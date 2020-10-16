import 'package:rotary_net/BLoCs/bloc.dart';
import 'package:rotary_net/objects/message_object.dart';
import 'package:rotary_net/objects/message_queue_object.dart';
import 'package:rotary_net/objects/message_with_description_object.dart';
import 'package:rotary_net/services/message_service.dart';
import 'dart:async';

class MessagesListBloc implements BloC {

  MessagesListBloc(){
    getMessagesListWithDescription();
  }

  final MessageService messageService = MessageService();

  // a getter of the Bloc List --> to be called from outside
  var _messagesListWithDescription = <MessageWithDescriptionObject>[];
  List<MessageWithDescriptionObject> get messagesListWithDescription => _messagesListWithDescription;

  // 1. private StreamController is declared that will manage the stream and sink for this BLoC.
  final _messagesWithDescriptionController = StreamController<List<MessageWithDescriptionObject>>.broadcast();

  // 2. exposes a public getter to the StreamController’s stream.
  Stream<List<MessageWithDescriptionObject>> get messagesWithDescriptionStream => _messagesWithDescriptionController.stream;

  // 3. represents the input for the BLoC
  void getMessagesListWithDescription() async {
    _messagesListWithDescription = await messageService.getMessagesListWithDescriptionUsingMessageQueueFromServer();
    _messagesWithDescriptionController.sink.add(_messagesListWithDescription);
  }

  Future<void> clearMessagesList() async {
    _messagesListWithDescription = <MessageWithDescriptionObject>[];
  }

  // 4. clean up method, the StreamController is closed when this object is deAllocated
  @override
  void dispose() {
    _messagesWithDescriptionController.close();
  }

  //#region CRUD: Message

  Future insertMessage(
      MessageWithDescriptionObject aMessageWithDescriptionObj) async {

    // InsertMessage ===>>> One Transaction: Insert to MessageTable AND to MessageQueueTable
    MessageObject _messageObj = await MessageObject.getMessageObjectFromMessageWithDescriptionObject(aMessageWithDescriptionObj);
    var dbResult = await messageService.insertMessageAndMessageQueueByHierarchyPermissionToDataBase(_messageObj, aMessageWithDescriptionObj);

    _messagesListWithDescription.add(aMessageWithDescriptionObj);
    _messagesListWithDescription.sort((a, b) => b.messageCreatedDateTime.compareTo(a.messageCreatedDateTime));
    _messagesWithDescriptionController.sink.add(_messagesListWithDescription);

    return dbResult;
  }

  Future<void> updateMessage(
      MessageWithDescriptionObject aOldMessageWithDescriptionObj,
      MessageWithDescriptionObject aNewMessageWithDescriptionObj) async {

    if (_messagesListWithDescription.contains(aOldMessageWithDescriptionObj)) {
      MessageObject _messageObj = await MessageObject.getMessageObjectFromMessageWithDescriptionObject(aNewMessageWithDescriptionObj);
      await messageService.updateMessageByMessageGuidIdToDataBase(_messageObj);

      _messagesListWithDescription.remove(aOldMessageWithDescriptionObj);
      _messagesListWithDescription.add(aNewMessageWithDescriptionObj);
      _messagesListWithDescription.sort((a, b) => b.messageCreatedDateTime.compareTo(a.messageCreatedDateTime));
      _messagesWithDescriptionController.sink.add(_messagesListWithDescription);
    }
  }

  Future<void> deleteMessageByMessageGuidId(
      MessageWithDescriptionObject aMessageWithDescriptionObj) async {

    if (_messagesListWithDescription.contains(aMessageWithDescriptionObj)) {
      MessageObject _messageObj = await MessageObject.getMessageObjectFromMessageWithDescriptionObject(aMessageWithDescriptionObj);
      await messageService.deleteMessageByMessageGuidIdFromDataBase(_messageObj);

      _messagesListWithDescription.remove(aMessageWithDescriptionObj);
      _messagesWithDescriptionController.sink.add(_messagesListWithDescription);
    }
  }
  //#endregion

  //#region CRUD: Message Queue

  Future insertMessageQueue(
      MessageWithDescriptionObject aMessageWithDescriptionObj,
      MessageQueueObject aMessageQueueObj) async {

    var dbResult = await messageService.insertMessageQueueToDataBase(aMessageQueueObj);

    _messagesListWithDescription.add(aMessageWithDescriptionObj);
    _messagesListWithDescription.sort((a, b) => b.messageCreatedDateTime.compareTo(a.messageCreatedDateTime));
    _messagesWithDescriptionController.sink.add(_messagesListWithDescription);

    return dbResult;
  }

  Future<void> deleteMessageQueueByMessageAndPersonGuidIdFromDataBase(
      MessageWithDescriptionObject aMessageWithDescriptionObj) async {

    if (_messagesListWithDescription.contains(aMessageWithDescriptionObj)) {
      MessageObject _messageObj = await MessageObject.getMessageObjectFromMessageWithDescriptionObject(aMessageWithDescriptionObj);
      await messageService.deleteMessageQueueByMessageAndPersonGuidIdFromDataBase(_messageObj, aMessageWithDescriptionObj);

      _messagesListWithDescription.remove(aMessageWithDescriptionObj);
      _messagesWithDescriptionController.sink.add(_messagesListWithDescription);
    }
  }
  //#endregion
}

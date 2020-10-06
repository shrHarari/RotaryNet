import 'package:rotary_net/BLoCs/bloc.dart';
import 'package:rotary_net/objects/message_object.dart';
import 'package:rotary_net/objects/message_with_description_object.dart';
import 'package:rotary_net/services/message_service.dart';
import 'dart:async';

class MessagesListBloc implements BloC {

  MessagesListBloc(){
    getMessagesList();
    getMessagesListWithDescription();
  }

  final MessageService messageService = MessageService();

  // a getter of the Bloc List --> to be called from outside
  var _messagesList = <MessageObject>[];
  List<MessageObject> get messagesList => _messagesList;

  var _messagesListWithDescription = <MessageWithDescriptionObject>[];
  List<MessageWithDescriptionObject> get messagesListWithDescription => _messagesListWithDescription;

  // 1. private StreamController is declared that will manage the stream and sink for this BLoC.
  final _messagesController = StreamController<List<MessageObject>>.broadcast();
  final _messagesWithDescriptionController = StreamController<List<MessageWithDescriptionObject>>.broadcast();

  // 2. exposes a public getter to the StreamController’s stream.
  Stream<List<MessageObject>> get messagesStream => _messagesController.stream;
  Stream<List<MessageWithDescriptionObject>> get messagesWithDescriptionStream => _messagesWithDescriptionController.stream;

  // 3. represents the input for the BLoC
  void getMessagesList() async {
    _messagesList = await messageService.getMessagesListFromServer();
    _messagesController.sink.add(_messagesList);
  }

  void getMessagesListWithDescription() async {
    _messagesListWithDescription = await messageService.getMessagesListWithDescriptionFromServer();
    _messagesWithDescriptionController.sink.add(_messagesListWithDescription);
  }

  Future<void> clearMessagesList() async {
    _messagesList = <MessageObject>[];
    _messagesListWithDescription = <MessageWithDescriptionObject>[];
  }

  // 4. clean up method, the StreamController is closed when this object is deAllocated
  @override
  void dispose() {
    _messagesController.close();
    _messagesWithDescriptionController.close();
  }

  //#region CRUD: Message

  Future<void> insertMessage(
      MessageObject aMessageObj,
      MessageWithDescriptionObject aMessageWithDescriptionObj) async {

    await messageService.insertMessageToDataBase(aMessageObj);

    _messagesList.add(aMessageObj);
    _messagesList.sort((a, b) => b.messageCreatedDateTime.compareTo(a.messageCreatedDateTime));
    _messagesController.sink.add(_messagesList);

    _messagesListWithDescription.add(aMessageWithDescriptionObj);
    _messagesListWithDescription.sort((a, b) => b.messageCreatedDateTime.compareTo(a.messageCreatedDateTime));
    _messagesWithDescriptionController.sink.add(_messagesListWithDescription);
  }

  Future<void> updateMessage(
      MessageObject aOldMessageObj,
      MessageObject aNewMessageObj,
      MessageWithDescriptionObject aOldMessageWithDescriptionObj,
      MessageWithDescriptionObject aNewMessageWithDescriptionObj) async {

    if (_messagesListWithDescription.contains(aOldMessageWithDescriptionObj)) {
      await messageService.updateMessageByMessageGuidIdToDataBase(aNewMessageObj);

      _messagesList.remove(aOldMessageObj);
      _messagesList.add(aNewMessageObj);
      _messagesList.sort((a, b) => b.messageCreatedDateTime.compareTo(a.messageCreatedDateTime));
      _messagesController.sink.add(_messagesList);

      _messagesListWithDescription.remove(aOldMessageWithDescriptionObj);
      _messagesListWithDescription.add(aNewMessageWithDescriptionObj);
      _messagesListWithDescription.sort((a, b) => b.messageCreatedDateTime.compareTo(a.messageCreatedDateTime));
      _messagesWithDescriptionController.sink.add(_messagesListWithDescription);
    }
  }

  Future<void> deleteMessageByMessageGuidId(
      MessageObject aMessageObj,
      MessageWithDescriptionObject aMessageWithDescriptionObj) async {

    if (_messagesListWithDescription.contains(aMessageWithDescriptionObj)) {
      await messageService.deleteMessageByMessageGuidIdFromDataBase(aMessageObj);

      _messagesList.remove(aMessageObj);
      _messagesController.sink.add(_messagesList);

      _messagesListWithDescription.remove(aMessageWithDescriptionObj);
      _messagesWithDescriptionController.sink.add(_messagesListWithDescription);
    }
  }
  //#endregion
}

import 'package:rotary_net/BLoCs/bloc.dart';
import 'package:rotary_net/objects/message_object.dart';
import 'package:rotary_net/objects/message_populated_object.dart';
import 'package:rotary_net/services/message_service.dart';
import 'dart:async';

class MessagesListBloc implements BloC {
  final String argPersonCardId;

  MessagesListBloc(this.argPersonCardId){
    getMessagesListPopulated(argPersonCardId);
  }

  final MessageService messageService = MessageService();

  // a getter of the Bloc List --> to be called from outside
  var _messagesListPopulated = <MessagePopulatedObject>[];
  List<MessagePopulatedObject> get messagesListPopulated => _messagesListPopulated;

  // 1. private StreamController is declared that will manage the stream and sink for this BLoC.
  final _messagesPopulatedController = StreamController<List<MessagePopulatedObject>>.broadcast();

  // 2. exposes a public getter to the StreamController’s stream.
  Stream<List<MessagePopulatedObject>> get messagesPopulatedStream => _messagesPopulatedController.stream;

  // 3. represents the input for the BLoC
  void getMessagesListPopulated(String aPersonCardId) async {
    _messagesListPopulated = await messageService.getMessagesListPopulatedByPersonCardId(argPersonCardId);
    _messagesListPopulated.sort((a, b) => b.messageCreatedDateTime.compareTo(a.messageCreatedDateTime));
    _messagesPopulatedController.sink.add(_messagesListPopulated);
  }

  Future<void> clearMessagesList() async {
    _messagesListPopulated = <MessagePopulatedObject>[];
  }

  // 4. clean up method, the StreamController is closed when this object is deAllocated
  @override
  void dispose() {
    _messagesPopulatedController.close();
  }

  //#region CRUD: Message

  Future insertMessage(MessagePopulatedObject aMessagePopulatedObj) async {

    // InsertMessage ===>>> One Transaction: Insert to MessageTable AND to MessageQueueTable
    MessageObject _messageObj = await MessageObject.getMessageObjectFromMessagePopulatedObject(aMessagePopulatedObj);
    var dbResult = await messageService.insertMessage(_messageObj);

    _messagesListPopulated.add(aMessagePopulatedObj);
    _messagesListPopulated.sort((a, b) => b.messageCreatedDateTime.compareTo(a.messageCreatedDateTime));
    _messagesPopulatedController.sink.add(_messagesListPopulated);

    return dbResult;
  }

  Future<void> updateMessage(
      MessagePopulatedObject aOldMessagePopulatedObj,
      MessagePopulatedObject aNewMessagePopulatedObj) async {

    if (_messagesListPopulated.contains(aOldMessagePopulatedObj)) {
      MessageObject _messageObj = await MessageObject.getMessageObjectFromMessagePopulatedObject(aNewMessagePopulatedObj);
      await messageService.updateMessageById(_messageObj);

      _messagesListPopulated.remove(aOldMessagePopulatedObj);
      _messagesListPopulated.add(aNewMessagePopulatedObj);
      _messagesListPopulated.sort((a, b) => b.messageCreatedDateTime.compareTo(a.messageCreatedDateTime));
      _messagesPopulatedController.sink.add(_messagesListPopulated);
    }
  }

  Future<void> deleteMessageById(MessagePopulatedObject aMessagePopulatedObj) async {

    if (_messagesListPopulated.contains(aMessagePopulatedObj)) {
      MessageObject _messageObj = await MessageObject.getMessageObjectFromMessagePopulatedObject(aMessagePopulatedObj);
      await messageService.deleteMessageById(_messageObj);

      _messagesListPopulated.remove(aMessagePopulatedObj);
      _messagesListPopulated.sort((a, b) => b.messageCreatedDateTime.compareTo(a.messageCreatedDateTime));
      _messagesPopulatedController.sink.add(_messagesListPopulated);
    }
  }

  Future<void> removeMessageFromPersonCardMessageQueue(MessagePopulatedObject aMessagePopulatedObj, String aPersonCardId) async {

    if (_messagesListPopulated.contains(aMessagePopulatedObj)) {
      MessageObject _messageObj = await MessageObject.getMessageObjectFromMessagePopulatedObject(aMessagePopulatedObj);
      await messageService.removeMessageFromPersonCardMessageQueue(_messageObj, aPersonCardId);

      _messagesListPopulated.remove(aMessagePopulatedObj);
      _messagesListPopulated.sort((a, b) => b.messageCreatedDateTime.compareTo(a.messageCreatedDateTime));
      _messagesPopulatedController.sink.add(_messagesListPopulated);
    }
  }

  Future<void> addMessageBackToPersonCardMessageQueue(MessagePopulatedObject aMessagePopulatedObj, String aPersonCardId) async {

    MessageObject _messageObj = await MessageObject.getMessageObjectFromMessagePopulatedObject(aMessagePopulatedObj);
    await messageService.addMessageBackToPersonCardMessageQueue(_messageObj, aPersonCardId);

    _messagesListPopulated.add(aMessagePopulatedObj);
    _messagesListPopulated.sort((a, b) => b.messageCreatedDateTime.compareTo(a.messageCreatedDateTime));
    _messagesPopulatedController.sink.add(_messagesListPopulated);
  }
  //#endregion
}

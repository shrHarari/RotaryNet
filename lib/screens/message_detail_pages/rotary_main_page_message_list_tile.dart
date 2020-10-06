import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:rotary_net/objects/message_with_description_object.dart';
import 'package:rotary_net/screens/message_detail_pages/message_detail_page_screen.dart';
import 'package:rotary_net/screens/message_detail_pages/message_detail_page_widgets.dart';
import 'package:rotary_net/shared/bubble_box_rotary_message.dart';
import 'package:intl/date_symbol_data_local.dart' as SymbolData;
import 'package:intl/intl.dart' as Intl;
import 'package:rotary_net/widgets/message_paragraph_painter.dart';

class RotaryMainPageMessageListTile extends StatelessWidget {
  final MessageWithDescriptionObject argMessageWithDescriptionObject;

  const RotaryMainPageMessageListTile({Key key, this.argMessageWithDescriptionObject}) : super(key: key);

  static const MAX_LINES = 4;
  static const MAX_LENGTH_DISPLAY_LAST_LINE = 15;
  static const MAX_LENGTH_LINE = 30;

  //#region Get Text styles
  static const TextStyle messageTextSpanStyleBold = TextStyle(
    fontFamily: 'Heebo-Light',
    fontSize: 18.0,
    height: 1.5,
    color: Colors.black,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle messageTextSpanStyle = TextStyle(
      fontFamily: 'Heebo-Light',
      fontSize: 17.0,
      height: 1.5,
      color: Colors.black87
  );
  //#endregion

  //#region Get Composer Name
  RichText getComposerName() {
    return RichText(
      textDirection: TextDirection.rtl,
      text: TextSpan(
        text: '[${argMessageWithDescriptionObject.composerFirstName} ${argMessageWithDescriptionObject.composerLastName}]: ',
        style: messageTextSpanStyle,
      ),
    );
  }
  //#endregion

  //#region Get Hebrew Message Created DateTime
  RichText getHebrewMessageCreatedDateTime() {
    SymbolData.initializeDateFormatting("he", null);
    var formatterStartDate = Intl.DateFormat.yMMMMEEEEd('he');
    String hebrewMessageCreatedDateTime = formatterStartDate.format(argMessageWithDescriptionObject.messageCreatedDateTime);

    return RichText(
      textDirection: TextDirection.rtl,
      text: TextSpan(
        children: [
          TextSpan(
            text: '\n[תאריך]: ',
            style: messageTextSpanStyle,
          ),
          TextSpan(
            text: hebrewMessageCreatedDateTime,
            style: messageTextSpanStyle,
          ),
        ],
      ),
    );
  }
  //#endregion

  //#region Get Message Paragraph Layout
  Widget getMessageParagraphLayout(String aText, TextStyle aTextStyle) {
    Container returnWidget;

    return LayoutBuilder(
        builder: (context, size) {
          final span = TextSpan(text: aText, style: aTextStyle);
          final textPainter = TextPainter(text: span, maxLines: MAX_LINES, textDirection: TextDirection.rtl);
          textPainter.layout(maxWidth: size.maxWidth, minWidth: 0);

          List<LineMetrics> lines = textPainter.computeLineMetrics();
          int numberOfLines = lines.length;

          if (numberOfLines > MAX_LINES)
          {
            returnWidget = Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints.expand(height: 160),
                      child: CustomPaint(
                        painter: MessageParagraphPainter(aText, aTextStyle, MAX_LINES-1, numberOfLines, TextDirection.rtl, Colors.white),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 80.0, right: 20.0),
                    child: RichText(
                      textDirection: TextDirection.rtl,

                      text: TextSpan(
                        text: '< קרא עוד ... >',
                        style: messageTextSpanStyle,
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            returnWidget = Container(
              child: ConstrainedBox(
                constraints: const BoxConstraints.expand(height: 160),
                child: Container(
                  child: CustomPaint(
                    painter: MessageParagraphPainter(aText, aTextStyle, MAX_LINES, numberOfLines, TextDirection.rtl, Colors.white),
                  ),
                ),
              ),
            );
          }
          return returnWidget;
        }
    );
  }
  //#endregion

  //#region Get Message Content
  Widget getMessageContent(String aText, TextStyle aTextStyle) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10.0, right: 10.0),
            child: getComposerName(),
          ),

          Flexible(
            // fit: FlexFit.loose,
            child: getMessageParagraphLayout(aText, aTextStyle)
          ),

          Padding(
            padding: const EdgeInsets.only(bottom: 10.0, right: 10.0),
            child: getHebrewMessageCreatedDateTime(),
          )
        ],
      ),
    );
  }
  //#endregion

  //#region Open Message Detail Screen
  openMessageDetailScreen(BuildContext context) async {

    Widget hebrewMessageCreatedTimeLabel = await MessageDetailWidgets.buildMessageCreatedTimeLabel(argMessageWithDescriptionObject.messageCreatedDateTime);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MessageDetailPageScreen(
          argMessageWithDescriptionObject: argMessageWithDescriptionObject,
          argHebrewMessageCreatedTimeLabel: hebrewMessageCreatedTimeLabel,
        ),
      ),
    );
  }
  //#endregion

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, top: 15.0, right: 15.0, bottom:10.0),
      child: GestureDetector(
        child: BubblesBoxRotaryMessage(
          argContent: getMessageContent(argMessageWithDescriptionObject.messageText, messageTextSpanStyleBold),
          argBubbleBackgroundColor: Colors.white,
          argBubbleBorderColor: Colors.amber,
        ),
        onTap: ()
        {
          // Hide Keyboard
          FocusScope.of(context).requestFocus(FocusNode());
          openMessageDetailScreen(context);
        },
      ),
    );
  }
}

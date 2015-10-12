import QtQuick 2.0
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.1
import QtQuick.Dialogs 1.2

import "."

AbstractEditor {
    id: root
    anchors.fill: parent

    Text {
        Layout.fillWidth: true
        text: "Key:"
    }

    TextField {
        id: keyText

        Layout.fillWidth: true
        Layout.minimumHeight: 28

        text: ""
        enabled: originalValue != "" || root.state !== "edit"
        property var originalValue: ""

        style: TextFieldStyle {
                background: Rectangle {
                radius: 1
                implicitWidth: 100
                implicitHeight: 24
                border.color: "#BFBFBF"
                border.width: 1
                color: (textArea.text=="" && textArea.enabled
                                      && textArea.readOnly == false) ? "lightyellow" : "white"
                }
         }
    }


    MultilineEditor {
        id: textArea
        Layout.fillWidth: true
        Layout.fillHeight: true
        text: ""
        enabled: keyText.originalValue != "" || root.state !== "edit"
        property var originalValue: ""
        showFormatters: root.state != "new"

        style: TextAreaStyle {
            backgroundColor: (textArea.text=="" && textArea.enabled
                              && textArea.readOnly == false) ? "lightyellow" : "white"
        }
    }

    function setValue(rowValue) {
        if (!rowValue)
            return       

        keyText.originalValue = rowValue['key']
        keyText.text = rowValue['key']
        textArea.originalValue = rowValue['value']
        textArea.setValue(rowValue['value'])
    }

    function isValueChanged() {
        return textArea.originalValue != textArea.getText()
                || keyText.originalValue != keyText.text
    }

    function resetAndDisableEditor() {
        textArea.text = ""
        textArea.originalValue = ""
        keyText.originalValue = ""
        keyText.text = ""
    }

    function getValue() {
        return {"value": textArea.getText(), "key": keyText.text}
    }

    function isValueValid() {
        var value = getValue()

        return value && value['key'] && value['key'].length > 0
    }

    function markInvalidFields() {
        keyText.textColor = "black"
        textArea.textColor = "black"
        // Fixme
    }

    function reset() {
        textArea.originalValue = ""
        textArea.text = ""
        keyText.originalValue = ""
        keyText.text = ""
    }
}

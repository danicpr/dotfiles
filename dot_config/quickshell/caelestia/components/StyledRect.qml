import QtQuick

Rectangle {
    id: root

    property bool liquidGlass: true
    readonly property bool showGlassBorder: liquidGlass
        && radius >= 8
        && color.a > 0.05
        && color.a < 0.95
        && width >= 40
        && height >= 28

    color: "transparent"
    border.width: showGlassBorder ? 1 : 0
    border.color: showGlassBorder ? Qt.rgba(1, 1, 1, 0.22) : "transparent"

    Behavior on color {
        CAnim {}
    }
}

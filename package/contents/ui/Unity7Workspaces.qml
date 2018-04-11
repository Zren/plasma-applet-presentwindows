import QtQuick 2.0
import QtQuick.Layouts 1.1
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore

import org.kde.plasma.private.pager 2.0

import "lib"

Item {
	id: panelItem

	// Heavy use of the default Pager's code.
	// See: /usr/share/plasma/plasmoid/org.kde.plasma.pager/contents/ui/main.qml
	PagerModel {
		id: pagerModel

		enabled: true
		showOnlyCurrentScreen: true //plasmoid.configuration.showOnlyCurrentScreen
		screenGeometry: plasmoid.screenGeometry
		pagerType: PagerModel.VirtualDesktops
	}

	PlasmaCore.FrameSvgItem {
		id: taskFrame
		anchors.fill: parent
		imagePath: "widgets/tasks"
		prefix: "normal"
	}

	Grid {
		id: pagerItemGrid
		anchors.fill: parent

		anchors.leftMargin: taskFrame.margins.left
		anchors.rightMargin: taskFrame.margins.right
		anchors.topMargin: taskFrame.margins.top
		anchors.bottomMargin: taskFrame.margins.bottom

		// spacing: units.devicePixelRatio
		rows: effectiveRows
		columns: effectiveColumns

		readonly property int effectiveRows: {
			var rows = 1
			var columns = Math.floor(pagerModel.count / pagerModel.layoutRows)

			if (pagerModel.count % pagerModel.layoutRows > 0) {
				columns += 1
			}

			rows = Math.floor(pagerModel.count / columns)

			if (pagerModel.count % columns > 0) {
				rows += 1
			}

			return rows
		}

		readonly property int effectiveColumns: {
			if (!pagerModel.count) {
				return 1
			}

			return Math.ceil(pagerModel.count / effectiveRows)
		}


		readonly property real pagerItemSizeRatio: pagerModel.pagerItemSize.width / pagerModel.pagerItemSize.height
		// readonly property real widthScaleFactor: columnWidth / pagerModel.pagerItemSize.width
		// readonly property real heightScaleFactor: rowHeight / pagerModel.pagerItemSize.height

		property int rowHeight: Math.floor(height / effectiveRows)
		property int columnWidth: Math.floor(width / effectiveColumns)

		property color seperatorColor: "#44FFFFFF"
		property color activeDesktopFillColor: "#44442027"

		Repeater {
			id: repeater
			model: pagerModel

			Item {
				id: desktop
				property int desktopIndex: index
				property int desktopColumn: index % pagerItemGrid.columns
				property int desktopRow: Math.floor(index / pagerItemGrid.columns)
				property bool isActiveDesktop: (index == pagerModel.currentPage)

				width: pagerItemGrid.columnWidth
				height: pagerItemGrid.rowHeight


				Rectangle {
					anchors.fill: parent
					color: desktop.isActiveDesktop ? pagerItemGrid.activeDesktopFillColor : "transparent"
				}

				Rectangle {
					id: verticalSeperator
					visible: desktop.desktopColumn < pagerItemGrid.columns-1 // Don't show on last column
					anchors.top: parent.top
					anchors.right: parent.right
					anchors.bottom: parent.bottom
					width: Math.round(1 * units.devicePixelRatio)
					color: pagerItemGrid.seperatorColor
				}
				Rectangle {
					id: horizontalSeperator
					visible: desktop.desktopRow < pagerItemGrid.rows-1 // Don't show on last row
					anchors.left: parent.left
					anchors.bottom: parent.bottom
					anchors.right: parent.right
					height: Math.round(1 * units.devicePixelRatio)
					color: pagerItemGrid.seperatorColor
				}

				AppletIcon {
					anchors.fill: parent
					source: desktop.isActiveDesktop ? "unity7selectedworkspace" : ""
				}
			}
			
		}
	}
}

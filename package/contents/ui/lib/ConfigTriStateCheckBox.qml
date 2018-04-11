import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

import ".."

CheckBox {
	id: configTriStateCheckBox

	property string configKey: ''
	partiallyCheckedEnabled: true
	checkedState: plasmoid.configuration[configKey]
	onClicked: plasmoid.configuration[configKey] = (plasmoid.configuration[configKey] + 1) % 3
}

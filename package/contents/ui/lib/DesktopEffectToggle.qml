import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0

ConfigSection {
	label: "Desktop Effect Toggle"
	property string effectId
	property bool loaded: false
	property bool effectEnabled: true

	ExecUtil {
		id: executable
		property string readStateCommand: 'qdbus org.kde.KWin /Effects isEffectLoaded ' + effectId
		property string toggleStateCommand: 'qdbus org.kde.KWin /Effects toggleEffect ' + effectId
		property string saveSateCommand: 'kwriteconfig5 --file ~/.config/kwinrc --group Plugins --key ' + effectId + 'Enabled' // saveSateCommand + ' ' + value
		property bool saveOnRead: false

		function readState() {
			executable.exec(readStateCommand)
		}
		function toggleState() {
			executable.exec(toggleStateCommand)
		}
		function saveState() {
			var isCurrentlyEnabled = toggleButton.checked
			executable.exec(saveSateCommand + ' ' + (isCurrentlyEnabled ? 'true' : 'false'))
		}
		Component.onCompleted: {
			readState()
		}

		onExited: {
			if (command == readStateCommand) {
				var value = executable.trimOutput(stdout)
				value = value === 'true' // cast to boolean
				effectEnabled = value
				toggleButton.checked = value
				loaded = true
				if (saveOnRead) {
					saveOnRead = false
					saveState()
				}
			} else if (command == toggleStateCommand) {
				saveOnRead = true
				readState()
			} else if (startsWith(command, saveSateCommand)) {

			}
		}

		function startsWith(a, b) {
			if (b.length <= a.length) {
				return a.substr(0, b.length) == b
			} else {
				return false
			}
		}
	}

	CheckBox {
		id: toggleButton
		text: i18n("Enabled")
		onClicked: {
			executable.toggleState()
		}
	}
}

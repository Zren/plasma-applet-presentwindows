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

		// For some reason, the toggleEffect qdbus function does not save to kwinrc.
		// So we need to manually write the new state to it, so that the next time
		// kwin is launched (next reboot), the desktop effect is still enabled/disabled.
		property string saveStateCommand: 'kwriteconfig5 --file ~/.config/kwinrc --group Plugins --key ' + effectId + 'Enabled' // saveStateCommand + ' ' + value
		property bool saveOnRead: false

		function readState() {
			executable.exec(readStateCommand)
		}
		function toggleState() {
			executable.exec(toggleStateCommand)
		}
		function saveState() {
			var isCurrentlyEnabled = toggleButton.checked
			executable.exec(saveStateCommand + ' ' + (isCurrentlyEnabled ? 'true' : 'false'))
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
			} else if (startsWith(command, saveStateCommand)) {

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

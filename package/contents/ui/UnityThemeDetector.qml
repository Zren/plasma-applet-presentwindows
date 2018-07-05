import QtQuick 2.0

QtObject {
	readonly property bool shouldUseUnityTheme: {
		return theme.themeName == 'UnityAmbiance'
	}
	readonly property int configState: plasmoid.configuration.useUnityTheme
	readonly property bool useUnityTheme: {
		// console.log('useUnityTheme', configState, shouldUseUnityTheme)
		if (configState == 0) { // checked
			return true
		} else if (configState == 1) { // partically checked
			return shouldUseUnityTheme
		} else { // configState == 2 (not checked)
			return false
		}
	}
}

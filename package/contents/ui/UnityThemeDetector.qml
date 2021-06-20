import QtQuick 2.0
import org.kde.plasma.core 2.0 as PlasmaCore

QtObject {
	readonly property bool shouldUseUnityTheme: {
		return PlasmaCore.Theme.themeName == 'UnityAmbiance'
	}
	readonly property int configState: plasmoid.configuration.useUnityTheme
	readonly property bool useUnityTheme: {
		// console.log('useUnityTheme', configState, shouldUseUnityTheme)
		if (configState == 0) { // Never
			return false
		} else if (configState == 1) { // DependsOnPlasmaStyle
			return shouldUseUnityTheme
		} else { // configState == 2 Always
			return true
		}
	}
}

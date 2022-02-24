import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Controls 2.5 as QQC2
import QtQuick.Layouts 1.0

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.kirigami 2.5 as Kirigami

import ".."
import "../lib"
import "../libconfig" as LibConfig


Kirigami.FormLayout {


	//-------------------------------------------------------
	LibConfig.Heading {
		text: i18n("Behavior")
		useThickTopMargin: false
	}
	DesktopEffectToggle {
		id: overviewToggle
		effectId: 'overview'
	}
	DesktopEffectToggle {
		id: presentWindowsToggle
		effectId: 'presentwindows'
	}
	DesktopEffectToggle {
		id: showDesktopGridToggle
		effectId: 'desktopgrid'
	}
	LibConfig.RadioButtonGroup {
		id: clickCommandGroup
		configKey: 'clickCommand'
		Kirigami.FormData.label: i18n("Click")
		Kirigami.FormData.buddyFor: null // Note: it attaches to the first CheckBox in the Repeater since it loads first.
		model: []

		//---
		Repeater {
			model: [
				{ value: 'Overview', text: i18nd("kwin_effects", "Toggle Overview"), effectToggle: overviewToggle },
				{ value: 'ExposeAll', text: i18nd("kwin_effects", "Toggle Present Windows (All desktops)"), effectToggle: presentWindowsToggle },
				{ value: 'Expose', text: i18nd("kwin_effects", "Toggle Present Windows (Current desktop)"), effectToggle: presentWindowsToggle },
				{ value: 'ExposeClass', text: i18nd("kwin_effects", "Toggle Present Windows (Window class)"), effectToggle: presentWindowsToggle },
				{ value: 'ShowDesktopGrid', text: i18nd("kwin_effects", "Toggle Desktop Grid"), effectToggle: showDesktopGridToggle },
			]
			RowLayout {
				QQC2.RadioButton {
					text: modelData.text
					enabled: modelData.effectToggle.loaded && modelData.effectToggle.effectEnabled
					QQC2.ButtonGroup.group: clickCommandGroup.group
					checked: modelData.value === plasmoid.configuration[clickCommandGroup.configKey]
					onClicked: {
						focus = true
						if (clickCommandGroup.configKey) {
							plasmoid.configuration[clickCommandGroup.configKey] = modelData.value
						}
					}
				}
				QQC2.Button {
					visible: modelData.effectToggle.loaded && !modelData.effectToggle.effectEnabled
					text: i18n("Enable Desktop Effect")
					onClicked: modelData.effectToggle.toggle()
				}
			}
		}

		//---
		KPackageModel {
			id: kwinScriptModel
			packageType: 'KWin/Script'
		}
		Repeater {
			visible: kwinScriptModel.loaded
			model: [
				{
					pluginId: 'Parachute',
					url: 'https://store.kde.org/p/1370195/',
				},
			]
			RowLayout {
				QQC2.RadioButton {
					text: modelData.pluginId
					enabled: kwinScriptModel.contains(modelData.pluginId)
					QQC2.ButtonGroup.group: clickCommandGroup.group
					checked: modelData.value === plasmoid.configuration[clickCommandGroup.configKey]
					onClicked: {
						focus = true
						if (clickCommandGroup.configKey) {
							plasmoid.configuration[clickCommandGroup.configKey] = modelData.value
						}
					}
				}
				LinkText {
					text: '<a href="' + modelData.url + '">' + modelData.url + '</a>'
				}
			}
		}
	}

	//-------------------------------------------------------
	LibConfig.Heading {
		text: i18n("Appearance")
	}

	LibConfig.AppletIconField {
		id: iconField
		configKey: 'icon'
		Kirigami.FormData.label: i18n("Icon")
		defaultValue: 'presentwindows-24px'
		presetValues: [
			'presentwindows-24px',
			'presentwindows-22px',
			'presentwindows-16px',
			'edit-group',
			'window',
			'view-app-grid-symbolic',
			'homerun',
		]
	}



	//-------------------------------------------------------
	LibConfig.Heading {
		text: i18n("Unity Pager Theme")
	}

	LibConfig.RadioButtonGroup {
		configKey: 'useUnityTheme'
		Kirigami.FormData.label: i18n("Use Unity 7 Theme")
		model: [
			{ value: 0, text: i18n("Never") },
			{ value: 1, text: i18n("When Plasma Style is Unity Ambiance") },
			{ value: 2, text: i18n("Always") },
		]
	}

	ConfigLabel {
		text: i18n("Should we use a Virtual Desktop indicator similar to Unity 7? This feature is enabled for the <a href=\"https://store.kde.org/p/998797/\">Unity Ambiance</a> Plasma Style by default.")
	}

	Label {
		text: i18n("<b>Current Plasma Style:</b> %1", PlasmaCore.Theme.themeName)
	}

}

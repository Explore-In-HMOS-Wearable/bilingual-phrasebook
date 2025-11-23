import { AbilityConstant, ConfigurationConstant, UIAbility, Want } from '@kit.AbilityKit';
import { window } from '@kit.ArkUI';
import Logger from '../utils/Logger';

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET);
    Logger.info('Ability onCreate')
  }

  onDestroy(): void {
    Logger.info('Ability onDestroy')
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    Logger.info('Ability onWindowStageCreate')

    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        Logger.info(`Failed to load the content. Cause: ${JSON.stringify(err)}`)
        return;
      }
      Logger.info('Succeeded in loading the content.')
    });
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    Logger.info('Ability onWindowStageDestroy')
  }

  onForeground(): void {
    // Ability has brought to foreground
    Logger.info('Ability onForeground')
  }

  onBackground(): void {
    // Ability has back to background
    Logger.info('Ability onBackground')
  }
}
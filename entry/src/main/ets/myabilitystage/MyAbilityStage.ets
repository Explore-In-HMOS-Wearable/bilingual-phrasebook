import { AbilityStage, Configuration } from '@kit.AbilityKit';
import { MainRegistry } from '../di/MainRegistry';
import { ServiceRegistry } from '../registry/ServiceRegistry';
import LocaleManager from '../utils/LocaleManager';
import Logger from '../utils/Logger';

export default class MyAbilityStage extends AbilityStage {
  private registry: ServiceRegistry | null = null;

  onCreate(): void {
    this.registry = MainRegistry.build(this.context.getApplicationContext())
  }

  onDestroy(): void {
    this.registry?.destroy()
  }

  onConfigurationUpdate(newConfig: Configuration): void {
    Logger.info(`MyAbilityStage: onConfigurationUpdate called with new config language: ${newConfig.language}`)
    if (newConfig.language && newConfig.language.length > 0) {
      try {
        const localeManager = this.registry?.get<LocaleManager>('LocaleManager::default');
        localeManager?.onSystemLocaleChanged(newConfig.language).catch((err: Error) => {
          Logger.error(`MyAbilityStage: onSystemLocaleChanged failed: ${err.message}`)
        });
      } catch (error) {
        Logger.error(`MyAbilityStage: failed to get LocaleManager: ${(error as Error).message}`)
      }
    }
  }
}
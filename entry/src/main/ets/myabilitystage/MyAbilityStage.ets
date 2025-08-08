import { AbilityStage, Configuration } from '@kit.AbilityKit';
import { MainRegistry } from '../di/MainRegistry';
import { ServiceRegistry } from '../registry/ServiceRegistry';
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
    Logger.info(`MyAbilityStage: onConfigurationUpdate called with new config language: '${newConfig.language}'`)
  }
}
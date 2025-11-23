import PreferencesManager from './PreferencesManager';
import { Context } from '@kit.AbilityKit';
import { preferences } from '@kit.ArkData';
import Logger from '../Logger';
import { BusinessError } from '@kit.BasicServicesKit';

export default class PreferencesManagerImpl extends PreferencesManager {
  private dataPreferences: preferences.Preferences | null = null;

  constructor(context: Context) {
    super();
    let options: preferences.Options = { name: 'user_preferences' };
    try {
      this.dataPreferences = preferences.getPreferencesSync(context, options);
      Logger.info('PreferencesManager Initialized')
    } catch (error) {
      Logger.error(`PreferencesManager error code: ${(error as BusinessError).code}, message: ${(error as BusinessError).message} `)
    }
  }

  onDispose(): void {
    this.dataPreferences = null
  }

  async setValue(key: string, value: string): Promise<void> {
    await this.dataPreferences?.put(key, value)
    await this.dataPreferences?.flush()
  }

  async getValue(key: string, defValue: string): Promise<string> {
    return (await this.dataPreferences?.get(key, defValue) as string) ?? defValue
  }
}
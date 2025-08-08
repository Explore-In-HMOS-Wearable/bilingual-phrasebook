import { AppLocale, appLocaleFromString } from '../model/AppLocale';
import Injectable from '../registry/Injectable';
import { i18n } from '@kit.LocalizationKit';
import { BusinessError } from '@kit.BasicServicesKit';
import Logger from './Logger';
import { Resolve } from '../registry/ServiceRegistry';
import PreferencesManager from './preferences/PreferencesManager';
import { PreferenceKeys } from './preferences/PreferenceKeys';


export default class LocaleManager implements Injectable {
  private locale: AppLocale = AppLocale.EN
  @Resolve(PreferencesManager)
  private pm?: PreferencesManager;

  private async getCachedLocale(): Promise<string> {
    return await this.pm?.getValue(PreferenceKeys.AppLocale, AppLocale.EN) ?? AppLocale.EN;
  }

  constructor() {
    const appLocaleStr = i18n.System.getAppPreferredLanguage();
    this.getCachedLocale().then(async (cachedLocale) => {
      if (appLocaleStr !== cachedLocale) {
        await this.updateAppLocale(appLocaleFromString(appLocaleStr))
      } else {
        this.setCurrentLocale(appLocaleFromString(appLocaleStr));
      }
    }).catch((err: BusinessError) => {
      Logger.error(`LocaleManager: updating app-local failed, error code: ${err.code}, message: ${err.message}.`)
    });
  }

  get appLocale(): AppLocale {
    return this.locale
  }

  toggleLocale() {
    switch (this.locale) {
      case AppLocale.EN:
        this.updateAppLocale(AppLocale.AR)
        break;
      case AppLocale.AR:
        this.updateAppLocale(AppLocale.EN)
        break;
    }
  }

  private async updateAppLocale(newLocale: AppLocale) {
    try {
      // Set the preferred language of the application to newLocale.
      i18n.System.setAppPreferredLanguage(newLocale);
      this.setCurrentLocale(newLocale);
      await this.setAppLocale(newLocale);
      Logger.info(`LocaleManager: locale changed to '${newLocale}'`)
    } catch (error) {
      let err: BusinessError = error as BusinessError;
      Logger.error(`LocaleManager: call System.setAppPreferredLanguage failed, error code: ${err.code}, message: ${err.message}.`)
    }
  }

  private setCurrentLocale(newLocale: AppLocale) {
    this.locale = newLocale;
  }

  private async setAppLocale(newLocale: AppLocale) {
    await this.pm?.setValue(PreferenceKeys.AppLocale, newLocale)
  }

  onDispose() {
  }
}

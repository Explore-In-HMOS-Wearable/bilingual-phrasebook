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
  private localeResolved: boolean = false;
  private isUpdating: boolean = false;
  private localeChangedListeners: ((locale: AppLocale) => void)[] = [];
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
        this.localeResolved = true;
        this.localeChangedListeners.forEach(cb => cb(this.locale));
      }
    }).catch((err: BusinessError) => {
      Logger.error(`LocaleManager: updating app-local failed, error code: ${err.code}, message: ${err.message}.`)
    });
  }

  /**
   * Registers a persistent observer that fires on every locale change, including initial async resolution.
   * Multiple listeners are supported; registering the same callback twice is a no-op.
   * If initialization has already completed, the callback is invoked immediately with the current locale.
   */
  setOnLocaleChanged(callback: (locale: AppLocale) => void): void {
    if (!this.localeChangedListeners.includes(callback)) {
      this.localeChangedListeners.push(callback);
    }
    if (this.localeResolved) {
      callback(this.locale);
    }
  }

  clearOnLocaleChanged(callback?: (locale: AppLocale) => void): void {
    if (callback) {
      const index = this.localeChangedListeners.indexOf(callback);
      if (index !== -1) {
        this.localeChangedListeners.splice(index, 1);
      }
    } else {
      this.localeChangedListeners = [];
    }
  }

  /**
   * Called when the system language changes externally (e.g. from watch settings).
   * Applies the new locale only if it differs from the current one.
   */
  async onSystemLocaleChanged(languageTag: string): Promise<void> {
    if (!languageTag || this.isUpdating) {
      return;
    }
    const newLocale = appLocaleFromString(languageTag);
    if (newLocale !== this.locale) {
      await this.updateAppLocale(newLocale);
    }
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
    this.isUpdating = true;
    try {
      // Set the preferred language of the application to newLocale.
      // NOTE: setAppPreferredLanguage triggers onConfigurationUpdate, which calls onSystemLocaleChanged.
      // The isUpdating guard above prevents the resulting re-entrant call from looping back here.
      i18n.System.setAppPreferredLanguage(newLocale);
      this.setCurrentLocale(newLocale);
      this.localeResolved = true;
      this.localeChangedListeners.forEach(cb => cb(newLocale));
      await this.setAppLocale(newLocale);
      Logger.info(`LocaleManager: locale changed to: ${newLocale}`)
    } catch (error) {
      let err: BusinessError = error as BusinessError;
      Logger.error(`LocaleManager: call System.setAppPreferredLanguage failed, error code: ${err.code}, message: ${err.message}.`)
    } finally {
      this.isUpdating = false;
    }
  }

  private setCurrentLocale(newLocale: AppLocale) {
    this.locale = newLocale;
  }

  private async setAppLocale(newLocale: AppLocale) {
    await this.pm?.setValue(PreferenceKeys.AppLocale, newLocale)
  }

  onDispose(): void {
    this.localeChangedListeners = [];
  }
}

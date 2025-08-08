export enum AppLocale {
  EN = 'en',
  AR = 'ar'
}

export function appLocaleFromString(localeStr: string): AppLocale {
  switch (localeStr.toLowerCase()) {
    case AppLocale.EN:
      return AppLocale.EN
    case AppLocale.AR:
      return AppLocale.AR
    default:
      return AppLocale.EN;
  }
}
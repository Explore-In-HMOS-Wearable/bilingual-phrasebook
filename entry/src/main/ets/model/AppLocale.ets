export enum AppLocale {
  EN = 'en',
  AR = 'ar'
}

export function appLocaleFromString(localeStr: string): AppLocale {
  const primaryTag = localeStr.trim().replace(/_/g, '-').split('-')[0].toLowerCase();
  switch (primaryTag) {
    case AppLocale.EN:
      return AppLocale.EN
    case AppLocale.AR:
      return AppLocale.AR
    default:
      return AppLocale.EN;
  }
}
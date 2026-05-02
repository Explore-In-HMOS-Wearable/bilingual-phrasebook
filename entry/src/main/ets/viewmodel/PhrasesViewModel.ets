import { PhrasesGroup, PHRASES_GROUPS } from '../model/PhraseModel'
import { Resolve } from '../registry/ServiceRegistry';
import LocaleManager from '../utils/LocaleManager';
import { AppLocale } from '../model/AppLocale';
import { PhrasesDataSource } from './PhrasesDataSource';

@Observed
export class PhrasesViewModel {
  @Resolve(LocaleManager)
  localManager?: LocaleManager;

  private readonly dataSource: PhrasesDataSource =
    new PhrasesDataSource(PHRASES_GROUPS, this.localManager?.appLocale ?? AppLocale.EN);

  public loadPhrases(): PhrasesGroup[] {
    return PHRASES_GROUPS;
  }

  public loadDataSource(): PhrasesDataSource {
    return this.dataSource;
  }

  public get appLocale(): AppLocale {
    return this.localManager?.appLocale ?? AppLocale.EN;
  }

  public toggleLocale() {
    this.localManager?.toggleLocale();
  }

  public setOnLocaleChanged(callback: (locale: AppLocale) => void): void {
    this.localManager?.setOnLocaleChanged((locale) => {
      this.dataSource.updateLocale(locale);
      callback(locale);
    });
  }

  public clearOnLocaleChanged(): void {
    this.localManager?.clearOnLocaleChanged();
  }
}

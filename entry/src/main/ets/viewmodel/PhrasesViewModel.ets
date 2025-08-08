import { PhraseModel, PHRASES_GROUPS } from '../model/PhraseModel'
import { Resolve } from '../registry/ServiceRegistry';
import LocaleManager from '../utils/LocaleManager';
import { PhrasesDataSource } from './PhrasesDataSource';

@Observed
export class PhrasesViewModel {
  @Resolve(LocaleManager)
  localManager?: LocaleManager;

  public loadPhrases(): PhraseModel[] {
    return PHRASES_GROUPS;
  }

  public loadDataSource(): PhrasesDataSource {
    return new PhrasesDataSource(PHRASES_GROUPS)
  }

  public get appLocale() {
    return this.localManager?.appLocale;
  }

  public toggleLocale() {
    this.localManager?.toggleLocale();
  }
}



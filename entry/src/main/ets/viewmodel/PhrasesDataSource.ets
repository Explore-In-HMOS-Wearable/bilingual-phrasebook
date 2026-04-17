import { PhrasesGroup } from '../model/PhraseModel';
import { AppLocale } from '../model/AppLocale';

export enum PhraseItemType { TITLE, PHRASE }

export interface PhraseItem {
  type: PhraseItemType;
  id: number;
  text: ResourceStr;
  primary?: string;
  secondary?: string;
}

export class PhrasesDataSource implements IDataSource {
  private flatList: PhraseItem[] = [];
  private listeners: DataChangeListener[] = [];
  private groups: PhrasesGroup[];

  constructor(groups: PhrasesGroup[], locale: AppLocale) {
    this.groups = groups;
    this.buildFlatList(locale);
  }

  public updateLocale(locale: AppLocale): void {
    this.buildFlatList(locale);
    this.listeners.forEach(l => l.onDataReloaded());
  }

  private buildFlatList(locale: AppLocale): void {
    this.flatList = [];
    let idCounter = 1;

    for (const group of this.groups) {
      this.flatList.push({
        type: PhraseItemType.TITLE,
        id: idCounter++,
        text: group.text
      });

      for (const phrase of group.phrases) {
        const primary = locale === AppLocale.EN ? phrase.en : phrase.ar;
        const secondary = locale === AppLocale.EN ? phrase.ar : phrase.en;
        this.flatList.push({
          type: PhraseItemType.PHRASE,
          id: idCounter++,
          text: primary,
          primary: primary,
          secondary: secondary
        });
      }
    }
  }

  public totalCount(): number {
    return this.flatList.length;
  }

  public getData(index: number): PhraseItem {
    return this.flatList[index];
  }

  registerDataChangeListener(listener: DataChangeListener): void {
    if (!this.listeners.includes(listener)) {
      this.listeners.push(listener);
    }
  }

  unregisterDataChangeListener(listener: DataChangeListener): void {
    const index = this.listeners.indexOf(listener);
    if (index !== -1) {
      this.listeners.splice(index, 1);
    }
  }
}

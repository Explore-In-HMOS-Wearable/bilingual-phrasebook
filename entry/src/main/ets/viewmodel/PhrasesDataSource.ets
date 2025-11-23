import { PhrasesGroup } from '../model/PhraseModel';

export enum PhraseItemType { TITLE, PHRASE }

export interface PhraseItem {
  type: PhraseItemType;
  id: number;
  text: ResourceStr;
}

export class PhrasesDataSource implements IDataSource {
  private flatList: PhraseItem[] = [];
  private listeners: DataChangeListener[] = [];

  constructor(groups: PhrasesGroup[]) {
    let idCounter = 1;

    for (const group of groups) {
      // Push group title
      this.flatList.push({
        type: PhraseItemType.TITLE,
        id: idCounter++,
        text: group.text
      });

      // Push each phrase
      for (const phrase of group.phrases) {
        this.flatList.push({
          type: PhraseItemType.PHRASE,
          id: idCounter++,
          text: phrase.text
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
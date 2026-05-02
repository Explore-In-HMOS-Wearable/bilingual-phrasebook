import {
  UIContext,
  ArcList,
  ArcListItem,
  ComponentContent,
  LengthMetrics,
  ArcButton,
  ArcButtonOptions,
  ColorMetrics,
  ArcButtonStyleMode
} from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { PhraseItem, PhraseItemType, PhrasesDataSource } from '../viewmodel/PhrasesDataSource';
import { PhrasesViewModel } from '../viewmodel/PhrasesViewModel';
import { PhraseCardComponent } from '../components/PhraseCardComponent';
import { SizeConstants } from '../constants/SizeConstants';
import { PhraseTitleComponent } from '../components/PhraseTitleComponent';
import { AppLocale } from '../model/AppLocale';
import Logger from '../utils/Logger';

interface HeaderParamsInterface {
  primaryLocale?: string;
  secondaryLocale?: string;
}

function otherLocale(locale: AppLocale): AppLocale {
  return locale === AppLocale.EN ? AppLocale.AR : AppLocale.EN;
}

@Builder
function buildHeader(params: HeaderParamsInterface) {
  Column() {
    Text($r('app.string.list_title'))
      .fontSize($r('app.float.list_title_size'))
      .fontWeight(700)
      .fontColor($r('app.color.deep_teal'))
    Row() {
      Text((params.primaryLocale ?? '').toUpperCase())
        .fontSize($r('app.float.list_header_size'))
        .fontWeight(700)
        .fontColor($r('app.color.deep_teal'))
      Text(' · ')
        .fontSize($r('app.float.list_header_size'))
        .fontColor($r('app.color.phrase_secondary_text_color'))
      Text((params.secondaryLocale ?? '').toUpperCase())
        .fontSize($r('app.float.list_header_size'))
        .fontColor($r('app.color.phrase_secondary_text_color'))
    }
  }
  .width(SizeConstants.FULL_WIDTH_PERCENT)
  .padding({ top: $r('app.float.margin_4'), bottom: $r('app.float.margin_8') })
  .alignItems(HorizontalAlign.Center)
  .justifyContent(FlexAlign.End)
}

@Entry
@Component
struct Index {
  private context?: UIContext = this.getContextSafely();
  private viewModel: PhrasesViewModel = new PhrasesViewModel();
  private dataSource: PhrasesDataSource = this.viewModel.loadDataSource();
  @State private currentLocale: AppLocale = this.viewModel.appLocale;
  private onLocaleToggled: () => void = () => {
    this.viewModel.toggleLocale();
  }
  private tabBar1?: ComponentContent<HeaderParamsInterface> = this.createHeaderContent();
  private bottomOptions = new ArcButtonOptions({
    label: $r('app.string.toggle_language'),
    styleMode: ArcButtonStyleMode.CUSTOM,
    fontSize: LengthMetrics.resource($r('app.float.list_header_size')),
    shadowEnabled: true,
    backgroundColor: ColorMetrics.resourceColor($r('app.color.deep_teal')),
    fontColor: ColorMetrics.resourceColor($r('app.color.card_text_color')),
    onClick: this.onLocaleToggled
  })

  private getContextSafely(): UIContext | undefined {
    try {
      return this.getUIContext();
    } catch (error) {
      let err: BusinessError = error as BusinessError;
      Logger.error(`Index: getUIContext failed, error code: ${err.code}, message: ${err.message}.`)
      return undefined;
    }
  }

  private createHeaderContent(): ComponentContent<HeaderParamsInterface> | undefined {
    if (!this.context) {
      return undefined;
    }

    try {
      return new ComponentContent<HeaderParamsInterface>(this.context, wrapBuilder(buildHeader), {
        primaryLocale: this.viewModel.appLocale,
        secondaryLocale: otherLocale(this.viewModel.appLocale)
      });
    } catch (error) {
      let err: BusinessError = error as BusinessError;
      Logger.error(`Index: header content initialization failed, error code: ${err.code}, message: ${err.message}.`)
      return undefined;
    }
  }

  private updateHeader(locale: AppLocale): void {
    if (!this.tabBar1) {
      return;
    }

    try {
      this.tabBar1.update({
        primaryLocale: locale,
        secondaryLocale: otherLocale(locale)
      });
    } catch (error) {
      let err: BusinessError = error as BusinessError;
      Logger.error(`Index: header content update failed, error code: ${err.code}, message: ${err.message}.`)
    }
  }

  aboutToAppear(): void {
    this.viewModel.setOnLocaleChanged((locale) => {
      this.currentLocale = locale;
      this.updateHeader(locale);
    });
  }

  aboutToDisappear(): void {
    this.viewModel.clearOnLocaleChanged();
  }

  build() {
    Stack() {
      if (this.tabBar1) {
        ArcList({ initialIndex: 0, header: this.tabBar1 }) {
          LazyForEach(this.dataSource, (item: PhraseItem, index: number) => {
            if (item.type === PhraseItemType.TITLE) {
              ArcListItem() {
                PhraseTitleComponent({
                  title: item.text
                }).margin({ top: index === 0 ? 0 : $r('app.float.margin_16') })
              }
            } else {
              ArcListItem() {
                PhraseCardComponent({
                  primary: item.primary ?? '',
                  secondary: item.secondary ?? ''
                })
              }
              .width(SizeConstants.WATCH_LIST_WIDTH_PX)
              .backgroundColor($r('app.color.card_background_color'))
              .borderRadius($r('app.float.margin_16'))
              .padding($r('app.float.margin_8'))
              .align(Alignment.Center)
              .margin({ bottom: index === this.dataSource.totalCount() - 1 ? $r('app.float.arc_button_clearance') : 0 })
            }
          }, (item: PhraseItem) => `${item.id}_${this.currentLocale}`)
        }
        .focusable(true)
        .focusOnTouch(true)
        .defaultFocus(true)
        .width(SizeConstants.FULL_SIZE_PX)
        .height(SizeConstants.FULL_SIZE_PX)
        .borderRadius(SizeConstants.FULL_SIZE_PX)
        .space(LengthMetrics.resource($r('app.float.margin_12')))
        .backgroundColor($r('app.color.app_background'))
      } else {
        ArcList({ initialIndex: 0 }) {
          LazyForEach(this.dataSource, (item: PhraseItem, index: number) => {
            if (item.type === PhraseItemType.TITLE) {
              ArcListItem() {
                PhraseTitleComponent({
                  title: item.text
                }).margin({ top: index === 0 ? 0 : $r('app.float.margin_16') })
              }
            } else {
              ArcListItem() {
                PhraseCardComponent({
                  primary: item.primary ?? '',
                  secondary: item.secondary ?? ''
                })
              }
              .width(SizeConstants.WATCH_LIST_WIDTH_PX)
              .backgroundColor($r('app.color.card_background_color'))
              .borderRadius($r('app.float.margin_16'))
              .padding($r('app.float.margin_8'))
              .align(Alignment.Center)
              .margin({ bottom: index === this.dataSource.totalCount() - 1 ? $r('app.float.arc_button_clearance') : 0 })
            }
          }, (item: PhraseItem) => `${item.id}_${this.currentLocale}`)
        }
        .focusable(true)
        .focusOnTouch(true)
        .defaultFocus(true)
        .width(SizeConstants.FULL_SIZE_PX)
        .height(SizeConstants.FULL_SIZE_PX)
        .borderRadius(SizeConstants.FULL_SIZE_PX)
        .space(LengthMetrics.resource($r('app.float.margin_12')))
        .backgroundColor($r('app.color.app_background'))
      }

      ArcButton({
        options: this.bottomOptions
      }).align(Alignment.Bottom)
    }
    .width(SizeConstants.FULL_WIDTH_PERCENT)
    .height(SizeConstants.FULL_HEIGHT_PERCENT)
    .alignContent(Alignment.Bottom)
  }
}

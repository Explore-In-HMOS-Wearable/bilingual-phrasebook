import {
  UIContext,
  ArcList,
  ArcListItem,
  ArcListAttribute,
  ArcListItemAttribute,
  ComponentContent,
  LengthMetrics,
  ArcButton,
  ArcButtonOptions,
  ColorMetrics,
  ArcButtonStyleMode,
} from '@kit.ArkUI';
import { PhraseItem, PhraseItemType } from '../viewmodel/PhrasesDataSource';
import { PhrasesViewModel } from '../viewmodel/PhrasesViewModel';
import { PhraseCardComponent } from '../components/PhraseCardComponent';
import { SizeConstants } from '../constants/SizeConstants';
import { PhraseTitleComponent } from '../components/PhraseTitleComponent';

interface HeaderParamsInterface {
  localeCode?: string;
}

@Builder
function buildHeader(params: HeaderParamsInterface) {
  Column() {
    Text($r('app.string.list_title'))
      .fontSize($r('app.float.list_header_size'))
      .fontWeight(FontWeight.Bold)
      .fontColor($r('app.color.deep_teal'))
    Row() {
      Text($r('app.string.current_locale'))
        .fontSize($r('app.float.list_header_size'))
        .fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.deep_teal'))
      Text('|')
        .margin({ start: LengthMetrics.resource($r('app.float.margin_8')) })
        .fontSize($r('app.float.list_header_size'))
        .fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.deep_teal'))
      Text(params.localeCode?.toUpperCase())
        .margin({ start: LengthMetrics.resource($r('app.float.margin_8')) })
        .fontSize($r('app.float.list_header_size'))
        .fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.deep_teal'))
    }
  }
  .constraintSize({ minHeight: SizeConstants.PERCENT_30 })
  .width(SizeConstants.FULL_WIDTH_PERCENT)
  .margin({ top: $r('app.float.margin_4') })
  .alignItems(HorizontalAlign.Center)
  .justifyContent(FlexAlign.End)
}

@Entry
@Component
struct Index {
  private context: UIContext = this.getUIContext();
  private viewModel: PhrasesViewModel = new PhrasesViewModel();
  private onLocaleToggled: () => void = () => {
    this.viewModel.toggleLocale();
    this.tabBar1.update({
      localeCode: this.viewModel.appLocale,
    })
  }
  private tabBar1: ComponentContent<HeaderParamsInterface> =
    new ComponentContent<HeaderParamsInterface>(
      this.context,
      wrapBuilder(buildHeader), {
      localeCode: this.viewModel.appLocale,
    });
  private bottomOptions = new ArcButtonOptions({
    label: $r('app.string.toggle_language'),
    styleMode: ArcButtonStyleMode.CUSTOM,
    fontSize: LengthMetrics.resource($r('app.float.list_header_size')),
    shadowEnabled: true,
    backgroundColor: ColorMetrics.resourceColor($r('app.color.deep_teal')),
    fontColor: ColorMetrics.resourceColor($r('app.color.card_text_color')),
    onClick: this.onLocaleToggled
  })

  build() {
    Stack() {
      ArcList({ initialIndex: 0, header: this.tabBar1 }) {
        LazyForEach(this.viewModel.loadDataSource(), (item: PhraseItem, index: number) => {
          if (item.type === PhraseItemType.TITLE) {
            ArcListItem() {
              PhraseTitleComponent({
                title: item.text
              }).margin({ top: index === 0 ? 0 : $r('app.float.margin_4') })
            }
          } else {
            ArcListItem() {
              PhraseCardComponent({
                title: item.text
              })
            }
            .width(SizeConstants.WATCH_LIST_WIDTH_PX)
            .backgroundColor($r('app.color.card_background_color'))
            .borderRadius($r('app.float.margin_16'))
            .padding($r('app.float.margin_8'))
            .align(Alignment.Center)
          }
        }, (item: PhraseItem, index?: number) => `${item.id}_${index}`)
      }
      .focusable(true)
      .focusOnTouch(true)
      .defaultFocus(true)
      .width(SizeConstants.FULL_SIZE_PX)
      .height(SizeConstants.FULL_SIZE_PX)
      .borderRadius(SizeConstants.FULL_SIZE_PX)
      .space(LengthMetrics.resource($r('app.float.margin_12')))
      .backgroundColor($r('app.color.app_background'))

      ArcButton({
        options: this.bottomOptions
      }).align(Alignment.Bottom)
    }
    .width(SizeConstants.FULL_WIDTH_PERCENT)
    .height(SizeConstants.FULL_HEIGHT_PERCENT)
    .alignContent(Alignment.Bottom)
  }
}
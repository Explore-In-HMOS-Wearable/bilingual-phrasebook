@Component
export struct PhraseCardComponent {
  @Prop @Require primary: string;
  @Prop @Require secondary: string;

  build() {
    Column() {
      Text(this.primary)
        .fontSize($r('app.float.phrase_font_size'))
        .fontColor($r('app.color.card_text_color'))
        .fontWeight(700)
        .textAlign(TextAlign.Center)
        .width('100%')
      Text(this.secondary)
        .fontSize($r('app.float.phrase_secondary_font_size'))
        .fontColor($r('app.color.phrase_secondary_text_color'))
        .fontWeight(400)
        .textAlign(TextAlign.Center)
        .width('100%')
        .margin({ top: $r('app.float.margin_2') })
    }
    .width('100%')
    .alignItems(HorizontalAlign.Center)
  }
}

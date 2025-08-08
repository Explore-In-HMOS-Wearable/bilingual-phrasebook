@Component
export struct PhraseCardComponent {
  @Prop
  @Require
  title: ResourceStr;

  build() {
    Text(this.title)
      .fontSize($r('app.float.phrase_font_size'))
      .fontColor($r('app.color.card_text_color'))
      .textAlign(TextAlign.Center)
  }
}
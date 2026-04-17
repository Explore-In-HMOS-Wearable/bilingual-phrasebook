@Component
export struct PhraseTitleComponent {
  @Prop
  @Require
  title: ResourceStr;

  build() {
    Text(this.title)
      .fontSize($r('app.float.list_header_size'))
      .fontColor($r('app.color.phrase_title_color'))
      .fontWeight(FontWeight.Medium)
      .textCase(TextCase.UpperCase)
      .letterSpacing(1.5)
  }
}
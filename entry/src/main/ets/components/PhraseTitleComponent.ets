@Component
export struct PhraseTitleComponent {
  @Prop
  @Require
  title: ResourceStr;

  build() {
    Text(this.title)
      .fontSize($r('app.float.list_header_size'))
      .fontColor(Color.Yellow)
  }
}
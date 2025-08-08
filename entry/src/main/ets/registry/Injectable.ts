export default interface Injectable {
  // cleanup or lifecycle method
  onDispose?(): void;
}
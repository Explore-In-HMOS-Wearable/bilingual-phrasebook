import Injectable from '../../registry/Injectable';

export default abstract class PreferencesManager implements Injectable {
  abstract onDispose(): void

  abstract setValue(key: string, value: string): Promise<void>

  abstract getValue(key: string, defValue: string): Promise<string>
}
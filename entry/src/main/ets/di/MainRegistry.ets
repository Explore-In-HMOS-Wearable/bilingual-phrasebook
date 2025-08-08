import PreferencesManager from '../utils/preferences/PreferencesManager';
import PreferencesManagerImpl from '../utils/preferences/PreferencesManagerImpl';
import { Register, ServiceRegistry } from '../registry/ServiceRegistry';
import UIRegistry from '../registry/UIRegistry';
import LocaleManager from '../utils/LocaleManager';

export class MainRegistry extends ServiceRegistry implements UIRegistry {
  context: Context

  private constructor(context: Context) {
    super();
    this.context = context;
  }

  public static build(context: Context): MainRegistry {
    const instance = new MainRegistry(context);
    instance.initialize();
    return instance;
  }

  @Register(PreferencesManager)
  registerPreferencesManager(): PreferencesManager {
    return new PreferencesManagerImpl(this.context);
  }

  @Register(LocaleManager)
  registerLocaleManager(): LocaleManager {
    return new LocaleManager()
  }
}


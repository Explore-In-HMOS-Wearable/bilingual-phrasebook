import Injectable from './Injectable'

type Constructor<T> = abstract new (...args: any[]) => T

const eagerServices = new Map<string, string>()
const lazyServices = new Map<string, string>()

let globalRegistry: ServiceRegistry | null = null

function setGlobalRegistry(registry: ServiceRegistry): void {
  globalRegistry = registry
}

/**
 * Registers a method as a service factory.
 * Services can be eager (default) or lazy.
 * @param cls
 * @param options
 * @returns
 */
export function Register<T extends Injectable>(
  cls: Constructor<T>,
  options: { name?: string, lazy?: boolean } = {}
): MethodDecorator {
  return function (_target, propertyKey, descriptor) {
    const methodName = propertyKey.toString()
    const name = options.name ?? 'default';
    const key = `${cls.name}::${name}`;
    const isLazy = options.lazy ?? false

    // Prevent duplicate methodNames registration
    if (eagerServices.has(methodName) || lazyServices.has(methodName)) {
      throw new Error(`Service factory method '${methodName}' already registered.`);
    }

    // Prevent duplicate names registration
    if (
      Array.from(eagerServices.values()).includes(key) ||
      Array.from(lazyServices.values()).includes(key)
    ) {
      throw new Error(`Service name '${name}' for '${cls.name}' type is already registered. Use a different name.`);
    }

    if (isLazy) {
      lazyServices.set(methodName, key);
    } else {
      eagerServices.set(methodName, key);
    }

    return descriptor
  }
}

/**
 * Resolves a registered service from the registry.
 * @param cls
 * @returns PropertyDecorator
 * @throws Error if the service is unavailable or the registry isn't ready.
 */
export function Resolve<T extends Injectable>(cls: Constructor<T>, options: { name?: string } = {}): PropertyDecorator {
  return function (target, propertyKey): void {
    Object.defineProperty(target, propertyKey, {
      configurable: true,
      enumerable: true,
      get: function () {
        const name = options.name ?? 'default';
        const key = `${cls.name}::${name}`;

        if (!globalRegistry) {
          throw new Error(`Resolve Error: '${key}' cannot be accessed before ServiceRegistry is ready.`);
        }

        const instance = globalRegistry.get<T>(key);
        Object.defineProperty(this, propertyKey, {
          value: instance,
          writable: false,
          configurable: false,
          enumerable: true,
        });

        return instance;
      },
    })
  }
}

/**
 * Central registry for all service instances and factories.
 */
export class ServiceRegistry {
  private readonly instances = new Map<string, Injectable>()
  private readonly factories = new Map<string, () => Injectable>()

  constructor() {
    setGlobalRegistry(this)
  }

  /**
   * Call all @Register methods (loop over eager/lazy service maps)
   */
  protected initialize(): void {
    // Initialize eager services
    for (const [methodName, className] of eagerServices.entries()) {
      const instance = (this as any)[methodName]()
      this.instances.set(className, instance)
    }

    // Register lazy factories
    for (const [methodName, className] of lazyServices.entries()) {
      this.factories.set(className, () => {
        if (this.instances.has(className)) {
          return this.instances.get(className)!
        }

        const instance = (this as any)[methodName]()
        this.instances.set(className, instance)
        this.factories.delete(className)
        return instance
      })
    }
  }

  /**
   * Clears all services and disposes of any lifecycle hooks.
   */
  destroy(): void {
    this.instances.forEach(service => service.onDispose?.())
    this.instances.clear()
    this.factories.clear()
  }

  /**
   *
   * @param key of type string
   * @returns T an instance of the service by key.
   * @throws Error if the service is not registered.
   */
  get<T extends Injectable>(key: string): T {
    const instance = this.instances.get(key);
    if (instance) {
      return instance as T;
    }

    const factory = this.factories.get(key);
    if (factory) {
      const created = factory();
      this.instances.set(key, created);
      return created as T;
    }

    throw new Error(`ServiceRegistry Error: No instance found for '${key}'.`);
  }
}

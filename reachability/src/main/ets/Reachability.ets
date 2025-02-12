import { Connectivity, ConnectivityType } from "./Connectivity";
import Logger from "./Logger";

const TAG = "[Reachability]";

export class Reachability {
  private notifierRunning: boolean = false;
  private connectivity: Connectivity;
  private _currentConnection: ConnectivityType = ConnectivityType.NONE;
  public whenReachable: Callback<ConnectivityType, void> = (connectionType) => {};
  public whenUnreachable: Callback<void> = () => {};

  constructor() {
    this.connectivity = new Connectivity();
  }

  public get currentConnection(): ConnectivityType {
    return this._currentConnection;
  }

  public get isReachable(): boolean {
    return (this._currentConnection === ConnectivityType.WIFI
      || this._currentConnection === ConnectivityType.CELLULAR
      || this._currentConnection === ConnectivityType.ETHERNET);
  }

  public get isReachableViaWWAN(): boolean {
    return this._currentConnection === ConnectivityType.CELLULAR;
  }

  public get isReachableViaWiFi(): boolean {
    return this._currentConnection === ConnectivityType.WIFI;
  }

  startNotifier() {
    if (this.notifierRunning) {
      return;
    }
    this.notifierRunning = true;

    // 注册
    Connectivity.netConnection.register(async (error) => {
      Logger.info(TAG, `register completed ${error ? JSON.stringify(error) : ''}`);
      this._currentConnection = await this.connectivity.getNetworkType();
      this.notifyReachabilityChanged();
    });

    // 订阅网络可用事件
    Connectivity.netConnection.on('netAvailable', async (data) => {
      this._currentConnection = await this.connectivity.getNetworkType();
      this.notifyReachabilityChanged();
    });

    // 订阅网络能力变化事件
    Connectivity.netConnection.on('netCapabilitiesChange', async (data) => {
      this._currentConnection = await this.connectivity.getNetworkType();
      this.notifyReachabilityChanged();
    });

    // 订阅网络连接信息变化事件
    Connectivity.netConnection.on('netConnectionPropertiesChange', async (data) => {
      this._currentConnection = await this.connectivity.getNetworkType();
      this.notifyReachabilityChanged();
    });

    // 订阅网络订阅网络丢失事件
    Connectivity.netConnection.on('netLost', (data) => {
      this._currentConnection = ConnectivityType.NONE;
      this.notifyReachabilityChanged();
    });

    // 订阅网络不可用事件
    Connectivity.netConnection.on('netUnavailable', (data) => {
      this._currentConnection = ConnectivityType.NONE;
      this.notifyReachabilityChanged();
    });
  }

  stopNotifier() {
    if (!this.notifierRunning) {
      return;
    }
    this.notifierRunning = false;

    Connectivity.netConnection.unregister((error) => {
      Logger.info(TAG, `unregister completed ${error ? JSON.stringify(error) : ''}`);
    });
  }

  private notifyReachabilityChanged(): void {
    this._currentConnection === ConnectivityType.NONE ? this.whenUnreachable?.() :
      this.whenReachable?.(this._currentConnection);
  }
}
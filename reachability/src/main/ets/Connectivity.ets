import { connection } from "@kit.NetworkKit";
import Logger from "./Logger";

export enum ConnectivityType {
  NONE = "none",
  WIFI = "wifi",
  CELLULAR = "cellular",
  ETHERNET = "ethernet",
  BLUETOOTH = "bluetooth",
  VPN = "vpn"
}

const TAG = "[Connectivity]";

export class Connectivity {
  public static netConnection = connection.createNetConnection();
  public networkType: ConnectivityType = ConnectivityType.NONE;

  // 通过异步方式获取网络信息
  async getNetworkType(): Promise<ConnectivityType> {
    try {
      const netHandle = await connection.getDefaultNet();
      if (netHandle.netId == 0) {
        return ConnectivityType.NONE;
      }
      const capabilities = await connection.getNetCapabilities(netHandle);
      this.networkType = this.hasTransport(capabilities.bearerTypes);
      return this.networkType;
    } catch (e) {
      Logger.error(TAG, `getNetworkType error: ${JSON.stringify(e)}`);
      return ConnectivityType.NONE;
    }
  }

  hasTransport(capabilities: Array<number>): ConnectivityType {
    if (!capabilities || capabilities.length == 0) {
      return ConnectivityType.NONE;
    }
    if (capabilities.includes(connection.NetBearType.BEARER_WIFI)) {
      return ConnectivityType.WIFI;
    }
    if (capabilities.includes(connection.NetBearType.BEARER_ETHERNET)) {
      return ConnectivityType.ETHERNET;
    }
    if (capabilities.includes(connection.NetBearType.BEARER_CELLULAR)) {
      return ConnectivityType.CELLULAR;
    }
    return ConnectivityType.NONE;
  }
}
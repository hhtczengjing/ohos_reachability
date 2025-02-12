# ohos_reachability

Discover the state of the network connectivity on HarmonyOS.

## 安装

```shell
ohpm i @devzeng/reachability
```

OpenHarmony ohpm 环境配置等更多内容，请参考[如何安装 OpenHarmony ohpm 包](https://ohpm.openharmony.cn/#/cn/help/downloadandinstall)

## 使用

```javascript
// 引入
import { Reachability } from '@devzeng/reachability';
private reachability: Reachability = new Reachability();

// 监听网络状态变化
this.reachability.whenReachable = (type) => {
    console.log('Network is reachable via ' + type);
};
this.reachability.whenUnreachable = () => {
    console.log('Network is not reachable');
};
this.reachability.startNotifier();

// 停止监听
this.reachability.stopNotifier();
```
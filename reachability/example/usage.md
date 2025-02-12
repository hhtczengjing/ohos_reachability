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
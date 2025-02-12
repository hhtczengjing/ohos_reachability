import { Reachability } from '@devzeng/reachability';

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';
  private reachability: Reachability = new Reachability();

  aboutToAppear(): void {
    this.reachability.whenReachable = (type) => {
      this.message = 'Network is reachable: ' + type;
    };
    this.reachability.whenUnreachable = () => {
      this.message = 'Network is unreachable';
    };
    this.reachability.startNotifier();
  }

  aboutToDisappear(): void {
    this.reachability.stopNotifier();
  }

  build() {
    Column() {
      Text(this.message)
        .fontSize(30)
        .fontWeight('bold')
        .textAlign(TextAlign.Center)
        .width('100%');
    }
    .height('100%')
    .width('100%')
  }
}
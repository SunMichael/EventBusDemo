# EventBusDemo
### 目的：简化各个组件之间的传递消息，使代码的可读性更好，耦合度更低。       
### 将控件所产生的事件全部收集起来，订阅者需要实现对应的protocol，在事件触发时通过代理获取到。      
### 大概机制类视于，广播中心收集所有的消息，订阅者只需订阅自己喜欢的消息类型，广播会在适当的时候推送消息给特定消息类型的订阅者
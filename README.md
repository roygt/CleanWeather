# CleanWeather

一个简单的天气App，可以搜索、添加、删除城市，下拉刷新天气信息，左右滑动切换城市等，天气数据来源于[和风天气](https://www.heweather.com)，App内用到的一些素材则来自于网络。

用到的第三方库有：  
1. [MJRefresh](https://github.com/CoderMJLee/MJRefresh)  
2. [fmdb](https://github.com/ccgus/fmdb)  
3. [BubbleTransition](https://github.com/andreamazz/BubbleTransition)  

MJRefresh用来实现下拉刷新功能，查询数据库则用的是fmdb。BubbleTransition用于转场，因为这个库是Swift版本的，所以是用OC去调用Swift。

#### 截图
![ScreenShot](https://github.com/roygt/CleanWeather/raw/master/ScreenShot.png)

//1.自动以NSLOG
#ifdef DEBUG
#define MyLog(...) NSLog(__VA_ARGS__)
#else
#define MyLog(...)
#endif

//2.判断是否为IOS7
#define IOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)

//3.获得RGB颜色
#define RGBColor(r,g,b)  [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]

//4.屏幕相关
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height


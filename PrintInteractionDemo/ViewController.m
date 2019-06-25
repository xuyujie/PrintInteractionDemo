//
//  ViewController.m
//  PrintInteractionDemo
//
//  Created by xuyujie on 2019/6/25.
//  Copyright © 2019 com.chinaums. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIPrintInteractionControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    UIButton * printextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    printextBtn.frame = CGRectMake(100, 100, 100, 50);
    printextBtn.backgroundColor = [UIColor blueColor];
    [printextBtn setTitle:@"打印文本" forState:UIControlStateNormal];
    [printextBtn addTarget:self action:@selector(printext:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:printextBtn];
    
    
    
    
    UIButton * printimgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    printimgBtn.frame = CGRectMake(100, 200, 100, 50);
    printimgBtn.backgroundColor = [UIColor blueColor];
    [printimgBtn setTitle:@"打印图片" forState:UIControlStateNormal];
    [printimgBtn addTarget:self action:@selector(printimg:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:printimgBtn];
    
    
    UIButton * printPdfBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    printPdfBtn.frame = CGRectMake(100, 300, 100, 50);
    printPdfBtn.backgroundColor = [UIColor blueColor];
    [printPdfBtn setTitle:@"打印PDF" forState:UIControlStateNormal];
    [printPdfBtn addTarget:self action:@selector(printPdf:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:printPdfBtn];
    
    
    
    UIButton * printwebBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    printwebBtn.frame = CGRectMake(100, 400, 100, 50);
    printwebBtn.backgroundColor = [UIColor blueColor];
    [printwebBtn setTitle:@"打印web" forState:UIControlStateNormal];
    [printwebBtn addTarget:self action:@selector(printweb:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:printwebBtn];
    
}


-(void)printext:(UIButton *)sender{
    UIPrintInteractionController *PrintInter = [UIPrintInteractionController sharedPrintController];//显示出打印的用户界面。
    PrintInter.delegate = self;
    if (!PrintInter) {
        NSLog(@"打印机不存在");
        return;
    }
    
    // 打印任务的信息  创建UIPrintInfo 实例配置参数
    UIPrintInfo *printInfo = [UIPrintInfo printInfo];
    printInfo.outputType =  UIPrintInfoOutputGeneral;//输出类型
    printInfo.orientation = UIPrintInfoOrientationPortrait;//打印方向
    printInfo.jobName = @""; //打印工作标识
    //printInfo.duplex = UIPrintInfoDuplexLongEdge;//双面打印绕长边翻页，NONE为禁止双面
    PrintInter.showsPageRange = YES;
    UISimpleTextPrintFormatter *textFormatter = [[UISimpleTextPrintFormatter alloc]
                                                 initWithText:@"ここの　ういえい　子に　うぃっl willingsea20655322　　你好么？ ＃@¥％……&＊"];
    textFormatter.startPage = 0;
    textFormatter.contentInsets = UIEdgeInsetsMake(0, 0, 0, 72.0); // 插入内容页的边缘 1 inch margins
    textFormatter.maximumContentWidth = 16 * 72.0;//最大范围的宽
    PrintInter.printFormatter = textFormatter;
    
    PrintInter.printInfo = printInfo;
    
    
    // 等待完成
    void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) =
    ^(UIPrintInteractionController *printController, BOOL completed, NSError *error) {
        if (!completed && error) {
            NSLog(@"可能无法完成，因为印刷错误: %@", error);
        }
    };
    
    
    [PrintInter presentFromRect:CGRectMake(500, 500, 100, 200) inView:self.view animated:YES completionHandler:completionHandler];//第二种方法
    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:sender];//调用方法的时候，要注意参数的类型－下面presentFromBarButtonItem:的参数类型是 UIBarButtonItem..如果你是在系统的UIToolbar or UINavigationItem上放的一个打印button，就不需要转换了。
        [PrintInter presentFromBarButtonItem:item animated:YES completionHandler:completionHandler];//在ipad上弹出打印那个页面
        
    } else {
        [PrintInter presentAnimated:YES completionHandler:completionHandler];//在iPhone上弹出打印那个页面
        // [printC presentFromRect:CGRectMake(500, 500, 100, 200) inView:self.webView animated:YES completionHandler:completionHandler];//第二种方法
        
    }
    
}

-(void)printimg:(UIButton *)sender{
    
    //获取要打印的图片
    UIImage * printImage =[UIImage imageNamed:@"start_2_1_1_A"];
    //剪切原图（824 * 2235）  这里需要说明下 因为A4 纸的72像素的 大小是（595，824） 为了打印出A4 纸 之类把原图转化成A4 的宽度，高度可适当调高 以适应页面内容的需求 ，调这个很简单地，打开你目前截取的图片，点击工具，然后点击调整大小，把宽度设置成595 就可以了，看高度是多少 除以 824 就是 几页
    UIImage * scanImage = [self scaleToSize:printImage size:CGSizeMake(595, 1660)];
    UIImage *jietuImage = [self imageFromImage:scanImage inRect:CGRectMake(0, 0, 595, 880)];
    UIPrintInteractionController *PrintInter = [UIPrintInteractionController sharedPrintController];//显示出打印的用户界面。
    PrintInter.delegate = self;
    if (!PrintInter) {
        NSLog(@"打印机不存在");
        return;
    }
    
    NSData *imgDate = UIImagePNGRepresentation(jietuImage);
    NSData *data = [NSData dataWithData:imgDate];
    if (PrintInter && [UIPrintInteractionController canPrintData:data]) {
        
        // 打印任务的信息  创建UIPrintInfo 实例配置参数
        UIPrintInfo *printInfo = [UIPrintInfo printInfo];
        printInfo.outputType =  UIPrintInfoOutputGeneral;//输出类型
        printInfo.orientation = UIPrintInfoOrientationPortrait;//打印方向
        printInfo.jobName = @""; //打印工作标识
        //printInfo.duplex = UIPrintInfoDuplexLongEdge;//双面打印绕长边翻页，NONE为禁止双面
        
        PrintInter.printInfo = printInfo;
        PrintInter.showsPageRange = YES;
        PrintInter.printingItem = data;//single NSData, NSURL, UIImage, ALAsset
        
        // 等待完成
        void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) =
        ^(UIPrintInteractionController *printController, BOOL completed, NSError *error) {
            if (!completed && error) {
                NSLog(@"可能无法完成，因为印刷错误: %@", error);
            }
        };
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:sender];//调用方法的时候，要注意参数的类型－下面presentFromBarButtonItem:的参数类型是 UIBarButtonItem..如果你是在系统的UIToolbar or UINavigationItem上放的一个打印button，就不需要转换了。
            [PrintInter presentFromBarButtonItem:item animated:YES completionHandler:completionHandler];//在ipad上弹出打印那个页面
        } else {
            [PrintInter presentAnimated:YES completionHandler:completionHandler];//在iPhone上弹出打印那个页面
            //[printC presentFromRect:CGRectMake(500, 500, 100, 200) inView:self.webView animated:YES completionHandler:completionHandler];//第二种方法
        }
        
        
    }
    
    
    
}


-(void)printPdf:(UIButton *)sender{
    
    NSString *pdf = [[NSBundle mainBundle] pathForResource:@"PDF使用指南.pdf" ofType:nil];
    
    NSData *pdfData = [NSData dataWithContentsOfFile:pdf];
    
    UIPrintInteractionController *PrintInter = [UIPrintInteractionController sharedPrintController];//显示出打印的用户界面。
    PrintInter.delegate = self;
    if (PrintInter && [UIPrintInteractionController canPrintData:pdfData]) {
        UIPrintInfo *printInfo = [UIPrintInfo printInfo];//准备打印信息以预设值初始化的对象。
        printInfo.outputType = UIPrintInfoOutputGeneral;//设置输出类型。
        PrintInter.showsPageRange = YES;//显示的页面范围
        printInfo.jobName = @"my.job";
        PrintInter.printInfo = printInfo;
        //设置打印源文件
        PrintInter.printingItem = pdfData;//single NSData, NSURL, UIImage, ALAsset
        // 等待完成
        void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) =
        ^(UIPrintInteractionController *printController, BOOL completed, NSError *error) {
            
            if (!completed && error) {
                NSLog(@"可能无法完成，因为印刷错误: %@", error);
            }
            if (completed) {
                NSLog(@"完成了");
            }else{
                NSLog(@"出错了");
                
            }
            
        };
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:sender];//调用方法的时候，要注意参数的类型－下面presentFromBarButtonItem:的参数类型是 UIBarButtonItem..如果你是在系统的UIToolbar or UINavigationItem上放的一个打印button，就不需要转换了。
            
            
            [PrintInter presentFromBarButtonItem:item animated:YES completionHandler:completionHandler];//在ipad上弹出打印那个页面
        } else {
            [PrintInter presentAnimated:YES completionHandler:^(UIPrintInteractionController * _Nonnull printInteractionController, BOOL completed, NSError * _Nullable error) {
                
            }];
        }
        
    }
    
}



-(void)printweb:(UIButton *)sender{
    
    UIPrintInteractionController *printC = [UIPrintInteractionController sharedPrintController];//显示出打印的用户界面。
    printC.delegate = self;
    
    
    UIPrintInfo *printInfo = [UIPrintInfo printInfo];//准备打印信息以预设值初始化的对象。
    printInfo.outputType = UIPrintInfoOutputGeneral;//设置输出类型。
    printC.showsPageRange = YES;//显示的页面范围
    
    // 打印网
    UIWebView * myWebView = [[UIWebView alloc] initWithFrame:self.view.frame];
    NSURL *url = [NSURL URLWithString:@"https://www.baidu.com"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    myWebView.scalesPageToFit = YES;
    [myWebView loadRequest:request];
    printC.printFormatter = [myWebView viewPrintFormatter];//布局打印视图绘制的内容。
    
    
    UIViewPrintFormatter *form = [[UIViewPrintFormatter alloc] init];
    form.maximumContentHeight = 40;
    [myWebView drawRect:CGRectMake(0, 0, 300, 300) forViewPrintFormatter:form];
    
    printC.printInfo = printInfo;
    
    void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) =
    ^(UIPrintInteractionController *printController, BOOL completed, NSError *error) {
        if (!completed && error) {
            NSLog(@"可能无法完成，因为印刷错误: %@", error);
        }
    };
    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:sender];//调用方法的时候，要注意参数的类型－下面presentFromBarButtonItem:的参数类型是 UIBarButtonItem..如果你是在系统的UIToolbar or UINavigationItem上放的一个打印button，就不需要转换了。
        [printC presentFromBarButtonItem:item animated:YES completionHandler:completionHandler];//在ipad上弹出打印那个页面
        
        //        [printC presentFromRect:CGRectMake(500, 500, 100, 200) inView:self.webView animated:YES completionHandler:completionHandler];//第二种方法
        
        
    } else {
        [printC presentAnimated:YES completionHandler:completionHandler];//在iPhone上弹出打印那个页面
    }
    
    
    
}

#pragma mark  -- UIPrintInteractionControllerDelegate

//- (UIViewController * _Nullable )printInteractionControllerParentViewController:(UIPrintInteractionController *)printInteractionController{
//
//    return nil;
//}

//______ 暂时无用   paperList据说是分页的，但是没找到具体信息
- (UIPrintPaper *)printInteractionController:(UIPrintInteractionController *)printInteractionController choosePaper:(NSArray<UIPrintPaper *> *)paperList{
    //设置纸张大小
    CGSize paperSize = CGSizeMake(595, 880);
    return [UIPrintPaper bestPaperForPageSize:paperSize withPapersFromArray:paperList];
    
}

//界面的显示
-(void)printInteractionControllerWillPresentPrinterOptions:(UIPrintInteractionController *)printInteractionController{
    
}
-(void)printInteractionControllerDidPresentPrinterOptions:(UIPrintInteractionController *)printInteractionController{
    
}
//界面的消失，
-(void)printInteractionControllerWillDismissPrinterOptions:(UIPrintInteractionController *)printInteractionController{
    
    NSLog(@"界面将要消失");
    
}
-(void)printInteractionControllerDidDismissPrinterOptions:(UIPrintInteractionController *)printInteractionController{
    NSLog(@"界面消失");
    
}

//打印工作的开始
- (void)printInteractionControllerWillStartJob:(UIPrintInteractionController *)printInteractionController{
    NSLog(@"打印工作开始");
}
// 打印工作的结束
- (void)printInteractionControllerDidFinishJob:(UIPrintInteractionController *)printInteractionController{
    NSLog(@"打印工作结束");
    
}

- (CGFloat)printInteractionController:(UIPrintInteractionController *)printInteractionController cutLengthForPaper:(UIPrintPaper *)paper NS_AVAILABLE_IOS(7_0){
    
    return 100;
}

//- (UIPrinterCutterBehavior) printInteractionController:(UIPrintInteractionController *)printInteractionController chooseCutterBehavior:(NSArray *)availableBehaviors NS_AVAILABLE_IOS(9_0){
//
//    return nil;
//}




//绘制原图 这个就是将原图改变为A4 纸宽度的图片
- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(20,20,size.width,size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

//截取原图  截取部分 打印的图片就是从这里来
- (UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect {
    CGImageRef sourceImageRef = [image CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    return newImage;
    
}


@end

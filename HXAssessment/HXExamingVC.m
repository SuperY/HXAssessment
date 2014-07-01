//
//  HXExamingVC.m
//  HXAssessment
//
//  Created by Felix_Y on 14-6-17.
//  Copyright (c) 2014年 HX. All rights reserved.
//

#import "HXExamingVC.h"
#import "HXNetworkManager.h"
#import "HXExamPaper.h"

#import <ConciseKit.h>
#import <hpple/TFHpple.h>
#import <AFNetworking/UIWebView+AFNetworking.h>
#import <ReactiveCocoa.h>

#import "WebViewJavascriptBridge.h"

@interface HXExamingVC ()<UIWebViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) HXExamPaper *examPaper;
@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, strong) NSArray *paper;
@property (nonatomic, strong) NSMutableArray *indexArray;

@property WebViewJavascriptBridge* bridge;

@end

@implementation HXExamingVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.examPaper = [HXExamPaper new];

    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    __weak HXExamingVC *weakSelf = self;
    [[HXNetworkManager sharedHXNetworkManager]downloadExamFile:self.theURL examMudelId:self.moduleID withExamId:self.examID success:^(id obj) {
        [weakSelf __parseHTMLSection:obj];
        NSString *num = @"1";
        [weakSelf __loadWebView:num];
    } error:^(NSInteger index) {

    }];

    [self __webViewJSDone];
}

- (NSArray *)__parserHTML:(NSData *)htmlData withXPath:(NSString *)XPathString
{

    TFHpple *hpple = [[TFHpple alloc]initWithHTMLData:htmlData];

    NSArray *elements = [hpple searchWithXPathQuery:XPathString];

    return elements;
}

- (void)__parseHTMLSection:(NSString *)path{


    NSData* htmlData = [NSData dataWithContentsOfFile:path];

    NSArray * sectionElements = [self __parserHTML:htmlData withXPath:@"//div[contains(@class ,'ui-question-group question-group-')]"];

    self.indexArray = [NSMutableArray new];

    NSMutableArray *queSections = [NSMutableArray new];

    for (NSInteger num = 0; num<[sectionElements count]; num++) {

        TFHppleElement *element = sectionElements[num];
        NSArray *queArray = [NSArray new];
        if ([[element objectForKey:@"class"]isEqualToString:@"ui-question-group question-group-4"]) {

            NSArray *subElements = [self __parserHTML:[element.raw dataUsingEncoding:NSUTF8StringEncoding] withXPath:@"//div[contains(@class ,'ui-question ui-question-independency ui-question')]"];
            for (NSInteger queNum = 0; queNum<[subElements count]; queNum++) {
                [self __parseComposite:subElements[queNum] withTitle:[(TFHppleElement *)subElements[queNum] raw]];
            }
            
        }else{
            queArray = [[self __parseQuestion:element]copy];
            [queSections addObject:queArray];
        }

    }

    //self.examPaper.sectionQuestions = queSections;
    self.paper = [queSections copy];
}

- (NSArray *)__parseQuestion:(TFHppleElement *)element
{
    NSMutableArray *queArray = [NSMutableArray new];
    NSData *elementData = [element.raw dataUsingEncoding:NSUTF8StringEncoding];

    NSArray * queElements  = [NSArray new];

    queElements = [self __parserHTML:elementData withXPath:@"//div[contains(@class ,'ui-question ui-question-independency ui-question')]"];

    NSString *sectionString = [(TFHppleElement*)[[element children] objectAtIndex:1] raw];
    for (NSInteger queNum = 0; queNum<[queElements count]; queNum++) {

//        if (queNum == 0) {
//            [queArray addObject: [sectionString stringByAppendingString:[(TFHppleElement *)queElements[queNum] raw]]];
//        }
//        else{
            [queArray addObject: [(TFHppleElement *)queElements[queNum] raw]];
        //}
    }

    return queArray;
}

- (NSArray *)__parseComposite:(TFHppleElement *)element withTitle:(NSString *)title{

    NSMutableArray *queArray = [NSMutableArray new];

    NSString *sectionString = [(TFHppleElement*)[[element children] objectAtIndex:1] raw];
    sectionString = [sectionString stringByAppendingString:title];

    NSData *elementData = [element.raw dataUsingEncoding:NSUTF8StringEncoding];//class="ui-question ui-question-independency ui-question

    NSArray * queElements  = [NSArray new];

    queElements = [self __parserHTML:elementData withXPath:@"//div[contains(@class ,'ui-question ui-question-sub ui-question')]"];

    for (NSInteger queNum = 0; queNum<[queElements count]; queNum++) {

        if (queNum == 0) {
            [queArray addObject: [sectionString stringByAppendingString:[(TFHppleElement *)queElements[queNum] raw]]];
        }
        else{
            [queArray addObject: [(TFHppleElement *)queElements[queNum] raw]];
        }
    }
    return queArray;
}

- (void)__loadWebView:(NSString *)numString{

    numString = [numString stringByReplacingOccurrencesOfString:@"." withString:@""];

    NSInteger sectionNum = [numString intValue];

    NSString* htmlString = [self.paper objectAtIndex:0][0];
    htmlString = [HXNetworkManager makePaper:htmlString];
    [self.webView loadHTMLString:htmlString baseURL:[NSURL fileURLWithPath:[[[NSBundle mainBundle]bundlePath] stringByAppendingPathComponent:@"html"]]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.examPaper.examPaperName = self.title;
    self.examPaper.examID = self.examID;
    self.examPaper.moduleID = self.moduleID;

    UIBarButtonItem *quesBtn = [[UIBarButtonItem alloc]initWithTitle:@"试题" style:UIBarButtonItemStyleDone target:self action:@selector(__quesBtnClick:)];
    UIBarButtonItem *submitBtn = [[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStyleDone target:self action:@selector(__submitBtnClick:)];

    [self.navigationItem setRightBarButtonItems:@[submitBtn,quesBtn]];

    self.webView = [[UIWebView alloc]initWithFrame:self.view.frame];
    [self.webView setTop:64];
    [self.webView setHeight:self.webView.height - 64];
    [self.webView setDelegate:self];
    [self.view addSubview:self.webView];

    UISwipeGestureRecognizer* swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeToRight:)];
    swipeRight.delegate= self;
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    swipeRight.cancelsTouchesInView = NO;

    UISwipeGestureRecognizer* swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeToLeft:)];
    swipeLeft.delegate= self;
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    swipeLeft.cancelsTouchesInView = NO;

    //这个可以加到任何控件上,比如你只想响应WebView，我正好填满整个屏幕
    [self.webView addGestureRecognizer:swipeRight];
    [self.webView addGestureRecognizer:swipeLeft];
}

- (void)__quesBtnClick:(id)sender{
    HXAlert(@"Error", @"Your resources load fail!", @"OK");
}

- (void)__submitBtnClick:(id)sender{
    HXAlert(@"提示", @"您将提交空白卷，确认提交？", @"确认");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)__webViewJSDone{
    [WebViewJavascriptBridge enableLogging];

    _bridge = [WebViewJavascriptBridge bridgeForWebView:self.webView webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"ObjC received message from JS: %@", data);
        responseCallback(@"Response for message from ObjC");
    }];

    [_bridge registerHandler:@"testObjcCallback" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"testObjcCallback called: %@", data);
        responseCallback(@"Response from testObjcCallback");
    }];

    [_bridge send:@"A string sent from ObjC before Webview has loaded." responseCallback:^(id responseData) {
        NSLog(@"objc got response! %@", responseData);
    }];

    [_bridge callHandler:@"testJavascriptHandler" data:@{ @"foo":@"before ready" }];

}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{

    [self.webView stringByEvaluatingJavaScriptFromString:@"<script>function connectWebViewJavascriptBridge(callback) {"
     "if (window.WebViewJavascriptBridge) {"
         "callback(WebViewJavascriptBridge)"
     "} else {"
         "document.addEventListener('WebViewJavascriptBridgeReady', function() {"
             "callback(WebViewJavascriptBridge)"
         "}, false)"
     "}"
     "}"

     "connectWebViewJavascriptBridge(function(bridge) {"
        "bridge.init(function(message, responseCallback) {"
            "alert('Received message: ' + message)"
            "if (responseCallback) {"
                "responseCallback(\"Right back atcha\")"
            "}"
        "})"
        "bridge.send('Hello from the javascript')"
        "bridge.send('Please respond to this', function responseCallback(responseData) {"
            "console.log(\"Javascript got its response\", responseData)"
        "})"
    "})</script>"];

    return true;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{

}

- (void)webViewDidFinishLoad:(UIWebView *)webView{

}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{

}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}



- (void)handleSwipeToRight:(UISwipeGestureRecognizer*)recognizer {
    // 触发手勢事件后，在这里作些事情
    if (recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        DLog(@"right   ");
    }

    [_bridge callHandler:@"getUserAnswer" data:[NSNull null] responseCallback:^(id responseData) {

    }];
}

- (void)handleSwipeToLeft:(UISwipeGestureRecognizer*)recognizer {
    // 触发手勢事件后，在这里作些事情
    if(recognizer.direction == UISwipeGestureRecognizerDirectionLeft){
        DLog(@"left");
    }
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (HXSectionQuestion *)__makeQuestionSection:(NSData *)elementData sectionNum:(NSInteger )num title:(NSString *)title{
    NSArray *numElements = [self __parserHTML:elementData withXPath:@"//div[@class='ui-question-title']/span[@class='ui-question-serial-no']"];
    NSArray *sorceElements = [self __parserHTML:elementData withXPath:@"//div[@class='ui-question-title']/span/span[@class='ui-question-score']"];
    NSArray *contentElements = [self __parserHTML:elementData withXPath:@"//div[contains(@class ,'ui-question-group question-group-')]/div[contains(@class ,'ui-question ui-question-independency ui-question')]/div[@class='ui-question-title']/div[@class='ui-question-content-wrapper']|//div[@class='ui-question-title']/span/span[@class='ui-question-score']"];
    NSArray *optionElements = [self __parserHTML:elementData withXPath:@"//ul[@class='ui-question-options']"];

    NSMutableArray *quesArray = [NSMutableArray new];

    for (NSInteger subNum = 0; subNum<[numElements count]; subNum++) {
        HXQuestion *q = [self __makeQuestionNum:numElements[subNum] sorceElement:sorceElements[subNum] contentElement:contentElements[subNum] optionElement:optionElements[subNum]];
        [quesArray addObject:q];
    }

    HXSectionQuestion *queSection = [HXSectionQuestion new];
    queSection.title = title;
    queSection.num = num;
    queSection.questions = quesArray;

    return queSection;
}

- (HXQuestion *)__makeQuestionNum:(TFHppleElement *)numElement sorceElement:(TFHppleElement *)sorceElement contentElement:(TFHppleElement *)contentELement optionElement:(TFHppleElement *)optionElement{

    HXQuestion *que = [HXQuestion new];
    que.num = [numElement text];
    que.score = [sorceElement text];

    //试题内容
    NSData *contentData = [contentELement.raw dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *contentElements = [self __parserHTML:contentData withXPath:@"//div[@class='ui-question-content-wrapper']/p/text()"];

    que.content = @" ";
    for (TFHppleElement *e in contentElements) {
        que.content = [que.content stringByAppendingString:e.raw];
    }

    //答案选项
    NSData *optionData = [optionElement.raw dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *optionElements = [self __parserHTML:optionData withXPath:@"//ul[@class='ui-question-options']/li/span[@class='ui-question-options-order']/text()"];
    NSArray *optionContentElements = [self __parserHTML:optionData withXPath:@"//ul[@class='ui-question-options']/li/text()"];

    NSMutableArray *opArray = [NSMutableArray new];
    for (NSInteger num=0; num<[optionElements count]; num++) {
        HXAnswer *ans = [HXAnswer new];
        ans.option = [(TFHppleElement *)optionElements[num] content];
        ans.content = [(TFHppleElement *)optionContentElements[num] content];

        [opArray addObject:ans];
    }
    
    que.answers = opArray;
    
    return que;
}

@end

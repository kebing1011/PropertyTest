//
//  AppDelegate.m
//  PropertyTest
//
//  Created by mao on 7/15/15.
//  Copyright (c) 2015 mao. All rights reserved.
//

#import "AppDelegate.h"
#import "TTObject.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

	
	TTObject* obj = [[TTObject alloc] init];
	
	NSString* stringA = @"123abcd";
	NSMutableString* stringB = [NSMutableString stringWithString:@"123abc"];
	
	NSLog(@"NSString-------->:%p", stringA);
	NSLog(@"NSMutableString->:%p", stringB);

	NSLog(@"\n");
	NSLog(@"右值为NSString:");
	
	obj.string1 = stringA; //strong
	obj.string2 = stringA; //copy
	obj.string3 = stringA; //weak
	obj.string4 = stringA; //assign
	
	
	
	NSLog(@"strong--->string1:%p, class:%@", obj.string1,  [obj.string1 class]);
	NSLog(@"copy----->string2:%p, class:%@", obj.string2,  [obj.string2 class]);
	NSLog(@"weak----->string3:%p, class:%@", obj.string3,  [obj.string3 class]);
	NSLog(@"assign--->string4:%p, class:%@", obj.string4,  [obj.string4 class]);
	NSLog(@"\n");
	NSLog(@"右值为NSMutabletring:");
	obj.string1 = stringB; //strong
	obj.string2 = stringB; //copy
	obj.string3 = stringB; //weak
	obj.string4 = stringB; //assign
	
	NSLog(@"strong--->string1:%p, class:%@", obj.string1,  [obj.string1 class]);
	NSLog(@"copy----->string2:%p, class:%@", obj.string2,  [obj.string2 class]);
	NSLog(@"weak----->string3:%p, class:%@", obj.string3,  [obj.string3 class]);
	NSLog(@"assign--->string4:%p, class:%@", obj.string4,  [obj.string4 class]);
	
	
	
	
	NSArray* arrayA = @[@1, @2, @3];
	
	NSMutableArray* arrayB = [arrayA mutableCopy];
	
	NSLog(@"NSArray-------->:%p", arrayA);
	NSLog(@"NSMutableArray->:%p", arrayB);
	
	NSLog(@"\n");
	NSLog(@"右值为NSArray:");
	
	obj.array1 = arrayA; //strong
	obj.array2 = arrayA; //copy
	obj.array3 = arrayA; //weak
	obj.array4 = arrayA; //assign
	
	
	
	NSLog(@"strong--->array1:%p, class:%@", obj.array1,  [obj.array1 class]);
	NSLog(@"copy----->array2:%p, class:%@", obj.array2,  [obj.array2 class]);
	NSLog(@"weak----->array3:%p, class:%@", obj.array3,  [obj.array3 class]);
	NSLog(@"assign--->array4:%p, class:%@", obj.array4,  [obj.array4 class]);
	NSLog(@"\n");
	NSLog(@"右值为NSMutabletring:");
	obj.array1 = arrayB; //strong
	obj.array2 = arrayB; //copy
	obj.array3 = arrayB; //weak
	obj.array4 = arrayB; //assign
	
	NSLog(@"strong--->array1:%p, class:%@", obj.array1,  [obj.array1 class]);
	NSLog(@"copy----->array2:%p, class:%@", obj.array2,  [obj.array2 class]);
	NSLog(@"weak----->array3:%p, class:%@", obj.array3,  [obj.array3 class]);
	NSLog(@"assign--->array4:%p, class:%@", obj.array4,  [obj.array4 class]);
	
	
	
	
	//为什么有些教程说一般NSString用Copy, 很明显可以看出，当右值为NSString的时候，没有变化，地址都是一样的。
	//当右值为NSMutableString的时候，内部调用的copy操作, 地址改变了，在外部Getter方法使用这个String的时候，保证它是不可变的只读特性。
	
	//分别说一下这几种属性
	/*
	
	1.strong 当property使用strong时, 在调用Setter方法时，会强引用右值。
	猜想它的Setter方法实现应该是这样的:
	 
	 - (void)setString1:(NSString *)string1 {
	 if (_string1 != string1) {
		_string1 = string1;
	   }
	 }
	
	 那么问题来了，如果我们右值使用的是NSMutableString，必竟它也是NSString的字类啊，Xcode不会有任何警告提示。
	 这样在Obj持有的string1成了一个NSMutableString的对象。如果我们在外部，用Gettter方法拿到obj.string1时，它是可以随意修改的。
	 
	 2.copy 当property使用copy时, 在调用Setter方法时，会用右值的copy协议。
	 猜想它的Setter方法实现应该是这样的:
	 - (void)setString2:(NSString *)string2 {
	 if (_string2 != string2) {
		_string2 = [string2 copy];
	 }
	 }
	
	 总是有一些新人会说，如果copy协议的话，会重新审请内存创建一个对象，然后将内容再付给它，(可以理解成C语言的deep-copy)那这样岂不是会加大的内存的使用啊。
	 看了上面log，我想这个困惑就解了吧。
	 显然，string2使用copy的协议，当右值为NSString时，内存地址不变!! 是不是脑洞大开啊，原来这个不可变对象在调用copy时，根没处理一样，也就是说没有新生一个对象，很好很强大。
	 当右值为NSMutableString时，调用copy协议，地址变了，生成了新的对象，不过呢，这个对象是inmutable的，在外部Getter方法时，就不怕被修改了，只读特性保持住了。
	 
	 3.weak 当property使用weak时, 在调用Setter方法时，会弱引用右值。
	 - (void)setString3:(NSString *)string3 {
	 if (_string3 != string3) {
		__weak NSString* string = string3;
		_string3 = string;
	 }
	 }
	 
	 这个跟强引用是类似的，都是引用，只不过是弱的引用，因为它是弱引用，当右值没有对象强引用它时，obj.string3 就会被设为nil，没有ownership, 不持有，只是借用而用，不是自已的has-a, 仅仅use-a 除此之外
	 Stong引用出现的问题，它也有，右值是NSSMutableString是，也会被修改，也对，本来就拿来用用，人家改了，管你鸟事啊。
	 
	 
	 4.assign时，当property不指定时，默认就是它，有代码洁癖的人如果是assign的话，一般不写，而有迫症的人，会写，一定要上下对齐，看着爽。
	 - (void)setString4:(NSString *)string4 {
	 if (_string4 !=string4) {
		__unsafe_unretained NSString* string = string4;
		_string4 = string;
	 }
	 }
	 
	 看到没__unsafe_unretained，这个从字眼上就知道，不安全的持有，哇，好怕怕，在手动管理内存的年代，直接左值＝右值就是assgin操作，到了ARC的年代，这种直接＝成了strong的了。
	 根weak有几分相似啊，也算是一种引用啊，都是拿指针过来用用，use-a，与weak不同的是，unsafe的啊，如果右值这个string没了，dealloc了, 它还儍拿着用呢，相当于C里面野指针，你用了已经释放了的内存，如果运气好，
	 有时候会还能用几下，没几下就会BAD_ACCESS，哇崩掉了，崩崩更健康，成长之必经之路啊, 那个weak的呢，被置成nil了，哎呀这去，不崩，好啊，但是这种引发的bug，更难查好不好，好深的一颗雷就被这样埋下了。
	 如果把nil塞到array里或dictionary里也会异常。
	 
	NSArray的Log，不用我多说了吧。
	 
	 
	 
	 
	 
	 现在你们在用基本数据模型（NSSArray, NSSet..）时，定义Property属性时，选择哪种应该很情楚了吧，别记什么某某法则，不懂原理，那是机器，我们是操作电脑的人。
	 
	 - (NSArray *)itemsAtIndexPath:(NSIndexPath *)indexPath {
	 //如果是这样的。。
	 NSMutableArray* items = [NSMutableArray array];
	 
	 //	一些操作
	 //...
	 //...
	 return [items copy]; //这句很重要！！相信很多人都直接返回了，没有copy，多说无益。
	 }
	 
	 
	 
	 
	
	*/
	
	
	
	return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

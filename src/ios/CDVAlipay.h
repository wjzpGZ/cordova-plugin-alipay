#import <Cordova/CDVPlugin.h>

@interface CDVAlipay : CDVPlugin

- (void) pay:(CDVInvokedUrlCommand*) command;
- (void) isWalletExist:(CDVInvokedUrlCommand*) command;

@end

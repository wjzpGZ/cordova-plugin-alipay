#import "CDVAlipay.h"
#import <AlipaySDK/AlipaySDK.h>

@implementation CDVAlipay

- (void) pay:(CDVInvokedUrlCommand*) command {
    __block CDVPluginResult* pluginResult = nil;

    NSString* orderStr = [command.arguments objectAtIndex:0];
    NSString* appScheme = [command.arguments objectAtIndex:1];

    if (orderStr != nil) {
        [[AlipaySDK defaultService] payOrder:orderStr fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"AlipayResult = %@",resultDic);
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[resultDic description]];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Arg was null"];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
}

- (void) isWalletExist:(CDVInvokedUrlCommand*)command {

    CDVPluginResult* pluginResult = nil;

    NSString* scheme = @"alipay://";

    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:scheme]]) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"true"];
    }
    else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"false"];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

#pragma mark "CDVPlugin Overrides"

- (void)handleOpenURL:(NSNotification *)notification
{
    NSURL* url = [notification object];

    if ([url.host isEqualToString:@"safepay"] || [url.host isEqualToString:@"alipay"]) {

        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
    }
}

@end

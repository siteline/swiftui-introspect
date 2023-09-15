#import <Foundation/Foundation.h>
#import <OSLog/OSLog.h>
#import "SDStatusBarManager.h"

__attribute__((constructor))
static void pluginDidStart(void) {
  [SDStatusBarManager.sharedInstance enableOverrides];
}

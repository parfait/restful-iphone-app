#import "RESOURCE_NAMEListController.h"
#import "ParfaitAppDelegate.h"
#import "RESOURCE_NAMEViewController.h"

@interface RESOURCE_NAME : ObjectiveResource
@end

@implementation RESOURCE_NAME
+ (NSString*)baseURL  { return @"BASE_URL"; }
@end

@implementation RESOURCE_NAMEListController
- (Class)resourceClass;
{
	return [RESOURCE_NAME class];
}
@end

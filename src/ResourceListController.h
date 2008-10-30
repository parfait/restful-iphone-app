#import <UIKit/UIKit.h>

@class ResourceViewController;

@interface ResourceListController : UITableViewController
{
	ResourceViewController* showController;
	NSArray* products;
}

- (void)refreshResourceList:(id)sender;
@end

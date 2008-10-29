#import <UIKit/UIKit.h>

@class ResourceViewController;

@interface RootViewController : UITableViewController
{
	ResourceViewController* showController;
	NSArray* products;
}

- (void)refreshResourceList:(id)sender;
@end

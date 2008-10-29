#import <UIKit/UIKit.h>
#import "ObjectiveResource.h"

@interface ResourceViewController : UITableViewController
{
	ObjectiveResource* resource;
}
@property (retain) ObjectiveResource* resource;
@end

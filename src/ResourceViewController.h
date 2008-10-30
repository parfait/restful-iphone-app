#import <UIKit/UIKit.h>
#import "ObjectiveResource.h"

#define HANDLE_CONNECTION_EXCEPTIONS(code) \
	@try \
	{ \
		code \
	} \
	@catch(ORResourceNotFound* error) \
	{ \
		UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Connection Error" \
                                                          message:@"Error connecting to resource" \
                                                         delegate:nil \
                                                cancelButtonTitle:@"OK" \
                                                otherButtonTitles:nil]; \
		[alertView show]; \
		[alertView release]; \
	} \
	@catch(ORConnectionError* error) \
	{ \
		UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Connection Error" \
                                                          message:[error reason] \
                                                         delegate:nil \
                                                cancelButtonTitle:@"OK" \
                                                otherButtonTitles:nil]; \
		[alertView show]; \
		[alertView release]; \
	}

@interface ResourceViewController : UITableViewController
{
	ObjectiveResource* resource;
}
@property (retain) ObjectiveResource* resource;
@end

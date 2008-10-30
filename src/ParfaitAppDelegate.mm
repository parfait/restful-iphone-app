#import "ParfaitAppDelegate.h"
#import "ResourceListController.h"


@implementation ParfaitAppDelegate

@synthesize window;
@synthesize navigationController;

- (void)applicationDidFinishLaunching:(UIApplication*)application
{
	// Configure and show the window
	[window addSubview:[navigationController view]];
	[window makeKeyAndVisible];
}


- (void)applicationWillTerminate:(UIApplication*)application
{
	// Save data if appropriate
}

- (void)dealloc
{
	[navigationController release];
	[window release];
	[super dealloc];
}
@end

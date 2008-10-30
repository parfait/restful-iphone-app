#import "ResourceViewController.h"
#import "CWInflector.h"


@implementation ResourceViewController
// ==================
// = Setup/Teardown =
// ==================

- (id)init;
{
	if(self = [self initWithStyle:UITableViewStyleGrouped])
	{

	}
	return self;
}

- (void)dealloc
{
	self.resource = nil;
	[super dealloc];
}

- (void)viewDidLoad
{
	UIBarButtonItem* refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshResource:)];
	self.navigationItem.rightBarButtonItem = refreshButton;
	[refreshButton release];
}

// =============
// = Accessors =
// =============

@synthesize resource;

- (void)setResource:(ObjectiveResource*)r;
{
	if(r != resource)
	{
		[resource release];
		resource   = [r retain];
		self.title = resource.title;
	}
	[self.tableView reloadData];
}

// ===========
// = Actions =
// ===========

- (void)refreshResource:(id)sender;
{
	HANDLE_CONNECTION_EXCEPTIONS
	(
		[self.resource reload];
		[self.tableView reloadData];
	)
}

// =============
// = TableView =
// =============

- (NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section
{
	return [[self.resource.interestingAttributeNames objectAtIndex:section] humanizedForm];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
	return [self.resource.interestingAttributeNames count];
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
	return 1;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
	NSString* attributeName   = [self.resource.interestingAttributeNames objectAtIndex:indexPath.section];
	id value                  = [self.resource.attributes objectForKey:attributeName];
	UITableViewCell* cell     = nil;
	ORAttributeType attrType = [resource typeForAttribute:attributeName];

	switch(attrType)
	{
	case kORAttributeTypeHTMLText:
		{
			static NSString* CellIdentifier = @"WebViewCell";

			cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
			if(cell == nil)
			{
				cell                = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
				cell.lineBreakMode  = UILineBreakModeClip;
				UIWebView* webView  = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 250, tableView.rowHeight)];
				{
					webView.backgroundColor  = [UIColor clearColor];
					webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
					[cell.contentView addSubview:webView];
					[cell layoutSubviews];
				}
				[webView release];
			}
			[[[cell.contentView subviews] objectAtIndex:1] loadHTMLString:[NSString stringWithFormat:@"<body style=\"background-color: transparent;\">%@</body>", value] baseURL:nil];
		}
		break;
	case kORAttributeTypeBoolean:
		{
			static NSString* CellIdentifier = @"BooleanCell";

			cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
			if(cell == nil)
			{
				cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
			}
			[cell setText:([value boolValue] ? @"Yes" : @"No")];
		}
		break;
	default:
		{
			static NSString* CellIdentifier = @"TextCell";

			cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
			if(cell == nil)
			{
				cell                = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
				cell.lineBreakMode  = UILineBreakModeClip;
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
			}

			value = [value description];

			// Temporary hack until I get something nicer for multiline strings
			value = [[value componentsSeparatedByString:@"\n"] objectAtIndex:0];

			[cell setText:value];
		}
	}

	return cell;
}
@end

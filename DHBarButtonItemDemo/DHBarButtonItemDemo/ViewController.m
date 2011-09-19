//
//  ViewController.m
//  DHBarButtonItemDemo
//
//  Created by David Hoerl on 9/19/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "DHBarButtonItem.h"

@interface ViewController()
@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;

- (IBAction)imageAction:(id)sender;

@end

@implementation ViewController
{
	DHBarButtonItem *item;
	NSArray *image1;
	NSArray *image2;
	NSArray *image3;
	NSArray *image4;
	NSArray *image5;
	
	NSArray *currentArray;
}
@synthesize toolbar;

- (void)viewDidLoad
{
    [super viewDidLoad];


	image1 = [NSArray arrayWithObjects:
		[NSDictionary dictionaryWithObjectsAndKeys:
			[UIImage imageNamed:@"flower.png"], kBBITTimage,
			nil],
		
		[NSDictionary dictionaryWithObjectsAndKeys:
			[UIImage imageNamed:@"plant.png"], kBBITTimage,
			[NSNumber numberWithInteger:UITextAlignmentLeft] , kBBITTalignment,
			nil],
		
		[NSDictionary dictionaryWithObjectsAndKeys:
			@"Short", kBBITTtext,
			[NSNumber numberWithInteger:UITextAlignmentCenter] , kBBITTalignment,
			nil],
			
		nil];

	image2 = [NSArray arrayWithObjects:
		[NSDictionary dictionaryWithObjectsAndKeys:
			[UIImage imageNamed:@"flower.png"], kBBITTimage,
			nil],
		
		[NSDictionary dictionaryWithObjectsAndKeys:
			[UIImage imageNamed:@"key.png"], kBBITTimage,
			[NSNumber numberWithInteger:UITextAlignmentRight] , kBBITTalignment,
			nil],
				
		[NSDictionary dictionaryWithObjectsAndKeys:
			@"Medium", kBBITTtext,
			[NSNumber numberWithInteger:UITextAlignmentRight] , kBBITTalignment,
			nil],
			
		nil];

	image3 = [NSArray arrayWithObjects:
		[NSDictionary dictionaryWithObjectsAndKeys:
			[UIImage imageNamed:@"flower.png"], kBBITTimage,
			nil],
		
		[NSDictionary dictionaryWithObjectsAndKeys:
			[UIImage imageNamed:@"plant.png"], kBBITTimage,
			[NSNumber numberWithInteger:UITextAlignmentLeft] , kBBITTalignment,
			nil],
		
		[NSDictionary dictionaryWithObjectsAndKeys:
			@"LongLongLong", kBBITTtext,
			[NSNumber numberWithInteger:UITextAlignmentLeft] , kBBITTalignment,
			nil],
		nil];

	image4 = [NSArray arrayWithObjects:
		[NSDictionary dictionaryWithObjectsAndKeys:
			[UIImage imageNamed:@"flower.png"], kBBITTimage,
			nil],
		
		[NSDictionary dictionaryWithObjectsAndKeys:
			[UIImage imageNamed:@"plant.png"], kBBITTimage,
			[NSNumber numberWithInteger:UITextAlignmentLeft] , kBBITTalignment,
			nil],
		
		[NSDictionary dictionaryWithObjectsAndKeys:
			@"LongLongLong", kBBITTtext,
			[NSNumber numberWithInteger:UITextAlignmentLeft] , kBBITTalignment,
			[NSNumber numberWithInteger:4] , kBBITTbaseline,
			nil],
		nil];

	image5 = [NSArray arrayWithObjects:
		[NSDictionary dictionaryWithObjectsAndKeys:
			[UIImage imageNamed:@"flower.png"], kBBITTimage,
			nil],
		
		[NSDictionary dictionaryWithObjectsAndKeys:
			[UIImage imageNamed:@"key.png"], kBBITTimage,
			[NSNumber numberWithInteger:UITextAlignmentLeft] , kBBITTalignment,
			[NSNumber numberWithInteger:-5] , kBBITTbaseline,
			nil],
		
		[NSDictionary dictionaryWithObjectsAndKeys:
			@"LongLongLong", kBBITTtext,
			[NSNumber numberWithInteger:UITextAlignmentLeft] , kBBITTalignment,
			nil],
		nil];

	// Initial options to set column widths and total width
	NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
		[NSNumber numberWithInteger:UIBarButtonItemStyleBordered], kBBITToptStyle, 
		[NSNumber numberWithInteger:5], kBBITToptPadding,
		[NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 5)], kBBITTimageInsets,	// only left and right honored
		
		[NSArray arrayWithObjects: // must appear in the same order as the columns they modify
			[NSArray array],	// first icolumn does not change from the initial item
			[NSArray arrayWithObjects:[UIImage imageNamed:@"key.png"], nil],	// Other possible images
			[NSArray arrayWithObjects:@"Medium", @"LongLongLong", nil], // Equivalent to "possible titles" in UIBarbuttonItem
			nil],  kBBITToptionsArray,
		nil];
	
	item = [DHBarButtonItem itemWithImageItems:image1 options:options];
	item.target = self;
	item.action = @selector(imageAction:);

	currentArray = image1;

	NSMutableArray *items = [NSMutableArray arrayWithArray:toolbar.items];
	[items addObject:item];
	[toolbar setItems:items animated:NO];
}

- (IBAction)imageAction:(id)sender
{
	if(currentArray == image1) currentArray = image2;
	else if(currentArray == image2) currentArray = image3;
	else if(currentArray == image3) currentArray = image4;
	else if(currentArray == image4) currentArray = image5;
	else if(currentArray == image5) currentArray = image1;
	
	[item imageFromItems:currentArray];
}

@end

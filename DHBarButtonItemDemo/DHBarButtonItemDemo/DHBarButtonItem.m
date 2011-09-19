//
//  DHBarButtonItem.m
//  RotatePicker
//
//  Created by David Hoerl on 9/14/11.
//  Copyright (c) 2011 David Hoerl. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#if ! __has_feature(objc_arc)
#error This code requires ARC.
#endif

#import "DHBarButtonItem.h"

#define TAB_IMAGE_HEIGHT	20.0f	// Apple recommends this height see UIBarItem Ref Page

//static BOOL retinaDisplay;

@interface DHBarButtonItem ()
@property (nonatomic, assign) NSUInteger count;	// must provide an array of this many items
@property (nonatomic, assign) CGFloat *widths;
@property (nonatomic, assign) CGFloat startingX;
@property (nonatomic, assign) CGFloat totalWidth;
@property (nonatomic, assign) CGFloat totalHeight;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, assign) CGFloat padding;

+ (CGSize)resizedImageSize:(UIImage *)image;
+ (CGFloat)itemWidth:(NSDictionary *)dict font:(UIFont *)font;

@end

@implementation DHBarButtonItem
@synthesize count;
@synthesize widths;
@synthesize startingX;
@synthesize totalWidth;
@synthesize totalHeight;
@synthesize font;
@synthesize padding;

+ (DHBarButtonItem *)itemWithImageItems:(NSArray *)itemsArray options:(NSDictionary *)optDict
{
	NSUInteger count = [itemsArray count];
	CGFloat *widths = (CGFloat *)calloc(count, sizeof(CGFloat));
	CGFloat totalWidth = 0;
	UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, 0, 0);
	CGFloat totalHeight = TAB_IMAGE_HEIGHT - insets.top - insets.bottom;

	UIBarButtonItemStyle style	= [[optDict objectForKey:kBBITToptStyle] integerValue];
	CGFloat padding				= [[optDict objectForKey:kBBITToptPadding] floatValue];
	UIFont *font				= [optDict objectForKey:kBBITToptFont];
	if(!font) font = [UIFont boldSystemFontOfSize:12];
								  [(NSValue *)[optDict objectForKey:kBBITTimageInsets] getValue:&insets];
	
	NSUInteger idx = 0;
	NSArray *optionsArray		= [optDict objectForKey:kBBITToptionsArray];
	for(NSArray *oneCol in optionsArray) {
		CGFloat width = 0;
		for(id item in oneCol) {
			NSString *key;
			if([item isKindOfClass:[NSString class]]) {
				key = kBBITTtext;
			} else
			if([item isKindOfClass:[UIImage class]]) {
				key = kBBITTimage;
			} else
			if([item isKindOfClass:[NSNumber class]]) {
				key = kBBITTspace;
			} else {
				continue;
			}
			CGFloat newWidth = [self itemWidth:[NSDictionary dictionaryWithObject:item forKey:key] font:font];
			assert(isnormal(newWidth));
			width = MAX(width, newWidth); 
		}
		widths[idx] = ceilf(width);
		// NSLog(@"options[%d]=%f", idx, width);
		++idx;
	}

	// Each item is a set of items to draw - 
	idx = 0;
	for(NSDictionary *dict in itemsArray) {
		CGFloat newWidth = [self itemWidth:dict font:font];

		CGFloat width = widths[idx];
		width = MAX(width, newWidth); 
		// NSLog(@"items[%d]=%f", idx, width);
		widths[idx]  = ceilf(width);
		++idx;
	}

	for(idx=0; idx<count; ++idx) {
		widths[idx] += padding;
		totalWidth += widths[idx];
	}
	totalWidth -= padding; // last one
	totalWidth += insets.left + insets.right;
	
	DHBarButtonItem *item = [[DHBarButtonItem alloc] initWithImage:nil style:style target:nil action:NULL];
	item.count			= count;
	item.startingX		= insets.left;
	item.totalWidth		= totalWidth;
	item.totalHeight	= totalHeight;
	item.widths			= widths; // transfer
	item.font			= font; // transfer
	item.padding		= padding;

	[item imageFromItems:itemsArray];
	
	return item;
}

+ (CGFloat)itemWidth:(NSDictionary *)dict font:(UIFont *)font
{
	CGFloat newWidth = 0;

	for(NSString *key in [dict allKeys]) {
		id object = [dict objectForKey:key];
		if([key isEqualToString:kBBITTimage]) {
			CGSize size = [DHBarButtonItem resizedImageSize:(UIImage *)object];
			newWidth = size.width;
		} else
		if([key isEqualToString:kBBITTtext]) {
			newWidth = [(NSString *)object sizeWithFont:font].width;
		} else
		if([key isEqualToString:kBBITTspace]) {
			newWidth = [(NSNumber *)object floatValue]; 
		}
	}
	return newWidth;
}

+ (CGSize)resizedImageSize:(UIImage *)image
{
	CGSize size = image.size;
	if(size.height > TAB_IMAGE_HEIGHT) {
		CGFloat factor = TAB_IMAGE_HEIGHT/size.height;
		size.height = TAB_IMAGE_HEIGHT;
		size.width = ceilf(size.width * factor);
	}
	return size;
}

- (void)setImageInsets:(UIEdgeInsets)inserts
{
	return; // user cannot set these on the bar button item itself
#if 0
	if(count) {
		UIEdgeInsets ei = [super imageInsets];
		assert(ei.top == inserts.top && ei.bottom == inserts.top);
		if(ei.top != inserts.top || ei.bottom != inserts.top) {
			return; // cannot change once the item is created
		}
	}
	[super setImageInsets:inserts];
#endif
}

- (void)dealloc
{
	free(widths);
}

- (void)imageFromItems:(NSArray *)items
{
	if([items count] != count) return;
NSLog(@"imageFromItems");
	UIGraphicsBeginImageContextWithOptions(CGSizeMake(totalWidth, totalHeight), NO, 0);
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetInterpolationQuality(context,  kCGInterpolationHigh);	// in case an icon size is reduced
	
	CGColorRef white = [[UIColor whiteColor] CGColor];

	CGFloat x = startingX;
	CGFloat *widthsPtr = widths;

	for(NSDictionary *dict in items) {
		CGFloat width = *widthsPtr - padding;
		CGContextSetFillColorWithColor(context, white);
		UITextAlignment ta = [[dict objectForKey:kBBITTalignment] integerValue];
		CGFloat baselineOffset = [[dict objectForKey:kBBITTbaseline] floatValue];
		UIColor *color = [dict objectForKey:kBBITTcolor];
		CGContextSetFillColorWithColor(context, color ? [color CGColor] : white);
		BOOL mask = [[dict objectForKey:kBBITTmask] boolValue];
	
		for(NSString *key in [dict allKeys]) {
			id object = [dict objectForKey:key];
			if([key isEqualToString:kBBITTimage]) {
				CGRect r;
				r.size = [DHBarButtonItem resizedImageSize:(UIImage *)object];
				r.origin.y = ceilf( (totalHeight - r.size.height)/2.0f + baselineOffset);
				CGFloat xVal;
				switch(ta) {
				case UITextAlignmentLeft:
					xVal = 0;
					break;
				case UITextAlignmentRight:
					xVal = width - r.size.width;
					break;
				case UITextAlignmentCenter:
				default:
					xVal = (width - r.size.width)/2.0f;
					break;
				}
				r.origin.x = floorf( x + xVal );
				if(mask) {
					CGContextSaveGState(context);
					CGContextClipToMask(context, r, [(UIImage *)object CGImage]);
					CGContextFillRect(context, r);
					CGContextRestoreGState(context);
				} else {
					[(UIImage *)object drawInRect:r];
				}
			} else
			if([key isEqualToString:kBBITTtext]) {
				CGFloat y = floorf( (totalHeight - font.lineHeight)/2 + baselineOffset);
				CGRect rect = CGRectMake(x, y, width, totalHeight);
				[(NSString *)object drawInRect:rect withFont:font lineBreakMode:UILineBreakModeClip alignment:ta];
			}
		}
		x += *widthsPtr++;
	}
	self.image = UIGraphicsGetImageFromCurrentImageContext();

	UIGraphicsEndImageContext();
}

@end

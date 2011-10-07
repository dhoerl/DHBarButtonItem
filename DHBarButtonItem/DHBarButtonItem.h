//
//  DHBarButtonItem.h
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

/*
This control is provided an initial "image" array. Other items that might appear in a 
column can be supplied in the initial options dictionary. For each position
the widest possible item is computed, and that width used for that position. The total 
width of the image used by the control is the sum of these widths plus the padding 
that goes between each item. In addition, you can supply standard imageInsets

This class should be created using the one class method itemWithImageItems that creates 
an initial image using the first item of each array of items.

To create a new image, use the object method replaceImageWithImageItems. The array passed to
this method contains dictionaries.

use

*/

// Item Dictionary Keys
#define kBBITTimage			@"kBBITTimage"				// UIImage - will be resized if height > 20 points
#define   kBBITTalignment	@"kBBITTalignment"			// NSNumber (integral) - UITextAlignment, default is left. Include in image dictionary
#define   kBBITTbaseline	@"kBBITTbaseline"			// NSNumber (float), optional - tweak baseline, default is 0
#define   kBBITTmask		@"kBBITTmask"				// NSNumber(BOOL), optional - mask the image (NavigationBars only)
#define   kBBITTcolor		@"kBBITTcolor"				// UIColor, optional - item color, default white (NavigationBars only)
#define kBBITTtext			@"kBBITTtext"				// NSString
#define   kBBITTalignment	@"kBBITTalignment"			// NSNumber (integral) - UITextAlignment, default is left. Include in text dictionary
#define   kBBITTbaseline	@"kBBITTbaseline"			// NSNumber (float), optional - tweak baseline, default is 0
#define   kBBITTcolor		@"kBBITTcolor"				// UIColor, optional - item color, default white (NavigationBars only)
#define kBBITTspace			@"kBBITTspace"				// NSNumber (integral) - empty space


// Option dictionary items: note that you need to let DHBarButtonItem set any (vertical) insets
#define kBBITToptStyle		@"kBBITToptStyle"			// NSNumber, required - UIBarButtonItemStyle
#define kBBITToptFont		@"kBBITToptFont"			// UIFont, optional - default is Bold System Font of size 12
#define kBBITToptPadding	@"kBBITToptPadding"			// NSNumber (float), optional - space between items, default is 0
#define kBBITTimageInsets	@"kBBITTimageInsets"		// NSValue encoded UIEdgeInsets structure, optional
#define kBBITToptionsArray	@"kBBITToptionsArray"		// Array of items which may appear in a given column, optional - first is col 0, second is col1 etc

@interface DHBarButtonItem : UIBarButtonItem

+ (DHBarButtonItem *)itemWithImageItems:(NSArray *)itemsArray options:(NSDictionary *)optDict;

- (void)imageFromItems:(NSArray *)items;

@end

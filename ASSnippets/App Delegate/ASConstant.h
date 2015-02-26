//
//  ASConstant.h
//  ASSnippets
//
//  Created by Atif Saeed on 2/24/15.
//  Copyright (c) 2015 atti14. All rights reserved.
//

#ifndef ASSnippets_ASConstant_h
#define ASSnippets_ASConstant_h

#define kApplauseKey @""

#define kThemeColor [UIColor colorWithRed:10.0/255.0 green:0.0/255.0 blue:33.0/255 alpha:1.0]
#define kBackgroundColor [UIColor colorWithRed:0/255.0 green:87/255.0 blue:173/255.0 alpha:1.0]
#define kTintColor [UIColor colorWithRed:20/255.0 green:200/255.0 blue:255/255.0 alpha:1.0]

typedef enum kASAction {
    kASActionTableView,
    kASActionCompass,
    kASActionCount
}kASAction;

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]



/* Target Check */

#ifdef ASTest

#define kApplicationTitle @"AS Test Target"

#elif ASSni

#else

#define kApplicationTitle @"AS Snippets"

#endif



#endif

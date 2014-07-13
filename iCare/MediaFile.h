//
//  MediaFile.h
//  iCare
//
//  Created by ido zamberg on 1/3/14.
//  Copyright (c) 2014 ido zamberg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MediaFile : NSObject

@property (nonatomic,strong) NSString * fileName;
@property (nonatomic,strong) NSString * fileType;
@property (nonatomic,strong) NSString * title;
@property (nonatomic,strong) NSNumber * level;
@property (nonatomic,strong) NSMutableArray* levels;


@end

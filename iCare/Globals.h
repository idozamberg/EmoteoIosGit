//
//  Globals.h
//  iCare
//
//  Created by ido zamberg on 1/4/14.
//  Copyright (c) 2014 ido zamberg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Globals : NSObject

typedef enum
{
    videoType,
    audioType,
    mixedType
}
exerciseListType;

typedef enum
{
    menuTablePrincipal,
    menuTableExercises,
    menuTableSettings,
    menuTableExerciseType,
    menuTableInformations
    
}menuTableType;

typedef enum
{
    exerciseTypeAudio,
    exerciseTypeVideo,
}exerciseType;

@end

//
//  main.m
//  Google Directions
//
//  Created by Anthony Taylor on 2013-08-30.
//  Copyright (c) 2013 Anthony Taylor. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"

typedef int (*PYStdWriter)(void *, const char *, int);

static PYStdWriter _oldStdWrite;

//Function prototypes
void __iOS7B5CleanConsoleOutput(void);
int __pyStderrWrite(void *inFD, const char *buffer, int size);

int main(int argc, char * argv[])
{
    //Calling the cleaning function
#warning REMOVE BEFORE FLIGHT - disables AssertMacros flood in console in XCode beta 5
    __iOS7B5CleanConsoleOutput();
    
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}

//implemented functions
int __pyStderrWrite(void *inFD, const char *buffer, int size)
{
    if ( strncmp(buffer, "AssertMacros:", 13) == 0 ) {
        return 0;
    }
    return _oldStdWrite(inFD, buffer, size);
}

void __iOS7B5CleanConsoleOutput(void)
{
    _oldStdWrite = stderr->_write;
    stderr->_write = __pyStderrWrite;
    
}
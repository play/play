// playhook.h
// iTunes-hook
//
// Created by https://github.com/holman/play/contributors
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

// Playhook is the evil mastermind that taps into iTunes events.
// It monitors the NotificationCenter for iTunes events and runs
// an application that hooks into Play to let it know an event
// has occurred.
//
@interface PlayHook : NSObject

// Initializes the PlayHook with a String path to the Play hook app
// that runs when an iTunes Event is fired.
- (id) init;

// Called when iTunes fires an event.
//
// Runs the Play hook application.
- (void) sendEvent;

@end

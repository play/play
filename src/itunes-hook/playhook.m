// playhook.m
// iTunes-hook
//
// Playhook hooks into itunes NotificationCenter events and runs
// a Play hook application that communicates iTunes events to Play.
//
// Created by https://github.com/holman/play/contributors
//

#import "playhook.h"

@implementation PlayHook

// Sets up the NotificationCenter hook that catches all events
// and calls PlayHook sendEvent when an iTunes event is fired.
- (id) init
{
    if (self = [super init])
    {
    	NSDistributedNotificationCenter* notificationCenter = [NSDistributedNotificationCenter defaultCenter];
		  NSString* notificationName = @"com.apple.iTunes.playerInfo";
      [notificationCenter addObserverForName:notificationName
      						        object:nil
      						        queue:[NSOperationQueue mainQueue]
      						        usingBlock:^(NSNotification *note) {
		    [self sendEvent];
		  }];
    }
    return self;
}

// Song changed, let the world know.
- (void) sendEvent
{
  fprintf(stdout, "song_changed\n");
}

// Pretend we care about memory leaks by releasing stuff from memory.
- (void) dealloc
{
 	[super dealloc];
}

@end

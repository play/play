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

// Initialize the hook with the path to the Play hook app 
// that will be run when itunes events are fired.
//
// Sets up the NotificationCenter hook that catches all events
// and calls PlayHook sendEvent when an iTunes event is fired.
- (id) initWithStr: (NSString*)inString
{
    if (self = [super init])
    {
      self.playHookPath = inString;

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

// Called whenever iTunes fires an event. Runs the Play hook app to
// let Play know an event has occured.
//
// Prints out any output from the Play hook app.
- (void) sendEvent
{
	NSLog(@"com.apple.iTunes.playerInfo event fired. sending event to play hook.\n");

  NSTask* task = [[NSTask alloc] init];
  [task setLaunchPath:self.playHookPath];

  NSPipe* pipe = [NSPipe pipe];
  [task setStandardOutput:pipe];

  NSFileHandle* outputFileHandle = [pipe fileHandleForReading];

  [task launch];
	[task waitUntilExit];

  NSData* data = [outputFileHandle readDataToEndOfFile];

  if(data)
  {            
    NSString* output = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    printf("%s", [output UTF8String]);
    [output release];
  }

	[task release];
}

// Contains the path and app name of the play hook that is ran
// when iTunes fires an event.
@synthesize playHookPath;

// Cleanup code.
// Pretend we care about memory leaks by releasing stuff from memory.
- (void) dealloc
{
 	[super dealloc];
}

@end

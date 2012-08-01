// itunes-hook.m
// iTunes event notifications hook.
//
// This app hooks into itunes NotificationCenter events and runs
// a Play hook application that communicates iTunes events to Play.
//
// Created by https://github.com/holman/play/contributors
//

#import "playhook.h"

int main (int argc, const char * argv[])
{
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];

	PlayHook* hook = [[PlayHook alloc] init];

	[[NSApplication sharedApplication] run];

	[hook release];
	[pool drain];
	return 0;
}

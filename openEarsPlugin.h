//
//  openEarsPlugin.h
//  rhymble
//
//  Created by Richard Telep on 6/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhoneGapCommand.h"
#import "AudioSessionManager.h"
#import "PocketsphinxController.h"
#import "OpenEarsEventsObserver.h"

@interface openEarsPlugin : PhoneGapCommand <OpenEarsEventsObserverDelegate>{
    AudioSessionManager *audio_session_manager;
    PocketsphinxController *pocket_sphinx_controller;
    OpenEarsEventsObserver *openears_events_observer;
    
}

@property (nonatomic, copy) NSString *successCallback;
@property (nonatomic, copy) NSString *failCallback;

@property (nonatomic, retain) AudioSessionManager *audio_session_manager;
@property (nonatomic, retain) PocketsphinxController *pocket_sphinx_controller;
@property (nonatomic, retain) OpenEarsEventsObserver *openears_events_observer;

- (void)log:(NSString*)msg withDict:(NSDictionary*)options;

- (void)startAudioSession:(NSArray*)arguments withDict:(NSDictionary*)options;

- (void)pocketsphinxControllerStartListening:(NSArray*)arguments withDict:(NSDictionary*)options;
- (void)pocketsphinxControllerStopListening:(NSArray*)arguments withDict:(NSDictionary*)options;
- (void)pocketsphinxControllerSuspendRecognition:(NSArray*)arguments withDict:(NSDictionary*)options;
- (void)pocketsphinxControllerResumeRecognition:(NSArray*)arguments withDict:(NSDictionary*)options;


@end

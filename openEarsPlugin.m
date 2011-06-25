//
//  openEarsPlugin.mm
//  rhymble
//
//  Created by Richard Telep on 6/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "openEarsPlugin.h"

@implementation openEarsPlugin


/*
 *  ++++++++++++++++++++++++++++++++++++++++
 *  Fields
 *  ++++++++++++++++++++++++++++++++++++++++
 */  
@synthesize audio_session_manager;
-(AudioSessionManager *) audio_session_manager{
    if (audio_session_manager == nil){
        audio_session_manager = [[AudioSessionManager alloc] init];
    }
    return audio_session_manager;
}

@synthesize pocket_sphinx_controller;
-(PocketsphinxController *) pocket_sphinx_controller{
    if (pocket_sphinx_controller == nil){
        pocket_sphinx_controller = [[PocketsphinxController alloc] init];
    }
    return pocket_sphinx_controller;
}


@synthesize openears_events_observer;
-(OpenEarsEventsObserver *) openears_events_observer{
    if (openears_events_observer == nil){
        openears_events_observer = [[OpenEarsEventsObserver alloc] init];
    }
    return openears_events_observer;
}

/*
 *  ++++++++++++++++++++++++++++++++++++++++
 *  Callbacks for the PhoneGap Plugin
 *  ++++++++++++++++++++++++++++++++++++++++
 */
@synthesize successCallback, failCallback;

/*
 *  ++++++++++++++++++++++++++++++++++++++++
 *  AudioSessionManager methods
 *  ++++++++++++++++++++++++++++++++++++++++
 */  


-(void)startAudioSession:(NSArray *)arguments withDict:(NSDictionary *)options{
    
    // Start AudioSessionManager
    [self.audio_session_manager startAudioSession];

    // OpenEarsEventsObserver too.
    [self.openears_events_observer setDelegate:self];

    // Handle the callbacks for JS
    NSUInteger argc = [arguments count];
    if (argc < 1) {
		return;	
	}
	self.successCallback = [arguments objectAtIndex:0];
	if (argc > 1) {
		self.failCallback = [arguments objectAtIndex:1];	
	}

}

/*
 *  ++++++++++++++++++++++++++++++++++++++++
 *  Log
 *  ++++++++++++++++++++++++++++++++++++++++
 */

-(void)log:(NSString*)msg withDict:(NSMutableDictionary *)options{
    NSLog(@"%@",msg);
}


/*
 *  ++++++++++++++++++++++++++++++++++++++++
 *  PocketsphinxController methods
 *  ++++++++++++++++++++++++++++++++++++++++
 */

-(void)pocketsphinxControllerStartListening:(NSArray *)arguments withDict:(NSDictionary *)options{
    NSString *lmPath = [NSString stringWithFormat:@"%@/%@",[[NSBundle mainBundle] resourcePath], @"OpenEars1.languagemodel"];
    NSString *dictionaryPath = [NSString stringWithFormat:@"%@/%@",[[NSBundle mainBundle] resourcePath], @"OpenEars1.dic"];
    [self.pocket_sphinx_controller startListeningWithLanguageModelAtPath:lmPath dictionaryAtPath:dictionaryPath languageModelIsJSGF:NO];
}

-(void)pocketsphinxControllerStopListening:(NSArray *)arguments withDict:(NSDictionary *)options{
    [self.pocket_sphinx_controller stopListening];
}

-(void)pocketsphinxControllerSuspendRecognition:(NSArray *)arguments withDict:(NSDictionary *)options{
    [self.pocket_sphinx_controller suspendRecognition];
}

-(void)pocketsphinxControllerResumeRecognition:(NSArray *)arguments withDict:(NSDictionary *)options{
    [self.pocket_sphinx_controller resumeRecognition];
}


/*
 *  ++++++++++++++++++++++++++++++++++++++++
 *  OpenEarsEventsObserver methods
 *  ++++++++++++++++++++++++++++++++++++++++
 */

- (void) pocketsphinxDidReceiveHypothesis:(NSString *)hypothesis recognitionScore:(NSString *)recognitionScore utteranceID:(NSString *)utteranceID {
    NSLog(@"Pocketsphinx received a hypothesis is %@ with a score of %@ and an ID of %@", hypothesis, recognitionScore, utteranceID);

    NSString* jsCallBack = [NSString stringWithFormat:@"%@(\"%@\");", self.successCallback, hypothesis];
	NSLog(jsCallBack);
    [self writeJavascript: jsCallBack];

}

        // There are numerous other methods to implement here.


/*
 *  ++++++++++++++++++++++++++++++++++++++++
 *  Cleanup
 *  ++++++++++++++++++++++++++++++++++++++++
 */

-(void)dealloc {
    [audio_session_manager release];
    [pocket_sphinx_controller release];
    openears_events_observer.delegate = nil;
    [openears_events_observer release];
    [successCallback release];
    [failCallback release];
    [super dealloc];
}




@end

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

@synthesize flite_controller;
-(FliteController *) flite_controller{
    if (flite_controller == nil){
        flite_controller = [[FliteController alloc] init];
    }
    return flite_controller;
}

@synthesize language_model_generator;
-(LanguageModelGenerator *) language_model_generator{
    if (language_model_generator == nil){
        language_model_generator = [[LanguageModelGenerator alloc] init];
    }
    return language_model_generator;
}

@synthesize started_listening;
@synthesize current_language_model;
@synthesize current_dictionary;
@synthesize path_to_dynamic_language_model;
@synthesize path_to_dynamic_grammar;
/*
 *  ++++++++++++++++++++++++++++++++++++++++
 *  AudioSessionManager methods
 *  ++++++++++++++++++++++++++++++++++++++++
 */  


-(void)startAudioSession:(NSArray *)arguments withDict:(NSDictionary *)options{
    
    // Start AudioSessionManager
    [self.audio_session_manager startAudioSession];

    // This class will be the delegate of the OpenEarsEventsObserver object.
    [self.openears_events_observer setDelegate:self];


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

-(void)pocketsphinxControllerStartListeningWithLanguageModelAtPath:(NSArray *)arguments withDict:(NSDictionary *)options{
    self.current_language_model = [NSString stringWithFormat:@"%@/%@",[[NSBundle mainBundle] resourcePath], [arguments objectAtIndex:0]];
    self.current_dictionary = [NSString stringWithFormat:@"%@/%@",[[NSBundle mainBundle] resourcePath], [arguments objectAtIndex:1]];

    NSLog(self.current_language_model);
    NSLog(self.current_dictionary);
    
    // Retrieving the value with a JSGF key from the options dict
    // gives us an object of the NSCFBool class.
    // Finding boolean values in ObjC confusing,
    // I couldn't figure out how else to test the value except this:
    NSString *jsgf_string = [NSString stringWithFormat:@"%@",[options objectForKey:@"JSGF"]];

    // Use JSGF
    if ([jsgf_string isEqualToString:@"1"]){
        [self.pocket_sphinx_controller startListeningWithLanguageModelAtPath:self.current_language_model dictionaryAtPath:self.current_dictionary languageModelIsJSGF:YES];
    } 
    // Use Arpa
    else {
        [self.pocket_sphinx_controller startListeningWithLanguageModelAtPath:self.current_language_model dictionaryAtPath:self.current_dictionary languageModelIsJSGF:NO];
    }
            
    
}

-(void)pocketsphinxControllerChangeLanguageModelToFile:(NSArray *) arguments withDict:(NSDictionary *)options{
    self.current_language_model = [NSString stringWithFormat:@"%@/%@",[[NSBundle mainBundle] resourcePath], [arguments objectAtIndex:0]];
    self.current_dictionary = [NSString stringWithFormat:@"%@/%@",[[NSBundle mainBundle] resourcePath], [arguments objectAtIndex:1]];
    [self.pocket_sphinx_controller changeLanguageModelToFile:self.current_language_model withDictionary:self.current_dictionary];
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
 *  FliteController methods
 *  ++++++++++++++++++++++++++++++++++++++++
 */

-(void)fliteControllerSay:(NSString *)phrase withDict:(NSDictionary *)options{
    NSString* phrase_out = [[NSString alloc] initWithFormat:@"%@",phrase];
    [self.flite_controller say:phrase_out withVoice:@"cmu_us_slt"];
    [phrase_out release];
}

/*
 *  ++++++++++++++++++++++++++++++++++++++++
 *  LanguageModelGenerator methods
 *  ++++++++++++++++++++++++++++++++++++++++
 */
-(void)languageModelGeneratorGenerateLanguageModelFromArray:(NSArray *)arguments withDict:(NSDictionary *)options{
   
    NSString *languageArrayCSV = [arguments objectAtIndex:0];
    NSArray *languageArray = [languageArrayCSV componentsSeparatedByString:@","];
    
	NSError *error = [self.language_model_generator generateLanguageModelFromArray:languageArray withFilesNamed:@"dynamic"];

    NSDictionary *dynamicLanguageGenerationResultsDictionary = nil;
    
    if([error code] != noErr) {
        NSLog(@"Dynamic language generator reported error %@", [error description]);
    } else {
		dynamicLanguageGenerationResultsDictionary = [error userInfo];
        
        NSString *lmFile = [dynamicLanguageGenerationResultsDictionary objectForKey:@"LMFile"];
		NSString *dictionaryFile = [dynamicLanguageGenerationResultsDictionary objectForKey:@"DictionaryFile"];
		NSString *lmPath = [dynamicLanguageGenerationResultsDictionary objectForKey:@"LMPath"];
		NSString *dictionaryPath = [dynamicLanguageGenerationResultsDictionary objectForKey:@"DictionaryPath"];
		
		NSLog(@"Dynamic language generator completed successfully, you can find your new files %@\n and \n%@\n at the paths \n%@ \nand \n%@", lmFile,dictionaryFile,lmPath,dictionaryPath);	
    
        self.path_to_dynamic_language_model = lmPath;
        self.path_to_dynamic_grammar = dictionaryPath;
    
    }
    //[languageArray release];
    if(dynamicLanguageGenerationResultsDictionary){
        NSLog(@"%@",self.path_to_dynamic_language_model);
        NSLog(@"%@",self.path_to_dynamic_grammar);
        
        switch ([self.started_listening intValue]) {
            
            // Pocketsphinx is listening, switch to new language model
            case 1:
                NSLog(@"***Switching to new lm.");
                [self.pocket_sphinx_controller changeLanguageModelToFile:self.path_to_dynamic_language_model withDictionary:self.path_to_dynamic_grammar];
                break;

            // Otherwise, start listening with language model
            default:
                NSLog(@"***Starting with new lm.");
                [self.pocket_sphinx_controller startListeningWithLanguageModelAtPath:self.path_to_dynamic_language_model dictionaryAtPath:self.path_to_dynamic_grammar languageModelIsJSGF:NO];
                break;
        }
        
    }

}


/*
 *  ++++++++++++++++++++++++++++++++++++++++
 *  OpenEarsEventsObserver delegate methods
 *  ++++++++++++++++++++++++++++++++++++++++
 */
- (void) pocketsphinxDidStartListening {
    self.started_listening = [[NSNumber alloc] initWithInteger:1];;
    NSLog(@"Pocketsphinx did start listening");
    NSString* jsString = @"window.plugins.openEarsPlugin.callbacks.pocketsphinxDidStartListening()";
    [self writeJavascript:jsString];
    [jsString release];
}
- (void) pocketsphinxDidStopListening{
    NSLog(@"Pocketsphinx did stop listening");
    NSString* jsString = @"window.plugins.openEarsPlugin.callbacks.pocketsphinxDidStopListening()";
    [self writeJavascript:jsString];
    [jsString release];
    self.started_listening = [[NSNumber alloc] initWithInteger:0];;
}

- (void) pocketsphinxDidSuspendRecognition {
    NSLog(@"Pockesphinx did suspend recognition");
    NSString* jsString = @"window.plugins.openEarsPlugin.callbacks.pocketsphinxDidSuspendRecognition()";
    [self writeJavascript:jsString];
    [jsString release];
} 
- (void) pocketsphinxDidResumeRecognition {
    NSLog(@"Pockesphinx did resume recognition");
    NSString* jsString = @"window.plugins.openEarsPlugin.callbacks.pocketsphinxDidResumeRecognition()";
    [self writeJavascript:jsString];
    [jsString release];
}

- (void) pocketsphinxDidDetectSpeech {
    NSLog(@"Pockesphinx did detect speech");
    NSString* jsString = @"window.plugins.openEarsPlugin.callbacks.pocketsphinxDidDetectSpeech()";
    [self writeJavascript:jsString];
    [jsString release];
}
- (void) pocketsphinxDidDetectFinishedSpeech {
    NSLog(@"Pocketsphinx did detect finished speech");
    NSString* jsString = @"window.plugins.openEarsPlugin.callbacks.pocketsphinxDidDetectFinishedSpeech()";
    [self writeJavascript:jsString];
    [jsString release];
}

- (void) pocketsphinxDidReceiveHypothesis:(NSString *)hypothesis recognitionScore:(NSString *)recognitionScore utteranceID:(NSString *)utteranceID {
    NSLog(@"Pocketsphinx received a hypothesis is %@ with a score of %@ and an ID of %@", hypothesis, recognitionScore, utteranceID);
    NSString* jsString = [[NSString alloc] initWithFormat:@"window.plugins.openEarsPlugin.callbacks.pocketsphinxDidReceiveHypothesis(\"%@\",%@,%@);",hypothesis,recognitionScore,utteranceID];
    [self writeJavascript:jsString];
    [jsString release];
}

- (void) pocketsphinxDidChangeLanguageModelToFile:(NSString *)newLanguageModelPathAsString andDictionary:(NSString *)newDictionaryPathAsString{
    NSString* jsString = @"window.plugins.openEarsPlugin.callbacks.pocketsphinxDidChangeLanguageModelToFile()";
    [self writeJavascript:jsString];
    [jsString release];
}

- (void) audioSessionInterruptionDidBegin{
    NSLog(@"audio session interruption did begin");
}
- (void) audioSessionInterruptionDidEnd{
    NSLog(@"audio session interruption did end");
}
- (void) audioInputDidBecomeUnavailable{
    NSLog(@"audio did become unavailable");
}
- (void) audioInputDidBecomeAvailable{
    NSLog(@"audio input did become available");
}
- (void) audioRouteDidChangeToRoute:(NSString *)newRoute{
    NSLog(@"audio route did change to route: %@", newRoute);
}


/**
 *  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    All OpenEarsEventsObserver delegate methods
    http://www.politepix.com/openears/yourapp#OpenEarsEventsObserver

// Audio Session Status Methods.
- (void) audioSessionInterruptionDidBegin; // There was an interruption.
- (void) audioSessionInterruptionDidEnd; // The interruption ended.
- (void) audioInputDidBecomeUnavailable; // The input became unavailable.
- (void) audioInputDidBecomeAvailable; // The input became available again.
- (void) audioRouteDidChangeToRoute:(NSString *)newRoute; // The audio route changed.

// Pocketsphinx Status Methods.
- (void) pocketsphinxDidStartCalibration; // Pocketsphinx isn't listening yet but it started calibration.
- (void) pocketsphinxDidCompleteCalibration; // Pocketsphinx isn't listening yet but calibration completed.
- (void) pocketsphinxRecognitionLoopDidStart; // Pocketsphinx isn't listening yet but it has entered the main recognition loop.
- (void) pocketsphinxDidStartListening; // Pocketsphinx is now listening.
- (void) pocketsphinxDidDetectSpeech; // Pocketsphinx heard speech and is about to process it.
- (void) pocketsphinxDidDetectFinishedSpeech; // Pocketsphinx detected a second of silence indicating the end of an utterance
- (void) pocketsphinxDidReceiveHypothesis:(NSString *)hypothesis recognitionScore:(NSString *)recognitionScore utteranceID:(NSString *)utteranceID; // Pocketsphinx has a hypothesis.
- (void) pocketsphinxDidStopListening; // Pocketsphinx has exited the continuous listening loop.
- (void) pocketsphinxDidSuspendRecognition; // Pocketsphinx has not exited the continuous listening loop but it will not attempt recognition.
- (void) pocketsphinxDidResumeRecognition; // Pocketsphinx has not exited the continuous listening loop and it will now start attempting recognition again.
- (void) pocketsphinxDidChangeLanguageModelToFile:(NSString *)newLanguageModelPathAsString andDictionary:(NSString *)newDictionaryPathAsString; // Pocketsphinx switched language models inline.
- (void) pocketSphinxContinuousSetupDidFail; // Some aspect of setting up the continuous loop failed, turn on OPENEARSLOGGING for more info.

// Flite Status Methods.
- (void) fliteDidStartSpeaking; // Flite started speaking. You probably don't have to do anything about this.
- (void) fliteDidFinishSpeaking; // Flite finished speaking. You probably don't have to do anything about this.

 *  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 */



/*
 *  ++++++++++++++++++++++++++++++++++++++++
 *  Cleanup
 *  ++++++++++++++++++++++++++++++++++++++++
 */

-(void) dealloc {
    [audio_session_manager release];
    [pocket_sphinx_controller release];
    openears_events_observer.delegate = nil;
    [openears_events_observer release];
    [started_listening release];
    [current_language_model release];
    [current_dictionary release];
    [path_to_dynamic_language_model release];
    [path_to_dynamic_grammar release];
    [super dealloc];
}




@end

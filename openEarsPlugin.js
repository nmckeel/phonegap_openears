/**
 * Phonegap OpenEars Plugin
 */
var OpenEarsPlugin = function() {};

OpenEarsPlugin.prototype.callbacks = {};
OpenEarsPlugin.hypothesis = {};

OpenEarsPlugin.prototype.isValidHypothesis = function(hypothesis){
    return hypothesis != '' && hypothesis != '(null)';
}

OpenEarsPlugin.prototype.setCallback = function(name, fn){
    OpenEarsPlugin.prototype.callbacks[name] = fn;
}

OpenEarsPlugin.prototype.log = function(msg){
    $('#log').append('<h1>'+msg+'</h1>');
    PhoneGap.exec('openEarsPlugin.log',msg);
};

OpenEarsPlugin.prototype.startAudioSession = function(){
    PhoneGap.exec('openEarsPlugin.startAudioSession');
};

OpenEarsPlugin.prototype.startListeningWithLanguageModelAtPath = function(options){
    PhoneGap.exec('openEarsPlugin.pocketsphinxControllerStartListeningWithLanguageModelAtPath',options.languagemodel, options.dictionary, options);
};

OpenEarsPlugin.prototype.changeLanguageModelToFile = function(options){
    PhoneGap.exec('openEarsPlugin.pocketsphinxControllerChangeLanguageModelToFile', options.languagemodel, options.dictionary);
}

OpenEarsPlugin.prototype.generateLanguageModel = function(languageArrayCSV){
    PhoneGap.exec('openEarsPlugin.languageModelGeneratorGenerateLanguageModelFromArray',languageArrayCSV);
}


OpenEarsPlugin.prototype.stopListening = function(){
    PhoneGap.exec('openEarsPlugin.pocketsphinxControllerStopListening');
};

OpenEarsPlugin.prototype.suspendRecognition = function(){
    PhoneGap.exec('openEarsPlugin.pocketsphinxControllerSuspendRecognition');
};

OpenEarsPlugin.prototype.resumeRecognition = function(){
    PhoneGap.exec('openEarsPlugin.pocketsphinxControllerResumeRecognition');
};

OpenEarsPlugin.prototype.say = function(phrase){
    PhoneGap.exec('openEarsPlugin.fliteControllerSay',phrase);
};


PhoneGap.addConstructor(function() {
    if(!window.plugins){window.plugins = {};}
    window.plugins.openEarsPlugin = new OpenEarsPlugin();
    
    // Did start listening
    window.plugins.openEarsPlugin.setCallback('pocketsphinxDidStartListening', function(){
        $(document).trigger('didstartlistening');
    });

    // Did stop listening
    window.plugins.openEarsPlugin.setCallback('pocketsphinxDidStopListening', function(){
        $(document).trigger('didstoplistening');
    });

    // Did detect speech
    window.plugins.openEarsPlugin.setCallback('pocketsphinxDidDetectSpeech', function(){
	$(document).trigger('diddetectspeech');
    });

    // Did detect finished speech
    window.plugins.openEarsPlugin.setCallback('pocketsphinxDidDetectFinishedSpeech', function(){
	$(document).trigger('diddetectfinishedspeech');
    });

    // Did change language model
    window.plugins.openEarsPlugin.setCallback('pocketsphinxDidChangeLanguageModelToFile', function(){
	$(document).trigger('didchangelanguagemodel');
    });

    // Did receive hypothesis
    window.plugins.openEarsPlugin.setCallback('pocketsphinxDidReceiveHypothesis', function(hypothesis, recognitionScore, utteranceID){
	window.plugins.openEarsPlugin.hypothesis = {
                hypothesis: hypothesis
            ,   recognitionScore: recognitionScore
            ,   utteranceID: utteranceID
        }
        $(document).trigger('didreceivehypothesis');
    });

    // Did suspend recognition
    window.plugins.openEarsPlugin.setCallback('pocketsphinxDidSuspendRecognition', function(){
	$(document).trigger('didsuspendrecognition');
    });

    // Did resume recognition
    window.plugins.openEarsPlugin.setCallback('pocketsphinxDidResumeRecognition', function(){
	$(document).trigger('didresumerecognition');
    });
    
    
});





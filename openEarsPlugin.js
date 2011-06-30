/**
 * Phonegap OpenEars Plugin
 */
var OpenEarsPlugin = function() {};

OpenEarsPlugin.prototype.callbacks = {};

OpenEarsPlugin.prototype.setCallback = function(name, fn){
    OpenEarsPlugin.prototype.callbacks[name] = fn;
}

OpenEarsPlugin.prototype.log = function(msg){
    $('#log').append('<h1>'+msg+'</h1>');
    PhoneGap.exec('openEarsPlugin.log',msg);
};

OpenEarsPlugin.prototype.startAudioSession = function(){
    this.log('Starting Audio Session.');
    PhoneGap.exec('openEarsPlugin.startAudioSession');
};

OpenEarsPlugin.prototype.startListeningWithLanguageModelAtPath = function(options){
    this.log('Starting Listening.');
    PhoneGap.exec('openEarsPlugin.pocketsphinxControllerStartListeningWithLanguageModelAtPath',options.languagemodel, options.dictionary);
};

OpenEarsPlugin.prototype.changeLanguageModelToFile = function(options){
    this.log("openEarsPLugin.js, Changing Language Model to "+options.languagemodel);
    PhoneGap.exec('openEarsPlugin.pocketsphinxControllerChangeLanguageModelToFile', options.languagemodel, options.dictionary);
}

OpenEarsPlugin.prototype.generateLanguageModel = function(languageArrayCSV){
    this.log("openEarsPLugin.js, generating language model");
    PhoneGap.exec('openEarsPlugin.languageModelGeneratorGenerateLanguageModelFromArray',languageArrayCSV);
}


OpenEarsPlugin.prototype.stopListening = function(){
    this.log('Stopping Listening.');
    PhoneGap.exec('openEarsPlugin.pocketsphinxControllerStopListening','foo');
};

OpenEarsPlugin.prototype.suspendRecognition = function(){
    this.log('Suspending Recognition.');
    PhoneGap.exec('openEarsPlugin.pocketsphinxControllerSuspendRecognition','foo');
};

OpenEarsPlugin.prototype.resumeRecognition = function(){
    this.log('Resuming Recognition.');
    PhoneGap.exec('openEarsPlugin.pocketsphinxControllerResumeRecognition','foo');
};

OpenEarsPlugin.prototype.say = function(phrase){
    PhoneGap.exec('openEarsPlugin.fliteControllerSay',phrase);
};


PhoneGap.addConstructor(function() {
    if(!window.plugins){window.plugins = {};}
    window.plugins.openEarsPlugin = new OpenEarsPlugin();
});





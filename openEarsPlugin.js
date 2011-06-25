/**
 * Phonegap OpenEars Plugin
 */
var OpenEarsPlugin = function() {};

OpenEarsPlugin.prototype.log = function(msg){
    $('#log').append('<h1>'+msg+'</h1>');
    PhoneGap.exec('openEarsPlugin.log',msg);
};

OpenEarsPlugin.prototype.startAudioSession = function(success, fail){
    this.log('Starting Audio Session.');
    PhoneGap.exec('openEarsPlugin.startAudioSession', GetFunctionName(success), GetFunctionName(fail));
};

OpenEarsPlugin.prototype.startListening = function(){
    this.log('Starting Listening.');
    PhoneGap.exec('openEarsPlugin.pocketsphinxControllerStartListening', 'foo');
};

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


PhoneGap.addConstructor(function() {
    if(!window.plugins){window.plugins = {};}
    window.plugins.openEarsPlugin = new OpenEarsPlugin();
});




/**

    function openEarsPlugin(){
    var OpenEarsPlugin = this;
    
    OpenEarsPlugin.log = function(msg){
        $('#log').append('<h1>'+msg+'</h1>');
        PhoneGap.exec('openEarsPlugin.log',msg);
    };

    OpenEarsPlugin.startAudioSession = function(success, fail){
        OpenEarsPlugin.log('Starting Audio Session.');
        PhoneGap.exec('openEarsPlugin.startAudioSession', success, fail);
    };
 
    OpenEarsPlugin.startListening = function(){
        OpenEarsPlugin.log('Starting Listening.');
        PhoneGap.exec('openEarsPlugin.pocketsphinxControllerStartListening', 'foo');
    };

    OpenEarsPlugin.stopListening = function(){
        OpenEarsPlugin.log('Stopping Listening.');
        PhoneGap.exec('openEarsPlugin.pocketsphinxControllerStopListening','foo');
    };

    OpenEarsPlugin.suspendRecognition = function(){
        OpenEarsPlugin.log('Suspending Recognition.');
        PhoneGap.exec('openEarsPlugin.pocketsphinxControllerSuspendRecognition','foo');
    };

    OpenEarsPlugin.resumeRecognition = function(){
        OpenEarsPlugin.log('Resuming Recognition.');
        PhoneGap.exec('openEarsPlugin.pocketsphinxControllerResumeRecognition','foo');
    };

}

**/

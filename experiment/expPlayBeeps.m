function [] = expPlayBeeps(screen,blink_number,block,requester,eyetracking)
%%
sendETNotifications(eyetracking,requester,sprintf('BLINK start, block %d', block))

drawTarget(screen.screen_width/2, screen.screen_height/2,screen,20,'fixcross');
LastFlip = flip_screen(screen);

nrchannels = 2;
freq = 48000;
waitForDeviceStart = 1;
% How many times to we wish to play the sound
repetitions = 1;
% Length of the beep
beepLengthSecs = 0.1;
% Length of the pause between beeps
beepPauseTime = 1.5 - beepLengthSecs;

devs = PsychPortAudio('GetDevices')
fprintf('XXX TODO AUTO FIND USB DEVICE')
pahandle = PsychPortAudio('Open',  6, 1, 1, freq, nrchannels);
PsychPortAudio('Volume', pahandle, 1);
basefreq  = 300;
myBeep = MakeBeep(basefreq, beepLengthSecs, freq);
% myBeep = myBeep + 0.5 * MakeBeep(basefreq*6, beepLengthSecs, freq);
% myBeep = myBeep + 0.25 * MakeBeep(basefreq*12, beepLengthSecs, freq);

startCue = 0;
PsychPortAudio('FillBuffer', pahandle, [myBeep; myBeep]);

for beep = 1:blink_number
    PsychPortAudio('Start', pahandle, repetitions, startCue, waitForDeviceStart);
    [actualStartTime, ~, ~, estStopTime] = PsychPortAudio('Stop', pahandle, 1, 1);
    sendETNotifications(eyetracking,requester,sprintf('BLINK beep %d block %d',beep,block))
    
    % Compute new start time for follow-up beep, beepPauseTime after end of
    % previous one
    startCue = estStopTime + beepPauseTime;

end
% Close the audio device
PsychPortAudio('Close', pahandle);
sendETNotifications(eyetracking,requester,sprintf('BLINK stop, block %d', block))

LastFlip = flip_screen(screen);

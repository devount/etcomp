function [ ] = expMicrosaccades(screen, time, eyetracking, requester, block)
showInstruction('MICROSACC',screen,requester,eyetracking, block);
drawTarget(screen.screen_width/2, screen.screen_height/2,screen,20,'fixbulleye');
LastFlip = flip_screen(screen,time);
sendETNotifications(eyetracking,requester,sprintf('MICROSACC start block %d',block))


LastFlip = flip_screen(screen, LastFlip +time);
sendETNotifications(eyetracking,requester,sprintf('MICROSACC stop block %d',block))

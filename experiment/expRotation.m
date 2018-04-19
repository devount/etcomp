function [] = expRotation(type,screen, eyetracking, requester, block)
% YAW and ROLL conditions
showInstruction(type,screen,requester,eyetracking, block);

centerX = screen.screen_width/2;
centerY = screen.screen_height/2;
sendETNotifications(eyetracking,requester,sprintf('Rotation type %s block %d',type,block))

if strcmp(type, 'SHAKE')
    dist = centerX/3
    l = dist;
    lm = dist*2;
    rm = screen.screen_width -2*dist;
    r = screen.screen_width -dist;
    coordX = [l lm rm r];
    for count =1 : 4
        drawTarget(centerX,centerY,screen,20,'fixcross');
        flip_screen(screen,2);
        sendETNotifications(eyetracking,requester,sprintf('Rotation type %s block %d center',type,block))

        KbStrokeWait(); 


        drawTarget(coordX(count),centerY,screen,20,'fixcross');
        flip_screen(screen,2);
        sendETNotifications(eyetracking,requester,sprintf('Rotation type %s block %d x %d, y %d',type,block, coordX(count),centerY));

        KbStrokeWait(); 



    end
    
    
    
else strcmp(type, 'TILD')
    
    
end

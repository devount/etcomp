function dispInstructions (nameIns,const,visual)% display instructions%%% Text settingsScreen('Preference', 'TextRenderer',0); Screen('TextFont',visual.main,'Courier Standard');Screen('TextSize',visual.main,18);% Read instruction filefin=fopen(nameIns,'r');cnt=1; instruction={};while ~feof(fin) && cnt~=0    [s,cnt]=fscanf(fin,'%s',1);    instruction=[instruction cellstr(s)];endfclose(fin);x=100; ya=15; y=ya; last=0;nzeichen=85;col=[256 0 0]Screen('FillRect',visual.main,col,[]);Screen('Flip',visual.main);% Display instructionif strcmp(instruction(1),'\n')    y=y+35;    pins='';    absatz=1;else    pins=char(instruction(1));    absatz=0;endfor i=2:length(instruction)    if length(pins)+length(char(instruction(i)))>nzeichen && ~strcmp(instruction(i),'\n')==1        y=y+35;        Screen('DrawText',visual.main,pins,x,y,[0 0 0]);        pins=sprintf('%s',char(instruction(i)));        x=100;    elseif strcmp(instruction(i),'\n')==1        y=y+35;        Screen('DrawText',visual.main,pins,x,y,[0 0 0]);        pins='';        y=y+40;        x=100;        absatz=1;    elseif strcmp(instruction(i),'\b')==1        y=y+35;        Screen('DrawText',visual.main,pins,x,y,[0 0 0]);        pins='';        y=const.MoHigh-100;        x=100;        absatz=1;        last=1;    elseif strcmp(instruction(i),'\s')==1        y=y+35;        Screen('DrawText',visual.main,pins,x,y,[0 0 0]);        pins='';        x=100;        absatz=1;    elseif strcmp(instruction(i),'\n\n')==1        y=y+35;        Screen('DrawText',visual.main,pins,x,y,[0 0 0]);        pins='';        y=2000;        x=100;        absatz=1;    else        if absatz == 1            pins=sprintf('%s',char(instruction(i)));            absatz=0;        else            pins=sprintf('%s %s',pins,char(instruction(i)));        end    end    if y >= 900 && i<length(instruction) && last==0        % Taste gedr�ckt?        Screen('DrawText',visual.main,'Weiter mit der Leertaste.',100,924,[0 0 0]);        Screen('Flip',visual.main);        waitForResponse;        Screen(visual.main,'FillRect',const.bgCol*256,[]);        Screen('Flip',visual.main);        y=ya;    endendScreen('Flip',visual.main);% Taste gedr�ckt?waitForResponse;Screen(visual.main,'FillRect',const.bgCol*256,[]);Screen('Flip',visual.main);
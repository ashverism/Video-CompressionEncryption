%Helper adopted function and not used in code
clear all
clc
close all
info=imaqhwinfo
info.InstalledAdaptors
clear all
clc
pause
vidobj=videoinput('winvideo',1);
vidobj.FramesPerTrigger=100;
vidobj.TriggerFrameDelay = 5;
src=getselectedsource(vidobj);
frameRates = set(src,'FrameRate')
src.FrameRate = frameRates{1};
actualRate = str2num( frameRates{1} )
preview(vidobj)
pause
start(vidobj)
waittime = actualRate * (vidobj.FramesPerTrigger + vidobj.TriggerFrameDelay) + 5
wait(vidobj,waittime);
[frames,timeStamp]=getdata(vidobj);
plot(timeStamp,'x')
xlabel('Frame Index')
ylabel('Time(s)')
pause
montage(frames),title('The 50 frames displayed as yuv frames')
str2=size(frames);
disp('The frame info is as follows')
disp(str2)
pause
num_frames=size(frames,4);
str=sprintf('The number of frames is %d.',num_frames);
disp(str)
events=vidobj.EventLog
events.Type
events.Data
pause
stop(vidobj);
closepreview(vidobj)
pause
closepreview(vidobj)

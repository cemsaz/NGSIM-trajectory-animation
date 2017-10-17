
% Cem Sazara - October 2017
% 
% Animation of NGSIM I-80 Vehicle Trajectories


load('trajectories.mat')

% Section limits can be adjusted, here it is 200-800 feets (600 feets long)
sectionLimits = [200 800];

% Limits of x-y axis
xLimit = [sectionLimits(1)-5 sectionLimits(2)+5];
yLimit = [-170 250];

Frames = unique(trajectories(:,2));

for i=1:length(Frames)
    frameData = trajectories(trajectories(:,2)==Frames(i) & ...
        trajectories(:,6)>=sectionLimits(1) & ...
        trajectories(:,6)<=sectionLimits(2),:);
    
    if isempty(frameData)
       continue; 
    end
    
    % Get needed fields
    lateralPos = frameData(:,5);
    longitudePos = frameData(:,6);
    id = num2str(frameData(:,1));
    len = frameData(:,9);
    width = frameData(:,10);
    class = frameData(:,11);
    
    % Construct vehicle bounding boxes
    boundingBoxArr = [longitudePos-len lateralPos-width/2 len width];
    
    % Set title
    title(strcat('Animation of NGSIM trajectories - frame: ', num2str(Frames(i))))
    
    % Plot road boundaries
    line(xLimit,[0 0],'Color','blue','LineStyle','--')
    line(xLimit,[100 100],'Color','blue','LineStyle','--')
    
    % Plot vehicle bounding boxes according to vehicle class
    % Red -> Motorcycle, Yellow-> Auto, Green-> Truck
    for j=1:length(boundingBoxArr(:,1))
        hold on
        if(class(j) == 1)
            rectangle('Position', boundingBoxArr(j,:), 'FaceColor', [1 0 0])
        elseif (class(j) == 2)
            rectangle('Position', boundingBoxArr(j,:), 'FaceColor', [1 1 0])
        else
            rectangle('Position', boundingBoxArr(j,:), 'FaceColor', [0 1 0])
        end
    end
    
    % Add vehicle id to each vehicle
    text(longitudePos-2*len/3,lateralPos,id, 'color', 'b', 'Margin', 0.1, 'FontSize',8, 'clipping','on')
    
    % Create custom legend for vehicle classes
    h = zeros(3, 1);
    h(1) = plot(NaN,NaN,'sr', 'MarkerFaceColor',[1,0,0]);
    h(2) = plot(NaN,NaN,'sy', 'MarkerFaceColor',[1,1,0]);
    h(3) = plot(NaN,NaN,'sg', 'MarkerFaceColor',[0,1,0]);
    lgd = legend(h, 'Motorcycle','Auto','Truck', 'Location','northeast');
    set(lgd,'FontSize',14)
    
    xlim(xLimit)
    ylim(yLimit)
    xlabel('Longitude (feet)')
    ylabel('Lateral (feet)')
    
    set(gca,'Ydir','reverse')
    grid on
    
    pause(0.001)
    clf('reset')
end


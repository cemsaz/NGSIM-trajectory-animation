
% Cem Sazara
% Animation of NGSIM I-80 Vehicle Trajectories
% Visualizes longitude positions only between 30-600 feets

load('trajectories.mat')

Frames = unique(trajectories(:,2));

for i=1:length(Frames)
    frameData = trajectories(trajectories(:,2)==Frames(i),:);
    
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
    line([30 630],[0 0],'Color','blue','LineStyle','--')
    line([30 630],[100 100],'Color','blue','LineStyle','--')
    
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
    text(longitudePos-2*len/3,lateralPos,id, 'color', 'b', 'Margin', 0.1)
    
    % Create custom legend for vehicle classes
    h = zeros(3, 1);
    h(1) = plot(NaN,NaN,'sr', 'MarkerFaceColor',[1,0,0]);
    h(2) = plot(NaN,NaN,'sy', 'MarkerFaceColor',[1,1,0]);
    h(3) = plot(NaN,NaN,'sg', 'MarkerFaceColor',[0,1,0]);
    lgd = legend(h, 'Motorcycle','Auto','Truck', 'Location','northeast');
    set(lgd,'FontSize',14)
    
    xlim([30 630])
    ylim([-170 250])
    xlabel('Longitude (feet)')
    ylabel('Latitude (feet)')
    
    set(gca,'Ydir','reverse')
    grid on
    pause(0.001)
    clf('reset')
end


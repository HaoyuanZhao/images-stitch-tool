imageDir = fullfile("input_images");
imageData = imageDatastore(imageDir);
numImages = numel(imageData.Files);
imageSize = zeros(numImages,2);
images = {};
for i = 1:numImages
   images{end + 1} = im2gray(im2double(readimage(imageData,i)));
   imageSize(i,:) = size(images{i});
end

my_fast_feature = {};
for i = 1:numImages
    my_fast_feature{end + 1} = my_fast_detector(images{i}, 0.3);
end

fastR_feature = {};
for i = 1:numImages
    %Using AND operation to drop the weak corner in FAST
    fastR_feature{end + 1} = harris_detector(images{i}, 0.001) & my_fast_feature{i};
end

%First calculate the feature for the frist image:
[feature, pts] = extractFeatures(images{1}, map_to_loc(fastR_feature{1}));
tforms(numImages) = projective2d(eye(3));

for i = 2:numImages
   prev_feature = feature; 
   prev_pts = pts;

   [feature, pts] = extractFeatures(images{i}, map_to_loc(fastR_feature{i}));
   matched_index = matchFeatures(feature, prev_feature, 'Unique', true);
   matched_pts = pts(matched_index(:, 1), :);
   matched_prev_pts = prev_pts(matched_index(:, 2), :);

   tforms(i)= estimateGeometricTransform2D(matched_pts, matched_prev_pts, ...
       'projective', 'Confidence', 99.9, 'MaxNumTrials', 2000);

   %If we have images >=2, the third image is base on the second image,
   %and we need all images base on the first image.
   tforms(i).T = tforms(i).T * tforms(i-1).T;
end 

%Find the frame size for panorama, some code are from Matlab
%documentation
for i = 1:numel(tforms)
    [xlim(i,:), ylim(i,:)] = outputLimits(tforms(i), [1 imageSize(i,2)], [1 imageSize(i,1)]);
end

maxImageSize = max(imageSize);

xMin = min([1; xlim(:)]);
xMax = max([maxImageSize(2); xlim(:)]);

yMin = min([1; ylim(:)]);
yMax = max([maxImageSize(1); ylim(:)]);

width  = round(xMax - xMin);
height = round(yMax - yMin);

blender = vision.AlphaBlender('Operation', 'Binary mask', ...
'MaskSource', 'Input port');  

panorama = zeros([height width 3], 'like', readimage(imageData, 1));
xLimits = [xMin xMax];
yLimits = [yMin yMax];
panoramaView = imref2d([height width], xLimits, yLimits);

for i = 1:numel(tforms)
    I = readimage(imageData, i);
    Ir = imwarp(I, tforms(i), 'OutputView', panoramaView);
    mask = imwarp(true(size(I, 1), size(I, 2)), tforms(i), 'OutputView', panoramaView); 
    panorama = step(blender, panorama, Ir, mask);
end

imwrite(panorama, "output_image.png", 'png');

clear

function result = map_to_loc(img)
    [row, col] = find(img);
    result = [col row];
end




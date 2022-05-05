function out = test_DT_split (bw_img, options, img, recurrent_idx)

out = [];

bw_img = logical(bw_img);

% B = bwboundaries(bw_img, 8,'noholes');
% B_length = cellfun(@length, B);
% B_big = B{find(B_length == max(B_length),1)};

s = regionprops(bw_img, 'Centroid', 'Area', 'Perimeter','Solidity', 'Eccentricity','Orientation', 'MajorAxisLength', 'MinorAxisLength', 'PixelList', 'PixelIdxList', 'BoundingBox');
s_max = s( find( ([s.Area]) == max([s.Area]) , 1) );

bw_object = true(size(bw_img));
bw_object(s_max.PixelIdxList) = false;

%% fgm (foreground markers)
D = bwdist(imcomplement(bw_img));
%D_thresh = max(D(:)) * options.T ;
D_thresh = (max(D(:)) * options.T) + (recurrent_idx-1) ;


D_new = D >= D_thresh;

% img_locMax = zeros(size(D));
% img_locMax(ind_maxima) = 1;
fgm = logical(D_new);


%% bgm (background markers)
    [m1,n1] = size(bw_object);
    expand = 10;
    big_DAB = logical(ones(m1+expand, n1+expand) * 255);
    big_DAB((1+expand/2):(1+expand/2)+m1-1, (1+expand/2):(1+expand/2)+n1-1) = bw_object;

D = bwdist( imcomplement(big_DAB)); %imcomplement
DL = watershed(D);
bgm = DL == 0;

bgm = bgm((1+expand/2):(1+expand/2)+m1-1, (1+expand/2):(1+expand/2)+n1-1);

%figure(99); imagesc(bgm); colormap('gray'); title('Watershed ridge lines (bgm)')

%% watershed
if options.gradientOnBW
    [gradmag, Gdir] = imgradient(bw_object,'CentralDifference');
else
    [gradmag, Gdir] = imgradient(img,'CentralDifference');
end
%gradmag2 = imimposemin(gradmag, bgm | fgm4);
gradmag2 = imimposemin(gradmag, bgm | fgm);
L = watershed(gradmag2);

if options.visualize1
    Lrgb = label2rgb(L, 'jet', 'w', 'shuffle');
    figure;imagesc(bw_object);hold on;
    himage = imagesc(Lrgb);
    himage.AlphaData = 0.3;
    title(['test DT split, with T=max*', num2str(options.T) ]);
end

out = bw_img;
out( imdilate(L == 0, ones(3, 3)) ) = false;
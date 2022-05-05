function [out, recurrent_idx]  = fun_boundryBasedSplit3 (bw_img, options, recurrent_idx, obj_num, current_img)

out = bw_img;
recurrent_idx = recurrent_idx + 1;
if recurrent_idx > options.max_recurr %7 / 30
    return;
end

s = regionprops(logical(bw_img), 'Centroid', 'Area', 'Perimeter', 'Solidity', 'Eccentricity','BoundingBox', 'PixelList');

% if length(s) < 2
%     out = bw_img;
%     return;
% end

%s = fun_classify_clasteroid (s);
if strcmpi(options.dataset, 'Lipsym')
    s = fun_classify_clasteroid_lipsym (s); % #TEMP
else
    s = fun_classify_clasteroid (s); % #TEMP
end


for k = 1:length(s)
    
    %if s(k).clasteroid == 2 || s(k).clasteroid == 1 % mod 11.06.2019
    if s(k).clasteroid ~= 0
    
        
    if s(k).clasteroid < 4 && recurrent_idx > 7 % mod 11.06.2019
        return;
    end
        
        current_obj = extract_obj (bw_img, s(k) );
        %current_obj = imcrop(bw_img, s(k).BoundingBox);
        
        
        
        % waterSeeded, DT, Hminima, huang, mouelhi, kong
        
        switch lower(options.method)
            case 'waterseeded'
                out_split = test_waterSeeded_split (bw_img, options.waterseeded, current_img);
            case 'dt'
                current_cluster_class = s(k).clasteroid;
                out_split = test_DT_split2 (current_obj, options.dt, current_img, current_cluster_class, recurrent_idx);
            case 'hminima'
                out_split = test_Hminima_split (current_obj, options.hminima, current_img);
            case 'huang'
                out_split = test_huang_split (current_obj, options.huang, current_img);
            case 'mouelhi'
                out_split = test_mouelhi_split (current_obj, options.mouelhi);
            case 'kong'
                out_split = test_kong_split2 (current_obj, options.kong);

            %figure;imshowpair(current_obj,out_split_mouelhi,'montage');
            otherwise
                out_split = bw_img;
                
        end
        
        % mod 09.04.2020
        bw_img = paste_obj2img ( bw_img, s(k), out_split );
        % end mod
%         if exist('out_bw_img', 'var')
%             out_bw_img = paste_obj2img ( out_bw_img, s(k), out_split );
%         else
%             out_bw_img = paste_obj2img ( bw_img, s(k), out_split );
%         end
        
        
        
    end
end
% mod 09.04.2020
out_bw_img = bw_img;
% end mod

if exist('out_bw_img', 'var') && ~isempty(s)
    s = regionprops(logical(out_bw_img), 'Centroid', 'Area', 'Perimeter', 'Solidity', 'Eccentricity','BoundingBox', 'PixelList');
    %s = fun_classify_clasteroid (s);
    if strcmpi(options.dataset, 'Lipsym')
        s = fun_classify_clasteroid_lipsym (s); % #TEMP
    else
        s = fun_classify_clasteroid (s); % #TEMP
    end
    
    % recurrent continue criteria
    %if length(find([s.clasteroid] == 2)) ~= 0  || length(find([s.clasteroid] == 1)) ~= 0
    if ~isempty(s) && (length(find([s.clasteroid] ~= 0)) ~= 0)    
        if options.show
            figure;
            subplot(2,1,1);imagesc(out_bw_img);title('recurr');drawnow;
        end
        
        if obj_num < length(s)
            recurrent_idx = 1;
            obj_num = length(s);
        end
        
        
        
%         if ~(strcmpi(options.method, 'dt')) || ( length(find([s.clasteroid] == 3)) == 0 && length(find([s.clasteroid] == 4)) == 0 && length(find([s.clasteroid] == 5)) == 0 && length(find([s.clasteroid] == 11)) == 0 ) && recurrent_idx > 7
%             return;
%         end
        
        
%         % recurrent function invoking
%         [out_bw_img, recurrent_idx] = fun_boundryBasedSplit2 (out_bw_img, options, recurrent_idx, obj_num, current_img);
        


        if regexpi( lower(options.dataset), lower('BBBC004') )
            % recurrent function invoking / MOD 17.06.2019
            
            if ( length(find([s.clasteroid] == 3)) == 0 && length(find([s.clasteroid] == 4)) == 0 && length(find([s.clasteroid] == 5)) == 0 && length(find([s.clasteroid] == 11)) == 0) && recurrent_idx > 7
                return;
            end
            
            if (strcmpi(options.method, 'dt'))
                [out_bw_img, recurrent_idx] = fun_boundryBasedSplit3 (out_bw_img, options, recurrent_idx, obj_num, current_img);
            elseif (strcmpi(options.method, 'kong'))
                if ~(length(find([s.Area] > 600 )) == 0)
                    [out_bw_img, recurrent_idx] = fun_boundryBasedSplit3 (out_bw_img, options, recurrent_idx, obj_num, current_img);
                end
            elseif (strcmpi(options.method, 'waterseeded')) || (strcmpi(options.method, 'hminima')) || (strcmpi(options.method, 'huang')) || (strcmpi(options.method, 'mouelhi'))
                if recurrent_idx > 1
                    return;
                end
            else
                if ~(length(find([s.clasteroid] < 3 )) == 0)
                    [out_bw_img, recurrent_idx] = fun_boundryBasedSplit3 (out_bw_img, options, recurrent_idx, obj_num, current_img);
                else
                    return;
                end
            end
            
        elseif regexpi( lower(options.dataset), lower('Lipsym') )
            
            % recurrent continue criteria
            if length(find([s.clasteroid] == 2)) ~= 0  || length(find([s.clasteroid] == 1)) ~= 0
                if options.show
                    figure;
                    subplot(2,1,1);imagesc(out_bw_img);title('recurr');drawnow;
                end

                % recurrent function invoking
                [out_bw_img, recurrent_idx] = fun_boundryBasedSplit3 (out_bw_img, options, recurrent_idx, obj_num, current_img);
            end
        
        else %IISPV dataset
            for k_s = 1:length(s)
                if s(k_s).clasteroid==3 || s(k_s).clasteroid==4 || s(k_s).clasteroid==5 || s(k_s).clasteroid==6 || s(k_s).clasteroid==11
                    s(k_s).clasteroid = 1;
                end
            end
            
            if recurrent_idx > 1 && ((strcmpi(options.method, 'waterseeded')) || (strcmpi(options.method, 'hminima')) || (strcmpi(options.method, 'huang')) || (strcmpi(options.method, 'mouelhi')))
                return;
            elseif (strcmpi(options.method, 'kong')) && (length(find([s.Area] > 600 )) == 0)
                return;
            end
            
            [out_bw_img, recurrent_idx] = fun_boundryBasedSplit3 (out_bw_img, options, recurrent_idx, obj_num, current_img);
            
        end
        
        
        if options.show
            subplot(2,1,2);imagesc(out_bw_img);title('post');drawnow;
        end
        
    end
    
end



% if options.kong.do
%     out = test_kong_split2 (bw_img, options.kong);
% end


if exist('out_bw_img', 'var')
    out = out_bw_img; % #TEMP
end


function out_img = extract_obj (bw_img, s_1 )
out_img = false(size(bw_img));

x = s_1.PixelList(:,1);
y = s_1.PixelList(:,2);
out_img(sub2ind(size(bw_img),y,x)) = 1;
%out_img(s_1.PixelList) = true;



function out_bw_img = paste_obj2img ( bw_img, s_1, obj2paste )

out_bw_img = bw_img;

%obj_rect = lr_fromIMcrop (bw_img, s_1.BoundingBox) ;
%out_bw_img( obj_rect(1):obj_rect(2), obj_rect(3):obj_rect(4) ) = 0;

%remove unsplit object
x = s_1.PixelList(:,1) ;%+  floor(s_1.BoundingBox(1));
y = s_1.PixelList(:,2) ;%+  floor(s_1.BoundingBox(2));
out_bw_img(sub2ind(size(out_bw_img),y,x)) = 0;

%paste splitted objects
idx2paste = find(obj2paste);
[y2paste, x2paste] = ind2sub(size(obj2paste), idx2paste);
%y = y2paste +  floor(s_1.BoundingBox(1));
%x = x2paste +  floor(s_1.BoundingBox(2));
%out_bw_img(sub2ind(size(out_bw_img),y,x)) = 1;
out_bw_img(sub2ind(size(out_bw_img),y2paste,x2paste)) = 1;



function out = lr_fromIMcrop (a, spatial_rect) 
%input: img, boundingBox

x = [1 size(a,2)];
y = [1 size(a,1)];

m = size(a,1);
n = size(a,2);
xmin = min(x(:));
ymin = min(y(:));
xmax = max(x(:));
ymax = max(y(:));

% Transform rectangle into row and column indices.
if (m == 1)
    pixelsPerVerticalUnit = 1;
else
    pixelsPerVerticalUnit = (m - 1) / (ymax - ymin);
end
if (n == 1)
    pixelsPerHorizUnit = 1;
else
    pixelsPerHorizUnit = (n - 1) / (xmax - xmin);
end

pixelHeight = spatial_rect(4) * pixelsPerVerticalUnit;
pixelWidth = spatial_rect(3) * pixelsPerHorizUnit;
r1 = (spatial_rect(2) - ymin) * pixelsPerVerticalUnit + 1;
c1 = (spatial_rect(1) - xmin) * pixelsPerHorizUnit + 1;
r2 = round(r1 + pixelHeight);
c2 = round(c1 + pixelWidth);
r1 = round(r1);
c1 = round(c1);

% Check for selected rectangle completely outside the image
if ((r1 > m) || (r2 < 1) || (c1 > n) || (c2 < 1))
    %b = [];
    out = [];
else
    r1 = max(r1, 1);
    r2 = min(r2, m);
    c1 = max(c1, 1);
    c2 = min(c2, n);
    %b = a(r1:r2, c1:c2, :);
    out = [r1, r2, c1, c2];
end


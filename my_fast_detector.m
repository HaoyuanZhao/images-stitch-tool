function result = my_fast_detector(img, t)
    img_len = size(img, 2);
    img_height = size(img, 1);
    up_threshold = img + t;
    down_threshold = img - t;
    img_corner_map = false(img_height, img_len);
    out_frame_value = 0;
    
    img_shift_1 = circshift(img, [3 0]);
    img_shift_1([1:3], : ) = out_frame_value;
    
    img_shift_9 = circshift(img, [-3 0]);
    img_shift_9([end - 2 : end], : ) = out_frame_value;
    
    img_shift_5 = circshift(img, [0 -3]);
    img_shift_5( : ,[end - 2 : end]) = out_frame_value;
    
    img_shift_13 = circshift(img, [0 3]);
    img_shift_13( : ,[1 : 3]) = out_frame_value;
    
    high_speed_test_result = ( (up_threshold < img_shift_1) | (down_threshold > img_shift_1) ) + ...
        ( (up_threshold < img_shift_9) | (down_threshold > img_shift_9) ) + ...
        ( (up_threshold < img_shift_5) | (down_threshold > img_shift_5) ) + ...
        ( (up_threshold < img_shift_13) | (down_threshold > img_shift_13) );
    %Generate a matrix mask
    high_speed_test_result = high_speed_test_result >= 3;
    
    %Remove the non-candidate pixels
    candidate_corner = img .* high_speed_test_result;
    
    [row, col, v] = find(candidate_corner);
    
    %Do further comparison for each candidate corner
    for i = 1:length(row)
        compared_result = false(1, 16);
        compared_pixel_index = [-3 0;-3 1;-2 2;-1 3; ...
        0 3;1 3;2 2;3 1; ...
        3 0;3 -1;2 -2;1 -3; ...
        0 -3;1 -3;2 -2;3 -1];
        %Check the at least 12 sequential darker/brighter pixels
        for j = 1:16
            compared_x = row(i) + compared_pixel_index(j);
            compared_y = col(i) + compared_pixel_index(j+16);
            %If the compared pixel out of the frame, using 0
            if compared_x < 1 || compared_x > img_height || ...
                    compared_y < 1 || compared_y > img_len
                compared_pixel = out_frame_value;
            else
                compared_pixel = img(compared_x, compared_y);
            end
            compared_result(j) = v(i) + t < compared_pixel || v(i) - t > compared_pixel;
        end
        %The final corner should at least have 12 darker/brighter pixels
        if nnz(compared_result) >= 12
            for j = 1:4
                zero_index = find(compared_result == 0);
                %The largest distance for any two 0 should less than 4, if
                %there are 12 sequential 1
                if max(zero_index) - min(zero_index) < 4
                    img_corner_map(row(i), col(i)) = 1;
                    break;
                end
                %Circle shift it to try all possibiliteis, and we only need
                %to shift at most 4 times, because the largest distance
                %should be 3
                compared_result = circshift(compared_result, 1);
            end
        end
    end
    
    result = img_corner_map;
end

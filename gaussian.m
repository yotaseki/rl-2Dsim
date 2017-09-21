function centers = gaussian
% Gaussian
% ガウス関数の中心行列

grid1   = [0.6];
grid2   = [0 1.0];
centers = zeros(length(grid1)*length(grid2),2);
itr = 1;
%for k=1:length(Actions)
    for i=1:length(grid1)
        for j=1:length(grid2)
            centers(itr,1) = grid1(i);
            centers(itr,2) = grid2(j);
            itr = itr+1;
        end
    end
%end
end

function [phi] = getPhi(state,aind,centers,B,var,nactions)

% 現在の状態に関する基底関数
dist = sum((centers - repmat(state',B,1)).^2,2);

phi = zeros(B*nactions,1);
phi(B*(aind-1)+1:B*aind) = exp(-dist/2/var^2);

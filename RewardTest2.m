function R = RewardTest2( x )
    %報酬関数
    R = sin(x) * (1/(1+(0.5-x).^2));
end


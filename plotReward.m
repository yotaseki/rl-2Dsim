clear all;
syms x;
figure;
hold on
fplot(x,(x-1)^2,[0 1]);
%{
figure
fplot(x,RewardTest(x),[-1 0.5]);
title("Reward")
%}
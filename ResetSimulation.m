function [Agent, Env] = ResetSimulation
%ResetSimulation この関数の概要をここに記述

Agent.state  = [0.6; 0];
Agent.action = [0  ; 0];
Env.t = 0;                  % 時刻(ステップ数)
Env.T = 10;                % ステップ数上限
Env.dt = 0.1;               % [s] シミュレーションステップ
Env.goal = [0.6;1];
end
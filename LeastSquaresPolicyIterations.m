function theta = LeastSquaresPolicyIterations(L, M, T, B, options )
%REINFORCEMENTLEARNING 強化学習
%   L        ;政策反復回数
%   M        ;エピソード数
%   T        ;ステップ数
%   B = length(options.centers); % 基底関数の数
l = [-0.1 ;  0];
r = [ 0.1 ;  0];
f = [ 0   ;0.1];
actions = [l r f];
nactions = 3; % 行動数
% デザイン行列 ベクトル モデルパラメータの初期化
X = zeros(M*T,B*nactions);
r = zeros(M*T,1);
theta = zeros(B*nactions,1);
% デバッグ用
MaxR = [];
AvgR = [];
Dsum = [];
% 政策反復
for l=1:L
    dr = 0;
    for m=1:M
        [Agent, Env] = ResetSimulation;
        for t=1:T+1
            % 状態の観測
            state = Agent.state;
            % ==========================
            % 距離
			dist = sum((options.centers - repmat(state',B,1)).^2,2);
            % 現在の状態における基底関数z
            phis = exp(-dist/2/(options.var^2));
            % 現在の状態における価値関数
            Q = phis'*reshape(theta,B,nactions);
            % ==========================
            % 政策
            policy = zeros(nactions,1);
            % e-greedy
            if(l==1)
            policy = ones(nactions,1)/nactions;
            else
            [v, a] = max(Q);
            policy = ones(nactions,1)*options.epsilon/nactions;
            policy(a) = 1 - options.epsilon+options.epsilon/nactions;
            end
            % 行動選択
            ran = rand;
            if(ran < policy(1))
                action = 1;
            elseif(ran < policy(1)+policy(2))
                action = 2;
			else
                action = 3;
            end
            Agent.a = [actions(:,action)];
            % 行動の実行
            Agent.state = Agent.state + Agent.a;
            if and(l>=1, m>=M)
				UpdateScene(state(1),state(2),"Policy="+num2str(l)+",Episode="+num2str(m));
            end
            if t>1
                % 現在の状態に関する基底関数の政策に関する平均
                aphi = zeros(B*nactions,1);
                for a=1:nactions
                    % getPhi 基底関数のベクトル
					aphi = aphi + getPhi(state, a ,options.centers,B,options.var,nactions) * policy(a);
                end
                % 一つ前の状態と行動に関する基底関数
                pphi = getPhi(pstate,paction,options.centers,B,options.var,nactions);
                % (M*T)*Bデザイン行列X, M*T次元ベクトルr
                X(T*(m-1)+t-1,:) = (pphi - options.gamma * aphi)';
				r(T*(m-1)+t-1) = Reward_sq(state, Env.goal);
                
                % 割引き和の計算
                dr = dr+ r(T*(m-1)+t-1)*options.gamma^(t-1);
            end
            paction = action;
			pstate = state;
        end    
    end
    % 政策評価
    theta = pinv(X'*X)*X'*r;
    disp([num2str(l)+") Max="+num2str(max(r)) "Avg="+num2str(mean(r)) "Dsum="+num2str(dr/M)]);
    MaxR = [MaxR max(r)];
    AvgR = [AvgR,mean(r)];
    Dsum = [Dsum, dr/M];
    % グラフ
    if(l>=2)
    figure(2);
    subplot(3,1,1);
    plot(1:l, MaxR);
    title('Max R');
    subplot(3,1,2);
    plot(1:l, AvgR);
    title('Avg.R');
    subplot(3,1,3);
    plot(1:l, Dsum);
    title('Dsum');
    end
end

    function R=Reward(state,goal)
    % 報酬関数
        x = sqrt((state(1)-goal(1))^2 + (state(2)-goal(2))^2 );
        R = 1/2^(x*10);
    end

    function R=Reward_sq(state,goal)
        x = sqrt((state(1)-goal(1))^2 + (state(2)-goal(2))^2 );
        R = (max(0, min(x,1)) - 1)^2;
    end

    function R=Reward_step(state,goal)
        if and(state(1) == goal(1), state(2) == goal(2))
            R = 1;
            disp("** Goal **");
        elseif not(state(1)==goal(1))
            R = -1;
        else
            R = 0;
        end
    end
end

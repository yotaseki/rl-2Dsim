function UpdateScene(x,y,Title)
% アニメーションを更新する関数
figure(1);
clf
hold on
title(Title);
drawAgent(x,y);
drawGoal(0.6, 1)
xlim([   0   1.2]);
ylim([-0.2   1.2]);
pause(0.05);
    function drawAgent(x,y)
        % カートの描画
        plot(x,y,'or','LineWidth',4);
    end
    function drawGoal(x,y)
        % ゴール地点を描画
        plot(x,y,'or','LineWidth',4,'Color','b');
    end
end

function flag = DrawTaskTitles_8 (positionInplot, thisTitle, taskTitle, pre, post, flag)

if flag == 0
    text(pre(1), 30, thisTitle, 'FontWeight', 'bold', 'FontSize', 10)
    text(((post(1) + pre(1))/2), 50, taskTitle, 'FontWeight', 'bold','FontSize', 15)
    flag = 1;
end

end

% switch positionInplot % Only for top 3 subplots
%     case 1
%         if flag == 0
%             text(pre(1), 30, thisTitle, 'FontWeight', 'bold', 'FontSize', 10)
%             flag = 1;
%         end
%         text(((post(1) + pre(1))/3), 25, taskTitle, 'FontWeight', 'bold','FontSize', 15)
%     case 2
%         if flag == 0
%             text(pre(1), 70, thisTitle, 'FontWeight', 'bold', 'FontSize', 10)
%             flag = 1;
%         end
%         
%         text(((post(1) + pre(1))/3), 25, taskTitle,'FontWeight', 'bold', 'FontSize', 15)
%     case 3
%         if flag == 0
%             text(pre(1), 70, thisTitle, 'FontWeight', 'bold', 'FontSize', 10)
%             flag = 1;
%         end
%         text(((post(1) + pre(1))/3), 25, taskTitle,'FontWeight', 'bold', 'FontSize', 15)
% end
%end

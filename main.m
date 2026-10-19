%_________________________________________________________________________%
%  main.m - benchmark driver                                              %
%                                                                         %
%  Runs MSFA, CMSFA and WOA on the standard test functions F1-F23 and     %
%  stores the results in ./results.                                       %
%                                                                         %
%  Based on the demo main.m of the WOA package by Seyedali Mirjalili      %
%  (S. Mirjalili, A. Lewis, Advances in Engineering Software, 2016,       %
%  DOI: 10.1016/j.advengsoft.2016.01.008).                                %
%_________________________________________________________________________%

clear; close all; clc

%% ------------------------------ Settings ------------------------------
Methods         = {'MSFA','CMSFA','WOA'};  % any subset of {'MSFA','CMSFA','WOA'}
Functions       = {'F1','F6'};             % any subset of F1 ... F23
% Functions     = arrayfun(@(i) sprintf('F%d',i), 1:23, 'UniformOutput', false); % all 23
Runs            = 1;                       % independent runs per (function, method)
SearchAgents_no = 1;                       % population size (MSFA/CMSFA use a single point)
Max_iteration   = 201;                     % iterations per run
doPlot          = true;                    % parameter space + convergence figure per function
saveResults     = true;                    % write results/<F>_<METHOD>.mat, summary.csv, figures
verbose         = false;                   % true = show the per-iteration output of the algorithms

%% ------------------------------ Paths ---------------------------------
root = fileparts(mfilename('fullpath'));
addpath(fullfile(root,'algorithms'), fullfile(root,'benchmark'));
resultsDir = fullfile(root,'results');
if saveResults && ~exist(resultsDir,'dir')
    mkdir(resultsDir);
end

%% ------------------------------ Main loop -----------------------------
rows = {};
for f = 1:numel(Functions)
    Function_name = Functions{f};
    [lb,ub,dim,fobj] = Get_Functions_details(Function_name);
    curves = cell(1,numel(Methods));       % convergence curve of the best run of each method

    for m = 1:numel(Methods)
        Method = Methods{m};
        alg    = str2func(Method);

        Best_score = zeros(Runs,1);
        Best_pos   = zeros(Runs,dim);
        cg_curves  = cell(Runs,1);

        rng default                        % run 1 matches a single run of the original main.m
        for r = 1:Runs
            if verbose
                [score,pos,cg] = alg(SearchAgents_no,Max_iteration,lb,ub,dim,fobj);
            else
                evalc('[score,pos,cg] = alg(SearchAgents_no,Max_iteration,lb,ub,dim,fobj);');
            end
            if ishghandle(11)              % MSFA/CMSFA draw a debug plot in figure 11
                close(11);
            end
            Best_score(r) = score;
            Best_pos(r,:) = pos;
            cg_curves{r}  = cg;
        end

        best  = min(Best_score);
        worst = max(Best_score);
        avg   = mean(Best_score);
        sd    = std(Best_score);
        [~,iBest] = min(Best_score);
        curves{m} = cg_curves{iBest};

        rows(end+1,:) = {Function_name, Method, dim, Runs, best, avg, worst, sd}; %#ok<SAGROW>
        fprintf('%-4s %-6s  best = %.6g   mean = %.6g   std = %.3g\n', ...
                Function_name, Method, best, avg, sd);

        if saveResults
            save(fullfile(resultsDir,[Function_name '_' Method '.mat']), ...
                 'Function_name','Method','Runs','Max_iteration','SearchAgents_no', ...
                 'dim','lb','ub','Best_score','Best_pos','cg_curves', ...
                 'best','avg','worst','sd');
        end
    end

    %% Figure: search space and convergence curves of all methods
    if doPlot
        % 'IntegerHandle','off' keeps these figures away from figure(11) used by MSFA/CMSFA
        fig = figure('IntegerHandle','off','NumberTitle','off','Name',Function_name, ...
                     'Position',[269 240 660 290]);

        subplot(1,2,1);
        func_plot(Function_name);
        title('Parameter space')
        xlabel('x_1');
        ylabel('x_2');
        zlabel([Function_name,'( x_1 , x_2 )'])

        subplot(1,2,2);
        hold on
        for m = 1:numel(Methods)
            plot(curves{m},'LineWidth',1.5);
        end
        hold off
        if all(cellfun(@(c) all(c>0), curves))
            set(gca,'YScale','log');       % log axis only when every curve is positive
        end
        title('Objective space')
        xlabel('Iteration');
        ylabel('Best score obtained so far');
        axis tight
        grid on
        box on
        legend(Methods)

        if saveResults
            saveas(fig, fullfile(resultsDir,[Function_name '.png']));
        end
    end
end

%% ------------------------------ Summary -------------------------------
summary = cell2table(rows, 'VariableNames', ...
    {'Function','Method','Dim','Runs','Best','Mean','Worst','Std'});
disp(summary)
if saveResults
    writetable(summary, fullfile(resultsDir,'summary.csv'));
end

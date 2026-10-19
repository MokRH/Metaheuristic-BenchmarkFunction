%_________________________________________________________________________%
%                                                                         %
%  MSFA source codes demo 1.0                                             %
%                                                                         %
%  Developed in MATLAB R2017b                                             %
%                                                                         %
%  Author and programmer: Mok Ren Hao                                     %
%                                                                         %
%  e-Mail: mokrenhao@gmail.com                                            %
%                                                                         %
%  Main paper: Fast and optimal tuning of fractional order PID controller %
%              for AVR system based on memorizable-smoothed functional    %
%              algorithm.                                                 %
%  DOI: https://doi.org/10.1016/j.jestch.2022.101264                      %
%                                                                         %
%  Usage notice: This code is authorised by the author and provided       %
%                for research use only. Please cite the main paper        %
%                if you use this code.                                    %
%                                                                         %
%_________________________________________________________________________%

function [Leader_score,Leader_pos,Convergence_curve]=MSFA(SearchAgents_no,Max_iter,lb,ub,dim,fobj)

% initialize position vector and score for the leader
Leader_pos=zeros(1,dim);
Leader_score=inf; %change this to -inf for maximization problems

%Initialize the positions of search agents
Positions(1,1:dim)=initialization(SearchAgents_no,dim,ub,lb);
% Positions(1,1:dim)=[-1.14 -1.58 2.07 -1.41 -1.26 3.44 -2.29 -2.22 -1.87 -1.02]

k=1;% Loop counter

p=dim;
P(1:p,k)=Positions;
Pbar=P(:,k);
Jbar=fobj(Pbar');
Jkbar(1)=Jbar;
Jkplus(1)=Jbar;
Jkminus(1)=Jbar;
Jf(1)=Jbar;

Convergence_curve=Jbar;

% Main loop
while k<Max_iter
    ak = 1.0/(k+1)^1;%0.602; % step
    bk = 0.1/(k+1)^1;%0.101;   % learning
    eta = sign(randn(p,1));
    
    Pplus = Pbar+bk*eta(:);
    Pminus = Pbar-bk*eta(:);
    Jplus=fobj(Pplus');    
    Jminus=fobj(Pminus');
    Jkplus(k+1)=Jplus;
    Jkminus(k+1)=Jminus;
    %     Z(1:p,1)=0;
    %     Z(:)=(1-bk).*Z(:)+(bk.*eta(:))*(Jplus-Jminus);
    
    g(:)=eta(:)*(Jplus-Jminus)/(2*bk);
    for i=1:p
        P(i,k+1)=Pbar(i)-ak.*g(i);
    end
    Jf(k+1)=fobj(P(:,k+1)');
    
    if abs(Jf(k+1))<abs(Jbar) % success (store)        
        Pbar=P(:,k+1);
        Jbar=Jf(k+1);
    end
    Jkbar(k+1)=Jbar;
    
    Leader_pos = Pbar';
    Leader_score = Jbar';
    Convergence_curve(k)=Leader_score;
    [k Leader_score]
    k=k+1;
end
figure(11)
hold on
% plot(Jkplus(:),'r','LineWidth',1.5);
% plot(Jkminus(:),'b','LineWidth',1.5);
plot(Jf(:),'g','LineWidth',1.5);
plot(Jkbar(:),'k--','LineWidth',1.0);


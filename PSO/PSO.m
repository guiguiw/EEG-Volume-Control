function [C, G ] = PSO( Iterations,C1,C2,SwarmSize, Data )
%PSORBFN Performs Particle Swarm Optimization for RBFN
% Inputs:
%   Iterations: The number of iterations to run
%   C1: Constratint 1
%   C2: Constratint 2
%   SwarmSize: The size of the swarm
%   Data: Stucture of the data to optimize
% Output:
%   C: Best value of C
%   G: Best value of G
%
%
% swarm(index of particle, [location, velocity, best position, best
% value], [x, y components or the value component])
%
% Author: Aaron Pulver, Deep Tayal 12/4/13 (Modified from Wesam Elshamy 6/28/06)

    % initialize swarm
    for i = 1 : SwarmSize;
        swarm(i, 1, 1) = rand()*200;
        swarm(i, 1, 2) = rand();
    end

    % best value to something really high
    swarm(:, 4, 1) = 1000; 
    % set velocities to 0
    swarm(:, 2, :) = rand;

    %% Iterations
    for iter = 1 : Iterations
        fprintf('Iteration: %d\n',iter);
        %-- evaluating position & quality ---
        for i = 1 : SwarmSize
            swarm(i, 1, 1) = (swarm(i, 1, 1) + swarm(i, 2, 1));     %update x position
            swarm(i, 1, 2) = swarm(i, 1, 2) + swarm(i, 2, 2);     %update y position
            
            % threshold values
            if(swarm(i,1,1) <= 0)
                swarm(i,1,1)=.001;
            end
            if(swarm(i,1,2) <= 0)
                swarm(i,1,2)=.001;
            end   
            
            x = swarm(i, 1, 1);
            y = swarm(i, 1, 2);

            % evaluate fitness function here
            val = FitnessFunctionSVM(x,y,Data);
            % val = FitnessTest([x,y]);
            
            % update the best positions
            if val < swarm(i, 4, 1)                 
                swarm(i, 3, 1) = swarm(i, 1, 1);    
                swarm(i, 3, 2) = swarm(i, 1, 2);    
                swarm(i, 4, 1) = val;               
            end
        end

        % global best is the lowest 
        [~, gbest] = min(swarm(:, 4, 1));
        % updating velocity vectors
        for i = 1 : SwarmSize
            swarm(i, 2, 1) = rand*swarm(i, 2, 1) + C1*rand*(swarm(i, 3, 1) - swarm(i, 1, 1)) + C2*rand*(swarm(gbest, 3, 1) - swarm(i, 1, 1));   %x velocity component
            swarm(i, 2, 2) = rand*swarm(i, 2, 2) + C1*rand*(swarm(i, 3, 2) - swarm(i, 1, 2)) + C2*rand*(swarm(gbest, 3, 2) - swarm(i, 1, 2));   %y velocity component
        end
        
        % plot to see movements
         %plot(swarm(:, 1, 1), swarm(:, 1, 2), 'x')   % drawing swarm movements
         %axis([0,30,0,32]);
         %pause(.2)
    end
    %plot(swarm(:, 1, 1), swarm(:, 1, 2), 'x')
    C=swarm(gbest, 3, 1)
    G=swarm(gbest, 3, 2)
end

function runTHA(self,uID)
%% assign static load by nodeid and run lsa solver
%
% inputs:
% fcase     - freedom case, defaults to 1
%
% 1. checks for empty outputid, defaults to output all
% 2. sets the result file name
% 3. loops self.nodeid and sets the force using nodeid, lcase, force combo1
% 4. enables all load cases in self.lcase
% 5. runs the solver
% 6. disables the previous load case enabling
% 7. opens result file 
% 8. gets node result at self.outputid
% 9. 
% 
% 
% jdv 7/9/14; 1/11/15; 08232016

    % globals
    global stTransientHeatSolver smProgressRun btTrue  rtNodeTemp rtBeamForce rtBeamDisp rtBeamStress stBeamPrincipal stBeamGlobal
    
    % error screen null output index
    if isempty(self.outputid)
        % get all the nodes
        self.outputid = api.getTotalNodes(uID);
%         self.outputcase = ones(size(self.outputid));
    end
    
%% Unique result file logic wrapper here    
    % check if unique result name in path
     newfile = self.isunique;    
    % if result file does not already exist
    if newfile
        % update user
        fprintf('\tRunning Transient Heat Analysis... \n');

        % set result file name 
        iErr = calllib('St7API','St7SetResultFileName',uID,self.fullname);
        HandleError(iErr);

         % enable load cases
        if ~isempty(self.LDcase)
            % Get total number of load cases - to be added
            % Disable all other load cases
            % If not all load cases 
            for ii = 1:length(self.LDcase)
                iErr = calllib('St7API','St7SetTHATemperatureLoadCase',uID,...
                self.LDcase(ii));
                HandleError(iErr);
            end
            iErr = calllib('St7API','St7SetSolverHeatNonlinear',uID,btTrue);
            HandleError(iErr);
            
            for ii = size(self.steps,1)
                row = ii;
                iErr = calllib('St7API','St7SetTimeStepData',uID,row,self.steps(row,1),1,self.steps(row,2));
                HandleError(iErr);
            end
        end


        % run lsa solver
        iErr = calllib('St7API','St7RunSolver',uID,stTransientHeatSolver, ...
            smProgressRun, btTrue);
        HandleError(iErr);

    end %% End Logic wrapper here
% End Logic wrapper here
    
%% Open result file
    if ~isempty(self.steps)
        % open results
        [iErr, nPrimary, nSecondary] = calllib('St7API', 'St7OpenResultFile',...
            uID, self.fullname, '', false, 0, 0);
        HandleError(iErr);
        
        if iscell(self.outputtype); types = self.outputtype; ids = self.outputid; num_types = length(self.outputtype);
        else num_types = 1; types = {self.outputtype}; ids = {self.outputid}; end
        
        for jj = 1:num_types
            % nodal results
            if ~isempty(regexp(types{jj}, regexptranslate('wildcard','nod*'),'Once'))
                % Gather Results
                self.resp{jj} = zeros(length(ids{jj}),1);

                % loop response index for requested results
                for ii = 1:size(self.resp{jj},1)
                    [iErr,self.resp{jj}(ii,:)] = calllib('St7API','St7GetNodeResult',uID,...
                        rtNodeTemp,ids{jj}(ii),ii,[0]);
                    HandleError(iErr);
                end
            elseif ~isempty(regexp(types{jj}, regexptranslate('wildcard','plate*'),'Once'))
                
            elseif ~isempty(regexp(types{jj}, regexptranslate('wildcard','brick*'),'Once'))
%             elseif ~isempty(regexp(types{jj}, regexptranslate('wildcard','beam*'),'Once'))
%                 subtype = stBeamPrincipal;
%                 switch types{jj}                    
%                 case {'beam','beam_force'}
%                     rtype = ;     
%                     numCol = ;
%                     self.resp{jj} = zeros(length(ids{jj}),2*numCol,length(self.outputcase{jj}));                    
%                 case 'beam_stress'
%                     rtype = ;
%                     numCol = ;
%                     self.resp{jj} = zeros(length(ids{jj}),2*numCol,length(self.outputcase{jj}));  
%                 case 'beam_disp'
%                     numCol = ;
%                     rtype = ;
%                     self.resp{jj} = zeros(length(ids{jj}),2*numCol,length(self.outputcase{jj}));
%                 end 
%                 % loop response index for requested results
%                 for ii = 1:length(self.outputcase{jj})
%                     for kk = 1:length(ids{jj})
%                         [iErr, numCol, self.resp{jj}(kk,:,ii)] = calllib('St7API', 'St7GetBeamResultEndPos',...
%                             uID, rtype, subtype, ids{jj}(kk), self.outputcase{jj}(ii), numCol, zeros(2*numCol,1));
%                         HandleError(iErr);
%                     end
%                 end
            end
        end

        % clean up
        iErr = calllib('St7API','St7CloseResultFile',uID);
        HandleError(iErr);
    end
    
    % update user
    fprintf('Done. ');
end
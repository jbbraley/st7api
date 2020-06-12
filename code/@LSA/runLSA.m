function runLSA(self,uID)
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
    global stLinearStaticSolver smProgressRun btTrue rtNodeDisp rtBeamForce rtBeamDisp rtBeamStress stBeamPrincipal stBeamGlobal
    
    % error screen null output index
    if isempty(self.outputid)
        % get all the nodes
        self.outputid = api.getTotalNodes(uID);
        self.outputcase = ones(size(self.outputid));
    end
    
%% Unique result file logic wrapper here    
    % check if unique result name in path
     newfile = self.isunique;    
    % if result file does not already exist
    if newfile
        % update user
        fprintf('\tRunning Linear Static Analysis... \n');

        % set result file name 
        iErr = calllib('St7API','St7SetResultFileName',uID,self.fullname);
        HandleError(iErr);

        % Assign force 
        % - loop load index for force assignment indices. assign to load case
        for ii = 1:length(self.inputid)
            iErr = calllib('St7API','St7SetNodeForce3',uID,self.inputid(ii),...
                self.inputcase(ii),self.force(ii,:));
            HandleError(iErr);
        end

        % Assign moment -- ADD ME PLEASE --
        % negative, this functionality should be part of a "node" object
        % method


        % enable all load cases in lsa object
        [lc,ind] = unique(self.inputcase);

        for ii = 1:length(lc);
            if isempty(self.fcase)
                % default enable first freedom case
                fc = 1;
            elseif min(size(self.fcase))==1
                % all fcases enabled for each load case
                fc = self.fcase;
            else
                % unique fcase combination for each load case
                fc = self.fcase(:,ind(ii));
            end
            for jj = 1:length(fc)
                iErr = calllib('St7API','St7EnableLSALoadCase',uID,lc(ii),...
                    fc(jj));
                HandleError(iErr);
            end
        end

        % run lsa solver
        iErr = calllib('St7API','St7RunSolver',uID,stLinearStaticSolver, ...
            smProgressRun, btTrue);
        HandleError(iErr);

        % disable load case
        for ii = 1:length(lc);
            if isempty(self.fcase)
                iErr = calllib('St7API','St7DisableLSALoadCase',uID,lc(ii),1);
            else
                iErr = calllib('St7API','St7DisableLSALoadCase',uID,lc(ii),...
                    self.fcase(ind));
            end
            HandleError(iErr);
        end
    end %% End Logic wrapper here
% End Logic wrapper here
    
%% Open result file
    if ~isempty(self.outputcase)
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
                self.resp{jj} = zeros(length(ids{jj}),6);

                % loop response index for requested results
                for ii = 1:size(self.resp{jj},1)
                    [iErr,self.resp{jj}(ii,:)] = calllib('St7API','St7GetNodeResult',uID,...
                        rtNodeDisp,ids{jj}(ii),self.outputcase(ii),[0 0 0 0 0 0]);
                    HandleError(iErr);
                end
            elseif ~isempty(regexp(types{jj}, regexptranslate('wildcard','beam*'),'Once'))
                subtype = stBeamPrincipal;
                switch types{jj}                    
                case {'beam','beam_force'}
                    rtype = rtBeamForce;     
                    numCol = 6;
                    self.resp{jj} = zeros(length(ids{jj}),2*numCol,length(self.outputcase{jj}));                    
                case 'beam_stress'
                    rtype = rtBeamStress;
                    numCol = 18;
                    self.resp{jj} = zeros(length(ids{jj}),2*numCol,length(self.outputcase{jj}));  
                case 'beam_disp'
                    numCol = 6;
                    rtype = rtBeamDisp;
                    self.resp{jj} = zeros(length(ids{jj}),2*numCol,length(self.outputcase{jj}));
                end 
                % loop response index for requested results
                for ii = 1:length(self.outputcase{jj})
                    for kk = 1:length(ids{jj})
                        [iErr, numCol, self.resp{jj}(kk,:,ii)] = calllib('St7API', 'St7GetBeamResultEndPos',...
                            uID, rtype, subtype, ids{jj}(kk), self.outputcase{jj}(ii), numCol, zeros(2*numCol,1));
                        HandleError(iErr);
                    end
                end
            end
        end

        % clean up
        iErr = calllib('St7API','St7CloseResultFile',uID);
        HandleError(iErr);
    end
    
    % update user
    fprintf('Done. ');
end
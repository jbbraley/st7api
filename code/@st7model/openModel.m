function openModel(self)
    % error screen missing file extension
    if isempty(regexp(self.filename,'.st7','once'))
       % ext missing, add
       self.filename = [self.filename '.st7'];   
    end
    % call fullfile to sort path\name conflicts
    ModelPathName = fullfile(self.pathname, self.filename);

    % open and handle error
    iErr = calllib('St7API', 'St7OpenFile', self.uID, ModelPathName, self.scratchpath);
    HandleError(iErr);
    
    self.open = 1;
end
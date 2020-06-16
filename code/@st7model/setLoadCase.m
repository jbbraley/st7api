function setLoadCase(self,caseNum,input)
opts.keepLoaded = 1;
opts.keepOpen = 1;

if self.open==0 || isempty(self.open)
    apish([],self,[],opts)
end
%Sets up load case defaults
iErr = calllib('St7API','St7SetLoadCaseDefaults',self.uID,caseNum,input);
HandleError(iErr);

end


function defaults = getLoadCase(self,caseNum)
opts.keepLoaded = 1;
opts.keepOpen = 1;

if self.open==0 || isempty(self.open)
    apish([],self,[],opts)
end
%Gets load case defaults
defaults = zeros(1,13);
[iErr, defaults] = calllib('St7API','St7GetLoadCaseDefaults',self.uID,caseNum,defaults);
HandleError(iErr);

end


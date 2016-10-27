function assemblePara(self)
%% assemblePara
% 
% takes structure 'parameters', loops through fields and populates
% "optimize" instance
% 
% author: John Braley
% create date: 26-Oct-2016 14:50:10
pp = self.modelPara;
fields = fieldnames(pp);
for ii = 1:length(fields)
    paraind{ii} = fields{ii};
    para = pp.(fields{ii});
    if ~isempty(para.ub)
    self.ub(ii) = para.ub;
    end
    if ~isempty(para.lb)
    self.lb(ii) = para.lb;
    end
    if ~isempty(para.start)
    self.start(ii) = para.start;
    end	
end

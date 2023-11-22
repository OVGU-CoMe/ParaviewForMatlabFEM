function filenames = sortFilenames(filenames,constStr)

%% Adjust filenames internally
% In some cases, the filenames in the 'sourceFilenames' do not contain step
% number like
%
% goalFilename00001.vtu
% goalFilename00002.vtu
% goalFilename00003.vtu,
%
% and so on, but they are of the form
%
% goalFilename1.vtu
% goalFilename2.vtu
% goalFilename3.vtu,
%
% and so on. In this case, the order of the parsed filenames can be mixed
% up by Matlab. Therefore, the step number are read and stored in the
% variable 'val'. Then, 'val' is sorted and the sorting ids saved in 'idx'
% is applied to sourceFilenames.

val = zeros(length(filenames),1);
for i = 1:length(filenames)
   s = split(filenames{i},{constStr,'.vtu'});

   % Find non-empty cells:
   ID = find( ~cellfun(@isempty,s) == 1 );

   if isempty(ID)
        error('The filename should be given in a format: "goalFilename######.vtu"')
   end
   ID = s{ID(end)};

   ID = regexp(ID,'\d*','Match');
   ID = ID{1};
   val(i) = str2double(ID);
end

[~,idx] = sort(val);
filenames = filenames(idx);
end
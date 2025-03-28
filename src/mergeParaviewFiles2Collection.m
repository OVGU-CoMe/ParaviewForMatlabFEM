function mergeParaviewFiles2Collection(sourceFolder,goalFolder,goalFilename,timesteps)


f = struct2cell(dir(fullfile(sourceFolder,[goalFilename '*.vtu'])))';
sourceFilenames = f(:,1);

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
sourceFilenames = sortFilenames( sourceFilenames, goalFilename );


write_pvd(sourceFolder,sourceFilenames,goalFolder,goalFilename,timesteps)

end


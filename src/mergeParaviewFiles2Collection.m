function mergeParaviewFiles2Collection(sourceFolder,goalFolder,goalFilename,timesteps)


f = struct2cell(dir(fullfile(sourceFolder,[goalFilename '*.vtu'])))';
sourceFilenames = f(:,1);
writeParaviewCollection(sourceFolder,sourceFilenames,goalFolder,goalFilename,timesteps)

end


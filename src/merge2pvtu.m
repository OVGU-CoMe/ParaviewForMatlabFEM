function merge2pvtu(sourceFolder,sourceFilenameSubStr,goalFilename,NameValueArgs)


arguments
    sourceFolder;
    sourceFilenameSubStr
    goalFilename {mustBeText};
    NameValueArgs.goalFolder {mustBeText} = sourceFolder;
    NameValueArgs.sortFiles (1,1) logical = false 
end

goalFolder = NameValueArgs.goalFolder;


%% Filter out source filenames
% This is based on the constant sub-string that must be contained by every
% source file

files = dir(sourceFolder);
nFiles = length(files);
sourceFilenames = cell(nFiles,1);

for i = 1:length(files)
    [~,~,ext] = fileparts(files(i).name);

    if strcmp(ext,'.vtu') &&...
            startsWith( files(i).name, sourceFilenameSubStr )

        sourceFilenames{i} = files(i).name;
    end
end

sourceFilenames = sourceFilenames(~cellfun('isempty',sourceFilenames));


%% Sort filenames based on ID
if NameValueArgs.sortFiles
    sourceFilenames = sortFilenames( sourceFilenames, sourceFilenameSubStr );
end


%% Write pvtu-file
write_pvtu(sourceFilenames,goalFilename,goalFolder)


end


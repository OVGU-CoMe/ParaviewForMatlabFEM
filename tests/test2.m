clear all

filedir = 'C:\Users\petoe\Documents\git_repository\SEM-SCM_Code\subroutines\Visualization\ParaviewForMatlabFEM\tests';

%% Define Mesh
Coor = [
    0     0;
    1     0;
    2     0;
    3     0;
    4     0;
    0     1;
    1     1;
    2     1;
    3     1;
    4     1;
    0     2;
    1     2;
    2     2;
    3     2;
    4     2;
    0     3;
    1     3;
    2     3;
    3     3;
    4     3;
    0     4;
    1     4;
    2     4;
    3     4;
    4     4];

Coor = [Coor zeros(size(Coor,1),1)];

Connectivity = [
    1     2     7     6;
    2     3     8     7;
    3     4     9     8;
    4     5    10     9;
    6     7    12    11;
    7     8    13    12;
    8     9    14    13;
    9    10    15    14;
    11    12    17    16;
    12    13    18    17;
    13    14    19    18;
    14    15    20    19;
    16    17    22    21;
    17    18    23    22;
    18    19    24    23;
    19    20    25    24];


t = linspace(0,5,100);

for i = 1:length(t)


UX = Coor(:,1)*sin( t(i) )^2;
UY = Coor(:,1).*Coor(:,2)*sin( t(i) )^2;
UZ = zeros(size(UX));

PointData{1}.name = 'Displacement';
PointData{1}.array = [UX, UY, UZ];


% Create data structures
% In the current example, we only have one data structure. If the mesh
% would contain multiple element types, then all the quads associated data
% would be in cell of the DataStructures, and the data associated with e.g.
% triangular elements would be in the second cell.

DataStructures{1}.Coor = Coor;
DataStructures{1}.Connectivity = Connectivity;
DataStructures{1}.PointData = PointData;

if exist('CellData','var')
    % If cell data has been defined, add it to the DataStructures. If no 
    % cell data exist, it is not a problem. The DataStructure must not
    % contain a CellData field - it is optional.
   DataStructures{1}.CellData = CellData; 
end


%% Define meta data for the plot

PlotSettings.filedir = filedir;
PlotSettings.filename = ['test2_' sprintf('%03d',i)];
PlotSettings.fileInfo = ['Thime: ' num2str(t(i)) ' [s]'];


%% Create vtu file
writevtu('2D',DataStructures,PlotSettings);

end



mergeParaviewFiles2Collection(filedir,filedir,'test2',t)
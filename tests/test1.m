clear all

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


%% Some PointData
ID = 1;

% Displacements -----------------------------------------------------------
UX = Coor(:,1);
UY = Coor(:,1).*Coor(:,2);
UZ = zeros(size(UX));

PointData{ID}.name = 'Displacement';
PointData{ID}.array = [UX, UY, UZ];

ID = ID + 1;

% Custom function ---------------------------------------------------------
% As a second field, we create an arbitrary function with 4 components. 
F1 = sin(Coor(:,1)); % Arbitrary field component nr.1
F2 = cos(Coor(:,2)); % Arbitrary field component nr.2
F3 = Coor(:,1).*Coor(:,2); % Arbitrary field component nr.3
F4 = 2*ones(size(Coor,1),1); % Arbitrary field component nr.4

% For the chosen field, we also add names to the different components
PointData{ID}.name = 'My function';
PointData{ID}.componentNames = {'F1', 'Other field', 'field name','blabla'};
PointData{ID}.array = [F1 F2 F3 F4];


%% Some CellData

addCellData = true;

if addCellData
    CellData{1} = [];
    CellData{1}.name = 'Element IDs';
    CellData{1}.array = (1:size(Connectivity,1))';
end


%% Create data structures
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

PlotSettings.filedir = 'C:\Users\petoe\Documents\git_repository\SEM-SCM_Code\subroutines\Visualization\ParaviewForMatlabFEM';
PlotSettings.filename = 'test1';
PlotSettings.fileInfo = {'This is a test!', 'This is a second line'};


%% Create vtu file
writevtu('2D',DataStructures,PlotSettings);
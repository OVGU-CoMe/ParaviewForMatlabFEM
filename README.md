This visualisation toolbox is used for exporting FEM results computed in Matlab to .vtu files which can be then opened by Paraview.

# VTU File Structure Exported files #

The exported .vtu files is wrapped by the staring tags <VTKFile>,<UnstructuredGrid> and </Piece>, and closing tags </Piece>, </VTKFile> </UnstructuredGrid>, in order.
The actuall data for the visualization is defined in the innermost block, i.e. the Piece-block, and includes the following for 4 blocks:

- Points
- Cells
- PointData
- CellData

While the "Points" and "Cells" blocks define the mesh itself, the "PointData" and "CellData" define the nodal, and element-wise results to be plotted, respectively. It is not necessary to have both "PointData" and "CellData", if the
mesh contains only nodal results, such as displacements, the "CellData" can be left out.

## **Points** ##
In the block defined by the tags <Points> and </Points>, the nodal coordinates are defined. Note that for 2D data, the z-coordinates cannot miss, but it has to be zero.

## **Cells** ##
In the block marked by the tags <Cells> and </Cells>, the topology data is given using the following sub-blocks defined as DataArrays:

 - connectivity
 - offsets
 - types

### **DataArray: "connectivity"** ###
The connectivity matrix defines which points from the Points-block constitute the individual elements. The data in the connectivity matrix is read row-by-row from left to right. Note that connectivity array does not have to be a 
matrix with a consistent size, but the number of columns can vary in each row. Why this is not a problem, is explained in the "offsets" sub-section. Nonetheless, although it is not necessary, the connectivity matrix can be structured,
such that each element with its corresponding nodes are defined in individual lines. Finally, note that the numbering starts from 0.

### **DataArray: "offsets"** ###
Since the connectivity array is parsed by simply scanning its content linearly, Paraview must know which elements are defined by which points. For this, the "offsets" vector is used, which tells which element is defined by how many 
consequtive nodal IDs in the connectivity array. Note that this allows for a meshes containing different element types. As an example, if the "offsets" array starts with the values 4, 4, 3, it means that the first element is defined 
by the nodal IDs 1, 2, 3, 4, the second one by 5, 6, 7, 8, and the third one by 9, 10, 11, regardless of the actual layout of the connectivity matrix.

### **DataArray: "types"** ###
This block defines for each element an integer referring to its element type, such as 9 for linear quadratic elements, or 5 for linear triangular elements. 

Which element type is used, is defined determined in the function 'writevtu.m'. No use input is needed.

## **Point Data** ##
This block contains nodal values, i.e. results associated with the different nodes, such as displacements, strain and stresses. Each of the different fields is stored in its own DataArray. The field names and number of components
are given in the opening DataArray tag by "Name" and "NumberOfComponents".  

## **Cell Data** ##
In some cases, the exported data contains values, that are accosiated with the elements and not by the nodes, such as material IDs, or domain IDs. Such data is defined in the "CellData" block.


# Usage #
The .vtu file is created by the Matlab function writevtu(...) with the following inputs.

## dim ##

## DataStructures ##

## PlotSettings ##



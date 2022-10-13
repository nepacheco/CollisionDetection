This is a codebase for 2D collision detection using AABB trees and 
Restricted Box Trees.

To run the demo code, simply open the file Demo.m in matlab and run the 
file.

To view experiments, add the Experiments folder to the MATLAB path, and run
the file PlotResults.m or PlotVelocityExperiments.m which are both in the 
Experiments folder. If you would like to view the circle experiments, make 
sure the folder field in PlotResults.m is "Results/Circle/". If you would
like to view the square experiments, make sure the folder field in 
PlotResults.m is "Results/Square/".

To construct a circle based polygon run the following command:
    polygon = NPolygon(N,pos)
where N is the number of vertices you want and pos is a 2x1 position of the
polygon. Additionally you can specify a randomness parameter between 0 and 
1 to determine how random the polygon looks.
A square polygon is constructed using the following command:
    polygon = SimplePolygon(N,pos)
This will create a polygon with N sides with the bottom left corner at pos.

To construct and plot an AABB bounding volume Hierarchy run:
    bvh = AABB(polygon.edges,0,true)
    bvh.plotBox()
This will construct an AABB using the polygon provided and all its children

To construct a Restricted box tree run:
    bvh = AABB(polygon.edges,0,false)
    bvh = RestrictedBox.makeTree(bvh)
    RestrictedBox.plotBox(bvh)

To perform AABB Collision detection run the function:
    AABBCollisionDetection(bvh1,bvh2)
where bvh1 and bvh2 are both AABB trees

To perform Restricted Box Tree Collision Detection run the function:
    RestrictedCollisionDetection(bvh1,bvh2,bvh1.l,bvh1.h,bvh2.l,bvh2.h)
where bvh1 and bvh2 are Restricted Box trees.

All these examples are used in the Demo.m file. For more examples, see the
testScript.m file.
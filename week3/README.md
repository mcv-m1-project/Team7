# Week 3

  - task1(). Implement a function for CCL that labels all connected components
	in a binary image and returns a list of the bounding boxes. To discard false
	positives, simple geometric constraints can be used (aspect ratio / filling
	ratio / ...)
  
  - task2(). Implement a multi-scale sliding window approach. Use at least one
	geometric feature to remove windows that are not likely to contain traffic signs
	without affecting too much the recall. Write a method to merge the
	overlapping windows in order to get the best detection for the given region.
  
  - task3(). Improve the efficiency of the sliding window approach using integral
	images. Compare the computational efficiency of the two methods.
  
  - task4(). Perform region based evaluation in addition to the pixel based
	evaluation. Matlab functions are provided for region based evaluation.

  - task5() Optional. Improve the efficiency of the basic sliding window
	approach using convolutions. Compare the computational efficiency of this
	method and the previous ones.

# Connected-component-labelling-through-MATLAB
This is a MATLAB function that utilises the image processing toolbox to convert any image to its edge image using Canny algorithm and then label connected components in it. The whole labelling algorithm is in a function that you can apply to any image. The edge image goes through the labelling algorithm and final image is displayed. This project is a good aid at understanding the connected-component labelling algorithm using MATLAB's matrix and image operations. The comments explain every line in the code. You are encouraged to optimise the code and make it shorter, i'm not much of a pro :)

Data:
- objects.m (the function you can call with any image as input)
- Sample image : shapes.png that you can use in the function for simple understanding

The algorithm:
- The obtained edge image is a binary image, and is converted to uint8(or uint16) grayscale image so that we can label seperate pixels
- Initially, all objects/blobs have the same value(30 has been set here, check code), that you can edit in the code according to the number of objects/blobs
- The anchor is moved through the image and the code checks if the pixel is of the set initial value
- Labelling starts there. The first pixel of blob is put in a source matrix.
- Source matrix structure:
	```
	|source_element1_row	source_element1_column|
	|source_element2_row	source_element2_column|
	...............................................
	```
- Now the code enters a loop that labels all connected pixels with a different value
- The 8 pixels around the source element are checked. The indices of the elements relative to image matrix are stored in a 'destination matrix' that has the same structure as the source matrix.
- Code moves to the next source element and does the same till all source elements' surroundings have been checked
- Source matrix is then cleared and roles of source and destination matrices are exchanged
(While checking initil label, if  the source elements have no surrounding pixels with initial value, code moves to the next source element. If no further source elements are present, the source is cleared and then roles of source and destination matrices are exchanged)
- This goes on till the destination matrix turns out to be empty after all checking surroundings of all source elements, which means that the whole blob/object has been labelled. The value of new label is the incremented, source-destination matrices cleared and the anchor moves on to find another blob
- This goes on till the anchor reaches the last, bottom-right pixel of the image
- The output image is the labelled one

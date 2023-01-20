
//Close all open images, clear results, and clear log
close("*");
run("Clear Results");
print("\\Clear");


//Macro prompts user to choose three directories.
//dir1: directory where all tif images for all channels are saved, see script for "exporting czis" for name formatting
//dir2: the directory where each radial slice (erosion mask) will be saved. Within dir2, make folders titled "masks_image set_x", x=1,2,3..total images to be analyzed. 
//dir3: the directory where all thresholdid images will be saved.
dir1 = getDirectory("Choose tif image files folder");
dir2 = getDirectory("Choose erosion masks folder");
dir3 = getDirectory("Choose folder where thresholded images will be saved");
dir4 = getDirectory("Choose results output folder");

//Makes an arrayed list of all the file names
list1 = getFileList(dir1);

//initialized counter "c"
c=0;

//In our dataset, channel 1 is the nuclear image channel. We use this channel to create our erosion masks. Therefore, we start with i=1.
//Counter is set to i=i+4 because we have four channels total. This should be adjusted if using less channels
for(i=1; i<list1.length; i=i+4){
	
	c=c+1;
	open(dir1+list1[i]);
	selectWindow(list1[i]);
	run("8-bit");
	setAutoThreshold("Default dark");
	run("Threshold...");
	
	//Adjust threshold values based on the nuclear channel (channel 1 in our dataset)
	setThreshold(7, 255);
	run("Convert to Mask");
	selectWindow(list1[i]);
	saveAs("Tiff", dir3+"threshold_image_"+i+".tif");
	run("Duplicate...", "title=Mask"+i+"_1");
	run("Options...", "iterations=50 count=1 do=Close");
	run("Options...", "iterations=1 count=1 do=[Fill Holes]");
		
		
		//Making and saving mask outlines, eroding 60 it/1ct produces strips ~20um thick
	for(j=1; j<15; j++){
		selectWindow("Mask"+i+"_"+j);
		run("Duplicate...", "title=Mask"+i+"_"+j+1);
		selectWindow("Mask"+i+"_"+j+1);
		run("Options...", "iterations=60 count=1 do=Erode");
		imageCalculator("Subtract create", "Mask"+i+"_"+j,"Mask"+i+"_"+j+1);
		selectWindow("Result of Mask"+i+"_"+j);
		saveAs("Tiff", dir2+"/masks_image set_"+c+"/Mask_outline"+j+10+".tif");
		}	
		close("*");
	}

//Channel 0 thresholding
for(i=0; i<list1.length; i=i+4){
	open(dir1+list1[i]);
	selectWindow(list1[i]);
	run("Remove Outliers...", "radius=20 threshold=20 which=Bright");
	run("8-bit");
	setAutoThreshold("Default dark");
	run("Threshold...");
	setThreshold(25, 255);
	run("Convert to Mask");
	saveAs("Tiff", dir3+"threshold_image_"+i+".tif");
	close();
}

//Channel 2 thresholding
for(i=2; i<list1.length; i=i+4){
	open(dir1+list1[i]);
	selectWindow(list1[i]);
	run("8-bit");
	run("Convert to Mask");
	saveAs("Tiff", dir3+"threshold_image_"+i+".tif");
	close();
}

//Channel 3 thresholding
for(i=3; i<list1.length; i=i+4){
	open(dir1+list1[i]);
	selectWindow(list1[i]);
	run("8-bit");
	run("Convert to Mask");	
	saveAs("Tiff", dir3+"threshold_image_"+i+".tif");
	close();
}

close("*")

list3 = getFileList(dir3);

for(x=1; x<c+1; x++){
	list2 = getFileList(dir2+"masks_image set_"+x+"/");
		for(k=0; k<list2.length; k++){
			open(dir2+"masks_image set_"+x+"/"+list2[k]);
			for(l=0; l<4;l++){
				image=((4*x)+l-4);
				open(dir3+list3[image]);
				imageCalculator("Multiply create", list2[k],list3[image]);
				selectWindow("Result of Mask_outline"+k+11+".tif");
				run("Measure");
				close();
				close("threshold_*");
				}
		}
	selectWindow("Results"); 
	saveAs("Results", dir4+"Results_"+x+".csv");
	run("Close");
	close("*");
}
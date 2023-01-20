
//close all open images, clear results, and clear log
close("*");
run("Clear Results");
print("\\Clear");

// Macro prompts user to choose the input/output directories.
//dir1: folder where czis are saved
//dir2: folder where macro will save tiff files
dir1 = getDirectory("Choose input files directory");
dir2 = getDirectory("Choose Output Directory: 'Results' folder");

print("Input From: "+dir1);
print("Output Results To: "+dir2);

//Makes an arrayed list of all the file names
list1 = getFileList(dir1);

print("Number of images: "+images);


for (i = 0; i < list1.length; i++)
{

run("Bio-Formats Importer", "open=[" + dir1 + list1[i] +"] autoscale color_mode=Default rois_import=[ROI manager] split_channels view=Hyperstack stack_order=XYCZT");

if (i==0) {

//Input Min/Max values for each channel
waitForUser("WAITING...", "Determine min and max values for each channel");
			Dialog.create("Min and Max Values");
			min0=getNumber("Min0", 0);
			max0=getNumber("Max0", 0);
			min1=getNumber("Min1", 0);
			max1=getNumber("Max1", 0);
			min2=getNumber("Min2", 0);
			max2=getNumber("Max2", 0);
			min3=getNumber("Min3", 0);
			max3=getNumber("Max3", 0);
			
}

name1 = list1[i];
name1 = replace(name1,".czi","");

//Shows all the edited images
setBatchMode("show");

//Rename the channel colors where appropriate 
selectWindow(list1[i]+" - "+ list1[i]+" #1 - C=0");
		run("Subtract Background...", "rolling=50");
		setMinAndMax(min0, max0);		
		run("Green");
		run("RGB Color");
		saveAs("Tiff", dir2+name1+"_gfp");

selectWindow(list1[i]+" - "+ list1[i]+" #1 - C=1");
		run("Subtract Background...", "rolling=50");
		setMinAndMax(min1, max1);
		run("Cyan");
		run("RGB Color");
		//saveAs("Tiff", dir2+name1+"_eomes_magenta");
		saveAs("Tiff", dir2+name1+"_cdx2_cyan");


selectWindow(list1[i]+" - "+ list1[i]+" #1 - C=2");
		run("Subtract Background...", "rolling=50");
		setMinAndMax(min2, max2);
		run("Magenta");
		run("RGB Color");
		//saveAs("Tiff", dir2+name1+"_sox17_green");
		saveAs("Tiff", dir2+name1+"_sox17_magenta");


selectWindow(list1[i]+" - "+ list1[i]+" #1 - C=3");
		run("Subtract Background...", "rolling=50");
		setMinAndMax(min3, max3);
		run("Yellow");
		run("RGB Color");
		//saveAs("Tiff", dir2+name1+"_sox2_blue");
		saveAs("Tiff", dir2+name1+"_tfap2c_yellow");

close("*");

}
# Batch .nd2 to .tif converter
---
Depending on the software package used to control a particular microscope, .nd2 or .tif files are commonly created. The MASH-FRET analysis package for smFRET experiments requires .tif files for processing. 

I wrote this simple ImageJ macro that: 
1. Opens all of the `.nd2` files in a given directory.
1. Saves an identically-named `.tif` file in the same location,
1. Operates on all sub-directories as well.

Simply point this at the folder where all of your movies are from the days experiments and wait for ImageJ to do the hard work for you.


```java
macro  "Convert stk to TIF" {
	
//locate the main directory to be analyzed
dir=getDirectory("Select the directory"); 
setBatchMode(true)
ext_nd2 = ".nd2";
ext_tif = ".TIF";

///////////
count = 0;
   countFiles(dir);
   n = 0;
   processFiles(dir);
   //print(count+" files processed");
   
   function countFiles(dir) {
      list = getFileList(dir);
      for (i=0; i<list.length; i++) {
          if (endsWith(list[i], "/"))
              countFiles(""+dir+list[i]);
          else
              count++;
      }
  }

   function processFiles(dir) {
      list = getFileList(dir);
      for (i=0; i<list.length; i++) {
          if (endsWith(list[i], "/"))
              processFiles(""+dir+list[i]);
          else {
             showProgress(n++, count);
             path = dir+list[i];
             processFile(path);
          }
      }
  }
////////////




//get list of all files in images folder
 	function processFile (path) {
list=getFileList(dir); 

	for(i=0;i<list.length;i++){ 
	
			if (endsWith(list[i], ext_nd2)){
	        	  	foldername = getSubstring(list[i],"","/");
	          		print(foldername);
					
						//open the acquisition file
						//open(dir+foldername+File.separator+list[i]);
						run("Bio-Formats Importer", "open=["+dir+foldername+File.separator+list[i]+"] autoscale color_mode=Default split_channels view=Hyperstack stack_order=XYCZT");
						
						selectWindow(list[i]+" - C=0");
						
						Acq_ID = getImageID();
						newname = getSubstring(list[i],"",".nd2");
						print(newname);
						print(dir+foldername+newname+ext_tif);
						File.makeDirectory(dir+(i+1));		
						saveAs("Tiff", dir+(i+1)+"/"+foldername+newname+ext_tif);		
						File.copy(dir+foldername+list[i], dir+(i+1)+"/"+foldername+newname+ext_nd2);
						File.delete(dir+foldername+list[i])
				}

		 while (nImages>0) { 
          selectImage(nImages); 
          close(); 
      	}
       
	}
	print("All files converted");
}
}

//-------------------------------------------------------------------------------------------------------------


function getSubstring(name, prefix, postfix) { 
   start=indexOf(name, prefix)+lengthOf(prefix); 
   end=start+indexOf(substring(name, start), postfix); 
   if(start>=0&&end>=0) 
     return substring(name, start, end); 
   else 
     return ""; 
} 

```
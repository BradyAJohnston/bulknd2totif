//////////////////////////////////////////////////////////////////////////////////////////
// Plugin "nd2_to_tif"
// This macro batch opens all .nd2 files and saves a .tif version for compatibility with
// MASHFRET and other software.
// Original version written 2019-09-035; latest version finished 03-10-2016
//
// Brady Addison Johnston
// Structural Biology
// School of Molecular Sciences
// The University of Western Australia
// 35 Stirling Highway, Crawley, WA, Australia
// E-mail: brady.johnston@research.uwa.edu.au
//////////////////////////////////////////////////////////////////////////////////////////
//
// INSTALLATION:
// ImageJ is a high-quality public domain software very useful for image processing.
// Download the software from the imagej.nih.gov site. 
// You should have ImageJ installed in your machine in the first place.
// This plugin is a script written in ImageJ macro language (.ijm file).
// After opening ImageJ, install this plugin by doing Plugins > Install… and choosing 
// nd2_to_tif from the appropriate directory.
// The plugin should now appear listed under the Plugins menu, and is ready to 
// be launched by clicking Plugins > nd2_to_tif. 
//
//////////////////////////////////////////////////////////////////////////////////////////

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

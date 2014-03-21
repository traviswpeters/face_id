/* imflip.c - Example C Matlab Extention (MEX) program file.
 * This program will read in an image consisting of either a single plane
 * grayscale image or a three-plane color image and flip it left to right.
 * This is intended to demonstrate some of the basic requirements for
 * passing Matlab images (2D or 3D) arrays as arguments to C executables. 
 *
 * For those who are not familiar with the C programming language.  It will
 * be worth it to go through the book "The C Programming Language" by 
 * Kernigham and Ritchie.  There are also very good tutorials out there, 
 * example: 
 * 
 * http://www.physics.drexel.edu/students/courses/Comp_Phys/General/C_basics/c_tutorial.html
 *
 * there are many others to chose from.
 *
 * You should read the section "Creating C Language MEX-Files" in the Matlab
 * Help documentation.  Without it you will not be able to understand what 
 * follows.
 * 
 * To use this demonstration program, first you will need to compile it:
 *
 * mex -g imflip.c
 *
 * Then you can use it by calling it at the command prompt in matlab or any
 * script or function you write:
 *
 * B = imflip(A); % Where A is an image of type double, uint8 or uint16.
 * 
 * Alex Hartov, 12/24/08
 *
 */

#include "mex.h" /* This statement tells the compiler to include the named
                  * file as if it were part of this one.  This header file
                  * is required for all mex files. */
#include "matrix.h" /* This file declares functions to check for data
                     * types (mxIsDouble() etc.) and a few other things. */


/* Functions and variables in C need to be declared.  In the following the
 * function is declared as returning nothing (void) and it is also defined 
 * as a function that takes arguments of type "Pointer to a double
 * array" and a few others of custom types.  */

/* The following function is called from within the mexFunction.  You can 
 * name it anything you want, and you can have as many functions as you
 * want within the file. For the purpose of this demonstration, we assume
 * that only arguments of an allowable type will be used. */
void imflip(double y[], double x[], mwSize mrows, mwSize mcols, 
            mwSize mplanes, int dataType) 
/* This is the function that actually does the flipping. */
{ double minVal, maxVal; /* Used in rescaling double array. */
  long int maxIndex, index, r, c, p; /* Used in computing array indexes */
  long int xindex, cx, yindex;
  double val;
  
  /* NOTE: MATLAB uses 1 based indexing, C uses 0 based indexing. */
    
  /* In this example, y corresponds to the ouptut image while x corresponds
   * to the input image.  We are also given the number of rows, columns and
   * planes.  Depending on the number of arguments, it may be preferable to
   * send a pointer to an array of arrays, as is done in the main mex
   * function.  */
  
  if(dataType==0)   /* Double image array.  Normally, images of type double
                     * are confined to have values in the 0 to 1 range.  We
                     * will run a check and normalize if necessary, then 
                     * flip the image. */
  /* Important to note here:  We treat the input and output images as being
   * 1D arrays.  Matlab does not use multi-dimentional arrays internally.  
   * Any array can be accessed as a single dimentional array.  In order to 
   * access the correct pixel/voxel in a multi dimentional array, you need 
   * to compute your indexes carefully.  Here since we perform the same 
   * operation on every element, 1D indexing is the simplest. */
  { minVal=0.0; 
    maxVal=1.0;
    /* In the following statement we use what we know about the size of the
     * array to compute the last element index. Note the use of long int as
     * a data type for indexing.  This is necessary if you expect that your
     * index may exceed 2^16-1 (65535). */
    maxIndex=(long int)(mrows*mcols*mplanes);
    for(index=0;index<maxIndex;index++) /* Check for input array range. */
    { val=x[index]; /* Input image value at that location. */
      if(val>maxVal) maxVal=val;
      if(val<minVal) minVal=val;
    }
    if(minVal<0.0 || maxVal>1.0) /* Requires adjusting data to 0-1 range */
    { maxVal=maxVal-minVal; /* Shift max to reflect min */
      for(index=0;index<maxIndex;index++)
      /* We know x[] is of type double, no type-casting is required.  Note 
       * also that we are modifying the input image (array x) which may not
       * always be a desirable thing to do.  Modifying this code so it does
       * not alter the input array is left as a homework task. */
      { x[index]=(x[index]-minVal)/maxVal;  /* Adjust input array values */
      }
    }
    else
    { for(index=0;index<maxIndex;index++) y[index]=(x[index]-minVal)/maxVal;
    }
  }
  else if(dataType==1) /* Uint8 image array.  Here we moving from an 
                        * unsigned integer 8 bits type to a double.  The
                        * allowable range of values for uint8 is 0 to 255, 
                        * while the output type of double should be 0 to 1.
                        * We will scale the data by 1/256 then flip the 
                        * image. */
  { /* Left as homework assignment. */
  }
  else if(dataType==2) /* Uint16 image array.  Here we moving from an 
                        * unsigned integer 16 bits type to a double.  The
                        * allowable range of values for uint16 is 0 to 
                        * 65535, while the output type of double should be 
                        * 0 to 1.  We will scale the data by 1/65535 then 
                        * flip the image. */
  { /* Left as homework assignment. */
  }

    /* Here we do the actual Left/Right flipping.  We need to compute the 
     * 3D indexes based on the dimensions of the image.  To do this we need 
     * to know that memory indexing takes place by incrementing rows first, 
     * columns next, planes next. */
    for(p=0;p<mplanes;p++)  /* Process all the planes */
    { for(c=0;c<mcols;c++)  /* Column index */
      { cx=mcols-c-1;   /* Reverse (R->L) column index */
        for(r=0;r<mrows;r++)/* Row index */
        { yindex=r+c*mrows+p*(mrows*mcols); // Note: destination index
          xindex=r+cx*mrows+p*(mrows*mcols);// source index
          y[yindex]=x[xindex];
          if(r>240 && c>240) y[yindex]=0.0; /* a simple way to verify that
                                             * we got the indexing right.
                                             * The lower right corner of 
                                             * picture will be black. */
        }
      }
    }
  
  /* The following was used for debugging. Can be removed or commented out.
   */  
  printf("%d %d %d\n",mrows, mcols, mplanes);
}


/* All MEX files must have a function called "mexFunction."  This is the 
 * entry point in this program, it is equivalent to the "main()" module in 
 * normal (non-MEX) C programs.  The list of arguments in the mexFunction
 * is fixed.  The arguments are:
 * 
 * nlhs    = number of left side (returned values) arguments in Matlab.
 *
 * *plhs[] = This is an array of pointers to the left hand side arguments.
 *
 * nrhs    = number of right side (inputs) arguments in Matlab.
 *
 * *prhs[] = Array of pointers to the input variables.
 */

/* Note: the function mexFunction does not return a value, hence it is
 * declared as void.  Passing data in/out is handled through the 4
 * arguments as discussed above. */
void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[] )
{
  double *x,*y;         /* Declare all variables in C */
  mwSize mrows,ncols;   /* Note the custom data type, it is defined in the
                         * mex.h header file. */
  mwSize number_of_dims;
  mwSize mplanes;
  const mwSize *dim_array;  
  int dataType;
  
  /* It is necessary to perform a few checks before performing any
   * computations.  Not having the correct data in may result in a crash of
   * Matlab, or worse. */
  
  /* Check for proper number of input and output arguments.
     In this example there should be one input and one output. */
  if(nrhs!=1) 
  { /* Check the number of right hand side arguments */
    mexErrMsgTxt("One input required.");    /* Matlab standard error 
                                             * message */
  } 
  else if(nlhs>1) 
  { /* Check left hand side arguments. Note that in the case of the 
     * returned value, there could be no output variable given (nlhs=0), 
     * which would still be valid.  In such a case it would be displayed at 
     * the prompt and the default output variable "ans" would be  give the 
     * returned value. */
    mexErrMsgTxt("Too many output arguments.");
  }
  
  /* The input must have either 2 or 3 dimensions. */
  /* This call returns the number of dimensions. */
  number_of_dims=mxGetNumberOfDimensions(prhs[0]);
  
  /* This call returns an array with the size of the input array in each 
   * dimension. */
  dim_array=mxGetDimensions(prhs[0]);
  
  mexPrintf("%i is greater than %i.\n", number_of_dims, dim_array[2]); 
  /* Check for 2 or 3D */
  if(number_of_dims<2 || number_of_dims>3)
  { mexErrMsgTxt("Improper input array, requires 2D or 3D array.");
  }
  if(number_of_dims==2) /* 2D array */
  { mrows=dim_array[0];
    ncols=dim_array[1];
    mplanes=1;
  }
  else /* 3D array */
  { mrows=dim_array[0];
    ncols=dim_array[1];
    mplanes=dim_array[2];
  }
  
  /* Inputs can be of type double, uint8 or uint16, however the output will
   * be double. The allowable data types here were selected arbitrarily, we
   * could have authorized other data types as well.  This program is only
   % intended to show how things are done. */
  if(mxIsDouble(prhs[0]))
  { printf("Input is double\n");
    dataType=0;
  }
  else if(mxIsUint8(prhs[0]))
  { mexErrMsgTxt("Input is uint8\n");
    /* Note: we treat this as an error for now.  Part of HW will be to correct this */
    
    dataType=1;
  }
  else if(mxIsUint16(prhs[0]))
  { mexErrMsgTxt("Input is uint16\n");
    /* Note: we treat this as an error for now.  Part of HW will be to correct this */
    
    dataType=2;
  }
  else
  { mexErrMsgTxt("Input array of wrong type, use uint8 uint16 or double.");
  }
  
  /* The input must be a noncomplex array */
  if (mxIsComplex(prhs[0]))   /* returns true if the argument is complex */
  { mexErrMsgTxt("Input must be noncomplex.");
  }
  
  /* Create matrix for the return argument.  The output matrix will be of
   * type double not matter what for this exercise. */
  plhs[0] = mxCreateNumericArray(number_of_dims,dim_array,mxDOUBLE_CLASS, 
          mxREAL);
    
  /* Assign pointers to each input and output. */
  x = mxGetPr(prhs[0]);
  y = mxGetPr(plhs[0]);
  
  /* Call the imflip subroutine. */
  imflip(y,x,mrows,ncols,mplanes,dataType);
}

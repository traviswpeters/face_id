#include "mex.h" 
#include "matrix.h" /* This file declares functions to check for data
                     * types (mxIsDouble() etc.) and a few other things. */

void compareFeatureMatrices(double dist[], double F1[], mwSize nrowsF1, mwSize ncolsF1, 
            double F2[], nrowsF2, ncolsF2) 
{ double minVal, maxVal; /* Used in rescaling double array. */
  long int maxIndex, index, r, c, p; /* Used in computing array indexes */
  long int xindex, cx, yindex;
  double val;
  
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
  double *F1, *F2, *emptyArray, *dist;         // C variables: Inputs: F1, F2, emptyArray (array which is the same size as the output - this is a hack).  Outputs: dist
  mwSize nrowsF1, ncolsF1, nrowsF2, ncolsF2;   /* Custom data type, defined in mex.h header file. */
  const mwSize *dim_arrayF1;  
  const mwSize *dim_arrayF2;  
  const mwSize *dim_array;   //will hold the dimensions of the output matrix
  
  // get the size of matrix F1 and F2
  dim_arrayF1=mxGetDimensions(prhs[0]);
  nrowsF1=dim_arrayF1[0];
  ncolsF1=dim_arrayF1[1];
  dim_arrayF2=mxGetDimensions(prhs[1]);
  nrowsF2=dim_arrayF2[0];
  ncolsF2=dim_arrayF2[1];
  
  //Dimensions of the output matrix
  dim_array=mxGetDimensions(prhs[2]);
  
  // Create the output matrix (type double)
  plhs[0] = mxCreateNumericArray(number_of_dims,dim_array,mxDOUBLE_CLASS, 
          mxREAL);
    
  /* Assign pointers to each input and output. */
  F1 = mxGetPr(prhs[0]);
  F2 = mxGetPr(prhs[0]);
  dist = mxGetPr(plhs[0]);
  
  /* Call the imflip subroutine. */
  compareFeatureMatrices(dist,F1,nrowsF1,ncolsF1,F2,nrowsF2,ncolsF2);
}

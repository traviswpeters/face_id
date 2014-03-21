#include "mex.h"    /* Required for Matlab Mex files */

/* Other include files may be required depending on what function calls you
 * make (e.g. math.h, matrix.h, etc.).  This should occur before any code. */

/*
 * timestwo.c - example found in API guide
 *
 * Computational function that takes a scalar and doubles it.
 *
 * This is a MEX-file for MATLAB.
 * Copyright 1984-2007 The MathWorks, Inc.
 *
 * Some modifications by AH 01/04/2010
 */
 
/* $Revision: 1.8.6.3 $ */

/* This is the "Computational Routine" of which the Matlab Help section
 * speaks.  It could have been placed after the main function but then we
 * would need to declare a function prototype here.  */
void timestwo(double y[], double x[])
{
  y[0] = 2.0*x[0];
}

/* This is the "Gateway Routine" which handles all the communication to
 * Matlab environment through the four variables in the argument list. */
void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[] )
{
  double *x,*y;         // double is a standard variable type in C
  mwSize mrows,ncols;   // whereas mwSize is a type defined in the mex.h
                        // header.  

  /* The main purpose of the Gateway Routine is to check for the correctness
   * of the given inputs.  This is critical in preventing serious mishaps */
  
  /* Check for proper number of arguments. */
  if(nrhs!=1) {
    mexErrMsgTxt("One input required.");
  } else if(nlhs>1) {
    mexErrMsgTxt("Too many output arguments.");
  }
  /* Note that it is possible to have a variable number of arguments, this
   * beyond what you will need for this course but it is described in the
   * documentation if you need to resort to this. */
  
  /* The input must be a noncomplex scalar double.*/
  mrows = mxGetM(prhs[0]);
  ncols = mxGetN(prhs[0]);
  if( !mxIsDouble(prhs[0]) || mxIsComplex(prhs[0]) ||
      !(mrows==1 && ncols==1) ) {
    mexErrMsgTxt("Input must be a noncomplex scalar double.");
  }
  
  /* Create matrix for the return argument. */
  plhs[0] = mxCreateDoubleMatrix(mrows,ncols, mxREAL);
  
  /* Assign pointers to each input and output. */
  x = mxGetPr(prhs[0]);
  y = mxGetPr(plhs[0]);
  
  /* Call the timestwo subroutine. */
  timestwo(y,x);
}


/* Question: How would you modify this code to handle rxc arrays and 
 * different variable types? */

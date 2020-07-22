﻿


#include "AdaptCriteria.h"


/*! \fn int Thresholdcriteria(Param XParam,T threshold, T* z, BlockP<T> XBlock,  bool*& refine, bool*& coarsen)
* Threshold criteria is a general form of wet dry criteria
* Simple wet/.dry refining criteria.
* if the block is wet -> refine is true
* if the block is dry -> coarsen is true
* beware the refinement sanity check is meant to be done after running this function
*/
template <class T> int Thresholdcriteria(Param XParam,T threshold, T* z, BlockP<T> XBlock, bool*& refine, bool*& coarsen)
{
	// Threshold criteria is a general form of wet dry criteria where esp is the threshold and h is the parameter tested
	// Below is written as a wet dry analogy where wet is vlaue above threshold and dry is below

	
	int success = 0;
	//int i;

	//Coarsen dry blocks and refine wet ones
	//CPU version


	// To start we assume all values are below the threshold
	bool iswet = false;
	for (int ibl = 0; ibl < XParam.nblk; ibl++)
	{
		int ib = XBlock.active[ibl];
		refine[ib] = false; // only refine if all are wet
		coarsen[ib] = true; // always try to coarsen
		iswet = false;
		for (int iy = 0; iy < XParam.blkwidth; iy++)
		{
			for (int ix = 0; ix < XParam.blkwidth; ix++)
			{

				int i = (ix + XParam.halowidth) + (iy + XParam.halowidth) * XParam.blkmemwidth + ib * XParam.blksize;
				
				if (z[i] > threshold)
				{
					iswet = true;
				}
			}
		}


		refine[ib] = iswet;
		coarsen[ib] = !iswet;

		//printf("ib=%d; refibe[ib]=%s\n", ib, iswet ? "true" : "false");
	}
	return success;
}
template  int Thresholdcriteria<float>(Param XParam, float threshold, float* z, BlockP<float> XBlock, bool*& refine, bool*& coarsen);
template  int Thresholdcriteria<double>(Param XParam, double threshold, double* z, BlockP<double> XBlock, bool*& refine, bool*& coarsen);

/*! \fn int inrangecriteria(Param XParam, T zmin, T zmax, T* z, BlockP<T> XBlock, bool*& refine, bool*& coarsen)
* Simple in-range refining criteria.
* if any value of z (could be any variable) is zmin <= z <= zmax the block will try to refine
* otherwise, the block will try to coarsen
* beware the refinement sanity check is meant to be done after running this function
*/
template<class T>
int inrangecriteria(Param XParam, T zmin, T zmax, T* z, BlockP<T> XBlock, bool*& refine, bool*& coarsen)
{
	// First use a simple refining criteria: zb>zmin && zb<zmax refine otherwise corasen
	int success = 0;
	//int i;


	// To start 
	bool isinrange = false;
	for (int ibl = 0; ibl < XParam.nblk; ibl++)
	{
		int ib = XBlock.active[ibl];
		refine[ib] = false; // only refine if zb is in range
		coarsen[ib] = true; // always try to coarsen otherwise
		isinrange = false;
		for (int iy = 0; iy < XParam.blkwidth; iy++)
		{
			for (int ix = 0; ix < XParam.blkwidth; ix++)
			{
				int i = (ix + XParam.halowidth) + (iy + XParam.halowidth) * XParam.blkmemwidth + ib * XParam.blksize;
				if (z[i] >= zmin && z[i] <= zmax)
				{
					isinrange = true;
				}
			}
		}


		refine[ib] = isinrange;
		coarsen[ib] = !isinrange;

		//printf("ib=%d; refibe[ib]=%s\n", ib, iswet ? "true" : "false");
	}
	return success;
}
template int inrangecriteria<float>(Param XParam, float zmin, float zmax, float* z, BlockP<float> XBlock, bool*& refine, bool*& coarsen);
template int inrangecriteria<double>(Param XParam, double zmin, double zmax, double* z, BlockP<double> XBlock, bool*& refine, bool*& coarsen);


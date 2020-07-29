
#include "MemManagement.h"

__host__ int memloc(Param XParam, int i, int j, int ib)
{
	return (i+XParam.halowidth) + (j + XParam.halowidth) * XParam.blkmemwidth + ib * XParam.blksize;
}

template <class T> __host__ void AllocateCPU(int nx, int ny, T *&zb)
{
	zb = (T *)malloc(nx*ny * sizeof(T));
	if (!zb)
	{
		fprintf(stderr, "Memory allocation failure\n");

		exit(EXIT_FAILURE);
	}
}



template <class T> __host__ void AllocateCPU(int nx, int ny, T *&zs, T *&h, T *&u, T *&v)
{

	AllocateCPU(nx, ny, zs);
	AllocateCPU(nx, ny, h);
	AllocateCPU(nx, ny, u);
	AllocateCPU(nx, ny, v);

}

template void AllocateCPU<double>(int nx, int ny, double *&zs, double *&h, double *&u, double *&v);
template void AllocateCPU<float>(int nx, int ny, float *&zs, float *&h, float *&u, float *&v);
template void AllocateCPU<int>(int nx, int ny, int *&zs, int *&h, int *&u, int *&v);

template <class T> __host__
void AllocateCPU(int nx, int ny, GradientsP<T>& Grad)
{
	AllocateCPU(nx, ny, Grad.dhdx, Grad.dzsdx, Grad.dudx, Grad.dvdx);
	AllocateCPU(nx, ny, Grad.dhdy, Grad.dzsdy, Grad.dudy, Grad.dvdy);
}
template void AllocateCPU<float>(int nx, int ny, GradientsP<float>& Grad);
template void AllocateCPU<double>(int nx, int ny, GradientsP<double>& Grad);

template <class T> void AllocateCPU(int nblk, int blksize, EvolvingP<T> & Ev)
{
	AllocateCPU(nblk, blksize, Ev.h, Ev.zs, Ev.u, Ev.v);
}



template <class T>
void AllocateCPU(int nblk, int blksize, Param XParam, Model<T>& XModel)
{
	// Allocate blocks data 
	AllocateCPU(nblk, blksize, XModel.evolv);
	AllocateCPU(nblk, blksize, XModel.evolv_o);

	AllocateCPU(nblk, blksize, XModel.grad.dhdy, XModel.grad.dzsdy, XModel.grad.dudy, XModel.grad.dvdy);

	AllocateCPU(nblk, blksize, XModel.flux.Fhu, XModel.flux.Fhv, XModel.flux.Fqux, XModel.flux.Fquy);

	AllocateCPU(nblk, blksize, XModel.flux.Fqvx, XModel.flux.Fqvy, XModel.flux.Su, XModel.flux.Sv);

	AllocateCPU(nblk, blksize, XModel.zb, XModel.adv.dh, XModel.adv.dhu, XModel.adv.dhv);

	AllocateCPU(nblk, blksize, XModel.cf, XModel.time.arrmax, XModel.time.arrmin, XModel.time.dtmax);
	

	//Allocate block info
	AllocateCPU(nblk, 1, XModel.blocks.active);
	AllocateCPU(nblk, 1, XModel.blocks.level);

	AllocateCPU(nblk, 1, XModel.blocks.BotLeft, XModel.blocks.BotRight, XModel.blocks.LeftBot, XModel.blocks.LeftTop);
	AllocateCPU(nblk, 1, XModel.blocks.RightBot, XModel.blocks.RightTop, XModel.blocks.TopLeft, XModel.blocks.TopRight);

	AllocateCPU(nblk, 1, XModel.blocks.xo);
	AllocateCPU(nblk, 1, XModel.blocks.yo);

	// If no adatptation ignore this!
	if (XParam.maxlevel != XParam.minlevel)
	{
		AllocateCPU(nblk, 1, XModel.adapt.availblk, XModel.adapt.csumblk, XModel.adapt.invactive, XModel.adapt.newlevel);
		AllocateCPU(nblk, 1, XModel.adapt.coarsen);
		AllocateCPU(nblk, 1, XModel.adapt.refine);
	}
	

	if (XParam.atmpforcing)
	{
		AllocateCPU(nblk, blksize, XModel.datmpdx);
		AllocateCPU(nblk, blksize, XModel.datmpdy);
	}


	if (XParam.outmax)
	{
		AllocateCPU(nblk, blksize, XModel.evmax);
	}
	if (XParam.outmean)
	{
		AllocateCPU(nblk, blksize, XModel.evmean);
	}

	//AllocateCPU(nx, ny, XModel.);



}

template void AllocateCPU<float>(int nblk, int blksize, Param XParam, Model<float>& XModel);
template void AllocateCPU<double>(int nblk, int blksize, Param XParam, Model<double>& XModel);




template <class T> __host__ void ReallocArray(int nblk, int blksize, T* & zb)
{
	//

	zb = (T*)realloc(zb, nblk * blksize * sizeof(T));
	if (zb == NULL)
	{
		fprintf(stderr, "Memory reallocation failure\n");

		exit(EXIT_FAILURE);
	}
	//return nblkmem
}

template void ReallocArray<int>(int nblk, int blksize, int* & zb);
template void ReallocArray<float>(int nblk, int blksize, float* & zb);
template void ReallocArray<double>(int nblk, int blksize, double* & zb);

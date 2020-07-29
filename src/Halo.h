
#ifndef HALO_H
#define HALO_H

#include "General.h"
#include "Param.h"
#include "Write_txt.h"
#include "Util_CPU.h"
#include "Arrays.h"
#include "Mesh.h"
#include "MemManagement.h"

template <class T> void fillHalo(Param XParam, int ib, BlockP<T> XBlock, T*& z);
template <class T> void fillHalo(Param XParam, BlockP<T> XBlock, EvolvingP<T> Xev);
template <class T> void fillLeft(Param XParam, int ib, BlockP<T> XBlock, T*& z);
template <class T> void fillRight(Param XParam, int ib, BlockP<T> XBlock, T*& z);
template <class T> void fillBot(Param XParam, int ib, BlockP<T> XBlock, T*& z);
// End of global definition
#endif
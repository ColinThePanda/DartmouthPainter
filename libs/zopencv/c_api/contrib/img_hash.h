#ifndef OPENCV_IMG_HASH_H
#define OPENCV_IMG_HASH_H

#include "../core.h"

#ifdef __cplusplus
extern "C" {
#endif

// ============================================================================
// Image Hashing Algorithms
// ============================================================================

/// Opaque pointer for ImgHashBase
typedef struct ImgHashBase ImgHashBase;

// Average Hash (aHash)
ImgHashBase *AverageHash_Create();

// Perceptual Hash (pHash)
ImgHashBase *PHash_Create();

// Difference Hash (dHash)
ImgHashBase *BlockMeanHash_Create(int mode);

// Marr-Hildreth Hash
ImgHashBase *MarrHildrethHash_Create(float alpha, float scale);

// Radial Variance Hash
ImgHashBase *RadialVarianceHash_Create(double sigma, int numOfAngleLine);

// Color Moment Hash
ImgHashBase *ColorMomentHash_Create();

/// Delete hash object
void ImgHashBase_Delete(ImgHashBase *ptr);

/// Compute hash for an image
void ImgHashBase_Compute(ImgHashBase *ptr, Mat *inputArr, Mat *outputArr);

/// Compare two hashes
double ImgHashBase_Compare(ImgHashBase *ptr, Mat *hashOne, Mat *hashTwo);

#ifdef __cplusplus
}
#endif

#endif // OPENCV_IMG_HASH_H

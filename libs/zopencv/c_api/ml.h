#ifndef OPENCV_ML_H
#define OPENCV_ML_H

#include "core.h"

#ifdef __cplusplus
extern "C" {
#endif

// Opaque pointer types
typedef struct SVM SVM;
typedef struct KNearest KNearest;

// ============================================================================
// SVM (Support Vector Machine)
// ============================================================================

/// Create SVM model
SVM *SVM_Create();

/// Delete SVM model
void SVM_Delete(SVM *svm);

/// Train SVM model
/// layout: 0 = ROW_SAMPLE, 1 = COL_SAMPLE
void SVM_Train(SVM *svm, Mat *samples, int layout, Mat *responses);

/// Predict using SVM
float SVM_Predict(SVM *svm, Mat *samples, Mat *results, int flags);

/// Set SVM type
void SVM_SetType(SVM *svm, int type);

/// Set kernel type
void SVM_SetKernel(SVM *svm, int kernel);

/// Set C parameter
void SVM_SetC(SVM *svm, double c);

/// Set gamma parameter
void SVM_SetGamma(SVM *svm, double gamma);

/// Get SVM type
int SVM_GetType(SVM *svm);

/// Get kernel type
int SVM_GetKernel(SVM *svm);

// ============================================================================
// KNearest (K-Nearest Neighbors)
// ============================================================================

/// Create KNearest model
KNearest *KNearest_Create();

/// Delete KNearest model
void KNearest_Delete(KNearest *knn);

/// Train KNearest model
void KNearest_Train(KNearest *knn, Mat *samples, int layout, Mat *responses);

/// Predict using KNearest
/// Returns predicted value
float KNearest_Predict(KNearest *knn, Mat *samples, Mat *results,
                       Mat *neighborResponses, Mat *dist);

/// Set default K value
void KNearest_SetDefaultK(KNearest *knn, int k);

/// Get default K value
int KNearest_GetDefaultK(KNearest *knn);

/// Set algorithm type
void KNearest_SetAlgorithmType(KNearest *knn, int alg);

#ifdef __cplusplus
}
#endif

#endif // OPENCV_ML_H

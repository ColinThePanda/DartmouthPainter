#ifndef OPENCV_FACE_H
#define OPENCV_FACE_H

#include "../core.h"

#ifdef __cplusplus
extern "C" {
#endif

// Opaque pointer types
typedef struct FaceRecognizer FaceRecognizer;

// ============================================================================
// FaceRecognizer (Base class for face recognition)
// ============================================================================

/// Create Eigenfaces recognizer
/// num_components: Number of components (default 0 = keep all)
/// threshold: Confidence threshold (default DBL_MAX)
FaceRecognizer *FaceRecognizer_CreateEigenfaces(int num_components,
                                                double threshold);

/// Create Fisherfaces recognizer
/// num_components: Number of components (default 0 = keep all)
/// threshold: Confidence threshold (default DBL_MAX)
FaceRecognizer *FaceRecognizer_CreateFisherfaces(int num_components,
                                                 double threshold);

/// Create LBPH (Local Binary Patterns Histograms) recognizer
/// radius: Radius for building LBP (default 1)
/// neighbors: Number of neighbors (default 8)
/// grid_x: Number of cells in horizontal direction (default 8)
/// grid_y: Number of cells in vertical direction (default 8)
/// threshold: Confidence threshold (default DBL_MAX)
FaceRecognizer *FaceRecognizer_CreateLBPH(int radius, int neighbors, int grid_x,
                                          int grid_y, double threshold);

/// Delete FaceRecognizer
void FaceRecognizer_Delete(FaceRecognizer *recognizer);

/// Train the recognizer
/// images: Vector of training images
/// labels: Vector of corresponding labels
void FaceRecognizer_Train(FaceRecognizer *recognizer, Mats *images,
                          Mat *labels);

/// Predict label for given image
/// image: Input image
/// label: Output predicted label
/// confidence: Output confidence value
void FaceRecognizer_Predict(FaceRecognizer *recognizer, Mat *image, int *label,
                            double *confidence);

/// Save model to file
void FaceRecognizer_Save(FaceRecognizer *recognizer, const char *filename);

/// Load model from file
void FaceRecognizer_Load(FaceRecognizer *recognizer, const char *filename);

#ifdef __cplusplus
}
#endif

#endif // OPENCV_FACE_H

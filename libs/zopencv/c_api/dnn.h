#ifndef OPENCV_DNN_H
#define OPENCV_DNN_H

#include "core.h"

#ifdef __cplusplus
extern "C" {
#endif

// Opaque pointer type for neural network
typedef struct Net Net;

// ============================================================================
// Network Creation and Loading
// ============================================================================

/// Read a network model stored in Darknet (https://pjreddie.com/darknet/) model
/// files
Net *ReadNetFromDarknet(const char *cfgFile, const char *darknetModel);

/// Reads a network model stored in Caffe framework's format
Net *ReadNetFromCaffe(const char *prototxt, const char *caffeModel);

/// Reads a network model stored in TensorFlow framework's format
Net *ReadNetFromTensorflow(const char *model, const char *config);

/// Reads a network model stored in ONNX format
Net *ReadNetFromONNX(const char *onnxFile);

/// Reads a network model stored in Torch/PyTorch format
Net *ReadNetFromTorch(const char *model, int isBinary);

/// Reads a network model stored in TFLite format
Net *ReadNetFromTFLite(const char *model);

/// Create an empty neural network
Net *Net_New();

/// Delete neural network
void Net_Delete(Net *net);

/// Check if network is empty (no layers loaded)
int Net_Empty(Net *net);

// ============================================================================
// Network Configuration
// ============================================================================

/// Sets the new input value for the network
void Net_SetInput(Net *net, Mat *blob, const char *name);

/// Runs forward pass to compute output of layer with name outputName
Mat *Net_Forward(Net *net, const char *outputName);

/// Returns names of layers with unconnected outputs
char **Net_GetUnconnectedOutLayersNames(Net *net, int *size);

/// Sets the preferable backend for DNN computations
void Net_SetPreferableBackend(Net *net, int backendId);

/// Sets the preferable target device for DNN computations
void Net_SetPreferableTarget(Net *net, int targetId);

// ============================================================================
// Blob Creation
// ============================================================================

/// Creates 4-dimensional blob from image
Mat *BlobFromImage(Mat *image, double scalefactor, Size size, Scalar mean,
                   int swapRB, int crop, int ddepth);

// BlobFromImages removed - use blobFromImage in a loop instead
// Mat *BlobFromImages(Mat *images, int nimages, double scalefactor, Size size,
//                     Scalar mean, int swapRB, int crop, int ddepth);

// Net_ForwardLayers removed - use Net_Forward instead
// void Net_ForwardLayers(Net *net, Mat **outputBlobs, int *size,
//                        const char **outBlobNames, int nblobNames);

/// Returns overall network computation time in milliseconds
double Net_GetPerfProfile(Net *net);

// ============================================================================
// Layer Manipulation
// ============================================================================

/// Returns indexes of layers with unconnected outputs
int *Net_GetUnconnectedOutLayers(Net *net, int *size);

/// Returns names of all layers in the network
char **Net_GetLayerNames(Net *net, int *size);

// ============================================================================
// Utility Functions
// ============================================================================

/// Release string array allocated by OpenCV
void FreeStringArray(char **arr, int size);

/// Release int array allocated by OpenCV
void FreeIntArray(int *arr);

/// Returns network dump as string (caller must free with FreeCharPtr)
const char *Net_Dump(Net *net);

/// Free a char pointer allocated by the C++ side
void FreeCharPtr(const char *ptr);

// ============================================================================
// Post-processing
// ============================================================================

/// Perform non-maximum suppression on bounding boxes
void NMSBoxes(Rect *bboxes, int bboxes_count, float *scores, int scores_count,
              float score_threshold, float nms_threshold, int **indices,
              int *indices_count);

#ifdef __cplusplus
}
#endif

#endif // OPENCV_DNN_H

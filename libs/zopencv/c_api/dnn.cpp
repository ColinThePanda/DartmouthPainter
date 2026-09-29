#include "dnn.h"
#include <opencv2/dnn.hpp>
#include <vector>

extern "C" {

// ============================================================================
// Network Creation and Loading
// ============================================================================

Net *ReadNetFromDarknet(const char *cfgFile, const char *darknetModel) {
  try {
    cv::dnn::Net net;
    if (darknetModel && darknetModel[0] != '\0') {
      net = cv::dnn::readNetFromDarknet(cfgFile, darknetModel);
    } else {
      net = cv::dnn::readNetFromDarknet(cfgFile);
    }
    return reinterpret_cast<Net *>(new cv::dnn::Net(net));
  } catch (...) {
    return NULL;
  }
}

Net *ReadNetFromCaffe(const char *prototxt, const char *caffeModel) {
  try {
    cv::dnn::Net net;
    if (caffeModel && caffeModel[0] != '\0') {
      net = cv::dnn::readNetFromCaffe(prototxt, caffeModel);
    } else {
      net = cv::dnn::readNetFromCaffe(prototxt);
    }
    return reinterpret_cast<Net *>(new cv::dnn::Net(net));
  } catch (...) {
    return NULL;
  }
}

Net *ReadNetFromTensorflow(const char *model, const char *config) {
  try {
    cv::dnn::Net net;
    if (config && config[0] != '\0') {
      net = cv::dnn::readNetFromTensorflow(model, config);
    } else {
      net = cv::dnn::readNetFromTensorflow(model);
    }
    return reinterpret_cast<Net *>(new cv::dnn::Net(net));
  } catch (...) {
    return NULL;
  }
}

Net *ReadNetFromONNX(const char *onnxFile) {
  try {
    cv::dnn::Net net = cv::dnn::readNetFromONNX(onnxFile);
    return reinterpret_cast<Net *>(new cv::dnn::Net(net));
  } catch (...) {
    return NULL;
  }
}

Net *ReadNetFromTorch(const char *model, int isBinary) {
  try {
    cv::dnn::Net net = cv::dnn::readNetFromTorch(model, isBinary != 0);
    return reinterpret_cast<Net *>(new cv::dnn::Net(net));
  } catch (...) {
    return NULL;
  }
}

Net *ReadNetFromTFLite(const char *model) {
  try {
    cv::dnn::Net net = cv::dnn::readNetFromTFLite(model);
    return reinterpret_cast<Net *>(new cv::dnn::Net(net));
  } catch (...) {
    return NULL;
  }
}

Net *Net_New() { return reinterpret_cast<Net *>(new cv::dnn::Net()); }

void Net_Delete(Net *net) { delete reinterpret_cast<cv::dnn::Net *>(net); }

int Net_Empty(Net *net) {
  cv::dnn::Net *n = reinterpret_cast<cv::dnn::Net *>(net);
  return n->empty() ? 1 : 0;
}

// ============================================================================
// Network Configuration
// ============================================================================

void Net_SetInput(Net *net, Mat *blob, const char *name) {
  cv::dnn::Net *n = reinterpret_cast<cv::dnn::Net *>(net);
  if (name && name[0] != '\0') {
    n->setInput(*reinterpret_cast<cv::Mat *>(blob), name);
  } else {
    n->setInput(*reinterpret_cast<cv::Mat *>(blob));
  }
}

Mat *Net_Forward(Net *net, const char *outputName) {
  cv::dnn::Net *n = reinterpret_cast<cv::dnn::Net *>(net);
  cv::Mat result;
  if (outputName && outputName[0] != '\0') {
    result = n->forward(outputName);
  } else {
    result = n->forward();
  }
  return reinterpret_cast<Mat *>(new cv::Mat(result));
}

char **Net_GetUnconnectedOutLayersNames(Net *net, int *size) {
  cv::dnn::Net *n = reinterpret_cast<cv::dnn::Net *>(net);
  std::vector<std::string> names = n->getUnconnectedOutLayersNames();

  *size = static_cast<int>(names.size());
  char **result = new char *[names.size()];

  for (size_t i = 0; i < names.size(); i++) {
    result[i] = new char[names[i].length() + 1];
    std::strcpy(result[i], names[i].c_str());
  }

  return result;
}

void Net_SetPreferableBackend(Net *net, int backendId) {
  cv::dnn::Net *n = reinterpret_cast<cv::dnn::Net *>(net);
  n->setPreferableBackend(backendId);
}

void Net_SetPreferableTarget(Net *net, int targetId) {
  cv::dnn::Net *n = reinterpret_cast<cv::dnn::Net *>(net);
  n->setPreferableTarget(targetId);
}

// ============================================================================
// Blob Creation
// ============================================================================

Mat *BlobFromImage(Mat *image, double scalefactor, Size size, Scalar mean,
                   int swapRB, int crop, int ddepth) {
  cv::Size cv_size(size.width, size.height);
  cv::Scalar cv_mean(mean.v0, mean.v1, mean.v2, mean.v3);

  cv::Mat blob =
      cv::dnn::blobFromImage(*reinterpret_cast<cv::Mat *>(image), scalefactor,
                             cv_size, cv_mean, swapRB != 0, crop != 0, ddepth);

  return reinterpret_cast<Mat *>(new cv::Mat(blob));
}

// BlobFromImages removed - use blobFromImage in a loop instead

// Net_ForwardLayers removed - use Net_Forward instead

double Net_GetPerfProfile(Net *net) {
  cv::dnn::Net *n = reinterpret_cast<cv::dnn::Net *>(net);
  std::vector<double> layersTimes;
  return n->getPerfProfile(layersTimes);
}

// ============================================================================
// Layer Manipulation
// ============================================================================

int *Net_GetUnconnectedOutLayers(Net *net, int *size) {
  cv::dnn::Net *n = reinterpret_cast<cv::dnn::Net *>(net);
  std::vector<int> layers = n->getUnconnectedOutLayers();

  *size = static_cast<int>(layers.size());
  int *result = new int[layers.size()];

  for (size_t i = 0; i < layers.size(); i++) {
    result[i] = layers[i];
  }

  return result;
}

char **Net_GetLayerNames(Net *net, int *size) {
  cv::dnn::Net *n = reinterpret_cast<cv::dnn::Net *>(net);
  std::vector<std::string> names = n->getLayerNames();

  *size = static_cast<int>(names.size());
  char **result = new char *[names.size()];

  for (size_t i = 0; i < names.size(); i++) {
    result[i] = new char[names[i].length() + 1];
    std::strcpy(result[i], names[i].c_str());
  }

  return result;
}

// ============================================================================
// Utility Functions
// ============================================================================

void FreeStringArray(char **arr, int size) {
  for (int i = 0; i < size; i++) {
    delete[] arr[i];
  }
  delete[] arr;
}

void FreeIntArray(int *arr) { delete[] arr; }

const char *Net_Dump(Net *net) {
  cv::dnn::Net *n = reinterpret_cast<cv::dnn::Net *>(net);
  if (n->empty()) {
    // Return empty string for empty networks to avoid OpenCV assertion
    char *result = new char[1];
    result[0] = '\0';
    return result;
  }
  std::string dump = n->dump();
  char *result = new char[dump.length() + 1];
  std::strcpy(result, dump.c_str());
  return result;
}

void FreeCharPtr(const char *ptr) { delete[] ptr; }

// ============================================================================
// Post-processing
// ============================================================================

void NMSBoxes(Rect *bboxes, int bboxes_count, float *scores, int scores_count,
              float score_threshold, float nms_threshold, int **indices,
              int *indices_count) {
  std::vector<cv::Rect> boxes;
  boxes.reserve(bboxes_count);
  for (int i = 0; i < bboxes_count; i++) {
    boxes.push_back(
        cv::Rect(bboxes[i].x, bboxes[i].y, bboxes[i].width, bboxes[i].height));
  }

  std::vector<float> scores_vec(scores, scores + scores_count);
  std::vector<int> result;

  cv::dnn::NMSBoxes(boxes, scores_vec, score_threshold, nms_threshold, result);

  *indices_count = static_cast<int>(result.size());
  *indices = new int[result.size()];
  for (size_t i = 0; i < result.size(); i++) {
    (*indices)[i] = result[i];
  }
}

} // extern "C"

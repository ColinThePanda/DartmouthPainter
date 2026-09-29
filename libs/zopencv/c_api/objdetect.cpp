#include "objdetect.h"
#include <opencv2/objdetect.hpp>

extern "C" {

// RectVector functions
RectVector *RectVector_New() {
  return reinterpret_cast<RectVector *>(new std::vector<cv::Rect>());
}

void RectVector_Delete(RectVector *rv) {
  delete reinterpret_cast<std::vector<cv::Rect> *>(rv);
}

size_t RectVector_Size(RectVector *rv) {
  return reinterpret_cast<std::vector<cv::Rect> *>(rv)->size();
}

Rect RectVector_At(RectVector *rv, size_t index) {
  cv::Rect &r = reinterpret_cast<std::vector<cv::Rect> *>(rv)->at(index);
  Rect rect;
  rect.x = r.x;
  rect.y = r.y;
  rect.width = r.width;
  rect.height = r.height;
  return rect;
}

// CascadeClassifier functions
CascadeClassifier *CascadeClassifier_New() {
  return reinterpret_cast<CascadeClassifier *>(new cv::CascadeClassifier());
}

CascadeClassifier *CascadeClassifier_NewFromFile(const char *filename) {
  return reinterpret_cast<CascadeClassifier *>(
      new cv::CascadeClassifier(filename));
}

void CascadeClassifier_Delete(CascadeClassifier *cc) {
  delete reinterpret_cast<cv::CascadeClassifier *>(cc);
}

int CascadeClassifier_Load(CascadeClassifier *cc, const char *filename) {
  return reinterpret_cast<cv::CascadeClassifier *>(cc)->load(filename) ? 1 : 0;
}

int CascadeClassifier_Empty(CascadeClassifier *cc) {
  return reinterpret_cast<cv::CascadeClassifier *>(cc)->empty() ? 1 : 0;
}

void CascadeClassifier_DetectMultiScale(CascadeClassifier *cc, Mat *image,
                                        RectVector *objects, double scaleFactor,
                                        int minNeighbors, int flags,
                                        Size minSize, Size maxSize) {
  cv::CascadeClassifier *classifier =
      reinterpret_cast<cv::CascadeClassifier *>(cc);
  cv::Mat *img = reinterpret_cast<cv::Mat *>(image);
  std::vector<cv::Rect> *objs =
      reinterpret_cast<std::vector<cv::Rect> *>(objects);
  classifier->detectMultiScale(*img, *objs, scaleFactor, minNeighbors, flags,
                               cv::Size(minSize.width, minSize.height),
                               cv::Size(maxSize.width, maxSize.height));
}

// HOGDescriptor functions
HOGDescriptor *HOGDescriptor_New() {
  return reinterpret_cast<HOGDescriptor *>(new cv::HOGDescriptor());
}

void HOGDescriptor_Delete(HOGDescriptor *hog) {
  delete reinterpret_cast<cv::HOGDescriptor *>(hog);
}

void HOGDescriptor_SetSVMDetector(HOGDescriptor *hog, int detectorType) {
  cv::HOGDescriptor *descriptor = reinterpret_cast<cv::HOGDescriptor *>(hog);
  if (detectorType == HOG_DEFAULT_PEOPLE_DETECTOR) {
    descriptor->setSVMDetector(cv::HOGDescriptor::getDefaultPeopleDetector());
  } else if (detectorType == HOG_DAIMLER_PEOPLE_DETECTOR) {
    descriptor->setSVMDetector(cv::HOGDescriptor::getDaimlerPeopleDetector());
  }
}

void HOGDescriptor_DetectMultiScale(HOGDescriptor *hog, Mat *image,
                                    RectVector *foundLocations,
                                    double hitThreshold, Size winStride,
                                    Size padding, double scale,
                                    double finalThreshold,
                                    int useMeanshiftGrouping) {
  cv::HOGDescriptor *descriptor = reinterpret_cast<cv::HOGDescriptor *>(hog);
  cv::Mat *img = reinterpret_cast<cv::Mat *>(image);
  std::vector<cv::Rect> *locs =
      reinterpret_cast<std::vector<cv::Rect> *>(foundLocations);
  descriptor->detectMultiScale(*img, *locs, hitThreshold,
                               cv::Size(winStride.width, winStride.height),
                               cv::Size(padding.width, padding.height), scale,
                               finalThreshold, useMeanshiftGrouping != 0);
}

// ============================================================================
// QRCodeDetector
// ============================================================================

QRCodeDetector *QRCodeDetector_New() {
  return reinterpret_cast<QRCodeDetector *>(new cv::QRCodeDetector());
}

void QRCodeDetector_Delete(QRCodeDetector *qr) {
  delete reinterpret_cast<cv::QRCodeDetector *>(qr);
}

int QRCodeDetector_Detect(QRCodeDetector *qr, Mat *image, PointVector *points) {
  cv::QRCodeDetector *q = reinterpret_cast<cv::QRCodeDetector *>(qr);
  cv::Mat *img = reinterpret_cast<cv::Mat *>(image);
  auto *pts = reinterpret_cast<std::vector<cv::Point> *>(points);

  // QRCodeDetector::detect uses Point2f, so convert
  std::vector<cv::Point2f> pts2f;
  bool found = q->detect(*img, pts2f);
  if (found) {
    pts->clear();
    for (const auto &p : pts2f) {
      pts->push_back(cv::Point(static_cast<int>(p.x), static_cast<int>(p.y)));
    }
  }
  return found ? 1 : 0;
}

int QRCodeDetector_Decode(QRCodeDetector *qr, Mat *image, PointVector *points,
                          Mat *straight_qrcode, char *buf, int bufSize) {
  cv::QRCodeDetector *q = reinterpret_cast<cv::QRCodeDetector *>(qr);
  cv::Mat *img = reinterpret_cast<cv::Mat *>(image);
  auto *pts = reinterpret_cast<std::vector<cv::Point> *>(points);
  cv::Mat *sq = reinterpret_cast<cv::Mat *>(straight_qrcode);

  std::vector<cv::Point2f> pts2f;
  for (const auto &p : *pts) {
    pts2f.push_back(
        cv::Point2f(static_cast<float>(p.x), static_cast<float>(p.y)));
  }

  try {
    std::string result = q->decode(*img, pts2f, *sq);
    int len = static_cast<int>(result.length());
    if (buf != nullptr && bufSize > 0) {
      int copyLen = std::min(len, bufSize - 1);
      std::memcpy(buf, result.c_str(), copyLen);
      buf[copyLen] = '\0';
    }
    return len;
  } catch (const cv::Exception &) {
    // OpenCV may throw on invalid inputs (e.g., empty points, type mismatch)
    if (buf != nullptr && bufSize > 0) {
      buf[0] = '\0';
    }
    return 0;
  }
}

int QRCodeDetector_DetectAndDecode(QRCodeDetector *qr, Mat *image,
                                   PointVector *points, Mat *straight_qrcode,
                                   char *buf, int bufSize) {
  cv::QRCodeDetector *q = reinterpret_cast<cv::QRCodeDetector *>(qr);
  cv::Mat *img = reinterpret_cast<cv::Mat *>(image);
  auto *pts = reinterpret_cast<std::vector<cv::Point> *>(points);
  cv::Mat *sq = reinterpret_cast<cv::Mat *>(straight_qrcode);

  std::vector<cv::Point2f> pts2f;
  std::string result = q->detectAndDecode(*img, pts2f, *sq);

  // Copy points back
  pts->clear();
  for (const auto &p : pts2f) {
    pts->push_back(cv::Point(static_cast<int>(p.x), static_cast<int>(p.y)));
  }

  int len = static_cast<int>(result.length());
  if (buf != nullptr && bufSize > 0) {
    int copyLen = std::min(len, bufSize - 1);
    std::memcpy(buf, result.c_str(), copyLen);
    buf[copyLen] = '\0';
  }
  return len;
}

} // extern "C"

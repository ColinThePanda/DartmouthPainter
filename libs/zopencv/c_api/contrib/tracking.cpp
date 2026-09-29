#include "tracking.h"
#include <opencv2/tracking.hpp>

extern "C" {

// ============================================================================
// Tracker (Legacy API)
// ============================================================================

Tracker *TrackerKCF_Create() {
  cv::Ptr<cv::Tracker> ptr = cv::TrackerKCF::create();
  return reinterpret_cast<Tracker *>(new cv::Ptr<cv::Tracker>(ptr));
}

Tracker *TrackerCSRT_Create() {
  cv::Ptr<cv::Tracker> ptr = cv::TrackerCSRT::create();
  return reinterpret_cast<Tracker *>(new cv::Ptr<cv::Tracker>(ptr));
}

Tracker *TrackerMIL_Create() {
  cv::Ptr<cv::Tracker> ptr = cv::TrackerMIL::create();
  return reinterpret_cast<Tracker *>(new cv::Ptr<cv::Tracker>(ptr));
}

void Tracker_Delete(Tracker *tracker) {
  delete reinterpret_cast<cv::Ptr<cv::Tracker> *>(tracker);
}

int Tracker_Init(Tracker *tracker, Mat *image, Rect boundingBox) {
  cv::Ptr<cv::Tracker> *ptr = reinterpret_cast<cv::Ptr<cv::Tracker> *>(tracker);
  cv::Rect bbox(boundingBox.x, boundingBox.y, boundingBox.width,
                boundingBox.height);
  try {
    (*ptr)->init(*reinterpret_cast<cv::Mat *>(image), bbox);
    return 1;
  } catch (...) {
    return 0;
  }
}

int Tracker_Update(Tracker *tracker, Mat *image, Rect *boundingBox) {
  cv::Ptr<cv::Tracker> *ptr = reinterpret_cast<cv::Ptr<cv::Tracker> *>(tracker);
  cv::Rect bbox;
  bool success = (*ptr)->update(*reinterpret_cast<cv::Mat *>(image), bbox);

  if (success) {
    boundingBox->x = bbox.x;
    boundingBox->y = bbox.y;
    boundingBox->width = bbox.width;
    boundingBox->height = bbox.height;
  }

  return success ? 1 : 0;
}

} // extern "C"

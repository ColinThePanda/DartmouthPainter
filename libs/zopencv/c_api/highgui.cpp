#include "highgui.h"
#include <opencv2/highgui.hpp>

extern "C" {

void ImShow(const char *winname, Mat *mat) {
  cv::Mat *m = reinterpret_cast<cv::Mat *>(mat);
  cv::imshow(winname, *m);
}

int WaitKey(int delay) { return cv::waitKey(delay); }

void DestroyWindow(const char *winname) { cv::destroyWindow(winname); }

void DestroyAllWindows() { cv::destroyAllWindows(); }

void NamedWindow(const char *winname, int flags) {
  cv::namedWindow(winname, flags);
}

void ResizeWindow(const char *winname, int width, int height) {
  cv::resizeWindow(winname, width, height);
}

void MoveWindow(const char *winname, int x, int y) {
  cv::moveWindow(winname, x, y);
}

void SetWindowProperty(const char *winname, int prop_id, double prop_value) {
  cv::setWindowProperty(winname, prop_id, prop_value);
}

double GetWindowProperty(const char *winname, int prop_id) {
  return cv::getWindowProperty(winname, prop_id);
}

int WaitKeyEx(int delay) { return cv::waitKeyEx(delay); }

int PollKey() { return cv::pollKey(); }

void zocv_SetWindowTitle(const char *winname, const char *title) {
  cv::setWindowTitle(winname, title);
}

Rect SelectROI(const char *winname, Mat *img, int showCrosshair,
               int fromCenter) {
  cv::Rect r = cv::selectROI(winname, *(cv::Mat *)img, showCrosshair != 0,
                             fromCenter != 0);
  Rect result;
  result.x = r.x;
  result.y = r.y;
  result.width = r.width;
  result.height = r.height;
  return result;
}

void CreateTrackbar(const char *trackbarname, const char *winname, int *value,
                    int count, TrackbarCallback onChange) {
  cv::createTrackbar(trackbarname, winname, value, count,
                     (cv::TrackbarCallback)onChange);
}

int GetTrackbarPos(const char *trackbarname, const char *winname) {
  return cv::getTrackbarPos(trackbarname, winname);
}

void SetTrackbarPos(const char *trackbarname, const char *winname, int pos) {
  cv::setTrackbarPos(trackbarname, winname, pos);
}

void SetTrackbarMin(const char *trackbarname, const char *winname, int minval) {
  cv::setTrackbarMin(trackbarname, winname, minval);
}

void SetTrackbarMax(const char *trackbarname, const char *winname, int maxval) {
  cv::setTrackbarMax(trackbarname, winname, maxval);
}

void SetMouseCallback(const char *winname, MouseCallback onMouse,
                      void *userdata) {
  cv::setMouseCallback(winname, (cv::MouseCallback)onMouse, userdata);
}

} // extern "C"

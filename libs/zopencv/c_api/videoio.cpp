#include "videoio.h"
#include <opencv2/videoio.hpp>

extern "C" {

VideoCapture *VideoCapture_New() {
  return reinterpret_cast<VideoCapture *>(new cv::VideoCapture());
}

VideoCapture *VideoCapture_NewFromIndex(int index) {
  return reinterpret_cast<VideoCapture *>(new cv::VideoCapture(index));
}

VideoCapture *VideoCapture_NewFromFile(const char *filename) {
  return reinterpret_cast<VideoCapture *>(new cv::VideoCapture(filename));
}

void VideoCapture_Delete(VideoCapture *vc) {
  delete reinterpret_cast<cv::VideoCapture *>(vc);
}

int VideoCapture_Open(VideoCapture *vc, const char *filename) {
  return reinterpret_cast<cv::VideoCapture *>(vc)->open(filename) ? 1 : 0;
}

int VideoCapture_OpenDevice(VideoCapture *vc, int index) {
  return reinterpret_cast<cv::VideoCapture *>(vc)->open(index) ? 1 : 0;
}

int VideoCapture_IsOpened(VideoCapture *vc) {
  return reinterpret_cast<cv::VideoCapture *>(vc)->isOpened() ? 1 : 0;
}

void VideoCapture_Release(VideoCapture *vc) {
  reinterpret_cast<cv::VideoCapture *>(vc)->release();
}

int VideoCapture_Read(VideoCapture *vc, Mat *frame) {
  cv::Mat *f = reinterpret_cast<cv::Mat *>(frame);
  return reinterpret_cast<cv::VideoCapture *>(vc)->read(*f) ? 1 : 0;
}

int VideoCapture_Grab(VideoCapture *vc) {
  return reinterpret_cast<cv::VideoCapture *>(vc)->grab() ? 1 : 0;
}

int VideoCapture_Retrieve(VideoCapture *vc, Mat *frame) {
  cv::Mat *f = reinterpret_cast<cv::Mat *>(frame);
  return reinterpret_cast<cv::VideoCapture *>(vc)->retrieve(*f) ? 1 : 0;
}

double VideoCapture_Get(VideoCapture *vc, int propId) {
  return reinterpret_cast<cv::VideoCapture *>(vc)->get(propId);
}

int VideoCapture_Set(VideoCapture *vc, int propId, double value) {
  return reinterpret_cast<cv::VideoCapture *>(vc)->set(propId, value) ? 1 : 0;
}

VideoWriter *VideoWriter_New() {
  return reinterpret_cast<VideoWriter *>(new cv::VideoWriter());
}

VideoWriter *VideoWriter_NewWithParams(const char *filename, int fourcc,
                                       double fps, Size frameSize,
                                       int isColor) {
  return reinterpret_cast<VideoWriter *>(new cv::VideoWriter(
      filename, fourcc, fps, cv::Size(frameSize.width, frameSize.height),
      isColor != 0));
}

void VideoWriter_Delete(VideoWriter *vw) {
  delete reinterpret_cast<cv::VideoWriter *>(vw);
}

int VideoWriter_Open(VideoWriter *vw, const char *filename, int fourcc,
                     double fps, Size frameSize, int isColor) {
  return reinterpret_cast<cv::VideoWriter *>(vw)->open(
             filename, fourcc, fps, cv::Size(frameSize.width, frameSize.height),
             isColor != 0)
             ? 1
             : 0;
}

int VideoWriter_IsOpened(VideoWriter *vw) {
  return reinterpret_cast<cv::VideoWriter *>(vw)->isOpened() ? 1 : 0;
}

void VideoWriter_Release(VideoWriter *vw) {
  reinterpret_cast<cv::VideoWriter *>(vw)->release();
}

void VideoWriter_Write(VideoWriter *vw, Mat *frame) {
  cv::Mat *f = reinterpret_cast<cv::Mat *>(frame);
  reinterpret_cast<cv::VideoWriter *>(vw)->write(*f);
}

int VideoWriter_FourCC(char c1, char c2, char c3, char c4) {
  return cv::VideoWriter::fourcc(c1, c2, c3, c4);
}

// API-specified functions

VideoCapture *VideoCapture_NewFromFileWithAPI(const char *filename,
                                              int apiPreference) {
  return reinterpret_cast<VideoCapture *>(
      new cv::VideoCapture(filename, apiPreference));
}

VideoCapture *VideoCapture_NewFromIndexWithAPI(int index, int apiPreference) {
  return reinterpret_cast<VideoCapture *>(
      new cv::VideoCapture(index, apiPreference));
}

int VideoCapture_OpenWithAPI(VideoCapture *vc, const char *filename,
                             int apiPreference) {
  return reinterpret_cast<cv::VideoCapture *>(vc)->open(filename, apiPreference)
             ? 1
             : 0;
}

int VideoCapture_OpenDeviceWithAPI(VideoCapture *vc, int index,
                                   int apiPreference) {
  return reinterpret_cast<cv::VideoCapture *>(vc)->open(index, apiPreference)
             ? 1
             : 0;
}

const char *VideoCapture_GetBackendName(VideoCapture *vc) {
  static thread_local std::string name;
  name = reinterpret_cast<cv::VideoCapture *>(vc)->getBackendName();
  return name.c_str();
}

VideoWriter *VideoWriter_NewWithParamsAndAPI(const char *filename,
                                             int apiPreference, int fourcc,
                                             double fps, Size frameSize,
                                             int isColor) {
  return reinterpret_cast<VideoWriter *>(new cv::VideoWriter(
      filename, apiPreference, fourcc, fps,
      cv::Size(frameSize.width, frameSize.height), isColor != 0));
}

int VideoWriter_OpenWithAPI(VideoWriter *vw, const char *filename,
                            int apiPreference, int fourcc, double fps,
                            Size frameSize, int isColor) {
  return reinterpret_cast<cv::VideoWriter *>(vw)->open(
             filename, apiPreference, fourcc, fps,
             cv::Size(frameSize.width, frameSize.height), isColor != 0)
             ? 1
             : 0;
}

const char *VideoWriter_GetBackendName(VideoWriter *vw) {
  static thread_local std::string name;
  name = reinterpret_cast<cv::VideoWriter *>(vw)->getBackendName();
  return name.c_str();
}

} // extern "C"

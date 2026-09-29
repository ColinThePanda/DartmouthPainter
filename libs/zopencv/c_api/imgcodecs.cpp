#include "imgcodecs.h"
#include <opencv2/imgcodecs.hpp>

extern "C" {

Mat *ImRead(const char *filename, int flags) {
  cv::Mat img = cv::imread(filename, flags);
  if (img.empty()) {
    return nullptr;
  }
  return reinterpret_cast<Mat *>(new cv::Mat(img));
}

int ImWrite(const char *filename, Mat *img) {
  cv::Mat *m = reinterpret_cast<cv::Mat *>(img);
  return cv::imwrite(filename, *m) ? 1 : 0;
}

int ImWriteWithParams(const char *filename, Mat *img, int *params,
                      int params_count) {
  cv::Mat *m = reinterpret_cast<cv::Mat *>(img);
  std::vector<int> p(params, params + params_count);
  return cv::imwrite(filename, *m, p) ? 1 : 0;
}

struct ByteArray ImEncode(const char *ext, Mat *img, int *params,
                          int params_count) {
  cv::Mat *m = reinterpret_cast<cv::Mat *>(img);
  std::vector<int> p;
  if (params != nullptr && params_count > 0) {
    p.assign(params, params + params_count);
  }
  std::vector<unsigned char> buf;
  cv::imencode(ext, *m, buf, p);

  struct ByteArray result;
  result.length = static_cast<int>(buf.size());
  result.data =
      static_cast<unsigned char *>(malloc(static_cast<size_t>(result.length)));
  if (result.data != nullptr) {
    memcpy(result.data, buf.data(), static_cast<size_t>(result.length));
  }
  return result;
}

Mat *ImDecode(unsigned char *buf, int len, int flags) {
  std::vector<unsigned char> data(buf, buf + len);
  cv::Mat img = cv::imdecode(data, flags);
  if (img.empty()) {
    return nullptr;
  }
  return reinterpret_cast<Mat *>(new cv::Mat(img));
}

int ImReadMulti(const char *filename, int flags, Mat **mats, int *count) {
  std::vector<cv::Mat> imgs;
  bool ok = cv::imreadmulti(filename, imgs, flags);
  if (!ok || imgs.empty()) {
    *count = 0;
    return 0;
  }
  *count = static_cast<int>(imgs.size());
  for (int i = 0; i < *count && mats != nullptr; i++) {
    mats[i] = reinterpret_cast<Mat *>(new cv::Mat(imgs[i]));
  }
  return 1;
}

int HaveImageReader(const char *filename) {
  return cv::haveImageReader(filename) ? 1 : 0;
}

int HaveImageWriter(const char *filename) {
  return cv::haveImageWriter(filename) ? 1 : 0;
}

int ImCount(const char *filename, int flags) {
  return static_cast<int>(cv::imcount(filename, flags));
}

} // extern "C"

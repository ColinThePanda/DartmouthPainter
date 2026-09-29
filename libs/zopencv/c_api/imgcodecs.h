#ifndef OPENCV_WRAPPER_IMGCODECS_H
#define OPENCV_WRAPPER_IMGCODECS_H

#include "core.h"

#ifdef __cplusplus
extern "C" {
#endif

// Image read modes
enum ImreadModes {
  IMREAD_UNCHANGED = -1,
  IMREAD_GRAYSCALE = 0,
  IMREAD_COLOR = 1,
};

// Image I/O functions
Mat *ImRead(const char *filename, int flags);
int ImWrite(const char *filename, Mat *img);
int ImWriteWithParams(const char *filename, Mat *img, int *params,
                      int params_count);

// Encode/Decode to/from memory buffer
struct ByteArray {
  unsigned char *data;
  int length;
};

struct ByteArray ImEncode(const char *ext, Mat *img, int *params,
                          int params_count);
Mat *ImDecode(unsigned char *buf, int len, int flags);

// Multi-page image support
int ImReadMulti(const char *filename, int flags, Mat **mats, int *count);

// Format support queries
int HaveImageReader(const char *filename);
int HaveImageWriter(const char *filename);
int ImCount(const char *filename, int flags);

#ifdef __cplusplus
}
#endif

#endif // OPENCV_WRAPPER_IMGCODECS_H

#ifndef OPENCV_WRAPPER_VIDEOIO_H
#define OPENCV_WRAPPER_VIDEOIO_H

#include "core.h"

#ifdef __cplusplus
extern "C" {
#endif

// Opaque pointer types
typedef struct VideoCapture VideoCapture;
typedef struct VideoWriter VideoWriter;

// Video capture properties
enum VideoCaptureProperties {
  CAP_PROP_POS_MSEC = 0,
  CAP_PROP_POS_FRAMES = 1,
  CAP_PROP_POS_AVI_RATIO = 2,
  CAP_PROP_FRAME_WIDTH = 3,
  CAP_PROP_FRAME_HEIGHT = 4,
  CAP_PROP_FPS = 5,
  CAP_PROP_FOURCC = 6,
  CAP_PROP_FRAME_COUNT = 7,
  CAP_PROP_FORMAT = 8,
  CAP_PROP_MODE = 9,
  CAP_PROP_BRIGHTNESS = 10,
  CAP_PROP_CONTRAST = 11,
  CAP_PROP_SATURATION = 12,
  CAP_PROP_HUE = 13,
  CAP_PROP_GAIN = 14,
  CAP_PROP_EXPOSURE = 15,
  CAP_PROP_CONVERT_RGB = 16,
  CAP_PROP_WHITE_BALANCE_BLUE_U = 17,
  CAP_PROP_RECTIFICATION = 18,
  CAP_PROP_MONOCHROME = 19,
  CAP_PROP_SHARPNESS = 20,
  CAP_PROP_AUTO_EXPOSURE = 21,
  CAP_PROP_GAMMA = 22,
  CAP_PROP_TEMPERATURE = 23,
  CAP_PROP_TRIGGER = 24,
  CAP_PROP_TRIGGER_DELAY = 25,
  CAP_PROP_WHITE_BALANCE_RED_V = 26,
  CAP_PROP_ZOOM = 27,
  CAP_PROP_FOCUS = 28,
  CAP_PROP_GUID = 29,
  CAP_PROP_ISO_SPEED = 30,
  CAP_PROP_BACKLIGHT = 32,
  CAP_PROP_PAN = 33,
  CAP_PROP_TILT = 34,
  CAP_PROP_ROLL = 35,
  CAP_PROP_IRIS = 36,
  CAP_PROP_SETTINGS = 37,
  CAP_PROP_BUFFERSIZE = 38,
  CAP_PROP_AUTOFOCUS = 39,
  CAP_PROP_BACKEND = 42,
  CAP_PROP_CHANNEL = 43,
  CAP_PROP_AUTO_WB = 44,
  CAP_PROP_WB_TEMPERATURE = 45,
  CAP_PROP_CODEC_PIXEL_FORMAT = 46,
  CAP_PROP_BITRATE = 47,
  CAP_PROP_ORIENTATION_META = 48,
  CAP_PROP_ORIENTATION_AUTO = 49,
  CAP_PROP_OPEN_TIMEOUT_MSEC = 53,
  CAP_PROP_READ_TIMEOUT_MSEC = 54,
};

enum VideoCaptureAPIs {
  CAP_ANY = 0,
  CAP_VFW = 200,
  CAP_V4L = 200,
  CAP_V4L2 = 200,
  CAP_FIREWIRE = 300,
  CAP_QT = 500,
  CAP_UNICAP = 600,
  CAP_DSHOW = 700,
  CAP_PVAPI = 800,
  CAP_OPENNI = 900,
  CAP_OPENNI_ASUS = 910,
  CAP_ANDROID = 1000,
  CAP_XIAPI = 1100,
  CAP_AVFOUNDATION = 1200,
  CAP_GIGANETIX = 1300,
  CAP_MSMF = 1400,
  CAP_WINRT = 1410,
  CAP_INTELPERC = 1500,
  CAP_REALSENSE = 1500,
  CAP_OPENNI2 = 1600,
  CAP_OPENNI2_ASUS = 1610,
  CAP_OPENNI2_ASTRA = 1620,
  CAP_GPHOTO2 = 1700,
  CAP_GSTREAMER = 1800,
  CAP_FFMPEG = 1900,
  CAP_IMAGES = 2000,
  CAP_ARAVIS = 2100,
  CAP_OPENCV_MJPEG = 2200,
  CAP_INTEL_MFX = 2300,
  CAP_XINE = 2400,
};

// VideoCapture functions
VideoCapture *VideoCapture_New();
VideoCapture *VideoCapture_NewFromIndex(int index);
VideoCapture *VideoCapture_NewFromFile(const char *filename);
void VideoCapture_Delete(VideoCapture *vc);
int VideoCapture_Open(VideoCapture *vc, const char *filename);
int VideoCapture_OpenDevice(VideoCapture *vc, int index);
int VideoCapture_IsOpened(VideoCapture *vc);
void VideoCapture_Release(VideoCapture *vc);
int VideoCapture_Read(VideoCapture *vc, Mat *frame);
int VideoCapture_Grab(VideoCapture *vc);
int VideoCapture_Retrieve(VideoCapture *vc, Mat *frame);
double VideoCapture_Get(VideoCapture *vc, int propId);
int VideoCapture_Set(VideoCapture *vc, int propId, double value);

// VideoWriter functions
VideoWriter *VideoWriter_New();
VideoWriter *VideoWriter_NewWithParams(const char *filename, int fourcc,
                                       double fps, Size frameSize, int isColor);
void VideoWriter_Delete(VideoWriter *vw);
int VideoWriter_Open(VideoWriter *vw, const char *filename, int fourcc,
                     double fps, Size frameSize, int isColor);
int VideoWriter_IsOpened(VideoWriter *vw);
void VideoWriter_Release(VideoWriter *vw);
void VideoWriter_Write(VideoWriter *vw, Mat *frame);

// Utility functions
int VideoWriter_FourCC(char c1, char c2, char c3, char c4);

// API-specified functions
VideoCapture *VideoCapture_NewFromFileWithAPI(const char *filename, int apiPreference);
VideoCapture *VideoCapture_NewFromIndexWithAPI(int index, int apiPreference);
int VideoCapture_OpenWithAPI(VideoCapture *vc, const char *filename, int apiPreference);
int VideoCapture_OpenDeviceWithAPI(VideoCapture *vc, int index, int apiPreference);
const char *VideoCapture_GetBackendName(VideoCapture *vc);

VideoWriter *VideoWriter_NewWithParamsAndAPI(const char *filename, int apiPreference,
                                             int fourcc, double fps, Size frameSize,
                                             int isColor);
int VideoWriter_OpenWithAPI(VideoWriter *vw, const char *filename, int apiPreference,
                            int fourcc, double fps, Size frameSize, int isColor);
const char *VideoWriter_GetBackendName(VideoWriter *vw);

#ifdef __cplusplus
}
#endif

#endif // OPENCV_WRAPPER_VIDEOIO_H

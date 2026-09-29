#ifndef OPENCV_WRAPPER_HIGHGUI_H
#define OPENCV_WRAPPER_HIGHGUI_H

#include "core.h"

#ifdef __cplusplus
extern "C" {
#endif

// Window flags
enum WindowFlags {
  WINDOW_NORMAL = 0x00000000,
  WINDOW_AUTOSIZE = 0x00000001,
  WINDOW_OPENGL = 0x00001000,
  WINDOW_FULLSCREEN = 1,
  WINDOW_FREERATIO = 0x00000100,
  WINDOW_KEEPRATIO = 0x00000000,
};

// Window property flags
enum WindowPropertyFlags {
  WND_PROP_FULLSCREEN = 0,
  WND_PROP_AUTOSIZE = 1,
  WND_PROP_ASPECT_RATIO = 2,
  WND_PROP_OPENGL = 3,
};

// Mouse event types
enum MouseEventTypes {
  EVENT_MOUSEMOVE = 0,
  EVENT_LBUTTONDOWN = 1,
  EVENT_RBUTTONDOWN = 2,
  EVENT_MBUTTONDOWN = 3,
  EVENT_LBUTTONUP = 4,
  EVENT_RBUTTONUP = 5,
  EVENT_MBUTTONUP = 6,
  EVENT_LBUTTONDBLCLK = 7,
  EVENT_RBUTTONDBLCLK = 8,
  EVENT_MBUTTONDBLCLK = 9,
  EVENT_MOUSEWHEEL = 10,
  EVENT_MOUSEHWHEEL = 11,
};

// HighGUI functions
void ImShow(const char *winname, Mat *mat);
int WaitKey(int delay);
void DestroyWindow(const char *winname);
void DestroyAllWindows();
void NamedWindow(const char *winname, int flags);
void ResizeWindow(const char *winname, int width, int height);
void MoveWindow(const char *winname, int x, int y);
void SetWindowProperty(const char *winname, int prop_id, double prop_value);
double GetWindowProperty(const char *winname, int prop_id);

// Additional highgui functions
int WaitKeyEx(int delay);
int PollKey(void);
void zocv_SetWindowTitle(const char *winname, const char *title);
Rect SelectROI(const char *winname, Mat *img, int showCrosshair,
               int fromCenter);

// Trackbar functions
typedef void (*TrackbarCallback)(int pos, void *userdata);
void CreateTrackbar(const char *trackbarname, const char *winname, int *value,
                    int count, TrackbarCallback onChange);
int GetTrackbarPos(const char *trackbarname, const char *winname);
void SetTrackbarPos(const char *trackbarname, const char *winname, int pos);
void SetTrackbarMin(const char *trackbarname, const char *winname, int minval);
void SetTrackbarMax(const char *trackbarname, const char *winname, int maxval);

// Mouse callback
typedef void (*MouseCallback)(int event, int x, int y, int flags,
                              void *userdata);
void SetMouseCallback(const char *winname, MouseCallback onMouse,
                      void *userdata);

#ifdef __cplusplus
}
#endif

#endif // OPENCV_WRAPPER_HIGHGUI_H

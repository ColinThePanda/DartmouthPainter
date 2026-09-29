#ifndef OPENCV_WRAPPER_OBJDETECT_H
#define OPENCV_WRAPPER_OBJDETECT_H

#include "core.h"

#ifdef __cplusplus
extern "C" {
#endif

// Opaque pointer types
typedef struct CascadeClassifier CascadeClassifier;
typedef struct RectVector RectVector;
typedef struct HOGDescriptor HOGDescriptor;

// RectVector functions
RectVector *RectVector_New();
void RectVector_Delete(RectVector *rv);
size_t RectVector_Size(RectVector *rv);
Rect RectVector_At(RectVector *rv, size_t index);

// CascadeClassifier functions
CascadeClassifier *CascadeClassifier_New();
CascadeClassifier *CascadeClassifier_NewFromFile(const char *filename);
void CascadeClassifier_Delete(CascadeClassifier *cc);
int CascadeClassifier_Load(CascadeClassifier *cc, const char *filename);
int CascadeClassifier_Empty(CascadeClassifier *cc);
void CascadeClassifier_DetectMultiScale(CascadeClassifier *cc, Mat *image,
                                        RectVector *objects, double scaleFactor,
                                        int minNeighbors, int flags,
                                        Size minSize, Size maxSize);

// HOGDescriptor functions
HOGDescriptor *HOGDescriptor_New();
void HOGDescriptor_Delete(HOGDescriptor *hog);
void HOGDescriptor_SetSVMDetector(HOGDescriptor *hog, int detectorType);
void HOGDescriptor_DetectMultiScale(HOGDescriptor *hog, Mat *image,
                                    RectVector *foundLocations,
                                    double hitThreshold, Size winStride,
                                    Size padding, double scale,
                                    double finalThreshold,
                                    int useMeanshiftGrouping);

// Predefined HOG detectors
enum HOGDetectorType {
  HOG_DEFAULT_PEOPLE_DETECTOR = 0,
  HOG_DAIMLER_PEOPLE_DETECTOR = 1,
};

// ============================================================================
// QRCodeDetector
// ============================================================================

typedef struct QRCodeDetector QRCodeDetector;

QRCodeDetector *QRCodeDetector_New();
void QRCodeDetector_Delete(QRCodeDetector *qr);

/// Detect QR code in image, returns 1 if found
int QRCodeDetector_Detect(QRCodeDetector *qr, Mat *image, PointVector *points);

/// Decode QR code given detected points, returns decoded string length
/// The decoded string is written to buf (up to bufSize), returns actual length
int QRCodeDetector_Decode(QRCodeDetector *qr, Mat *image, PointVector *points,
                          Mat *straight_qrcode, char *buf, int bufSize);

/// Detect and decode in one step
int QRCodeDetector_DetectAndDecode(QRCodeDetector *qr, Mat *image,
                                   PointVector *points, Mat *straight_qrcode,
                                   char *buf, int bufSize);

#ifdef __cplusplus
}
#endif

#endif // OPENCV_WRAPPER_OBJDETECT_H

#ifndef OPENCV_TEXT_H
#define OPENCV_TEXT_H

#include "../core.h"

#ifdef __cplusplus
extern "C" {
#endif

// Opaque pointer types
typedef struct TextDetectorCNN TextDetectorCNN;
typedef struct OCRTesseract OCRTesseract;

// ============================================================================
// TextDetectorCNN - CNN-based text detection
// ============================================================================

/// Create TextDetectorCNN
/// model_arch_filename: Path to model architecture file
/// model_weights_filename: Path to model weights file
TextDetectorCNN *TextDetectorCNN_Create(const char *model_arch_filename,
                                        const char *model_weights_filename);

/// Delete TextDetectorCNN
void TextDetectorCNN_Delete(TextDetectorCNN *detector);

/// Detect text regions in image
/// image: Input image
/// bbox: Output bounding boxes (vector of Rect)
/// confidence: Output confidence values
void TextDetectorCNN_Detect(TextDetectorCNN *detector, Mat *image, Mat *bbox,
                            Mat *confidence);

// ============================================================================
// OCRTesseract - Tesseract OCR
// ============================================================================

/// Create OCRTesseract
/// datapath: Path to tessdata directory (can be NULL for default)
/// language: Language code (e.g., "eng" for English)
/// char_whitelist: Character whitelist (can be NULL)
/// oem: OCR Engine Mode (0-3, default 3)
/// psm: Page Segmentation Mode (0-13, default 3)
OCRTesseract *OCRTesseract_Create(const char *datapath, const char *language,
                                  const char *char_whitelist, int oem, int psm);

/// Delete OCRTesseract
void OCRTesseract_Delete(OCRTesseract *ocr);

/// Run OCR on image
/// image: Input image
/// output_text: Output recognized text (caller must free)
/// component_rects: Output component rectangles (can be NULL)
/// component_texts: Output component texts (can be NULL)
/// component_confidences: Output confidences (can be NULL)
void OCRTesseract_Run(OCRTesseract *ocr, Mat *image, char **output_text,
                      Mat *component_rects, Mat *component_texts,
                      Mat *component_confidences);

#ifdef __cplusplus
}
#endif

#endif // OPENCV_TEXT_H

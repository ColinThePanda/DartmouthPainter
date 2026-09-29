#include "text.h"
#include <cstring>
#include <opencv2/text.hpp>

extern "C" {

// ============================================================================
// TextDetectorCNN
// ============================================================================

TextDetectorCNN *TextDetectorCNN_Create(const char *model_arch_filename,
                                        const char *model_weights_filename) {
  cv::Ptr<cv::text::TextDetectorCNN> ptr = cv::text::TextDetectorCNN::create(
      model_arch_filename, model_weights_filename);
  return reinterpret_cast<TextDetectorCNN *>(
      new cv::Ptr<cv::text::TextDetectorCNN>(ptr));
}

void TextDetectorCNN_Delete(TextDetectorCNN *detector) {
  delete reinterpret_cast<cv::Ptr<cv::text::TextDetectorCNN> *>(detector);
}

void TextDetectorCNN_Detect(TextDetectorCNN *detector, Mat *image, Mat *bbox,
                            Mat *confidence) {
  cv::Ptr<cv::text::TextDetectorCNN> *ptr =
      reinterpret_cast<cv::Ptr<cv::text::TextDetectorCNN> *>(detector);

  std::vector<cv::Rect> bboxes;
  std::vector<float> confidences;

  (*ptr)->detect(*reinterpret_cast<cv::Mat *>(image), bboxes, confidences);

  // Convert bboxes to Mat
  cv::Mat *bbox_mat = reinterpret_cast<cv::Mat *>(bbox);
  *bbox_mat = cv::Mat(bboxes.size(), 4, CV_32S);
  for (size_t i = 0; i < bboxes.size(); i++) {
    bbox_mat->at<int>(i, 0) = bboxes[i].x;
    bbox_mat->at<int>(i, 1) = bboxes[i].y;
    bbox_mat->at<int>(i, 2) = bboxes[i].width;
    bbox_mat->at<int>(i, 3) = bboxes[i].height;
  }

  // Convert confidences to Mat
  cv::Mat *conf_mat = reinterpret_cast<cv::Mat *>(confidence);
  *conf_mat = cv::Mat(confidences.size(), 1, CV_32F);
  for (size_t i = 0; i < confidences.size(); i++) {
    conf_mat->at<float>(i, 0) = confidences[i];
  }
}

// ============================================================================
// OCRTesseract
// ============================================================================

OCRTesseract *OCRTesseract_Create(const char *datapath, const char *language,
                                  const char *char_whitelist, int oem,
                                  int psm) {
  cv::Ptr<cv::text::OCRTesseract> ptr = cv::text::OCRTesseract::create(
      datapath ? datapath : nullptr, language ? language : "eng",
      char_whitelist ? char_whitelist : nullptr, oem, psm);
  return reinterpret_cast<OCRTesseract *>(
      new cv::Ptr<cv::text::OCRTesseract>(ptr));
}

void OCRTesseract_Delete(OCRTesseract *ocr) {
  delete reinterpret_cast<cv::Ptr<cv::text::OCRTesseract> *>(ocr);
}

void OCRTesseract_Run(OCRTesseract *ocr, Mat *image, char **output_text,
                      Mat *component_rects, Mat *component_texts,
                      Mat *component_confidences) {
  cv::Ptr<cv::text::OCRTesseract> *ptr =
      reinterpret_cast<cv::Ptr<cv::text::OCRTesseract> *>(ocr);

  std::string text;
  std::vector<cv::Rect> rects;
  std::vector<std::string> texts;
  std::vector<float> confidences;

  (*ptr)->run(*reinterpret_cast<cv::Mat *>(image), text, &rects, &texts,
              &confidences);

  // Allocate and copy output text
  *output_text = strdup(text.c_str());

  // Convert component_rects if provided
  if (component_rects) {
    cv::Mat *rects_mat = reinterpret_cast<cv::Mat *>(component_rects);
    *rects_mat = cv::Mat(rects.size(), 4, CV_32S);
    for (size_t i = 0; i < rects.size(); i++) {
      rects_mat->at<int>(i, 0) = rects[i].x;
      rects_mat->at<int>(i, 1) = rects[i].y;
      rects_mat->at<int>(i, 2) = rects[i].width;
      rects_mat->at<int>(i, 3) = rects[i].height;
    }
  }

  // Note: component_texts and component_confidences conversion omitted for
  // simplicity
}

} // extern "C"

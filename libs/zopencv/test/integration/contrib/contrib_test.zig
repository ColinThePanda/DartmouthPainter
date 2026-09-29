const std = @import("std");
const testing = std.testing;
const cv = @import("zopencv");

const test_image_lena = "testdata/images/lena.jpg";
const test_image_fruits = "testdata/images/fruits.jpg";

// ============================================================================
// ximgproc — edge-preserving filters and new APIs on real images
// ============================================================================

test "integration: ximgproc guidedFilter on real image" {
    var img = try cv.imgcodecs.imread(test_image_lena, .color);
    defer img.deinit();
    try testing.expect(!img.empty());

    var dst = try cv.Mat.init();
    defer dst.deinit();

    cv.contrib.ximgproc.guidedFilter(img, img, &dst, 8, 100.0);
    try testing.expect(!dst.empty());
    try testing.expectEqual(img.rows(), dst.rows());
    try testing.expectEqual(img.cols(), dst.cols());
    try testing.expectEqual(img.channels(), dst.channels());
}

test "integration: ximgproc bilateralTextureFilter on real image" {
    var img = try cv.imgcodecs.imread(test_image_fruits, .color);
    defer img.deinit();
    try testing.expect(!img.empty());

    var dst = try cv.Mat.init();
    defer dst.deinit();

    cv.contrib.ximgproc.bilateralTextureFilter(img, &dst, 3, 1, 0.5, 0.5);
    try testing.expect(!dst.empty());
    try testing.expectEqual(img.rows(), dst.rows());
    try testing.expectEqual(img.cols(), dst.cols());
}

test "integration: ximgproc anisotropicDiffusion on real image" {
    var img = try cv.imgcodecs.imread(test_image_lena, .color);
    defer img.deinit();
    try testing.expect(!img.empty());

    var dst = try cv.Mat.init();
    defer dst.deinit();

    cv.contrib.ximgproc.anisotropicDiffusion(img, &dst, 0.1, 30.0, 5);
    try testing.expect(!dst.empty());
    try testing.expectEqual(img.rows(), dst.rows());
    try testing.expectEqual(img.cols(), dst.cols());
}

test "integration: ximgproc thinning on real image" {
    var img = try cv.imgcodecs.imread(test_image_lena, .grayscale);
    defer img.deinit();
    try testing.expect(!img.empty());

    // Threshold to binary for thinning
    var binary = try cv.Mat.init();
    defer binary.deinit();
    _ = cv.imgproc.threshold(img, &binary, 128.0, 255.0, .binary);

    var thinned = try cv.Mat.init();
    defer thinned.deinit();

    cv.contrib.ximgproc.thinning(binary, &thinned, .ZHANGSUEN);
    try testing.expect(!thinned.empty());
    try testing.expectEqual(binary.rows(), thinned.rows());
    try testing.expectEqual(binary.cols(), thinned.cols());
}

test "integration: ximgproc niBlackThreshold on real image" {
    var img = try cv.imgcodecs.imread(test_image_lena, .grayscale);
    defer img.deinit();
    try testing.expect(!img.empty());

    var dst = try cv.Mat.init();
    defer dst.deinit();

    cv.contrib.ximgproc.niBlackThreshold(img, &dst, 255.0, 0, 15, -0.2, .SAUVOLA);
    try testing.expect(!dst.empty());
    try testing.expectEqual(img.rows(), dst.rows());
    try testing.expectEqual(img.cols(), dst.cols());
}

// ============================================================================
// xphoto — white balance, denoising, effects on real images
// ============================================================================

test "integration: xphoto WhiteBalancer on real image" {
    var img = try cv.imgcodecs.imread(test_image_fruits, .color);
    defer img.deinit();
    try testing.expect(!img.empty());

    var dst = try cv.Mat.init();
    defer dst.deinit();

    var wb = try cv.contrib.xphoto.WhiteBalancer.createGrayWorld();
    defer wb.deinit();

    wb.balanceWhite(img, &dst);
    try testing.expect(!dst.empty());
    try testing.expectEqual(img.rows(), dst.rows());
    try testing.expectEqual(img.cols(), dst.cols());
}

test "integration: xphoto oilPainting on real image" {
    var img = try cv.imgcodecs.imread(test_image_lena, .color);
    defer img.deinit();
    try testing.expect(!img.empty());

    var dst = try cv.Mat.init();
    defer dst.deinit();

    cv.contrib.xphoto.oilPainting(img, &dst, 5, 1);
    try testing.expect(!dst.empty());
    try testing.expectEqual(img.rows(), dst.rows());
    try testing.expectEqual(img.cols(), dst.cols());
}

test "integration: xphoto applyChannelGains on real image" {
    var img = try cv.imgcodecs.imread(test_image_fruits, .color);
    defer img.deinit();
    try testing.expect(!img.empty());

    var dst = try cv.Mat.init();
    defer dst.deinit();

    cv.contrib.xphoto.applyChannelGains(img, &dst, 1.5, 1.0, 0.5);
    try testing.expect(!dst.empty());
    try testing.expectEqual(img.rows(), dst.rows());
    try testing.expectEqual(img.cols(), dst.cols());
}

test "integration: xphoto BM3D denoising on real image" {
    var img = try cv.imgcodecs.imread(test_image_lena, .grayscale);
    defer img.deinit();
    try testing.expect(!img.empty());

    var dst = try cv.Mat.init();
    defer dst.deinit();

    cv.contrib.xphoto.bm3dDenoising(img, &dst, 10.0);
    try testing.expect(!dst.empty());
    try testing.expectEqual(img.rows(), dst.rows());
}

// ============================================================================
// bgsegm — background subtraction on real image
// ============================================================================

test "integration: bgsegm MOG on real image" {
    var img = try cv.imgcodecs.imread(test_image_lena, .color);
    defer img.deinit();
    try testing.expect(!img.empty());

    var bs = try cv.contrib.bgsegm.BackgroundSubtractor.createMOG(200, 5, 0.7, 0);
    defer bs.deinit();

    var fgmask = try cv.Mat.init();
    defer fgmask.deinit();

    // Feed a few frames to build up the background model
    var i: usize = 0;
    while (i < 3) : (i += 1) {
        bs.apply(img, &fgmask, -1);
    }

    try testing.expect(!fgmask.empty());
    try testing.expectEqual(img.rows(), fgmask.rows());
    try testing.expectEqual(img.cols(), fgmask.cols());
}

test "integration: bgsegm CNT getBackgroundImage" {
    var img = try cv.imgcodecs.imread(test_image_lena, .color);
    defer img.deinit();
    try testing.expect(!img.empty());

    // CNT supports getBackgroundImage (MOG does not)
    var bs = try cv.contrib.bgsegm.BackgroundSubtractor.createCNT(15, true, 15 * 60, false);
    defer bs.deinit();

    var fgmask = try cv.Mat.init();
    defer fgmask.deinit();

    var i: usize = 0;
    while (i < 5) : (i += 1) {
        bs.apply(img, &fgmask, -1);
    }

    var bg = try cv.Mat.init();
    defer bg.deinit();
    bs.getBackgroundImage(&bg);
    try testing.expect(!bg.empty());
}

// ============================================================================
// img_hash — hash real images and compare
// ============================================================================

test "integration: img_hash on real images" {
    var img1 = try cv.imgcodecs.imread(test_image_lena, .color);
    defer img1.deinit();
    try testing.expect(!img1.empty());

    var img2 = try cv.imgcodecs.imread(test_image_fruits, .color);
    defer img2.deinit();
    try testing.expect(!img2.empty());

    var hasher = try cv.contrib.img_hash.ImgHashBase.createPHash();
    defer hasher.deinit();

    var hash1 = try cv.Mat.init();
    defer hash1.deinit();
    hasher.compute(img1, &hash1);
    try testing.expect(!hash1.empty());

    var hash2 = try cv.Mat.init();
    defer hash2.deinit();
    hasher.compute(img2, &hash2);
    try testing.expect(!hash2.empty());

    // Same image hashed twice should be distance 0
    var hash1_copy = try cv.Mat.init();
    defer hash1_copy.deinit();
    hasher.compute(img1, &hash1_copy);

    const self_distance = hasher.compare(hash1, hash1_copy);
    try testing.expectEqual(@as(f64, 0.0), self_distance);

    // Different images should have non-zero distance
    const cross_distance = hasher.compare(hash1, hash2);
    try testing.expect(cross_distance > 0.0);
}

// ============================================================================
// bioinspired — retina filter on real image
// ============================================================================

test "integration: bioinspired Retina on real image" {
    var img = try cv.imgcodecs.imread(test_image_lena, .color);
    defer img.deinit();
    try testing.expect(!img.empty());

    var retina = try cv.contrib.bioinspired.Retina.create(img.cols(), img.rows(), true);
    defer retina.deinit();

    retina.run(img);

    var parvo = try cv.Mat.init();
    defer parvo.deinit();
    retina.getParvo(&parvo);

    var magno = try cv.Mat.init();
    defer magno.deinit();
    retina.getMagno(&magno);

    try testing.expect(!parvo.empty());
    try testing.expect(!magno.empty());
    try testing.expectEqual(img.rows(), parvo.rows());
    try testing.expectEqual(img.cols(), parvo.cols());
}

// ============================================================================
// tracking — init + update tracker on real image
// ============================================================================

test "integration: tracking CSRT on real image" {
    var img = try cv.imgcodecs.imread(test_image_lena, .color);
    defer img.deinit();
    try testing.expect(!img.empty());

    var tracker = try cv.contrib.tracking.Tracker.createCSRT();
    defer tracker.deinit();

    // Define a bounding box in the image
    const bbox = cv.Rect.init(100, 100, 50, 50);
    const inited = tracker.init(img, bbox);
    try testing.expect(inited);

    // Update with same image (should track)
    var updated_bbox = cv.Rect.init(0, 0, 0, 0);
    const updated = tracker.update(img, &updated_bbox);
    try testing.expect(updated);
    try testing.expect(updated_bbox.width > 0);
    try testing.expect(updated_bbox.height > 0);
}

// ============================================================================
// xfeatures2d — detect and compute on real image
// ============================================================================

test "integration: xfeatures2d FREAK detect and compute on real image" {
    var img = try cv.imgcodecs.imread(test_image_lena, .grayscale);
    defer img.deinit();
    try testing.expect(!img.empty());

    // Create FREAK descriptor extractor via Feature2D
    var freak = try cv.contrib.xfeatures2d.FREAK.createDefault();
    defer freak.deinit();

    // First detect keypoints using ORB (FREAK is descriptor-only)
    var orb = try cv.features2d.ORB.init();
    defer orb.deinit();

    var keypoints = try cv.features2d.KeyPointVector.init();
    defer keypoints.deinit();

    orb.detect(img, &keypoints, null);
    try testing.expect(keypoints.size() > 0);

    // Now compute FREAK descriptors using Feature2D.compute
    var descriptors = try cv.Mat.init();
    defer descriptors.deinit();

    freak.compute(img, &keypoints, &descriptors);
    try testing.expect(!descriptors.empty());
}

test "integration: xfeatures2d ORB detect on real image" {
    var img = try cv.imgcodecs.imread(test_image_lena, .grayscale);
    defer img.deinit();
    try testing.expect(!img.empty());

    var orb = try cv.features2d.ORB.init();
    defer orb.deinit();

    var keypoints = try cv.features2d.KeyPointVector.init();
    defer keypoints.deinit();

    var descriptors = try cv.Mat.init();
    defer descriptors.deinit();

    orb.detectAndCompute(img, null, &keypoints, &descriptors);
    try testing.expect(keypoints.size() > 0);
    try testing.expect(!descriptors.empty());
}

// ============================================================================
// aruco — detect markers on synthetic marker image
// ============================================================================

test "integration: aruco generate and detect marker" {
    var dict = try cv.contrib.aruco.ArucoDictionary.getPredefined(.dict_6x6_250);
    defer dict.deinit();

    // Generate a marker image (marker ID 42, 200x200 pixels)
    var marker_img = try cv.Mat.init();
    defer marker_img.deinit();
    dict.generateImageMarker(42, 200, &marker_img, 1);
    try testing.expect(!marker_img.empty());
    try testing.expectEqual(@as(i32, 200), marker_img.rows());
    try testing.expectEqual(@as(i32, 200), marker_img.cols());

    // Add a white border around the marker (required for reliable detection)
    var bordered = try cv.Mat.init();
    defer bordered.deinit();
    cv.imgproc.copyMakeBorder(marker_img, &bordered, 50, 50, 50, 50, 0, cv.Scalar.init(255, 255, 255, 0));

    var detector = try cv.contrib.aruco.ArucoDetector.create(dict);
    defer detector.deinit();

    var corners = try cv.Mat.init();
    defer corners.deinit();
    var ids = try cv.Mat.init();
    defer ids.deinit();
    var rejected = try cv.Mat.init();
    defer rejected.deinit();

    // Detect the generated marker in bordered image
    detector.detectMarkers(bordered, &corners, &ids, &rejected);

    // Should find the marker
    try testing.expect(!ids.empty());
    try testing.expectEqual(@as(i32, 1), ids.rows());
}

// ============================================================================
// optflow — DualTVL1OpticalFlow on synthetic images
// ============================================================================

test "integration: optflow DualTVL1 on synthetic images" {
    // Create two 64x64 grayscale images (CV_8UC1 = 0)
    var img1 = try cv.Mat.initWithSize(64, 64, 0);
    defer img1.deinit();
    var img2 = try cv.Mat.initWithSize(64, 64, 0);
    defer img2.deinit();

    var flow = try cv.contrib.optflow.DualTVL1OpticalFlow.create();
    defer flow.deinit();

    var result = try cv.Mat.init();
    defer result.deinit();
    flow.calc(img1, img2, &result);

    // Result should be CV_32FC2 flow field, same size as input
    try testing.expect(!result.empty());
    try testing.expectEqual(@as(i32, 64), result.rows());
    try testing.expectEqual(@as(i32, 64), result.cols());
}

// ============================================================================
// saliency — SpectralResidual and FineGrained on real image
// ============================================================================

test "integration: saliency SpectralResidual on real image" {
    var img = try cv.imgcodecs.imread(test_image_lena, .color);
    defer img.deinit();
    try testing.expect(!img.empty());

    var saliency = try cv.contrib.saliency.StaticSaliency.createSpectralResidual();
    defer saliency.deinit();

    var saliencyMap = try cv.Mat.init();
    defer saliencyMap.deinit();
    const success = saliency.computeSaliency(img, &saliencyMap);
    try testing.expect(success);
    try testing.expect(!saliencyMap.empty());
    try testing.expectEqual(img.rows(), saliencyMap.rows());
    try testing.expectEqual(img.cols(), saliencyMap.cols());
}

test "integration: saliency FineGrained on real image" {
    var img = try cv.imgcodecs.imread(test_image_lena, .color);
    defer img.deinit();
    try testing.expect(!img.empty());

    var saliency = try cv.contrib.saliency.StaticSaliency.createFineGrained();
    defer saliency.deinit();

    var saliencyMap = try cv.Mat.init();
    defer saliencyMap.deinit();
    const success = saliency.computeSaliency(img, &saliencyMap);
    try testing.expect(success);
    try testing.expect(!saliencyMap.empty());
}

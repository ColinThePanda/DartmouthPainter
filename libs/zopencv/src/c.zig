// C API imports — core OpenCV modules, plus contrib if enabled via -Dcontrib=true
const config = @import("config");

pub const c = @cImport({
    @cInclude("core.h");
    @cInclude("imgcodecs.h");
    @cInclude("imgproc.h");
    @cInclude("videoio.h");
    @cInclude("highgui.h");
    @cInclude("features2d.h");
    @cInclude("objdetect.h");
    @cInclude("photo.h");
    @cInclude("calib3d.h");
    @cInclude("dnn.h");
    @cInclude("video.h");
    @cInclude("ml.h");
    @cInclude("stitching.h");
    @cInclude("flann.h");
    // Contrib headers (only when -Dcontrib=true)
    if (config.enable_contrib) {
        @cInclude("contrib/tracking.h");
        @cInclude("contrib/aruco.h");
        @cInclude("contrib/face.h");
        @cInclude("contrib/text.h");
        @cInclude("contrib/xfeatures2d.h");
        @cInclude("contrib/ximgproc.h");
        @cInclude("contrib/xphoto.h");
        @cInclude("contrib/img_hash.h");
        @cInclude("contrib/bgsegm.h");
        @cInclude("contrib/dnn_superres.h");
        @cInclude("contrib/bioinspired.h");
        @cInclude("contrib/optflow.h");
        @cInclude("contrib/saliency.h");
    }
});

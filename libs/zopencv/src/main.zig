const std = @import("std");
const config = @import("config");

// Core OpenCV modules
pub const core = @import("core.zig");
pub const imgcodecs = @import("imgcodecs.zig");
pub const imgproc = @import("imgproc.zig");
pub const videoio = @import("videoio.zig");
pub const highgui = @import("highgui.zig");
pub const features2d = @import("features2d.zig");
pub const objdetect = @import("objdetect.zig");
pub const photo = @import("photo.zig");
pub const calib3d = @import("calib3d.zig");
pub const dnn = @import("dnn.zig");
pub const video = @import("video.zig");
pub const ml = @import("ml.zig");
pub const stitching = @import("stitching.zig");
pub const flann = @import("flann.zig");

// OpenCV Contrib modules (from opencv_contrib repository, requires -Dcontrib=true)
pub const contrib = if (config.enable_contrib) @import("contrib/contrib.zig") else struct {};

// Re-export commonly used types
pub const Mat = core.Mat;
pub const Point = core.Point;
pub const Point2f = core.Point2f;
pub const Point3f = core.Point3f;
pub const Rect = core.Rect;
pub const Size = core.Size;
pub const Scalar = core.Scalar;
pub const PointVector = core.PointVector;
pub const Error = core.Error;

// Core module functions
pub const getVersion = core.getVersion;

// Matrix arithmetic operations
pub const add = core.add;
pub const subtract = core.subtract;
pub const multiply = core.multiply;
pub const divide = core.divide;
pub const bitwiseAnd = core.bitwiseAnd;
pub const bitwiseOr = core.bitwiseOr;
pub const bitwiseXor = core.bitwiseXor;
pub const bitwiseNot = core.bitwiseNot;
pub const compare = core.compare;
pub const inRange = core.inRange;
pub const addWeighted = core.addWeighted;
pub const absdiff = core.absdiff;

// Math and reduction operations (Phase 5)
pub const norm = core.norm;
pub const normalize = core.normalize;
pub const sum = core.sum;
pub const mean = core.mean;
pub const meanStdDev = core.meanStdDev;
pub const minMaxLoc = core.minMaxLoc;
pub const reduce = core.reduce;
pub const countNonZero = core.countNonZero;
pub const sqrt = core.sqrt;
pub const pow = core.pow;
pub const exp = core.exp;
pub const log = core.log;

// Array operations (Phase 6)
pub const merge = core.merge;
pub const split = core.split;
pub const flip = core.flip;
pub const rotate = core.rotate;

// Linear algebra operations (Phase 7)
pub const gemm = core.gemm;
pub const transpose = core.transpose;
pub const invert = core.invert;
pub const solve = core.solve;
pub const determinant = core.determinant;
pub const trace = core.trace;

// Math operations (Phase 8)
pub const min = core.min;
pub const max = core.max;
pub const abs = core.abs;

// Channel operations (Phase 9)
pub const extractChannel = core.extractChannel;
pub const insertChannel = core.insertChannel;
pub const mixChannels = core.mixChannels;
pub const findNonZero = core.findNonZero;

// Array concatenation operations (Phase 10)
pub const repeat = core.repeat;
pub const hconcat = core.hconcat;
pub const vconcat = core.vconcat;

// Advanced linear algebra operations (Phase 11)
pub const mulTransposed = core.mulTransposed;
pub const eigen = core.eigen;
pub const SVDecomp = core.SVDecomp;

// Final P1 utility functions (Phase 12)
pub const setIdentity = core.setIdentity;
pub const sort = core.sort;
pub const sortIdx = core.sortIdx;
pub const completeSymm = core.completeSymm;
pub const convertScaleAbs = core.convertScaleAbs;
pub const LUT = core.LUT;
pub const hasNonZero = core.hasNonZero;

// Linear algebra functions
pub const calcCovarMatrix = core.calcCovarMatrix;
pub const mahalanobis = core.mahalanobis;

// Point3fVector
pub const Point3fVector = core.Point3fVector;

// Histogram
pub const calcHist = imgproc.calcHist;

// Final P2 utility functions (Phase 13)
pub const checkRange = core.checkRange;
pub const patchNaNs = core.patchNaNs;
pub const setRNGSeed = core.setRNGSeed;

// C API access for advanced users
pub const c_api = @import("c.zig");

test {
    std.testing.refAllDecls(@This());
}

// Imgproc module functions - Image pyramids and geometric transforms
pub const pyrDown = imgproc.pyrDown;
pub const pyrUp = imgproc.pyrUp;
pub const warpAffine = imgproc.warpAffine;
pub const warpPerspective = imgproc.warpPerspective;
pub const getAffineTransform = imgproc.getAffineTransform;
pub const getPerspectiveTransform = imgproc.getPerspectiveTransform;

// Point2fVector type
pub const Point2fVector = core.Point2fVector;

// PointsVector type (contours)
pub const PointsVector = core.PointsVector;

// Contour operations
pub const findContours = imgproc.findContours;
pub const drawContours = imgproc.drawContours;
pub const contourArea = imgproc.contourArea;
pub const arcLength = imgproc.arcLength;

// Shape analysis
pub const boundingRect = imgproc.boundingRect;
pub const minAreaRect = imgproc.minAreaRect;
pub const minEnclosingCircle = imgproc.minEnclosingCircle;
pub const approxPolyDP = imgproc.approxPolyDP;
pub const convexHull = imgproc.convexHull;
pub const RotatedRect = imgproc.RotatedRect;

// Histogram
pub const equalizeHist = imgproc.equalizeHist;

// Feature detection
pub const goodFeaturesToTrack = imgproc.goodFeaturesToTrack;
pub const matchTemplate = imgproc.matchTemplate;
pub const TemplateMatchMode = imgproc.TemplateMatchMode;

// Hough transforms
pub const houghLines = imgproc.houghLines;
pub const houghCircles = imgproc.houghCircles;
pub const HoughMode = imgproc.HoughMode;

// Analysis
pub const connectedComponents = imgproc.connectedComponents;
pub const connectedComponentsWithStats = imgproc.connectedComponentsWithStats;
pub const moments = imgproc.moments;
pub const Moments = imgproc.Moments;

// Advanced filtering
pub const filter2D = imgproc.filter2D;
pub const scharr = imgproc.scharr;

// Shape matching
pub const matchShapes = imgproc.matchShapes;
pub const ShapeMatchMethod = imgproc.ShapeMatchMethod;

// Fitting
pub const fitLine = imgproc.fitLine;
pub const fitEllipse = imgproc.fitEllipse;
pub const DistType = imgproc.DistType;

// Morphology helpers
pub const getStructuringElement = imgproc.getStructuringElement;
pub const MorphShape = imgproc.MorphShape;

// Corner detection
pub const cornerHarris = imgproc.cornerHarris;

// Segmentation
pub const pyrMeanShiftFiltering = imgproc.pyrMeanShiftFiltering;
pub const watershed = imgproc.watershed;

// Transforms
pub const distanceTransform = imgproc.distanceTransform;
pub const integral = imgproc.integral;

// Border
pub const copyMakeBorder = imgproc.copyMakeBorder;

// GrabCut
pub const grabCut = imgproc.grabCut;
pub const GrabCutMode = imgproc.GrabCutMode;

// Flood Fill
pub const floodFill = imgproc.floodFill;

// CLAHE
pub const Clahe = imgproc.Clahe;

// Text measurement
pub const getTextSize = imgproc.getTextSize;

// Rotation matrix
pub const getRotationMatrix2D = imgproc.getRotationMatrix2D;

// Probabilistic Hough Lines
pub const houghLinesP = imgproc.houghLinesP;

// Contour analysis
pub const pointPolygonTest = imgproc.pointPolygonTest;
pub const isContourConvex = imgproc.isContourConvex;

// Advanced filtering
pub const boxFilter = imgproc.boxFilter;
pub const sepFilter2D = imgproc.sepFilter2D;

// Remap
pub const remap = imgproc.remap;

// Normalization
pub const normalizeImg = imgproc.normalize;
pub const NormType = imgproc.NormType;

// Histogram comparison
pub const compareHist = imgproc.compareHist;
pub const HistCompMethod = imgproc.HistCompMethod;
// Feature detection
pub const ORB = features2d.ORB;
pub const SIFT = features2d.SIFT;
pub const AKAZE = features2d.AKAZE;
pub const KeyPointVector = features2d.KeyPointVector;
pub const KeyPointData = features2d.KeyPointData;
pub const KeyPoint = features2d.KeyPoint;
pub const drawKeypoints = features2d.drawKeypoints;

// Feature matching
pub const DMatchData = features2d.DMatchData;
pub const DMatchVector = features2d.DMatchVector;
pub const BFMatcher = features2d.BFMatcher;
pub const FlannBasedMatcher = features2d.FlannBasedMatcher;
pub const NormTypes = features2d.NormTypes;
pub const drawMatches = features2d.drawMatches;

// QRCode detection
pub const QRCodeDetector = objdetect.QRCodeDetector;

// KalmanFilter
pub const KalmanFilter = video.KalmanFilter;

// Phase 1 imgproc additions
pub const accumulate = imgproc.accumulate;
pub const accumulateProduct = imgproc.accumulateProduct;
pub const accumulateSquare = imgproc.accumulateSquare;
pub const accumulateWeighted = imgproc.accumulateWeighted;
pub const applyColorMap = imgproc.applyColorMap;
pub const arrowedLine = imgproc.arrowedLine;
pub const blendLinear = imgproc.blendLinear;
pub const drawMarker = imgproc.drawMarker;
pub const MarkerTypes = imgproc.MarkerTypes;
pub const ColormapTypes = imgproc.ColormapTypes;
pub const fillConvexPoly = imgproc.fillConvexPoly;
pub const fillPoly = imgproc.fillPoly;
pub const boxPoints = imgproc.boxPoints;
pub const createHanningWindow = imgproc.createHanningWindow;
pub const getGaussianKernel = imgproc.getGaussianKernel;
pub const getRectSubPix = imgproc.getRectSubPix;
pub const invertAffineTransform = imgproc.invertAffineTransform;
pub const spatialGradient = imgproc.spatialGradient;
pub const sqrBoxFilter = imgproc.sqrBoxFilter;
pub const stackBlur = imgproc.stackBlur;
pub const warpPolar = imgproc.warpPolar;
pub const clipLine = imgproc.clipLine;
pub const ellipse2Poly = imgproc.ellipse2Poly;
pub const huMoments = imgproc.huMoments;
pub const getFontScaleFromHeight = imgproc.getFontScaleFromHeight;
pub const cornerMinEigenVal = imgproc.cornerMinEigenVal;
pub const cornerEigenValsAndVecs = imgproc.cornerEigenValsAndVecs;
pub const preCornerDetect = imgproc.preCornerDetect;
pub const cvtColorTwoPlane = imgproc.cvtColorTwoPlane;
pub const convertMaps = imgproc.convertMaps;
pub const divSpectrums = imgproc.divSpectrums;
pub const fitEllipseAMS = imgproc.fitEllipseAMS;
pub const fitEllipseDirect = imgproc.fitEllipseDirect;
pub const intersectConvexConvex = imgproc.intersectConvexConvex;
pub const minEnclosingTriangle = imgproc.minEnclosingTriangle;
pub const rotatedRectangleIntersection = imgproc.rotatedRectangleIntersection;

// Phase 2 imgproc exports
pub const getGaborKernel = imgproc.getGaborKernel;
pub const getDerivKernels = imgproc.getDerivKernels;
pub const demosaicing = imgproc.demosaicing;
pub const phaseCorrelate = imgproc.phaseCorrelate;
pub const PhaseCorrelateResult = imgproc.PhaseCorrelateResult;
pub const linearPolar = imgproc.linearPolar;
pub const logPolar = imgproc.logPolar;
pub const convexityDefects = imgproc.convexityDefects;
pub const approxPolyN = imgproc.approxPolyN;

// imgcodecs exports
pub const ImwriteFlags = imgcodecs.ImwriteFlags;
pub const imwriteWithParams = imgcodecs.imwriteWithParams;
pub const imencode = imgcodecs.imencode;
pub const imdecode = imgcodecs.imdecode;
pub const haveImageReader = imgcodecs.haveImageReader;
pub const haveImageWriter = imgcodecs.haveImageWriter;
pub const imcount = imgcodecs.imcount;
pub const imreadMulti = imgcodecs.imreadMulti;

// core DFT/math/random/clustering exports
pub const DftFlags = core.DftFlags;
pub const KMeansFlags = core.KMeansFlags;
pub const dft = core.dft;
pub const idft = core.idft;
pub const dct = core.dct;
pub const idct = core.idct;
pub const getOptimalDFTSize = core.getOptimalDFTSize;
pub const mulSpectrums = core.mulSpectrums;
pub const transform = core.transform;
pub const perspectiveTransform = core.perspectiveTransform;
pub const phase = core.phase;
pub const computeMagnitude = core.computeMagnitude;
pub const polarToCart = core.polarToCart;
pub const cartToPolar = core.cartToPolar;
pub const randu = core.randu;
pub const randn = core.randn;
pub const randShuffle = core.randShuffle;
pub const kmeans = core.kmeans;

// highgui exports
pub const WindowFlag = highgui.WindowFlag;
pub const WindowPropertyFlag = highgui.WindowPropertyFlag;
pub const MouseEventTypes = highgui.MouseEventTypes;
pub const imshow = highgui.imshow;
pub const waitKeyEx = highgui.waitKeyEx;
pub const pollKey = highgui.pollKey;
pub const destroyWindow = highgui.destroyWindow;
pub const destroyAllWindows = highgui.destroyAllWindows;
pub const namedWindow = highgui.namedWindow;
pub const resizeWindow = highgui.resizeWindow;
pub const moveWindow = highgui.moveWindow;
pub const setWindowProperty = highgui.setWindowProperty;
pub const getWindowProperty = highgui.getWindowProperty;
pub const setWindowTitle = highgui.setWindowTitle;
pub const selectROI = highgui.selectROI;
pub const createTrackbar = highgui.createTrackbar;
pub const getTrackbarPos = highgui.getTrackbarPos;
pub const setTrackbarPos = highgui.setTrackbarPos;
pub const setTrackbarMin = highgui.setTrackbarMin;
pub const setTrackbarMax = highgui.setTrackbarMax;
pub const setMouseCallback = highgui.setMouseCallback;

// photo HDR/Tonemap exports
pub const MergeMertens = photo.MergeMertens;
pub const Tonemap = photo.Tonemap;
pub const AlignMTB = photo.AlignMTB;
pub const CalibrateDebevec = photo.CalibrateDebevec;
pub const MergeDebevec = photo.MergeDebevec;

// calib3d exports
pub const findHomography = calib3d.findHomography;
pub const estimateAffinePartial2D = calib3d.estimateAffinePartial2D;
pub const estimateAffine3D = calib3d.estimateAffine3D;
pub const projectPoints = calib3d.projectPoints;
pub const reprojectImageTo3D = calib3d.reprojectImageTo3D;
pub const recoverPose = calib3d.recoverPose;
pub const composeRT = calib3d.composeRT;
pub const decomposeProjectionMatrix = calib3d.decomposeProjectionMatrix;
pub const decomposeEssentialMat = calib3d.decomposeEssentialMat;
pub const computeCorrespondEpilines = calib3d.computeCorrespondEpilines;
pub const sampsonDistance = calib3d.sampsonDistance;
pub const convertPointsFromHomogeneous = calib3d.convertPointsFromHomogeneous;
pub const convertPointsToHomogeneous = calib3d.convertPointsToHomogeneous;
pub const filterSpeckles = calib3d.filterSpeckles;
pub const validateDisparity = calib3d.validateDisparity;
pub const drawFrameAxes = calib3d.drawFrameAxes;
pub const findCirclesGrid = calib3d.findCirclesGrid;
pub const stereoRectifyUncalibrated = calib3d.stereoRectifyUncalibrated;
pub const correctMatches = calib3d.correctMatches;
pub const undistortPoints = calib3d.undistortPoints;

// core batch 3 exports
pub const PCA = core.PCA;
pub const borderInterpolate = core.borderInterpolate;

// photo Tonemap variants
pub const TonemapDrago = photo.TonemapDrago;
pub const TonemapReinhard = photo.TonemapReinhard;
pub const TonemapMantiuk = photo.TonemapMantiuk;
pub const fastNlMeansDenoisingMulti = photo.fastNlMeansDenoisingMulti;
pub const fastNlMeansDenoisingColoredMulti = photo.fastNlMeansDenoisingColoredMulti;

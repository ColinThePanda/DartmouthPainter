# Machine Learning Module

SVM and KNN classifiers.

## SVM

```zig
const SVM = struct {
    fn init() !SVM;
    fn deinit(self: *SVM) void;
    fn train(self: SVM, samples: Mat, layout: i32, responses: Mat) void;
    fn predict(self: SVM, samples: Mat, results: ?*Mat, flags: i32) f32;
    fn setType(self: SVM, svm_type: SVMType) void;
    fn setKernel(self: SVM, kernel: SVMKernel) void;
    fn setC(self: SVM, value: f64) void;
    fn setGamma(self: SVM, value: f64) void;
    fn getType(self: SVM) SVMType;
    fn getKernel(self: SVM) SVMKernel;
};

const SVMType = enum(i32) { c_svc, nu_svc, one_class, eps_svr, nu_svr };
const SVMKernel = enum(i32) { custom, linear, poly, rbf, sigmoid, chi2, inter };
```

## KNearest

```zig
const KNearest = struct {
    fn init() !KNearest;
    fn deinit(self: *KNearest) void;
    fn train(self: KNearest, samples: Mat, layout: i32, responses: Mat) void;
    fn predict(self: KNearest, samples: Mat, results: ?*Mat,
              neighborResponses: ?*Mat, dist: ?*Mat) f32;
    fn setDefaultK(self: KNearest, k: i32) void;
    fn getDefaultK(self: KNearest) i32;
    fn setAlgorithmType(self: KNearest, alg: KNearestAlgorithm) void;
};

const KNearestAlgorithm = enum(i32) { brute_force, kd_tree };
const SampleLayout = enum(i32) { row, col };
```

## Example

```zig
const cv = @import("zopencv");

var svm = try cv.ml.SVM.init();
defer svm.deinit();
svm.setType(.c_svc);
svm.setKernel(.rbf);
svm.setC(1.0);
svm.setGamma(0.5);
svm.train(trainData, @intFromEnum(cv.ml.SampleLayout.row), labels);
const result = svm.predict(testSample, null, 0);
```

module MLJMultivariateStatsInterface

# ===================================================================
# IMPORTS
import MLJModelInterface
import MLJModelInterface: Table, Continuous, Finite, @mlj_model, metadata_pkg,
    metadata_model
import MultivariateStats
import MultivariateStats: SimpleCovariance
import StatsBase: CovarianceEstimator

using Distances
using LinearAlgebra

# ===================================================================
## EXPORTS
export LinearRegressor, RidgeRegressor, PCA, KernelPCA, ICA, PPCA, FactorAnalysis, LDA,
    BayesianLDA, SubspaceLDA, BayesianSubspaceLDA

# ===================================================================
## Re-EXPORTS
export SimpleCovariance, CovarianceEstimator, SqEuclidean, CosineDist

# ===================================================================
## CONSTANTS
# Define constants for easy referencing of packages
const MMI = MLJModelInterface
const MS = MultivariateStats
const PCAFitResultType = MS.PCA
const KernelPCAFitResultType = MS.KernelPCA
const ICAFitResultType = MS.ICA
const PPCAFitResultType = MS.PPCA
const FactorAnalysisResultType = MS.FactorAnalysis
const default_kernel = (x, y) -> x'y #default kernel used in KernelPCA

# Definitions of model descriptions for use in model doc-strings.
const PCA_DESCR = """Principal component analysis. Learns a linear transformation to
project the data  on a lower dimensional space while preserving most of the initial
variance.
"""
const KPCA_DESCR = "Kernel principal component analysis."
const ICA_DESCR = "Independent component analysis."
const PPCA_DESCR = "Probabilistic principal component analysis"
const FactorAnalysis_DESCR = "Factor Analysis"
const LDA_DESCR = """Multiclass linear discriminant analysis. The algorithm learns a
projection matrix `P` that projects a feature matrix `Xtrain` onto a lower dimensional
space of dimension `out_dim` such that the trace of the transformed between-class scatter
matrix(`Pᵀ*Sb*P`) is maximized relative to the trace of the transformed within-class
scatter matrix (`Pᵀ*Sw*P`).The projection matrix is scaled such that `Pᵀ*Sw*P=I` or
`Pᵀ*Σw*P=I`(where `Σw` is the within-class covariance matrix) .
Predicted class posterior probability for feature matrix `Xtest` are derived by applying
a softmax transformationto a matrix `Pr`, such that  rowᵢ of `Pr` contains computed
distances(based on a distance metric) in the transformed space of rowᵢ in `Xtest` to the
centroid of each class.
"""
const BayesianLDA_DESCR = """Bayesian Multiclass linear discriminant analysis. The algorithm
learns a projection matrix `P` that projects a feature matrix `Xtrain` onto a lower
dimensional space of dimension `out_dim` such that the trace of the transformed
between-class scatter matrix(`Pᵀ*Sb*P`) is maximized relative to the trace of the
transformed within-class scatter matrix (`Pᵀ*Sw*P`). The projection matrix is scaled such
that `Pᵀ*Sw*P = n` or `Pᵀ*Σw*P=I` (Where `n` is the number of training samples and `Σw`
is the within-class covariance matrix).
Predicted class posterior probability distibution are derived by applying Bayes rule with
a multivariate Gaussian class-conditional distribution.
"""
const SubspaceLDA_DESCR = """Multiclass linear discriminant analysis. Suitable for high
dimensional data (Avoids computing scatter matrices `Sw` ,`Sb`). The algorithm learns a
projection matrix `P = W*L` that projects a feature matrix `Xtrain` onto a lower
dimensional space of dimension `nc - 1` such that the trace of the transformed
between-class scatter matrix(`Pᵀ*Sb*P`) is maximized relative to the trace of the
transformed within-class scatter matrix (`Pᵀ*Sw*P`). The projection matrix is scaled such
that `Pᵀ*Sw*P = mult*I` or `Pᵀ*Σw*P=mult/(n-nc)*I` (where `n` is the number of training
samples, mult` is  one of `n` or `1` depending on whether `Sb` is normalized, `Σw` is the
within-class covariance matrix, and `nc` is the number of unique classes in `y`) and also
obeys `Wᵀ*Sb*p = λ*Wᵀ*Sw*p`, for every column `p` in `P`.
Predicted class posterior probability for feature matrix `Xtest` are derived by applying a
softmax transformation to a matrix `Pr`, such that  rowᵢ of `Pr` contains computed
distances(based on a distance metric) in the transformed space of rowᵢ in `Xtest` to the
centroid of each class.
"""
const BayesianSubspaceLDA_DESCR = """Bayesian Multiclass linear discriminant analysis.
Suitable for high dimensional data (Avoids computing scatter matrices `Sw` ,`Sb`). The
algorithm learns a projection matrix `P = W*L` (`Sw`), that projects a feature matrix
`Xtrain` onto a lower dimensional space of dimension `nc-1` such that the trace of the
transformed between-class scatter matrix(`Pᵀ*Sb*P`) is maximized relative to the trace
of the transformed within-class scatter matrix (`Pᵀ*Sw*P`). The projection matrix is
scaled such that `Pᵀ*Sw*P = mult*I` or `Pᵀ*Σw*P=mult/(n-nc)*I` (where `n` is the number of
training samples, `mult` is  one of `n` or `1` depending on whether `Sb` is normalized,
`Σw` is the within-class covariance matrix, and `nc` is the number of unique classes in
`y`) and also obeys `Wᵀ*Sb*p = λ*Wᵀ*Sw*p`, for every column `p` in `P`.
Posterior class probability distibution are derived by applying Bayes rule with a
multivariate Gaussian class-conditional distribution
"""
const LINEAR_DESCR = """Linear regression. Learns a linear combination(s) of given
variables to fit the responses by minimizing the squared error between.
"""
const RIDGE_DESCR = """Ridge regressor with regularization parameter lambda. Learns a
linear regression with a penalty on the l2 norm of the coefficients.
"""

const PKG = "MLJMultivariateStatsInterface"

# ===================================================================
# Includes
include("models/decomposition_models.jl")
include("models/discriminant_analysis.jl")
include("models/linear_models.jl")
include("utils.jl")

# ===================================================================
# List of all models interfaced
const MODELS = (
    LinearRegressor, RidgeRegressor, PCA, KernelPCA, ICA, LDA,
    BayesianLDA, SubspaceLDA,
    BayesianSubspaceLDA, FactorAnalysis, PPCA
)

# ====================================================================
# PKG_METADATA
metadata_pkg.(
    MODELS,
    name = "MultivariateStats",
    uuid = "6f286f6a-111f-5878-ab1e-185364afe411",
    url = "https://github.com/JuliaStats/MultivariateStats.jl",
    license = "MIT",
    julia = true,
    is_wrapper = false
)

end

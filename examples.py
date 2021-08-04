####
#### Install and load DECAES
####
####    NOTE:   This script requires the julia package to be installed.
####            See the following documentation for instructions:
####
####                https://github.com/JuliaPy/pyjulia#quick-usage
####

# (Optionally) configure Julia environment variables; must be done before PyJulia initialization
import os
# os.environ["JULIA_PROJECT"] = "/path/to/julia/project" # custom path to julia project environment
os.environ["JULIA_NUM_THREADS"] = "32" # highly recommended for speed; set this equal to the number of threads available on your machine

# Initialize Julia runtime
from julia.api import Julia
jl = Julia(
    runtime = "/usr/local/julia-1.6.1/bin/julia", # optional; defaults to "julia"
    compiled_modules = False, # required on Debian-based Linux distributions such as Ubuntu; see https://pyjulia.readthedocs.io/en/stable/troubleshooting.html#your-python-interpreter-is-statically-linked-to-libpython
)

# Install DECAES, if necessary
from julia import Pkg
Pkg.add("DECAES")

# Load DECAES
from julia import DECAES

####
#### Example using mock image for proof-of-concept demonstration
####

# Create mock image
import numpy as np
TE  = 10e-3 # arbitrary mock echo time
nTE = 32 # arbitrary mock number of echoes
T2  = 80e-3 # true T2 value
image = np.exp(-np.linspace(TE, nTE*TE, nTE) / T2) # exponentially decaying signal
image = np.tile(image.reshape((1,1,1,nTE)), (3,3,3,1)) # reshape and repeat into shape (3, 3, 3, nTE) image
real_noise = 1e-3 * np.random.randn(*image.shape) # small amount of random noise (real channel)
imag_noise = 1e-3 * np.random.randn(*image.shape) # small amount of random noise (imaginary channel)
image = np.sqrt((image + real_noise)**2 + imag_noise**2) # add Rician noise

# Call T2mapSEcorr to compute T2 distribution
out = DECAES.T2mapSEcorr(image, TE = TE, nT2 = 40, T2Range = (TE,1.0), Reg = "lcurve")
t2maps, t2dist = out.maps, out.distributions

# Call T2partSEcorr to compute T2 parts such as MWF (aka short fraction "sfr"), LWF (aka long fraction "mfr")
t2parts = DECAES.T2partSEcorr(t2dist, T2Range = (TE,1.0), SPWin = (TE, 25e-3), MPWin = (25e-3, 200e-3))

print(
    """
    GGM T2        = {ggm} (true = {T2})
    Flip Angle    = {alpha} (true = 180.0)
    SFR (aka MWF) = {sfr} (true = 0.0)
    MFR (aka LWF) = {mfr} (true = 1.0)
    """
    .format(
        T2 = T2,
        ggm = t2maps["ggm"][0,0,0],
        alpha = t2maps["alpha"][0,0,0],
        sfr = t2parts["sfr"][0,0,0],
        mfr = t2parts["mfr"][0,0,0],
    )
)

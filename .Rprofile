# If running in a conda env, set PKG_CONFIG_PATH so that conda-installed libs
# will be detected when installing R packages
conda_prefix <- Sys.getenv("CONDA_PREFIX")
if (base::dir.exists(conda_prefix)) {
  Sys.setenv(
    PKG_CONFIG_PATH = base::file.path(conda_prefix, "lib", "pkgconfig")
  )
}
rm(conda_prefix)

# Set max print
options(max.print = 400)

# Set line width
cols <- system2("stty", "-a | head -n 1 | awk '{print $7}' | sed 's/;//'", stdout = TRUE)
options(width = min(150, -5 + as.integer(cols)))
rm(cols)

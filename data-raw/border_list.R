library(R.matlab)
## see get_list_dlabels line 350
## 	BORDER_XYZ(1,:)=MNID.mat(1,4)-BORDER_XYZ(1,:);
# MNID.mat is 92
ver = "5"
versions = c("4", "5")

# fslhd(aal_fname(version = 4))
# fslhd(aal_fname(version = 5))
ver = versions[1]
aal_border = vector(mode = "list", length = length(versions))
names(aal_border) = paste0("v", versions)
for (ver in versions) {
  border = R.matlab::readMat(paste0("data-raw/ROI_MNI_V", ver, "_Border.mat"))
  stopifnot(all(names(border) %in% c("BORDER.XYZ", "BORDER.V")))
  dxyz = dim(border$BORDER.XYZ)
  if (dxyz[1] < dxyz[2]) {
    border$BORDER.XYZ = t(border$BORDER.XYZ)
  }
  MNID.mat = 92
  border$BORDER.XYZ[,1] = MNID.mat - border$BORDER.XYZ[,1]

  border$BORDER.V = drop(border$BORDER.V)


  vlist = R.matlab::readMat(paste0("data-raw/ROI_MNI_V", ver, "_List.mat"))
  vlist = vlist$ROI
  vlist = t(drop(vlist))
  vlist = as.data.frame(vlist, stringsAsFactors = FALSE)
  for (i in seq(ncol(vlist))) {
    vlist[, i] = unlist(vlist[,i])
  }
  aal_border[[paste0("v", ver)]] = border
}

usethis::use_data(aal_border, compress = "xz",
                  overwrite = TRUE)

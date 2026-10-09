# SplitLab 1.9.0 — Oluwatofunmi's Modifications

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.23271001.svg)](https://doi.org/10.5281/zenodo.23271001)

This is a modified copy of SplitLab, a shear-wave splitting analysis environment for MATLAB. If you use this software, please cite the original:

> Wüstefeld, A., Bokelmann, G., Zaroli, C., & Barruol, G. (2008). SplitLab: A shear-wave splitting environment in Matlab. *Computers & Geosciences*, 34(5), 515–528. https://doi.org/10.1016/j.cageo.2007.08.002

## Source

This fork is based on SplitLab 1.9.0 from https://github.com/IPGP/splitlab, maintained by IPGP (Institut de Physique du Globe de Paris).

## Data

`harvardCMT.mat` and its date-range-specific variants (`harvardCMT_3_23_to_7_24.mat`, etc.) are **not independently compiled data** — they are local caches of the **Global CMT (GCMT) catalog**, fetched via SplitLab's own built-in tool, `Tools/SL_cmtread.m`, which queries `https://www.ldeo.columbia.edu/~gcmt/projects/CMT/catalog/NEW_QUICK/qcmt.ndk`. The date-range-specific files are simply subsets covering this study's event-search window.

If you use the GCMT catalog, cite:

> Dziewonski, A. M., Chou, T.-A., & Woodhouse, J. H. (1981). Determination of earthquake source parameters from waveform data for studies of global and regional seismicity. *Journal of Geophysical Research*, 86(B4), 2825–2852.
>
> Ekström, G., Nettles, M., & Dziewoński, A. M. (2012). The global CMT project 2004–2010: Centroid-moment tensors for 13,017 earthquakes. *Physics of the Earth and Planetary Interiors*, 200–201, 1–9.

These files are included as cached copies for convenience; please cite GCMT (references above) if you use them.

## License

SplitLab is distributed under the GNU General Public License v2 (or, at the user's option, any later version), per the header in `SL_defaultconfig.m`:

> SplitLab is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version. This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

This modified copy is distributed under the same terms.

## How to run

1. Add this folder and its subfolders (`ShearWaveSplitting/`, `Tools/`, `config_GUI/`, `Saclab/`) to the MATLAB path.
2. Run:
   ```matlab
   splitlab
   ```
   This launches the main GUI — project/database setup, event selection, waveform viewing, and the splitting-measurement interface.

## Modifications

The changes below were made by O. Adeboye (2025–2026). They build on an earlier station-reading extension by O. Adeboye and G. Ito (`config_GUI/configpanelFINDFILE.m`), which added support for HH1/HH2/HHZ and LH1/LH2/LHZ file naming. Each entry lists the file changed and why.

### Splitting intensity (SI)

- **`ShearWaveSplitting/preSplit.m`** — Splitting intensity was computed but not stored correctly across batch iterations; fixed to store `[SI, errSI]` for every trial in the batch loop (`[splitIntens(n,1), splitIntens(n,2)] = splitting_intensity(...)`), rather than only the final iteration.
- **`ShearWaveSplitting/splitdiagnosticSetHeader.m`** — Added SI (value ± uncertainty) to the diagnostic-plot header text, shown whenever a valid (non-NaN) SI is available for that measurement.
- **`Tools/pjt2xls.m`** — Added `SI` and `errSI` columns to the project-to-spreadsheet export, so splitting intensity is available in the exported results table alongside φ/δt and their uncertainties.

### Stacked (Wolfe & Silver, 1998) measurements

- **`ShearWaveSplitting/splitWolfeSilver.m`** — Rewritten from a hardcoded routine (Good+Fair splits only, energy method only, no explicit event-to-event rotation) into a parameterized function `splitWolfeSilver(Quality, Nulls, phases, useEV)`:
  - `Quality`/`Nulls` let the caller choose which combination of Good/Fair splits and Good/Fair nulls to include in the stack.
  - `phases` allows filtering to specific phases (e.g. SKS only) rather than stacking across all phases indiscriminately.
  - `useEV` toggles between stacking the energy-minimization surface (original behavior) and the eigenvalue surface.
  - Each event's error surface is now explicitly rotated to a common geographic reference (via back-azimuth) **before** stacking, so surfaces from events with different back-azimuths combine correctly rather than being summed in each event's own local frame.
  - Only eigenvalue surfaces computed with the *same* eigenvalue criterion (e.g. min λ2 vs. max λ1/λ2) are combined, since these use different formulas and aren't numerically comparable.
- **`ShearWaveSplitting/SL_Results.m`** — The "Stack W&S" button now passes the GUI's Quality/Nulls filter selections through to the new parameterized `splitWolfeSilver`. The "Stack S&C" button was fixed to pass the required arguments to `splitSilverChan`; previously it called that function with no arguments at all, which would error against its 9-argument signature.

### Batch-mode diagnostics

- **`ShearWaveSplitting/preSplit.m`** — Added per-iteration logging in the batch loop: records the filter band and time window tested at each trial, and prints a one-line summary per trial (filter, window, Q, and φ/δt for the RC, SC, and EV methods) for auditing batch runs.
- **`ShearWaveSplitting/splitdiagnosticplot.m`** — The batch-mode Quality (Q) histogram now also prints a full text summary to the console: count and fraction of trials per Q bin, plus mean/std/max/min Q and the best-fit filter band.

### Cross-platform export

- **`Tools/pjt2xls.m`** — Reworked the project-to-Excel export path, which previously relied on `xlswrite` and required Microsoft Excel to be installed (failing on Mac without it).

### Files renamed only, no functional change

`ShearWaveSplitting/saveresult.m`, `geterrorbars.m`, `geterrorbarsRC.m`, `Tools/database_editResults.m`, `Tools/getFileAndEQseconds.m` were reorganized/renamed from their original filenames but are byte-identical in content.

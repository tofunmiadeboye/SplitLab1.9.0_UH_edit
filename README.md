# SplitLab 1.9.0 — Oluwatofunmi's Modifications

This is a modified copy of SplitLab, a shear-wave splitting analysis environment for MATLAB. If you use this software, please cite the original:

> Wüstefeld, A., Bokelmann, G., Zaroli, C., & Barruol, G. (2008). SplitLab: A shear-wave splitting environment in Matlab. *Computers & Geosciences*, 34(5), 515–528. https://doi.org/10.1016/j.cageo.2007.08.002

The changes below were made by O. Adeboye (2026) unless otherwise noted, building on a station-reading extension (HH1/HH2/HHZ, BHE/BHN/BHZ, LH1/LH2/LHZ file-naming support, `config_GUI/configpanelFINDFILE.m`) previously added by G. Ito. Each entry lists the file changed and why.

## Splitting intensity (SI)

- **`ShearWaveSplitting/preSplit.m`** — Splitting intensity was computed but not stored correctly across batch iterations; fixed to store `[SI, errSI]` for every trial in the batch loop (`[splitIntens(n,1), splitIntens(n,2)] = splitting_intensity(...)`), rather than only the final iteration.
- **`ShearWaveSplitting/splitdiagnosticSetHeader.m`** — Added SI (value ± uncertainty) to the diagnostic-plot header text, shown whenever a valid (non-NaN) SI is available for that measurement.
- **`Tools/pjt2xls.m`** — Added `SI` and `errSI` columns to the project-to-spreadsheet export, so splitting intensity is available in the exported results table alongside φ/δt and their uncertainties.

## Stacked (Wolfe & Silver, 1998) measurements

- **`ShearWaveSplitting/splitWolfeSilver.m`** — Rewritten from a hardcoded routine (Good+Fair splits only, energy method only, no explicit event-to-event rotation) into a parameterized function `splitWolfeSilver(Quality, Nulls, phases, useEV)`:
  - `Quality`/`Nulls` let the caller choose which combination of Good/Fair splits and Good/Fair nulls to include in the stack.
  - `phases` allows filtering to specific phases (e.g. SKS only) rather than stacking across all phases indiscriminately.
  - `useEV` toggles between stacking the energy-minimization surface (original behavior) and the eigenvalue surface.
  - Each event's error surface is now explicitly rotated to a common geographic reference (via back-azimuth) **before** stacking, so surfaces from events with different back-azimuths combine correctly rather than being summed in each event's own local frame.
  - Only eigenvalue surfaces computed with the *same* eigenvalue criterion (e.g. min λ2 vs. max λ1/λ2) are combined, since these use different formulas and aren't numerically comparable.
- **`ShearWaveSplitting/SL_Results.m`** — The "Stack W&S" button now passes the GUI's Quality/Nulls filter selections through to the new parameterized `splitWolfeSilver`. The "Stack S&C" button was fixed to pass the required arguments to `splitSilverChan`; previously it called that function with no arguments at all, which would error against its 9-argument signature.

## Batch-mode diagnostics

- **`ShearWaveSplitting/preSplit.m`** — Added per-iteration logging in the batch loop: records the filter band and time window tested at each trial, and prints a one-line summary per trial (filter, window, Q, and φ/δt for the RC, SC, and EV methods) for auditing batch runs.
- **`ShearWaveSplitting/splitdiagnosticplot.m`** — The batch-mode Quality (Q) histogram now also prints a full text summary to the console: count and fraction of trials per Q bin, plus mean/std/max/min Q and the best-fit filter band.

## Cross-platform export

- **`Tools/pjt2xls.m`** — Reworked the project-to-Excel export path, which previously relied on `xlswrite` and required Microsoft Excel to be installed (failing on Mac without it).

## Not a new addition (correcting an earlier assumption)

- **HH1/HH2/HHZ (and BHE/BHN/BHZ, LH1/LH2/LHZ) SAC file-naming support** (`config_GUI/configpanelFINDFILE.m`) predates this edit set — the code attributes it to G. Ito, and it is present unchanged in the baseline this was diffed against. Do not attribute it to the author of the changes above.

## Files renamed only, no functional change

`ShearWaveSplitting/saveresult.m`, `geterrorbars.m`, `geterrorbarsRC.m`, `Tools/database_editResults.m`, `Tools/getFileAndEQseconds.m` were reorganized/renamed from their original filenames but are byte-identical in content.

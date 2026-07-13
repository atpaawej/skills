## Seam

A place where you can change behaviour without modifying the module itself. The term comes from tailoring — you alter a garment at the seam, not by reweaving the fabric. A good seam in code means a requirement changes, and the change stays local.

## Depth

A module's interface-to-implementation ratio. A deep module does significant work behind a simple API. A shallow module makes callers understand complexity without delivering proportional value. The goal is depth.

## Change boundary

The set of decisions sealed inside one module such that any single requirement change touches exactly that module. If a change ripples across boundaries, the boundary is in the wrong place.

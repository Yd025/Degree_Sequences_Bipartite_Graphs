#!/usr/bin/env sage
from sage.all import *

T = tetrahedron(color='red', opacity=0.8, mesh=True)

T.show(title="3D", frame=True, aspect_ratio=1)
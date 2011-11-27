(*
Modeling Kernel Language (MKL) toolchain
Copyright (C) 2010-2011 David Broman
MKL toolchain is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

MKL toolchain is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with MKL toolchain.  If not, see <http://www.gnu.org/licenses/>.
*)


val generate : int -> Evalast.tm -> Evalast.tm

val run : Evalast.bcode -> Evalast.tm list -> Evalast.tm

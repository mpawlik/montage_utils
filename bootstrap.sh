#!/bin/bash

if [ $# -ne 1 ]; then
	echo "Usage: $0 DEGREE" 
	exit 1
fi

SURVEY=2mass
OBJ=M42
BAND=j
DEGREE=$1
WORK_DIR=$2
TABLE=${DEGREE}_degree_images.tbl

echo "Creating work directory..."
if [ -e $DEGREE ]; then
	echo "Work dir already exists! ($DEGREE)"
	exit 1
fi
mkdir -p $1
cd $DEGREE
mkdir input workdir

echo "Generating metadata..."
echo "SURVEY=$SURVEY" >> metadata
echo "OBJ=$OBJ" >> metadata
echo "BAND=$BAND" >> metadata
echo "DEGREE=$DEGREE" >> metadata

echo "Generating DAX..."
mDAG $SURVEY $BAND $OBJ $DEGREE $DEGREE 0.000278 workdir @@WORK_URL@@ @@DATA_URL@@
#mDAG survey band objstr width height cdelt workdir workurlbase urlbase
RC=$?
if [ $RC -ne 0 ]; then
	echo "mDAG failed"
	exit $RC
fi

cat workdir/dag.xml | sed 's/.fit.fits/.fits/' | sed 's/.fi.fits/.fits/' | sed 's/.fi_area.fits/_area.fits/' | sed 's/.fit_area.fits/_area.fits/' > workdir/dag.xml.new

mv workdir/dag.xml workdir/dag.xml.old
mv workdir/dag.xml.new workdir/dag.xml


cp workdir/images.tbl input
cd input
sed -i s/https/http/ images.tbl
#sed -i s/:443// images.tbl
sed -i s/irsa.ipac.caltech.edu/rrrrrrrrrrrrrrrrrrrrr/ images.tbl

echo Calling mArchiveExec images.tbl
mArchiveExec images.tbl
RC=$?
if [ $RC -ne 0 ]; then
	echo "mArchiveExec failed"
	exit $RC
fi
cd ..
S=`grep big_region workdir/dag.xml | head -1 | sed 's/.*big_region_\(.*\)\.hdr.*/\1/'`
cp workdir/big_region.hdr input/big_region_$S.hdr
cp workdir/region.hdr input/region_$S.hdr
cp workdir/cimages.tbl input/cimages_$S.tbl
cp workdir/pimages.tbl input/pimages_$S.tbl
cp workdir/images.tbl input/images_$S.tbl
cp workdir/statfile.tbl input/statfile_$S.tbl
cp workdir/dag.xml input/

cd input
echo Ungzipping
for file in *gz; do gunzip $file; done

echo Calling sed
sed -i 's/fits.g.fits/fits/' *tbl

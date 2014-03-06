#!/bin/bash

############################################
#  fcsExporter.sh
#  fcsExporter
#
# This script will select all assets in Final Cut Server and export to XML
#  Created by Paul McGlaughlin on 9/8/11.
#  Copyright 2011 318, Inc. All rights reserved.
#
###########################################

###########################################
##  Changelog -
##  1. created fcsExporter project and fcsExporter.sh file
##  2. declared executable variables
##  3. built command to get all assetNumbers from fcsvr_client
##  4. Setup pseudocode for reference and guidance.
##  5. Productions will need to be a separate set of queries - perhaps then matched to the appropriate Asset MD.  
##
##  Question - will we need to export user info?  Is it possible to include passwords?
###########################################

build=20111102

##Setup Variables

##Operating Variables
declare -x outputAssetFile="fcsAssetOutputs.xml"
declare -x AssetMDoutputFile="fcsAssetMDOutputs.xml"
decalre -x outputProductionFile="fcsProductionOutputs.xml"
declare -x assetGetMDcommand="/Library/Application\ Support/Final\ Cut\ Server/Final\ Cut\ Server.bundle/Contents/MacOS/fcsvr_client getmd --xml > fcsExport.xml"
declare -x TotalAssetsInServer="0"
declare -x TotalProductionsInServer="0"
declare -x currentAssetNumber="0"
declare -x currentProductionNumber="0"


##Declare our executables
declare -x awk="/usr/bin/awk"
declare -x grep="/usr/bin/grep"
declare -x transmogrifier="/usr/local/bin/transmogrifier.py"
declare -x ln="/bin/ln"
declare -x mkdir='/bin/mkdir'
declare -x rm='/bin/rm'
declare -x fcsvr_client="/Library/Application Support/Final Cut Server/Final Cut Server.bundle/Contents/MacOS/fcsvr_client"


##Get all assetNumbers from fcsvr_client > outputassetfile.
/Library/Application\ Support/Final\ Cut\ Server/Final\ Cut\ Server.bundle/Contents/MacOS/fcsvr_client search /asset > outputAssetFile

##count the number of lines in the outputassetfile
TotalAssetsInServer=awk 'wc -l' outputAssetFile

##setup assetparseloop to parse through assetNumbers. Using awk

## for (( c=1; c<=TotalAssetsInServer; c++))
## do

##inside assetparseloop call fcsvr_client getMD for each asset
awk 'fcsvr_client getmd --xml "[$1]"' outputAssetFile     ##This command is not correct


##inside assetparseloop call fcsvr_client -getparent links for each asset

##inside assetparseloop call fcsvr_client -getchild links for each asset 

##inside assetparseloop get the Annotations (if present). 

/Library/Application\ Support/Final\ Cut\ Server/Final\ Cut\ Server.bundle/Contents/Resources/sbin/fcsvr_run psql px pxdb -c "SELECT pxmdvalue.entityid, pxmdvalue.value AS asset_name FROM pxmdvalue INNER JOIN pxentity ON pxentity.entityid = pxmdvalue.entityid WHERE pxmdvalue.fieldid='1543' AND pxmdvalue.value='ASSETNAME' AND pxentity.address LIKE '/asset/%';" > 

##write (or append file) the asset info to the AssetMDoutputfile



##end assetparseloop

##done




## get a list of all productions

/Library/Application\ Support/Final\ Cut\ Server/Final\ Cut\ Server.bundle/Contents/Resources/sbin/fcsvr_run psql px pxdb -c "SELECT pxmdvalue.value FROM pxentity inner join pxmdvalue on pxmdvalue.entityid = pxentity.entityid WHERE pxentity .parententityid = (SELECT entityid from pxentity where address = '/project') and (pxmdvalue.fieldid=(select fieldid from pxmdfield where name='Title' and mdgroupcategoryid='100'));" > outputProductionFile

##count the number of lines in the outputProductionFile
TotalProductionsInServer=awk 'wc -l' outputProductionFile

## setup Productionparseloop

##for
##do

## get the members of a particular production (fcsvr_client list_parent_links /project/#

## add the production to the appropriate place in the AssetMDoutputfile.

##end Productionparseloop.

##done


#!/bin/bash



# Erstellt beim Aufrufen eines Patienten einen Link zu dessen Dokumentenablage
# in trpword und stellt diesen Pfad per Samba zur Verfuegung.
#
# DisplayAusgabe.sh wird am Linux Server vorausgesetzt,
# am Windows PC wird Rexserver benoetigt.
#
# Dieses Script z.B. in DV Optionen bei "Patient aufgerufen" eintragen oder 
# über Formular 400 als xscan.sh starten.
#
# SPnG (FW), Stand: 11.11.2013



# Bitte anpassen: ##############################################################
#
smbpfad=/home/david/trpword/.stationen    # Diesen Pfad + Login Name des Linux 
#                                         # Users mit der smb.conf abgleichen!
#
# Bitte anpassen, falls Batch Aufruf gewuenscht: ###############################
#
ip="192.168.0.10"                         # IP des WinPC (Rexserver!)
port="6666"                               # Port fuer Rexserver
batch="c:\\david\startwas.bat"            # Batchdatei am WinPC, "c:\\" beachten!!
#
################################################################################




# Ab hier bitte Finger weg!



# Leeren Ordner in trpword anlegen:
ichbins=`whoami`
apuser="$smbpfad/$ichbins"
mkdir -p -m 0775 $apuser 2>/dev/null
if [ -L "$apuser/Patient" ]; then
   rm -f $apuser/Patient
fi

# Welcher Patient ist gerade augerufen?
serverpfad=$DAV_HOME/trpword/pat_nr
pfad=`echo $1 | awk '{printf("%08.f\n",$1)}' \
              | awk -F '' '{printf("%d/%d/%d/%d/%d/%d/%d/%d",$1,$2,$3,$4,$5,$6,$7,$8)}'`
fullpfad=$serverpfad/$2/$pfad
mkdir -p -m 0777 "$fullpfad" > "/dev/null" 2>&1 
 
# Link im Stationsordner zum Patienten anlegen:
ln -s $fullpfad $apuser/Patient

# Ggf. Batchdatei am Windowsrechner starten:
#echo "DAVCMD start /min $batch" | netcat $ip $port >/dev/null

exit 0

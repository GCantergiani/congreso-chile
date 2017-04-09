 #!/bin/bash

# To download all detaill voting from deputies
if [ "$1" == "dip" ]; then
	
	# A file to save the retrieve deputies
	# A simple form to resume download if something crash
	touch retrieve_deputies.csv

	# Folder to save all the votation details
	mkdir -p diputies

	# We hope that there are no voting-documents greater than 200k
	for i in $(seq 0 200000); 
		do
			echo "[DIP] file $i"
			if grep -qFx $i "retrieve_deputies.csv"; then
				echo "[DIP] The file $i exists."
			else
				curl -s http://opendata.congreso.cl/wscamaradiputados.asmx/getVotacion_Detalle?prmVotacionID=$i > D-$i.xml; 
				sizeFile=$(ls -l D-$i.xml | awk '{print $5}')

				# If the size of the file is less than 200, is a blank file (without votation details)
				if [ $sizeFile -lt 200 ]; then
					rm D-$i.xml
					echo -e $i >> retrieve_deputies.csv
				else
					echo "[DIP] votation $i downloaded.."

					# Move file to diputies folder
					mv D-$i.xml ./diputies
					echo -e $i >> retrieve_deputies.csv
				fi
			fi
	done    

fi

# To download all detaill voting from senators
if [ "$1" == "sen" ]; then

		# A file to save the retrieve deputies
		# A simple form to resume download if something crash
        touch retrieve_senators.csv

    	# Folder to save all the votation details
		mkdir -p senators

	# We hope that there are no voting-documents greater than 200k
	for i in $(seq 0 200000); 
		do
			echo "[SEN] file $i"
			if grep -qFx $i "retrieve_senators.csv"; then
				echo "[SEN] The file $i exists."
			else
				curl -s http://www.senado.cl/wspublico/votaciones.php?boletin=$i > S-$i.xml;
				sizeFile=$(ls -l S-$i.xml | awk '{print $5}')

				# If the size of the file is less than 200, is a blank file (without votation details)
				if [ $sizeFile -lt 26 ]; then
					rm S-$i.xml
					echo -e $i >> retrieve_senators.csv
				else
					echo "[DIP] votation $i downloaded.."

					# Move file to senators folder
					mv S-$i.xml ./senators
					echo -e $i >> retrieve_senators.csv
				fi
			fi
	done

fi

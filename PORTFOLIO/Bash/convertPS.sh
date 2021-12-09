mapfile -d $'\0' psFiles < <(find /mnt/z/Data_Processed/Plasticity_Grant/GABA/LCMODEL/Data_Processed/ -name "ps" -print0)

for psFile in "${psFiles[@]}"
do
ps2pdf $psFile
done

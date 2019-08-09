fct_dlfile(){
FileDL=$1
  if [ ! -f `basename $FileDL` ]
  then
    wget -c $FileDL
  else 
    echo "file $FileDL already exist "
  fi
}
fct_dlfile ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/integrated_call_samples_v2.20130502.ALL.ped


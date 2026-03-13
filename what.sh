
#process dataset

mkdir signal_scaled
python scripts/process.py signal/file1.txt signal/meta.json signal_scaled/file1.txt
python scripts/process.py signal/file2.txt signal/meta.json signal_scaled/file2.txt
python scripts/process.py signal/file3.txt signal/meta.json signal_scaled/file3.txt


#create new metadata

cat signal_scaled/file*.txt|awk '{a+=$1}END{print a}'|jq '.|{sum: .}' > signal_scaled/meta.json



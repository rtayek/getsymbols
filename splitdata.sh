# script  to split big csv file and add headers
# runs in /d/data/yahoodata
rm split.*
split -d   --suffix-length=3 --additional-suffix=.csv -l 500  yahoosymbols.csv split.
sed -i '1d' split.000.csv
sed -i "1s/^/`head -n 1 yahoosymbols.csv`\n/" split.*.csv

#!/bin/sh

readonly SRCFILE=$1 #"_bundle.pdf"
command -v pdfinfo || exit 1
command -v pdfjam || exit 1

# pdf page count has to equal a factor of four
count_original=$(pdfinfo $SRCFILE | awk '/^Pages:/ {print $2}')
if [ $((count_original%4)) -eq 0 ]; then
  count=$((count_original+4))
else # fill up to factor of four
  count=$((count_original + (count_original%4)))
fi
#count_groups=$((count/20)) #20 source pdf pages, 10 origin pdf pages, 5 print pages per batch

# 1: page n
# 2: page 1
# 3: page 2
# 4: page n-1
# 5: page n-2
# 6: page 3
# 7: page 4
# 8: page n-3
# 9: page n-4
#    etc.
make_booklet_order() {
#  for h in $(seq 1 $count_groups); do
    for i in $(seq 1 $((count/2))); do
      #value=$(set_by_evenness $(($i*$h)))
      value=$(set_by_evenness $i)
      both+=$value
      [ $((i%2)) -eq 0 ] && \
        backpage+=$value || \
        frontpage+=$value
    done
#  done
}

set_by_evenness() {
  i=$((count - ($1-1)))
  [ $i -gt $count_original ] && i=2 #fill last pages with blank page (requires 2nd page in source PDF to be blank)
  if [ $(($1%2)) -eq 0 ]; then # even
    value="$SRCFILE $1 $SRCFILE $i "
  else # odd
    value="$SRCFILE $i $SRCFILE $1 "
  fi
  echo "$value"
}

make_booklet_order

#pdfjam --landscape --scale 0.9 --twoside --nup 2x1
pdfjam --landscape --nup 2x1 --outfile "_reordered_$SRCFILE" $both
pdfjam --landscape --nup 2x1 --outfile "_reordered_front_$SRCFILE" $frontpage
pdfjam --landscape --nup 2x1 --outfile "_reordered_back_$SRCFILE" $backpage

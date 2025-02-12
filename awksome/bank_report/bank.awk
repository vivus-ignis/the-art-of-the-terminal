BEGIN {
  FS=";"
}

# skip the first 14 lines and consider only expenses (amount start with a minus sign)
$1 ~ /^[0-9]/ && $(NF-1) ~ /^-/ {
  split($1, date, ".")  # date format is DD.MM.YYYY
  month = int(date[2])

  # convert this -5.025,15 to this 5025.15
  amount = $(NF-1)
  gsub(/\./, "", amount)
  gsub(/,/, ".", amount)
  gsub(/-/, "", amount)

  amount = int(amount)
  # ^^^ this is needed because gsub string operation labelled amount as string value

  buckets[month, "total_amount"] += amount
  buckets[month, "trxn_count"]++

  months[month] = 1

  if (amount <= 10) {
    buckets[month, "0-10", "amount"] += amount
    buckets[month, "0-10", "trxn"]++
  }
  if (amount > 10 && amount <= 100) {
    buckets[month, "11-100", "amount"] += amount
    buckets[month, "11-100", "trxn"]++
  }
  if (amount > 100 && amount <= 500) {
    buckets[month, "101-500", "amount"] += amount
    buckets[month, "101-500", "trxn"]++
  }
  if (amount > 500 && amount <= 1000) {
    buckets[month, "501-1000", "amount"] += amount
    buckets[month, "501-1000", "trxn"]++
  }
  if (amount > 1000) {
    buckets[month, "1001", "amount"] += amount
    buckets[month, "1001", "trxn"]++
  }
}

END {
  # MONTH   x%/y%  x%/y%   x%/y%    x%/y%    x%/y%
  # x -- % of all transactions
  # y -- % of all spends

  printf("%-7s %-6s %-6s %-6s %-6s %-6s\n", "MONTH", "1-10", "11-100", "101-500", "501-1000", "1001-...")
  printf(                                   "----------------------------------------------------------\n")
  for (month in months) {
    printf("%-5s %3d/%-3d %3d/%-3d %3d/%-3d %3d/%-3d %3d/%-3d\n", \
            month, \
            buckets[month, "0-10", "amount"] / buckets[month, "total_amount"] * 100, \
            buckets[month, "0-10", "trxn"] / buckets[month, "trxn_count"] * 100, \
            buckets[month, "11-100", "amount"] / buckets[month, "total_amount"] * 100, \
            buckets[month, "11-100", "trxn"] / buckets[month, "trxn_count"] * 100, \
            buckets[month, "101-500", "amount"] / buckets[month, "total_amount"] * 100, \
            buckets[month, "101-500", "trxn"] / buckets[month, "trxn_count"] * 100, \
            buckets[month, "501-1000", "amount"] / buckets[month, "total_amount"] * 100, \
            buckets[month, "501-1000", "trxn"] / buckets[month, "trxn_count"] * 100, \
            buckets[month, "1001", "amount"] / buckets[month, "total_amount"] * 100, \
            buckets[month, "1001", "trxn"] / buckets[month, "trxn_count"] * 100)
  }
}

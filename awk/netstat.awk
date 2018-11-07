# $1 - Proto
# $2 - Recv-Q
# $3 - SEnd-Q
# $4 - Local Address
# $5 - Foreign Address
# $6 - State
# $7 - PID/Program Name

BEGIN {
  states = ";ESTABLISHED;SYN_SENT;SYN_RECV;FIN_WAIT1;FIN_WAIT2" \
           ";TIME_WAIT;CLOSE;CLOSE_WAIT;LAST_ACK;LISTEN;CLOSING;UNKNOWN;"
}

function join(array, start, end, sep, result, i)
{
  if (sep == "")
    sep = " "
  else if (sep == SUBSEP) # magic value
    sep = ""
  result = array[start]
  for (i = start + 1; i <= end; i++)
    result = result sep array[i]
  return result
}

{
  if ($1 ~ /^(tcp|udp)$/ ) {
    split($4,laddr,":")
    split($5,faddr,":")
  } else {
    split($4,a,":")
    laddr[1] = join(a, 1, length(a) - 1, ":")
    laddr[2] = a[length(a)]

    split($5,a,":")
    faddr[1] = join(a, 1, length(a) - 1, ":")
    faddr[2] = a[length(a)]
  }
  if (states ~ ";" $6 ";") {
    state = $6
    split($7,pid,"/")
  } else {
    state = "NO_STATE"
    split($6,pid,"/")
  }

  print $1 ";" laddr[1] ";" laddr[2] ";" faddr[1] ";" faddr[2] ";" state ";" pid[1] ";" pid[2]
}

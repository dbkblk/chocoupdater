Loop, %0% {
if (%a_index% = 1) {
	str := %A_index%
}
else {
	str := str " " %A_index%
}
}

if str
	Run  *RunAs %comspec% /c cup -y %str% && timeout 5

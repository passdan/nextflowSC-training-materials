//process_input_value.nf


process PRINTCHR {

  input:
  val chr

  output:
  path "${chr}.txt"

  script:
  """
  echo processing chromosome $chr >${chr}.txt
  """
}



workflow {
  chr_ch = channel.of( 'A' .. 'P' )

  PRINTCHR(chr_ch)
  PRINTCHR.out.view()
}

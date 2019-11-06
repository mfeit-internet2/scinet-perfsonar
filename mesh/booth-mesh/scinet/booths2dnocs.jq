# Warning:  Both 1081 is hard-coded as the NOC.

[
  .
  | .[]
  | if .Dnoc != ""
    then
      {"\(.Name | split(" ")[1])": (
        (.Dnoc | split(" ")[1]) as $dnoc
        # TODO: This needs to set proper FQDNs
        | if $dnoc == "1081" then "noc" else $dnoc end
        )
      }
    else
      empty
    end
]
| add

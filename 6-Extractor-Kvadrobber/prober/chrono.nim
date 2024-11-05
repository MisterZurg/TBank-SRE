declareCounter myCounter, "an example counter"

type
  Prober = object
    name: string

method collide(a: Prober) =
  echo "unimplemented"


var
  pb: Prober = Prober(name: "zeliboba")

echo pb

pb.collide()

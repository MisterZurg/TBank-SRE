type
  State = enum
    Closed, Open, HalfOpen


# # Define transitions
# let transitions = {
#   (Locked, InsertCoin): Unlocked,
#   (Unlocked, Push): Locked
# }.toTable

defmodule YomelTest do
  use ExUnit.Case

  test "the truth" do
    input = """
    ---
    receipt:     Oz-Ware Purchase Invoice
    date:        2007-08-06
    customer:
        given:   Dorothy
        family:  Gale

    items:
        - part_no:   A4786
          descrip:   Water Bucket (Filled)
          price:     1.47
          quantity:  4

        - part_no:   E1628
          descrip:   High Heeled "Ruby" Slippers
          size:      8
          price:     100.27
          quantity:  1

    bill_to:  &id001
        street: |
                123 Tornado Alley
                Suite 16
        city:   East Centerville
        state:  KS

    ship_to:  *id001

    specialDelivery:  >
        Follow the Yellow Brick
        Road to the Emerald City.
        Pay no attention to the
        man behind the curtain.
    ...
    """

    events = Yomel.Parser.event_stream(input) |> Enum.to_list

    assert is_list(events)
    assert Enum.count(events) > 20
    assert [:stream_start, :document_start | _] = events
  end
end

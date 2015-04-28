defmodule DecoderTest do
  use ExUnit.Case
  import TestHelper

  test "decoding untagged scalar" do
    events = pack [
      {:scalar, "a", nil, nil, :plain}
    ]
    {:ok, actual} = Yomel.Decoder.decode(events)
    expected = ["a"]

    assert actual == expected
  end

  test "decoding int tagged scalar" do
    events = pack [
      {:scalar, "1", nil, "tag:yaml.org,2002:int", :plain}
    ]
    {:ok, actual} = Yomel.Decoder.decode(events)
    expected = [1]

    assert actual == expected
  end

  test "decoding str tagged scalar" do
    events = pack [
      {:scalar, "1", nil, "tag:yaml.org,2002:str", :plain}
    ]
    {:ok, actual} = Yomel.Decoder.decode(events)
    expected = ["1"]

    assert actual == expected
  end

  test "decoding float tagged float" do
    events = pack [
      {:scalar, "1.0", nil, "tag:yaml.org,2002:float", :plain}
    ]
    {:ok, actual} = Yomel.Decoder.decode(events)
    expected = [1.0]

    assert actual == expected
  end

  test "decoding float tagged integer" do
    events = pack [
      {:scalar, "1", nil, "tag:yaml.org,2002:float", :plain}
    ]
    {:ok, actual} = Yomel.Decoder.decode(events)
    expected = [1.0]

    assert actual == expected
  end

  test "decoding sequence events" do
    events = pack [
      {:sequence_start, nil, nil, :block},
      {:scalar, "a", nil, nil, :plain},
      {:scalar, "b", nil, nil, :plain},
      :sequence_end
    ]
    {:ok, actual} = Yomel.Decoder.decode(events)
    expected = [["a", "b"]]

    assert actual == expected
  end

  test "decoding mapping events" do
    events = pack [
      {:mapping_start, nil, nil, :block},
      {:scalar, "k", nil, nil, :plain},
      {:scalar, "v", nil, nil, :plain},
      :mapping_end
    ]
    {:ok, actual} = Yomel.Decoder.decode(events)
    expected = [%{"k" => "v"}]

    assert actual == expected
  end

  test "decoding multi-docs events" do
    events = [
      :stream_start,
      :document_start,
      {:scalar, "doc1", nil, nil, :plain},
      :document_end,
      :document_start,
      {:scalar, "doc2", nil, nil, :plain},
      :document_end,
      :stream_end
    ]
    {:ok, actual} = Yomel.Decoder.decode(events)
    expected = ["doc1", "doc2"]

    assert actual == expected
  end

  test "decoding empty doc events" do
    events = pack [{:scalar, "", nil, nil, :plain}]
    {:ok, actual} = Yomel.Decoder.decode(events)
    expected = [""]

    assert actual == expected
  end
end

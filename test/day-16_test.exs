defmodule AocTest.DaySixteen do
  use ExUnit.Case
  doctest AOC.Puzzles.DaySixteen
  import AOC.Puzzles.DaySixteen

  test "part 1" do
    assert part_one(["620080001611562C8802118E34"]) == 12
    assert part_one(["C0015000016115A2E0802F182340"]) == 23
    assert part_one(["A0016C880162017C3686B18A3D4780"]) == 31

    input = AOC.Setup.get_input(16)
    assert part_one(input) == 1007
  end

  test "part 2" do
    input = AOC.Setup.get_input(16)
    assert part_two(input) == 834151779165
  end

  test "parse" do
    assert parse(["D2FE28"]) == "110100101111111000101000"
  end

  test "parse_binary" do
    assert parse_binary("011111100101") == 2021
  end

  test "parse_literal_body" do
    assert parse_literal_body("101111111000101000") == {2021, "000"}

    assert parse_literal_body("0101001010010001001000000000") == {10, "01010010001001000000000"}
  end

  test "parse_packet" do
    # Literal
    contains_literal = "110100101111111000101000"

    expected_literal = %Packet{
      body: 2021,
      type: :literal,
      version: 6
    }

    assert parse_packet(contains_literal) == {expected_literal, "000"}

    # Has sub-length of 27
    with_subpacket_bit_len = "00111000000000000110111101000101001010010001001000000000"

    expected_packet = %Packet{
      type: :lt,
      version: 1,
      body: [
        %Packet{type: :literal, version: 6, body: 10},
        %Packet{type: :literal, version: 2, body: 20}
      ]
    }

    assert parse_packet(with_subpacket_bit_len) == {expected_packet, "0000000"}

    # Has 3 sub-packets
    with_subpacket_count = "11101110000000001101010000001100100000100011000001100000"

    expected_packet = %Packet{
      type: :max,
      version: 7,
      body: [
        %Packet{type: :literal, version: 2, body: 1},
        %Packet{type: :literal, version: 4, body: 2},
        %Packet{type: :literal, version: 1, body: 3}
      ]
    }

    assert parse_packet(with_subpacket_count) == {expected_packet, "00000"}
  end

  test "eval" do
    # C200B40A82 finds the sum of 1 and 2, resulting in the value 3.
    assert Packet.eval(hex_to_packets(["C200B40A82"])) == 3
    # 04005AC33890 finds the product of 6 and 9, resulting in the value 54.
    assert Packet.eval(hex_to_packets(["04005AC33890"])) == 54
    # 880086C3E88112 finds the minimum of 7, 8, and 9, resulting in the value 7.
    assert Packet.eval(hex_to_packets(["880086C3E88112"])) == 7
    # CE00C43D881120 finds the maximum of 7, 8, and 9, resulting in the value 9.
    assert Packet.eval(hex_to_packets(["CE00C43D881120"])) == 9
    # D8005AC2A8F0 produces 1, because 5 is less than 15.
    assert Packet.eval(hex_to_packets(["D8005AC2A8F0"])) == 1
    # F600BC2D8F produces 0, because 5 is not greater than 15.
    assert Packet.eval(hex_to_packets(["F600BC2D8F"])) == 0
    # 9C005AC2F8F0 produces 0, because 5 is not equal to 15.
    assert Packet.eval(hex_to_packets(["9C005AC2F8F0"])) == 0
    # 9C0141080250320F1802104A08 produces 1, because 1 + 3 = 2 * 2.
    assert Packet.eval(hex_to_packets(["9C0141080250320F1802104A08"])) == 1
  end

  test "sum_version_numbers" do
    packets = %Packet{
      type: :operator,
      version: 4,
      body: [
        %Packet{
          type: :operator,
          version: 1,
          body: [
            %Packet{
              type: :operator,
              version: 5,
              body: [
                %Packet{
                  type: :literal,
                  version: 6,
                  body: 15
                }
              ]
            }
          ]
        }
      ]
    }

    assert sum_version_numbers(packets) == 16
  end
end

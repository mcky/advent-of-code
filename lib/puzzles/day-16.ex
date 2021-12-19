defmodule Packet do
  defstruct [:type, :version, :body]

  def get_type(0), do: :sum
  def get_type(1), do: :product
  def get_type(2), do: :min
  def get_type(4), do: :literal
  def get_type(3), do: :max
  def get_type(5), do: :gt
  def get_type(6), do: :lt
  def get_type(7), do: :eq
  def get_type(_n), do: :unknown

  def new(type, version, body) do
    %Packet{
      type: get_type(type),
      version: version,
      body: body
    }
  end

  def eval_fn(:sum), do: &Enum.sum/1
  def eval_fn(:product), do: &Enum.product/1
  def eval_fn(:min), do: &Enum.min/1
  def eval_fn(:max), do: &Enum.max/1
  def eval_fn(:lt), do: fn [a, b] -> if a < b, do: 1, else: 0 end
  def eval_fn(:gt), do: fn [a, b] -> if a > b, do: 1, else: 0 end
  def eval_fn(:eq), do: fn [a, b] -> if a == b, do: 1, else: 0 end

  def eval(%Packet{type: :literal, body: value}), do: value

  def eval(%Packet{type: type, body: children}) when is_list(children) do
    values = Enum.map(children, &eval/1)
    f = eval_fn(type)
    f.(values)
  end
end

defmodule AOC.Puzzles.DaySixteen do
  def parse(input) do
    input
    |> Enum.at(0)
    |> String.graphemes()
    |> Enum.map(&hex_to_binary/1)
    |> Enum.join("")
  end

  def decimal_to_binary(num) when is_integer(num) do
    List.to_string(:io_lib.format("~8.2B", [num]))
    |> String.trim()
    |> String.pad_leading(4, "0")
  end

  def hex_to_binary(hex) do
    hex
    |> Integer.parse(16)
    |> elem(0)
    |> decimal_to_binary()
  end

  def parse_binary(s) do
    {n, _rem} = Integer.parse(s, 2)
    n
  end

  def parse_literal_body(s) do
    chunked =
      s
      |> String.graphemes()
      |> Enum.chunk_every(5)
      |> Enum.map(&Enum.join(&1, ""))

    {body_chunks, halt_idx} =
      chunked
      |> Enum.with_index()
      |> Enum.reduce_while([], fn
        {"1" <> bits, _idx}, acc -> {:cont, [bits | acc]}
        {"0" <> bits, idx}, acc -> {:halt, {[bits | acc], idx}}
      end)

    remainder =
      Enum.drop(chunked, halt_idx + 1)
      |> Enum.join("")

    body =
      body_chunks
      |> Enum.reverse()
      |> Enum.join("")
      |> parse_binary()

    {body, remainder}
  end

  def scan_binary_until("", acc, _count, _max_count) do
    {acc |> Enum.reverse(), ""}
  end

  def scan_binary_until(binary_s, acc, count, max_count) when count == max_count do
    {acc |> Enum.reverse(), binary_s}
  end

  def scan_binary_until(binary_s, acc, count, max_count) do
    {packet, remainder} = parse_packet(binary_s)

    scan_binary_until(remainder, [packet | acc], count + 1, max_count)
  end

  def scan_binary_until(binary_s, max_count) do
    scan_binary_until(binary_s, [], 0, max_count)
  end

  def scan_binary_until(binary_s) do
    # scan_binary_until will stop as soon as the remainder is empty,
    # so pass :infinity to continue until then
    scan_binary_until(binary_s, :infinity)
  end

  def parse_operator(binary_s) do
    {length_type_id, remainder} = String.split_at(binary_s, 1)

    case length_type_id do
      "0" ->
        {subp_bit_len, remainder} = String.split_at(remainder, 15)
        subp_len = parse_binary(subp_bit_len)
        {sub_packet_string, remainder} = String.split_at(remainder, subp_len)

        {result, _empty_remainder} = scan_binary_until(sub_packet_string)

        {result, remainder}

      "1" ->
        {num_subpackets_bits, remainder} = String.split_at(remainder, 11)
        num_subpackets = parse_binary(num_subpackets_bits)

        scan_binary_until(remainder, num_subpackets)
    end
  end

  def packet_header(binary_s) do
    {version, remainder} = String.split_at(binary_s, 3)
    {type, remainder} = String.split_at(remainder, 3)

    version = parse_binary(version)
    type = parse_binary(type)

    {version, type, remainder}
  end

  def parse_packet(binary_s) do
    {version, type, remainder} = packet_header(binary_s)

    {body, remainder} =
      case type do
        4 -> parse_literal_body(remainder)
        _operator -> parse_operator(remainder)
      end

    {
      Packet.new(type, version, body),
      remainder
    }
  end

  def sum_version_numbers(%Packet{version: version, body: body}) when is_list(body) do
    body
    |> Enum.map(&sum_version_numbers/1)
    |> Enum.sum()
    |> Kernel.+(version)
  end

  def sum_version_numbers(%Packet{version: version}) do
    version
  end

  def hex_to_packets(input) do
    {packets, _} =
      input
      |> parse()
      |> parse_packet()

    packets
  end

  def part_one(input) do
    packets = hex_to_packets(input)
    sum_version_numbers(packets)
  end

  def part_two(input) do
    packets = hex_to_packets(input)
    Packet.eval(packets)
  end
end

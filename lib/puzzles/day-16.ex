defmodule Packet do
  defstruct [:type, :version, :body]

  def get_type(4), do: :literal
  def get_type(_n), do: :operator

  def new(type, version, body) do
    %Packet{
      type: get_type(type),
      version: version,
      body: body
    }
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
    |> decimal_to_binary
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

  def scan_binary_until("", acc, count, max_count) do
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

  def scan_binary_s("", acc) do
    acc |> Enum.reverse()
  end

  def scan_binary_s(binary_s, acc) do
    {packet, remainder} = parse_packet(binary_s)

    scan_binary_s(remainder, [packet | acc])
  end

  def scan_binary_s(binary_s) do
    scan_binary_s(binary_s, [])
  end

  def parse_operator(binary_s) do
    {length_type_id, remainder} = String.split_at(binary_s, 1)

    case length_type_id do
      "0" ->
        {subp_bit_len, remainder} = String.split_at(remainder, 15)
        subp_len = parse_binary(subp_bit_len)
        {sub_packet_string, foo} = String.split_at(remainder, subp_len)
        {scan_binary_s(sub_packet_string), foo}

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

    case type do
      4 ->
        {body, remainder} = parse_literal_body(remainder)

        {
          Packet.new(type, version, body),
          remainder
        }

      n ->
        {body, remainder} = parse_operator(remainder)

        {
          Packet.new(type, version, body),
          remainder
        }
    end
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

  def part_one(input) do
    {packets, _} =
      input
      |> parse()
      |> parse_packet()

    sum_version_numbers(packets)
  end

  def part_two(input) do
    input
    |> parse()
  end
end

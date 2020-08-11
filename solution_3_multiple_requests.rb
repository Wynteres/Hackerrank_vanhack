class RequestReader
  attr_reader :filename, :elements

  def initialize(filename:)
    @filename = filename
    @elements = []
  end

  def scan_lines
    File.open(@filename).each do |line|
      parsed_line = line.gsub("\n", '').match(%r[\d{2}\/\w*\/\d{4}*[:\d]*])[0]
      @elements << parsed_line
    end
  end

  def count_requests
    counter = Hash.new(0)
    @elements.each { |element| counter[element] += 1 }.select! { |element| counter[element] > 1 }.uniq!
  end

  def write_response_file
    File.open("req_#{@filename}", 'w') { |file| file.write(@elements.join("\n")) }
  end
end

rr = RequestReader.new(filename: 'hosts_access_log_00.txt') #change to filename
rr.scan_lines
rr.count_requests
rr.write_response_file

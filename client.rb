require 'socket'

class Client
  def initialize(socket)
    @socket = socket
    @request_object = send_request
    @response_object = listen_response

    @request_object.join # will send the request to server
    @response_object.join # will receive response from server
  end

  def send_request
    puts "Please enter your username to establish a connection..."
    begin
      Thread.new do
        loop do
          message = $stdin.gets.chomp
          @socket.puts message
        end
      end
    rescue IOError => e
      puts e.message
      # e.backtrace
      @socket.close
    end

  end

  def listen_response
    Thread.new do
      loop do
        response = @socket.gets.chomp
        puts "#{response}"
        @socket.close if response.eql? 'quit'
      end
    end
  rescue IOError => e
    puts e.message
    # e.backtrace
    @socket.close
  end
end

socket = TCPSocket.open('localhost', 3000)
Client.new(socket)

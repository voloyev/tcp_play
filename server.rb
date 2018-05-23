require 'socket'

class Server
  def initialize(sock_address, sock_port)
    @server_socket = TCPServer.open(sock_port, sock_address)
    @connected_clients = {}
    @connections_details = { server: @server_socket, clients: @connected_clients }
  end

  def run
    loop do
      client_connection = @server_socket.accept
      puts 'About to creaеte connection'
      Thread.start(client_connection) do |conn|
        conn_name = conn.gets.chomp.to_sym
        if details(conn_name) != nil
          conn.puts 'This username already exists'
          conn.puts 'quit'
          conn.kill self
        end

        puts "Connection established #{conn_name} => #{conn}"
        add_details(conn_name, conn)
        conn.puts "Connection established successfully #{conn_name} => #{conn}"
        establish_chatting(conn_name, conn)
      end
    end.join
  end

  private

  def details(conn_name)
    @connections_details[:clients][conn_name]
  end

  def add_details(conn_name, conn)
    @connections_details[:clients][conn_name] = conn
  end

  def establish_chatting(username, connection)
    loop do
      message = connection.gets.chomp
      puts @connections_details[:clients]
      (@connections_details[:clients]).keys.each do |client|
        @connections_details[:clients][client].puts "#{username} : #{message}"
      end
    end
  end
end

Server.new(3000, 'localhost').run

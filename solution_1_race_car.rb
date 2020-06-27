require 'ostruct'
require 'pry-byebug'

class Vertex
  attr_accessor :neighboors,
    :distance_from_start

  attr_reader :lane, :obstacle_vertex

  MAX_DISTANCE = 4294967296

  def initialize(lane:, obstacle_vertex: false, distance_from_start: MAX_DISTANCE)
    @lane = lane
    @obstacle_vertex = obstacle_vertex
    @neighboors = Array.new
    @distance_from_start = distance_from_start
  end
end

class Edge
  attr_reader :vertex, :distance

  def initialize(vertex:, distance: )
    @vertex = vertex
    @distance = distance
  end
end

class RaceCarMovement
  def calculate(obstacles)
    @obstacles = obstacles
    populate_graph_map
    generate_edges
    shortest_path
  end

  private

  def shortest_path
    @graph_map.each do |row|
      row.each do |vertex|
        vertex.neighboors.each do |edge|
          relative_distance = edge.distance + vertex.distance_from_start
          if relative_distance < edge.vertex.distance_from_start
            edge.vertex.distance_from_start = relative_distance
          end
        end
      end
    end

    @graph_map.last.sort_by { |vertex| vertex.distance_from_start }.first.distance_from_start
  end

  def populate_graph_map
    @graph_map = [[]]
    @graph_map[0].push(Vertex.new(lane: 0, obstacle_vertex: true))
    @graph_map[0].push(Vertex.new(lane: 1, obstacle_vertex: false, distance_from_start: 0))
    @graph_map[0].push(Vertex.new(lane: 2, obstacle_vertex: true))

    new_vertex =
      (1..@obstacles.size).map do |row|
        (0..2).map do |lane|
          obstacle_vertex = (@obstacles[row-1] - 1 == lane)

          Vertex.new(lane: lane, obstacle_vertex: obstacle_vertex)
        end
      end

    @graph_map.concat(new_vertex)
  end

  def generate_edges
    @graph_map.each_with_index do |lanes, index|
      unless index == @obstacles.size
        next_vertex_set = @graph_map[index + 1]
        lanes.each do |vertex|
          next if vertex.obstacle_vertex

          connect_to(vertex, next_vertex_set)
        end
      end
    end
  end

  def connect_to(vertex, next_vertex_set)
    next_vertex_set.each do |next_vertex|
      next if next_vertex.obstacle_vertex

      distance = (next_vertex.lane != vertex.lane) ? 1 : 0
      vertex.neighboors.push(Edge.new(vertex: next_vertex, distance: distance))
    end
  end
end

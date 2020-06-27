require 'ostruct'

class Vertex
  attr_accessor :neighboors,
    :visited,
    :distance_from_start

  attr_reader :lane, :row, :obstacle_vertex

  MAX_DISTANCE = 4294967296

  def initialize(lane:, obstacle_vertex: false, distance_from_start: MAX_DISTANCE)
    @lane = lane
    @obstacle_vertex = obstacle_vertex
    @neighboors = []
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

class Dijkstra
  attr_reader :graph_map

  def initialize(obstacles)
    @graph_map = [
      [
        Vertex.new(lane: 0, obstacle_vertex: true),
        Vertex.new(lane: 1, obstacle_vertex: false, distance_from_start: 0),
        Vertex.new(lane: 2, obstacle_vertex: true),
      ]
    ]

    @obstacles = obstacles
    @rows = obstacles.size
  end

  def calculate
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
    new_graphs = (1..@rows).map do |row|
      row = (0..2).map do |lane|
        obstacle_vertex = (@obstacles[row-1] - 1 == lane)

        Vertex.new(lane: lane, obstacle_vertex: obstacle_vertex)
      end
    end

    @graph_map += new_graphs
  end

  def generate_edges
    @graph_map.each_with_index do |lanes, index|
      unless index == @rows
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

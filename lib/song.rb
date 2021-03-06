class Song
  extend Concerns::Findable
  @@all = []
  attr_accessor :name
  attr_reader :artist, :genre

  #Hook
  def initialize(name, artist = nil, genre = nil)
    @name = name
    self.artist = artist if artist
    self.genre = genre if genre
  end

  #Class methods

  def self.all
    @@all
  end

  def self.destroy_all
    self.all.clear
  end

  def self.create(name)
    new_song = self.new(name)
    new_song.save
    new_song
  end

  def self.find_by_name(name)
    self.all.detect {|song| song.name == name}
  end

  def self.find_or_create_by_name(name)
      find_by_name(name) || create(name)
  end

  def self.new_from_filename(filename)
    song = Song.new(filename.split(" - ")[1])
    artist = Artist.find_or_create_by_name(filename.split(" - ")[0])
    song.artist=(artist)
    genre = Genre.find_or_create_by_name(filename.split(" - ")[2].split(".mp3")[0])
    song.genre=(genre)
    song
  end

  def self.create_from_filename(filename)
    new_from_filename(filename).save
  end

  #Instance methods
  def save
    self.class.all << self
  end

  def artist=(artist)
    @artist = artist
    artist.add_song(self)
  end

  def genre=(genre)
    @genre = genre
    genre.songs << self unless genre.songs.include?(self)
  end

end

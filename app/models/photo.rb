class Photo < ActiveRecord::Base
  attr_accessible :image, :md5, :width, :height, :mean_color, :format
  serialize :mean_color
  mount_uploader :image, ImageUploader

  validates :image,  :presence => true
  validates_uniqueness_of :md5
  before_validation :calculate_md5  

  def calculate_md5
    if self.image.file
      require 'digest/md5'
      self.md5 = Digest::MD5.hexdigest(self.image.file.read)
    end
  end
  
  # load the all imageas and match the pixcel values.
  def self.match_pixel(pixel,mean_color)
    collect_color = mean_color[0].to_a
    diffs = collect_color.collect do |photo|
      color_difference pixel, photo[1] 
    end
    collect_color[diffs.index(diffs.min)][0]
  end

# fetch the mean color for friends images
  def self.fetch_mean_color(all_images)
    mean_array = []
    collect_mean_color = {}
    p all_images.count
    i=1
    all_images.each do |photo|
      p i
      i=i+1
      image = Magick::ImageList.new  
      urlimage = open(photo) 
      img = image.from_blob(urlimage.read)
    
      red = green = blue = 0
      img.each_pixel do |p, x, y|
        red += p.red
        green += p.green
        blue += p.blue
      end
      num_pixels = img.bounding_box.width * img.bounding_box.height
      mean_color = {
      :red => red / num_pixels,
      :green=> green / num_pixels,
      :blue=> blue / num_pixels
      }
      collect_mean_color[photo] = mean_color
    end
    mean_array << collect_mean_color
    return mean_array
  end
  
  
# Make the color diffference and find the closest image.
#here check the input image rgb - for all fixel by matching the other images.
  def self.color_difference(rgb1, rgb2)
    red, green, blue = rgb1['red'] - rgb2[:red], rgb1['green'] - rgb2[:green], rgb1['blue'] - rgb2[:blue]
    Math.sqrt( (red * red) + (green * green) + (blue * blue) )
  end
end

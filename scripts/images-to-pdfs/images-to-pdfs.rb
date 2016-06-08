require 'rmagick'

# Get images directory & pdfs directory as argument from terminal
def convert images_directory , pdfs_directory

  # Check if pdf directry exists - else create the pdf directory
  unless Dir.exist? pdfs_directory
    Dir.mkdir(pdfs_directory)
  end

  if Dir.exist? images_directory

    # Get all files from that directory
    all_images = Dir.entries(images_directory)

    #Segregate only the required the question paper images , just in case the directory contains other files
    starting = %w[mid- end-]
    ending = %w[.jpg .png .tif .gif .svg .bmp]
    all_images.keep_if { |a| (a.start_with? *starting) && (a.end_with? *ending)}

    #Store number of images as a variable to show % finished
    number_of_images = all_images.count

    # Initialisation of variables like Array of names of papers , eg. mid-spring-2016-MA20104
    Dir.chdir(images_directory)
    papernames_array = []
    i = 0
    all_images = all_images.sort
    stack = Magick::ImageList.new

    #Loop through all paper images & batch merge them into PDFs , even if a paper has 3 pages / images
    all_images.each do |file|
      papernames_array[i] = file[0..22]
      if i == 0
        Dir.chdir(images_directory)
        stack = Magick::ImageList.new
        incoming = Magick::ImageList.new file
        stack.concat(incoming)
      else
        if papernames_array[i].eql? papernames_array[i-1]
          Dir.chdir(images_directory)
          incoming = Magick::ImageList.new file
          stack.concat(incoming)
        else
          Dir.chdir(pdfs_directory)
          stack.write(papernames_array[i-1]+".pdf")
          Dir.chdir(images_directory)
          stack = Magick::ImageList.new
          incoming = Magick::ImageList.new file
          stack.concat(incoming)
        end
        if i == number_of_images-1
          Dir.chdir(pdfs_directory)
          stack.write(papernames_array[i]+".pdf")
        end
      end
      i = i + 1
      percentage = (i.to_f/number_of_images.to_f) * 100
      puts "Processing #{i}/#{number_of_images} images , #{percentage}% done"
    end

  else

    puts "Images-to-pdfs conversion failed : Images directory doesn't exist."  
  
  end  
end  

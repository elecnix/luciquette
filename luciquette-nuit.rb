require "prawn"
require "json"
require 'optparse'
require 'json'

options = {}
OptionParser.new do |opt|
  opt.on('--file JSON_FILE') { |o| options[:file] = o }
end.parse!

Prawn::Font::AFM.hide_m17n_warning = true

label = JSON.parse(File.read(options[:file]))

keys = JSON.parse('{
    "srm" : "SRM",
    "ibu" : "IBU",
    "abv" : "ABV",
    "grains" : "GRAIN",
    "hops" : "HOUBLON",
    "yeast" : "LEVURE",
    "other" : "Notes",
    "ph" : "PH",
    "pbd" : "DaB",
    "id" : "DI",
    "fd" : "DF",
    "brewer" : "BRASSEURS",
    "brewdate" : "BRASSÉ",
    "bottledate" : "EMBOUTEILLÉ"}')

Prawn::Document.generate("out.pdf", :page_layout => :landscape) do
    font_families.update(
        "Luxi" => {
            :normal => "fonts/luximr.ttf",
            :bold => "fonts/luximb.ttf"
        },
        "LifeSavers" => {
            :normal => "fonts/LifeSavers-Regular.ttf",
            :bold => "fonts/LifeSavers-Bold.ttf"
        },
        "NotoMono" => {
            :normal => "fonts/NotoMono-Regular.ttf"
        },
        "Museo_Slab" => {
            :normal => "fonts/Museo_Slab_500italic-webfont.ttf"
        },
        "Aller" => {
            :normal => "fonts/Aller_Rg.ttf"
        }
    )
    [0, bounds.width / 2].each do |x|
        [bounds.height, bounds.height / 2].each do |y|
            stroke_color "a7a7a7"
            dash([1, 1], :phase => 1)
            bounding_box([x, y], :width => 72 * 4, :height => 72 * 3) do
                image "images/#{label['image']}", :height => bounds.height - 1, :position => :right
                move_up bounds.height
                fill_color "000000"
                fill_color "ffffff"
                move_down 10
                font "LifeSavers", :style => :bold
                text " #{label['name']}", :align => :center, :size => 35
                move_down 4
                text label['style'], :align => :center, :size => 16
                move_down 10
                stroke_color "000000"
                font "Luxi", :size => 8
                fill_color "444444"
                fill_color "999999"
                key_width = 72 * 1
                col_space = 8
                keyvalue = -> (key, value) {
                    value = "#{value}"
                    bb = bounding_box([-50, cursor], :width => 72 * 4) do
                        bounding_box([0, bounds.top], :width => key_width) do
                            text key, :align => :right
                        end
                        bounding_box([key_width + col_space, bounds.top], :width => bounds.width - key_width) do
                            text value
                        end
                        move_down 2.5
                    end
                }
                std_keyvalue = -> (key) {
                    keyvalue.call(keys[key], label[key])
                }
                std_keyvalue.call('brewer')
                std_keyvalue.call('bottledate')
                std_keyvalue.call('brewdate')
                keyvalue.call("DI/DF", " #{label['id']} / #{label['fd']}")
                keyvalue.call('ABV', " #{label['abv']}%")
                std_keyvalue.call('srm')
                std_keyvalue.call('ibu')
                std_keyvalue.call('dab')
                std_keyvalue.call('ph')
                std_keyvalue.call('grains')
                std_keyvalue.call('hops')
                std_keyvalue.call('yeast')
            end
        end
    end
end


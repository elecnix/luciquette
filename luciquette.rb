require "prawn"
require "json"
require 'optparse'
require 'json'

options = {}
OptionParser.new do |opt|
  opt.on('--file JSON_FILE') { |o| options[:file] = o }
end.parse!

Prawn::Font::AFM.hide_m17n_warning = true

json_label = JSON.parse(File.read(options[:file]))

labels = JSON.parse('{"srm" : "SRM",
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
    "brewer" : "BRASSÉ AU",
    "brewdate" : "LE",
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
    guide_offset = 10
    pouce = 72
    label_width = pouce * 4
    label_height = pouce * 3.5
    marge = 10
    jeu = 4 # jeu entre les boites
    sections = [["srm", "ibu", "abv"],
                ["grains"], ["hops"], ["yeast"], ["other"],
                ["pbd", "ph"], ["id", "fd"], ["bottledate"], ["brewer", "brewdate"]]

    [0, bounds.width / 2].each do |x|
        [bounds.height, bounds.height / 2].each do |y|
            stroke_color "a7a7a7"
            dash([1, 6], :phase => 1)

            bounding_box([x, y], :width => label_width, :height => label_height) do
                stroke_bounds
                fill_color "ffffff"
                fill_color "000000"
                font "LifeSavers", :style => :bold
                move_down marge
                text " #{json_label['name']}", :align => :center, :size => 35
                tw = json_label['style'].to_s.length + (pouce * 0.25)
                move_down jeu
                swidth = label_width - pouce * 0.25
                bounding_box([0, cursor], :width => swidth, :height => pouce * 0.5) do
                    text json_label['style'], :align => :right, :size => 16
                end
                stroke do
                  stroke_color "102099"
                  dash([1, 0], :phase => 1)
                  lh = label_height-pouce*1.15
                  self.line_width = 1.5
                  stroke_line [label_width/2, lh], [label_width, lh]
                  fill_gradient [50, 100], [150, 200], '102099', '000033'
                end
                font_size = 9
                font "Luxi", :size => font_size

                sections.each do | l |
                  col = marge
                  ncol = l.length
                  col_width = label_width/ncol
                  l.each do | key |
                    content = json_label[key].to_s
                    largeur = content.length * font_size
                    hauteur = (largeur / label_width + 1) * (font_size)
                    text_box("#{labels[key]}:  #{content}", :kerning => true, :at => [col, cursor]) do
                    end
                    col = col + col_width
                    if hauteur > font_size
                      move_down hauteur - font_size # multiligne
                    end
                  end
                  move_down font_size + jeu
                end
            end
        end
    end
end

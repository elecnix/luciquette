require "prawn"
Prawn::Font::AFM.hide_m17n_warning = true
class Label
    def initialize(
            name,
            p
        )
        @name = name
        @style = p[:style]
        @srm = p[:srm]
        @brewer = p[:brewer]
        @brewdate = p[:brewdate]
        @bottledate = p [:bottledate]
        @abv = p[:abv]
        @ibu = p[:ibu]
        @grains = p[:grains]
        @hops = p[:hops]
        @yeast = p[:yeast]
        @pbd = p[:pbd]
        @id = p[:id]
        @fd = p[:fd]
        @ph = p[:ph]
        @dab = p[:dab]
    end
    def name
        @name
    end
    def style
        @style
    end
    def srm
        @srm
    end
    def ibu
        @ibu
    end
    def brewer
        @brewer
    end
    def brewdate
        @brewdate
    end
    def bottledate
        @bottledate
    end
    def abv
        @abv
    end
    def grains
        @grains
    end
    def hops
        @hops
    end
    def yeast
        @yeast
    end
    def pbd
        @pbd
    end
    def id
        @id
    end
    def fd
        @fd
    end
    def ph
        @ph
    end
    def dab
        @dab
    end
end
label = Label.new("Reine des neiges",
    :style => "Hefeweizen",
    :srm => 5,
    :ibu => 13,
    :abv => 5.6,
    :ph => 6.1,
    :dab => 1.043,
    :grains => "Blé malté, orge 2 rangs, munich",
    :hops => "Hallertau Hersbruker",
    :yeast => "Wyeast bavarian 3046",
    :pbd => "1.050",
    :id => "1.051",
    :fd => "1.008",
    :brewer => "7291",
    :brewdate => "2019-02-03",
    :bottledate => "2019-02-16")
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
            stroke_horizontal_line x - 10, x, :at => y
            stroke_horizontal_line 72 * 4, 72 * 4 + 10, :at => y
            stroke_horizontal_line x - 10, x, :at => y - 72 * 3.5
            stroke_horizontal_line 72 * 4, 72 * 4 + 10, :at => y - 72 * 3.5
            stroke_vertical_line bounds.height, bounds.height + 10, :at => 0
            stroke_vertical_line y, y + 18, :at => x
            stroke_vertical_line y, y + 18, :at => x + 72 * 4
            
            bounding_box([x, y], :width => 72 * 4, :height => 72 * 3.5) do
                #transparent(1) do
                #  fill_color "eeeeff"
                #  fill_rectangle [0, 72 * 3.5], 72 * 4, 72 * 3.5
                #end
                fill_color "ffffff"
                fill_color "000000"
                move_down 10
                font "LifeSavers", :style => :bold
                text " #{label.name}", :align => :center, :size => 35
                move_down 4
                bounding_box([0, cursor], :width => 72 * 4 - 72 * 0.25, :height => 72 * 0.5) do
                    #fill_color "0000FF"
                    #fill_rectangle [0, bounds.height], 72 * 4, bounds.height
                    text label.style, :align => :right, :size => 16
                end
                stroke_color "dddddd"
                dash([3, 6], :phase => 6)
                #stroke_bounds
                y_position = cursor
                space = 6
                font "Luxi", :size => 8
                #fill_color "aaa19d"
                fill_color "444444"
                left_col_width = 1
                bounding_box([0, y_position], :width => 72 * left_col_width - space / 2, :height => 72 * 3.5 / 2) do
                    text "SRM", :align => :right
                    text "IBU", :align => :right
                    text "ABV", :align => :right
                    text "DI/DF", :align => :right
                    text "DaB", :align => :right
                    text "PH", :align => :right
                    text "GRAIN", :align => :right
                    text "HOUBLON", :align => :right
                    text "LEVURE", :align => :right
                    text "BRASSAGE", :align => :right
                    text "EMB", :align => :right
                    text "BRASSÉE AU", :align => :right
                end
                bounding_box([72 * left_col_width + space / 2, y_position], :width => 72 * 4 - 72 * left_col_width - space / 2, :height => 72 * 3.5 / 2) do
                    text " #{label.srm}"
                    text " #{label.ibu}"
                    text " #{label.abv}%"
                    text " #{label.id}/#{label.fd}"
                    text " #{label.dab}"
                    text " #{label.ph}"
                    text " #{label.grains}"
                    text " #{label.hops}"
                    text " #{label.yeast}"
                    text " #{label.brewdate}"
                    text " #{label.bottledate}"
                    text " #{label.brewer}"
                end
            end
        end
    end
end

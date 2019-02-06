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
        @abv = p[:abv]
        @ibu = p[:ibu]
        @grains = p[:grains]
        @hops = p[:hops]
        @yeast = p[:yeast]
        @pbd = p[:pbd]
        @id = p[:id]
        @fd = p[:fd]
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
end
label = Label.new("LA BIÈRE",
    :style => "Pale Ale",
    :srm => 10,
    :ibu => 10,
    :abv => 5,
    :grains => "2-row",
    :hops => "Mosaic",
    :yeast => "US-05",
    :pbd => "1.050",
    :id => "1.065",
    :fd => "1.010",
    :brewer => "Lucie",
    :brewdate => "2019-01-27")
Prawn::Document.generate("out.pdf", :page_layout => :landscape) do
    [0, bounds.width / 2].each do |x|
        [bounds.height, bounds.height / 2].each do |y|
            bounding_box([x, y], :width => 72 * 4, :height => 72 * 3.5) do
                move_down 10
                font "Helvetica", :style => :bold
                text " #{label.name}", :align => :center, :size => 40
                text label.style, :align => :center, :size => 10
                stroke_color "aaaaaa"
                dash([3, 6], :phase => 6)
                stroke_bounds
                move_down 10
                y_position = cursor
                space = 6
                bounding_box([0, y_position], :width => 72 * 2 - space / 2, :height => 72 * 3.5 / 2) do
                    font "Helvetica", :size => 10
                    text "SRM", :align => :right
                    text "IBU", :align => :right
                    text "ABV", :align => :right
                    text "GRAIN", :align => :right
                    text "HOUBLON", :align => :right
                    text "LEVURE", :align => :right
                    text "DI", :align => :right
                    text "DF", :align => :right
                    text "BRASSEUR", :align => :right
                    text "DATE", :align => :right
                end
                bounding_box([72 * 2 + space / 2, y_position], :width => 72 * 2 - space / 2, :height => 72 * 3.5 / 2) do
                    font "Helvetica", :size => 10
                    text " #{label.srm}"
                    text " #{label.ibu}"
                    text " #{label.abv}%"
                    text " #{label.grains}"
                    text " #{label.hops}"
                    text " #{label.yeast}"
                    text " #{label.id}"
                    text " #{label.fd}"
                    text " #{label.brewer}"
                    text " #{label.brewdate}"
                end
            end
        end
    end
end
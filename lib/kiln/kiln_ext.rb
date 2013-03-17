class UIImage
  class << self
    alias :imageNamed_old :imageNamed
    def imageNamed(name)
      imageNamed_old(name)
    end
  end
end

class UIView

  class << self
    attr_accessor :kiln

    def kiln
      @kiln ||= {
        'Frame' => {
          frame: Kiln::FrameEditor,
        },
        'Color' => {
          backgroundColor: Kiln::ColorEditor,
        },
      }
    end

    # this could be optimized a tiny bit by only calling superclass.build_kiln
    # but i am le tired
    def build_kiln
      @retval ||= begin
        retval = Hash.new { |hash,key| hash[key] = {} }
        klasses = []
        klass = self
        while klass && klass <= UIView
          klasses.unshift(klass)
          klass = klass.superclass
        end

        klasses.each do |klass|
          kiln_props = klass.kiln
          kiln_props && kiln_props.each do |key,values|
            retval[key] = values.merge(retval[key])
          end
        end
        retval
      end
    end

  end

  def kiln
    self.class.build_kiln
  end

end


class << UILabel
  def kiln
    @kiln ||= {
      'Content' => {
        text: Kiln::TextEditor,
      }
    }
  end
end

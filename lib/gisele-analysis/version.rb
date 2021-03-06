module Gisele
  module Analysis
    module Version

      MAJOR = 0
      MINOR = 6
      TINY  = 0

      def self.to_s
        [ MAJOR, MINOR, TINY ].join('.')
      end

    end
    VERSION = Version.to_s
  end
end

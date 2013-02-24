# coding utf-8

require "FileUtils"
require "active_file/version"

require "rake"
import File.expand_path("../tasks/db.rake", __FILE__)

module ActiveFile
    def save
        @new_record = false # seta objeto como registro existente

        File.open("db/revistas/#{@id}.yml", "w") do |file|
            file.puts serialize
        end
    end

    def destroy(id)
        unless @destroyed or @new_record
            @destroyed = true
            FileUtils.rm "db/revistas/#{@id}.yml"
        end
    end

    module ClassMethods
      def field(name)
        @fields ||= []
        @fields << name

        get = %Q{
            def #{name}
                @#{name}
            end
        }

        set = %Q{
            def #{name}=(valor)
                @#{name}=valor
            end
        }

        self.class_eval get
        self.class_eval set
      end
      
      def find(id)
        raise DocumentNotFound, "Arquivo db/revistas/#{id} nao encontrado.", caller unless File.exists?("db/revistas/#{id}.yml")
        deserialize "db/revistas/#{id}.yml"
      end
      
      def next_id
          Dir.glob("db/revistas/*.yml").size + 1
      end
      
      def method_missing(name, *args, &block)
        field = name.to_s.split("_").last
        super if @fields.include? field 
        
        load_all.select do |object|
          object.send(field) == args.first
        end
      end
      
      private    
      
      def load_all
        Dir.glob('db/revistas/*.yml').map do |file|
          deserialize file
        end
      end

      def deserialize(file)
        YAML.load File.open(file, "r")
      end
    end

    def self.included(base)
        base.extend ClassMethods
        base.class_eval do
          def initialize(parameters = {})
              @id = self.class.next_id
              @destroyed = false
              @new_record = true

              parameters.each do |key, value|
                  instance_variable_set "@#{key}", value
              end
          end
        end
    end

    private

    def serialize
        YAML.dump self
    end
end


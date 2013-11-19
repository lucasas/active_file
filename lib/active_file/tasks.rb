module ActiveFile
  class GemHelper
    include Rake::DSL if defined? Rake::DSL

    class << self
      attr_accessor :instance

      def install_tasks(opts = {})
        new.install
      end
    end

    def install
      desc "Limpa todas os arquivos de uma midia"
      task :clear, [:folder] do |task, args|
        FileUtils.rm Dir["db/#{args.folder}/*.yml"]
      end

      desc "Popula com os dados definidos no arquivo db/folder/seeds.rb"
      task :seed, [:folder] do
        seed_file = File.expand_path "db/#{folder}/seeds.rb", __FILE__
        load(seed_file) if File.exist?(seed_file)
      end

      desc "Popula com os dados definidos no arquivo db/folder/seeds.rb apagando os existentes"
      task :reseed, [:folder] => ["db:clear", "db:seed"] do
      end

      GemHelper.instance = self
    end
  end
end

ActiveFile::GemHelper.install_tasks

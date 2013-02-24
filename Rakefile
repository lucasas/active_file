#!/usr/bin/env rake
require 'fileutils'

namespace :db do
    desc "Limpa todas os arquivos de uma midia"
    task :clear, [:folder] do |task, args|
        FileUtils.rm Dir["db/#{args[:folder]}/*.#{args[:file_extension]}"]
    end

    desc "Popula com os dados definidos no arquivo db/folder/seeds.rb"
    task :seed, [:folder] do
        seed_file = File.expand_path "db/#{folder}/seeds.rb", __FILE__
        load(seed_file) if File.exist?(seed_file)
    end

    desc "Popula com os dados definidos no arquivo db/folder/seeds.rb apagando os existentes"
    task :reseed, [:folder] => ["db:clear", "db:seed"] do
    end
end



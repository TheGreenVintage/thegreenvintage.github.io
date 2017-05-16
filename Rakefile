require 'open-uri'
require 'csv'
require 'yaml'

I18N_FILE = "https://docs.google.com/spreadsheets/d/e/2PACX-1vSSl8MxVlbv1b9IbkQXcHVmyGFNMFzFEMKk4cabvb0qIcBkBro3Vg2Wfslwg8DlRYZdltb9FYo3DHl7/pub?gid=0&single=true&output=csv"
DATA_FILES = {
  destinations: "https://docs.google.com/spreadsheets/d/1DXPTtb1tN-4HCwsLhMGICMxQrg8b28w1CnMAhT90rFo/pub?gid=1539468359&single=true&output=csv",
  activities: "https://docs.google.com/spreadsheets/d/1DXPTtb1tN-4HCwsLhMGICMxQrg8b28w1CnMAhT90rFo/pub?gid=802183433&single=true&output=csv",
  employees: "https://docs.google.com/spreadsheets/d/1DXPTtb1tN-4HCwsLhMGICMxQrg8b28w1CnMAhT90rFo/pub?gid=261678603&single=true&output=csv",
  home: "https://docs.google.com/spreadsheets/d/1DXPTtb1tN-4HCwsLhMGICMxQrg8b28w1CnMAhT90rFo/pub?gid=125310584&single=true&output=csv",
}

task :i18n do
  puts "Downloading i18n files..."

  open(I18N_FILE) do |file|
    csv2yaml(file)
  end
end

task :data do
  puts "Downloading data files..."
  DATA_FILES.each do |key, value|
    download(value, "_data/#{key}.csv")
  end
end

def download(url, path)
  open(url) {|f|
    File.open(path,"wb") do |file|
      file.puts f.read.gsub(/\r\n/, "\n")
    end
  }
end

def csv2yaml(file)
  data = CSV.read(file, :headers => true)

  headers = data.headers
  master = headers.slice!(0)
  translations = data.map(&:to_hash)

  languages = headers.map do |header|
    language = {}

    language[header] = translations.reduce({}) do |memo, translation|
      key = translation[master]
      value = translation[header]

      key_path = key.split('.')

      hash = memo

      loop do

        if key_path.length == 1
          value.strip! rescue puts "Error in #{key_path}" # TODO: Handle errors
          value = YAML.load(value) if key_path.first.end_with? '_list'

          hash[key_path.first] = value
        else
          step_hash = hash[key_path.first] || {}
          hash[key_path.first] = step_hash
          hash = step_hash
        end

        key_path.slice!(0)

        break if key_path.empty?
      end

      memo
    end

    language
  end

  languages.each do |language|
    File.open("_locales/#{language.keys.first}.yml", 'w') do |f|
      f.write "# Do not edit this generated file\n"
      f.write language.to_yaml
    end
  end
end


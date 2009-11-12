require 'ftools'
require 'watir'
require 'gchart'
require 'tk'
require 'win32ole'

class Belgamonitor

  def write_hash(filename, hash)
    File.open(filename, "w") do |f|
      f.write(hash.to_yaml)
    end
  end

  def read_hash(filename)
    yaml_data = IO.read(filename)
    YAML.load(yaml_data)
  end

  def update_statistics()
    config = read_hash('config.yaml')

    $ie.goto('http://www.belgacom.be/private/en/jsp/dynamic/homepage.jsp')
    $ie.text_field(:name, 'username').set(config["username"])
    $ie.text_field(:name, 'password').set(config["password"])
    $ie.form(:name, "logClient").submit
    $ie.link(:text, "my internet").click
    $ie.link(:text, "Consult monthly volume").click

    $ie.text =~ /Monthly volume used(.*)/
    rLine = $1
    rLine =~ /((\d{1,2} GB) (\d{1,3} MB)) out of (\d{1,2}) GB/

    usage_gb = $2.to_i * 1024
    usage_mb = $3.to_i
    limit_gb = $4.to_i * 1024
    total_usage_mb = usage_gb + usage_mb

    time = Time.now
    date = time.strftime("%d %b")

    daily_usage = {}
    if File.exist?('belgacom.yaml')
      daily_usage = read_hash('belgacom.yaml')
    end

    daily_usage[date] = total_usage_mb;

    write_hash('belgacom.yaml', daily_usage)

    daily_usage_mb_array   = []
    daily_usage_axis_labels = []
    daily_usage_axis_labels_string = ""
    daily_usage.sort.each {|value| daily_usage_mb_array.push value[1]}
    daily_usage.sort.each {|value| daily_usage_axis_labels.push value[0]}
    daily_usage_axis_labels.each {|value| daily_usage_axis_labels_string += value + '|'}
    daily_usage_axis_labels_string = daily_usage_axis_labels_string.chop

    $ie.goto Gchart.line(:data => daily_usage_mb_array,
                        :size => '600x200', 
                        :bg => 'efefef',
                        :title => 'Daily Internet Usage - Belgacom',
                        :max_value => 25 * 1024,
                        :axis_with_labels => 'x,y,r',
                        :axis_labels => [daily_usage_axis_labels_string,
                                         '0 GB | 5 GB| 10 GB| 15 GB| 20 GB| 25 GB',
                                         '0 GB | 5 GB| 10 GB| 15 GB| 20 GB| 25 GB'])

  end

  def show_current_statistics()  
    daily_usage = read_hash('belgacom.yaml')
  
    daily_usage_mb_array   = []
    daily_usage_axis_labels = []
    daily_usage_axis_labels_string = ""
    daily_usage.sort.each {|value| daily_usage_mb_array.push value[1]}
    daily_usage.sort.each {|value| daily_usage_axis_labels.push value[0]}
    daily_usage_axis_labels.each {|value| daily_usage_axis_labels_string += value + '|'}
    daily_usage_axis_labels_string = daily_usage_axis_labels_string.chop

    $ie.goto Gchart.line(:data => daily_usage_mb_array,
                        :size => '600x200', 
                        :bg => 'efefef',
                        :title => 'Daily Internet Usage - Belgacom',
                        :max_value => 25 * 1024,
                        :axis_with_labels => 'x,y,r',
                        :axis_labels => [daily_usage_axis_labels_string,
                                         '0 GB | 5 GB| 10 GB| 15 GB| 20 GB| 25 GB',
                                         '0 GB | 5 GB| 10 GB| 15 GB| 20 GB| 25 GB'])
  end

  def close()
    $ie.close
    exit
  end

  def initialize 
    @autoit = WIN32OLE.new("AutoItX3.Control")
    $ie = Watir::IE.new
    $ie.bring_to_front

    root = TkRoot.new{title "Belgacom ISP Monitor"}
    top  = TkFrame.new(root)

    ph = { 'padx' => 100, 'pady' => 50 }     # common options
    p_update_statistics = proc {update_statistics}
    p_show_current_statistics = proc {show_current_statistics}
    p_close = proc {close}

    if File.exist?('belgacom.yaml')
      current_status_button_status = "normal"
    else
      current_status_button_status = "disabled"
    end

    TkButton.new(top) {text 'Show current statistics'; 
                       state current_status_button_status; 
                       command p_show_current_statistics; 
                       pack ph}
    TkButton.new(top) {text 'Update statistics'; 
                       command p_update_statistics; 
                       pack ph}
    TkButton.new(top) {text 'Exit'; command p_close; pack ph}

    top.pack('fill'=>'both', 'side' =>'top')
  end
end

Belgamonitor.new
Tk.mainloop

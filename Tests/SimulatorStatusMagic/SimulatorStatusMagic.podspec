Pod::Spec.new do |s|
  s.name             = "SimulatorStatusMagic"
  s.version          = "2.7"
  s.summary          = "Enable perfect status bars in the iOS Simulator."
  s.description      = <<-DESC
                        Modify the iOS Simulator so that it has a perfect status bar, then run your app and take perfect screenshots every time. The modifications made are designed to match the images you see on the Apple site and are as follows:

                        * 9:41 AM is displayed for the time.
                        * The battery is full and shows 100%.
                        * 5 bars of cellular signal and full WiFi bars are displayed.
                        * Tue Jan 9 is displayed for the date (iPad only)
                       DESC
  s.homepage         = "https://github.com/shinydevelopment/SimulatorStatusMagic"
  s.license          = 'MIT'
  s.author           = { "Dave Verwer" => "dave.verwer@gmail.com", "Greg Spiers" => "gspiers@gmail.com", "Chris Vasselli" => "clindsay@gmail.com" }
  s.source           = { :git => "https://github.com/shinydevelopment/SimulatorStatusMagic.git", :tag => s.version.to_s }

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'SDStatusBarManager'
  s.frameworks = 'UIKit'
end

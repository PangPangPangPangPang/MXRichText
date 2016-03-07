Pod::Spec.new do |s|
  s.name         = "MXRichText"
  s.version      = "0.0.1"
  s.summary      = "A RichText widget，support emoji、attachment、link"
  s.homepage     = "http://mmmmmax.wang"
  s.license      = "MIT"
  s.authors      = { 'Max' => '446964321@qq.com'}
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/PangPangPangPangPang/MXRichText", :tag => s.version }
  s.source_files = 'MXRichText', 'MXRichText/MXRichText/*'
  s.requires_arc = true
end

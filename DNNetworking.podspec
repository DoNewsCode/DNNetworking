Pod::Spec.new do |s|
s.name         = 'DNNetworking'
s.version      = '1.0.0'
s.summary      = 'DoNews网络框架'
s.homepage     = 'https://github.com/DoNewsCode/DNNetworking'
s.license      = 'MIT'
s.authors      = {'MrJKzzz' => '372871577@qq.com'}
s.platform     = :ios, '8.0'
s.source       = {:git => 'https://github.com/DoNewsCode/DNNetworking.git', :tag => s.version}
s.source_files = 'DNNetworking/**/*'
s.dependency: 'AFNetworking','YYModel'
end
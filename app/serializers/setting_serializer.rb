class SettingSerializer < ActiveModel::Serializer
  attributes :id, :name, :value
  link(:self) { setting_url(object) }
end
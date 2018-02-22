class SettingsController < ApplicationController

  def index
    settings = Setting.all
    render json: settings
  end

  def show
    setting = Setting.find(params[:id])
    render json: setting
  end

  def update
    setting = Setting.find(params[:id])
    if setting.update_attributes(setting_params)
      render json: setting
    else
      render json: {}
    end
  end

  private

  def setting_params
    params.require(:setting).permit! if params[:setting]
  end
end
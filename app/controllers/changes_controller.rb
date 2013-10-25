class ChangesController < ApplicationController
  def destroy
    @change = Change.find(params[:id].to_i)
    @change.destroy
    redirect_to root_path
  end

  def delete_many

  end
end

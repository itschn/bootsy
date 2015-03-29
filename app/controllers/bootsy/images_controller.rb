require_dependency 'bootsy/application_controller'

module Bootsy
  class ImagesController < Bootsy::ApplicationController
    class Bootsy::ImagesController < ApplicationController
  
      #
      # Settings
      # ---------------------------------------------------------------------------------------
      #
      #
      #
      #
  
      #
      # Concerns
      # ---------------------------------------------------------------------------------------
      #
      #
      #
      #

      #
      # Filter
      # ---------------------------------------------------------------------------------------
      #
      #
      #
      #
  
      before_action :persist_gallery!, only: :create

      #
      # Plugins
      # ---------------------------------------------------------------------------------------
      #
      #
      #
      #
  
      #
      # Actions
      # ---------------------------------------------------------------------------------------
      #
      #
      #
      #
  
      def index
        respond_to do |format|
          format.html
          format.json do
            render json: {
              images: collection.map { |image| render_to_string(file: 'bootsy/images/_image', formats: [:html],locals: { image: image }, layout: false) },
              form: render_to_string(file: 'bootsy/images/index', formats: [:html], locals: { gallery: parent, image: parent.images.new }, layout: false)
            }
          end
        end
      end
      
      def create(options={}, &block)
        object = build_resource
        
        respond_to do |format|
          if object.save
            format.html { render json: [resource_fileupload_response_hash].to_json, content_type: 'text/html', layout: false }
            format.json { render json: { files: [resource_fileupload_response_hash] }, status: :created }
          else
            format.html { render action: :index }
            format.json { render json: { files: [error: resource.errors.full_messages.join('. '), name: original_filename] } }
          end
        end
      end
  
      def create
        super do |success, failure|      
          success.html do
            render json: [resource_fileupload_response_hash].to_json, content_type: 'text/html', layout: false
          end
          success.json do
            render json: { files: [resource_fileupload_response_hash] }, status: :created
          end

        end
      end
      
      def destroy
        resource.destroy

        respond_to do |format|
          format.json do
            render json: { id: params[:id] }
          end

          format.html { redirect_to images_url }
        end
      end
  
      #
      # Protected
      # ---------------------------------------------------------------------------------------
      #
      #
      #
      #

      protected
      
      def resource
        get_resource_ivar || set_resource_ivar(parent.images.find(params[:id]))
      end
  
      def parent
        @gallery ||= Bootsy::ImageGallery.find(params[:image_gallery_id])
      end
  
      def collection
        get_collection_ivar || set_collection_ivar(parent.images)
      end
  
      def persist_gallery!
        parent.save!
      end
  
      def build_resource
        get_resource_ivar || set_resource_ivar(parent.images.build(permitted_params[resource_instance_name]))
      end

      #
      # Private
      # ---------------------------------------------------------------------------------------
      #
      #
      #
      #

      private
  
      def permitted_params    
        params.permit(resource_instance_name => [:image_file])
      end
  
      def resource_fileupload_response_hash    
        resource_fileupload_response_hash = {
          name: resource.image_file.filename,
          icon_class: mimetype_icon_css_class(resource.image_file.content_type),
          thumb_url: resource.image_file.url(:tiny),
          content_type: resource.image_file.content_type,
          size: resource.image_file.size,
          url: resource.image_file.url(:tiny),
          resource_url: polymorphic_url([:bootsy, parent, resource], locale: I18n.locale),
          identifier: ActionController::Base.helpers.dom_id(resource, :row)
        }.stringify_keys
    
        resource_fileupload_response_hash
      end
      
      def original_filename
        if params[resource_instance_name] && params[resource_instance_name][:image_file]
          sanitized_file = CarrierWave::SanitizedFile.new(params[resource_instance_name][:image_file])
          sanitized_file.original_filename
        end
      end

    end
  end
end

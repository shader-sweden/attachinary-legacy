require 'attachinary/utils'

module Attachinary
  module Extension
    module Base

      def has_attachment(scope, options={})
        attachinary options.merge(single: true, scope: scope)
      end

      def has_attachments(scope, options={})
        attachinary options.merge(single: false, scope: scope)
      end

    private
      def attachinary(options)
        options = Attachinary::Utils.process_options(options)

        attachinary_orm_definition(options)
        
        # def photo?
        #   photo.present?
        # end
        # def images?
        #   images.present?
        # end
        define_method :"#{options[:scope]}?" do
          send(:"#{options[:scope]}").present?
        end

        # def photo_metadata
        #   options
        # end
        define_method :"#{options[:scope]}_metadata" do
          options
        end

        if options[:single]
          # def photo_url=(url)
          #   ...
          # end
          define_method :"#{options[:scope]}_url=" do |url, upload_options = {}|
            upload_options.merge! resource_type: 'auto'
            send(:"#{options[:scope]}=", Cloudinary::Uploader.upload(url, upload_options))
          end

        else
          # def image_urls=(urls)
          #   ...
          # end
          define_method :"#{options[:singular]}_urls=" do |urls, upload_options = {}|
            upload_options.merge! resource_type: 'auto'
            send(:"#{options[:scope]}=", urls.map { |url| Cloudinary::Uploader.upload(url, upload_options) })
          end
        end

      end

      # Helper method to check for rails 4
      def rails4?
        Rails::VERSION::MAJOR == 4
      end

      # Helper method to check for rails 5
      def rails5?
        Rails::VERSION::MAJOR == 5
      end

      # Helper method to check for rails 6
      def rails6?
        Rails::VERSION::MAJOR == 6
      end

       # Helper method to check for rails 7
      def rails7?
        Rails::VERSION::MAJOR == 7
      end
    end
  end
end

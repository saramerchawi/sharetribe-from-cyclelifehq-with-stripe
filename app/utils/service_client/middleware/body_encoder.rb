module ServiceClient
  module Middleware

    class JSONEncoder
      def encode(body)
        body.to_json unless body.nil?
      end

      def decode(body)
        JSON.parse(body) unless body.nil?
      end
    end

    class TransitEncoder

      def initialize(encoding)
        @_encoding = encoding
      end

      def decode(body)
        TransitUtils.decode(body, @_encoding) unless body.nil?
      end

      def encode(body)
        TransitUtils.encode(body, @_encoding) unless body.nil?
      end
    end

    class TextEncoder
      def encode(body)
        body.to_s unless body.nil?
      end

      def decode(body)
        body
      end
    end

    # Encodes the body to given encoding.
    #
    # The encoding is given to the constructor and that encoding is
    # used encode the request. For response, the Content-Type header
    # is used to define which decoder to use.
    #
    # Reads from res[:body] and writes to res[:body]
    #
    class BodyEncoder < MiddlewareBase

      ENCODERS = [
        {encoding: :json, media_type: "application/json", encoder: JSONEncoder.new},
        {encoding: :transit_json, media_type: "application/transit+json", encoder: TransitEncoder.new(:json)},
        {encoding: :transit_msgpack, media_type: "application/transit+msgpack", encoder: TransitEncoder.new(:transit_msgpack)},
        {encoding: :text, media_type: "text/plain", encoder: TextEncoder.new},
      ]

      class ParsingError < StandardError
      end

      def initialize(encoding)
        encoder = encoder_by_encoding(encoding)

        if encoder.nil?
          raise ArgumentError.new("Coulnd't find encoder for encoding: '#{encoding}'")
        end

        @_request_encoder = encoder
      end

      def enter(ctx)
        req = ctx.fetch(:req)

        body = req[:body]
        headers = req.fetch(:headers)

        ctx[:req][:body] = @_request_encoder[:encoder].encode(body)
        ctx[:req][:headers]["Accept"] = @_request_encoder[:media_type]
        ctx[:req][:headers]["Content-Type"] = @_request_encoder[:media_type] unless body.nil?

        ctx
      end

      def leave(ctx)
        res = ctx.fetch(:res)
        headers = res.fetch(:headers)
        body = res[:body]

        # Choose encoder by the Content-Type header, if possible.
        # Otherwise, fallback to the same encoder we used to encode the request
        encoder = encoder_by_content_type(headers["Content-Type"]) || @_request_encoder

        begin
          ctx[:res][:body] = encoder[:encoder].decode(body)
        rescue StandardError => e
          raise ParsingError.new("Parsing error, msg: '#{e.message}', body: '#{body}'")
        end
        ctx
      end

      private

      def encoder_by_encoding(encoding)
        ENCODERS.find { |e| e[:encoding] == encoding }
      end

      def encoder_by_content_type(content_type)
        media_type = HTTPUtils.parse_content_type(content_type)

        ENCODERS.find { |e| e[:media_type] == media_type }
      end
    end
  end
end

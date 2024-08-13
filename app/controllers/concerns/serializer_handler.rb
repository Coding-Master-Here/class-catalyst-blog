# frozen_string_literal: true

# Serializer Handler
module SerializerHandler
  def serialize(collection, serializer)
    ActiveModelSerializers::SerializableResource.new(collection,
                                                     each_serializer: serializer,
                                                     adapter: :json)
                                                .as_json
  end
end

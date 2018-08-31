module SerializableResource
  def serailie_json(object)
    ActiveModelSerializers::SerializableResource.new(object)
  end
end

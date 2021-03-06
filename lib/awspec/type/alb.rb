module Awspec::Type
  class Alb < ResourceBase
    def resource_via_client
      @resource_via_client ||= find_alb(@display_name)
    end

    def id
      @id = resource_via_client.load_balancer_name if resource_via_client
    end

    STATES = %w(
      active provisioning failed
    )

    STATES.each do |state|
      define_method state + '?' do
        resource_via_client.state.code == state
      end
    end

    def has_security_group?(sg_id)
      sgs = resource_via_client.security_groups
      ret = sgs.find do |sg|
        sg == sg_id
      end
      return true if ret
      sg2 = find_security_group(sg_id)
      return true if sg2.tag_name == sg_id || sg2.group_name == sg_id
      false
    end
  end
end

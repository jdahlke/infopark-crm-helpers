# This fixes an issue with someone (tm) trying to call
# FakeWeb::StubSocket#read_timeout=, which does not exist.
module FakeWeb
  class StubSocket
    def read_timeout=(_)
    end
  end
end

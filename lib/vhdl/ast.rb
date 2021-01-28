class String
  def accept(visitor,arg=nil)
    self
  end
end

module VHDL

  class AstNode
    def accept(visitor, arg=nil)
       name = self.class.name.split(/::/).last
       visitor.send("visit#{name}".to_sym, self ,arg) # Metaprograming !
    end

    def str
      ppr=PrettyPrinter.new
      self.accept(ppr)
    end
  end

  class DesignUnit < AstNode
    attr_accessor :elements
    def initialize elements=[]
      @elements=elements
    end

    def <<(e)
      @elements << e
      @elements.flatten!
    end
  end

  class Entity < AstNode
    attr_accessor :generics,:name,:ports
    def initialize generics=[],name=nil,ports=[]
      @generics,@name,@ports=generics,name,ports
    end
  end

  class Generic < AstNode
    attr_accessor :name,:type,:init
    def initialize name=nil,type=nil,init=nil
      @name,@type,@init=name,type,init
    end
  end

  class Port < AstNode
    attr_accessor :name,:direction,:type
    def initialize name=nil,direction=nil,type=nil
      @name,@direction,@type=name,direction,type
    end
  end

  class Architecture < AstNode
    attr_accessor :name,:entity_name,:decls,:body
    def initialize name=nil,entity_name=nil,decls=[],body=nil
      @name,@entity_name,@decls,@body=name,entity_name,decls,body
    end

    def <<(e)
      @decls << e
      @decls.flatten!
    end
  end

  class Signal < AstNode
    attr_accessor :name,:type,:init
    def initialize name=nil,type=nil,init=nil
      @name,@type,@init=name,type,init
    end
  end

  class Constant < AstNode
    attr_accessor :name,:type,:expr
    def initialize name=nil,type=nil,expr=nil
      @name,@type,@expr=name,type,expr
    end
  end

  class Body < AstNode
    attr_accessor :stmts
    def initialize stmts=[]
      @stmts=stmts
    end

    def <<(e)
      @stmts << e
      @stmts.flatten!
    end
  end

  class SigAssign < AstNode
    attr_accessor :lhs,:rhs
    def initialize lhs=nil,rhs=nil
      @lhs,@rhs=lhs,rhs
    end
  end

  class Instanciation < AstNode
    attr_accessor :iname,:ename,:aname,:genericmap,:portmap
    def initialize iname=nil,ename=nil,aname=nil,genericmap=nil,portmap=nil
      @iname,@ename,@aname,@genericmap,@portmap=iname,ename,aname,genericmap,portmap
    end
  end
end # VHDL

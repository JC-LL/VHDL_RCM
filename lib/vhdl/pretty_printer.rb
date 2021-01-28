require_relative "visitor_vhdl_rkgen"
require_relative "code"

module VHDL

  class PrettyPrinter < Visitor
    def print ast
      code=Code.new
      code << "--generated automatically using VHDL_RCM"
      code << ast.accept(self)
      puts code.finalize
    end

    def visitDesignUnit(designunit_,args=nil)
      code=Code.new
      designunit_.elements.each{|element_| code << element_.accept(self,args)}
      code
    end

    def visitEntity(entity_,args=nil)
      code=Code.new
      name=entity_.name.accept(self,args)
      code << "entity #{name} is"
      code.indent=2
      code << "generic("
      code.indent=4
      entity_.generics.each{|generic_| code << generic_.accept(self,args)}
      code.indent=2
      code << ");"
      code << "port("
      code.indent=4
      entity_.ports.each{|port_| code << port_.accept(self,args)}
      code.indent=2
      code << ");"
      code.indent=0
      code << "end entity #{name};"
      code
    end

    def visitGeneric(generic_,args=nil)
      name=generic_.name.accept(self,args)
      type=generic_.type.accept(self,args)
      init=generic_.init.accept(self,args)
      "#{name} : #{type} := #{init};"
    end

    def visitPort(port_,args=nil)
      name=port_.name.accept(self,args)
      dir =port_.direction.accept(self,args)
      type=port_.type.accept(self,args)
      "#{name} : #{dir} #{type};"
    end

    def visitArchitecture(architecture_,args=nil)
      code=Code.new
      aname=architecture_.name.accept(self,args)
      ename=architecture_.entity_name.accept(self,args)
      code.newline
      code << "architecture #{aname} of #{ename} is"
      code.indent=2
      architecture_.decls.each{|decl_| code << decl_.accept(self,args)}
      code.indent=0
      code << "begin"
      code.indent=2
      code << architecture_.body.accept(self,args)
      code.indent=0
      code << "end #{aname};"
      code
    end

    def visitSignal(signal_,args=nil)
      name=signal_.name.accept(self,args)
      type=signal_.type.accept(self,args)
      init=signal_.init.accept(self,args)
      "signal #{name} : #{type} := #{init};"
    end

    def visitConstant(constant_,args=nil)
      name=constant_.name.accept(self,args)
      type=constant_.type.accept(self,args)
      init=constant_.expr.accept(self,args)
      "constant #{name.upcase} : #{type} := #{init};"
    end

    def visitBody(body_,args=nil)
      code=Code.new
      body_.stmts.each{|stmt_| code << stmt_.accept(self,args)}
      code
    end

    def visitSigAssign(sigassign_,args=nil)
      lhs=sigassign_.lhs.accept(self,args)
      rhs=sigassign_.rhs.accept(self,args)
      "#{lhs} <= #{rhs};"
    end

    def visitInstanciation(instanciation_,args=nil)
      instanciation_.iname.accept(self,args)
      instanciation_.lname.accept(self,args)
      instanciation_.ename.accept(self,args)
      instanciation_.aname.accept(self,args)
      instanciation_.genericMap.accept(self,args)
      instanciation_.portMap.accept(self,args)

    end
  end # visitor
end # VHDL

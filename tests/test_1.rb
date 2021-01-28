require_relative "../lib/vhdl"

include VHDL

entity=Entity.new(generics=[],name="test",ports=[])
entity.generics << Generic.new("N","integer","42")
entity.ports << (1..3).map{|i| Port.new("i_#{i}","in","std_logic")}
entity.ports << (1..3).map{|i| Port.new("o_#{i}","out","std_logic")}
entity.ports.flatten!

architecture=Architecture.new("rtl","test",decls=[])
decls << VHDL::Signal.new("a","unsigned(31 downto 0)", "to_unsigned(0,32)")
architecture.body=Body.new(stmts=[])
stmts << SigAssign.new("a","b")

du=DesignUnit.new
du << entity
du << architecture

PrettyPrinter.new.print(du)

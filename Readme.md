Easily distribute any code in multiple servers.

Install
=======

```Bash
gem install madrox-cluster
```

Usage
=====

###Starting a Server

```Bash
madrox 127.0.0.1 5000
```

###Adding servers

```Ruby
#configure a server
Madrox.config(["server_1:5000", "server_1:5001", "server_2:5000", "server_2:5001"])
```

###Executing a block


```Ruby
#Distribute processing through the servers
result = Madrox.collect([35, 30, 35, 37, 25, 30]) do |x|
  def fib(n)
    n<=1 ? n : fib(n-2) + fib(n-1)
  end
  fib(x)
end
```

###Register code in advance

```Ruby
CalcClass = Proc.new { |x|
  class Calc
    def fib(n)
      n<=1 ? n : fib(n-2) + fib(n-1)
    end
  end

  Calc
}

#stores this class in all servers
Madrox.register("Calc", CalcClass)

result = Madrox.collect([35, 30, 35, 37, 25, 30]) do |x|
  Calc.new.fib(x)
end
```

Disclaimer
=====

This gem is provided as is - therefore, the creators and contributors of this gem are not responsible for any damages that may result from its usage. Although Authentication and SSL may be added later, Madrox is experimental and is meant to be used in private trusted local networks. Use at your own risk.

Madrox is an experiment. For a more solid solution please check [dRuby](http://www.ruby-doc.org/stdlib-1.9.3/libdoc/drb/rdoc/DRb.html)

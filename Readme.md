Madrox [![Code Climate](https://codeclimate.com/github/iurimatias/madrox-cluster.png)](https://codeclimate.com/github/iurimatias/madrox-cluster)
======

Easily distribute any code across multiple servers

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
#Distribute processing across the servers
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

Benchmarks
=====

```bash

Benchmarks for 10 x fibbonaci(40):
┌──────────────────────┬───────────────────────────────┬─────────────────────┐
│                      │ Machines Used                 │ Time Taken          │
├──────────────────────────────────────────────────────┼─────────────────────┤
│ Normal Ruby Process  │ 1 mac 4 cores                 │ 3 minutes 40 secs   │
├──────────────────────┼───────────────────────────────┼─────────────────────┤
│ 4 Madrox Servers     │ 1 mac 4 cores                 │ 1 minute  36 secs   │
├──────────────────────┼───────────────────────────────┼─────────────────────┤
│ 6 Madrox Servers     │ 1 mac 4 cores + 1 mac 2 cores │ 1 minute   5 secs   │
└──────────────────────┴───────────────────────────────┴─────────────────────┘
```

Disclaimer
=====

This gem is provided as is - therefore, the creators and contributors of this gem are not responsible for any damages that may result from its usage. Although Authentication and SSL may be added later, Madrox is experimental and is meant to be used in private trusted local networks. Use at your own risk.

Madrox is an experiment. For a more solid solution please check [dRuby](http://www.ruby-doc.org/stdlib-1.9.3/libdoc/drb/rdoc/DRb.html)

[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/iurimatias/madrox-cluster/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

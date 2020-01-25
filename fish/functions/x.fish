function x --description "Extract file"
  set --local ext (echo $argv[1] | awk -F. '{print $NF}')
  switch $ext
    case tar
      tar xf $argv[1]
    case gz
      if test (echo $argv[1] | awk -F. '{print $(NF-1)}') = tar
        tar xzf $argv[1]
      else
        gunzip $argv[1]
      end
    case xz
      if test (echo $argv[1] | awk -F. '{print $(NF-1)}') = tar
        tar xJf $argv[1]
      else
        unxz $argv[1]
      end
    case bz2
      if test (echo $argv[1] | awk -F. '{print $(NF-1)}') = tar
        tar xjf $argv[1]
      else
        bunzip2 $argv[1]
      end
    case tgz
      tar xzf $argv[1]
    case rar
      unrar x $argv[1]
    case zip
      unzip $argv[1]
    case '*'
      echo "unknown extension"
  end
end

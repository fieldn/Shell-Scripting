for i in {0..10}
    do
        echo "Password: "$(cat password$i.txt)
        ./pwcheck.sh "password$i.txt"
        echo
done

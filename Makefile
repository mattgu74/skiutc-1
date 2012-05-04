#SkiUTC
# Under AGPL license
# @author Matthieu Guffroy

#OPA_bin=~/opa_bin/bin/
OPA=opa
OPT=--opx-dir _build_o --parser js-like --database mongo
FILES=$(shell find src -name '*.opa')
EXE=main.exe

all: facebook.opp $(FILES)
	$(OPA_bin)$(OPA) $^ -o $(EXE) $(OPT)

run:
	./$(EXE) --base-url skiutc --port 10080 --pidfile skiutc.pid --db-force-upgrade &

facebook.opp: src/helper/facebook.js
	$(OPA_bin)opa-plugin-builder $^ -o $@

stop:
	kill $(shell cat skiutc.pid)
	sleep 4

reload: all stop run

clean:
	rm -rf *.opx *.opx.broken *.opp
	rm -f *.exe
	rm -rf doc
	rm -rf _build _tracks
	rm -f *.log
	rm -f *.apix
	rm -f src/*.api
	rm -rf *.opp
	rm -f src/*.api-txt

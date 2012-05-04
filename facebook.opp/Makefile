# ============================== #
# ==== BSL-CUSTOMLIB-MAKER ===== #
# ========== MLstate =========== #

# Generated Makefile by /usr/lib/opa/bin/opa-plugin-builder-bin version 1591-(42bedc8) : 30/04/12 - 17:51:37
# from command : /usr/lib/opa/bin/opa-plugin-builder-bin facebook.js -o facebook

OPP=facebook

SUFFIX=MLRuntime
INCLUDE=-I $(MLSTATELIBS)/lib/opa/static 

OCAML_FLAGS=
OCAMLOPT_FLAGS=

TARGETS_CMI=$(patsubst %, $(OPP)%.cmi, $(SUFFIX))
TARGETS_CMX=$(patsubst %, $(OPP)%.cmx, $(SUFFIX))

all: $(TARGETS_CMI) $(TARGETS_CMX)

OCAMLOPT ?= ocamlopt.opt
TRX ?= $(MLSTATELIBS)/bin/trx

%.ml : %.trx
	$(TRX) $^ > $@

%.cmx : %.ml %.cmi
	$(OCAMLOPT) $(OCAML_FLAGS) $(OCAMLOPT_FLAGS) $(INCLUDE) -c $<

%.cmi : %.mli
	$(OCAMLOPT) $(OCAML_FLAGS) $(OCAMLOPT_FLAGS) $(INCLUDE) -c $<

%.cmi : %.ml
	$(OCAMLOPT) $(OCAML_FLAGS) $(OCAMLOPT_FLAGS) $(INCLUDE) -c $<

clean :
	rm -f *.cmx *.cmo *.o *.cmi

wclean :
	@echo "Would remove *.cmx *.cmo *.o *.cmi"

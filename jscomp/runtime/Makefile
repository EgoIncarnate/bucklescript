include ../Makefile.shared

COMPILER=../bin/bsc.exe

OTHERS= caml_array caml_string caml_bytes\
	caml_obj caml_int64 \
	caml_exceptions	caml_utils caml_sys caml_io\
	caml_float caml_lexer caml_parser caml_primitive\
	caml_format caml_md5 caml_queue caml_hash caml_weak\
	caml_backtrace caml_int32 caml_gc typed_array \
	js_primitive caml_basic caml_oo curry caml_oo_curry caml_module \
	bs_string  js_float bs_obj js_nativeint js_int js_null js_undefined

SOURCE_LIST= $(OTHERS) caml_builtin_exceptions  block  js js_unsafe

caml_oo.cmj : caml_array.cmj
js_unsafe.cmj:js_unsafe.cmi js.cmj js.cmi
js_unsafe.cmi js.cmj: js.cmi
caml_format.cmj caml_io.cmj caml_oo_curry.cmj: curry.cmj
caml_weak.cmj caml_module.cmj: caml_obj.cmj js_primitive.cmj
caml_builtin_exceptions.cmj: caml_builtin_exceptions.cmi js_unsafe.cmi
block.cmj: block.cmi
caml_int64.cmj : caml_obj.cmj
# or we can do a post-processing to add missing cmj dependency manually

$(addsuffix .cmj, $(OTHERS)): caml_builtin_exceptions.cmj  block.cmj js.cmj js_unsafe.cmj
## since we use ppx
$(addsuffix .cmi, $(OTHERS)): js.cmi js_unsafe.cmj js_unsafe.cmi js.cmj


RUNTIME := $(addsuffix .cmj, $(SOURCE_LIST)) $(addsuffix .cmi, $(SOURCE_LIST))

BS_COMMON_FLAGS= -no-alias-deps -bs-no-version-header -bs-diagnose -bs-no-check-div-by-zero -bs-cross-module-opt -bs-package-name bs-platform

ifdef BS_RELEASE_BUILD
BS_FLAGS=  $(BS_COMMON_FLAGS) -bs-package-output commonjs:lib/js -bs-package-output goog:lib/goog -bs-package-output amdjs:lib/amdjs -bs-package-output es6:lib/es6
else
BS_FLAGS=  $(BS_COMMON_FLAGS) -bs-package-output commonjs:lib/js
endif

COMPFLAGS += $(BS_FLAGS) -I ../stdlib -nostdlib -nopervasives -open Pervasives -unsafe -w -40-49 -bin-annot


$(RUNTIME): $(COMPILER)

all: $(RUNTIME)

clean::
	rm -f *.cm*
	rm -f *~
	rm -f  *.annot
	rm -f *.rawlambda *.lam *.lambda *.map

# Note since Makefile rules does not support multiple output
# To avoid bugs, we should always have a .mli file for each .ml when using suffix rules
# otherwise Make can not know how to generate .cmi when only .ml exists
.mli.cmi:
	$(COMPILER) $(INCLUDES) $(COMPFLAGS)  -c $<
.ml.cmj:
	$(COMPILER) $(INCLUDES) $(COMPFLAGS)  -c $<

-include .depend

ML_SOURCES=$(addsuffix .ml, $(OTHERS))
MLI_SOURCES=$(addsuffix .mli, $(OTHERS))

depend:
	$(CAMLDEP) -native $(INCLUDES) $(ML_SOURCES) $(MLI_SOURCES) | sed -e 's/\.cmx/.cmj/g' >.depend

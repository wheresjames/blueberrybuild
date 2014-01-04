
# What to build
BUILDDIRS := mk-libs

.PHONY $(BUILDDIRS) :
	$(MAKE) $(MAKECMDGOALS) -C $@ 

.PHONY all: $(BUILDDIRS)
.PHONY rebuild: $(BUILDDIRS)
.PHONY clean: $(BUILDDIRS)

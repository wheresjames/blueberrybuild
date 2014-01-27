
default_target: all

# What to build
BUILDDIRS := v1

.PHONY $(BUILDDIRS) :
	$(MAKE) $(MAKECMDGOALS) -C $@ 

.PHONY all: $(BUILDDIRS)
.PHONY rebuild: $(BUILDDIRS)
.PHONY clean: $(BUILDDIRS)


default_target: all

# What to build
BUILDDIRS := mk-libs mk-apps

.PHONY $(BUILDDIRS) :
	$(MAKE) $(MAKECMDGOALS) -C $@ 

.PHONY all: $(BUILDDIRS)
.PHONY rebuild: $(BUILDDIRS)
.PHONY clean: $(BUILDDIRS)


# Filters out strings containing specified sub string
# $(call filter-out-str [sub string to find] [list to filter]
filter-out-str = $(foreach v,$(2),$(if $(findstring $(1),$(v)),,$(v)))

define \n


endef

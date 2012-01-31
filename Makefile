# All generated files go into the BUILD directory
BUILD		 = build

MODNAME		 = fakenode

# DTrace provider name
PROVIDER	 = node

# Uncomment for 64-bit build
#CARCHFLAGS	+= -m64
#LDFLAGS	+= -m64
CC		 = gcc
CFLAGS		+= -Wall -Werror -fPIC $(CARCHFLAGS)
CPPFLAGS	+= -I$(BUILD)

# Source layout
CSRCS		 = src/$(MODNAME).c
CSSRCS		 = $(CSRCS) src/$(PROVIDER)_provider_impl.h
CSSRCS		+= src/$(PROVIDER)_provider.d src/$(PROVIDER).d
EXEFILE		 = $(BUILD)/$(MODNAME)
OBJFILES	 = $(CSRCS:src/%.c=$(BUILD)/%.o)
EXTRAOBJFILES	 = $(BUILD)/$(PROVIDER)_provider.o

all: $(EXEFILE)

clean:
	-rm -rf $(BUILD)

$(BUILD):
	mkdir -p $(BUILD)

$(EXEFILE): $(OBJFILES) $(EXTRAOBJFILES)
	$(CC) $(LDFLAGS) -o $@ $^

#
# Object files are generated either by building the corresponding source file
# or by running "dtrace -G" on the provider file using the other object files.
#
$(BUILD)/%.o: src/%.c | $(BUILD)
	$(CC) $(CFLAGS) $(CPPFLAGS) -c -o $@ $<

$(BUILD)/$(MODNAME).o: $(BUILD)/$(PROVIDER)_provider.h

$(BUILD)/$(PROVIDER)_provider.o: src/$(PROVIDER)_provider.d $(OBJFILES) | $(BUILD)
	dtrace -xnolibs -G -o $@ -s $< $(OBJFILES)

#
# The provider header file is generated directly by "dtrace -h".
#
$(BUILD)/$(PROVIDER)_provider.h: src/$(PROVIDER)_provider.d | $(BUILD)
	dtrace -xnolibs -h -o $@ -s $<

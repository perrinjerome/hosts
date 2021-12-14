CFLAGS+=-Wall -s -g

ifeq ($(PREFIX),)
    PREFIX := /usr/local
endif

all: test userhosts.so

userhosts.so: userhosts.c
	$(CC) $(CFLAGS) $(CPPFLAGS) -D_GNU_SOURCE -fPIC -shared userhosts.c -o userhosts.so -ldl

test_getaddrinfo: test_getaddrinfo.c
	$(CC) $(CFLAGS) $(CPPFLAGS) -g test_getaddrinfo.c -o test_getaddrinfo

.hosts: test_hosts
	cp test_hosts .hosts

test: test_getaddrinfo userhosts.so .hosts
	LD_PRELOAD=${PWD}/userhosts.so HOSTS=test_hosts ./test_getaddrinfo

install: userhosts.so
	install -d $(DESTDIR)$(PREFIX)/lib/
	install -m 644 userhosts.so $(DESTDIR)$(PREFIX)/lib/

clean:
	rm -f userhosts.so test_getaddrinfo .hosts

From: Xiong Zhou <xzhou-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [LTP issues] MAP_LOCKED MS_INVALIDATE, dio rw odd count on DAX
Date: Tue, 24 Jan 2017 13:24:05 +0800
Message-ID: <20170124052405.o7oz6xr3bwwmjxvo@XZHOUW.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="j2au3orvnrua6zfh"
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-nvdimm@lists.01.org


--j2au3orvnrua6zfh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

LTP tests on DAX show 2 issues.

msync03 and diotest4, both xfs and ext4,

non-DAX  pass
DAX      fail

1, MAP_LOCKED && msync with MS_INVALIDATE, which should fail.

Flag checking code in msync looks ok but missing _LOCK vma falgs
for DAX mapped vma ? i guess DAX now does not support that ?
Tracking by LTP testcase "msync03"

2. O_DIRECT rw odd counts on DAX

read/write 1 byte on file opened with O_DIRECT, EINVAL is
expected but Success.
I'm not sure whether this is an issue, please enlighten :)
Tracking by LTP testcase "dio04 diotest4".

BTW, I am testing DAX with xfstests, LTP and other fs test
cases. If the same case fails on DAX but pass on non-DAX,
i'll look into and report if it is a real issue to me. I've
been doing this for a while, recently, I started looking at
cases that fail on non-DAX and pass on DAX inspired by
Darrick in another thread.

For now, test result looks good. Except the above 2 issues
which I've seen for a while and not sure they are really
issues, xfstests check -g auto has no major regressions
between DAX and non-DAX. generic/403 is a new case and its
failures are under investigation, i'll report if it is.

Thanks,
Xiong

--j2au3orvnrua6zfh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="msync03.c"

/*
 * Copyright (c) International Business Machines  Corp., 2001
 * Copyright (c) 2014 Fujitsu Ltd.
 */

#include <stdio.h>
#include <errno.h>
#include <unistd.h>
#include <fcntl.h>
#include <string.h>
#include <signal.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/mman.h>
#include <sys/mount.h>
#include <pwd.h>
#include <sys/resource.h>

#define BUF_SIZE	256

static void setup(void);
static void cleanup(void);
static int fd;
static char *addr1;
static size_t page_sz;
int main(int ac, char **av)
{
	int ret, lc;
	char write_buf[BUF_SIZE];

	if (ac != 2) {
		fprintf(stderr, "%s <test file>\n", av[0]);
		return 1;
	}

	page_sz = (size_t)sysconf(_SC_PAGESIZE);

	fd = open(av[1], O_RDWR | O_CREAT, 0666);

	memset(write_buf, 'a', BUF_SIZE);
	ret = write(fd, write_buf, BUF_SIZE);
	if (ret == -1) {
		fprintf(stderr, "write failed\n");
		return 1;
	}

	addr1 = mmap(0, page_sz, PROT_READ | PROT_WRITE,
			  MAP_SHARED | MAP_LOCKED, fd, 0);
	if (addr1 == MAP_FAILED) {
		fprintf(stderr, "mmap failed unexpectedly\n");
		return 1;
	}

	ret = msync(addr1, page_sz, MS_INVALIDATE);
	if (ret != -1) {
		fprintf(stderr, "msync succeeded unexpectedly, test fail\n");
		return 1;
	}

	if (errno == EBUSY) {
		fprintf(stderr, "msync failed as expected, test pass\n");
	} else {
		fprintf(stderr,
			 "msync failed unexpectedly; expected: "
			 "%d - %s, test fail\n", EBUSY, strerror(EBUSY));
	}

	if (addr1 && munmap(addr1, page_sz) < 0)
		fprintf(stderr, "munmap() failed\n");

	if (fd > 0 && close(fd) < 0)
		fprintf(stderr, "close() failed\n");

	return 0;
}

--j2au3orvnrua6zfh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="diotest4.c"

/*
 *
 *   Copyright (c) International Business Machines  Corp., 2002
 *
 * NAME
 *      diotest4.c
 *
 * DESCRIPTION
 *	The program generates error conditions and verifies the error
 *	code generated with the expected error value. The program also
 *	tests some of the boundary condtions. The size of test file created
 *	is filesize_in_blocks * 4k.
 *	Test blocks:
 *	[3] Odd count of read and write
 *
*/

#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <signal.h>
#include <sys/file.h>
#include <fcntl.h>
#include <sys/types.h>
#include <sys/mman.h>
#include <sys/syscall.h>
#include <errno.h>
#include <string.h>
#include <sys/shm.h>

#define BUFSIZE 	4096
#define TRUE	1

/*
 * runtest_f: Do read, writes. Verify the error value obtained by
 *	running read or write with the expected error value (errnum).
*/
int
runtest_f(int fd, char *buf, int offset, int count, int errnum, int testnum,
	  char *msg)
{
	int ret;
	int l_fail = 0;

	if (lseek(fd, offset, SEEK_SET) < 0) {
		if (errno != errnum) {
			fprintf(stderr, "lseek before read failed: %s\n",
				 strerror(errno));
			l_fail = TRUE;
		}
	} else {
		errno = 0;
		ret = read(fd, buf, count);
		if (ret >= 0 || errno != errnum) {
			fprintf(stderr, "read allows %s. returns %d: %s\n",
				 msg, ret, strerror(errno));
			l_fail = TRUE;
		}
	}
	if (lseek(fd, offset, SEEK_SET) < 0) {
		if (errno != errnum) {
			fprintf(stderr, "lseek before write failed: %s\n",
				 strerror(errno));
			l_fail = TRUE;
		}
	} else {
		errno = 0;
		ret = write(fd, buf, count);
		if (ret >= 0 || errno != errnum) {
			fprintf(stderr, "write allows %s.returns %d: %s\n",
				 msg, ret, strerror(errno));
			l_fail = TRUE;
		}
	}
	return (l_fail);
}

int main(int argc, char *argv[])
{
	int bufsize = BUFSIZE;
	int count, ret;
	int offset;
	int fd, newfd;
	int failed = 0;
	char *buf0;

	if (argc != 2) {
		fprintf(stderr, "%s <test file>\n", argv[0]);
		return 1;
	}

	/* Open file and fill, allocate for buffer */
	if ((fd = open(argv[1], O_DIRECT | O_RDWR | O_CREAT, 0666)) < 0) {
		fprintf(stderr, "open failed for %s: %s\n",
			 argv[1], strerror(errno));
		return 1;
	}
	if ((buf0 = valloc(BUFSIZE)) == NULL) {
		fprintf(stderr, "valloc() buf0 failed: %s\n",
			 strerror(errno));
		return 1;
	}
	memset(buf0, 0, BUFSIZE);
	if (write(fd, buf0, BUFSIZE) < 0) {
		fprintf(stderr, "write failed for %s: %s\n",
			 argv[1], strerror(errno));
		return 1;
	}
	close(fd);
	if ((fd = open(argv[1], O_DIRECT | O_RDWR)) < 0) {
		fprintf(stderr, "open failed for %s: %s\n",
			 argv[1], strerror(errno));
		return 1;
	}

	/* Test-3: Odd count of read and write */
	offset = 0;
	count = 1;
	lseek(fd, 0, SEEK_SET);
	if (write(fd, buf0, BUFSIZE) == -1) {
		fprintf(stderr, "can't write to file %d", ret);
	}
	ret = runtest_f(fd, buf0, offset, count, EINVAL, 3, "odd count");
	if (ret == TRUE)
		fprintf(stderr, "diotest4 fail\n");
	else
		fprintf(stderr, "diotest4 pass\n");

	close(fd);
	return 0;
}

--j2au3orvnrua6zfh
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

--j2au3orvnrua6zfh--

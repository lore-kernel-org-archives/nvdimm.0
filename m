From: Xiong Zhou <xzhou-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: read failure (was Re: mmap dio write failure)
Date: Wed, 8 Feb 2017 11:51:05 +0800
Message-ID: <20170208035105.lvewz5ce7xbu5zud@XZHOUW.usersys.redhat.com>
References: <20170120044007.kwevjo7nawwolagy@XZHOUW.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="5ivbbo24xtyftq2r"
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170120044007.kwevjo7nawwolagy-E9dkjZ7ERC1QcClZ3XN9yxcY2uh10dtjAL8bYrjMMd8@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org
Cc: eguan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-nvdimm@lists.01.org


--5ivbbo24xtyftq2r
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 20, 2017 at 12:40:07PM +0800, Xiong Zhou wrote:
> Hi,
> 
> At first, I am not sure whether this is an issue.
> 
> mmap a file in a DAX mountpoint, open another file
> in a non-DAX mountpoint with O_DIRECT, write the
> mapped area to the other file.
> 
> This write Success on pmem ramdisk(memmap=2G!20G like)
> This write Fail(Bad address) on nvdimm pmem devices.
> This write Fail(Bad address) on brd based ramdisk.
> 
> If we skip the O_DIRECT flag, all tests pass.
> 
> If we write from DAX to DAX, all tests pass.
> If we write from non-DAX to DAX, all tests pass.
> 
snip..

To falloc instead of pwrite while initiating test files,
( Thanks Ross! :) 
the write call returned success, however the following
read back to mmaped area FAILED the same way:

return (Bad address) on raw-mode nvdimm device;
return (Success)     on memory-mode nvdimm device;
return (Bad address) on brd based ramdisk.

Also, this only happends with O_DIRECT flag on.

This smells like an issue to me, still looking into why
read can't get that page..

Thanks,
Xiong

--5ivbbo24xtyftq2r
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="t_mmap_dio.c"

/*
 * This programme was originally written by
 *     Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 *
 * Copyright (C) 2016, Red Hat, Inc.
 */
#define _GNU_SOURCE 1
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <libaio.h>
#include <errno.h>
#include <sys/time.h>

void usage(char *prog)
{
	fprintf(stderr,
		"usage: %s <src file> <dest file> <size> <msg>\n",
		prog);
	exit(1);
}

void err_exit(char *op, unsigned long len, char *s)
{
	fprintf(stderr, "%s(%s) len %lu %s\n",
		op, strerror(errno), len, s);
	exit(1);
}

int main(int argc, char **argv)
{
	int fd, fd2, ret, dio = 1;
	char *map;
	char *msg;
	char *sfile;
	char *dfile;
	unsigned long len, opt;

	if (argc < 4)
		usage(basename(argv[0]));

	while ((opt = getopt(argc, argv, "b")) != -1)
		dio = 0;

	sfile = argv[optind];
	dfile = argv[optind + 1];
	msg = argv[optind + 3];
	len = strtoul(argv[optind + 2], NULL, 10);
	if (errno == ERANGE)
		err_exit("strtoul", 0, msg);

	/* Open source file and mmap*/
	fd = open(sfile, O_RDWR, 0644);
	if (fd < 0)
		err_exit("open src", len, msg);

	map = (char *)mmap(NULL, len,
		PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
	if (map == MAP_FAILED)
		err_exit("mmap", len, msg);

	if (dio == 1) {
		/* Open dest file with O_DIRECT */
		fd2 = open(dfile, O_RDWR|O_DIRECT, 0644);
		if (fd2 < 0)
			err_exit("open dest", len, msg);
	} else {
		/* Open dest file without O_DIRECT */
		fd2 = open(dfile, O_RDWR, 0644);
		if (fd2 < 0)
			err_exit("open dest", len, msg);
	}

	/* First, test storing to dest file from source mapping */
	ret = write(fd2, map, len);
	if (ret != len)
		err_exit("write", len, msg);

	ret = fsync(fd2);
	if (ret != 0)
		err_exit("fsync", len, msg);

	ret = (int)lseek(fd2, 0, SEEK_SET);
	if (ret == -1)
		err_exit("lseek", len, msg);

	/* Next, test reading from dest file into source mapping */
	ret = read(fd2, map, len);
	if (ret != len)
		err_exit("read", len, msg);
	ret = msync(map, len, MS_SYNC);
	if (ret < 0)
		err_exit("msync", len, msg);

	ret = munmap(map, len);
	if (ret < 0)
		err_exit("munmap", len, msg);

	ret = close(fd);
	if (ret < 0)
		err_exit("clsoe fd", len, msg);

	ret = close(fd2);
	if (ret < 0)
		err_exit("close fd2", len, msg);

	exit(0);
}

--5ivbbo24xtyftq2r
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

--5ivbbo24xtyftq2r--

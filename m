From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: read failure (was Re: mmap dio write failure)
Date: Wed, 22 Feb 2017 15:05:29 -0800
Message-ID: <CAPcyv4gKtLp07ta6PmWKrFJa9RZOPhShFmBcXiRS2izturw4QQ@mail.gmail.com>
References: <20170120044007.kwevjo7nawwolagy@XZHOUW.usersys.redhat.com>
 <20170208035105.lvewz5ce7xbu5zud@XZHOUW.usersys.redhat.com>
 <CAPcyv4iF2xH=9FHDMqb8OYMFO45GkiEEKf1y73Q7scGQSJniag@mail.gmail.com>
 <20170208044959.rq3ofmsjth2oeu2u@XZHOUW.usersys.redhat.com>
 <CAPcyv4iCz9SqJkoKYr-RWxV4FmqPB1Wfkx_A_jE-S5Unpo-5Pw@mail.gmail.com>
 <20170208065651.ab74cytferq4ha57@XZHOUW.usersys.redhat.com>
 <20170208070907.m6cwwz47hrow5vui@XZHOUW.usersys.redhat.com>
 <20170208072253.erl4esloglvq2zet@XZHOUW.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20170208072253.erl4esloglvq2zet-E9dkjZ7ERC1QcClZ3XN9yxcY2uh10dtjAL8bYrjMMd8@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Xiong Zhou <xzhou-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-nvdimm <linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org>, Eryu Guan <eguan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

On Tue, Feb 7, 2017 at 11:22 PM, Xiong Zhou <xzhou-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Wed, Feb 08, 2017 at 03:09:07PM +0800, Xiong Zhou wrote:
>> On Wed, Feb 08, 2017 at 02:56:51PM +0800, Xiong Zhou wrote:
>> > On Tue, Feb 07, 2017 at 09:05:21PM -0800, Dan Williams wrote:
>> > > On Tue, Feb 7, 2017 at 8:49 PM, Xiong Zhou <xzhou-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>> > > > On Tue, Feb 07, 2017 at 08:10:14PM -0800, Dan Williams wrote:
>> > > >> On Tue, Feb 7, 2017 at 7:51 PM, Xiong Zhou <xzhou-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>> > > >> > On Fri, Jan 20, 2017 at 12:40:07PM +0800, Xiong Zhou wrote:
>> > > >> >> Hi,
>> > > >> >>
>> > > >> >> At first, I am not sure whether this is an issue.
>> > > >> >>
>> > > >> >> mmap a file in a DAX mountpoint, open another file
>> > > >> >> in a non-DAX mountpoint with O_DIRECT, write the
>> > > >> >> mapped area to the other file.
>> > > >> >>
>> > > >> >> This write Success on pmem ramdisk(memmap=2G!20G like)
>> > > >> >> This write Fail(Bad address) on nvdimm pmem devices.
>> > > >> >> This write Fail(Bad address) on brd based ramdisk.
>> > > >> >>
>> > > >> >> If we skip the O_DIRECT flag, all tests pass.
>> > > >> >>
>> > > >> >> If we write from DAX to DAX, all tests pass.
>> > > >> >> If we write from non-DAX to DAX, all tests pass.
>> > > >> >>
>> > > >> > snip..
>> > > >> >
>> > > >> > To falloc instead of pwrite while initiating test files,
>> > > >> > ( Thanks Ross! :)
>> > > >> > the write call returned success, however the following
>> > > >> > read back to mmaped area FAILED the same way:
>> > > >> >
>> > > >> > return (Bad address) on raw-mode nvdimm device;
>> > > >> > return (Success)     on memory-mode nvdimm device;
>> > > >> > return (Bad address) on brd based ramdisk.
>> > > >> >
>> > > >> > Also, this only happends with O_DIRECT flag on.
>> > > >> >
>> > > >> > This smells like an issue to me, still looking into why
>> > > >> > read can't get that page..
>> > > >> >
>> > > >>
>> > > >> Why does it smell like an issue? Any path that calls get_user_pages()
>> > > >
>> > > > Because the write call gets its page and succeeds, while read back fails.
>> > > > __get_user_pages on the same address first pass, then fail.
>> > >
>> > > Ok, I might have misread your description. Can you tell me the exact
>> > > reproduction steps so I can give it a try?
>> >
>> > Reproducer attached.
>> >
>
> Attachment issue..
>
> You need root to run this, assuming your pmem device is /dev/pmem0.
>
> Steps:
>   sh test.sh /dev/pmem0
>
> Thanks for your time!
>
> ----- test.sh --------------------------------------
> #!/bin/bash
> [ -z "$1" ] && { echo "$0 <dev>"; exit 1; }
>
> DEV="$1"
> MNT=/tbdmnt
> cc t_mmap_dio.c
> mkdir -p $MNT
> wipefs -af $DEV > /dev/null
> #mkfs.xfs -fq -d su=2m,sw=1 $DEV && \
> mkfs.xfs -fq $DEV && \
> mount -o dax $DEV $MNT && \
> #xfs_io -f -c "w 0 268435456" $MNT/ts > /dev/null && \
> #xfs_io -f -c "w 0 268435456" /root/td > /dev/null
> xfs_io -f -c "falloc 0 268435456" $MNT/ts > /dev/null && \
> xfs_io -f -c "falloc 0 268435456" /root/td > /dev/null
> if ./a.out $MNT/ts /root/td 16777216 "$DEV" ; then
>         echo dio PASS
> else
>         echo dio FAIL
> fi
>
> rm -f $MNT/ts /root/td
> xfs_io -f -c "falloc 0 268435456" $MNT/ts > /dev/null
> xfs_io -f -c "falloc 0 268435456" /root/td > /dev/null
>
> if ./a.out -b $MNT/ts /root/td 16777216 "$DEV" ; then
>         echo buffered IO PASS
> else
>         echo buffered IO FAIL
> fi
> umount $MNT
>
> --------------------------------------------------------
>
>
> ----- t_mmap_dio.c ----------------------------------
> /*
>  * This programme was originally written by
>  *     Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>  *
>  * Copyright (C) 2016, Red Hat, Inc.
>  */
> #define _GNU_SOURCE 1
> #include <stdio.h>
> #include <stdlib.h>
> #include <string.h>
> #include <unistd.h>
> #include <fcntl.h>
> #include <sys/mman.h>
> #include <libaio.h>
> #include <errno.h>
> #include <sys/time.h>
>
> void usage(char *prog)
> {
>         fprintf(stderr,
>                 "usage: %s <src file> <dest file> <size> <msg>\n",
>                 prog);
>         exit(1);
> }
>
> void err_exit(char *op, unsigned long len, char *s)
> {
>         fprintf(stderr, "%s(%s) len %lu %s\n",
>                 op, strerror(errno), len, s);
>         exit(1);
> }
>
> int main(int argc, char **argv)
> {
>         int fd, fd2, ret, dio = 1;
>         char *map;
>         char *msg;
>         char *sfile;
>         char *dfile;
>         unsigned long len, opt;
>
>         if (argc < 4)
>                 usage(basename(argv[0]));
>
>         while ((opt = getopt(argc, argv, "b")) != -1)
>                 dio = 0;
>
>         sfile = argv[optind];
>         dfile = argv[optind + 1];
>         msg = argv[optind + 3];
>         len = strtoul(argv[optind + 2], NULL, 10);
>         if (errno == ERANGE)
>                 err_exit("strtoul", 0, msg);
>
>         /* Open source file and mmap*/
>         fd = open(sfile, O_RDWR, 0644);
>         if (fd < 0)
>                 err_exit("open src", len, msg);
>
>         map = (char *)mmap(NULL, len,
>                 PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
>         if (map == MAP_FAILED)
>                 err_exit("mmap", len, msg);
>
>         if (dio == 1) {
>                 /* Open dest file with O_DIRECT */
>                 fd2 = open(dfile, O_RDWR|O_DIRECT, 0644);
>                 if (fd2 < 0)
>                         err_exit("open dest", len, msg);
>         } else {
>                 /* Open dest file without O_DIRECT */
>                 fd2 = open(dfile, O_RDWR, 0644);
>                 if (fd2 < 0)
>                         err_exit("open dest", len, msg);
>         }
>
>         /* First, test storing to dest file from source mapping */
>         ret = write(fd2, map, len);
>         if (ret != len)
>                 err_exit("write", len, msg);
>
>         ret = fsync(fd2);
>         if (ret != 0)
>                 err_exit("fsync", len, msg);
>
>         ret = (int)lseek(fd2, 0, SEEK_SET);
>         if (ret == -1)
>                 err_exit("lseek", len, msg);
>
>         /* Next, test reading from dest file into source mapping */
>         ret = read(fd2, map, len);
>         if (ret != len)
>                 err_exit("read", len, msg);
>         ret = msync(map, len, MS_SYNC);
>         if (ret < 0)
>                 err_exit("msync", len, msg);
>
>         ret = munmap(map, len);
>         if (ret < 0)
>                 err_exit("munmap", len, msg);
>
>         ret = close(fd);
>         if (ret < 0)
>                 err_exit("clsoe fd", len, msg);
>
>         ret = close(fd2);
>         if (ret < 0)
>                 err_exit("close fd2", len, msg);
>
>         exit(0);
> }
>
> ----------------------------------------------
> ----- my log -------------

Thanks for the reproducer!

> sh-4.2# uname -r
> 4.10.0-rc7-master-f7d6040+
> sh-4.2# whoami
> root
> sh-4.2# pwd
> /root
> sh-4.2# sh test.sh /dev/pmem0
> dio PASS
> buffered IO PASS
> sh-4.2# sh test.sh /dev/pmem2
> read(Bad address) len 16777216 /dev/pmem2
> dio FAIL
> buffered IO PASS

This is expected. In the raw case we can't do the direct-I/O access to
read() into the buffer since there's no page. The reason the write()
from the buffer succeeds is because the extent is unwritten, so the
filesystem uses the zero page.

This is why the:

xfs_io -f -c 'w 0 268435456' /tbdmnt/ts

...setup fails at the write(), while the:

xfs_io -f -c 'falloc 0 268435456' /tbdmnt/ts

...setup fails later at the read() when the test switches from hitting
the zero page to trying to lookup a "dax" page.

> sh-4.2# modprobe brd rd_size=$((1*1024*1024))
> sh-4.2# sh test.sh /dev/ram0
> read(Bad address) len 16777216 /dev/ram0
> dio FAIL

This fails because dax on /dev/ramX does not support direct-I/O. The
write() works for the same "zero-page" reason above, but the read()
fails because the pte entry for the mapping is marked pte_special()
and we don't have a ->find_special_page() in the vm_ops to go from pte
back to the page that the brd driver is using.  I don't think this is
a problem worth solving since brd is more of a test vehicle than a
production driver.

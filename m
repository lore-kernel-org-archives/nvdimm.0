Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ipmail03.adl2.internode.on.net (ipmail03.adl2.internode.on.net
 [150.101.137.141])
 by ml01.01.org (Postfix) with ESMTP id 658E92205B92C
 for <linux-nvdimm@lists.01.org>; Fri, 12 Jan 2018 13:14:04 -0800 (PST)
Date: Sat, 13 Jan 2018 08:19:15 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: DAX 2MB mappings for XFS
Message-ID: <20180112211915.GF27323@dastard>
References: <1515788779.16384.29.camel@hpe.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1515788779.16384.29.camel@hpe.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: "Kani, Toshi" <toshi.kani@hpe.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jan 12, 2018 at 07:40:25PM +0000, Kani, Toshi wrote:
> Hello,
> 
> I noticed that DAX 2MB mmap no longer works on XFS.  I used the
> following steps on a 4.15-rc7 kernel.  Am I missing something, or is
> there a problem in XFS?
> 
> # mkfs.xfs -f -d su=2m,sw=1 /dev/pmem0
> # mount -o dax /dev/pmem0 /mnt/pmem0
> # xfs_io -c "extsize 2m" /mnt/pmem0
> 
> fio with libpmem engine (which uses mmap) is slow since it gets
> serialized by 4KB page faults.
> 
> # numactl --cpunodebind=0 --membind=0 fio --filename=/mnt/pmem0/testfile 
> --rw=read --ioengine=libpmem --iodepth=1 --numjobs=16 --runtime=60 --
> group_reporting --name=perf_test --thread=1 --size=6g --bs=128k --
> direct=1
>   :
> Run status group 0 (all jobs):
>    READ: bw=4357MiB/s (4569MB/s), 4357MiB/s-4357MiB/s (4569MB/s-
> 4569MB/s), io=96.0GiB (103GB), run=22560-22560msec
> 
> Resulted file blocks in "testfile" are not aligned by 2MB.
> 
> # filefrag -v /mnt/pmem0/testfile
> Filesystem type is: 58465342
> File size of testfile is 6442450944 (1572864 blocks of 4096 bytes)
>  ext:     logical_offset:        physical_offset: length:   expected:
> flags:
>    0:        0..  261111:        520..    261631: 261112:
>    1:   261112..  261348:         12..       248:    237:     261632:
>    2:   261349..  522705:     261644..    523000: 261357:        249:
>    3:   522706..  784062:     523276..    784632: 261357:     523001:
>    4:   784063.. 1045419:     784908..   1046264: 261357:     784633:
>    5:  1045420.. 1304216:    1049100..   1307896: 258797:    1046265:
>    6:  1304217.. 1565573:    1308172..   1569528: 261357:    1307897:
>    7:  1565574.. 1572863:    1570304..   1577593:   7290:    1569529: 
> last,eof
> testfile: 8 extents found
> 
> A file created by fallocate also shows that physical offset starts from
> 520, which is not aligned by 2MB. 
> 
> # fallocate --length 1G /mnt/pmem0/data
> # filefrag -v /mnt/pmem0/data
> Filesystem type is: 58465342
> File size of /mnt/pmem0/data is 1073741824 (262144 blocks of 4096 bytes)
>  ext:     logical_offset:        physical_offset: length:   expected:
> flags:
>    0:        0..  260607:        520..    261127:
> 260608:             unwritten
>    1:   260608..  262143:     262144..    263679:   1536:     261128:
> last,unwritten,eof
> /mnt/pmem0/data: 2 extents found

/me really dislikes filefrag output.

$ sudo xfs_bmap -vvp /mnt/scratch/data
/mnt/scratch/data:
 EXT: FILE-OFFSET         BLOCK-RANGE      AG AG-OFFSET          TOTAL FLAGS
   0: [0..2088959]:       4160..2093119     0 (4160..2093119)  2088960 011111
   1: [2088960..2097151]: 2101248..2109439  1 (4096..12287)       8192 010000
 FLAG Values:
    0100000 Shared extent
    0010000 Unwritten preallocated extent
    0001000 Doesn't begin on stripe unit
    0000100 Doesn't end   on stripe unit
    0000010 Doesn't begin on stripe width
    0000001 Doesn't end   on stripe width

Yeah, though so. The bmap output clearly tells me that the
allocation being asked for doesn't fit into a single AG, so it's
trimmed to fit.

To confirm this is the issue, let's do two smaller alllocations:

$ sudo rm /mnt/scratch/data
dave@test4:~$ sudo xfs_io -f -c "falloc 0 512m" -c "falloc 512m 512m" -c stat -c "bmap -vvp" /mnt/scratch/data
fd.path = "/mnt/scratch/data"
fd.flags = non-sync,non-direct,read-write
stat.ino = 4099
stat.type = regular file
stat.size = 1073741824
stat.blocks = 2097152
fsxattr.xflags = 0x802 [-p--------e------]
fsxattr.projid = 0
fsxattr.extsize = 2097152
fsxattr.cowextsize = 0
fsxattr.nextents = 2
fsxattr.naextents = 0
dioattr.mem = 0x200
dioattr.miniosz = 512
dioattr.maxiosz = 2147483136
/mnt/scratch/data:
 EXT: FILE-OFFSET         BLOCK-RANGE      AG AG-OFFSET          TOTAL FLAGS
   0: [0..1048575]:       8192..1056767     0 (8192..1056767)  1048576 010000
   1: [1048576..2097151]: 2101248..3149823  1 (4096..1052671)  1048576 010000
 FLAG Values:
    0100000 Shared extent
    0010000 Unwritten preallocated extent
    0001000 Doesn't begin on stripe unit
    0000100 Doesn't end   on stripe unit
    0000010 Doesn't begin on stripe width
    0000001 Doesn't end   on stripe width

Yup, all blocks are 2MB aligned.

IOWs, what you are seeing is trying to do a very large allocation on
a very small (8GB) XFS filesystem.  It's rare someone asks to
allocate >25% of the filesystem space in one allocation, so it's not
surprising it triggers ENOSPC-like algorithms because it doesn't fit
into a single AG....

We can probably look to optimise this, but I'm not sure if we can
easily differentiate this case (i.e. allocation request larger than
continguous free space) from the same situation near ENOSPC when we
really do have to trim to fit...

Remember: stripe unit allocation alignment is a hint in XFS that we
can and do ignore when necessary - it's not a binding rule.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

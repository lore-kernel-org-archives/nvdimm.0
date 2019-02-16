Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
 [150.101.137.129])
 by ml01.01.org (Postfix) with ESMTP id 6A34220886FCE
 for <linux-nvdimm@lists.01.org>; Sat, 16 Feb 2019 15:01:23 -0800 (PST)
Date: Sun, 17 Feb 2019 10:00:52 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [LSF/MM TOPIC] Software RAID Support for NV-DIMM
Message-ID: <20190216230052.GW20493@dastard>
References: <20190215095710.GA12279@linux-x5ow.site>
 <20190216053133.GT20493@dastard> <20190216053957.GU20493@dastard>
 <CAPcyv4jkT5i=akskXCzS7ST47iEk=x8Oh84Cp7q+WRpdOX8hGg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4jkT5i=akskXCzS7ST47iEk=x8Oh84Cp7q+WRpdOX8hGg@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>, linux-block@vger.kernel.org, Hannes Reinecke <hare@suse.de>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, lsf-pc@lists.linux-foundation.org, linux-btrfs@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Sat, Feb 16, 2019 at 09:05:31AM -0800, Dan Williams wrote:
> On Fri, Feb 15, 2019 at 9:40 PM Dave Chinner <david@fromorbit.com> wrote:
> >
> > On Sat, Feb 16, 2019 at 04:31:33PM +1100, Dave Chinner wrote:
> > > On Fri, Feb 15, 2019 at 10:57:12AM +0100, Johannes Thumshirn wrote:
> > > > (This is a joint proposal with Hannes Reinecke)
> > > >
> > > > Servers with NV-DIMM are slowly emerging in data centers but one key feature
> > > > for reliability of these systems hasn't been addressed up to now, data
> > > > redundancy.
> > > >
> > > > While it would be best to solve this issue in the memory controller of the CPU
> > > > itself, I don't see this coming in the next few years. This puts us as the OS
> > > > in the burden to create the redundant copies of data for the users.
> > > >
> > > > If we leave of the DAX support Linux' software RAID implementations (MD,
> > > > device-mapper and BTRFS RAID) do already work on top of pmem devices, but they
> > > > are incompatible with DAX.
> > > >
> > > > In this session Hannes and I would like to discuss eventual ways how we as an
> > > > operating system can mitigate these issues for our users.
> > >
> > > We've supported this since mid 2018 and commit ba23cba9b3bd ("fs:
> > > allow per-device dax status checking for filesystems"). That is,
> > > we can have DAX on the XFS RT device indepently of the data device.
> > >
> > > That is, you set up pmem in three segments - two small identical
> > > segments start get mirrored with RAID1 as the data device, and
> > > the remainder as a block device that is dax capable set up as the
> > > XFS realtime device. Set the RTINHERIT bit on the root directory at
> > > mkfs time ("-d rtinherit=1") and then all the data goes to the DAX
> > > capable realtime device, and all the metadata goes to the software
> > > raided pmem block devices that aren't DAX capable.
> > >
> > > Problem already solved, yes?
> >
> > Sorry, this was meant to be a reply to Dan's email commenting about
> > some people needing mirrored metadata, not the parent that was
> > talking about whole device RAID...
> >
> > i.e. mirrored metadata w/ FS-DAX for data should already be a solved
> > problem...
> 
> Ah true, thanks for the clarification. I'll give it a try, the last
> time I looked RT configurations failed with DAX, but perhaps that's
> been fixed and I can drop if from my list of broken DAX items.

It should work. The whole reason for DAX on rt devices is that we
can guarantee PMD sized and aligned allocations for all user data
with the RT device (i.e. using "-r extsize=<PMD_SIZE>" mkfs option)
so it's nearly equivalent in capability compared to using device dax
directly. We can't guarantee such alignment with the data device as
extent size hints are, well, just hints and it will fall back to
smaller allocations if it's too difficult to find PMD aligned free
space...

$ sudo mkfs.xfs -f -r rtdev=/dev/pmem1,extsize=2m -d rtinherit=1 /dev/pmem0
meta-data=/dev/pmem0             isize=512    agcount=4, agsize=524288 blks
         =                       sectsz=4096  attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=0
         =                       reflink=0
data     =                       bsize=4096   blocks=2097152, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=2560, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =/dev/pmem1             extsz=2097152 blocks=2097152, rtextents=4096
$ sudo mount -o dax,rtdev=/dev/pmem1 /dev/pmem0 /mnt/scratch
$ sudo dmesg |tail -3
XFS (pmem0): DAX enabled. Warning: EXPERIMENTAL, use at your own risk
XFS (pmem0): Mounting V5 Filesystem
XFS (pmem0): Ending clean mount
$

Yup, DAX is enabled on the filesystem.

$ sudo xfs_io -c stat /mnt/scratch
....
fsxattr.xflags = 0x100 [-------t--------]
....
$

The root dir is configured to put all new files on the rt device.

$ sudo xfs_io -f -c "pwrite 0 1m" -c stat -c "bmap -vp" /mnt/scratch/foo
wrote 1048576/1048576 bytes at offset 0
1 MiB, 256 ops; 0.0029 sec (338.983 MiB/sec and 86779.6610 ops/sec)
fd.path = "/mnt/scratch/foo"
fd.flags = non-sync,non-direct,read-write
stat.ino = 131
stat.type = regular file
stat.size = 1048576
stat.blocks = 4096
fsxattr.xflags = 0x1 [r---------------]
fsxattr.projid = 0
fsxattr.extsize = 0
fsxattr.cowextsize = 0
fsxattr.nextents = 1
fsxattr.naextents = 0
dioattr.mem = 0x200
dioattr.miniosz = 512
dioattr.maxiosz = 2147483136
/mnt/scratch/foo:
 EXT: FILE-OFFSET      RT-BLOCK-RANGE     TOTAL FLAGS
   0: [0..4095]:       0..4095             4096 000000
$

Yup, /mnt/scratch/foo is on the rt device, it's got a 2MB sized and
aligned extent allocated to it, and DAX is enabled.

So it looks to me like this all just works fine.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

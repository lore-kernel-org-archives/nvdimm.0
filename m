Return-Path: <linux-fsdevel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <1439571318.16263.3.camel@linux.intel.com>
References: <1439484671-15718-1-git-send-email-ross.zwisler@linux.intel.com>
	<1439484671-15718-8-git-send-email-ross.zwisler@linux.intel.com>
	<CAPcyv4j=h1FULCnmLbwNv6E0ySyZNKniM3GZEnNCpGeiqCb+Kg@mail.gmail.com>
	<1439571318.16263.3.camel@linux.intel.com>
Date: Fri, 14 Aug 2015 09:58:16 -0700
Message-ID: <CAPcyv4gBwa=ud7FZcAK=uq8F-9RVdZNf+-=ROB0K7G3SkiP1FQ@mail.gmail.com>
Subject: Re: [PATCH v2 7/7] pmem, dax: have direct_access use __pmem annotation
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-fsdevel-owner@vger.kernel.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Jonathan Corbet <corbet@lwn.net>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Jens Axboe <axboe@kernel.dk>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com, Alexander Viro <viro@zeniv.linux.org.uk>, Matthew Wilcox <willy@linux.intel.com>, Jeff Layton <jlayton@primarydata.com>, Christoph Hellwig <hch@lst.de>, Andrew Morton <akpm@linux-foundation.org>, Omar Sandoval <osandov@osandov.com>, Boaz Harrosh <boaz@plexistor.com>, Miklos Szeredi <mszeredi@suse.cz>, Jan Kara <jack@suse.cz>, Wolfram Sang <wsa@the-dreams.de>, =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= <u.kleine-koenig@pengutronix.de>, Gerald Schaefer <gerald.schaefer@de.ibm.com>, Ameen Ali <ameenali023@gmail.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagig@mellanox.com>, Mike Snitzer <snitzer@redhat.com>, Tejun Heo <tj@kernel.org>, Shaohua Li <shli@fb.com>, Ming Lei <ming.lei@canonical.com>, linux-doc@vger.kernel.org, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, linux-s390@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Dave Chinner <david@fromorbit.com>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Aug 14, 2015 at 9:55 AM, Ross Zwisler
<ross.zwisler@linux.intel.com> wrote:
> On Thu, 2015-08-13 at 14:20 -0700, Dan Williams wrote:
>> On Thu, Aug 13, 2015 at 9:51 AM, Ross Zwisler
>> <ross.zwisler@linux.intel.com> wrote:
>> > Update the annotation for the kaddr pointer returned by direct_access()
>> > so that it is a __pmem pointer.  This is consistent with the PMEM driver
>> > and with how this direct_access() pointer is used in the DAX code.
>> >
>> > Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
>> > ---
>> >  Documentation/filesystems/Locking |  3 ++-
>> >  arch/powerpc/sysdev/axonram.c     |  7 ++++---
>> >  drivers/block/brd.c               |  4 ++--
>> >  drivers/nvdimm/pmem.c             |  4 ++--
>> >  drivers/s390/block/dcssblk.c      | 10 +++++----
>> >  fs/block_dev.c                    |  2 +-
>> >  fs/dax.c                          | 44 +++++++++++++++++++++------------------
>> >  include/linux/blkdev.h            |  8 +++----
>> >  8 files changed, 45 insertions(+), 37 deletions(-)
>> >
>> > diff --git a/Documentation/filesystems/Locking b/Documentation/filesystems/Locking
>> > index 6a34a0f..06d4434 100644
>> > --- a/Documentation/filesystems/Locking
>> > +++ b/Documentation/filesystems/Locking
>> > @@ -397,7 +397,8 @@ prototypes:
>> >         int (*release) (struct gendisk *, fmode_t);
>> >         int (*ioctl) (struct block_device *, fmode_t, unsigned, unsigned long);
>> >         int (*compat_ioctl) (struct block_device *, fmode_t, unsigned, unsigned long);
>> > -       int (*direct_access) (struct block_device *, sector_t, void **, unsigned long *);
>> > +       int (*direct_access) (struct block_device *, sector_t, void __pmem **,
>> > +                               unsigned long *);
>>
>> So this collides with the __pfn_t work.  I think the we have a
>> reasonable chance of getting that in to 4.3, so I'd wait to see if we
>> hit any major roadblocks with that set [1] before merging these.
>>
>> [1]: https://lists.01.org/pipermail/linux-nvdimm/2015-August/001803.html
>
> Fair enough.  Yea, I hadn't merged with that series yet a) because I didn't
> know when its review cycle would settle down and b) because that series hadn't
> pulled in changes from Matthew for PMD support, which I was originally using
> as a baseline.
>
> I'll merge with your code for v3.

Sounds, let me go rebase the __pfn_t patches on -mm so we'all lined up
and collision free.

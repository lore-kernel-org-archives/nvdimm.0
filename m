From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 0/6] Support DAX for device-mapper dm-linear devices
Date: Wed, 22 Jun 2016 18:38:42 -0400
Message-ID: <20160622223842.GA34512@redhat.com>
References: <20160620195217.GB21657@redhat.com>
 <1466452883.3504.244.camel@hpe.com>
 <1466457467.3504.249.camel@hpe.com>
 <20160620222236.GA22461@redhat.com>
 <20160621134147.GA26392@redhat.com>
 <1466523280.3504.262.camel@hpe.com>
 <20160621181728.GA27821@redhat.com>
 <1466616868.3504.320.camel@hpe.com>
 <CAPcyv4gqiNQ-FRqCV3WxBzjUBZNY6eZVA9ioc0q+Lm=oG8bWAg@mail.gmail.com>
 <1466625958.3504.340.camel@hpe.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1466625958.3504.340.camel@hpe.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Cc: "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "sandeen@redhat.com" <sandeen@redhat.com>, "linux-nvdimm@ml01.01.org" <linux-nvdimm@ml01.01.org>, "agk@redhat.com" <agk@redhat.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "axboe@kernel.dk" <axboe@kernel.dk>, "axboe@fb.com" <axboe@fb.com>, "ross.zwisler@linux.intel.com" <ross.zwisler@linux.intel.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: linux-nvdimm@lists.01.org

On Wed, Jun 22 2016 at  4:16P -0400,
Kani, Toshimitsu <toshi.kani@hpe.com> wrote:

> On Wed, 2016-06-22 at 12:15 -0700, Dan Williams wrote:
> > On Wed, Jun 22, 2016 at 10:44 AM, Kani, Toshimitsu <toshi.kani@hpe.=
com>
> > wrote:
> > > On Tue, 2016-06-21 at 14:17 -0400, Mike Snitzer wrote:
> > > >=20
> > > > On Tue, Jun 21 2016 at 11:44am -0400,
> > > > Kani, Toshimitsu <toshi.kani@hpe.com> wrote:
> > > > >=20
> > > > > On Tue, 2016-06-21 at 09:41 -0400, Mike Snitzer wrote:
> > > > > > On Mon, Jun 20 2016 at=A0=A06:22pm -0400,
> > > > > > Mike Snitzer <snitzer@redhat.com> wrote:
> > > > > > I'm now wondering if we'd be better off setting a new QUEUE=
_FLAG_DAX
> > > > > > rather than establish GENHD_FL_DAX on the genhd?
> > > > > >=20
> > > > > > It'd be quite a bit easier to allow upper layers (e.g. XFS =
and ext4)
> > > > > > to check for a queue flag.
> > > > >=A0
> > > > > I think GENHD_FL_DAX is more appropriate since DAX does not u=
se a
> > > > > request queue, except for protecting the underlining device b=
eing
> > > > > disabled while direct_access() is called (b2e0d1625e19).
> > > >=A0
> > > > The devices in question have a request_queue.=A0=A0All bio-base=
d device have
> > > > a request_queue.
> > >
> > > DAX-capable devices have two operation modes, bio-based and DAX.=A0=
=A0I agree
> > > that bio-based operation is associated with a request queue, and =
its
> > > capabilities should be set to it.=A0=A0DAX, on the other hand, is=
 rather
> > > independent from a request queue.
> > >=20
> > > > I don't have a big problem with GENHD_FL_DAX.=A0=A0Just wanted =
to point out
> > > > that such block device capabilities are generally advertised in=
 terms of
> > > > a QUEUE_FLAG.
> > >
> > > I do not have a strong opinion, but feel a bit odd to associate D=
AX to a
> > > request queue.
> >
> > Given that we do not support dax to a raw block device [1] it seems=
 a
> > gendisk flag is more misleading than request_queue flag that specif=
ies
> > what requests can be made of the device.
> >=20
> > [1]: acc93d30d7d4 Revert "block: enable dax for raw block devices"
>=20
> Oh, I see. =A0I will change to use request_queue flag.

I implemented the block patch for this yesterday but based on your
feedback I stopped there (didn't carry the change through to the DM cor=
e
and DM linear -- can easily do so tomorrow though).

=46eel free to use this as a starting point and fix/extend and add a
proper header:

=46rom e88736ce322f248157da6c7d402e940adafffa1e Mon Sep 17 00:00:00 200=
1
=46rom: Mike Snitzer <snitzer@redhat.com>
Date: Tue, 21 Jun 2016 12:23:29 -0400
Subject: [PATCH] block: add QUEUE_FLAG_DAX for devices to advertise the=
ir DAX support

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/block/brd.c          | 3 +++
 drivers/nvdimm/pmem.c        | 1 +
 drivers/s390/block/dcssblk.c | 1 +
 fs/block_dev.c               | 5 +++--
 include/linux/blkdev.h       | 2 ++
 5 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index f5b0d6f..13eee12 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -508,6 +508,9 @@ static struct brd_device *brd_alloc(int i)
 	brd->brd_queue->limits.discard_granularity =3D PAGE_SIZE;
 	blk_queue_max_discard_sectors(brd->brd_queue, UINT_MAX);
 	brd->brd_queue->limits.discard_zeroes_data =3D 1;
+#ifdef CONFIG_BLK_DEV_RAM_DAX
+	queue_flag_set_unlocked(QUEUE_FLAG_DAX, brd->brd_queue);
+#endif
 	queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, brd->brd_queue);
=20
 	disk =3D brd->brd_disk =3D alloc_disk(max_part);
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 608fc44..53b701b 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -283,6 +283,7 @@ static int pmem_attach_disk(struct device *dev,
 	blk_queue_max_hw_sectors(q, UINT_MAX);
 	blk_queue_bounce_limit(q, BLK_BOUNCE_ANY);
 	queue_flag_set_unlocked(QUEUE_FLAG_NONROT, q);
+	queue_flag_set_unlocked(QUEUE_FLAG_DAX, q);
 	q->queuedata =3D pmem;
=20
 	disk =3D alloc_disk_node(0, nid);
diff --git a/drivers/s390/block/dcssblk.c b/drivers/s390/block/dcssblk.=
c
index bed53c4..093e9e1 100644
--- a/drivers/s390/block/dcssblk.c
+++ b/drivers/s390/block/dcssblk.c
@@ -618,6 +618,7 @@ dcssblk_add_store(struct device *dev, struct device=
_attribute *attr, const char
 	dev_info->gd->driverfs_dev =3D &dev_info->dev;
 	blk_queue_make_request(dev_info->dcssblk_queue, dcssblk_make_request)=
;
 	blk_queue_logical_block_size(dev_info->dcssblk_queue, 4096);
+	queue_flag_set_unlocked(QUEUE_FLAG_DAX, dev_info->dcssblk_queue);
=20
 	seg_byte_size =3D (dev_info->end - dev_info->start + 1);
 	set_capacity(dev_info->gd, seg_byte_size >> 9); // size in sectors
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 71ccab1..9bcb3a9 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -484,6 +484,7 @@ long bdev_direct_access(struct block_device *bdev, =
struct blk_dax_ctl *dax)
 	sector_t sector =3D dax->sector;
 	long avail, size =3D dax->size;
 	const struct block_device_operations *ops =3D bdev->bd_disk->fops;
+	struct request_queue *q =3D bdev_get_queue(bdev);
=20
 	/*
 	 * The device driver is allowed to sleep, in order to make the
@@ -493,7 +494,7 @@ long bdev_direct_access(struct block_device *bdev, =
struct blk_dax_ctl *dax)
=20
 	if (size < 0)
 		return size;
-	if (!ops->direct_access)
+	if (!blk_queue_dax(q) || !ops->direct_access)
 		return -EOPNOTSUPP;
 	if ((sector + DIV_ROUND_UP(size, 512)) >
 					part_nr_sects_read(bdev->bd_part))
@@ -1287,7 +1288,7 @@ static int __blkdev_get(struct block_device *bdev=
, fmode_t mode, int for_part)
 		bdev->bd_disk =3D disk;
 		bdev->bd_queue =3D disk->queue;
 		bdev->bd_contains =3D bdev;
-		if (IS_ENABLED(CONFIG_BLK_DEV_DAX) && disk->fops->direct_access)
+		if (IS_ENABLED(CONFIG_BLK_DEV_DAX) && blk_queue_dax(disk->queue))
 			bdev->bd_inode->i_flags =3D S_DAX;
 		else
 			bdev->bd_inode->i_flags =3D 0;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 9746d22..d5cb326 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -505,6 +505,7 @@ struct request_queue {
 #define QUEUE_FLAG_WC	       23	/* Write back caching */
 #define QUEUE_FLAG_FUA	       24	/* device supports FUA writes */
 #define QUEUE_FLAG_FLUSH_NQ    25	/* flush not queueuable */
+#define QUEUE_FLAG_DAX	       26	/* device supports DAX */
=20
 #define QUEUE_FLAG_DEFAULT	((1 << QUEUE_FLAG_IO_STAT) |		\
 				 (1 << QUEUE_FLAG_STACKABLE)	|	\
@@ -594,6 +595,7 @@ static inline void queue_flag_clear(unsigned int fl=
ag, struct request_queue *q)
 #define blk_queue_discard(q)	test_bit(QUEUE_FLAG_DISCARD, &(q)->queue_=
flags)
 #define blk_queue_secdiscard(q)	(blk_queue_discard(q) && \
 	test_bit(QUEUE_FLAG_SECDISCARD, &(q)->queue_flags))
+#define blk_queue_dax(q)	test_bit(QUEUE_FLAG_DAX, &(q)->queue_flags)
=20
 #define blk_noretry_request(rq) \
 	((rq)->cmd_flags & (REQ_FAILFAST_DEV|REQ_FAILFAST_TRANSPORT| \
--=20
2.7.4 (Apple Git-66)

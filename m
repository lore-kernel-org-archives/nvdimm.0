From: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/6] Support DAX for device-mapper dm-linear devices
Date: Tue, 21 Jun 2016 09:41:47 -0400
Message-ID: <20160621134147.GA26392@redhat.com>
References: <1465856497-19698-1-git-send-email-toshi.kani@hpe.com>
 <20160613225756.GA18417@redhat.com>
 <20160620180043.GA21261@redhat.com>
 <1466446861.3504.243.camel@hpe.com>
 <20160620194026.GA21657@redhat.com>
 <20160620195217.GB21657@redhat.com>
 <1466452883.3504.244.camel@hpe.com>
 <1466457467.3504.249.camel@hpe.com>
 <20160620222236.GA22461@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160620222236.GA22461-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: "Kani, Toshimitsu" <toshi.kani-ZPxbGqLxI0U@public.gmane.org>, axboe-b10kYP2dOMg@public.gmane.org
Cc: "axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org" <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, "sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org" <linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org" <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, "agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

On Mon, Jun 20 2016 at  6:22pm -0400,
Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> On Mon, Jun 20 2016 at  5:28pm -0400,
> Kani, Toshimitsu <toshi.kani-ZPxbGqLxI0U@public.gmane.org> wrote:
> =

> > =

> > Hi Mike,
> > =

> > Can you fold the following patch to the dm-linear patch?
> > =

> > Thanks,
> > -Tsohi
> > =

> > ------
> > Subject: [PATCH] dm-linear: Fix partition handling for DAX
> > =

> > Partition handling was missing in linear_direct_access().
> > Call bdev_direct_access(), instead of directly calling
> > target direct_access function.
> > =

> > Signed-off-by: Toshi Kani <toshi.kani-ZPxbGqLxI0U@public.gmane.org>
> > ---
> > =A0drivers/md/dm-linear.c |=A0=A0=A014 ++++++++++----
> > =A01 file changed, 10 insertions(+), 4 deletions(-)
> > =

> > diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
> > index 325aa06..38323e4 100644
> > --- a/drivers/md/dm-linear.c
> > +++ b/drivers/md/dm-linear.c
> > @@ -148,10 +148,16 @@ static long linear_direct_access(struct dm_target=
 *ti,
> > sector_t sector,
> > =A0{
> > =A0	struct linear_c *lc =3D ti->private;
> > =A0	struct block_device *bdev =3D lc->dev->bdev;
> > -	const struct block_device_operations *bd_ops =3D bdev->bd_disk->fops;
> > -
> > -	return bd_ops->direct_access(bdev, linear_map_sector(ti, sector),
> > -				=A0=A0=A0=A0=A0kaddr, pfn, size);
> > +	struct blk_dax_ctl dax =3D {
> > +		.sector =3D linear_map_sector(ti, sector),
> > +		.size =3D size,
> > +	};
> > +	long ret;
> > +
> > +	ret =3D bdev_direct_access(bdev, &dax);
> > +	*kaddr =3D dax.addr;
> > +	*pfn =3D dax.pfn;
> > +	return ret;
> > =A0}
> > =A0
> > =A0static struct target_type linear_target =3D {
> =

> Looks good, I folded it in and tested it to work.  Pushed to my 'wip'
> branch.
> =

> No longer seeing any corruption in my test that was using partitions to
> span pmem devices with a dm-linear device.
> =

> Jens, any chance you'd be open to picking up the first 2 patches in this
> series?  Or would you like to see them folded or something different?

I'm now wondering if we'd be better off setting a new QUEUE_FLAG_DAX
rather than establish GENHD_FL_DAX on the genhd?

It'd be quite a bit easier to allow upper layers (e.g. XFS and ext4) to
check for a queue flag.

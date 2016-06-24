From: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 3/4] dm: add infrastructure for DAX support
Date: Thu, 23 Jun 2016 21:49:30 -0400
Message-ID: <20160624014930.GA10540@redhat.com>
References: <1466715953-40692-1-git-send-email-snitzer@redhat.com>
 <1466715953-40692-4-git-send-email-snitzer@redhat.com>
 <1466724984.3504.380.camel@hpe.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1466724984.3504.380.camel-ZPxbGqLxI0U@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: "Kani, Toshimitsu" <toshi.kani-ZPxbGqLxI0U@public.gmane.org>
Cc: "axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org" <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, "linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org" <linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org" <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

On Thu, Jun 23 2016 at  7:36pm -0400,
Kani, Toshimitsu <toshi.kani-ZPxbGqLxI0U@public.gmane.org> wrote:

> On Thu, 2016-06-23 at 17:05 -0400, Mike Snitzer wrote:
> =A0:
> > +static int device_supports_dax(struct dm_target *ti, struct dm_dev *de=
v,
> > +			=A0=A0=A0=A0=A0=A0=A0sector_t start, sector_t len, void *data)
> > +{
> > +	struct request_queue *q =3D bdev_get_queue(dev->bdev);
> > +
> > +	return q && blk_queue_dax(q);
> > +}
> > +
> > +static bool dm_table_supports_dax(struct dm_table *t)
> > +{
> > +	struct dm_target *ti;
> > +	unsigned i =3D 0;
> > +
> > +	/* Ensure that all targets support DAX. */
> > +	while (i < dm_table_get_num_targets(t)) {
> > +		ti =3D dm_table_get_target(t, i++);
> > +
> > +		if (!ti->type->direct_access)
> > +			return false;
> > +
> > +		if (!ti->type->iterate_devices ||
> > +		=A0=A0=A0=A0!ti->type->iterate_devices(ti, device_supports_dax,
> > NULL))
> > +			return false;
> > +	}
> > +
> > +	return true;
> > +}
> > +
> =

> Hi Mike,
> =

> Thanks for the update. =A0I have a question about the above change. =A0Ta=
rgets may
> have their own parameters. =A0For instance, dm-stripe has 'chunk_size', w=
hich is
> checked in stripe_ctr(). =A0DAX adds additional restriction that chunk_si=
ze
> needs to be aligned by page size. =A0So, I think we need to keep target
> responsible to verify if DAX can be supported. =A0What do you think?

We've never had to concern the dm-stripe target with hardware
specific chunk_size validation.  The user is able to specify the
chunk_size via lvm2's lvcreate -I argument.  Yes this gives users enough
rope to hang themselves but it is very easy to configure a dm-stripe
device with the appropriate chunk size (PAGE_SIZE) from userspace.

But lvm2 could even be trained to make sure the chunk_size is a factor
of physical_block_size (PAGE_SIZE in the case of pmem) if the underlying
devices export queue/dax=3D1

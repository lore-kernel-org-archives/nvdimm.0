From: Pankaj Gupta <pagupta-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 3/5] libnvdimm: add nd_region buffered dax_dev flag
Date: Wed, 9 Jan 2019 13:21:29 -0500 (EST)
Message-ID: <888499462.61280342.1547058089165.JavaMail.zimbra@redhat.com>
References: <20190109135024.14093-1-pagupta@redhat.com>
 <20190109135024.14093-4-pagupta@redhat.com>
 <CAPcyv4jsa709BVPAx_BT5eFrODf-PUPOZ4aguDsjZVawVXTVHQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <CAPcyv4jsa709BVPAx_BT5eFrODf-PUPOZ4aguDsjZVawVXTVHQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, KVM list <kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Hildenbrand <david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-nvdimm <linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org>, Jason Wang <jasowang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Qemu Developers <qemu-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org>, virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, Ross Zwisler <zwisler-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Eric Blake <eblake-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Linux ACPI <linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Nitesh Narayan Lal <nilal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Rik van Riel <riel-ebMLmSuQjDVBDgjK7y7TUQ@public.gmane.org>, Stefan Hajnoczi <stefanha-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Igor Mammedov <imammedo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, lcapitulino-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Kevin Wolf <kwolf-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-ext4 <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Xiao Guangrong <xiaoguangrong.eric-Re5JQEeQqe8@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org


> >
> > This patch adds 'DAXDEV_BUFFERED' flag which is set
> > for virtio pmem corresponding nd_region. This later
> > is used to disable MAP_SYNC functionality for ext4
> > & xfs filesystem.
> >
> > Signed-off-by: Pankaj Gupta <pagupta-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > ---
> >  drivers/dax/super.c          | 17 +++++++++++++++++
> >  drivers/nvdimm/pmem.c        |  3 +++
> >  drivers/nvdimm/region_devs.c |  7 +++++++
> >  drivers/virtio/pmem.c        |  1 +
> >  include/linux/dax.h          |  9 +++++++++
> >  include/linux/libnvdimm.h    |  6 ++++++
> >  6 files changed, 43 insertions(+)
> >
> > diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> > index 6e928f3..9128740 100644
> > --- a/drivers/dax/super.c
> > +++ b/drivers/dax/super.c
> > @@ -167,6 +167,8 @@ enum dax_device_flags {
> >         DAXDEV_ALIVE,
> >         /* gate whether dax_flush() calls the low level flush routine */
> >         DAXDEV_WRITE_CACHE,
> > +       /* flag to disable MAP_SYNC for virtio based host page cache flush
> > */
> > +       DAXDEV_BUFFERED,
> >  };
> >
> >  /**
> > @@ -335,6 +337,21 @@ bool dax_write_cache_enabled(struct dax_device
> > *dax_dev)
> >  }
> >  EXPORT_SYMBOL_GPL(dax_write_cache_enabled);
> >
> > +void virtio_pmem_host_cache(struct dax_device *dax_dev, bool wc)
> > +{
> > +       if (wc)
> > +               set_bit(DAXDEV_BUFFERED, &dax_dev->flags);
> > +       else
> > +               clear_bit(DAXDEV_BUFFERED, &dax_dev->flags);
> > +}
> > +EXPORT_SYMBOL_GPL(virtio_pmem_host_cache);
> 
> The "write_cache" property was structured this way because it can
> conceivably change at runtime. The MAP_SYNC capability should be
> static and never changed after init.

o.k. Will change.

> 
> > +bool virtio_pmem_host_cache_enabled(struct dax_device *dax_dev)
> > +{
> > +       return test_bit(DAXDEV_BUFFERED, &dax_dev->flags);
> > +}
> > +EXPORT_SYMBOL_GPL(virtio_pmem_host_cache_enabled);
> 
> Echoing Darrick and Jan this is should be a generic property of a
> dax_device and not specific to virtio. I don't like the "buffered"
> designation as that's not accurate. There may be hardware reasons why
> a dax_device is not synchronous, like a requirement to flush a
> write-pending queue or otherwise notify the device of new writes.

Agree.

> 
> I would just have a dax_synchronous() helper and a DAXDEV_SYNC flag. I
> would also modify alloc_dax() to take a flags argument so that the
> capability can be instantiated when the dax_device is allocated.

o.k. Will make the change.

Thanks,
Pankaj
> 

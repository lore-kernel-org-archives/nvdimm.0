Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 08238212017C1
 for <linux-nvdimm@lists.01.org>; Thu, 11 Apr 2019 08:57:40 -0700 (PDT)
Date: Thu, 11 Apr 2019 11:57:38 -0400 (EDT)
From: Pankaj Gupta <pagupta@redhat.com>
Message-ID: <1463291806.21158433.1554998258746.JavaMail.zimbra@redhat.com>
In-Reply-To: <CAPcyv4i1FjBzfcWtzeCvj-giHa9xaX0dMQ==q4LZC_L8VEqkHg@mail.gmail.com>
References: <20190410040826.24371-1-pagupta@redhat.com>
 <20190410040826.24371-2-pagupta@redhat.com>
 <CAPcyv4i1FjBzfcWtzeCvj-giHa9xaX0dMQ==q4LZC_L8VEqkHg@mail.gmail.com>
Subject: Re: [Qemu-devel] [PATCH v5 1/6] libnvdimm: nd_region flush callback
 support
MIME-Version: 1.0
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
Cc: Jan Kara <jack@suse.cz>, KVM list <kvm@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, david <david@fromorbit.com>, Qemu Developers <qemu-devel@nongnu.org>, virtualization@lists.linux-foundation.org, Andreas Dilger <adilger.kernel@dilger.ca>, Ross Zwisler <zwisler@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, David Hildenbrand <david@redhat.com>, Matthew Wilcox <willy@infradead.org>, Christoph Hellwig <hch@infradead.org>, Linux ACPI <linux-acpi@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, Len Brown <lenb@kernel.org>, kilobyte@angband.pl, Rik van Riel <riel@surriel.com>, yuval shaia <yuval.shaia@oracle.com>, Stefan Hajnoczi <stefanha@redhat.com>, Igor Mammedov <imammedo@redhat.com>, lcapitulino@redhat.com, Kevin Wolf <kwolf@redhat.com>, Nitesh Narayan Lal <nilal@redhat.com>, Theodore Ts'o <tytso@mit.edu>, Xiao Guangrong <xiaoguangrong.eric@gmail.com>, cohuck@redhat.com, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>
List-ID: <linux-nvdimm@lists.01.org>



> >
> > This patch adds functionality to perform flush from guest
> > to host over VIRTIO. We are registering a callback based
> > on 'nd_region' type. virtio_pmem driver requires this special
> > flush function. For rest of the region types we are registering
> > existing flush function. Report error returned by host fsync
> > failure to userspace.
> >
> > This also handles asynchronous flush requests from the block layer
> > by creating a child bio and chaining it with parent bio.
> >
> > Signed-off-by: Pankaj Gupta <pagupta@redhat.com>
> > ---bio_chain Dan williams
> [..]
> > diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
> > index b4ef7d9ff22e..fb1041ab32a6 100644
> > --- a/drivers/nvdimm/region_devs.c
> > +++ b/drivers/nvdimm/region_devs.c
> > @@ -295,7 +295,9 @@ static ssize_t deep_flush_store(struct device *dev,
> > struct device_attribute *att
> >                 return rc;
> >         if (!flush)
> >                 return -EINVAL;
> > -       nvdimm_flush(nd_region);
> > +       rc = nvdimm_flush(nd_region, NULL, false);
> > +       if (rc)
> > +               return rc;
> >
> >         return len;
> >  }
> > @@ -1085,6 +1087,11 @@ static struct nd_region *nd_region_create(struct
> > nvdimm_bus *nvdimm_bus,
> >         dev->of_node = ndr_desc->of_node;
> >         nd_region->ndr_size = resource_size(ndr_desc->res);
> >         nd_region->ndr_start = ndr_desc->res->start;
> > +       if (ndr_desc->flush)
> > +               nd_region->flush = ndr_desc->flush;
> > +       else
> > +               nd_region->flush = generic_nvdimm_flush;
> > +
> >         nd_device_register(dev);
> >
> >         return nd_region;
> > @@ -1125,11 +1132,36 @@ struct nd_region
> > *nvdimm_volatile_region_create(struct nvdimm_bus *nvdimm_bus,
> >  }
> >  EXPORT_SYMBOL_GPL(nvdimm_volatile_region_create);
> >
> > +int nvdimm_flush(struct nd_region *nd_region, struct bio *bio, bool async)
> > +{
> 
> I don't quite see the point of the 'async' argument. All the usages of
> this routine are either
> 
> nvdimm_flush(nd_region, bio, true)
> ...or:
> nvdimm_flush(nd_region, NULL, false)

Agree.

> 
> ...so why not gate async behavior on the presence of the 'bio' argument?

Sure.

> 
> 
> > +       int rc = 0;
> > +
> > +       /* Create child bio for asynchronous flush and chain with
> > +        * parent bio. Otherwise directly call nd_region flush.
> > +        */
> > +       if (async && bio->bi_iter.bi_sector != -1) {
> > +
> > +               struct bio *child = bio_alloc(GFP_ATOMIC, 0);
> > +
> > +               if (!child)
> > +                       return -ENOMEM;
> > +               bio_copy_dev(child, bio);
> > +               child->bi_opf = REQ_PREFLUSH;
> > +               child->bi_iter.bi_sector = -1;
> > +               bio_chain(child, bio);
> > +               submit_bio(child);
> 
> I understand how this works, but it's a bit too "magical" for my
> taste. I would prefer that all flush implementations take an optional
> 'bio' argument rather than rely on the make_request implementation to
> stash the bio away on a driver specific list.

I did this to make use of "bio_chain" for chaining child bio for async flush
suggested [1]. Are you saying to remove this and just call "flush" based on 
bio argument? Or I implemented the 'bio_chain' request entirely wrong?

[1] https://lkml.org/lkml/2018/9/27/1028

> 
> > +       } else {
> > +               if (nd_region->flush(nd_region))
> > +                       rc = -EIO;
> 
> Given the common case wants to be fast and synchronous I think we
> should try to avoid retpoline overhead by default. So something like
> this:
> 
> if (nd_region->flush == generic_nvdimm_flush)
>     rc = generic_nvdimm_flush(...);

Sure.

Thanks,
Pankaj
> 
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

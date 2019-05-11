Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com
 [IPv6:2607:f8b0:4864:20::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BF67B2120515E
 for <linux-nvdimm@lists.01.org>; Fri, 10 May 2019 17:59:21 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id t187so2472043oie.10
 for <linux-nvdimm@lists.01.org>; Fri, 10 May 2019 17:59:21 -0700 (PDT)
MIME-Version: 1.0
References: <20190510155202.14737-1-pagupta@redhat.com>
 <20190510155202.14737-4-pagupta@redhat.com>
 <CAPcyv4hbVNRFSyS2CTbmO88uhnbeH4eiukAng2cxgbDzLfizwg@mail.gmail.com>
 <864186878.28040999.1557535549792.JavaMail.zimbra@redhat.com>
In-Reply-To: <864186878.28040999.1557535549792.JavaMail.zimbra@redhat.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 10 May 2019 17:59:08 -0700
Message-ID: <CAPcyv4gL3ODfOr52Ztgq7BM4gVf1cih6cj0271gcpVvpi9aFSA@mail.gmail.com>
Subject: Re: [PATCH v8 3/6] libnvdimm: add dax_dev sync flag
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
To: Pankaj Gupta <pagupta@redhat.com>
Cc: cohuck@redhat.com, Jan Kara <jack@suse.cz>, KVM list <kvm@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, david <david@fromorbit.com>, Qemu Developers <qemu-devel@nongnu.org>, virtualization@lists.linux-foundation.org, Andreas Dilger <adilger.kernel@dilger.ca>, Ross Zwisler <zwisler@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>, jstaron@google.com, linux-nvdimm <linux-nvdimm@lists.01.org>, David Hildenbrand <david@redhat.com>, Matthew Wilcox <willy@infradead.org>, Christoph Hellwig <hch@infradead.org>, Linux ACPI <linux-acpi@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, Len Brown <lenb@kernel.org>, Adam Borowski <kilobyte@angband.pl>, Rik van Riel <riel@surriel.com>, yuval shaia <yuval.shaia@oracle.com>, Stefan Hajnoczi <stefanha@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, lcapitulino@redhat.com, Kevin Wolf <kwolf@redhat.com>, Nitesh Narayan Lal <nilal@redhat.com>, Theodore Ts'o <tytso@mit.edu>, Xiao Guangrong <xiaoguangrong.eric@gmail.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Igor Mammedov <imammedo@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, May 10, 2019 at 5:45 PM Pankaj Gupta <pagupta@redhat.com> wrote:
>
>
>
> > >
> > > This patch adds 'DAXDEV_SYNC' flag which is set
> > > for nd_region doing synchronous flush. This later
> > > is used to disable MAP_SYNC functionality for
> > > ext4 & xfs filesystem for devices don't support
> > > synchronous flush.
> > >
> > > Signed-off-by: Pankaj Gupta <pagupta@redhat.com>
> > > ---
> > >  drivers/dax/bus.c            |  2 +-
> > >  drivers/dax/super.c          | 13 ++++++++++++-
> > >  drivers/md/dm.c              |  3 ++-
> > >  drivers/nvdimm/pmem.c        |  5 ++++-
> > >  drivers/nvdimm/region_devs.c |  7 +++++++
> > >  include/linux/dax.h          |  8 ++++++--
> > >  include/linux/libnvdimm.h    |  1 +
> > >  7 files changed, 33 insertions(+), 6 deletions(-)
> > [..]
> > > diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> > > index 043f0761e4a0..ee007b75d9fd 100644
> > > --- a/drivers/md/dm.c
> > > +++ b/drivers/md/dm.c
> > > @@ -1969,7 +1969,8 @@ static struct mapped_device *alloc_dev(int minor)
> > >         sprintf(md->disk->disk_name, "dm-%d", minor);
> > >
> > >         if (IS_ENABLED(CONFIG_DAX_DRIVER)) {
> > > -               dax_dev = alloc_dax(md, md->disk->disk_name, &dm_dax_ops);
> > > +               dax_dev = alloc_dax(md, md->disk->disk_name, &dm_dax_ops,
> > > +                                                        DAXDEV_F_SYNC);
> >
> > Apologies for not realizing this until now, but this is broken.
> > Imaging a device-mapper configuration composed of both 'async'
> > virtio-pmem and 'sync' pmem. The 'sync' flag needs to be unified
> > across all members. I would change this argument to '0' and then
> > arrange for it to be set at dm_table_supports_dax() time after
> > validating that all components support synchronous dax.
>
> o.k. Need to set 'DAXDEV_F_SYNC' flag after verifying all the target
> components support synchronous DAX.
>
> Just a question, If device mapper configuration have composed of both
> virtio-pmem or pmem devices, we want to configure device mapper for async flush?

If it's composed of both then, yes, it needs to be async flush at the
device-mapper level. Otherwise MAP_SYNC will succeed and fail to
trigger fsync on the host file when necessary for the virtio-pmem
backed portion of the device-mapper device.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

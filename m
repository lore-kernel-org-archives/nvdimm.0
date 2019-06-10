Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7717E21959CB2
 for <linux-nvdimm@lists.01.org>; Sun,  9 Jun 2019 22:08:24 -0700 (PDT)
Date: Mon, 10 Jun 2019 01:08:20 -0400 (EDT)
From: Pankaj Gupta <pagupta@redhat.com>
Message-ID: <1533125860.33764157.1560143300908.JavaMail.zimbra@redhat.com>
In-Reply-To: <CAPcyv4iW-UeHBs+qSii2Pk7Q2Nki6imGBTEORuxEAWgEMMp=nA@mail.gmail.com>
References: <20190521133713.31653-1-pagupta@redhat.com>
 <20190521133713.31653-5-pagupta@redhat.com>
 <CAPcyv4iW-UeHBs+qSii2Pk7Q2Nki6imGBTEORuxEAWgEMMp=nA@mail.gmail.com>
Subject: Re: [PATCH v10 4/7] dm: enable synchronous dax
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
Cc: cohuck@redhat.com, Jan Kara <jack@suse.cz>, KVM list <kvm@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, david <david@fromorbit.com>, Qemu Developers <qemu-devel@nongnu.org>, virtualization@lists.linux-foundation.org, device-mapper development <dm-devel@redhat.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Ross Zwisler <zwisler@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>, jstaron@google.com, linux-nvdimm <linux-nvdimm@lists.01.org>, David Hildenbrand <david@redhat.com>, Matthew Wilcox <willy@infradead.org>, Christoph Hellwig <hch@infradead.org>, Linux ACPI <linux-acpi@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, Len Brown <lenb@kernel.org>, Adam Borowski <kilobyte@angband.pl>, Randy Dunlap <rdunlap@infradead.org>, Rik van Riel <riel@surriel.com>, yuval shaia <yuval.shaia@oracle.com>, Stefan Hajnoczi <stefanha@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, lcapitulino@redhat.com, Kevin Wolf <kwolf@redhat.com>, Nitesh Narayan Lal <nilal@redhat.com>, Theodore Ts'o <tytso@mit.edu>, Xiao Guangrong <xiaoguangrong.eric@gmail.com>, Mike Snitzer <snitzer@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Igor Mammedov <imammedo@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>


> On Tue, May 21, 2019 at 6:43 AM Pankaj Gupta <pagupta@redhat.com> wrote:
> >
> >  This patch sets dax device 'DAXDEV_SYNC' flag if all the target
> >  devices of device mapper support synchrononous DAX. If device
> >  mapper consists of both synchronous and asynchronous dax devices,
> >  we don't set 'DAXDEV_SYNC' flag.
> >
> > Signed-off-by: Pankaj Gupta <pagupta@redhat.com>
> > ---
> >  drivers/md/dm-table.c | 14 ++++++++++++++
> >  1 file changed, 14 insertions(+)
> >
> > diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> > index cde3b49b2a91..1cce626ff576 100644
> > --- a/drivers/md/dm-table.c
> > +++ b/drivers/md/dm-table.c
> > @@ -886,10 +886,17 @@ static int device_supports_dax(struct dm_target *ti,
> > struct dm_dev *dev,
> >         return bdev_dax_supported(dev->bdev, PAGE_SIZE);
> >  }
> >
> > +static int device_synchronous(struct dm_target *ti, struct dm_dev *dev,
> > +                              sector_t start, sector_t len, void *data)
> > +{
> > +       return dax_synchronous(dev->dax_dev);
> > +}
> > +
> >  static bool dm_table_supports_dax(struct dm_table *t)
> >  {
> >         struct dm_target *ti;
> >         unsigned i;
> > +       bool dax_sync = true;
> >
> >         /* Ensure that all targets support DAX. */
> >         for (i = 0; i < dm_table_get_num_targets(t); i++) {
> > @@ -901,7 +908,14 @@ static bool dm_table_supports_dax(struct dm_table *t)
> >                 if (!ti->type->iterate_devices ||
> >                     !ti->type->iterate_devices(ti, device_supports_dax,
> >                     NULL))
> >                         return false;
> > +
> > +               /* Check devices support synchronous DAX */
> > +               if (dax_sync &&
> > +                   !ti->type->iterate_devices(ti, device_synchronous,
> > NULL))
> > +                       dax_sync = false;
> 
> Looks like this needs to be rebased on the current state of v5.2-rc,
> and then we can nudge Mike for an ack.

Sorry! for late reply due to vacations. I will rebase the series on v5.2-rc4 and
send a v11.

Thanks,
Pankaj
Yes, 
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

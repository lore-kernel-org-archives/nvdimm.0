Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com
 [IPv6:2607:f8b0:4864:20::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CD27821268F83
 for <linux-nvdimm@lists.01.org>; Wed, 15 May 2019 13:49:08 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id l203so866934oia.3
 for <linux-nvdimm@lists.01.org>; Wed, 15 May 2019 13:49:08 -0700 (PDT)
MIME-Version: 1.0
References: <20190514145422.16923-1-pagupta@redhat.com>
 <20190514145422.16923-5-pagupta@redhat.com>
In-Reply-To: <20190514145422.16923-5-pagupta@redhat.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 15 May 2019 13:48:57 -0700
Message-ID: <CAPcyv4jp+9eBQMX+KXhT1oZRkxLeCp9r9g9hFUCRw=OcuQ9wmQ@mail.gmail.com>
Subject: Re: [PATCH v9 4/7] dm: enable synchronous dax
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
To: Mike Snitzer <snitzer@redhat.com>
Cc: cohuck@redhat.com, Jan Kara <jack@suse.cz>, KVM list <kvm@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, david <david@fromorbit.com>, Qemu Developers <qemu-devel@nongnu.org>, virtualization@lists.linux-foundation.org, device-mapper development <dm-devel@redhat.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Ross Zwisler <zwisler@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>, jstaron@google.com, linux-nvdimm <linux-nvdimm@lists.01.org>, David Hildenbrand <david@redhat.com>, Matthew Wilcox <willy@infradead.org>, Christoph Hellwig <hch@infradead.org>, Linux ACPI <linux-acpi@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, Len Brown <lenb@kernel.org>, Adam Borowski <kilobyte@angband.pl>, Rik van Riel <riel@surriel.com>, yuval shaia <yuval.shaia@oracle.com>, Stefan Hajnoczi <stefanha@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, lcapitulino@redhat.com, Kevin Wolf <kwolf@redhat.com>, Nitesh Narayan Lal <nilal@redhat.com>, Theodore Ts'o <tytso@mit.edu>, Xiao Guangrong <xiaoguangrong.eric@gmail.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Igor Mammedov <imammedo@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

[ add Mike and dm-devel ]

Mike, any concerns with the below addition to the device-mapper-dax
implementation?

On Tue, May 14, 2019 at 7:58 AM Pankaj Gupta <pagupta@redhat.com> wrote:
>
>  This patch sets dax device 'DAXDEV_SYNC' flag if all the target
>  devices of device mapper support synchrononous DAX. If device
>  mapper consists of both synchronous and asynchronous dax devices,
>  we don't set 'DAXDEV_SYNC' flag.
>
> Signed-off-by: Pankaj Gupta <pagupta@redhat.com>
> ---
>  drivers/md/dm-table.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
>
> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> index cde3b49b2a91..1cce626ff576 100644
> --- a/drivers/md/dm-table.c
> +++ b/drivers/md/dm-table.c
> @@ -886,10 +886,17 @@ static int device_supports_dax(struct dm_target *ti, struct dm_dev *dev,
>         return bdev_dax_supported(dev->bdev, PAGE_SIZE);
>  }
>
> +static int device_synchronous(struct dm_target *ti, struct dm_dev *dev,
> +                              sector_t start, sector_t len, void *data)
> +{
> +       return dax_synchronous(dev->dax_dev);
> +}
> +
>  static bool dm_table_supports_dax(struct dm_table *t)
>  {
>         struct dm_target *ti;
>         unsigned i;
> +       bool dax_sync = true;
>
>         /* Ensure that all targets support DAX. */
>         for (i = 0; i < dm_table_get_num_targets(t); i++) {
> @@ -901,7 +908,14 @@ static bool dm_table_supports_dax(struct dm_table *t)
>                 if (!ti->type->iterate_devices ||
>                     !ti->type->iterate_devices(ti, device_supports_dax, NULL))
>                         return false;
> +
> +               /* Check devices support synchronous DAX */
> +               if (dax_sync &&
> +                   !ti->type->iterate_devices(ti, device_synchronous, NULL))
> +                       dax_sync = false;
>         }
> +       if (dax_sync)
> +               set_dax_synchronous(t->md->dax_dev);
>
>         return true;
>  }
> --
> 2.20.1
>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x242.google.com (mail-ot0-x242.google.com
 [IPv6:2607:f8b0:4003:c0f::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C718622526481
 for <linux-nvdimm@lists.01.org>; Wed,  4 Apr 2018 17:03:08 -0700 (PDT)
Received: by mail-ot0-x242.google.com with SMTP id h55-v6so23816444ote.9
 for <linux-nvdimm@lists.01.org>; Wed, 04 Apr 2018 17:03:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <152287929452.28903.15383389230749046740.stgit@djiang5-desk3.ch.intel.com>
References: <152287929452.28903.15383389230749046740.stgit@djiang5-desk3.ch.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 4 Apr 2018 17:03:07 -0700
Message-ID: <CAPcyv4hZfNOG15guKE0Lq=QoFr8DZerEH=1=OjnrEY2trPXNcw@mail.gmail.com>
Subject: Re: [PATCH] dax: adding fsync/msync support for device DAX
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
To: Dave Jiang <dave.jiang@intel.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Include lkml on the next posting as well.

On Wed, Apr 4, 2018 at 3:01 PM, Dave Jiang <dave.jiang@intel.com> wrote:
> When msync() is called on a device dax region, eventually ops->fsync() is
> called. By providing fsync in the device dax file operations, we can provide
> support for both. nvdimm_flush() for the nd_region is called when msync/fsync
> is called in order to provide deep flush to the user app through standard POSIX
> calls.
>

Lets clarify the justification:

"Currently, fsdax applications can assume that if they call fsync or
msync on a dax mapped file that any pending writes that have been
flushed out of the cpu cache will be also be flushed to the lowest
possible persistence / failure domain available on the platform. In
typical scenarios the platform ADR capability handles marshaling
writes that have reached global visibility to persistence. In
exceptional cases where ADR fails to complete its operation software
can detect that scenario the the "last shutdown" health status check
and otherwise mitigate the effects of an ADR failure by protecting
metadata with the WPQ flush. In other words, enabling device-dax to
optionally trigger WPQ Flush on msync() allows applications to have
common implementation for persistence domain handling across fs-dax
and device-dax."


> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  drivers/dax/dax-private.h |    1 +
>  drivers/dax/device-dax.h  |    2 ++
>  drivers/dax/device.c      |   19 +++++++++++++++++++
>  drivers/dax/pmem.c        |   10 ++++++++++
>  4 files changed, 32 insertions(+)
>
> diff --git a/drivers/dax/dax-private.h b/drivers/dax/dax-private.h
> index b6fc4f04636d..5fc20191c89e 100644
> --- a/drivers/dax/dax-private.h
> +++ b/drivers/dax/dax-private.h
> @@ -35,6 +35,7 @@ struct dax_region {
>         unsigned int align;
>         struct resource res;
>         unsigned long pfn_flags;
> +       void (*sync)(struct device *);
>  };
>
>  /**
> diff --git a/drivers/dax/device-dax.h b/drivers/dax/device-dax.h
> index 688b051750bd..651f2e763058 100644
> --- a/drivers/dax/device-dax.h
> +++ b/drivers/dax/device-dax.h
> @@ -22,4 +22,6 @@ struct dax_region *alloc_dax_region(struct device *parent,
>                 void *addr, unsigned long flags);
>  struct dev_dax *devm_create_dev_dax(struct dax_region *dax_region,
>                 int id, struct resource *res, int count);
> +void dax_set_sync(struct dax_region *dax_region, void (*sync)(struct device *dev));
> +
>  #endif /* __DEVICE_DAX_H__ */
> diff --git a/drivers/dax/device.c b/drivers/dax/device.c
> index 37be5a306c8f..5341760cc987 100644
> --- a/drivers/dax/device.c
> +++ b/drivers/dax/device.c
> @@ -523,6 +523,24 @@ static int dax_release(struct inode *inode, struct file *filp)
>         return 0;
>  }
>
> +void dax_set_sync(struct dax_region *dax_region, void (*sync)(struct device *))
> +{
> +       dax_region->sync = sync;
> +}
> +EXPORT_SYMBOL_GPL(dax_set_sync);

We don't need dax_set_sync(), the dax_pmem driver set up the
dax_region in the first place, it can set the callback at that time.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

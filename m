Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-yw0-x22b.google.com (mail-yw0-x22b.google.com
 [IPv6:2607:f8b0:4002:c05::22b])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 23A5E21BADAB1
 for <linux-nvdimm@lists.01.org>; Fri, 30 Jun 2017 09:46:01 -0700 (PDT)
Received: by mail-yw0-x22b.google.com with SMTP id 63so51577924ywr.0
 for <linux-nvdimm@lists.01.org>; Fri, 30 Jun 2017 09:47:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170612222511.22030-1-toshi.kani@hpe.com>
References: <20170612222511.22030-1-toshi.kani@hpe.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 30 Jun 2017 09:47:33 -0700
Message-ID: <CAPcyv4gL-C2exjbZDibnFU59S267EEmV8d6uoLtH_RndtvEy=w@mail.gmail.com>
Subject: Re: [PATCH v2] libnvdimm, pmem: Add sysfs notifications to badblocks
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
To: Toshi Kani <toshi.kani@hpe.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jun 12, 2017 at 3:25 PM, Toshi Kani <toshi.kani@hpe.com> wrote:
> Sysfs "badblocks" information may be updated during run-time that:
>  - MCE, SCI, and sysfs "scrub" may add new bad blocks
>  - Writes and ioctl() may clear bad blocks
>
> Add support to send sysfs notifications to sysfs "badblocks" file
> under region and pmem directories when their badblocks information
> is re-evaluated (but is not necessarily changed) during run-time.
>
> Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Vishal Verma <vishal.l.verma@intel.com>
> Cc: Linda Knippers <linda.knippers@hpe.com>
> ---
> v2: Send notifications for the clearing case
> ---
>  drivers/nvdimm/bus.c    |    3 +++
>  drivers/nvdimm/nd.h     |    1 +
>  drivers/nvdimm/pmem.c   |   14 ++++++++++++++
>  drivers/nvdimm/pmem.h   |    1 +
>  drivers/nvdimm/region.c |   12 ++++++++++--
>  5 files changed, 29 insertions(+), 2 deletions(-)
>
[..]
> diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
> index c544d46..6c14c72 100644
> --- a/drivers/nvdimm/pmem.c
> +++ b/drivers/nvdimm/pmem.c
[..]
> @@ -377,6 +379,13 @@ static int pmem_attach_disk(struct device *dev,
>
>         revalidate_disk(disk);
>
> +       pmem->bb_state = sysfs_get_dirent(disk_to_dev(disk)->kobj.sd,
> +                                         "badblocks");
> +       if (pmem->bb_state)
> +               sysfs_put(pmem->bb_state);

Sorry I missed this on the first review, but this looks broken. We
need to hold the reference for as long as we might trigger
notifications, so the sysfs_put() should wait until
pmem_release_disk().

[..]
> diff --git a/drivers/nvdimm/region.c b/drivers/nvdimm/region.c
> index 869a886..ca94029 100644
> --- a/drivers/nvdimm/region.c
> +++ b/drivers/nvdimm/region.c
> @@ -58,10 +58,16 @@ static int nd_region_probe(struct device *dev)
>
>                 if (devm_init_badblocks(dev, &nd_region->bb))
>                         return -ENODEV;
> +               nd_region->bb_state = sysfs_get_dirent(nd_region->dev.kobj.sd,
> +                                                      "badblocks");
> +               if (nd_region->bb_state)
> +                       sysfs_put(nd_region->bb_state);

...same here. This should wait until we tear down the region.

I'll take a look at an incremental fix patch.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

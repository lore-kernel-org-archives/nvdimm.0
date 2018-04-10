Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x241.google.com (mail-oi0-x241.google.com
 [IPv6:2607:f8b0:4003:c06::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 998A322618154
 for <linux-nvdimm@lists.01.org>; Tue, 10 Apr 2018 13:46:26 -0700 (PDT)
Received: by mail-oi0-x241.google.com with SMTP id 126-v6so12531535oig.0
 for <linux-nvdimm@lists.01.org>; Tue, 10 Apr 2018 13:46:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <152339295872.17800.11928214580818704332.stgit@djiang5-desk3.ch.intel.com>
References: <152339295872.17800.11928214580818704332.stgit@djiang5-desk3.ch.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 10 Apr 2018 13:46:25 -0700
Message-ID: <CAPcyv4iwj_0PRvdgB-Cp5dqTnVZeWjeUdLV_rdXyH1e1K1QBxQ@mail.gmail.com>
Subject: Re: [PATCH] libnvdimm: fix NULL ptr access in nvdimm_flush when
 region is disabled
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

On Tue, Apr 10, 2018 at 1:42 PM, Dave Jiang <dave.jiang@intel.com> wrote:
> When a region is disabled, there is no driver attached. Therefore
> dev->driverdata is NULL. An attempt to write to regionN/deep_flush via sysfs
> would cause a NULL pointer dereference. Bail when dev->driver is NULL to
> protect this scenario.
>
> Fix: ab630891ce0eb(libnvdimm, region: sysfs trigger for nvdimm_flush())
>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  drivers/nvdimm/region_devs.c |    4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
> index a612be6f019d..d5619b7feb6a 100644
> --- a/drivers/nvdimm/region_devs.c
> +++ b/drivers/nvdimm/region_devs.c
> @@ -1074,6 +1074,10 @@ void nvdimm_flush(struct nd_region *nd_region)
>         struct nd_region_data *ndrd = dev_get_drvdata(&nd_region->dev);
>         int i, idx;
>
> +       /* protect against disabled region */
> +       if (!nd_region->dev.driver)
> +               return;
> +

Move this to deep_flush_store(). That's the only caller that can
trigger nvdimm_flush() while the region might be disabled, and that
needs to return an error code.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

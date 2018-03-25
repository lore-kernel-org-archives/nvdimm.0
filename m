Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pl0-x241.google.com (mail-pl0-x241.google.com
 [IPv6:2607:f8b0:400e:c01::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5ECF4224AE8A4
 for <linux-nvdimm@lists.01.org>; Sun, 25 Mar 2018 16:18:20 -0700 (PDT)
Received: by mail-pl0-x241.google.com with SMTP id c11-v6so10824079plo.0
 for <linux-nvdimm@lists.01.org>; Sun, 25 Mar 2018 16:24:55 -0700 (PDT)
Date: Mon, 26 Mar 2018 10:24:46 +1100
From: Balbir Singh <bsingharora@gmail.com>
Subject: Re: [PATCH 2/6] libnvdimm: Add nd_region_destroy()
Message-ID: <20180326102446.60358bf6@gmail.com>
In-Reply-To: <20180323081209.31387-2-oohall@gmail.com>
References: <20180323081209.31387-1-oohall@gmail.com>
 <20180323081209.31387-2-oohall@gmail.com>
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
To: Oliver O'Halloran <oohall@gmail.com>
Cc: devicetree@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Fri, 23 Mar 2018 19:12:05 +1100
Oliver O'Halloran <oohall@gmail.com> wrote:

> Currently there's no way to remove a region from and nvdimm_bus without
> tearing down the whole bus. This patch adds an API for removing a single
> region from the bus so that we can implement a sensible unbind operation
> for the of_nd_region platform driver.
> 
> Signed-off-by: Oliver O'Halloran <oohall@gmail.com>
> ---
>  drivers/nvdimm/region_devs.c | 6 ++++++
>  include/linux/libnvdimm.h    | 1 +
>  2 files changed, 7 insertions(+)
> 
> diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
> index 2f1d5771100e..76f46fd1fae0 100644
> --- a/drivers/nvdimm/region_devs.c
> +++ b/drivers/nvdimm/region_devs.c
> @@ -1039,6 +1039,12 @@ struct nd_region *nvdimm_blk_region_create(struct nvdimm_bus *nvdimm_bus,
>  }
>  EXPORT_SYMBOL_GPL(nvdimm_blk_region_create);
>  
> +void nd_region_destroy(struct nd_region *region)
> +{
> +	nd_device_unregister(&region->dev, ND_SYNC);

child_unregister seems to do the same thing, but is expected to be used
as a callback from device_for_each_child()

I'd suggest we merge the two and rename child_unregister and nd_region_unregister

Balbir Singh.

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

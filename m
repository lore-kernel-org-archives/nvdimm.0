Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x243.google.com (mail-oi0-x243.google.com
 [IPv6:2607:f8b0:4003:c06::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 31F192214673A
 for <linux-nvdimm@lists.01.org>; Fri, 23 Mar 2018 09:53:13 -0700 (PDT)
Received: by mail-oi0-x243.google.com with SMTP id 71-v6so10884682oie.12
 for <linux-nvdimm@lists.01.org>; Fri, 23 Mar 2018 09:59:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180323081209.31387-2-oohall@gmail.com>
References: <20180323081209.31387-1-oohall@gmail.com>
 <20180323081209.31387-2-oohall@gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 23 Mar 2018 09:59:45 -0700
Message-ID: <CAPcyv4iGX+2idBpWAtcruyjyxxN1NkixzKzT1+hbCm718pSb-w@mail.gmail.com>
Subject: Re: [PATCH 2/6] libnvdimm: Add nd_region_destroy()
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
Cc: Device Tree <devicetree@vger.kernel.org>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Mar 23, 2018 at 1:12 AM, Oliver O'Halloran <oohall@gmail.com> wrote:
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

Let's put this in the "nvdimm_" namespace so it pairs with the
nvdimm_*_region_create() apis.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

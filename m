Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x242.google.com (mail-oi0-x242.google.com
 [IPv6:2607:f8b0:4003:c06::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5B49220347146
 for <linux-nvdimm@lists.01.org>; Thu, 19 Oct 2017 17:05:40 -0700 (PDT)
Received: by mail-oi0-x242.google.com with SMTP id v9so17659086oif.13
 for <linux-nvdimm@lists.01.org>; Thu, 19 Oct 2017 17:09:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20171018182155.6054-1-ross.zwisler@linux.intel.com>
References: <CAPcyv4gNYekwo1DQ9fOCzdtixvAUn5YnZY0wKfxQaeRppwdUPQ@mail.gmail.com>
 <20171018182155.6054-1-ross.zwisler@linux.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 19 Oct 2017 17:09:18 -0700
Message-ID: <CAPcyv4hzQ1Zscy2qkxuc2AG8yEueT2mQhV1q8uCu0Gpjhekk8w@mail.gmail.com>
Subject: Re: [PATCH v2] dev/dax: fix uninitialized variable build warning
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Oct 18, 2017 at 11:21 AM, Ross Zwisler
<ross.zwisler@linux.intel.com> wrote:
> Fix this build warning:
>
> warning: 'phys' may be used uninitialized in this function
> [-Wuninitialized]
>
> As reported here:
>
> https://lkml.org/lkml/2017/10/16/152
> http://kisskb.ellerman.id.au/kisskb/buildresult/13181373/log/
>
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> ---
>  drivers/dax/device.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/dax/device.c b/drivers/dax/device.c
> index e9f3b3e..6833ada 100644
> --- a/drivers/dax/device.c
> +++ b/drivers/dax/device.c
> @@ -222,7 +222,8 @@ __weak phys_addr_t dax_pgoff_to_phys(struct dev_dax *dev_dax, pgoff_t pgoff,
>                 unsigned long size)
>  {
>         struct resource *res;
> -       phys_addr_t phys;
> +       /* gcc-4.6.3-nolibc for i386 complains that this is uninitialized */
> +       phys_addr_t uninitialized_var(phys);

Thanks Ross, applied.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

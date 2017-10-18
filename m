Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x242.google.com (mail-oi0-x242.google.com
 [IPv6:2607:f8b0:4003:c06::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7D0D521F3884B
 for <linux-nvdimm@lists.01.org>; Wed, 18 Oct 2017 08:53:12 -0700 (PDT)
Received: by mail-oi0-x242.google.com with SMTP id v132so9752882oie.1
 for <linux-nvdimm@lists.01.org>; Wed, 18 Oct 2017 08:56:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20171018154006.15431-1-ross.zwisler@linux.intel.com>
References: <20171018154006.15431-1-ross.zwisler@linux.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 18 Oct 2017 08:56:48 -0700
Message-ID: <CAPcyv4gNYekwo1DQ9fOCzdtixvAUn5YnZY0wKfxQaeRppwdUPQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] dev/dax: fix uninitialized variable build warning
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

On Wed, Oct 18, 2017 at 8:40 AM, Ross Zwisler
<ross.zwisler@linux.intel.com> wrote:
> Fix this build warning:
>
> warning: 'phys' may be used uninitialized in this function
> [-Wuninitialized]
>
> As reported here:
>
> https://lkml.org/lkml/2017/10/16/152
>
> This should have no functional change because you can only get into the if
> statement in dax_pgoff_to_phys() that is complaining about 'phys' being
> uninitialized if you broke out early in the above loop, in which case
> 'phys' will be set.

Then the compiler is wrong.

>
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> ---
>  drivers/dax/device.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/dax/device.c b/drivers/dax/device.c
> index e9f3b3e..4aca0a2 100644
> --- a/drivers/dax/device.c
> +++ b/drivers/dax/device.c
> @@ -222,7 +222,7 @@ __weak phys_addr_t dax_pgoff_to_phys(struct dev_dax *dev_dax, pgoff_t pgoff,
>                 unsigned long size)
>  {
>         struct resource *res;
> -       phys_addr_t phys;
> +       phys_addr_t phys = 0;

We have uninitialized_var() for silencing the compiler, and since the
report is bogus we might note with a comment which gcc had a problem
with this routine.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

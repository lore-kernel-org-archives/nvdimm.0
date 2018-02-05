Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7F64A21F0DA47
 for <linux-nvdimm@lists.01.org>; Mon,  5 Feb 2018 10:14:59 -0800 (PST)
Date: Mon, 5 Feb 2018 11:20:39 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH] libnvdimm: remove redundant assignment to pointer 'dev'
Message-ID: <20180205182039.GA7891@linux.intel.com>
References: <20180205140852.14110-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180205140852.14110-1-colin.king@canonical.com>
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
To: Colin King <colin.king@canonical.com>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Feb 05, 2018 at 02:08:52PM +0000, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Pointer dev is being assigned a value that is never read, it is being
> re-assigned the same value later on, hence the initialization is redundant
> and can be removed.
> 
> Cleans up clang warning:
> drivers/nvdimm/pfn_devs.c:307:17: warning: Value stored to 'dev' during
> its initialization is never read
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>

More importantly this fixes a potential NULL pointer dereference.  nd_pfn
is checked for NULL a few lines down, but we would have crashed here trying to
get nd_pfn->dev.

We can append the above info to the changelog when we apply.

> ---
>  drivers/nvdimm/pfn_devs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
> index f5c4e8c6e29d..2f4d18752c97 100644
> --- a/drivers/nvdimm/pfn_devs.c
> +++ b/drivers/nvdimm/pfn_devs.c
> @@ -304,7 +304,7 @@ static const struct attribute_group *nd_pfn_attribute_groups[] = {
>  struct device *nd_pfn_devinit(struct nd_pfn *nd_pfn,
>  		struct nd_namespace_common *ndns)
>  {
> -	struct device *dev = &nd_pfn->dev;
> +	struct device *dev;
>  
>  	if (!nd_pfn)
>  		return NULL;
> -- 
> 2.15.1
> 
> _______________________________________________
> Linux-nvdimm mailing list
> Linux-nvdimm@lists.01.org
> https://lists.01.org/mailman/listinfo/linux-nvdimm
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

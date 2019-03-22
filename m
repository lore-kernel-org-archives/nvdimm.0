Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0CC44211E82F1
 for <linux-nvdimm@lists.01.org>; Fri, 22 Mar 2019 15:49:31 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH] nvdimm: btt_devs: fix a NULL pointer dereference and a
 memory leak
Date: Fri, 22 Mar 2019 22:49:29 +0000
Message-ID: <eea1b50fe8c76d45fef0aaca1878c30fa8f2cbde.camel@intel.com>
References: <20190312081529.4889-1-kjlu@umn.edu>
In-Reply-To: <20190312081529.4889-1-kjlu@umn.edu>
Content-Language: en-US
Content-ID: <B6878E8040DC78448B070CFD65C378F3@intel.com>
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
To: "kjlu@umn.edu" <kjlu@umn.edu>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "pakki001@umn.edu" <pakki001@umn.edu>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "zwisler@kernel.org" <zwisler@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, 2019-03-12 at 03:15 -0500, Kangjie Lu wrote:
> In case kmemdup fails, the fix releases resources and returns to
> avoid the NULL pointer dereference.
> Also, the error paths in the following code should release
> resources to avoid memory leaks.
> 
> Signed-off-by: Kangjie Lu <kjlu@umn.edu>
> ---
>  drivers/nvdimm/btt_devs.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 

Looks good,
Reviewed-by: Vishal Verma <vishal.l.verma@intel.com>

> diff --git a/drivers/nvdimm/btt_devs.c b/drivers/nvdimm/btt_devs.c
> index 795ad4ff35ca..565ea0b6f765 100644
> --- a/drivers/nvdimm/btt_devs.c
> +++ b/drivers/nvdimm/btt_devs.c
> @@ -196,8 +196,13 @@ static struct device *__nd_btt_create(struct
> nd_region *nd_region,
>  	}
>  
>  	nd_btt->lbasize = lbasize;
> -	if (uuid)
> +	if (uuid) {
>  		uuid = kmemdup(uuid, 16, GFP_KERNEL);
> +		if (!uuid) {
> +			kfree(nd_btt);
> +			return NULL;
> +		}
> +	}
>  	nd_btt->uuid = uuid;
>  	dev = &nd_btt->dev;
>  	dev_set_name(dev, "btt%d.%d", nd_region->id, nd_btt->id);
> @@ -209,6 +214,7 @@ static struct device *__nd_btt_create(struct
> nd_region *nd_region,
>  		dev_dbg(&ndns->dev, "failed, already claimed by %s\n",
>  				dev_name(ndns->claim));
>  		put_device(dev);
> +		kfree(uuid);
>  		return NULL;
>  	}
>  	return dev;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

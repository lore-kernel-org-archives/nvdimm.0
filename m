From: Mukesh Ojha <mojha@codeaurora.org>
Subject: Re: [PATCH v4] nvdimm: btt_devs: fix a NULL pointer dereference
Date: Tue, 26 Mar 2019 15:53:07 +0530
Message-ID: <5fa84f18-7253-2543-57e4-6a9e2b2da716@codeaurora.org>
References: <20190325215527.12574-1-pakki001@umn.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190325215527.12574-1-pakki001@umn.edu>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Aditya Pakki <pakki001@umn.edu>
Cc: kjlu@umn.edu, Vishal Verma <vishal.l.verma@intel.com>, Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>, Keith Busch <keith.busch@intel.com>, Ira Weiny <ira.weiny@intel.com>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org
List-Id: linux-nvdimm@lists.01.org


On 3/26/2019 3:25 AM, Aditya Pakki wrote:
> In case kmemdup fails, the fix releases resources and returns to
> avoid the NULL pointer dereference.
>
> Signed-off-by: Aditya Pakki <pakki001@umn.edu>
>
> ---
> v3: Move kfree(nd_btt) to goto block.
> v2: Replace incorrect kfree with ida_simple_remove, suggested by
> Johannes Thumshirn
> v1: Free nd_btt->id in case of failure and avoid double free, suggested
> by Dan Williams
> ---
>   drivers/nvdimm/btt_devs.c | 18 +++++++++++++-----
>   1 file changed, 13 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/nvdimm/btt_devs.c b/drivers/nvdimm/btt_devs.c
> index b72a303176c7..9486acc08402 100644
> --- a/drivers/nvdimm/btt_devs.c
> +++ b/drivers/nvdimm/btt_devs.c
> @@ -198,14 +198,15 @@ static struct device *__nd_btt_create(struct nd_region *nd_region,
>   		return NULL;
>   
>   	nd_btt->id = ida_simple_get(&nd_region->btt_ida, 0, 0, GFP_KERNEL);
> -	if (nd_btt->id < 0) {
> -		kfree(nd_btt);
> -		return NULL;
> -	}
> +	if (nd_btt->id < 0)
> +		goto out_nd_btt;
>   
>   	nd_btt->lbasize = lbasize;
> -	if (uuid)
> +	if (uuid) {
>   		uuid = kmemdup(uuid, 16, GFP_KERNEL);
> +		if (!uuid)
> +			goto out_put_id;
> +	}
>   	nd_btt->uuid = uuid;
>   	dev = &nd_btt->dev;
>   	dev_set_name(dev, "btt%d.%d", nd_region->id, nd_btt->id);
> @@ -220,6 +221,13 @@ static struct device *__nd_btt_create(struct nd_region *nd_region,
>   		return NULL;
>   	}
>   	return dev;
> +
> +out_put_id:
> +	ida_simple_remove(&nd_region->btt_ida, nd_btt->id);
> +
> +out_nd_btt:
> +	kfree(nd_btt);
> +	return NULL;
>   }
>   
>   struct device *nd_btt_create(struct nd_region *nd_region)


you have to take care of this below if block(true) as well as you are 
touching the function.
  if (ndns && !__nd_attach_ndns(&nd_btt->dev, ndns, &nd_btt->ndns)) {

Thanks,
Mukesh

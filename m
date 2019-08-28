Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from gateway30.websitewelcome.com (gateway30.websitewelcome.com
 [192.185.193.11])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C4CB320215F4A
 for <linux-nvdimm@lists.01.org>; Wed, 28 Aug 2019 11:32:28 -0700 (PDT)
Received: from cm11.websitewelcome.com (cm11.websitewelcome.com [100.42.49.5])
 by gateway30.websitewelcome.com (Postfix) with ESMTP id 6C6513C4C2
 for <linux-nvdimm@lists.01.org>; Wed, 28 Aug 2019 13:30:27 -0500 (CDT)
Subject: Re: [PATCH] libnvdimm, region: Use struct_size() in kzalloc()
References: <20190610210613.GA21989@embeddedor>
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-ID: <3abfb317-76cc-f9a0-243f-9b493a524a98@embeddedor.com>
Date: Wed, 28 Aug 2019 13:30:24 -0500
MIME-Version: 1.0
In-Reply-To: <20190610210613.GA21989@embeddedor>
Content-Language: en-US
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
To: Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, Keith Busch <keith.busch@intel.com>, Ira Weiny <ira.weiny@intel.com>
Cc: linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Hi all,

Friendly ping:

Who can take this, please?

Thanks
--
Gustavo

On 6/10/19 4:06 PM, Gustavo A. R. Silva wrote:
> One of the more common cases of allocation size calculations is finding
> the size of a structure that has a zero-sized array at the end, along
> with memory for some number of elements for that array. For example:
> 
> struct nd_region {
> 	...
>         struct nd_mapping mapping[0];
> };
> 
> instance = kzalloc(sizeof(struct nd_region) + sizeof(struct nd_mapping) *
>                           count, GFP_KERNEL);
> 
> Instead of leaving these open-coded and prone to type mistakes, we can
> now use the new struct_size() helper:
> 
> instance = kzalloc(struct_size(instance, mapping, count), GFP_KERNEL);
> 
> This code was detected with the help of Coccinelle.
> 
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> ---
>  drivers/nvdimm/region_devs.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
> index b4ef7d9ff22e..88becc87e234 100644
> --- a/drivers/nvdimm/region_devs.c
> +++ b/drivers/nvdimm/region_devs.c
> @@ -1027,10 +1027,9 @@ static struct nd_region *nd_region_create(struct nvdimm_bus *nvdimm_bus,
>  		}
>  		region_buf = ndbr;
>  	} else {
> -		nd_region = kzalloc(sizeof(struct nd_region)
> -				+ sizeof(struct nd_mapping)
> -				* ndr_desc->num_mappings,
> -				GFP_KERNEL);
> +		nd_region = kzalloc(struct_size(nd_region, mapping,
> +						ndr_desc->num_mappings),
> +				    GFP_KERNEL);
>  		region_buf = nd_region;
>  	}
>  
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

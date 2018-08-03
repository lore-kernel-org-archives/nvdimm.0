Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EB3B9210D8528
 for <linux-nvdimm@lists.01.org>; Fri,  3 Aug 2018 10:13:40 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH] libnvdimm, bus: check id immediately following
 ida_simple_get
Date: Fri, 3 Aug 2018 17:13:39 +0000
Message-ID: <1533316417.8557.72.camel@intel.com>
References: <1533298113-17495-1-git-send-email-oceanhehy@gmail.com>
In-Reply-To: <1533298113-17495-1-git-send-email-oceanhehy@gmail.com>
Content-Language: en-US
Content-ID: <F108586DC8F90E448DF4CB33713BFEE6@intel.com>
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
To: "Williams, Dan J" <dan.j.williams@intel.com>, "ross.zwisler@linux.intel.com" <ross.zwisler@linux.intel.com>, "oceanhehy@gmail.com" <oceanhehy@gmail.com>, "Jiang, Dave" <dave.jiang@intel.com>
Cc: "hehy1@lenovo.com" <hehy1@lenovo.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>


On Fri, 2018-08-03 at 08:08 -0400, Ocean He wrote:
> From: Ocean He <hehy1@lenovo.com>
> 
> The id check was not executed immediately following ida_simple_get.
> Just
> change the codes position, without function change.
> 
> Signed-off-by: Ocean He <hehy1@lenovo.com>
> ---
>  drivers/nvdimm/bus.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Looks good, feel free to add
Reviewed-by: Vishal Verma <vishal.l.verma@intel.com>

> 
> diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
> index 27902a8..ab28e7c 100644
> --- a/drivers/nvdimm/bus.c
> +++ b/drivers/nvdimm/bus.c
> @@ -350,12 +350,12 @@ struct nvdimm_bus *nvdimm_bus_register(struct
> device *parent,
>  	INIT_LIST_HEAD(&nvdimm_bus->mapping_list);
>  	init_waitqueue_head(&nvdimm_bus->probe_wait);
>  	nvdimm_bus->id = ida_simple_get(&nd_ida, 0, 0, GFP_KERNEL);
> -	mutex_init(&nvdimm_bus->reconfig_mutex);
> -	badrange_init(&nvdimm_bus->badrange);
>  	if (nvdimm_bus->id < 0) {
>  		kfree(nvdimm_bus);
>  		return NULL;
>  	}
> +	mutex_init(&nvdimm_bus->reconfig_mutex);
> +	badrange_init(&nvdimm_bus->badrange);
>  	nvdimm_bus->nd_desc = nd_desc;
>  	nvdimm_bus->dev.parent = parent;
>  	nvdimm_bus->dev.release = nvdimm_bus_release;
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

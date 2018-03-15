Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C42372258AEFA
 for <linux-nvdimm@lists.01.org>; Thu, 15 Mar 2018 16:40:18 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [ndctl PATCH v2] ndctl, list: fix namespace json object parenting
Date: Thu, 15 Mar 2018 23:46:41 +0000
Message-ID: <1521157599.28441.4.camel@intel.com>
References: <152098394967.38244.14033629842721195081.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <152098394967.38244.14033629842721195081.stgit@dwillia2-desk3.amr.corp.intel.com>
Content-Language: en-US
Content-ID: <096303EA4969BD4AB84124DAC0F9A076@intel.com>
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
To: "Williams, Dan J" <dan.j.williams@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>


On Tue, 2018-03-13 at 16:33 -0700, Dan Williams wrote:
> When listing namespaces and regions a generic jplatform object is
> created to house the regions array. However, commit f8cc6fee4e4d
> "ndctl,
> list: refactor core topology walking into util_filter_walk()"
> inadvertently added namespaces to that jplatform, and otherwise
> failed
> to parent namespaces to their proper parent region.
> 
>     # ndctl list -RNu
>     {
>       "regions":[
>         {
>           "dev":"region1",
>           "size":"511.00 GiB (548.68 GB)",
>           "available_size":0,
>           "type":"pmem",
>           "numa_node":0,
>           "namespaces":[
>             {
>               "dev":"namespace1.0",
>               "mode":"raw",
>               "size":"511.00 GiB (548.68 GB)",
>               "sector_size":512,
>               "blockdev":"pmem1",
>               "numa_node":0
>             },
>             {
>               "dev":"namespace0.0", <------- wrong region
>               "mode":"fsdax",
>               "size":"4.00 GiB (4.29 GB)",
>               "sector_size":512,
>               "blockdev":"pmem0",
>               "numa_node":0
>             }
>           ]
>         },
>         {
>           "dev":"region0",
>           "size":"4.00 GiB (4.29 GB)",
>           "available_size":0,
>           "type":"pmem"
>         }
>       ],
>       "namespaces":[  <------ we already listed the namespaces
>         {
>           "dev":"namespace1.0",
>           "mode":"raw",
>           "size":"511.00 GiB (548.68 GB)",
>           "sector_size":512,
>           "blockdev":"pmem1",
>           "numa_node":0
>         },
>         {
>           "dev":"namespace0.0",
>           "mode":"fsdax",
>           "size":"4.00 GiB (4.29 GB)",
>           "sector_size":512,
>           "blockdev":"pmem0",
>           "numa_node":0
>         }
>       ]
>     }
>     ndctl: json_object.c:188: json_object_put: Assertion `jso-
> >_ref_count > 0' failed.
>     Aborted (core dumped)  <------ not ideal
> 
> Clear out the jnamespaces tracking as the filter walk transitions to
> the
> next region, and make sure that jnamepsaces is not added to jplatform
> when regions are being displayed.
> 
> Fixes: f8cc6fee4e4d(" ndctl, list: refactor core topology
> walking...")
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
> v2: fix breaking namespace arrays on region boundaries
> 
>  ndctl/list.c |    9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)

Looks good, queued.

> 
> diff --git a/ndctl/list.c b/ndctl/list.c
> index 0ca5b6dee5eb..fe8036eabc3b 100644
> --- a/ndctl/list.c
> +++ b/ndctl/list.c
> @@ -245,6 +245,13 @@ static bool filter_region(struct ndctl_region
> *region,
>  	lfa->jregion = jregion;
>  
>  	/*
> +	 * We've started a new region, any previous jnamespaces will
> +	 * have been parented to the last region. Clear out
> jnamespaces
> +	 * so we start a new array per region.
> +	 */
> +	lfa->jnamespaces = NULL;
> +
> +	/*
>  	 * Without a bus we are collecting regions anonymously
> across
>  	 * the platform.
>  	 */
> @@ -366,7 +373,7 @@ static int list_display(struct list_filter_arg
> *lfa)
>  			json_object_object_add(jplatform, "dimms",
> jdimms);
>  		if (jregions)
>  			json_object_object_add(jplatform, "regions",
> jregions);
> -		if (jnamespaces)
> +		if (jnamespaces && !jregions)
>  			json_object_object_add(jplatform,
> "namespaces",
>  					jnamespaces);
>  		printf("%s\n",
> json_object_to_json_string_ext(jplatform,
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

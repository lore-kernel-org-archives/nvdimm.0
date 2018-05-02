Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5091F20957B16
 for <linux-nvdimm@lists.01.org>; Wed,  2 May 2018 14:37:50 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH v2] ndctl, filter: fix "keyword 'all' is ignored" in
 util_<obj>_filter()
Date: Wed, 2 May 2018 21:37:48 +0000
Message-ID: <1525297066.5237.16.camel@intel.com>
References: <20180426005648.13028-1-qi.fuli@jp.fujitsu.com>
In-Reply-To: <20180426005648.13028-1-qi.fuli@jp.fujitsu.com>
Content-Language: en-US
Content-ID: <E458195FB91F7145A28F7F097C8640A2@intel.com>
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
To: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "qi.fuli@jp.fujitsu.com" <qi.fuli@jp.fujitsu.com>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, 2018-04-26 at 09:56 +0900, QI Fuli wrote:
> This is a follow up patch for commit c70adc3cf6bf ("ndctl, filter:
> refactor
> util_<obj>_filter() to support multiple space-seperated arguments")
> refactored util_<obj>_filter() to support multiple space-seperated
> arguments.
> But, when the keyword "all" is included in space-seperated arguments,
> it will be treaded as <object>'s name. This patch fixes it.
> 
> Signed-off-by: QI Fuli <qi.fuli@jp.fujitsu.com>
> 
> Change log since v1:
>  - Removing the strcmp(__ident, "all") == 0 at the top of
> util_<obj>_filter()
>  - Changing the strcmp(ident, "all") == 0 to strcmp(name, "all") == 0
> 
> ---
>  util/filter.c | 20 ++++++++++++++++----
>  1 file changed, 16 insertions(+), 4 deletions(-)

Thanks, applied. Just as a future note, you should have the "changes since
v1" notes below the '---' marker (between the --- and the first file
diffstat). This prevents it from being picked up as part of the commit
message.

Thanks,
	-Vishal

> 
> diff --git a/util/filter.c b/util/filter.c
> index 0d3cc02..1734bce 100644
> --- a/util/filter.c
> +++ b/util/filter.c
> @@ -31,7 +31,7 @@ struct ndctl_bus *util_bus_filter(struct ndctl_bus
> *bus, const char *__ident)
>  	unsigned long bus_id, id;
>  	const char *provider, *devname, *name;
>  
> -	if (!__ident || strcmp(__ident, "all") == 0)
> +	if (!__ident)
>  		return bus;
>  
>  	ident = strdup(__ident);
> @@ -40,6 +40,9 @@ struct ndctl_bus *util_bus_filter(struct ndctl_bus
> *bus, const char *__ident)
>  
>  	for (name = strtok_r(ident, " ", &save); name;
>  			name = strtok_r(NULL, " ", &save)) {
> +		if (strcmp(name, "all") == 0)
> +			break;
> +
>  		bus_id = strtoul(ident, &end, 0);
>  		if (end == ident || end[0])
>  			bus_id = ULONG_MAX;
> @@ -69,7 +72,7 @@ struct ndctl_region *util_region_filter(struct
> ndctl_region *region,
>  	const char *name, *region_name;
>  	unsigned long region_id, id;
>  
> -	if (!__ident || strcmp(__ident, "all") == 0)
> +	if (!__ident)
>  		return region;
>  
>  	ident = strdup(__ident);
> @@ -78,6 +81,9 @@ struct ndctl_region *util_region_filter(struct
> ndctl_region *region,
>  
>  	for (name = strtok_r(ident, " ", &save); name;
>  			name = strtok_r(NULL, " ", &save)) {
> +		if (strcmp(name, "all") == 0)
> +			break;
> +
>  		region_id = strtoul(ident, &end, 0);
>  		if (end == ident || end[0])
>  			region_id = ULONG_MAX;
> @@ -106,7 +112,7 @@ struct ndctl_namespace *util_namespace_filter(struct
> ndctl_namespace *ndns,
>  	const char *name;
>  	char *ident, *save;
>  
> -	if (!__ident || strcmp(__ident, "all") == 0)
> +	if (!__ident)
>  		return ndns;
>  
>  	ident = strdup(__ident);
> @@ -115,6 +121,9 @@ struct ndctl_namespace *util_namespace_filter(struct
> ndctl_namespace *ndns,
>  
>  	for (name = strtok_r(ident, " ", &save); name;
>  			name = strtok_r(NULL, " ", &save)) {
> +		if (strcmp(name, "all") == 0)
> +			break;
> +
>  		if (strcmp(name, ndctl_namespace_get_devname(ndns)) ==
> 0)
>  			break;
>  
> @@ -137,7 +146,7 @@ struct ndctl_dimm *util_dimm_filter(struct ndctl_dimm
> *dimm,
>  	const char *name, *dimm_name;
>  	unsigned long dimm_id, id;
>  
> -	if (!__ident || strcmp(__ident, "all") == 0)
> +	if (!__ident)
>  		return dimm;
>  
>  	ident = strdup(__ident);
> @@ -146,6 +155,9 @@ struct ndctl_dimm *util_dimm_filter(struct ndctl_dimm
> *dimm,
>  
>  	for (name = strtok_r(ident, " ", &save); name;
>  			name = strtok_r(NULL, " ", &save)) {
> +		if (strcmp(name, "all") == 0)
> +			break;
> +
>  		dimm_id = strtoul(ident, &end, 0);
>  		if (end == ident || end[0])
>  			dimm_id = ULONG_MAX;
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

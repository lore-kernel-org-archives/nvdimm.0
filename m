Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5D26822618173
 for <linux-nvdimm@lists.01.org>; Tue, 10 Apr 2018 16:50:13 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [ndctl PATCH v2] ndctl: complete move to "fsdax" and "devdax"
Date: Tue, 10 Apr 2018 23:50:10 +0000
Message-ID: <1523404208.5172.7.camel@intel.com>
References: <20180410170901.19784-1-ross.zwisler@linux.intel.com>
In-Reply-To: <20180410170901.19784-1-ross.zwisler@linux.intel.com>
Content-Language: en-US
Content-ID: <E36AC7A1642D364FB47B0B31EEAB5340@intel.com>
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
To: "ross.zwisler@linux.intel.com" <ross.zwisler@linux.intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, 2018-04-10 at 11:09 -0600, Ross Zwisler wrote:
> Add on to the work started by:
> 
> commit ebb4fb605e68 ("ndctl, create-namespace: introduce "fsdax" and
> "devdax" modes")
> 
> and change some more user visible places to use "fsdax" and "devdax"
> modes
> instead of "memory" and "dax", respectively.  Having multiple terms for
> the
> same mode is confusing for users.
> 
> We will continue to accept "memory" and "dax" as parameters, but all
> output
> and man pages will now use the updated terms.
> 
> Note that after the above referenced commit we still printed the old
> names
> in the default 'ndctl list' output for backward compatibility with
> scripts.
> This patch intentionally breaks that backward compatibility in favor of
> avoiding confusion and using the new mode names everywhere.
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> ---
>  Documentation/ndctl/ndctl-inject-error.txt |  2 +-
>  Documentation/ndctl/ndctl-list.txt         |  6 +++---
>  ndctl/namespace.c                          | 16 ++++++++--------
>  util/json.c                                | 10 ++--------
>  4 files changed, 14 insertions(+), 20 deletions(-)

This also needs unit test updates to create.sh and clear.sh as they look
for 'memory'

> 
> diff --git a/Documentation/ndctl/ndctl-inject-error.txt
> b/Documentation/ndctl/ndctl-inject-error.txt
> index 01f6c22..94c4e69 100644
> --- a/Documentation/ndctl/ndctl-inject-error.txt
> +++ b/Documentation/ndctl/ndctl-inject-error.txt
> @@ -45,7 +45,7 @@ OPTIONS
>  
>  	NOTE: The offset is interpreted in different ways based on the
> "mode"
>  	of the namespace. For "raw" mode, the offset is the base
> namespace
> -	offset. For "memory" mode (i.e. a "pfn" namespace), the offset
> is
> +	offset. For "fsdax" mode (i.e. a "pfn" namespace), the offset is
>  	relative to the user-visible part of the namespace, and the
> offset
>  	introduced by the kernel's metadata will be accounted for. For a
>  	"sector" mode namespace (i.e. a "BTT" namespace), the offset is
> diff --git a/Documentation/ndctl/ndctl-list.txt
> b/Documentation/ndctl/ndctl-list.txt
> index 04affc4..2abc572 100644
> --- a/Documentation/ndctl/ndctl-list.txt
> +++ b/Documentation/ndctl/ndctl-list.txt
> @@ -49,7 +49,7 @@ EXAMPLE
>    "namespaces":[
>      {
>        "dev":"namespace0.0",
> -      "mode":"memory",
> +      "mode":"fsdax",
>        "size":8589934592,
>        "blockdev":"pmem0"
>      }
> @@ -132,11 +132,11 @@ include::xable-region-options.txt[]
>  -X::
>  --device-dax::
>  	Include device-dax ("daxregion") details when a namespace is in
> -	"dax" mode.
> +	"devdax" mode.
>  [verse]
>  {
>    "dev":"namespace0.0",
> -  "mode":"dax",
> +  "mode":"devdax",
>    "size":4225761280,
>    "uuid":"18ae1bbb-bb62-4efc-86df-4a5caacb5dcc",
>    "daxregion":{
> diff --git a/ndctl/namespace.c b/ndctl/namespace.c
> index f2c5644..fe86d82 100644
> --- a/ndctl/namespace.c
> +++ b/ndctl/namespace.c
> @@ -103,7 +103,7 @@ OPT_STRING('n', "name", &param.name, "name", \
>  OPT_STRING('s', "size", &param.size, "size", \
>  	"specify the namespace size in bytes (default: available
> capacity)"), \
>  OPT_STRING('m', "mode", &param.mode, "operation-mode", \
> -	"specify a mode for the namespace, 'sector', 'memory', or
> 'raw'"), \
> +	"specify a mode for the namespace, 'sector', 'fsdax', 'devdax'
> or 'raw'"), \
>  OPT_STRING('M', "map", &param.map, "memmap-location", \
>  	"specify 'mem' or 'dev' for the location of the memmap"), \
>  OPT_STRING('l', "sector-size", &param.sector_size, "lba-size", \
> @@ -533,7 +533,7 @@ static int validate_namespace_options(struct
> ndctl_region *region,
>  			 * supported a 2M default alignment when
>  			 * ndctl_pfn_has_align() returns false.
>  			 */
> -			debug("%s not support 'align' for memory
> mode\n",
> +			debug("%s not support 'align' for fsdax mode\n",
>  					region_name);
>  			return -EAGAIN;
>  		} else if (p->mode == NDCTL_NS_MODE_DAX
> @@ -542,7 +542,7 @@ static int validate_namespace_options(struct
> ndctl_region *region,
>  			 * Unlike the pfn case, we require the kernel to
>  			 * have 'align' support for device-dax.
>  			 */
> -			debug("%s not support 'align' for dax mode\n",
> +			debug("%s not support 'align' for devdax
> mode\n",
>  					region_name);
>  			return -EAGAIN;
>  		} else if (!param.align_default
> @@ -696,7 +696,7 @@ static int validate_namespace_options(struct
> ndctl_region *region,
>  
>  		if (ndns && p->mode != NDCTL_NS_MODE_MEMORY
>  			&& p->mode != NDCTL_NS_MODE_DAX) {
> -			debug("%s: --map= only valid for memory mode
> namespace\n",
> +			debug("%s: --map= only valid for fsdax mode
> namespace\n",
>  				ndctl_namespace_get_devname(ndns));
>  			return -EINVAL;
>  		}
> @@ -709,10 +709,10 @@ static int validate_namespace_options(struct
> ndctl_region *region,
>  		struct ndctl_pfn *pfn =
> ndctl_region_get_pfn_seed(region);
>  
>  		if (!pfn && param.mode_default) {
> -			debug("%s memory mode not available\n",
> region_name);
> +			debug("%s fsdax mode not available\n",
> region_name);
>  			p->mode = NDCTL_NS_MODE_RAW;
>  		} else if (!pfn) {
> -			error("operation failed, %s memory mode not
> available\n",
> +			error("operation failed, %s fsdax mode not
> available\n",
>  					region_name);
>  			return -EINVAL;
>  		}
> @@ -723,7 +723,7 @@ static int validate_namespace_options(struct
> ndctl_region *region,
>  		struct ndctl_dax *dax =
> ndctl_region_get_dax_seed(region);
>  
>  		if (!dax) {
> -			error("operation failed, %s dax mode not
> available\n",
> +			error("operation failed, %s devdax mode not
> available\n",
>  					region_name);
>  			return -EINVAL;
>  		}
> @@ -759,7 +759,7 @@ static int namespace_create(struct ndctl_region
> *region)
>  		return rc;
>  
>  	if (ndctl_region_get_ro(region)) {
> -		debug("%s: read-only, inelligible for namespace
> creation\n",
> +		debug("%s: read-only, ineligible for namespace
> creation\n",
>  			devname);
>  		return -EAGAIN;
>  	}
> diff --git a/util/json.c b/util/json.c
> index 5b4b4c3..8d65525 100644
> --- a/util/json.c
> +++ b/util/json.c
> @@ -685,19 +685,13 @@ struct json_object *util_namespace_to_json(struct
> ndctl_namespace *ndns,
>  			size = ndctl_pfn_get_size(pfn);
>  		else /* native/static memory mode */
>  			size = ndctl_namespace_get_size(ndns);
> -		if (flags & UTIL_JSON_HUMAN)
> -			jobj = json_object_new_string("fsdax");
> -		else
> -			jobj = json_object_new_string("memory");
> +		jobj = json_object_new_string("fsdax");
>  		break;
>  	case NDCTL_NS_MODE_DAX:
>  		if (!dax)
>  			goto err;
>  		size = ndctl_dax_get_size(dax);
> -		if (flags & UTIL_JSON_HUMAN)
> -			jobj = json_object_new_string("devdax");
> -		else
> -			jobj = json_object_new_string("dax");
> +		jobj = json_object_new_string("devdax");
>  		break;
>  	case NDCTL_NS_MODE_SAFE:
>  		if (!btt)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

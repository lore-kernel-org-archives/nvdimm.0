Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t2352.austin.hpe.com (g2t2352.austin.hpe.com [15.233.44.25])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7F0D620945617
 for <linux-nvdimm@lists.01.org>; Mon, 10 Jul 2017 11:41:35 -0700 (PDT)
Subject: Re: [ndctl PATCH v2] ndctl, daxctl, list: add --human option for
 number formatting
References: <20170710155616.7319.E1E9C6FF@jp.fujitsu.com>
 <149971108315.5438.1105220261491872156.stgit@dwillia2-desk3.amr.corp.intel.com>
From: Linda Knippers <linda.knippers@hpe.com>
Message-ID: <5963CAA2.3020509@hpe.com>
Date: Mon, 10 Jul 2017 14:42:42 -0400
MIME-Version: 1.0
In-Reply-To: <149971108315.5438.1105220261491872156.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: Dan Williams <dan.j.williams@intel.com>, linux-nvdimm@lists.01.org
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
List-ID: <linux-nvdimm@lists.01.org>

On 07/10/2017 02:26 PM, Dan Williams wrote:
> The json output format of the 'list' commands is meant to make it easy
> to ingest the data into other tools. However, for direct administrator
> use of the utility provide an option to format some numbers for easier
> human consumption, similar to the "-h" to du(1). Note that the short
> option is "-u" since "-h" is already established as the short option for
> "--help".
> 
>     Before:
>     # ndctl list --region=7
>     {
>       "dev":"region7",
>       "size":67108864,
>       "available_size":67108864,
>       "type":"pmem",
>       "iset_id":-6382611090938810793,
>       "badblock_count":8
>     }
> 
>     After:
>     # ndctl list --region=7 --human
>     {
>       "dev":"region7",
>       "size":"64.00 MiB / 67.11 MB",
>       "available_size":"64.00 MiB / 67.11 MB",
>       "type":"pmem",
>       "iset_id":"0xa76c6907811fae57",
>       "badblock_count":8
>     }
> 
> Cc: Dave Jiang <dave.jiang@intel.com>
> Reported-by: Linda Knippers <linda.knippers@hpe.com>
> Reported-by: Yasunori Goto <y-goto@jp.fujitsu.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
> 
> Changes since v1:
> * drop the auto-detect and just require the "--human" option for the
>   different format of the output. This prevents any confusion with
>   default output behavior (Yasunori)
> 
> * include the JEDEC size in addition to the IEC size (i.e. MiB vs MB
>   etc) (Dave).

I'd rather see us pick one or the other and not provide two values.
Even though this is the human friendly output, it's possible that it could
be used by other programs that know what MB means and know what MiB means
but now would need to know that / doesn't mean to divide one by the other.
I think as long as the units are clear, either one is ok.

-- ljk
> 
>  Documentation/daxctl/daxctl-list.txt |   20 ++++++
>  Documentation/ndctl/ndctl-list.txt   |   28 +++++++++
>  daxctl/list.c                        |    5 ++
>  ndctl/list.c                         |   16 ++++-
>  ndctl/namespace.c                    |    7 ++
>  util/json.c                          |  106 +++++++++++++++++++++++++++++++---
>  util/json.h                          |   11 +++-
>  7 files changed, 175 insertions(+), 18 deletions(-)
> 
> diff --git a/Documentation/daxctl/daxctl-list.txt b/Documentation/daxctl/daxctl-list.txt
> index 6de8d828de27..75dbcc4a07ef 100644
> --- a/Documentation/daxctl/daxctl-list.txt
> +++ b/Documentation/daxctl/daxctl-list.txt
> @@ -73,6 +73,26 @@ OPTIONS
>  --idle::
>  	Include idle (not enabled / zero-sized) devices in the listing
>  
> +-u::
> +--human::
> +	By default 'daxctl list' will output machine-friendly raw-integer
> +	data. Instead, with this flag, numbers representing storage size
> +	will be formatted as human readable strings with units, other
> +	fields are converted to hexadecimal strings.  Example:
> +
> +[verse]
> +# daxctl list
> +{
> +  "chardev":"dax1.0",
> +  "size":32828817408
> +}
> +
> +# daxctl list --human
> +{
> +  "chardev":"dax1.0",
> +  "size":"30.57 GiB / 32.83 GB"
> +}
> +
>  COPYRIGHT
>  ---------
>  Copyright (c) 2016 - 2017, Intel Corporation. License GPLv2: GNU GPL
> diff --git a/Documentation/ndctl/ndctl-list.txt b/Documentation/ndctl/ndctl-list.txt
> index fd67d2b3e0ba..cc2d87cbb295 100644
> --- a/Documentation/ndctl/ndctl-list.txt
> +++ b/Documentation/ndctl/ndctl-list.txt
> @@ -180,6 +180,34 @@ include::xable-region-options.txt[]
>    ]
>  }
>  
> +-u::
> +--human::
> +	By default 'ndctl list' will output machine-friendly raw-integer
> +	data. Instead, with this flag, numbers representing storage size
> +	will be formatted as human readable strings with units, other
> +	fields are converted to hexadecimal strings.  Example:
> +
> +[verse]
> +# ndctl list --region=7
> +{
> +  "dev":"region7",
> +  "size":67108864,
> +  "available_size":67108864,
> +  "type":"pmem",
> +  "iset_id":-6382611090938810793,
> +  "badblock_count":8
> +}
> +
> +# ndctl list --human --region=7
> +{
> +  "dev":"region7",
> +  "size":"64.00 MiB / 67.11 MB",
> +  "available_size":"64.00 MiB / 67.11 MB",
> +  "type":"pmem",
> +  "iset_id":"0xa76c6907811fae57",
> +  "badblock_count":8
> +}
> +
>  COPYRIGHT
>  ---------
>  Copyright (c) 2016 - 2017, Intel Corporation. License GPLv2: GNU GPL
> diff --git a/daxctl/list.c b/daxctl/list.c
> index e213df138f07..678ef6ce4c13 100644
> --- a/daxctl/list.c
> +++ b/daxctl/list.c
> @@ -26,6 +26,7 @@ static struct {
>  	bool devs;
>  	bool regions;
>  	bool idle;
> +	bool human;
>  } list;
>  
>  static unsigned long listopts_to_flags(void)
> @@ -36,6 +37,8 @@ static unsigned long listopts_to_flags(void)
>  		flags |= UTIL_JSON_DAX;
>  	if (list.idle)
>  		flags |= UTIL_JSON_IDLE;
> +	if (list.human)
> +		flags |= UTIL_JSON_HUMAN;
>  	return flags;
>  }
>  
> @@ -70,6 +73,8 @@ int cmd_list(int argc, const char **argv, void *ctx)
>  		OPT_BOOLEAN('D', "devices", &list.devs, "include dax device info"),
>  		OPT_BOOLEAN('R', "regions", &list.regions, "include dax region info"),
>  		OPT_BOOLEAN('i', "idle", &list.idle, "include idle devices"),
> +		OPT_BOOLEAN('u', "human", &list.human,
> +				"use human friendly number formats "),
>  		OPT_END(),
>  	};
>  	const char * const u[] = {
> diff --git a/ndctl/list.c b/ndctl/list.c
> index 7ecfcc91b0ec..d81d6464ebb1 100644
> --- a/ndctl/list.c
> +++ b/ndctl/list.c
> @@ -37,6 +37,7 @@ static struct {
>  	bool health;
>  	bool dax;
>  	bool media_errors;
> +	bool human;
>  } list;
>  
>  static unsigned long listopts_to_flags(void)
> @@ -49,6 +50,8 @@ static unsigned long listopts_to_flags(void)
>  		flags |= UTIL_JSON_MEDIA_ERRORS;
>  	if (list.dax)
>  		flags |= UTIL_JSON_DAX;
> +	if (list.human)
> +		flags |= UTIL_JSON_HUMAN;
>  	return flags;
>  }
>  
> @@ -160,12 +163,13 @@ static struct json_object *region_to_json(struct ndctl_region *region,
>  		goto err;
>  	json_object_object_add(jregion, "dev", jobj);
>  
> -	jobj = json_object_new_int64(ndctl_region_get_size(region));
> +	jobj = util_json_object_size(ndctl_region_get_size(region), flags);
>  	if (!jobj)
>  		goto err;
>  	json_object_object_add(jregion, "size", jobj);
>  
> -	jobj = json_object_new_int64(ndctl_region_get_available_size(region));
> +	jobj = util_json_object_size(ndctl_region_get_available_size(region),
> +			flags);
>  	if (!jobj)
>  		goto err;
>  	json_object_object_add(jregion, "available_size", jobj);
> @@ -186,8 +190,8 @@ static struct json_object *region_to_json(struct ndctl_region *region,
>  
>  	iset = ndctl_region_get_interleave_set(region);
>  	if (iset) {
> -		jobj = json_object_new_int64(
> -				ndctl_interleave_set_get_cookie(iset));
> +		jobj = util_json_object_hex(
> +				ndctl_interleave_set_get_cookie(iset), flags);
>  		if (!jobj)
>  			fail("\n");
>  		else
> @@ -216,7 +220,7 @@ static struct json_object *region_to_json(struct ndctl_region *region,
>  			json_object_object_add(jregion, "mappings", jmappings);
>  		}
>  
> -		jmapping = util_mapping_to_json(mapping);
> +		jmapping = util_mapping_to_json(mapping, listopts_to_flags());
>  		if (!jmapping) {
>  			fail("\n");
>  			continue;
> @@ -282,6 +286,8 @@ int cmd_list(int argc, const char **argv, void *ctx)
>  		OPT_BOOLEAN('i', "idle", &list.idle, "include idle devices"),
>  		OPT_BOOLEAN('M', "media-errors", &list.media_errors,
>  				"include media errors"),
> +		OPT_BOOLEAN('u', "human", &list.human,
> +				"use human friendly number formats "),
>  		OPT_END(),
>  	};
>  	const char * const u[] = {
> diff --git a/ndctl/namespace.c b/ndctl/namespace.c
> index b28936cfd3ec..7b0198f11cad 100644
> --- a/ndctl/namespace.c
> +++ b/ndctl/namespace.c
> @@ -397,9 +397,12 @@ static int setup_namespace(struct ndctl_region *region,
>  		error("%s: failed to enable\n",
>  				ndctl_namespace_get_devname(ndns));
>  	} else {
> -		struct json_object *jndns = util_namespace_to_json(ndns,
> -				UTIL_JSON_DAX);
> +		unsigned long flags = UTIL_JSON_DAX;
> +		struct json_object *jndns;
>  
> +		if (isatty(1))
> +			flags |= UTIL_JSON_HUMAN;
> +		jndns = util_namespace_to_json(ndns, flags);
>  		if (jndns)
>  			printf("%s\n", json_object_to_json_string_ext(jndns,
>  						JSON_C_TO_STRING_PRETTY));
> diff --git a/util/json.c b/util/json.c
> index 1863bca10121..30217326c0b4 100644
> --- a/util/json.c
> +++ b/util/json.c
> @@ -11,10 +11,12 @@
>   * General Public License for more details.
>   */
>  #include <limits.h>
> +#include <string.h>
>  #include <util/json.h>
>  #include <util/filter.h>
>  #include <uuid/uuid.h>
>  #include <json-c/json.h>
> +#include <json-c/printbuf.h>
>  #include <ndctl/libndctl.h>
>  #include <daxctl/libdaxctl.h>
>  #include <ccan/array_size/array_size.h>
> @@ -25,6 +27,90 @@
>  #include <ndctl.h>
>  #endif
>  
> +/* adapted from mdadm::human_size_brief() */
> +static int display_size(struct json_object *jobj, struct printbuf *pbuf,
> +		int level, int flags)
> +{
> +	unsigned long long bytes = json_object_get_int64(jobj);
> +	static char buf[128];
> +	int c;
> +
> +	/*
> +	 * We convert bytes to either centi-M{ega,ibi}bytes or
> +	 * centi-G{igi,ibi}bytes, with appropriate rounding, and then print
> +	 * 1/100th of those as a decimal.  We allow upto 2048Megabytes before
> +	 * converting to gigabytes, as that shows more precision and isn't too
> +	 * large a number.  Terabytes are not yet handled.
> +	 *
> +	 * If prefix == IEC, we mean prefixes like kibi,mebi,gibi etc.
> +	 * If prefix == JEDEC, we mean prefixes like kilo,mega,giga etc.
> +	 */
> +
> +	if (bytes < 5000*1024)
> +		snprintf(buf, sizeof(buf), "%lld", bytes);
> +	else {
> +		/* IEC */
> +		if (bytes < 2*1024LL*1024LL*1024LL) {
> +			long cMiB = (bytes * 200LL / (1LL<<20) +1) /2;
> +
> +			c = snprintf(buf, sizeof(buf), "\"%ld.%02ld MiB",
> +					cMiB/100 , cMiB % 100);
> +		} else {
> +			long cGiB = (bytes * 200LL / (1LL<<30) +1) /2;
> +
> +			c = snprintf(buf, sizeof(buf), "\"%ld.%02ld GiB",
> +					cGiB/100 , cGiB % 100);
> +		}
> +
> +		c += snprintf(buf + c, sizeof(buf) - c, " / ");
> +
> +		/* JEDEC */
> +		if (bytes < 2*1024LL*1024LL*1024LL) {
> +			long cMB  = (bytes / (1000000LL / 200LL) + 1) / 2;
> +
> +			snprintf(buf + c, sizeof(buf) - c, "%ld.%02ld MB\"",
> +					cMB/100, cMB % 100);
> +		} else {
> +			long cGB  = (bytes / (1000000000LL/200LL) + 1) / 2;
> +
> +			snprintf(buf + c, sizeof(buf) - c, "%ld.%02ld GB\"",
> +					cGB/100 , cGB % 100);
> +		}
> +	}
> +
> +	return printbuf_memappend(pbuf, buf, strlen(buf));
> +}
> +
> +static int display_hex(struct json_object *jobj, struct printbuf *pbuf,
> +		int level, int flags)
> +{
> +	unsigned long long val = json_object_get_int64(jobj);
> +	static char buf[32];
> +
> +	snprintf(buf, sizeof(buf), "\"%#llx\"", val);
> +	return printbuf_memappend(pbuf, buf, strlen(buf));
> +}
> +
> +struct json_object *util_json_object_size(unsigned long long size,
> +		unsigned long flags)
> +{
> +	struct json_object *jobj = json_object_new_int64(size);
> +
> +	if (jobj && (flags & UTIL_JSON_HUMAN))
> +		json_object_set_serializer(jobj, display_size, NULL, NULL);
> +	return jobj;
> +}
> +
> +struct json_object *util_json_object_hex(unsigned long long val,
> +		unsigned long flags)
> +{
> +	struct json_object *jobj = json_object_new_int64(val);
> +
> +	if (jobj && (flags & UTIL_JSON_HUMAN))
> +		json_object_set_serializer(jobj, display_hex, NULL, NULL);
> +	return jobj;
> +}
> +
>  void util_display_json_array(FILE *f_out, struct json_object *jarray, int jflag)
>  {
>  	int len = json_object_array_length(jarray);
> @@ -140,7 +226,8 @@ struct json_object *util_dimm_to_json(struct ndctl_dimm *dimm)
>  	return NULL;
>  }
>  
> -struct json_object *util_daxctl_dev_to_json(struct daxctl_dev *dev)
> +struct json_object *util_daxctl_dev_to_json(struct daxctl_dev *dev,
> +		unsigned long flags)
>  {
>  	const char *devname = daxctl_dev_get_devname(dev);
>  	struct json_object *jdev, *jobj;
> @@ -153,7 +240,7 @@ struct json_object *util_daxctl_dev_to_json(struct daxctl_dev *dev)
>  	if (jobj)
>  		json_object_object_add(jdev, "chardev", jobj);
>  
> -	jobj = json_object_new_int64(daxctl_dev_get_size(dev));
> +	jobj = util_json_object_size(daxctl_dev_get_size(dev), flags);
>  	if (jobj)
>  		json_object_object_add(jdev, "size", jobj);
>  
> @@ -181,7 +268,7 @@ struct json_object *util_daxctl_devs_to_list(struct daxctl_region *region,
>  				return NULL;
>  		}
>  
> -		jdev = util_daxctl_dev_to_json(dev);
> +		jdev = util_daxctl_dev_to_json(dev, flags);
>  		if (!jdev) {
>  			json_object_put(jdevs);
>  			return NULL;
> @@ -211,7 +298,7 @@ struct json_object *util_daxctl_region_to_json(struct daxctl_region *region,
>  
>  	size = daxctl_region_get_size(region);
>  	if (size < ULLONG_MAX) {
> -		jobj = json_object_new_int64(size);
> +		jobj = util_json_object_size(size, flags);
>  		if (!jobj)
>  			goto err;
>  		json_object_object_add(jregion, "size", jobj);
> @@ -219,7 +306,7 @@ struct json_object *util_daxctl_region_to_json(struct daxctl_region *region,
>  
>  	available_size = daxctl_region_get_available_size(region);
>  	if (available_size) {
> -		jobj = json_object_new_int64(available_size);
> +		jobj = util_json_object_size(available_size, flags);
>  		if (!jobj)
>  			goto err;
>  		json_object_object_add(jregion, "available_size", jobj);
> @@ -490,7 +577,7 @@ struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns,
>  		json_object_object_add(jndns, "mode", jobj);
>  
>  	if (size < ULLONG_MAX) {
> -		jobj = json_object_new_int64(size);
> +		jobj = util_json_object_size(size, flags);
>  		if (jobj)
>  			json_object_object_add(jndns, "size", jobj);
>  	}
> @@ -604,7 +691,8 @@ struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns,
>  	return NULL;
>  }
>  
> -struct json_object *util_mapping_to_json(struct ndctl_mapping *mapping)
> +struct json_object *util_mapping_to_json(struct ndctl_mapping *mapping,
> +		unsigned long flags)
>  {
>  	struct json_object *jmapping = json_object_new_object();
>  	struct ndctl_dimm *dimm = ndctl_mapping_get_dimm(mapping);
> @@ -618,12 +706,12 @@ struct json_object *util_mapping_to_json(struct ndctl_mapping *mapping)
>  		goto err;
>  	json_object_object_add(jmapping, "dimm", jobj);
>  
> -	jobj = json_object_new_int64(ndctl_mapping_get_offset(mapping));
> +	jobj = util_json_object_hex(ndctl_mapping_get_offset(mapping), flags);
>  	if (!jobj)
>  		goto err;
>  	json_object_object_add(jmapping, "offset", jobj);
>  
> -	jobj = json_object_new_int64(ndctl_mapping_get_length(mapping));
> +	jobj = util_json_object_hex(ndctl_mapping_get_length(mapping), flags);
>  	if (!jobj)
>  		goto err;
>  	json_object_object_add(jmapping, "length", jobj);
> diff --git a/util/json.h b/util/json.h
> index 19d5ffc4376e..ec394b636cff 100644
> --- a/util/json.h
> +++ b/util/json.h
> @@ -20,13 +20,15 @@ enum util_json_flags {
>  	UTIL_JSON_IDLE = (1 << 0),
>  	UTIL_JSON_MEDIA_ERRORS = (1 << 1),
>  	UTIL_JSON_DAX = (1 << 2),
> +	UTIL_JSON_HUMAN = (1 << 3),
>  };
>  
>  struct json_object;
>  void util_display_json_array(FILE *f_out, struct json_object *jarray, int jflag);
>  struct json_object *util_bus_to_json(struct ndctl_bus *bus);
>  struct json_object *util_dimm_to_json(struct ndctl_dimm *dimm);
> -struct json_object *util_mapping_to_json(struct ndctl_mapping *mapping);
> +struct json_object *util_mapping_to_json(struct ndctl_mapping *mapping,
> +		unsigned long flags);
>  struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns,
>  		unsigned long flags);
>  struct daxctl_region;
> @@ -35,10 +37,15 @@ struct json_object *util_region_badblocks_to_json(struct ndctl_region *region,
>  		unsigned int *bb_count, unsigned long flags);
>  struct json_object *util_daxctl_region_to_json(struct daxctl_region *region,
>  		const char *ident, unsigned long flags);
> -struct json_object *util_daxctl_dev_to_json(struct daxctl_dev *dev);
> +struct json_object *util_daxctl_dev_to_json(struct daxctl_dev *dev,
> +		unsigned long flags);
>  struct json_object *util_daxctl_devs_to_list(struct daxctl_region *region,
>  		struct json_object *jdevs, const char *ident,
>  		unsigned long flags);
> +struct json_object *util_json_object_size(unsigned long long size,
> +		unsigned long flags);
> +struct json_object *util_json_object_hex(unsigned long long val,
> +		unsigned long flags);
>  #ifdef HAVE_NDCTL_SMART
>  struct json_object *util_dimm_health_to_json(struct ndctl_dimm *dimm);
>  #else
> 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id ED07720954BA2
 for <linux-nvdimm@lists.01.org>; Mon, 19 Mar 2018 14:24:54 -0700 (PDT)
Date: Mon, 19 Mar 2018 15:31:21 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH] ndctl: Add support for region persistent domain
Message-ID: <20180319213121.GA5110@linux.intel.com>
References: <152106992276.3651.11460547310766381879.stgit@djiang5-desk3.ch.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <152106992276.3651.11460547310766381879.stgit@djiang5-desk3.ch.intel.com>
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
To: Dave Jiang <dave.jiang@intel.com>
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Mar 14, 2018 at 04:25:22PM -0700, Dave Jiang wrote:
> Adding helper functions to iterate through sysfs region persistence domain
> attribute. The region will display the domain with the most persistence for the
> region.  The bus will display the domain attribute with the least persistence
> amongst all the regions. ndctl_bus_get_persistence_domain() and
> ndctl_region_get_persistence_domain are exported. ndctl list will also display
> the region persistence domain as well.
> 
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>

In general I think this is more complex than it needs to be.  IIUC we have a
1:1 relationship between regions and persistence domains, right?  If so, I
don't understand the need for region_pd_foreach(), region_get_first_pd(),
region_get_next_pd(), etc.

Can't we just have one region_get_persistence_domain() which opens
region->path/persistence_domain, parses a string, and is done?

If so, this obviates the need to store a FILE* (persist_fp) in struct
ndctl_region, right?  Let's just keep the open/read/close sequence local to
the get() function.

Some other nits below.

> ---
>  0 files changed
> 
> diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
> index a165e697..94a1dbcd 100644
> --- a/ndctl/lib/libndctl.c
> +++ b/ndctl/lib/libndctl.c
> @@ -180,6 +180,8 @@ struct ndctl_region {
>  	} iset;
>  	FILE *badblocks;
>  	struct badblock bb;
> +	FILE *persist_fp;
> +	unsigned int persist_domain;

Throughout I think it'd add clarity to use a named enum for the
PERSISTENCE_CPU_CACHE type defines, instead of passing around unsigned ints.
See ndctl_pfn_get_location() et al. for an example of what I mean - this
disambiguates your enum from an error return value, for example.

Tiny nit: you spell out "persistence" for both the function names and for the
PERSISTENCE_CPU_CACHE type defines, but for these members you shorten to
"persist".  My vote is to spell it out always so it's more consistent.

>  };
>  
>  /**
> @@ -916,6 +918,17 @@ NDCTL_EXPORT struct ndctl_bus *ndctl_bus_get_by_provider(struct ndctl_ctx *ctx,
>  	return NULL;
>  }
>  
> +NDCTL_EXPORT unsigned int
> +ndctl_bus_get_persistence_domain(struct ndctl_bus *bus)
> +{
> +	struct ndctl_region *region;
> +
> +	/* iterate through region to get the region persist domain */
> +	ndctl_region_foreach(bus, region) {}

I don't understand why you need to loop though all the regions in the bus?
ndctl_region_foreach() ends up calling
ndctl_region_get_first()=>regions_init(), which I think is what you care
about, right?  No need for the looping.

> +static int region_persistence_init(struct ndctl_region *region)
> +{
> +	struct ndctl_ctx *ctx = ndctl_region_get_ctx(region);
> +	char *pd_path;
> +	int rc = 0;
> +
> +	if (region->persist_fp) {
> +		fclose(region->persist_fp);
> +		region->persist_fp = NULL;
> +	}
> +
> +	if (asprintf(&pd_path, "%s/persistence_domain",
> +				region->region_path) < 0) {
> +		rc = -errno;
> +		err(ctx, "region persist domain path allocation failure\n");
> +		return rc;
> +	}
> +
> +	region->persist_fp = fopen(pd_path, "re");
> +	if (!region->persist_fp) {
> +		rc = -errno;
> +		free(pd_path);
> +		return rc;

no need for the free() and return lines - just fall thru.

> +	}
> +
> +	free(pd_path);
> +	return rc;
> +}

<>

> diff --git a/ndctl/libndctl.h b/ndctl/libndctl.h
> index f3a27411..be5b196c 100644
> --- a/ndctl/libndctl.h
> +++ b/ndctl/libndctl.h
> @@ -115,6 +115,7 @@ int ndctl_bus_is_cmd_supported(struct ndctl_bus *bus, int cmd);
>  unsigned int ndctl_bus_get_revision(struct ndctl_bus *bus);
>  unsigned int ndctl_bus_get_id(struct ndctl_bus *bus);
>  const char *ndctl_bus_get_provider(struct ndctl_bus *bus);
> +unsigned int ndctl_bus_get_persistence_domain(struct ndctl_bus *bus);
>  int ndctl_bus_wait_probe(struct ndctl_bus *bus);
>  int ndctl_bus_wait_for_scrub_completion(struct ndctl_bus *bus);
>  unsigned int ndctl_bus_get_scrub_count(struct ndctl_bus *bus);
> @@ -305,6 +306,14 @@ struct badblock {
>  	unsigned long long offset;
>  	unsigned int len;
>  };
> +
> +enum {
> +	PERSISTENCE_NONE = 0,
> +/* order these in distance to CPU persistence domain */
> +	PERSISTENCE_CPU_CACHE,
> +	PERSISTENCE_MEM_CTRL,
> +};

I don't think we should have a single value that means "unset" and "no
persistence".  Meaning, if we have 3 regions on a bus, and 2 report
PERSISTENCE_NONE and one reports PERSISTENCE_CPU_CACHE, won't this current
code report PERSISTENCE_CPU_CACHE?

I think you can solve this and shorten this type of check in add_region():

        if (region->bus->persist_domain == 0 ||
                        region->bus->persist_domain < pd)
                region->bus->persist_domain = pd;

To just:
        if (region->bus->persist_domain > pd)
                region->bus->persist_domain = pd;

By just reordering them and defining 
	
enum {
	PERSISTENCE_NONE = 0,
	PERSISTENCE_MEM_CTRL,
	PERSISTENCE_CPU_CACHE,
	PERSISTENCE_UNKNOWN,
};

and initializing things to PERSISTENCE_UNKNOWN.

> +
>  struct ndctl_region;
>  struct ndctl_region *ndctl_region_get_first(struct ndctl_bus *bus);
>  struct ndctl_region *ndctl_region_get_next(struct ndctl_region *region);
> @@ -318,6 +327,7 @@ struct badblock *ndctl_region_get_next_badblock(struct ndctl_region *region);
>          for (badblock = ndctl_region_get_first_badblock(region); \
>               badblock != NULL; \
>               badblock = ndctl_region_get_next_badblock(region))
> +

unrelated whitespace change.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

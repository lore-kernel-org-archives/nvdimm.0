Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CA23720956080
 for <linux-nvdimm@lists.01.org>; Tue, 20 Mar 2018 13:28:09 -0700 (PDT)
Date: Tue, 20 Mar 2018 14:34:38 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v2] ndctl: Add support for get bus and region persistent
 domain
Message-ID: <20180320203438.GA5068@linux.intel.com>
References: <152150305678.47105.9095916907704193253.stgit@djiang5-desk3.ch.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <152150305678.47105.9095916907704193253.stgit@djiang5-desk3.ch.intel.com>
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

On Mon, Mar 19, 2018 at 04:45:30PM -0700, Dave Jiang wrote:
> Adding helper functions to iterate through sysfs region persistence domain
> attribute. The region will display the domain with the most persistence for the
> region.  The bus will display the domain attribute with the least persistence
> amongst all the regions. ndctl_bus_get_persistence_domain() and
> ndctl_region_get_persistence_domain are exported. ndctl list will also display
> the region persistence domain as well.
> 
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>

Nice this is cleaner, and you've shaved off 20 lines. :)

> @@ -755,6 +756,7 @@ static void *add_bus(void *parent, int id, const char *ctl_base)
>  	list_head_init(&bus->regions);
>  	bus->ctx = ctx;
>  	bus->id = id;
> +	bus->persistence_domain = PERSISTENCE_UNKNOWN;
>  
>  	sprintf(path, "%s/dev", ctl_base);
>  	if (sysfs_read_attr(ctx, path, buf) < 0
> @@ -916,6 +918,17 @@ NDCTL_EXPORT struct ndctl_bus *ndctl_bus_get_by_provider(struct ndctl_ctx *ctx,
>  	return NULL;
>  }
>  
> +NDCTL_EXPORT unsigned int

Can we make this return an enum ndctl_persistence, like the internal functions
do?  This follows the lead of APIs like ndctl_namespace_get_mode(), which by
returning an enum ndctl_namespace_mode tells the user what values to expect
and what those values mean.

Ditto for the ndctl_region_get_persistence_domain(), and the two external
declarations in libndctl.h.

> +ndctl_bus_get_persistence_domain(struct ndctl_bus *bus)
> +{
> +	struct ndctl_region *region;
> +
> +	/* iterate through region to get the region persistence domain */
> +	ndctl_region_foreach(bus, region) {}

I still don't understand why you need to do a ndctl_region_foreach() here,
looping through all the regions on a bus?  I think you're just after the
initialization that

ndctl_region_foreach()
  ndctl_region_get_first()
    regions_init()

gives you, right?  If so, let's be more clear about that and just call
regions_init() directly.  This also saves the work of needlessly looping
through the regions, and makes it so you don't need a local 'region' variable.


> +
> +	return bus->persistence_domain;
> +}
> +
>  NDCTL_EXPORT struct ndctl_btt *ndctl_region_get_btt_seed(struct ndctl_region *region)
>  {
>  	struct ndctl_ctx *ctx = ndctl_region_get_ctx(region);
> @@ -1755,6 +1768,62 @@ static int region_set_type(struct ndctl_region *region, char *path)
>  	return 0;
>  }
>  
> +static enum ndctl_persistence region_get_pd_type(char *name)
> +{
> +	if (strncmp("cpu_cache", name, 9) == 0)
> +		return PERSISTENCE_CPU_CACHE;
> +	else if (strncmp("memory_controller", name, 17) == 0)
> +		return PERSISTENCE_MEM_CTRL;
> +	else
> +		return PERSISTENCE_UNKNOWN;
> +}
> +
> +static int region_persistence_scan(struct ndctl_region *region)
> +{
> +	struct ndctl_ctx *ctx = ndctl_region_get_ctx(region);
> +	char *pd_path;
> +	FILE *pf;
> +	char buf[64];
> +	int rc = 0;
> +	enum ndctl_persistence pd = PERSISTENCE_NONE;
> +
> +	if (asprintf(&pd_path, "%s/persistence_domain",
> +				region->region_path) < 0) {
> +		rc = -errno;
> +		err(ctx, "region persist domain path allocation failure\n");
> +		return rc;
> +	}
> +
> +	pf = fopen(pd_path, "re");
> +	if (!pf) {
> +		rc = -errno;
> +		free(pd_path);
> +		return rc;
> +	}
> +
> +	region->persistence_domain = PERSISTENCE_NONE;

I think that this initialization needs to happen at the top of the function
before we have any return paths.  This is because the code that calls this,
add_region(), doesn't set region->persistence_domain if we give an error
return.  I think that this means that if the asprintf() fails, for example, we
will end up with region->persistence_domain being uninitialized.


> +	do {
> +		rc = fscanf(pf, "%s", buf);
> +		if (rc == EOF) {
> +			if (ferror(pf)) {
> +				rc = -errno;
> +				goto out;
> +			}
> +		} else if (rc == 1)
> +			pd = region_get_pd_type(buf);
> +
> +		if (region->persistence_domain < pd)
> +			region->persistence_domain = pd;
> +	} while (rc != EOF);
> +
> +	rc = 0;
> +
> +out:
> +	fclose(pf);
> +	free(pd_path);
> +	return rc;
> +}
> +
>  static void *add_region(void *parent, int id, const char *region_base)
>  {
>  	char buf[SYSFS_ATTR_SIZE];
> @@ -1762,6 +1831,7 @@ static void *add_region(void *parent, int id, const char *region_base)
>  	struct ndctl_bus *bus = parent;
>  	struct ndctl_ctx *ctx = bus->ctx;
>  	char *path = calloc(1, strlen(region_base) + 100);
> +	int rc;
>  
>  	if (!path)
>  		return NULL;
> @@ -1831,6 +1901,17 @@ static void *add_region(void *parent, int id, const char *region_base)
>  	list_add(&bus->regions, &region->list);
>  
>  	free(path);
> +
> +	/* get the persistence domain attribs */
> +	rc = region_persistence_scan(region);
> +	if (rc < 0)
> +		err(ctx, "%s: region persistence scan failed\n",
> +				ndctl_region_get_devname(region));

Nit: no need for 'rc' here, just follow the lead of the rest of the if()
statements in this function and do

if (region_persistence_scan(region) < 0) {
	err(...
}

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

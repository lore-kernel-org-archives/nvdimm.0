Return-Path: <owner-linux-mm@kvack.org>
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: Re: [PATCH v3 1/6] nvdimm: Consider probe return -EOPNOTSUPP as success
In-Reply-To: <20190604091357.32213-1-aneesh.kumar@linux.ibm.com>
References: <20190604091357.32213-1-aneesh.kumar@linux.ibm.com>
Date: Tue, 11 Jun 2019 14:59:03 +0530
MIME-Version: 1.0
Content-Type: text/plain
Message-Id: <87pnnkcvxc.fsf@linux.ibm.com>
Sender: owner-linux-mm@kvack.org
To: dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org, linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org
List-ID: <linux-nvdimm@lists.01.org>


Hi Dan,

Any feedback on this?

A change I would like to get done on top of this series is

+	if (__le16_to_cpu(pfn_sb->version_minor) < 3) {
+		/*
+		 * For a large part we use PAGE_SIZE. But we
+		 * do have some accounting code using SZ_4K.
+		 */
+		pfn_sb->page_struct_size = cpu_to_le16(64);
+		pfn_sb->page_size = cpu_to_le32(SZ_4K);
+	}
+

to

+	if (__le16_to_cpu(pfn_sb->version_minor) < 3) {
+		/*
+		 * For a large part we use PAGE_SIZE. But we
+		 * do have some accounting code using SZ_4K.
+		 */
+		pfn_sb->page_struct_size = cpu_to_le16(64);
+		pfn_sb->page_size = cpu_to_le32(PAGE_SIZE);
+	}
+


That would make sure we will able to access the namespace created on
powerpc with newer kernel.

Kindly let me know if you want to see further changes to this series. Do
you think this is ready for next merge window?

-aneesh

"Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com> writes:

> With following patches we add EOPNOTSUPP as return from probe callback to
> indicate we were not able to initialize a namespace due to pfn superblock
> feature/version mismatch. We want to consider this a probe success so that
> we can create new namesapce seed and there by avoid marking the failed
> namespace as the seed namespace.
>
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
> ---
>  drivers/nvdimm/bus.c         |  4 ++--
>  drivers/nvdimm/nd-core.h     |  3 ++-
>  drivers/nvdimm/region_devs.c | 19 +++++++++++++++----
>  3 files changed, 19 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
> index 2eb6a6cfe9e4..792b3e90453b 100644
> --- a/drivers/nvdimm/bus.c
> +++ b/drivers/nvdimm/bus.c
> @@ -100,8 +100,8 @@ static int nvdimm_bus_probe(struct device *dev)
>  
>  	nvdimm_bus_probe_start(nvdimm_bus);
>  	rc = nd_drv->probe(dev);
> -	if (rc == 0)
> -		nd_region_probe_success(nvdimm_bus, dev);
> +	if (rc == 0 || rc == -EOPNOTSUPP)
> +		nd_region_probe_success(nvdimm_bus, dev, rc);
>  	else
>  		nd_region_disable(nvdimm_bus, dev);
>  	nvdimm_bus_probe_end(nvdimm_bus);
> diff --git a/drivers/nvdimm/nd-core.h b/drivers/nvdimm/nd-core.h
> index e5ffd5733540..9e67a79fb6d5 100644
> --- a/drivers/nvdimm/nd-core.h
> +++ b/drivers/nvdimm/nd-core.h
> @@ -134,7 +134,8 @@ int __init nvdimm_bus_init(void);
>  void nvdimm_bus_exit(void);
>  void nvdimm_devs_exit(void);
>  void nd_region_devs_exit(void);
> -void nd_region_probe_success(struct nvdimm_bus *nvdimm_bus, struct device *dev);
> +void nd_region_probe_success(struct nvdimm_bus *nvdimm_bus,
> +			     struct device *dev, int ret);
>  struct nd_region;
>  void nd_region_create_ns_seed(struct nd_region *nd_region);
>  void nd_region_create_btt_seed(struct nd_region *nd_region);
> diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
> index b4ef7d9ff22e..fcf3d8828540 100644
> --- a/drivers/nvdimm/region_devs.c
> +++ b/drivers/nvdimm/region_devs.c
> @@ -723,7 +723,7 @@ void nd_mapping_free_labels(struct nd_mapping *nd_mapping)
>   * disable the region.
>   */
>  static void nd_region_notify_driver_action(struct nvdimm_bus *nvdimm_bus,
> -		struct device *dev, bool probe)
> +					   struct device *dev, bool probe, int ret)
>  {
>  	struct nd_region *nd_region;
>  
> @@ -753,6 +753,16 @@ static void nd_region_notify_driver_action(struct nvdimm_bus *nvdimm_bus,
>  			nd_region_create_ns_seed(nd_region);
>  		nvdimm_bus_unlock(dev);
>  	}
> +
> +	if (dev->parent && is_nd_region(dev->parent) &&
> +	    !probe && (ret == -EOPNOTSUPP)) {
> +		nd_region = to_nd_region(dev->parent);
> +		nvdimm_bus_lock(dev);
> +		if (nd_region->ns_seed == dev)
> +			nd_region_create_ns_seed(nd_region);
> +		nvdimm_bus_unlock(dev);
> +	}
> +
>  	if (is_nd_btt(dev) && probe) {
>  		struct nd_btt *nd_btt = to_nd_btt(dev);
>  
> @@ -788,14 +798,15 @@ static void nd_region_notify_driver_action(struct nvdimm_bus *nvdimm_bus,
>  	}
>  }
>  
> -void nd_region_probe_success(struct nvdimm_bus *nvdimm_bus, struct device *dev)
> +void nd_region_probe_success(struct nvdimm_bus *nvdimm_bus,
> +			     struct device *dev, int ret)
>  {
> -	nd_region_notify_driver_action(nvdimm_bus, dev, true);
> +	nd_region_notify_driver_action(nvdimm_bus, dev, true, ret);
>  }
>  
>  void nd_region_disable(struct nvdimm_bus *nvdimm_bus, struct device *dev)
>  {
> -	nd_region_notify_driver_action(nvdimm_bus, dev, false);
> +	nd_region_notify_driver_action(nvdimm_bus, dev, false, 0);
>  }
>  
>  static ssize_t mappingN(struct device *dev, char *buf, int n)
> -- 
> 2.21.0

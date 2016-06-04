Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.linuxfoundation.org (mail.linuxfoundation.org
 [140.211.169.12])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id F0CA61A1E43
 for <linux-nvdimm@lists.01.org>; Sat,  4 Jun 2016 14:10:32 -0700 (PDT)
Date: Sat, 4 Jun 2016 14:10:14 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 01/13] driver core, libnvdimm: disable manual unbind of
 dimms while region active
Message-ID: <20160604211014.GA29509@kroah.com>
References: <146507355220.8347.12117020810872172684.stgit@dwillia2-desk3.amr.corp.intel.com>
 <146507355828.8347.11600179233094511139.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <146507355828.8347.11600179233094511139.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: hch@lst.de, david@fromorbit.com, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Sat, Jun 04, 2016 at 01:52:38PM -0700, Dan Williams wrote:
> There are scenarios where we need a middle ground between disabling all
> manual bind/unbind attempts (via driver->suppress_bind_attrs) and
> allowing unbind at any userspace-determined time.  Pinning modules takes
> away one vector for unwanted out-of-sequence device_release_driver()
> invocations, this new mechanism (via device->suppress_unbind_attr) takes
> away another.
> 
> The first user of this mechanism is the libnvdimm sub-system where
> manual dimm disabling should be prevented while the dimm is active in
> any region.  Note that there is a 1:N dimm-to-region relationship which
> is why this is implemented as a disable count rather than a flag.  This
> forces userspace to disable regions before dimms when manually shutting
> down a bus topology.
> 
> This does not affect any of the kernel-internal initiated invocations of
> device_release_driver().
> 
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  drivers/base/base.h             |    1 +
>  drivers/base/bus.c              |   12 ++++++++++--
>  drivers/base/core.c             |    1 +
>  drivers/base/dd.c               |    2 +-
>  drivers/nvdimm/namespace_devs.c |    1 +
>  drivers/nvdimm/region_devs.c    |    4 +++-
>  include/linux/device.h          |   20 ++++++++++++++++++++
>  7 files changed, 37 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/base/base.h b/drivers/base/base.h
> index e05db388bd1c..129814b17ca6 100644
> --- a/drivers/base/base.h
> +++ b/drivers/base/base.h
> @@ -109,6 +109,7 @@ extern int bus_add_driver(struct device_driver *drv);
>  extern void bus_remove_driver(struct device_driver *drv);
>  
>  extern void driver_detach(struct device_driver *drv);
> +extern void __device_release_driver(struct device *dev);
>  extern int driver_probe_device(struct device_driver *drv, struct device *dev);
>  extern void driver_deferred_probe_del(struct device *dev);
>  static inline int driver_match_device(struct device_driver *drv,
> diff --git a/drivers/base/bus.c b/drivers/base/bus.c
> index 6470eb8088f4..b48a903f2d28 100644
> --- a/drivers/base/bus.c
> +++ b/drivers/base/bus.c
> @@ -188,10 +188,18 @@ static ssize_t unbind_store(struct device_driver *drv, const char *buf,
>  	if (dev && dev->driver == drv) {
>  		if (dev->parent)	/* Needed for USB */
>  			device_lock(dev->parent);
> -		device_release_driver(dev);
> +
> +		device_lock(dev);
> +		if (atomic_read(&dev->suppress_unbind_attr) > 0)
> +			err = -EBUSY;
> +		else {
> +			__device_release_driver(dev);
> +			err = count;
> +		}
> +		device_unlock(dev);
> +
>  		if (dev->parent)
>  			device_unlock(dev->parent);
> -		err = count;
>  	}
>  	put_device(dev);
>  	bus_put(bus);
> diff --git a/drivers/base/core.c b/drivers/base/core.c
> index 0a8bdade53f2..0ea0e8560e1d 100644
> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c
> @@ -708,6 +708,7 @@ void device_initialize(struct device *dev)
>  	INIT_LIST_HEAD(&dev->devres_head);
>  	device_pm_init(dev);
>  	set_dev_node(dev, -1);
> +	atomic_set(&dev->suppress_unbind_attr, 0);
>  #ifdef CONFIG_GENERIC_MSI_IRQ
>  	INIT_LIST_HEAD(&dev->msi_list);
>  #endif
> diff --git a/drivers/base/dd.c b/drivers/base/dd.c
> index 16688f50729c..9e21817ca2d6 100644
> --- a/drivers/base/dd.c
> +++ b/drivers/base/dd.c
> @@ -756,7 +756,7 @@ EXPORT_SYMBOL_GPL(driver_attach);
>   * __device_release_driver() must be called with @dev lock held.
>   * When called for a USB interface, @dev->parent lock must be held as well.
>   */
> -static void __device_release_driver(struct device *dev)
> +void __device_release_driver(struct device *dev)
>  {
>  	struct device_driver *drv;
>  
> diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
> index c5e3196c45b0..e65572b6092c 100644
> --- a/drivers/nvdimm/namespace_devs.c
> +++ b/drivers/nvdimm/namespace_devs.c
> @@ -1950,6 +1950,7 @@ static int init_active_labels(struct nd_region *nd_region)
>  		}
>  		nd_mapping->ndd = ndd;
>  		atomic_inc(&nvdimm->busy);
> +		device_disable_unbind_attr(&nvdimm->dev);
>  		get_ndd(ndd);
>  
>  		count = nd_label_active_count(ndd);
> diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
> index 40fcfea26fbb..320f0f3ea367 100644
> --- a/drivers/nvdimm/region_devs.c
> +++ b/drivers/nvdimm/region_devs.c
> @@ -427,8 +427,10 @@ static void nd_region_notify_driver_action(struct nvdimm_bus *nvdimm_bus,
>  			nd_mapping->labels = NULL;
>  			put_ndd(ndd);
>  			nd_mapping->ndd = NULL;
> -			if (ndd)
> +			if (ndd) {
>  				atomic_dec(&nvdimm->busy);
> +				device_enable_unbind_attr(&nvdimm->dev);
> +			}
>  		}
>  
>  		if (is_nd_pmem(dev))
> diff --git a/include/linux/device.h b/include/linux/device.h
> index 38f02814d53a..d9eaa85bb9cf 100644
> --- a/include/linux/device.h
> +++ b/include/linux/device.h
> @@ -849,6 +849,7 @@ struct device {
>  
>  	void	(*release)(struct device *dev);
>  	struct iommu_group	*iommu_group;
> +	atomic_t		suppress_unbind_attr; /* disable manual unbind */
>  
>  	bool			offline_disabled:1;
>  	bool			offline:1;
> @@ -988,6 +989,25 @@ static inline void device_lock_assert(struct device *dev)
>  	lockdep_assert_held(&dev->mutex);
>  }
>  
> +static inline bool device_disable_unbind_attr(struct device *dev)
> +{
> +	bool suppressed = false;
> +
> +	device_lock(dev);
> +	if (dev->driver) {
> +		atomic_inc(&dev->suppress_unbind_attr);
> +		suppressed = true;
> +	}
> +	device_unlock(dev);
> +
> +	return suppressed;
> +}
> +
> +static inline bool device_enable_unbind_attr(struct device *dev)
> +{
> +	return atomic_dec_and_test(&dev->suppress_unbind_attr);
> +}
> +

Ick, that's a mess.

Why not just prevent the unbinding from happening in your bus when you
need it?

And as you are grabbing a lock, why is this an atomic variable?

This is just making things _really_ complex for very limited gain for
what I can tell.

thanks,

greg k-h
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

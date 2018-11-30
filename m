Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Fri, 30 Nov 2018 15:40:38 -0800
From: Luis Chamberlain <mcgrof@kernel.org>
Subject: Re: [driver-core PATCH v7 2/9] driver core: Establish clear order of
 operations for deferred probe and remove
Message-ID: <20181130234038.GF28501@garbanzo.do-not-panic.com>
References: <154345118835.18040.17186161872550839244.stgit@ahduyck-desk1.amr.corp.intel.com>
 <154345153672.18040.3771035148218843351.stgit@ahduyck-desk1.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <154345153672.18040.3771035148218843351.stgit@ahduyck-desk1.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org, linux-nvdimm@lists.01.org, tj@kernel.org, akpm@linux-foundation.org, linux-pm@vger.kernel.org, jiangshanlai@gmail.com, rafael@kernel.org, len.brown@intel.com, pavel@ucw.cz, zwisler@kernel.org, dan.j.williams@intel.com, dave.jiang@intel.com, bvanassche@acm.org, dmitry.torokhov@gmail.com, brendanhiggins@google.com
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Nov 28, 2018 at 04:32:16PM -0800, Alexander Duyck wrote:
> Add an additional bit flag to the device struct named async_probe. This
> additional flag allows us to guarantee ordering between probe and remove
> operations.
> 
> This allows us to guarantee that if we execute a remove operation on a
> given interface it will not attempt to update the driver member
> asynchronously following the earlier operation. Previously this guarantee
> was not present and could result in us attempting to remove a driver from
> an interface only to have it attempt to attach the driver later when we
> finally complete the deferred asynchronous probe call.
> 
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>

Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>

This is the sort of corner case that is best if we had a test case for
it, as it is hard to reproduce and -- how do we know we won't regress
later? Not sure if it helps but we have lib/test_kmod.c and its
respective tools/testing/selftests/kmod/kmod.sh, a new enum kmod_test_case
might be in order for device emulation creeping up / disappearing
during a custom mock driver using async probe.

Yeah.. I know.. "yes this seems good but how about later"? While we're going
through the motions here and have your attention on this I think it
would be valuable for this now. This is the sort of code that won't
change often, but if modified *can* really break things badly.

  Luis

> ---
>  drivers/base/dd.c      |   16 ++++++++++++++++
>  include/linux/device.h |    3 +++
>  2 files changed, 19 insertions(+)
> 
> diff --git a/drivers/base/dd.c b/drivers/base/dd.c
> index 88713f182086..ef3f70a7cb5a 100644
> --- a/drivers/base/dd.c
> +++ b/drivers/base/dd.c
> @@ -774,6 +774,10 @@ static void __device_attach_async_helper(void *_dev, async_cookie_t cookie)
>  
>  	device_lock(dev);
>  
> +	/* nothing to do if async_probe has been cleared */
> +	if (!dev->async_probe)
> +		goto out_unlock;
> +
>  	if (dev->parent)
>  		pm_runtime_get_sync(dev->parent);
>  
> @@ -785,6 +789,9 @@ static void __device_attach_async_helper(void *_dev, async_cookie_t cookie)
>  	if (dev->parent)
>  		pm_runtime_put(dev->parent);
>  
> +	/* We made our attempt at an async_probe, clear the flag */
> +	dev->async_probe = false;
> +out_unlock:
>  	device_unlock(dev);
>  
>  	put_device(dev);
> @@ -829,6 +836,7 @@ static int __device_attach(struct device *dev, bool allow_async)
>  			 */
>  			dev_dbg(dev, "scheduling asynchronous probe\n");
>  			get_device(dev);
> +			dev->async_probe = true;
>  			async_schedule(__device_attach_async_helper, dev);
>  		} else {
>  			pm_request_idle(dev);
> @@ -929,6 +937,14 @@ static void __device_release_driver(struct device *dev, struct device *parent)
>  {
>  	struct device_driver *drv;
>  
> +	/*
> +	 * In the event that we are asked to release the driver on an
> +	 * interface that is still waiting on a probe we can just terminate
> +	 * the probe by setting async_probe to false. When the async call
> +	 * is finally completed it will see this state and just exit.
> +	 */
> +	dev->async_probe = false;
> +
>  	drv = dev->driver;
>  	if (drv) {
>  		while (device_links_busy(dev)) {
> diff --git a/include/linux/device.h b/include/linux/device.h
> index 1b25c7a43f4c..4d2eb2c74149 100644
> --- a/include/linux/device.h
> +++ b/include/linux/device.h
> @@ -957,6 +957,8 @@ struct dev_links_info {
>   *              device.
>   * @dma_coherent: this particular device is dma coherent, even if the
>   *		architecture supports non-coherent devices.
> + * @async_probe: This device has an asynchronous probe event pending. Should
> + *		 only be updated while holding device lock.
>   *
>   * At the lowest level, every device in a Linux system is represented by an
>   * instance of struct device. The device structure contains the information
> @@ -1051,6 +1053,7 @@ struct device {
>      defined(CONFIG_ARCH_HAS_SYNC_DMA_FOR_CPU_ALL)
>  	bool			dma_coherent:1;
>  #endif
> +	bool			async_probe:1;
>  };
>  
>  static inline struct device *kobj_to_dev(struct kobject *kobj)
> 

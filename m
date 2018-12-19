Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-f66.google.com (mail-ot1-f66.google.com
 [209.85.210.66])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8E1CA211982E3
 for <linux-nvdimm@lists.01.org>; Wed, 19 Dec 2018 06:28:02 -0800 (PST)
Received: by mail-ot1-f66.google.com with SMTP id f18so19209467otl.11
 for <linux-nvdimm@lists.01.org>; Wed, 19 Dec 2018 06:28:02 -0800 (PST)
MIME-Version: 1.0
References: <154466182249.9126.3905559325944768059.stgit@ahduyck-desk1.jf.intel.com>
 <154466189880.9126.10737761541647369077.stgit@ahduyck-desk1.jf.intel.com>
In-Reply-To: <154466189880.9126.10737761541647369077.stgit@ahduyck-desk1.jf.intel.com>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Wed, 19 Dec 2018 15:27:48 +0100
Message-ID: <CAJZ5v0hSWOb4b7FWJmfi86mYY+T1kedtC=ydS8VMUvpH4ctzbw@mail.gmail.com>
Subject: Re: [driver-core PATCH v9 1/9] driver core: Establish order of
 operations for device_add and device_del via bitflag
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
To: alexander.h.duyck@linux.intel.com
Cc: Len Brown <len.brown@intel.com>, bvanassche@acm.org, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linux PM <linux-pm@vger.kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "Luis R. Rodriguez" <mcgrof@kernel.org>, Pavel Machek <pavel@ucw.cz>, zwisler@kernel.org, Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Dec 13, 2018 at 1:45 AM Alexander Duyck
<alexander.h.duyck@linux.intel.com> wrote:
>
> Add an additional bit flag to the device struct named "dead".
>
> This additional flag provides a guarantee that when a device_del is
> executed on a given interface an async worker will not attempt to attach
> the driver following the earlier device_del call. Previously this
> guarantee was not present and could result in the device_del call
> attempting to remove a driver from an interface only to have the async
> worker attempt to probe the driver later when it finally completes the
> asynchronous probe call.
>
> One additional change added was that I pulled the check for dev->driver
> out of the __device_attach_driver call and instead placed it in the
> __device_attach_async_helper call. This was motivated by the fact that the
> only other caller of this, __device_attach, had already taken the
> device_lock() and checked for dev->driver. Instead of testing for this
> twice in this path it makes more sense to just consolidate the dev->dead
> and dev->driver checks together into one set of checks.
>
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>

Reviewed-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

> ---
>  drivers/base/core.c    |   11 +++++++++++
>  drivers/base/dd.c      |   22 +++++++++++-----------
>  include/linux/device.h |    5 +++++
>  3 files changed, 27 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/base/core.c b/drivers/base/core.c
> index 0073b09bb99f..950e25495726 100644
> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c
> @@ -2080,6 +2080,17 @@ void device_del(struct device *dev)
>         struct kobject *glue_dir = NULL;
>         struct class_interface *class_intf;
>
> +       /*
> +        * Hold the device lock and set the "dead" flag to guarantee that
> +        * the update behavior is consistent with the other bitfields near
> +        * it and that we cannot have an asynchronous probe routine trying
> +        * to run while we are tearing out the bus/class/sysfs from
> +        * underneath the device.
> +        */
> +       device_lock(dev);
> +       dev->dead = true;
> +       device_unlock(dev);
> +
>         /* Notify clients of device removal.  This call must come
>          * before dpm_sysfs_remove().
>          */
> diff --git a/drivers/base/dd.c b/drivers/base/dd.c
> index 88713f182086..74c194ac99df 100644
> --- a/drivers/base/dd.c
> +++ b/drivers/base/dd.c
> @@ -731,15 +731,6 @@ static int __device_attach_driver(struct device_driver *drv, void *_data)
>         bool async_allowed;
>         int ret;
>
> -       /*
> -        * Check if device has already been claimed. This may
> -        * happen with driver loading, device discovery/registration,
> -        * and deferred probe processing happens all at once with
> -        * multiple threads.
> -        */
> -       if (dev->driver)
> -               return -EBUSY;
> -
>         ret = driver_match_device(drv, dev);
>         if (ret == 0) {
>                 /* no match */
> @@ -774,6 +765,15 @@ static void __device_attach_async_helper(void *_dev, async_cookie_t cookie)
>
>         device_lock(dev);
>
> +       /*
> +        * Check if device has already been removed or claimed. This may
> +        * happen with driver loading, device discovery/registration,
> +        * and deferred probe processing happens all at once with
> +        * multiple threads.
> +        */
> +       if (dev->dead || dev->driver)
> +               goto out_unlock;
> +
>         if (dev->parent)
>                 pm_runtime_get_sync(dev->parent);
>
> @@ -784,7 +784,7 @@ static void __device_attach_async_helper(void *_dev, async_cookie_t cookie)
>
>         if (dev->parent)
>                 pm_runtime_put(dev->parent);
> -
> +out_unlock:
>         device_unlock(dev);
>
>         put_device(dev);
> @@ -897,7 +897,7 @@ static int __driver_attach(struct device *dev, void *data)
>         if (dev->parent && dev->bus->need_parent_lock)
>                 device_lock(dev->parent);
>         device_lock(dev);
> -       if (!dev->driver)
> +       if (!dev->dead && !dev->driver)
>                 driver_probe_device(drv, dev);
>         device_unlock(dev);
>         if (dev->parent && dev->bus->need_parent_lock)
> diff --git a/include/linux/device.h b/include/linux/device.h
> index 1b25c7a43f4c..f73dad81e811 100644
> --- a/include/linux/device.h
> +++ b/include/linux/device.h
> @@ -957,6 +957,10 @@ struct dev_links_info {
>   *              device.
>   * @dma_coherent: this particular device is dma coherent, even if the
>   *             architecture supports non-coherent devices.
> + * @dead:      This device is currently either in the process of or has
> + *             been removed from the system. Any asynchronous events
> + *             scheduled for this device should exit without taking any
> + *             action.
>   *
>   * At the lowest level, every device in a Linux system is represented by an
>   * instance of struct device. The device structure contains the information
> @@ -1051,6 +1055,7 @@ struct device {
>      defined(CONFIG_ARCH_HAS_SYNC_DMA_FOR_CPU_ALL)
>         bool                    dma_coherent:1;
>  #endif
> +       bool                    dead:1;
>  };
>
>  static inline struct device *kobj_to_dev(struct kobject *kobj)
>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

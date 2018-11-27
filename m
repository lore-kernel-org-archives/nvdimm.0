Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com
 [IPv6:2607:f8b0:4864:20::343])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6D0AA21A02937
 for <linux-nvdimm@lists.01.org>; Mon, 26 Nov 2018 18:35:17 -0800 (PST)
Received: by mail-ot1-x343.google.com with SMTP id 40so18746614oth.4
 for <linux-nvdimm@lists.01.org>; Mon, 26 Nov 2018 18:35:17 -0800 (PST)
MIME-Version: 1.0
References: <154145223352.29224.8912797012647157172.stgit@ahduyck-desk1.jf.intel.com>
 <154145232484.29224.1635232599636954462.stgit@ahduyck-desk1.jf.intel.com>
In-Reply-To: <154145232484.29224.1635232599636954462.stgit@ahduyck-desk1.jf.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 26 Nov 2018 18:35:05 -0800
Message-ID: <CAPcyv4ieNzbx5iN74ZCAKDesgYt_67iM_DC-A35M=Z9jfR+YAQ@mail.gmail.com>
Subject: Re: [driver-core PATCH v5 5/9] driver core: Establish clear order of
 operations for deferred probe and remove
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
Cc: "Brown, Len" <len.brown@intel.com>, bvanassche@acm.org, Linux-pm mailing list <linux-pm@vger.kernel.org>, Greg KH <gregkh@linuxfoundation.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, jiangshanlai@gmail.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>, zwisler@kernel.org, Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Nov 5, 2018 at 1:12 PM Alexander Duyck
<alexander.h.duyck@linux.intel.com> wrote:
>
> This patch adds an additional bit to the device struct named async_probe.
> This additional bit allows us to guarantee ordering between probe and
> remove operations.
>
> This allows us to guarantee that if we execute a remove operation or a
> driver load attempt on a given interface it will not attempt to update the
> driver member asynchronously following the earlier operation. Previously
> this guarantee was not present and could result in us attempting to remove
> a driver from an interface only to have it show up later when it is
> asynchronously loaded.
>
> One change I made in addition is I replaced the use of "bool X:1" to define
> the bitfield to a "u8 X:1" setup in order to resolve some checkpatch
> warnings.

The usage of "us" in the changelog through me off, please reword this
to explicitly state the subject like: "The additional bit allows the
driver core to guarantee ordering between probe and remove
operations."

> Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> ---
>  drivers/base/dd.c      |  104 +++++++++++++++++++++++++++---------------------
>  include/linux/device.h |    9 ++--
>  2 files changed, 64 insertions(+), 49 deletions(-)
>
> diff --git a/drivers/base/dd.c b/drivers/base/dd.c
> index e74cefeb5b69..ed19cf0d6f9a 100644
> --- a/drivers/base/dd.c
> +++ b/drivers/base/dd.c
> @@ -472,6 +472,8 @@ static int really_probe(struct device *dev, struct device_driver *drv)
>                  drv->bus->name, __func__, drv->name, dev_name(dev));
>         WARN_ON(!list_empty(&dev->devres_head));
>
> +       /* clear async_probe flag as we are no longer deferring driver load */
> +       dev->async_probe = false;
>  re_probe:
>         dev->driver = drv;
>
> @@ -771,6 +773,10 @@ static void __device_attach_async_helper(void *_dev, async_cookie_t cookie)
>
>         device_lock(dev);
>
> +       /* nothing to do if async_probe has been cleared */
> +       if (!dev->async_probe)
> +               goto out_unlock;
> +
>         if (dev->parent)
>                 pm_runtime_get_sync(dev->parent);
>
> @@ -781,7 +787,7 @@ static void __device_attach_async_helper(void *_dev, async_cookie_t cookie)
>
>         if (dev->parent)
>                 pm_runtime_put(dev->parent);
> -
> +out_unlock:
>         device_unlock(dev);
>
>         put_device(dev);
> @@ -826,6 +832,7 @@ static int __device_attach(struct device *dev, bool allow_async)
>                          */
>                         dev_dbg(dev, "scheduling asynchronous probe\n");
>                         get_device(dev);
> +                       dev->async_probe = true;
>                         async_schedule(__device_attach_async_helper, dev);
>                 } else {
>                         pm_request_idle(dev);
> @@ -971,62 +978,69 @@ EXPORT_SYMBOL_GPL(driver_attach);
>   */
>  static void __device_release_driver(struct device *dev, struct device *parent)
>  {
> -       struct device_driver *drv;
> +       struct device_driver *drv = dev->driver;
>
> -       drv = dev->driver;
> -       if (drv) {
> -               while (device_links_busy(dev)) {
> -                       __device_driver_unlock(dev, parent);
> +       /*
> +        * In the event that we are asked to release the driver on an
> +        * interface that is still waiting on a probe we can just terminate
> +        * the probe by setting async_probe to false. When the async call
> +        * is finally completed it will see this state and just exit.
> +        */
> +       dev->async_probe = false;
> +       if (!drv)
> +               return;

Patch 4 deleted the async_synchronize_full() that would have flushed
in-flight ->probe() relative to the current ->remove(). If remove runs
before probe then would seem to be deadlock condition, but if
->remove() runs before probe then dev->driver is NULL and we abort. So
I'm struggling to see what value dev->async_probe provides over
dev->driver?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pl1-f193.google.com (mail-pl1-f193.google.com
 [209.85.214.193])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8C33421A07A92
 for <linux-nvdimm@lists.01.org>; Mon,  5 Nov 2018 17:04:52 -0800 (PST)
Received: by mail-pl1-f193.google.com with SMTP id g59-v6so5307981plb.10
 for <linux-nvdimm@lists.01.org>; Mon, 05 Nov 2018 17:04:52 -0800 (PST)
Message-ID: <1541466289.196084.176.camel@acm.org>
Subject: Re: [driver-core PATCH v5 4/9] driver core: Move
 async_synchronize_full call
From: Bart Van Assche <bvanassche@acm.org>
Date: Mon, 05 Nov 2018 17:04:49 -0800
In-Reply-To: <154145231976.29224.39638353241256116.stgit@ahduyck-desk1.jf.intel.com>
References: <154145223352.29224.8912797012647157172.stgit@ahduyck-desk1.jf.intel.com>
 <154145231976.29224.39638353241256116.stgit@ahduyck-desk1.jf.intel.com>
Mime-Version: 1.0
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
To: Alexander Duyck <alexander.h.duyck@linux.intel.com>, linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Cc: len.brown@intel.com, linux-pm@vger.kernel.org, rafael@kernel.org, jiangshanlai@gmail.com, linux-nvdimm@lists.01.org, pavel@ucw.cz, zwisler@kernel.org, tj@kernel.org, akpm@linux-foundation.org
List-ID: <linux-nvdimm@lists.01.org>

On Mon, 2018-11-05 at 13:11 -0800, Alexander Duyck wrote:
> This patch moves the async_synchronize_full call out of
> __device_release_driver and into driver_detach.
> 
> The idea behind this is that the async_synchronize_full call will only
> guarantee that any existing async operations are flushed. This doesn't do
> anything to guarantee that a hotplug event that may occur while we are
> doing the release of the driver will not be asynchronously scheduled.
> 
> By moving this into the driver_detach path we can avoid potential deadlocks
> as we aren't holding the device lock at this point and we should not have
> the driver we want to flush loaded so the flush will take care of any
> asynchronous events the driver we are detaching might have scheduled.
> 
> Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> ---
>  drivers/base/dd.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/base/dd.c b/drivers/base/dd.c
> index 76c40fe69463..e74cefeb5b69 100644
> --- a/drivers/base/dd.c
> +++ b/drivers/base/dd.c
> @@ -975,9 +975,6 @@ static void __device_release_driver(struct device *dev, struct device *parent)
>  
>  	drv = dev->driver;
>  	if (drv) {
> -		if (driver_allows_async_probing(drv))
> -			async_synchronize_full();
> -
>  		while (device_links_busy(dev)) {
>  			__device_driver_unlock(dev, parent);
>  
> @@ -1087,6 +1084,9 @@ void driver_detach(struct device_driver *drv)
>  	struct device_private *dev_prv;
>  	struct device *dev;
>  
> +	if (driver_allows_async_probing(drv))
> +		async_synchronize_full();
> +
>  	for (;;) {
>  		spin_lock(&drv->p->klist_devices.k_lock);
>  		if (list_empty(&drv->p->klist_devices.k_list)) {

Have you considered to move that async_synchronize_full() call into
bus_remove_driver()? Verifying the correctness of this patch requires to
check whether the async_synchronize_full() comes after the
klist_remove(&drv->p->knode_bus) call. That verification is easier when
the async_synchronize_full() call occurs in bus_remove_driver() instead
of in driver_detach().

Thanks,

Bart.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

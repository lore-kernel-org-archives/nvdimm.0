Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pg1-f193.google.com (mail-pg1-f193.google.com
 [209.85.215.193])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C9D6F21A07A82
 for <linux-nvdimm@lists.01.org>; Fri, 30 Nov 2018 15:21:41 -0800 (PST)
Received: by mail-pg1-f193.google.com with SMTP id d72so3126674pga.9
 for <linux-nvdimm@lists.01.org>; Fri, 30 Nov 2018 15:21:41 -0800 (PST)
Date: Fri, 30 Nov 2018 15:21:37 -0800
From: Luis Chamberlain <mcgrof@kernel.org>
Subject: Re: [driver-core PATCH v7 1/9] driver core: Move
 async_synchronize_full call
Message-ID: <20181130232137.GE28501@garbanzo.do-not-panic.com>
References: <154345118835.18040.17186161872550839244.stgit@ahduyck-desk1.amr.corp.intel.com>
 <154345153162.18040.15354788106932190561.stgit@ahduyck-desk1.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <154345153162.18040.15354788106932190561.stgit@ahduyck-desk1.amr.corp.intel.com>
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
To: Alexander Duyck <alexander.h.duyck@linux.intel.com>, dmitry.torokhov@gmail.com
Cc: len.brown@intel.com, bvanassche@acm.org, linux-pm@vger.kernel.org, gregkh@linuxfoundation.org, linux-nvdimm@lists.01.org, jiangshanlai@gmail.com, linux-kernel@vger.kernel.org, pavel@ucw.cz, zwisler@kernel.org, tj@kernel.org, akpm@linux-foundation.org, rafael@kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Nov 28, 2018 at 04:32:11PM -0800, Alexander Duyck wrote:
> Move the async_synchronize_full call out of __device_release_driver and
> into driver_detach.
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
> Fixes: 765230b5f084 ("driver-core: add asynchronous probing support for drivers")
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>

Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>

  Luis

> ---
>  drivers/base/dd.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/base/dd.c b/drivers/base/dd.c
> index 689ac9dc6d81..88713f182086 100644
> --- a/drivers/base/dd.c
> +++ b/drivers/base/dd.c
> @@ -931,9 +931,6 @@ static void __device_release_driver(struct device *dev, struct device *parent)
>  
>  	drv = dev->driver;
>  	if (drv) {
> -		if (driver_allows_async_probing(drv))
> -			async_synchronize_full();
> -
>  		while (device_links_busy(dev)) {
>  			device_unlock(dev);
>  			if (parent)
> @@ -1039,6 +1036,9 @@ void driver_detach(struct device_driver *drv)
>  	struct device_private *dev_prv;
>  	struct device *dev;
>  
> +	if (driver_allows_async_probing(drv))
> +		async_synchronize_full();
> +
>  	for (;;) {
>  		spin_lock(&drv->p->klist_devices.k_lock);
>  		if (list_empty(&drv->p->klist_devices.k_list)) {
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from cloudserver094114.home.pl (cloudserver094114.home.pl
 [79.96.170.134])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D704C211BFCDD
 for <linux-nvdimm@lists.01.org>; Wed, 30 Jan 2019 15:46:50 -0800 (PST)
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [driver-core PATCH v10 6/9] driver core: Attach devices on CPU
 local to device node
Date: Thu, 31 Jan 2019 00:45:42 +0100
Message-ID: <2520015.o9hhCCUgSl@aspire.rjw.lan>
In-Reply-To: <154818237710.18753.13303508368380513033.stgit@ahduyck-desk1.amr.corp.intel.com>
References: <154818223154.18753.12374915684623789884.stgit@ahduyck-desk1.amr.corp.intel.com>
 <154818237710.18753.13303508368380513033.stgit@ahduyck-desk1.amr.corp.intel.com>
MIME-Version: 1.0
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
To: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Cc: len.brown@intel.com, bvanassche@acm.org, linux-nvdimm@lists.01.org, gregkh@linuxfoundation.org, linux-pm@vger.kernel.org, jiangshanlai@gmail.com, linux-kernel@vger.kernel.org, mcgrof@kernel.org, pavel@ucw.cz, zwisler@kernel.org, tj@kernel.org, akpm@linux-foundation.org, rafael@kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Tuesday, January 22, 2019 7:39:37 PM CET Alexander Duyck wrote:
> Call the asynchronous probe routines on a CPU local to the device node. By
> doing this we should be able to improve our initialization time
> significantly as we can avoid having to access the device from a remote
> node which may introduce higher latency.
> 
> For example, in the case of initializing memory for NVDIMM this can have a
> significant impact as initialing 3TB on remote node can take up to 39
> seconds while initialing it on a local node only takes 23 seconds. It is
> situations like this where we will see the biggest improvement.
> 
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>

Reviewed-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

> ---
>  drivers/base/dd.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/base/dd.c b/drivers/base/dd.c
> index 627ad05064e0..aa6a9c613595 100644
> --- a/drivers/base/dd.c
> +++ b/drivers/base/dd.c
> @@ -829,7 +829,7 @@ static int __device_attach(struct device *dev, bool allow_async)
>  			 */
>  			dev_dbg(dev, "scheduling asynchronous probe\n");
>  			get_device(dev);
> -			async_schedule(__device_attach_async_helper, dev);
> +			async_schedule_dev(__device_attach_async_helper, dev);
>  		} else {
>  			pm_request_idle(dev);
>  		}
> @@ -989,7 +989,7 @@ static int __driver_attach(struct device *dev, void *data)
>  		if (!dev->driver) {
>  			get_device(dev);
>  			dev->p->async_driver = drv;
> -			async_schedule(__driver_attach_async_helper, dev);
> +			async_schedule_dev(__driver_attach_async_helper, dev);
>  		}
>  		device_unlock(dev);
>  		return 0;
> 
> 


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

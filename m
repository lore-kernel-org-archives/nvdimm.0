Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com
 [IPv6:2607:f8b0:4864:20::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 87CCA2115C06D
 for <linux-nvdimm@lists.01.org>; Fri, 28 Sep 2018 10:42:51 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id u197-v6so6133111oif.5
 for <linux-nvdimm@lists.01.org>; Fri, 28 Sep 2018 10:42:51 -0700 (PDT)
MIME-Version: 1.0
References: <20180926214433.13512.30289.stgit@localhost.localdomain>
 <20180926215155.13512.30900.stgit@localhost.localdomain>
In-Reply-To: <20180926215155.13512.30900.stgit@localhost.localdomain>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 28 Sep 2018 10:42:39 -0700
Message-ID: <CAPcyv4hZFQ99jnJnWBDDvrpiXq4zSAxo4C870tzfsN7eQ-8Y7Q@mail.gmail.com>
Subject: Re: [RFC workqueue/driver-core PATCH 4/5] driver core: Use new
 async_schedule_dev command
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
Cc: "Brown, Len" <len.brown@intel.com>, Linux-pm mailing list <linux-pm@vger.kernel.org>, Greg KH <gregkh@linuxfoundation.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, jiangshanlai@gmail.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, zwisler@kernel.org, Pavel Machek <pavel@ucw.cz>, Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Sep 26, 2018 at 2:52 PM Alexander Duyck
<alexander.h.duyck@linux.intel.com> wrote:
>
> This change makes it so that we use the device specific version of the
> async_schedule commands to defer various tasks related to devices. By doing
> this we should see a slight improvement in performance as any device that
> is sensitive to latency/locality in the setup will now be initializing on
> the node closest to the device.
>
> Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> ---
>  drivers/base/dd.c         |    4 ++--
>  drivers/base/power/main.c |   12 ++++++------
>  2 files changed, 8 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/base/dd.c b/drivers/base/dd.c
> index 5ba366c1cb83..81472dc44a70 100644
> --- a/drivers/base/dd.c
> +++ b/drivers/base/dd.c
> @@ -826,7 +826,7 @@ static int __device_attach(struct device *dev, bool allow_async)
>                          */
>                         dev_dbg(dev, "scheduling asynchronous probe\n");
>                         get_device(dev);
> -                       async_schedule(__device_attach_async_helper, dev);
> +                       async_schedule_dev(__device_attach_async_helper, dev);
>                 } else {
>                         pm_request_idle(dev);
>                 }
> @@ -927,7 +927,7 @@ static int __driver_attach(struct device *dev, void *data)
>                 if (!dev->driver) {
>                         get_device(dev);
>                         dev_set_drvdata(dev, drv);
> -                       async_schedule(__driver_attach_async_helper, dev);
> +                       async_schedule_dev(__driver_attach_async_helper, dev);
>                 }

Above looks good to me...

>                 device_unlock(dev);
>                 return 0;
> diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
> index 3f68e2919dc5..8495d9b1e9d0 100644
> --- a/drivers/base/power/main.c
> +++ b/drivers/base/power/main.c

Let's split these changes into their own patch, just in case it causes
a suspend regression we can revert it independently of the async
probing change. It might also be worthwhile to have a positive
indication that this improves the latency of power transitions.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

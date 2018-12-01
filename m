Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pg1-f196.google.com (mail-pg1-f196.google.com
 [209.85.215.196])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 897EE211944A0
 for <linux-nvdimm@lists.01.org>; Fri, 30 Nov 2018 18:48:52 -0800 (PST)
Received: by mail-pg1-f196.google.com with SMTP id w7so3277546pgp.13
 for <linux-nvdimm@lists.01.org>; Fri, 30 Nov 2018 18:48:52 -0800 (PST)
Date: Fri, 30 Nov 2018 18:48:47 -0800
From: Luis Chamberlain <mcgrof@kernel.org>
Subject: Re: [driver-core PATCH v7 4/9] driver core: Probe devices
 asynchronously instead of the driver
Message-ID: <20181201024847.GH28501@garbanzo.do-not-panic.com>
References: <154345118835.18040.17186161872550839244.stgit@ahduyck-desk1.amr.corp.intel.com>
 <154345154692.18040.8161459765233879389.stgit@ahduyck-desk1.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <154345154692.18040.8161459765233879389.stgit@ahduyck-desk1.amr.corp.intel.com>
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
Cc: len.brown@intel.com, Dmitry Torokhov <dmitry.torokhov@gmail.com>, bvanassche@acm.org, linux-pm@vger.kernel.org, gregkh@linuxfoundation.org, linux-nvdimm@lists.01.org, jiangshanlai@gmail.com, linux-kernel@vger.kernel.org, brendanhiggins@google.com, pavel@ucw.cz, zwisler@kernel.org, tj@kernel.org, akpm@linux-foundation.org, rafael@kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Nov 28, 2018 at 04:32:26PM -0800, Alexander Duyck wrote:
> Probe devices asynchronously instead of the driver.

> +static void __driver_attach_async_helper(void *_dev, async_cookie_t cookie)
> +{
> +	struct device *dev = _dev;
> +	struct device_driver *drv;
> +
> +	__device_driver_lock(dev, dev->parent);
> +
> +	/*
> +	 * If someone attempted to bind a driver either successfully or
> +	 * unsuccessfully before we got here we should just skip the driver
> +	 * probe call.
> +	 */
> +	drv = dev_get_drv_async(dev);
> +	if (drv && !dev->driver)
> +		driver_probe_device(drv, dev);

I believe this should mean drivers which have async work on probe can
deadlock. For instance, if a driver does call async_schedule() or a
derivative call does this for it, the kernel will call
async_synchronize_full() and I believe we deadlock.

Are we sure most subsystems which would use async probe will not have
an async_schedule() call?

  Luis
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

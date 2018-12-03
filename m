Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1359221959CB2
 for <linux-nvdimm@lists.01.org>; Mon,  3 Dec 2018 08:44:44 -0800 (PST)
Message-ID: <c60069cf68cd0c674f31f7690406bb97dd39c8da.camel@linux.intel.com>
Subject: Re: [driver-core PATCH v7 4/9] driver core: Probe devices
 asynchronously instead of the driver
From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Date: Mon, 03 Dec 2018 08:44:43 -0800
In-Reply-To: <20181201024847.GH28501@garbanzo.do-not-panic.com>
References: <154345118835.18040.17186161872550839244.stgit@ahduyck-desk1.amr.corp.intel.com>
 <154345154692.18040.8161459765233879389.stgit@ahduyck-desk1.amr.corp.intel.com>
 <20181201024847.GH28501@garbanzo.do-not-panic.com>
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
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: len.brown@intel.com, Dmitry Torokhov <dmitry.torokhov@gmail.com>, bvanassche@acm.org, linux-pm@vger.kernel.org, gregkh@linuxfoundation.org, linux-nvdimm@lists.01.org, jiangshanlai@gmail.com, linux-kernel@vger.kernel.org, brendanhiggins@google.com, pavel@ucw.cz, zwisler@kernel.org, tj@kernel.org, akpm@linux-foundation.org, rafael@kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Fri, 2018-11-30 at 18:48 -0800, Luis Chamberlain wrote:
> On Wed, Nov 28, 2018 at 04:32:26PM -0800, Alexander Duyck wrote:
> > Probe devices asynchronously instead of the driver.
> > +static void __driver_attach_async_helper(void *_dev, async_cookie_t cookie)
> > +{
> > +	struct device *dev = _dev;
> > +	struct device_driver *drv;
> > +
> > +	__device_driver_lock(dev, dev->parent);
> > +
> > +	/*
> > +	 * If someone attempted to bind a driver either successfully or
> > +	 * unsuccessfully before we got here we should just skip the driver
> > +	 * probe call.
> > +	 */
> > +	drv = dev_get_drv_async(dev);
> > +	if (drv && !dev->driver)
> > +		driver_probe_device(drv, dev);
> 
> I believe this should mean drivers which have async work on probe can
> deadlock. For instance, if a driver does call async_schedule() or a
> derivative call does this for it, the kernel will call
> async_synchronize_full() and I believe we deadlock.
> 
> Are we sure most subsystems which would use async probe will not have
> an async_schedule() call?
> 
>   Luis

So the async_schedule call isn't a problem. I would only be an issue if
they are calling async_sychronize_full while we are holding a lock
and/or mutex. To mitigate that I believe many drivers are just using
the domain version of things instead of using the global async calls.

An issue like what you have described would already exist if there is
code like that floating around out there. As is this patch isn't
changing the fact that a driver can load asynchronously. All it is
doing is allowing each device to be handled asynchronously instead of
having just one thread work its way though all the devices one at a
time.

The earlier bug we were addressing in patch 1/9 was something like what
you were describing where we were performing an async_synchronize_full
while holding the device lock. I would think the requirement if you are
going to are going to use async within a driver is to use the domain
specific version instead of just synchronizing entire domains, or if
you must synchronize the entire domain you should not be doing so while
holding any locks and/or mutexs.

One of the reasons why I am using a flag to perform the synchronization
between the device_add and device_del in patch 2 is because technically
any driver can be turned into an asynchronous probing driver by just
adding the kernel parameter <driver>.async_probe. That flag is somewhat
hidden here as dev_get_drv_async was checking for the async_probe flag
in this version of the patch. In the future I plan to replace the
"async_probe" flag with a "dead" flag to indicate that the device is in
the process of doing through a device_del which should accomplish the
same thing.

- Alex

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

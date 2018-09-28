Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com
 [IPv6:2607:f8b0:4864:20::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 757F42112870A
 for <linux-nvdimm@lists.01.org>; Thu, 27 Sep 2018 19:48:54 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id a203-v6so4088478oib.0
 for <linux-nvdimm@lists.01.org>; Thu, 27 Sep 2018 19:48:54 -0700 (PDT)
MIME-Version: 1.0
References: <20180926214433.13512.30289.stgit@localhost.localdomain>
 <20180926215149.13512.51991.stgit@localhost.localdomain>
 <CAPcyv4h5U4Fph52H80QodBRXK+PjS6Zw_6qK2+DXtr=qZT7Gzw@mail.gmail.com>
 <021d55fb-9f6a-0b52-3513-e9c5493bd7d7@linux.intel.com>
In-Reply-To: <021d55fb-9f6a-0b52-3513-e9c5493bd7d7@linux.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 27 Sep 2018 19:48:42 -0700
Message-ID: <CAPcyv4hQJo9HvCw70p+Qnpcg40x=mOsnLvsd1asGc0GD8EP6Sg@mail.gmail.com>
Subject: Re: [RFC workqueue/driver-core PATCH 3/5] driver core: Probe devices
 asynchronously instead of the driver
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

On Thu, Sep 27, 2018 at 8:31 AM Alexander Duyck
<alexander.h.duyck@linux.intel.com> wrote:
>
>
>
> On 9/26/2018 5:48 PM, Dan Williams wrote:
> > On Wed, Sep 26, 2018 at 2:51 PM Alexander Duyck
> > <alexander.h.duyck@linux.intel.com> wrote:
> >>
> >> This change makes it so that we probe devices asynchronously instead of the
> >> driver. This results in us seeing the same behavior if the device is
> >> registered before the driver or after. This way we can avoid serializing
> >> the initialization should the driver not be loaded until after the devices
> >> have already been added.
> >>
> >> The motivation behind this is that if we have a set of devices that
> >> take a significant amount of time to load we can greatly reduce the time to
> >> load by processing them in parallel instead of one at a time. In addition,
> >> each device can exist on a different node so placing a single thread on one
> >> CPU to initialize all of the devices for a given driver can result in poor
> >> performance on a system with multiple nodes.
> >>
> >> One issue I can see with this patch is that I am using the
> >> dev_set/get_drvdata functions to store the driver in the device while I am
> >> waiting on the asynchronous init to complete. For now I am protecting it by
> >> using the lack of a dev->driver and the device lock.
> >>
> >> Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> > [..]
> >> @@ -891,6 +914,25 @@ static int __driver_attach(struct device *dev, void *data)
> >>                  return ret;
> >>          } /* ret > 0 means positive match */
> >>
> >> +       if (driver_allows_async_probing(drv)) {
> >> +               /*
> >> +                * Instead of probing the device synchronously we will
> >> +                * probe it asynchronously to allow for more parallelism.
> >> +                *
> >> +                * We only take the device lock here in order to guarantee
> >> +                * that the dev->driver and driver_data fields are protected
> >> +                */
> >> +               dev_dbg(dev, "scheduling asynchronous probe\n");
> >> +               device_lock(dev);
> >> +               if (!dev->driver) {
> >> +                       get_device(dev);
> >> +                       dev_set_drvdata(dev, drv);
> >> +                       async_schedule(__driver_attach_async_helper, dev);
> >
> > I'm not sure async drivers / sub-systems are ready for their devices
> > to show up in parallel. While userspace should not be relying on
> > kernel device names, people get upset when devices change kernel names
> > from one boot to the next, and I can see this change leading to that
> > scenario.
>
> The thing is the current async behavior already does this if the driver
> is loaded before the device is added. All I am doing is making the
> behavior with the driver loaded first the standard instead of letting it
> work the other way around. This way we get consistent behavior.

Ok, I can see the consistency argument. It's still a behavior change
that needs testing. Configurations that have been living with the
default of synchronous probing of the devices on the bus for a later
arriving driver might be surprised.

That said, I was confusing async probing with device registration in
my thinking, so some of the discovery order / naming concerns may not
be as bad as I was imagining. Sub-systems that would be broken by this
behavior change would already be broken if a driver is built-in vs
module.

So, consider this, an Acked-by.

> > If a driver / sub-system wants more parallelism than what
> > driver_allows_async_probing() provides it should do it locally, for
> > example, like libata does.
>
> So where I actually saw this was with the pmem legacy setup I had. After
> doing all the work to parallelize things in the driver it had no effect.
> That was because the nd_pmem driver wasn't loaded yet so all the
> device_add calls did is add the device but didn't attach the nd_pmem
> driver. Then when the driver loaded it serialized the probe calls
> resulting in it taking twice as long as it needed to in order to
> initialize the memory.
>
> This seems to affect standard persistent memory as well. The only
> difference is that instead of probing the device on the first pass we
> kick it back and reprobe it in nd_pmem_probe/nd_pfn_probe in order to
> set the correct personality and that in turn allows us to asynchronously
> reschedule the work on the correct CPU and deserialize it.

I don't see any problems with this series with the nvdimm unit tests,
but note those tests do not check for discovery order / naming
discrepancies.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

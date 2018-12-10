Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com
 [IPv6:2607:f8b0:4864:20::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 732532194D3B9
 for <linux-nvdimm@lists.01.org>; Mon, 10 Dec 2018 11:43:30 -0800 (PST)
Received: by mail-oi1-x242.google.com with SMTP id i6so10006293oia.6
 for <linux-nvdimm@lists.01.org>; Mon, 10 Dec 2018 11:43:30 -0800 (PST)
MIME-Version: 1.0
References: <154403054034.11544.3978949383914046587.stgit@ahduyck-desk1.jf.intel.com>
 <154403072403.11544.10419282512791659652.stgit@ahduyck-desk1.jf.intel.com>
 <CAPcyv4jH_Op-xHTd2FwQizPaWFx_2FE-pVsOLLmZAEK8EVPrYg@mail.gmail.com>
 <15b6817fd945a1622afe673b46b028bacefad72b.camel@linux.intel.com>
In-Reply-To: <15b6817fd945a1622afe673b46b028bacefad72b.camel@linux.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 10 Dec 2018 11:43:17 -0800
Message-ID: <CAPcyv4i1RTrKYX0YpyCRE=pqt3pHBRiCGQq1wYUriLjKKTVA7A@mail.gmail.com>
Subject: Re: [driver-core PATCH v8 2/9] driver core: Establish order of
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
Cc: "Brown, Len" <len.brown@intel.com>, bvanassche@acm.org, linux-nvdimm <linux-nvdimm@lists.01.org>, Greg KH <gregkh@linuxfoundation.org>, Linux-pm mailing list <linux-pm@vger.kernel.org>, jiangshanlai@gmail.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "Luis R. Rodriguez" <mcgrof@kernel.org>, Pavel Machek <pavel@ucw.cz>, zwisler@kernel.org, Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Dec 10, 2018 at 11:35 AM Alexander Duyck
<alexander.h.duyck@linux.intel.com> wrote:
>
> On Mon, 2018-12-10 at 10:58 -0800, Dan Williams wrote:
> > On Wed, Dec 5, 2018 at 9:25 AM Alexander Duyck
> > <alexander.h.duyck@linux.intel.com> wrote:
> > >
> > > Add an additional bit flag to the device struct named "dead".
> > >
> > > This additional flag provides a guarantee that when a device_del is
> > > executed on a given interface an async worker will not attempt to attach
> > > the driver following the earlier device_del call. Previously this
> > > guarantee was not present and could result in the device_del call
> > > attempting to remove a driver from an interface only to have the async
> > > worker attempt to probe the driver later when it finally completes the
> > > asynchronous probe call.
> > >
> > > Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> > > ---
> > >  drivers/base/core.c    |   11 +++++++++++
> > >  drivers/base/dd.c      |    8 ++++++--
> > >  include/linux/device.h |    5 +++++
> > >  3 files changed, 22 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/drivers/base/core.c b/drivers/base/core.c
> > > index f3e6ca4170b4..70358327303b 100644
> > > --- a/drivers/base/core.c
> > > +++ b/drivers/base/core.c
> > > @@ -2075,6 +2075,17 @@ void device_del(struct device *dev)
> > >         struct kobject *glue_dir = NULL;
> > >         struct class_interface *class_intf;
> > >
> > > +       /*
> > > +        * Hold the device lock and set the "dead" flag to guarantee that
> > > +        * the update behavior is consistent with the other bitfields near
> > > +        * it and that we cannot have an asynchronous probe routine trying
> > > +        * to run while we are tearing out the bus/class/sysfs from
> > > +        * underneath the device.
> > > +        */
> > > +       device_lock(dev);
> > > +       dev->dead = true;
> > > +       device_unlock(dev);
> > > +
> > >         /* Notify clients of device removal.  This call must come
> > >          * before dpm_sysfs_remove().
> > >          */
> > > diff --git a/drivers/base/dd.c b/drivers/base/dd.c
> > > index 88713f182086..3bb8c3e0f3da 100644
> > > --- a/drivers/base/dd.c
> > > +++ b/drivers/base/dd.c
> > > @@ -774,6 +774,10 @@ static void __device_attach_async_helper(void *_dev, async_cookie_t cookie)
> > >
> > >         device_lock(dev);
> > >
> > > +       /* device is or has been removed from the bus, just bail out */
> > > +       if (dev->dead)
> > > +               goto out_unlock;
> > > +
> >
> > What do you think about moving this check into
> > __device_attach_driver() alongside all the other checks? That way we
> > also get ->dead checking through the __device_attach() path.
>
> I'm not really sure that is the best spot to do that. Part of the
> reason being that by placing it where I did we avoid messing with the
> runtime power management for the parent if it was already powered off.

...but this already a rare event and the parent shouldn't otherwise be
bothered by a spurious pm_runtime wakeup event.

> If anything I would say we could probably look at pulling the check out
> and placing the driver check in __device_attach_async_helper since from
> what I can tell the check is actually redundant in the non-async path
> anyway since __device_attach already had taken the device lock and
> checked dev->driver prior to calling __device_attach_driver.
>
> > ...and after that maybe it could be made a common helper
> > (dev_driver_checks()?) shared between __device_attach_driver() and
> > __driver_attach() to reduce some duplication.
>
> I'm not sure consolidating it into a function would really be worth the
> extra effort. It would essentially just obfuscate the checks and I am
> not sure you really save much with:
>         if (dev_driver_checks(dev))
> vs:
>         if (!dev->dead && !dev->driver)
>
> By the time you create the function and replace the few spots that are
> making these checks you would end up most likely adding more complexity
> to the kernel rather than reducing it any.

No, I was talking about removing this duplication in
__device_attach_driver() and __driver_attach():

        if (ret == 0) {
                /* no match */
                return 0;
        } else if (ret == -EPROBE_DEFER) {
                dev_dbg(dev, "Device match requests probe deferral\n");
                driver_deferred_probe_add(dev);
        } else if (ret < 0) {
                dev_dbg(dev, "Bus failed to match device: %d", ret);
                return ret;
        } /* ret > 0 means positive match */

...and lead in with a dev->dead check.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

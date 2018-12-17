Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5DFD221196238
 for <linux-nvdimm@lists.01.org>; Mon, 17 Dec 2018 08:31:49 -0800 (PST)
Message-ID: <96fc96dc7c7856a1f415417bf287936071c32f4d.camel@linux.intel.com>
Subject: Re: [driver-core PATCH v9 2/9] device core: Consolidate locking and
 unlocking of parent and device
From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Date: Mon, 17 Dec 2018 08:31:46 -0800
In-Reply-To: <CAJZ5v0it33gOgjR8KUqsGtykh7UovZ5MUbJeEavHDa2uQSXM0g@mail.gmail.com>
References: <154466182249.9126.3905559325944768059.stgit@ahduyck-desk1.jf.intel.com>
 <154466190393.9126.148371211828405339.stgit@ahduyck-desk1.jf.intel.com>
 <CAJZ5v0it33gOgjR8KUqsGtykh7UovZ5MUbJeEavHDa2uQSXM0g@mail.gmail.com>
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
To: "Rafael J. Wysocki" <rafael@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Len Brown <len.brown@intel.com>, bvanassche@acm.org, Linux PM <linux-pm@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Lai Jiangshan <jiangshanlai@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "Luis R. Rodriguez  <mcgrof@kernel.org>, Pavel Machek <pavel@ucw.cz>, zwisler@kernel.org, Tejun Heo" <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, 2018-12-14 at 11:40 +0100, Rafael J. Wysocki wrote:
>  somOn Thu, Dec 13, 2018 at 1:45 AM Alexander Duyck
> <alexander.h.duyck@linux.intel.com> wrote:
> > 
> > Try to consolidate all of the locking and unlocking of both the parent and
> > device when attaching or removing a driver from a given device.
> > 
> > To do that I first consolidated the lock pattern into two functions
> > __device_driver_lock and __device_driver_unlock. After doing that I then
> > created functions specific to attaching and detaching the driver while
> > acquiring these locks. By doing this I was able to reduce the number of
> > spots where we touch need_parent_lock from 12 down to 4.
> > 
> > This patch should produce no functional changes, it is meant to be a code
> > clean-up/consolidation only.
> > 
> > Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
> > Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> > Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> > Reviewed-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> > ---
> >  drivers/base/base.h |    2 +
> >  drivers/base/bus.c  |   23 ++----------
> >  drivers/base/dd.c   |   95 ++++++++++++++++++++++++++++++++++++++++-----------
> >  3 files changed, 81 insertions(+), 39 deletions(-)
> > 
> > diff --git a/drivers/base/base.h b/drivers/base/base.h
> > index 7a419a7a6235..3f22ebd6117a 100644
> > --- a/drivers/base/base.h
> > +++ b/drivers/base/base.h
> > @@ -124,6 +124,8 @@ extern int driver_add_groups(struct device_driver *drv,
> >                              const struct attribute_group **groups);
> >  extern void driver_remove_groups(struct device_driver *drv,
> >                                  const struct attribute_group **groups);
> > +int device_driver_attach(struct device_driver *drv, struct device *dev);
> > +void device_driver_detach(struct device *dev);
> > 
> >  extern char *make_class_name(const char *name, struct kobject *kobj);
> > 
> > diff --git a/drivers/base/bus.c b/drivers/base/bus.c
> > index b886b15cb53b..74054481007d 100644
> > --- a/drivers/base/bus.c
> > +++ b/drivers/base/bus.c
> > @@ -184,11 +184,7 @@ static ssize_t unbind_store(struct device_driver *drv, const char *buf,
> > 
> >         dev = bus_find_device_by_name(bus, NULL, buf);
> >         if (dev && dev->driver == drv) {
> > -               if (dev->parent && dev->bus->need_parent_lock)
> > -                       device_lock(dev->parent);
> > -               device_release_driver(dev);
> > -               if (dev->parent && dev->bus->need_parent_lock)
> > -                       device_unlock(dev->parent);
> > +               device_driver_detach(dev);
> >                 err = count;
> >         }
> >         put_device(dev);
> > @@ -211,13 +207,7 @@ static ssize_t bind_store(struct device_driver *drv, const char *buf,
> > 
> >         dev = bus_find_device_by_name(bus, NULL, buf);
> >         if (dev && dev->driver == NULL && driver_match_device(drv, dev)) {
> > -               if (dev->parent && bus->need_parent_lock)
> > -                       device_lock(dev->parent);
> > -               device_lock(dev);
> > -               err = driver_probe_device(drv, dev);
> > -               device_unlock(dev);
> > -               if (dev->parent && bus->need_parent_lock)
> > -                       device_unlock(dev->parent);
> > +               err = device_driver_attach(drv, dev);
> > 
> >                 if (err > 0) {
> >                         /* success */
> > @@ -771,13 +761,8 @@ EXPORT_SYMBOL_GPL(bus_rescan_devices);
> >   */
> >  int device_reprobe(struct device *dev)
> >  {
> > -       if (dev->driver) {
> > -               if (dev->parent && dev->bus->need_parent_lock)
> > -                       device_lock(dev->parent);
> > -               device_release_driver(dev);
> > -               if (dev->parent && dev->bus->need_parent_lock)
> > -                       device_unlock(dev->parent);
> > -       }
> > +       if (dev->driver)
> > +               device_driver_detach(dev);
> >         return bus_rescan_devices_helper(dev, NULL);
> >  }
> >  EXPORT_SYMBOL_GPL(device_reprobe);
> > diff --git a/drivers/base/dd.c b/drivers/base/dd.c
> > index 74c194ac99df..f07c16277ed9 100644
> > --- a/drivers/base/dd.c
> > +++ b/drivers/base/dd.c
> > @@ -867,6 +867,64 @@ void device_initial_probe(struct device *dev)
> >         __device_attach(dev, true);
> >  }
> > 
> > +/*
> > + * __device_driver_lock - acquire locks needed to manipulate dev->drv
> > + * @dev: Device we will update driver info for
> > + * @parent: Parent device. Needed if the bus requires parent lock
> > + *
> > + * This function will take the required locks for manipulating dev->drv.
> > + * Normally this will just be the @dev lock, but when called for a USB
> > + * interface, @parent lock will be held as well.
> > + */
> > +static void __device_driver_lock(struct device *dev, struct device *parent)
> > +{
> > +       if (parent && dev->bus->need_parent_lock)
> > +               device_lock(parent);
> > +       device_lock(dev);
> > +}
> > +
> > +/*
> > + * __device_driver_unlock - release locks needed to manipulate dev->drv
> > + * @dev: Device we will update driver info for
> > + * @parent: Parent device. Needed if the bus requires parent lock
> > + *
> > + * This function will release the required locks for manipulating dev->drv.
> > + * Normally this will just be the the @dev lock, but when called for a
> > + * USB interface, @parent lock will be released as well.
> > + */
> > +static void __device_driver_unlock(struct device *dev, struct device *parent)
> > +{
> > +       device_unlock(dev);
> > +       if (parent && dev->bus->need_parent_lock)
> > +               device_unlock(parent);
> > +}
> > +
> > +/**
> > + * device_driver_attach - attach a specific driver to a specific device
> > + * @drv: Driver to attach
> > + * @dev: Device to attach it to
> > + *
> > + * Manually attach driver to a device. Will acquire both @dev lock and
> > + * @dev->parent lock if needed.
> > + */
> > +int device_driver_attach(struct device_driver *drv, struct device *dev)
> > +{
> > +       int ret = 0;
> > +
> > +       __device_driver_lock(dev, dev->parent);
> > +
> > +       /*
> > +        * If device has been removed or someone has already successfully
> > +        * bound a driver before us just skip the driver probe call.
> > +        */
> > +       if (!dev->dead && !dev->driver)
> > +               ret = driver_probe_device(drv, dev);
> > +
> > +       __device_driver_unlock(dev, dev->parent);
> > +
> > +       return ret;
> > +}
> > +
> >  static int __driver_attach(struct device *dev, void *data)
> >  {
> >         struct device_driver *drv = data;
> > @@ -894,14 +952,7 @@ static int __driver_attach(struct device *dev, void *data)
> >                 return ret;
> >         } /* ret > 0 means positive match */
> > 
> > -       if (dev->parent && dev->bus->need_parent_lock)
> > -               device_lock(dev->parent);
> > -       device_lock(dev);
> > -       if (!dev->dead && !dev->driver)
> > -               driver_probe_device(drv, dev);
> > -       device_unlock(dev);
> > -       if (dev->parent && dev->bus->need_parent_lock)
> > -               device_unlock(dev->parent);
> > +       device_driver_attach(drv, dev);
> > 
> >         return 0;
> >  }
> > @@ -932,15 +983,11 @@ static void __device_release_driver(struct device *dev, struct device *parent)
> >         drv = dev->driver;
> >         if (drv) {
> >                 while (device_links_busy(dev)) {
> > -                       device_unlock(dev);
> > -                       if (parent)
> > -                               device_unlock(parent);
> > +                       __device_driver_unlock(dev, parent);
> > 
> >                         device_links_unbind_consumers(dev);
> > -                       if (parent)
> > -                               device_lock(parent);
> > 
> > -                       device_lock(dev);
> > +                       __device_driver_lock(dev, parent);
> >                         /*
> >                          * A concurrent invocation of the same function might
> >                          * have released the driver successfully while this one
> 
> This change will clash with
> https://patchwork.kernel.org/patch/10729571/ somewhat which really
> should go it first as a stable-candidate fix.
> 
> I would suggest rebasing on top of that one, unless Greg has different
> plans here.

Greg, any opinion here? From what I can tell the patch pointed out and
this one both address the same issue. The only real difference is that
the patch called out would be a better stable-candidate fix.

I'm just wondering if the patch set is good as is or if I need to be
submitting a v10 w/ rebase on top of this patch.

Thanks.

- Alex

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

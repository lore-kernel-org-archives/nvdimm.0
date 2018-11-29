Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EB22521962301
 for <linux-nvdimm@lists.01.org>; Thu, 29 Nov 2018 10:07:13 -0800 (PST)
Message-ID: <a5b33ae899fc4131abf0f26af33a6c6b7f462431.camel@linux.intel.com>
Subject: Re: [driver-core PATCH v7 2/9] driver core: Establish clear order
 of operations for deferred probe and remove
From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Date: Thu, 29 Nov 2018 10:07:13 -0800
In-Reply-To: <CAPcyv4gMswOJ3VTaY6P7f=iG_jNBKZyynn22CLrEBB13Fq-8vQ@mail.gmail.com>
References: <154345118835.18040.17186161872550839244.stgit@ahduyck-desk1.amr.corp.intel.com>
 <154345153672.18040.3771035148218843351.stgit@ahduyck-desk1.amr.corp.intel.com>
 <CAPcyv4gMswOJ3VTaY6P7f=iG_jNBKZyynn22CLrEBB13Fq-8vQ@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: "Brown, Len" <len.brown@intel.com>, bvanassche@acm.org, linux-nvdimm <linux-nvdimm@lists.01.org>, Greg KH <gregkh@linuxfoundation.org>, Linux-pm mailing list <linux-pm@vger.kernel.org>, jiangshanlai@gmail.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "Luis R. Rodriguez" <mcgrof@kernel.org>, Pavel Machek <pavel@ucw.cz>, zwisler@kernel.org, Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, 2018-11-28 at 17:57 -0800, Dan Williams wrote:
> On Wed, Nov 28, 2018 at 4:32 PM Alexander Duyck
> <alexander.h.duyck@linux.intel.com> wrote:
> > 
> > Add an additional bit flag to the device struct named async_probe. This
> > additional flag allows us to guarantee ordering between probe and remove
> > operations.
> > 
> > This allows us to guarantee that if we execute a remove operation on a
> 
> You missed the review comment on the usage of "us". I've long been an
> abuser of this as well saying "we" and "us" to casually refer to
> whatever part of the kernel I'm currently modifying. The problem is
> that it is ambiguous and assumes the reader happens translates the
> "us" / "we" to the same specific subject you had in mind. It leaves
> room for confusion that can be eliminated by explicitly referencing
> the expected agent, subject, object in mind.
> 
> I long blew off suggestions to correct usages like this, but it
> finally sunk in for me after reading Thomas' rewrite of a "we" and
> "this" laden changelog, and why he and other tip-maintainers want to
> push back on the usage in the tip tree, see the "Changelog" section of
> the guidance in "[patch 2/2] Documentation/process: Add tip tree
> handbook": https://lkml.org/lkml/2018/11/7/932.
> 
> Patch review is quicker without the speed bumps of translating
> occurrences of the "we" and "us"

It wasn't my intention to blow it off. I have gone through and updated
it in my repo and I can see how it can be confusing as in one spot  I
wasn't sure if the "we"/"us" was the probe or the remove routine.

> > given interface it will not attempt to update the driver member
> > asynchronously following the earlier operation. Previously this guarantee
> > was not present and could result in us attempting to remove a driver from
> > an interface only to have it attempt to attach the driver later when we
> > finally complete the deferred asynchronous probe call.
> > 
> > Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> > Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> > ---
> >  drivers/base/dd.c      |   16 ++++++++++++++++
> >  include/linux/device.h |    3 +++
> >  2 files changed, 19 insertions(+)
> > 
> > diff --git a/drivers/base/dd.c b/drivers/base/dd.c
> > index 88713f182086..ef3f70a7cb5a 100644
> > --- a/drivers/base/dd.c
> > +++ b/drivers/base/dd.c
> > @@ -774,6 +774,10 @@ static void __device_attach_async_helper(void *_dev, async_cookie_t cookie)
> > 
> >         device_lock(dev);
> > 
> > +       /* nothing to do if async_probe has been cleared */
> > +       if (!dev->async_probe)
> > +               goto out_unlock;
> > +
> >         if (dev->parent)
> >                 pm_runtime_get_sync(dev->parent);
> > 
> > @@ -785,6 +789,9 @@ static void __device_attach_async_helper(void *_dev, async_cookie_t cookie)
> >         if (dev->parent)
> >                 pm_runtime_put(dev->parent);
> > 
> > +       /* We made our attempt at an async_probe, clear the flag */
> > +       dev->async_probe = false;
> > +out_unlock:
> >         device_unlock(dev);
> > 
> >         put_device(dev);
> > @@ -829,6 +836,7 @@ static int __device_attach(struct device *dev, bool allow_async)
> >                          */
> >                         dev_dbg(dev, "scheduling asynchronous probe\n");
> >                         get_device(dev);
> > +                       dev->async_probe = true;
> >                         async_schedule(__device_attach_async_helper, dev);
> >                 } else {
> >                         pm_request_idle(dev);
> > @@ -929,6 +937,14 @@ static void __device_release_driver(struct device *dev, struct device *parent)
> >  {
> >         struct device_driver *drv;
> > 
> > +       /*
> > +        * In the event that we are asked to release the driver on an
> > +        * interface that is still waiting on a probe we can just terminate
> > +        * the probe by setting async_probe to false. When the async call
> > +        * is finally completed it will see this state and just exit.
> > +        */
> > +       dev->async_probe = false;
> > +
> >         drv = dev->driver;
> >         if (drv) {
> >                 while (device_links_busy(dev)) {
> > diff --git a/include/linux/device.h b/include/linux/device.h
> > index 1b25c7a43f4c..4d2eb2c74149 100644
> > --- a/include/linux/device.h
> > +++ b/include/linux/device.h
> > @@ -957,6 +957,8 @@ struct dev_links_info {
> >   *              device.
> >   * @dma_coherent: this particular device is dma coherent, even if the
> >   *             architecture supports non-coherent devices.
> > + * @async_probe: This device has an asynchronous probe event pending. Should
> > + *              only be updated while holding device lock.
> >   *
> >   * At the lowest level, every device in a Linux system is represented by an
> >   * instance of struct device. The device structure contains the information
> > @@ -1051,6 +1053,7 @@ struct device {
> >      defined(CONFIG_ARCH_HAS_SYNC_DMA_FOR_CPU_ALL)
> >         bool                    dma_coherent:1;
> >  #endif
> > +       bool                    async_probe:1;
> 
> I think this flag is misnamed, the wrong polarity and should be set in
> the device removal path, not the driver detach path. The wider problem
> is the removal of a device while actions initiated by its arrival may
> still be in flight, or have yet to start. It's not just the probe path
> in the driver-core that might be interested in this state, but also
> bus implementations that kick off their own async operations.

Okay, so increase the scope so that the information is usable outside
of driver core.

> I think the flag should be named "cancel" and set it in the
> device_del() path. Otherwise this is encoding code flow state in the
> struct rather than device-state that the code needs to comprehend.

Instead of "cancel" what would you think of "dead"? In my mind once we
call device_del we are essentially working with a dead device object so
that might make more sense in terms of a state rather than "cancel"
which doesn't really tell us what should be canceled.

Looking over the code I could probably set it before we start calling
the notifiers for BUS_NOTIFY_DEL_DEVICE. The only thing I am not sure
about is if we would need to add any sort of synchronization primitives
around it.

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

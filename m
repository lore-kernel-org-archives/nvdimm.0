Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com
 [IPv6:2607:f8b0:4864:20::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id ACFE121A00AE6
 for <linux-nvdimm@lists.01.org>; Tue, 27 Nov 2018 14:26:26 -0800 (PST)
Received: by mail-oi1-x241.google.com with SMTP id u18so20816439oie.10
 for <linux-nvdimm@lists.01.org>; Tue, 27 Nov 2018 14:26:26 -0800 (PST)
MIME-Version: 1.0
References: <154170028986.12967.2108024712555179678.stgit@ahduyck-desk1.jf.intel.com>
 <154170042103.12967.5841784115552956171.stgit@ahduyck-desk1.jf.intel.com>
 <CAPcyv4ibARHP1Gji2cZQ704BeiKL26Bh13G58eyB+PjQJSD58w@mail.gmail.com>
 <ec672fcf5924ef267f35b11c13ddc50c815b1a9f.camel@linux.intel.com>
 <CAPcyv4gKT1CDA-xVh5LCYEVUeXLB5ktCFqpFhPWzNK7+QbQdvw@mail.gmail.com>
 <e700da0293e8637e56682a4c4c4c37a2929b5efe.camel@linux.intel.com>
In-Reply-To: <e700da0293e8637e56682a4c4c4c37a2929b5efe.camel@linux.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 27 Nov 2018 14:26:13 -0800
Message-ID: <CAPcyv4ige6rMf24UCsFG+41FZ4rPb1PHPGKAX_Ttj2MoNYgqgQ@mail.gmail.com>
Subject: Re: [driver-core PATCH v6 4/9] driver core: Move
 async_synchronize_full call
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
Cc: "Brown, Len" <len.brown@intel.com>, bvanassche@acm.org, Linux-pm mailing list <linux-pm@vger.kernel.org>, Greg KH <gregkh@linuxfoundation.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, jiangshanlai@gmail.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>, zwisler@kernel.org, Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Nov 27, 2018 at 1:36 PM Alexander Duyck
<alexander.h.duyck@linux.intel.com> wrote:
>
> On Tue, 2018-11-27 at 12:35 -0800, Dan Williams wrote:
> > On Tue, Nov 27, 2018 at 9:38 AM Alexander Duyck
> > <alexander.h.duyck@linux.intel.com> wrote:
> > >
> > > On Mon, 2018-11-26 at 18:11 -0800, Dan Williams wrote:
> > > > On Thu, Nov 8, 2018 at 10:07 AM Alexander Duyck
> > > > <alexander.h.duyck@linux.intel.com> wrote:
> > > > >
> > > > > Move the async_synchronize_full call out of __device_release_driver and
> > > > > into driver_detach.
> > > > >
> > > > > The idea behind this is that the async_synchronize_full call will only
> > > > > guarantee that any existing async operations are flushed. This doesn't do
> > > > > anything to guarantee that a hotplug event that may occur while we are
> > > > > doing the release of the driver will not be asynchronously scheduled.
> > > > >
> > > > > By moving this into the driver_detach path we can avoid potential deadlocks
> > > > > as we aren't holding the device lock at this point and we should not have
> > > > > the driver we want to flush loaded so the flush will take care of any
> > > > > asynchronous events the driver we are detaching might have scheduled.
> > > > >
> > > >
> > > > What problem is this patch solving in practice, because if there were
> > > > drivers issuing async work from probe they would need to be
> > > > responsible for flushing it themselves. That said it seems broken that
> > > > the async probing infrastructure takes the device_lock inside
> > > > async_schedule and then holds the lock when calling
> > > > async_syncrhonize_full. Is it just luck that this hasn't caused
> > > > deadlocks in practice?
> > >
> > > My understanding is that it has caused some deadlocks. There was
> > > another patch set that Bart Van Assche had submitted that was
> > > addressing this. I just tweaked my patch set to address both the issues
> > > he had seen as well as the performance improvements included in my
> > > original patch set.
> >
> > I tried to go find that discussion, but failed. It would help to
> > report an actual failure rather than a theoretical one.
>
> His patch set can be found at:
> https://patchwork.kernel.org/project/linux-scsi/list/?series=32209&state=*
>
> Your comments can be found in patch 3 on how his set and mine were
> similar, and patch 4 in his set is what I am replacing with patch 4 in
> this set.

Thanks, yeah this little backstory should be summarized / linked in
the patch description for the async scanning ordering change so it's a
chorus of reports about the deficiencies of the current driver-core
implementation.

> Actually just looking at it I should probably pull in his "fixes" tag.

Perhaps also ask Dmitry to re-ack this new one that includes the early sync.

>
> > > > Given that the device_lock is hidden from lockdep I think it would be
> > > > helpful to have a custom lock_map_acquire() setup, similar to the
> > > > workqueue core, to try to keep the locking rules enforced /
> > > > documented.
> > > >
> > > > The only documentation I can find for async-probe deadlock avoidance
> > > > is the comment block in do_init_module() for async_probe_requested.
> > >
> > > Would it make sense to just add any lockdep or deadlock documentation
> > > as a seperate patch? I can work on it but I am not sure it makes sense
> > > to add to this patch since there is a chance this one will need to be
> > > backported to stable at some point.
> >
> > Yes, separate follow-on sounds ok.
> >
> > > > Stepping back a bit, does this patch have anything to do with the
> > > > performance improvement, or is it a separate "by the way I also found
> > > > this" kind of patch?
> > >
> > > This is more of a seperate "by the way" type of patch based on the
> > > discussion Bart and I had about how to best address the issue. There
> > > may be some improvement since we only call async_synchronize_full once
> > > and only when we are removing the driver, but I don't think it would be
> > > very noticable.
> >
> > Ok, might be worthwhile to submit this at the front of the series as a
> > fix that has implications for what comes later. The only concern is
> > whether this fix stands alone. It would seem to make the possibility
> > of ->remove() racing ->probe() worse, no? Can we make this change
> > without the new/proposed ->async_probe tracking infrastructure?
>
> Yeah, I might move this up to patch 1 of the set since this is a fix.
>
> There end up being a ton of bugs in the way this was originally
> handled. So for example if I am not mistaken you only hit the flush if
> we find the dev->driver is already set to the driver we are removing.
> By moving it to where I did and changing the check so that it is based
> on the driver we are removing we can guarantee that we force the flush
> at before we start walking the driver->p->klist_devices list which
> isn't populated until after a device is probed.
>
> As far as ->remove racing with ->probe I don't see this change making
> it any worse than it was. The same race is still there that was there
> before. The only difference is that we don't have the false sense of
> security from having a flush there that doesn't do anything.
>

Ok, makes sense, you can add my Reviewed-by to that resend, because
the fact that the probe takes the device_lock() in the async run queue
and the remove path takes the device_lock() and then flushes the async
run queue is an obvious deadlock.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com
 [IPv6:2607:f8b0:4864:20::341])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9DD1821194D3F
 for <linux-nvdimm@lists.01.org>; Thu, 29 Nov 2018 14:00:25 -0800 (PST)
Received: by mail-ot1-x341.google.com with SMTP id e12so3278431otl.5
 for <linux-nvdimm@lists.01.org>; Thu, 29 Nov 2018 14:00:25 -0800 (PST)
MIME-Version: 1.0
References: <154345118835.18040.17186161872550839244.stgit@ahduyck-desk1.amr.corp.intel.com>
 <154345153672.18040.3771035148218843351.stgit@ahduyck-desk1.amr.corp.intel.com>
 <CAPcyv4gMswOJ3VTaY6P7f=iG_jNBKZyynn22CLrEBB13Fq-8vQ@mail.gmail.com>
 <a5b33ae899fc4131abf0f26af33a6c6b7f462431.camel@linux.intel.com>
 <CAPcyv4j2w6ygzuP-vEKPk6NGLCEB6FcKTVFQkUqr3HC471xJsg@mail.gmail.com>
 <53173cf971f5fbd33d744a1734dda87cb66c4206.camel@linux.intel.com>
In-Reply-To: <53173cf971f5fbd33d744a1734dda87cb66c4206.camel@linux.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 29 Nov 2018 14:00:12 -0800
Message-ID: <CAPcyv4gJvjB-tWwW65q5uXW7xABZ0WmfSNVHG5C437MgoEC+QQ@mail.gmail.com>
Subject: Re: [driver-core PATCH v7 2/9] driver core: Establish clear order of
 operations for deferred probe and remove
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

On Thu, Nov 29, 2018 at 1:54 PM Alexander Duyck
<alexander.h.duyck@linux.intel.com> wrote:
>
> On Thu, 2018-11-29 at 10:55 -0800, Dan Williams wrote:
> > On Thu, Nov 29, 2018 at 10:07 AM Alexander Duyck
> > <alexander.h.duyck@linux.intel.com> wrote:
> > >
> > > On Wed, 2018-11-28 at 17:57 -0800, Dan Williams wrote:
> >
> > [..]
> > > > I think the flag should be named "cancel" and set it in the
> > > > device_del() path. Otherwise this is encoding code flow state in the
> > > > struct rather than device-state that the code needs to comprehend.
> > >
> > > Instead of "cancel" what would you think of "dead"? In my mind once we
> > > call device_del we are essentially working with a dead device object so
> > > that might make more sense in terms of a state rather than "cancel"
> > > which doesn't really tell us what should be canceled.
> >
> > That sounds good to me.
> >
> > > Looking over the code I could probably set it before we start calling
> > > the notifiers for BUS_NOTIFY_DEL_DEVICE. The only thing I am not sure
> > > about is if we would need to add any sort of synchronization primitives
> > > around it.
> > >
> >
> > I think it needs to be something like a barrier:
> >
> >     dev->dead;
> >     device_lock();
> >     device_unlock();
> >
> > ...where you can be sure that anyone after that device_unlock() has
> > acted on dev->dead, or will see dev->dead.
>
> Actually what I think I will do is set dev->dead to true with the
> device lock held at the start of device_del. So something like:
>         device_lock();
>         dev->dead = true;
>         device_unlock();

Yeah, the lock is needed anyway since it's a bitfield.

> It seems like that would probably make the most sense and be consistent
> with the handling of other bits such as dev->offline. It means adding
> one more call to device_lock/unlock but it guarantees that the update
> behavior is consistent with the other bitfields near it and that we
> cannot have an asynchronous probe routine trying to run while we are
> tearing out the bus/class/sysfs from underneath the device.

I think that last statement

"guarantee that the update behavior is consistent with the other
bitfields near it and that we cannot have an asynchronous probe
routine trying to run while we are tearing out the bus/class/sysfs
from underneath the device."

...would be good to include as a comment when setting 'dead' to true.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

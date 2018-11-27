Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com
 [IPv6:2607:f8b0:4864:20::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 708BC21A07A82
 for <linux-nvdimm@lists.01.org>; Mon, 26 Nov 2018 18:11:31 -0800 (PST)
Received: by mail-oi1-x243.google.com with SMTP id v6so17923851oif.2
 for <linux-nvdimm@lists.01.org>; Mon, 26 Nov 2018 18:11:31 -0800 (PST)
MIME-Version: 1.0
References: <154170028986.12967.2108024712555179678.stgit@ahduyck-desk1.jf.intel.com>
 <154170042103.12967.5841784115552956171.stgit@ahduyck-desk1.jf.intel.com>
In-Reply-To: <154170042103.12967.5841784115552956171.stgit@ahduyck-desk1.jf.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 26 Nov 2018 18:11:19 -0800
Message-ID: <CAPcyv4ibARHP1Gji2cZQ704BeiKL26Bh13G58eyB+PjQJSD58w@mail.gmail.com>
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

On Thu, Nov 8, 2018 at 10:07 AM Alexander Duyck
<alexander.h.duyck@linux.intel.com> wrote:
>
> Move the async_synchronize_full call out of __device_release_driver and
> into driver_detach.
>
> The idea behind this is that the async_synchronize_full call will only
> guarantee that any existing async operations are flushed. This doesn't do
> anything to guarantee that a hotplug event that may occur while we are
> doing the release of the driver will not be asynchronously scheduled.
>
> By moving this into the driver_detach path we can avoid potential deadlocks
> as we aren't holding the device lock at this point and we should not have
> the driver we want to flush loaded so the flush will take care of any
> asynchronous events the driver we are detaching might have scheduled.
>

What problem is this patch solving in practice, because if there were
drivers issuing async work from probe they would need to be
responsible for flushing it themselves. That said it seems broken that
the async probing infrastructure takes the device_lock inside
async_schedule and then holds the lock when calling
async_syncrhonize_full. Is it just luck that this hasn't caused
deadlocks in practice?

Given that the device_lock is hidden from lockdep I think it would be
helpful to have a custom lock_map_acquire() setup, similar to the
workqueue core, to try to keep the locking rules enforced /
documented.

The only documentation I can find for async-probe deadlock avoidance
is the comment block in do_init_module() for async_probe_requested.

Stepping back a bit, does this patch have anything to do with the
performance improvement, or is it a separate "by the way I also found
this" kind of patch?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

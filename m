Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3E40A211A458F
 for <linux-nvdimm@lists.01.org>; Thu, 20 Dec 2018 07:28:47 -0800 (PST)
Date: Thu, 20 Dec 2018 16:28:44 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [driver-core PATCH v9 1/9] driver core: Establish order of
 operations for device_add and device_del via bitflag
Message-ID: <20181220152844.GA27498@kroah.com>
References: <154466182249.9126.3905559325944768059.stgit@ahduyck-desk1.jf.intel.com>
 <154466189880.9126.10737761541647369077.stgit@ahduyck-desk1.jf.intel.com>
 <CAJZ5v0hSWOb4b7FWJmfi86mYY+T1kedtC=ydS8VMUvpH4ctzbw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAJZ5v0hSWOb4b7FWJmfi86mYY+T1kedtC=ydS8VMUvpH4ctzbw@mail.gmail.com>
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
To: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Len Brown <len.brown@intel.com>, bvanassche@acm.org, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Linux PM <linux-pm@vger.kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "Luis R. Rodriguez" <mcgrof@kernel.org>, Pavel Machek <pavel@ucw.cz>, zwisler@kernel.org, Tejun Heo <tj@kernel.org>, alexander.h.duyck@linux.intel.com, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Dec 19, 2018 at 03:27:48PM +0100, Rafael J. Wysocki wrote:
> On Thu, Dec 13, 2018 at 1:45 AM Alexander Duyck
> <alexander.h.duyck@linux.intel.com> wrote:
> >
> > Add an additional bit flag to the device struct named "dead".
> >
> > This additional flag provides a guarantee that when a device_del is
> > executed on a given interface an async worker will not attempt to attach
> > the driver following the earlier device_del call. Previously this
> > guarantee was not present and could result in the device_del call
> > attempting to remove a driver from an interface only to have the async
> > worker attempt to probe the driver later when it finally completes the
> > asynchronous probe call.
> >
> > One additional change added was that I pulled the check for dev->driver
> > out of the __device_attach_driver call and instead placed it in the
> > __device_attach_async_helper call. This was motivated by the fact that the
> > only other caller of this, __device_attach, had already taken the
> > device_lock() and checked for dev->driver. Instead of testing for this
> > twice in this path it makes more sense to just consolidate the dev->dead
> > and dev->driver checks together into one set of checks.
> >
> > Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> > Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> 
> Reviewed-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

It's too late for 4.21-rc1 as my tree should be closed by now.

So I'll hold on to these in my queue until 4.21-rc1 is out and then
queue them up and see what breaks in linux-next :)

thanks,

greg k-h
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

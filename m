Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pg1-f196.google.com (mail-pg1-f196.google.com
 [209.85.215.196])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1C0AC2117D76B
 for <linux-nvdimm@lists.01.org>; Tue, 27 Nov 2018 12:33:02 -0800 (PST)
Received: by mail-pg1-f196.google.com with SMTP id z10so8381539pgp.7
 for <linux-nvdimm@lists.01.org>; Tue, 27 Nov 2018 12:33:02 -0800 (PST)
Message-ID: <1543350780.185366.81.camel@acm.org>
Subject: Re: [driver-core PATCH v6 9/9] libnvdimm: Schedule device
 registration on node local to the device
From: Bart Van Assche <bvanassche@acm.org>
Date: Tue, 27 Nov 2018 12:33:00 -0800
In-Reply-To: <CAPcyv4gWwsYOeXVNDoDy4v=SU6bRyBG1fgSu84y64jGApaJ91g@mail.gmail.com>
References: <154170028986.12967.2108024712555179678.stgit@ahduyck-desk1.jf.intel.com>
 <154170044652.12967.17419321472770956712.stgit@ahduyck-desk1.jf.intel.com>
 <CAPcyv4jmTbHZbs2KHhH2_S6=mxxkwdiJCDL6widexMzePhNFBg@mail.gmail.com>
 <2031cf4705d76dd4d0f722a600a6a106cce2ba41.camel@linux.intel.com>
 <CAPcyv4gWwsYOeXVNDoDy4v=SU6bRyBG1fgSu84y64jGApaJ91g@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>, alexander.h.duyck@linux.intel.com
Cc: "Brown, Len" <len.brown@intel.com>, Linux-pm mailing list <linux-pm@vger.kernel.org>, Greg KH <gregkh@linuxfoundation.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, jiangshanlai@gmail.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>, zwisler@kernel.org, Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, 2018-11-27 at 11:34 -0800, Dan Williams wrote:
> On Tue, Nov 27, 2018 at 10:04 AM Alexander Duyck
> <alexander.h.duyck@linux.intel.com> wrote:
> > 
> > On Mon, 2018-11-26 at 18:21 -0800, Dan Williams wrote:
> > > On Thu, Nov 8, 2018 at 10:07 AM Alexander Duyck
> > > <alexander.h.duyck@linux.intel.com> wrote:
> > > > 
> > > > Force the device registration for nvdimm devices to be closer to the actual
> > > > device. This is achieved by using either the NUMA node ID of the region, or
> > > > of the parent. By doing this we can have everything above the region based
> > > > on the region, and everything below the region based on the nvdimm bus.
> > > > 
> > > > By guaranteeing NUMA locality I see an improvement of as high as 25% for
> > > > per-node init of a system with 12TB of persistent memory.
> > > > 
> > > 
> > > It seems the speed-up is achieved with just patches 1, 2, and 9 from
> > > this series, correct? I wouldn't want to hold up that benefit while
> > > the driver-core bits are debated.
> > 
> > Actually patch 6 ends up impacting things for persistent memory as
> > well. The problem is that all the async calls to add interfaces only do
> > anything if the driver is already loaded. So there are cases such as
> > the X86_PMEM_LEGACY_DEVICE case where the memory regions end up still
> > being serialized because the devices are added before the driver.
> 
> Ok, but is the patch 6 change generally useful outside of the
> libnvdimm case? Yes, local hacks like MODULE_SOFTDEP are terrible for
> global problems, but what I'm trying to tease out if this change
> benefits other async probing subsystems outside of libnvdimm, SCSI
> perhaps? Bart can you chime in with the benefits you see so it's clear
> to Greg that the driver-core changes are a generic improvement?

Hi Dan,

For SCSI asynchronous probing is really important because when scanning SAN
LUNs there is plenty of potential for concurrency due to the network delay.

I think the following quote provides the information you are looking for:

"This patch reduces the time needed for loading the scsi_debug kernel
module with parameters delay=0 and max_luns=256 from 0.7s to 0.1s. In
other words, this specific test runs about seven times faster."

Source: https://www.spinics.net/lists/linux-scsi/msg124457.html

Best regards,

Bart.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

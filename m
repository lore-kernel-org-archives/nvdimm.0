Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pl1-f193.google.com (mail-pl1-f193.google.com
 [209.85.214.193])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 567DD2119173C
 for <linux-nvdimm@lists.01.org>; Tue, 27 Nov 2018 13:22:30 -0800 (PST)
Received: by mail-pl1-f193.google.com with SMTP id z23so16243434plo.0
 for <linux-nvdimm@lists.01.org>; Tue, 27 Nov 2018 13:22:30 -0800 (PST)
Message-ID: <1543353746.185366.90.camel@acm.org>
Subject: Re: [driver-core PATCH v6 9/9] libnvdimm: Schedule device
 registration on node local to the device
From: Bart Van Assche <bvanassche@acm.org>
Date: Tue, 27 Nov 2018 13:22:26 -0800
In-Reply-To: <CAPcyv4hya0ASfVue6GH3ZXKJOzytQXDqtEWxvrEdCTcb545tYg@mail.gmail.com>
References: <154170028986.12967.2108024712555179678.stgit@ahduyck-desk1.jf.intel.com>
 <154170044652.12967.17419321472770956712.stgit@ahduyck-desk1.jf.intel.com>
 <CAPcyv4jmTbHZbs2KHhH2_S6=mxxkwdiJCDL6widexMzePhNFBg@mail.gmail.com>
 <2031cf4705d76dd4d0f722a600a6a106cce2ba41.camel@linux.intel.com>
 <CAPcyv4gWwsYOeXVNDoDy4v=SU6bRyBG1fgSu84y64jGApaJ91g@mail.gmail.com>
 <1543350780.185366.81.camel@acm.org>
 <CAPcyv4hya0ASfVue6GH3ZXKJOzytQXDqtEWxvrEdCTcb545tYg@mail.gmail.com>
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
Cc: "Brown, Len" <len.brown@intel.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Greg KH <gregkh@linuxfoundation.org>, Linux-pm mailing list <linux-pm@vger.kernel.org>, jiangshanlai@gmail.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>, zwisler@kernel.org, Tejun Heo <tj@kernel.org>, alexander.h.duyck@linux.intel.com, Andrew Morton <akpm@linux-foundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, 2018-11-27 at 12:50 -0800, Dan Williams wrote:
> Thanks Bart, so tying this back to Alex's patches, does the ordering
> problem that Alex's patches solve impact the SCSI case? I'm looking
> for something like "SCSI depends on asynchronous probing and without
> 'driver core: Establish clear order of operations for deferred probe
> and remove' probing is often needlessly serialized". I.e. does it
> suffer from the same platform problem that libnvdimm ran into where
> it's local async probing implementation was hindered by the driver
> core?

(+Martin)

Hi Dan,

Patch 6/9 reduces the time needed to scan SCSI LUNs significantly. The only
way to realize that speedup is by enabling more concurrency. That's why I
think that patch 6/9 is a significant driver core improvement.

Bart.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com
 [IPv6:2607:f8b0:4864:20::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C35BA21A07A82
 for <linux-nvdimm@lists.01.org>; Mon, 26 Nov 2018 18:21:44 -0800 (PST)
Received: by mail-oi1-x241.google.com with SMTP id u18so17914685oie.10
 for <linux-nvdimm@lists.01.org>; Mon, 26 Nov 2018 18:21:44 -0800 (PST)
MIME-Version: 1.0
References: <154170028986.12967.2108024712555179678.stgit@ahduyck-desk1.jf.intel.com>
 <154170044652.12967.17419321472770956712.stgit@ahduyck-desk1.jf.intel.com>
In-Reply-To: <154170044652.12967.17419321472770956712.stgit@ahduyck-desk1.jf.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 26 Nov 2018 18:21:33 -0800
Message-ID: <CAPcyv4jmTbHZbs2KHhH2_S6=mxxkwdiJCDL6widexMzePhNFBg@mail.gmail.com>
Subject: Re: [driver-core PATCH v6 9/9] libnvdimm: Schedule device
 registration on node local to the device
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
> Force the device registration for nvdimm devices to be closer to the actual
> device. This is achieved by using either the NUMA node ID of the region, or
> of the parent. By doing this we can have everything above the region based
> on the region, and everything below the region based on the nvdimm bus.
>
> By guaranteeing NUMA locality I see an improvement of as high as 25% for
> per-node init of a system with 12TB of persistent memory.
>

It seems the speed-up is achieved with just patches 1, 2, and 9 from
this series, correct? I wouldn't want to hold up that benefit while
the driver-core bits are debated.

You can add:

    Reviewed-by: Dan Williams <dan.j.williams@intel.com>

...if the series needs to be kept together, but as far as I can see
the workqueue changes enable 2 sub-topics of development and it might
make sense for Tejun to take those first 2 and then Greg and I can
base any follow-up topics on that stable baseline.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

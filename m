Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com
 [IPv6:2607:f8b0:4864:20::344])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 869A721B02822
 for <linux-nvdimm@lists.01.org>; Mon, 26 Nov 2018 17:10:30 -0800 (PST)
Received: by mail-ot1-x344.google.com with SMTP id 32so18556435ota.12
 for <linux-nvdimm@lists.01.org>; Mon, 26 Nov 2018 17:10:30 -0800 (PST)
MIME-Version: 1.0
References: <154170028986.12967.2108024712555179678.stgit@ahduyck-desk1.jf.intel.com>
 <154170041079.12967.13132220574997822111.stgit@ahduyck-desk1.jf.intel.com>
In-Reply-To: <154170041079.12967.13132220574997822111.stgit@ahduyck-desk1.jf.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 26 Nov 2018 17:10:18 -0800
Message-ID: <CAPcyv4jZdgkJ=12GJ_CoN5Van5=Ag+mGTjJjCWtj7oGD5dBG2w@mail.gmail.com>
Subject: Re: [driver-core PATCH v6 2/9] async: Add support for queueing on
 specific NUMA node
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

On Thu, Nov 8, 2018 at 10:06 AM Alexander Duyck
<alexander.h.duyck@linux.intel.com> wrote:
>
> Introduce four new variants of the async_schedule_ functions that allow
> scheduling on a specific NUMA node.
>
> The first two functions are async_schedule_near and
> async_schedule_near_domain end up mapping to async_schedule and
> async_schedule_domain, but provide NUMA node specific functionality. They
> replace the original functions which were moved to inline function
> definitions that call the new functions while passing NUMA_NO_NODE.
>
> The second two functions are async_schedule_dev and
> async_schedule_dev_domain which provide NUMA specific functionality when
> passing a device as the data member and that device has a NUMA node other
> than NUMA_NO_NODE.
>
> The main motivation behind this is to address the need to be able to
> schedule device specific init work on specific NUMA nodes in order to
> improve performance of memory initialization.

What Andrew tends to due when an enhancement is spread over multiple
patches is to duplicate the motivation in each patch. So here you
could include the few sentences you wrote about the performance
benefits of this work:

"What I have seen on several systems is a pretty significant improvement
in initialization time for persistent memory. In the case of 3TB of
memory being initialized on a single node the improvement in the worst
case was from about 36s down to 26s for total initialization time."

...and conclude that the data shows a general benefit for affinitizing
async work to a specific numa node.

With that changelog clarification:

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

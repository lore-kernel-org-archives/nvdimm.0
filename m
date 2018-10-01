Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-yw1-xc41.google.com (mail-yw1-xc41.google.com
 [IPv6:2607:f8b0:4864:20::c41])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E08E421AE30DB
 for <linux-nvdimm@lists.01.org>; Mon,  1 Oct 2018 09:01:46 -0700 (PDT)
Received: by mail-yw1-xc41.google.com with SMTP id v198-v6so833033ywg.12
 for <linux-nvdimm@lists.01.org>; Mon, 01 Oct 2018 09:01:46 -0700 (PDT)
Date: Mon, 1 Oct 2018 09:01:42 -0700
From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC workqueue/driver-core PATCH 1/5] workqueue: Provide
 queue_work_near to queue work near a given NUMA node
Message-ID: <20181001160142.GE270328@devbig004.ftw2.facebook.com>
References: <20180926214433.13512.30289.stgit@localhost.localdomain>
 <20180926215138.13512.33146.stgit@localhost.localdomain>
 <20180926215307.GA270328@devbig004.ftw2.facebook.com>
 <9b002bbb-3e6d-9e99-d8f9-36df4306093e@linux.intel.com>
 <20180926220957.GB270328@devbig004.ftw2.facebook.com>
 <ba72f007-84e2-6fe0-b128-d876dadef5f5@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <ba72f007-84e2-6fe0-b128-d876dadef5f5@linux.intel.com>
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
To: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Cc: len.brown@intel.com, linux-pm@vger.kernel.org, gregkh@linuxfoundation.org, linux-nvdimm@lists.01.org, jiangshanlai@gmail.com, linux-kernel@vger.kernel.org, zwisler@kernel.org, pavel@ucw.cz, rafael@kernel.org, akpm@linux-foundation.org
List-ID: <linux-nvdimm@lists.01.org>

Hello,

On Wed, Sep 26, 2018 at 03:19:21PM -0700, Alexander Duyck wrote:
> On 9/26/2018 3:09 PM, Tejun Heo wrote:
> I could just use queue_work_on probably, but is there any issue if I
> am passing CPU values that are not in the wq_unbound_cpumask? That

That should be fine.  If it can't find any available cpu, it'll fall
back to round-robin.  We probably can improve it so that it can
consider the numa distance when falling back.

> was mostly my concern. Also for an unbound queue do I need to worry
> about the hotplug lock? I wasn't sure if that was the case or not as

Issuers don't need to worry about them.

> I know it is called out as something to be concerned with using
> queue_work_on, but in __queue_work the value is just used to
> determine which node to grab a work queue from.

It might be better to leave queue_work_on() to be used for per-cpu
workqueues and introduce queue_work_near() as you suggseted.  I just
don't want it to duplicate the node selection code in it.  Would that
work?

> I forgot to address your question about the advantages. They are
> pretty significant. The test system I was working with was
> initializing 3TB of nvdimm memory per node. If the node is aligned
> it takes something like 24 seconds, whereas an unaligned core can
> take 36 seconds or more.

Oh yeah, sure, numa affinity matters quite a bit on memory heavy
workloads.  I was mistaken that you were adding adding numa affinity
to per-cpu workqueues.

Thanks.

-- 
tejun
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

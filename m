Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com
 [IPv6:2607:f8b0:4864:20::b43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 17A9121B02822
 for <linux-nvdimm@lists.01.org>; Tue,  2 Oct 2018 11:41:30 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id 184-v6so1244169ybg.1
 for <linux-nvdimm@lists.01.org>; Tue, 02 Oct 2018 11:41:30 -0700 (PDT)
Date: Tue, 2 Oct 2018 11:41:27 -0700
From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC workqueue/driver-core PATCH 1/5] workqueue: Provide
 queue_work_near to queue work near a given NUMA node
Message-ID: <20181002184127.GH270328@devbig004.ftw2.facebook.com>
References: <20180926214433.13512.30289.stgit@localhost.localdomain>
 <20180926215138.13512.33146.stgit@localhost.localdomain>
 <20180926215307.GA270328@devbig004.ftw2.facebook.com>
 <9b002bbb-3e6d-9e99-d8f9-36df4306093e@linux.intel.com>
 <20180926220957.GB270328@devbig004.ftw2.facebook.com>
 <ba72f007-84e2-6fe0-b128-d876dadef5f5@linux.intel.com>
 <20181001160142.GE270328@devbig004.ftw2.facebook.com>
 <4eebc017-23a2-a26e-095c-66433061a141@linux.intel.com>
 <20181002174116.GG270328@devbig004.ftw2.facebook.com>
 <be9081de-f186-b265-934d-78cec2a8792f@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <be9081de-f186-b265-934d-78cec2a8792f@linux.intel.com>
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

On Tue, Oct 02, 2018 at 11:23:26AM -0700, Alexander Duyck wrote:
> >Yeah, it's all in wq_select_unbound_cpu().  Right now, if the
> >requested cpu isn't in wq_unbound_cpumask, it falls back to dumb
> >round-robin.  We can probably do better there and find the nearest
> >node considering topology.
> 
> Well if we could get wq_select_unbound_cpu doing the right thing
> based on node topology that would be most of my work solved right
> there. Basically I could just pass WQ_CPU_UNBOUND with the correct
> node and it would take care of getting to the right CPU.

Yeah, sth like that.  It might be better to keep the function to take
cpu for consistency as everything else passes around cpu.

> >>The question I have then is what should I do about workqueues that
> >>aren't WQ_UNBOUND if they attempt to use queue_work_near? In that
> >
> >Hmm... yeah, let's just use queue_work_on() for now.  We can sort it
> >out later and users could already do that anyway.
> 
> So are you saying I should just return an error for now if somebody
> tries to use something other than an unbound workqueue with
> queue_work_near, and expect everyone else to just use queue_work_on
> for the other workqueue types?

Oh, I meant that let's not add a new interface for now and just use
queue_work_on() for your use case too.

Thanks.

-- 
tejun
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

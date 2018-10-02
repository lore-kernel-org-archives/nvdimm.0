Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BFDE32115C07A
 for <linux-nvdimm@lists.01.org>; Tue,  2 Oct 2018 13:49:22 -0700 (PDT)
Subject: Re: [RFC workqueue/driver-core PATCH 1/5] workqueue: Provide
 queue_work_near to queue work near a given NUMA node
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
 <20181002184127.GH270328@devbig004.ftw2.facebook.com>
From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Message-ID: <92d8b57f-db37-e4bf-b69f-3ab5c4440ea0@linux.intel.com>
Date: Tue, 2 Oct 2018 13:49:22 -0700
MIME-Version: 1.0
In-Reply-To: <20181002184127.GH270328@devbig004.ftw2.facebook.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Tejun Heo <tj@kernel.org>
Cc: len.brown@intel.com, linux-pm@vger.kernel.org, gregkh@linuxfoundation.org, linux-nvdimm@lists.01.org, jiangshanlai@gmail.com, linux-kernel@vger.kernel.org, zwisler@kernel.org, pavel@ucw.cz, rafael@kernel.org, akpm@linux-foundation.org
List-ID: <linux-nvdimm@lists.01.org>

On 10/2/2018 11:41 AM, Tejun Heo wrote:
> Hello,
> 
> On Tue, Oct 02, 2018 at 11:23:26AM -0700, Alexander Duyck wrote:
>>> Yeah, it's all in wq_select_unbound_cpu().  Right now, if the
>>> requested cpu isn't in wq_unbound_cpumask, it falls back to dumb
>>> round-robin.  We can probably do better there and find the nearest
>>> node considering topology.
>>
>> Well if we could get wq_select_unbound_cpu doing the right thing
>> based on node topology that would be most of my work solved right
>> there. Basically I could just pass WQ_CPU_UNBOUND with the correct
>> node and it would take care of getting to the right CPU.
> 
> Yeah, sth like that.  It might be better to keep the function to take
> cpu for consistency as everything else passes around cpu.
> 
>>>> The question I have then is what should I do about workqueues that
>>>> aren't WQ_UNBOUND if they attempt to use queue_work_near? In that
>>>
>>> Hmm... yeah, let's just use queue_work_on() for now.  We can sort it
>>> out later and users could already do that anyway.
>>
>> So are you saying I should just return an error for now if somebody
>> tries to use something other than an unbound workqueue with
>> queue_work_near, and expect everyone else to just use queue_work_on
>> for the other workqueue types?
> 
> Oh, I meant that let's not add a new interface for now and just use
> queue_work_on() for your use case too.
> 
> Thanks.

So the only issue is that I was hoping to get away with not having to 
add additional preemption. That was the motivation behind doing 
queue_work_near as I could just wrap it all in the same local_irq_save 
that way I don't have to worry about the CPU I am on changing.

What I may look at doing is just greatly reducing the 
workqueue_select_unbound_cpu_near function to essentially just perform a 
few tests and then will just use the results from a cpumask_any_and of 
the cpumask_of_node and the cpu_online_mask. I'll probably rename it 
while I am at it since I am going to probably be getting away from the 
"unbound" checks in the logic.

- Alex

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

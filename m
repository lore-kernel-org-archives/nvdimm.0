Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A1C6821161235
 for <linux-nvdimm@lists.01.org>; Mon,  1 Oct 2018 14:54:59 -0700 (PDT)
Subject: Re: [RFC workqueue/driver-core PATCH 1/5] workqueue: Provide
 queue_work_near to queue work near a given NUMA node
References: <20180926214433.13512.30289.stgit@localhost.localdomain>
 <20180926215138.13512.33146.stgit@localhost.localdomain>
 <20180926215307.GA270328@devbig004.ftw2.facebook.com>
 <9b002bbb-3e6d-9e99-d8f9-36df4306093e@linux.intel.com>
 <20180926220957.GB270328@devbig004.ftw2.facebook.com>
 <ba72f007-84e2-6fe0-b128-d876dadef5f5@linux.intel.com>
 <20181001160142.GE270328@devbig004.ftw2.facebook.com>
From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Message-ID: <4eebc017-23a2-a26e-095c-66433061a141@linux.intel.com>
Date: Mon, 1 Oct 2018 14:54:39 -0700
MIME-Version: 1.0
In-Reply-To: <20181001160142.GE270328@devbig004.ftw2.facebook.com>
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

On 10/1/2018 9:01 AM, Tejun Heo wrote:
> Hello,
> 
> On Wed, Sep 26, 2018 at 03:19:21PM -0700, Alexander Duyck wrote:
>> On 9/26/2018 3:09 PM, Tejun Heo wrote:
>> I could just use queue_work_on probably, but is there any issue if I
>> am passing CPU values that are not in the wq_unbound_cpumask? That
> 
> That should be fine.  If it can't find any available cpu, it'll fall
> back to round-robin.  We probably can improve it so that it can
> consider the numa distance when falling back.
> 
>> was mostly my concern. Also for an unbound queue do I need to worry
>> about the hotplug lock? I wasn't sure if that was the case or not as
> 
> Issuers don't need to worry about them.
> 
>> I know it is called out as something to be concerned with using
>> queue_work_on, but in __queue_work the value is just used to
>> determine which node to grab a work queue from.
> 
> It might be better to leave queue_work_on() to be used for per-cpu
> workqueues and introduce queue_work_near() as you suggseted.  I just
> don't want it to duplicate the node selection code in it.  Would that
> work?

So if I understand what you are saying correctly we default to 
round-robin on a given node has no CPUs attached to it. I could probably 
work with that if that is the default behavior instead of adding much of 
the complexity I already have.

The question I have then is what should I do about workqueues that 
aren't WQ_UNBOUND if they attempt to use queue_work_near? In that case I 
should be looking for some way to go from a node to a CPU shouldn't I? 
If so should I look at doing something like wq_select_unbound_cpu that 
uses the node cpumask instead of the wq_unbound_cpumask?

- Alex


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

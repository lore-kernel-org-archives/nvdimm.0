Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3386D21157438
 for <linux-nvdimm@lists.01.org>; Wed, 26 Sep 2018 15:19:22 -0700 (PDT)
Subject: Re: [RFC workqueue/driver-core PATCH 1/5] workqueue: Provide
 queue_work_near to queue work near a given NUMA node
References: <20180926214433.13512.30289.stgit@localhost.localdomain>
 <20180926215138.13512.33146.stgit@localhost.localdomain>
 <20180926215307.GA270328@devbig004.ftw2.facebook.com>
 <9b002bbb-3e6d-9e99-d8f9-36df4306093e@linux.intel.com>
 <20180926220957.GB270328@devbig004.ftw2.facebook.com>
From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Message-ID: <ba72f007-84e2-6fe0-b128-d876dadef5f5@linux.intel.com>
Date: Wed, 26 Sep 2018 15:19:21 -0700
MIME-Version: 1.0
In-Reply-To: <20180926220957.GB270328@devbig004.ftw2.facebook.com>
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

On 9/26/2018 3:09 PM, Tejun Heo wrote:
> Hello,
> 
> On Wed, Sep 26, 2018 at 03:05:17PM -0700, Alexander Duyck wrote:
>> I am using unbound workqueues. However there isn't an interface that
>> exposes the NUMA bits of them directly. All I am doing with this
>> patch is adding "queue_work_near" which takes a NUMA node as an
>> argument and then copies the logic of "queue_work_on" with the
>> exception that I am doing a check to verify that there is an
>> intersection between wq_unbound_cpumask and the cpumask of the node,
>> and then passing a CPU from that intersection into "__queue_work".
> 
> Can it just take a cpu id and not feed that to __queue_work()?  That
> looks like a lot of extra logic.
> 
> Thanks.

I could just use queue_work_on probably, but is there any issue if I am 
passing CPU values that are not in the wq_unbound_cpumask? That was 
mostly my concern. Also for an unbound queue do I need to worry about 
the hotplug lock? I wasn't sure if that was the case or not as I know it 
is called out as something to be concerned with using queue_work_on, but 
in __queue_work the value is just used to determine which node to grab a 
work queue from.

I forgot to address your question about the advantages. They are pretty 
significant. The test system I was working with was initializing 3TB of 
nvdimm memory per node. If the node is aligned it takes something like 
24 seconds, whereas an unaligned core can take 36 seconds or more.

Thanks.

- Alex
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

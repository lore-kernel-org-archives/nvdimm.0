Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EAC3E2114B12E
 for <linux-nvdimm@lists.01.org>; Wed, 26 Sep 2018 15:06:50 -0700 (PDT)
Subject: Re: [RFC workqueue/driver-core PATCH 1/5] workqueue: Provide
 queue_work_near to queue work near a given NUMA node
References: <20180926214433.13512.30289.stgit@localhost.localdomain>
 <20180926215138.13512.33146.stgit@localhost.localdomain>
 <20180926215307.GA270328@devbig004.ftw2.facebook.com>
From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Message-ID: <9b002bbb-3e6d-9e99-d8f9-36df4306093e@linux.intel.com>
Date: Wed, 26 Sep 2018 15:05:17 -0700
MIME-Version: 1.0
In-Reply-To: <20180926215307.GA270328@devbig004.ftw2.facebook.com>
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



On 9/26/2018 2:53 PM, Tejun Heo wrote:
> Hello,
> 
> On Wed, Sep 26, 2018 at 02:51:38PM -0700, Alexander Duyck wrote:
>> This patch provides a new function queue_work_near which is meant to
>> schedule work on the nearest unbound CPU to the requested NUMA node. The
>> main motivation for this is to help assist asynchronous init to better
>> improve boot times for devices that are local to a specific node.
>>
>> Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> 
> Why not just use unbound workqueues, which are NUMA-affine by default?
> Are there big enough advantages?
> 
> Thanks.

I am using unbound workqueues. However there isn't an interface that 
exposes the NUMA bits of them directly. All I am doing with this patch 
is adding "queue_work_near" which takes a NUMA node as an argument and 
then copies the logic of "queue_work_on" with the exception that I am 
doing a check to verify that there is an intersection between 
wq_unbound_cpumask and the cpumask of the node, and then passing a CPU 
from that intersection into "__queue_work".

Thanks.

- Alex
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

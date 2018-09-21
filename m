Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AAD14211546E6
 for <linux-nvdimm@lists.01.org>; Fri, 21 Sep 2018 10:02:22 -0700 (PDT)
Subject: Re: [PATCH v4 4/5] async: Add support for queueing on specific node
References: <20180920215824.19464.8884.stgit@localhost.localdomain>
 <20180920222938.19464.34102.stgit@localhost.localdomain>
 <CAPcyv4iFs5WXMYgbC6mBSxcHggv5y1kPW5BoZ4JMy5o-bv6cOg@mail.gmail.com>
From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Message-ID: <f900a0b7-546f-7273-420c-112cb4b30e11@linux.intel.com>
Date: Fri, 21 Sep 2018 10:02:13 -0700
MIME-Version: 1.0
In-Reply-To: <CAPcyv4iFs5WXMYgbC6mBSxcHggv5y1kPW5BoZ4JMy5o-bv6cOg@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: Pasha Tatashin <pavel.tatashin@microsoft.com>, Michal Hocko <mhocko@suse.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Dave Hansen <dave.hansen@intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>



On 9/21/2018 7:57 AM, Dan Williams wrote:
> On Thu, Sep 20, 2018 at 3:31 PM Alexander Duyck
> <alexander.h.duyck@linux.intel.com> wrote:
>>
>> This patch introduces two new variants of the async_schedule_ functions
>> that allow scheduling on a specific node. These functions are
>> async_schedule_on and async_schedule_on_domain which end up mapping to
>> async_schedule and async_schedule_domain but provide NUMA node specific
>> functionality. The original functions were moved to inline function
>> definitions that call the new functions while passing NUMA_NO_NODE.
>>
>> The main motivation behind this is to address the need to be able to
>> schedule NVDIMM init work on specific NUMA nodes in order to improve
>> performance of memory initialization.
>>
>> One additional change I made is I dropped the "extern" from the function
>> prototypes in the async.h kernel header since they aren't needed.
>>
>> Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
>> ---
>>   include/linux/async.h |   20 +++++++++++++++++---
>>   kernel/async.c        |   36 +++++++++++++++++++++++++-----------
>>   2 files changed, 42 insertions(+), 14 deletions(-)
>>
>> diff --git a/include/linux/async.h b/include/linux/async.h
>> index 6b0226bdaadc..9878b99cbb01 100644
>> --- a/include/linux/async.h
>> +++ b/include/linux/async.h
>> @@ -14,6 +14,7 @@
>>
>>   #include <linux/types.h>
>>   #include <linux/list.h>
>> +#include <linux/numa.h>
>>
>>   typedef u64 async_cookie_t;
>>   typedef void (*async_func_t) (void *data, async_cookie_t cookie);
>> @@ -37,9 +38,22 @@ struct async_domain {
>>          struct async_domain _name = { .pending = LIST_HEAD_INIT(_name.pending), \
>>                                        .registered = 0 }
>>
>> -extern async_cookie_t async_schedule(async_func_t func, void *data);
>> -extern async_cookie_t async_schedule_domain(async_func_t func, void *data,
>> -                                           struct async_domain *domain);
>> +async_cookie_t async_schedule_on(async_func_t func, void *data, int node);
>> +async_cookie_t async_schedule_on_domain(async_func_t func, void *data, int node,
>> +                                       struct async_domain *domain);
> 
> I would expect this to take a cpu instead of a node to not surprise
> users coming from queue_work_on() / schedule_work_on()...

The thing is queue_work_on actually queues the work on a cpu in most 
cases. The problem is that we are running on an unbound workqueue so 
what we actually get is node specific behavior instead of CPU specific. 
That is why I opted for this.
https://elixir.bootlin.com/linux/v4.19-rc4/source/kernel/workqueue.c#L1390

>> +
>> +static inline async_cookie_t async_schedule(async_func_t func, void *data)
>> +{
>> +       return async_schedule_on(func, data, NUMA_NO_NODE);
>> +}
>> +
>> +static inline async_cookie_t
>> +async_schedule_domain(async_func_t func, void *data,
>> +                     struct async_domain *domain)
>> +{
>> +       return async_schedule_on_domain(func, data, NUMA_NO_NODE, domain);
>> +}
>> +
>>   void async_unregister_domain(struct async_domain *domain);
>>   extern void async_synchronize_full(void);
>>   extern void async_synchronize_full_domain(struct async_domain *domain);
>> diff --git a/kernel/async.c b/kernel/async.c
>> index a893d6170944..1d7ce81c1949 100644
>> --- a/kernel/async.c
>> +++ b/kernel/async.c
>> @@ -56,6 +56,7 @@ synchronization with the async_synchronize_full() function, before returning
>>   #include <linux/sched.h>
>>   #include <linux/slab.h>
>>   #include <linux/workqueue.h>
>> +#include <linux/cpu.h>
>>
>>   #include "workqueue_internal.h"
>>
>> @@ -149,8 +150,11 @@ static void async_run_entry_fn(struct work_struct *work)
>>          wake_up(&async_done);
>>   }
>>
>> -static async_cookie_t __async_schedule(async_func_t func, void *data, struct async_domain *domain)
>> +static async_cookie_t __async_schedule(async_func_t func, void *data,
>> +                                      struct async_domain *domain,
>> +                                      int node)
>>   {
>> +       int cpu = WORK_CPU_UNBOUND;
>>          struct async_entry *entry;
>>          unsigned long flags;
>>          async_cookie_t newcookie;
>> @@ -194,30 +198,40 @@ static async_cookie_t __async_schedule(async_func_t func, void *data, struct asy
>>          /* mark that this task has queued an async job, used by module init */
>>          current->flags |= PF_USED_ASYNC;
>>
>> +       /* guarantee cpu_online_mask doesn't change during scheduling */
>> +       get_online_cpus();
>> +
>> +       if (node >= 0 && node < MAX_NUMNODES && node_online(node))
>> +               cpu = cpumask_any_and(cpumask_of_node(node), cpu_online_mask);
> 
> ...I think this node to cpu helper should be up-leveled for callers. I
> suspect using get_online_cpus() may cause lockdep problems to take the
> cpu_hotplug_lock() within a "do_something_on()" routine. For example,
> I found this when auditing queue_work_on() users:

Yeah, after looking over the code I think I do see an issue. I will 
probably need to add something like a "unbound_cpu_by_node" type of 
function in order to pair it up with the unbound_pwq_by_node call that 
is in __queue_work. Otherwise I run the risk of scheduling on a CPU that 
I shouldn't be scheduling on.

> /*
>   * Doesn't need any cpu hotplug locking because we do rely on per-cpu
>   * kworkers being shut down before our page_alloc_cpu_dead callback is
>   * executed on the offlined cpu.
>   * Calling this function with cpu hotplug locks held can actually lead
>   * to obscure indirect dependencies via WQ context.
>   */
> void lru_add_drain_all(void)
> 
> I think it's a gotcha waiting to happen if async_schedule_on() has
> more restrictive calling contexts than queue_work_on().
I can look into that. If nothing else it looks like queue_work_on does 
put the onus on the caller to make certain the CPU cannot go away so I 
can push the responsibility up the call chain in order to maintain parity.

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x241.google.com (mail-oi0-x241.google.com
 [IPv6:2607:f8b0:4003:c06::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0F806211518C7
 for <linux-nvdimm@lists.01.org>; Fri, 21 Sep 2018 07:57:33 -0700 (PDT)
Received: by mail-oi0-x241.google.com with SMTP id m11-v6so11645621oic.2
 for <linux-nvdimm@lists.01.org>; Fri, 21 Sep 2018 07:57:33 -0700 (PDT)
MIME-Version: 1.0
References: <20180920215824.19464.8884.stgit@localhost.localdomain>
 <20180920222938.19464.34102.stgit@localhost.localdomain>
In-Reply-To: <20180920222938.19464.34102.stgit@localhost.localdomain>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 21 Sep 2018 07:57:21 -0700
Message-ID: <CAPcyv4iFs5WXMYgbC6mBSxcHggv5y1kPW5BoZ4JMy5o-bv6cOg@mail.gmail.com>
Subject: Re: [PATCH v4 4/5] async: Add support for queueing on specific node
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
Cc: Pasha Tatashin <pavel.tatashin@microsoft.com>, Michal Hocko <mhocko@suse.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Dave Hansen <dave.hansen@intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Sep 20, 2018 at 3:31 PM Alexander Duyck
<alexander.h.duyck@linux.intel.com> wrote:
>
> This patch introduces two new variants of the async_schedule_ functions
> that allow scheduling on a specific node. These functions are
> async_schedule_on and async_schedule_on_domain which end up mapping to
> async_schedule and async_schedule_domain but provide NUMA node specific
> functionality. The original functions were moved to inline function
> definitions that call the new functions while passing NUMA_NO_NODE.
>
> The main motivation behind this is to address the need to be able to
> schedule NVDIMM init work on specific NUMA nodes in order to improve
> performance of memory initialization.
>
> One additional change I made is I dropped the "extern" from the function
> prototypes in the async.h kernel header since they aren't needed.
>
> Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> ---
>  include/linux/async.h |   20 +++++++++++++++++---
>  kernel/async.c        |   36 +++++++++++++++++++++++++-----------
>  2 files changed, 42 insertions(+), 14 deletions(-)
>
> diff --git a/include/linux/async.h b/include/linux/async.h
> index 6b0226bdaadc..9878b99cbb01 100644
> --- a/include/linux/async.h
> +++ b/include/linux/async.h
> @@ -14,6 +14,7 @@
>
>  #include <linux/types.h>
>  #include <linux/list.h>
> +#include <linux/numa.h>
>
>  typedef u64 async_cookie_t;
>  typedef void (*async_func_t) (void *data, async_cookie_t cookie);
> @@ -37,9 +38,22 @@ struct async_domain {
>         struct async_domain _name = { .pending = LIST_HEAD_INIT(_name.pending), \
>                                       .registered = 0 }
>
> -extern async_cookie_t async_schedule(async_func_t func, void *data);
> -extern async_cookie_t async_schedule_domain(async_func_t func, void *data,
> -                                           struct async_domain *domain);
> +async_cookie_t async_schedule_on(async_func_t func, void *data, int node);
> +async_cookie_t async_schedule_on_domain(async_func_t func, void *data, int node,
> +                                       struct async_domain *domain);

I would expect this to take a cpu instead of a node to not surprise
users coming from queue_work_on() / schedule_work_on()...

> +
> +static inline async_cookie_t async_schedule(async_func_t func, void *data)
> +{
> +       return async_schedule_on(func, data, NUMA_NO_NODE);
> +}
> +
> +static inline async_cookie_t
> +async_schedule_domain(async_func_t func, void *data,
> +                     struct async_domain *domain)
> +{
> +       return async_schedule_on_domain(func, data, NUMA_NO_NODE, domain);
> +}
> +
>  void async_unregister_domain(struct async_domain *domain);
>  extern void async_synchronize_full(void);
>  extern void async_synchronize_full_domain(struct async_domain *domain);
> diff --git a/kernel/async.c b/kernel/async.c
> index a893d6170944..1d7ce81c1949 100644
> --- a/kernel/async.c
> +++ b/kernel/async.c
> @@ -56,6 +56,7 @@ synchronization with the async_synchronize_full() function, before returning
>  #include <linux/sched.h>
>  #include <linux/slab.h>
>  #include <linux/workqueue.h>
> +#include <linux/cpu.h>
>
>  #include "workqueue_internal.h"
>
> @@ -149,8 +150,11 @@ static void async_run_entry_fn(struct work_struct *work)
>         wake_up(&async_done);
>  }
>
> -static async_cookie_t __async_schedule(async_func_t func, void *data, struct async_domain *domain)
> +static async_cookie_t __async_schedule(async_func_t func, void *data,
> +                                      struct async_domain *domain,
> +                                      int node)
>  {
> +       int cpu = WORK_CPU_UNBOUND;
>         struct async_entry *entry;
>         unsigned long flags;
>         async_cookie_t newcookie;
> @@ -194,30 +198,40 @@ static async_cookie_t __async_schedule(async_func_t func, void *data, struct asy
>         /* mark that this task has queued an async job, used by module init */
>         current->flags |= PF_USED_ASYNC;
>
> +       /* guarantee cpu_online_mask doesn't change during scheduling */
> +       get_online_cpus();
> +
> +       if (node >= 0 && node < MAX_NUMNODES && node_online(node))
> +               cpu = cpumask_any_and(cpumask_of_node(node), cpu_online_mask);

...I think this node to cpu helper should be up-leveled for callers. I
suspect using get_online_cpus() may cause lockdep problems to take the
cpu_hotplug_lock() within a "do_something_on()" routine. For example,
I found this when auditing queue_work_on() users:

/*
 * Doesn't need any cpu hotplug locking because we do rely on per-cpu
 * kworkers being shut down before our page_alloc_cpu_dead callback is
 * executed on the offlined cpu.
 * Calling this function with cpu hotplug locks held can actually lead
 * to obscure indirect dependencies via WQ context.
 */
void lru_add_drain_all(void)

I think it's a gotcha waiting to happen if async_schedule_on() has
more restrictive calling contexts than queue_work_on().
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

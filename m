Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 09B102194D3B3
 for <linux-nvdimm@lists.01.org>; Thu,  7 Mar 2019 22:31:10 -0800 (PST)
Date: Fri, 8 Mar 2019 01:31:08 -0500 (EST)
From: Pankaj Gupta <pagupta@redhat.com>
Message-ID: <1859347572.10599669.1552026668860.JavaMail.zimbra@redhat.com>
In-Reply-To: <20190306095709.23138-1-yongxin.liu@windriver.com>
References: <20190306095709.23138-1-yongxin.liu@windriver.com>
Subject: Re: [PATCH RT] nvdimm: make lane acquirement RT aware
MIME-Version: 1.0
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
To: Yongxin Liu <yongxin.liu@windriver.com>
Cc: linux-rt-users@vger.kernel.org, linux-nvdimm@lists.01.org, bigeasy@linutronix.de, linux-kernel@vger.kernel.org, rostedt@goodmis.org, paul gortmaker <paul.gortmaker@windriver.com>, tglx@linutronix.de
List-ID: <linux-nvdimm@lists.01.org>


> Currently, nvdimm driver isn't RT compatible.
> nd_region_acquire_lane() disables preemption with get_cpu() which
> causes "scheduling while atomic" spews on RT, when using fio to test
> pmem as block device.
> 
> In this change, we replace get_cpu/put_cpu with local_lock_cpu/
> local_unlock_cpu, and introduce per CPU variable "ndl_local_lock".
> Due to preemption on RT, this lock can avoid race condition for the
> same lane on the same CPU. When CPU number is greater than the lane
> number, lane can be shared among CPUs. "ndl_lock->lock" is used to
> protect the lane in this situation.
> 
> This patch is derived from Dan Williams and Pankaj Gupta's proposal from
> https://www.mail-archive.com/linux-nvdimm@lists.01.org/msg13359.html
> and https://www.spinics.net/lists/linux-rt-users/msg20280.html.
> Many thanks to them.
> 
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Pankaj Gupta <pagupta@redhat.com>
> Cc: linux-rt-users <linux-rt-users@vger.kernel.org>
> Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
> Signed-off-by: Yongxin Liu <yongxin.liu@windriver.com>

This patch looks good to me.

Acked-by: Pankaj Gupta <pagupta@redhat.com>

> ---
>  drivers/nvdimm/region_devs.c | 40 +++++++++++++++++++---------------------
>  1 file changed, 19 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
> index fa37afcd43ff..6c5388cf2477 100644
> --- a/drivers/nvdimm/region_devs.c
> +++ b/drivers/nvdimm/region_devs.c
> @@ -18,9 +18,13 @@
>  #include <linux/sort.h>
>  #include <linux/io.h>
>  #include <linux/nd.h>
> +#include <linux/locallock.h>
>  #include "nd-core.h"
>  #include "nd.h"
>  
> +/* lock for tasks on the same CPU to sequence the access to the lane */
> +static DEFINE_LOCAL_IRQ_LOCK(ndl_local_lock);
> +
>  /*
>   * For readq() and writeq() on 32-bit builds, the hi-lo, lo-hi order is
>   * irrelevant.
> @@ -935,18 +939,15 @@ int nd_blk_region_init(struct nd_region *nd_region)
>  unsigned int nd_region_acquire_lane(struct nd_region *nd_region)
>  {
>  	unsigned int cpu, lane;
> +	struct nd_percpu_lane *ndl_lock, *ndl_count;
>  
> -	cpu = get_cpu();
> -	if (nd_region->num_lanes < nr_cpu_ids) {
> -		struct nd_percpu_lane *ndl_lock, *ndl_count;
> +	cpu = local_lock_cpu(ndl_local_lock);
>  
> -		lane = cpu % nd_region->num_lanes;
> -		ndl_count = per_cpu_ptr(nd_region->lane, cpu);
> -		ndl_lock = per_cpu_ptr(nd_region->lane, lane);
> -		if (ndl_count->count++ == 0)
> -			spin_lock(&ndl_lock->lock);
> -	} else
> -		lane = cpu;
> +	lane = cpu % nd_region->num_lanes;
> +	ndl_count = per_cpu_ptr(nd_region->lane, cpu);
> +	ndl_lock = per_cpu_ptr(nd_region->lane, lane);
> +	if (ndl_count->count++ == 0)
> +		spin_lock(&ndl_lock->lock);
>  
>  	return lane;
>  }
> @@ -954,17 +955,14 @@ EXPORT_SYMBOL(nd_region_acquire_lane);
>  
>  void nd_region_release_lane(struct nd_region *nd_region, unsigned int lane)
>  {
> -	if (nd_region->num_lanes < nr_cpu_ids) {
> -		unsigned int cpu = get_cpu();
> -		struct nd_percpu_lane *ndl_lock, *ndl_count;
> -
> -		ndl_count = per_cpu_ptr(nd_region->lane, cpu);
> -		ndl_lock = per_cpu_ptr(nd_region->lane, lane);
> -		if (--ndl_count->count == 0)
> -			spin_unlock(&ndl_lock->lock);
> -		put_cpu();
> -	}
> -	put_cpu();
> +	struct nd_percpu_lane *ndl_lock, *ndl_count;
> +	unsigned int cpu = smp_processor_id();
> +
> +	ndl_count = per_cpu_ptr(nd_region->lane, cpu);
> +	ndl_lock = per_cpu_ptr(nd_region->lane, lane);
> +	if (--ndl_count->count == 0)
> +		spin_unlock(&ndl_lock->lock);
> +	local_unlock_cpu(ndl_local_lock);
>  }
>  EXPORT_SYMBOL(nd_region_release_lane);
>  
> --
> 2.14.4
> 
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

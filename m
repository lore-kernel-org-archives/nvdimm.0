Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail1.windriver.com (mail1.windriver.com [147.11.146.13])
 (using TLSv1.1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DBA682194EB70
 for <linux-nvdimm@lists.01.org>; Sun, 17 Mar 2019 18:42:12 -0700 (PDT)
From: "Liu, Yongxin" <Yongxin.Liu@windriver.com>
Subject: RE: [PATCH RT] nvdimm: make lane acquirement RT aware
Date: Mon, 18 Mar 2019 01:41:10 +0000
Message-ID: <597B109EC20B76429F71A8A97770610D12A63C81@ALA-MBD.corp.ad.wrs.com>
References: <20190306095709.23138-1-yongxin.liu@windriver.com>
 <20190307143344.ytsnbmot5tjzjhip@linutronix.de>
 <597B109EC20B76429F71A8A97770610D12A52669@ALA-MBD.corp.ad.wrs.com>
 <20190308094131.ge4wbsvz4p6xikdf@linutronix.de>
 <597B109EC20B76429F71A8A97770610D12A5643B@ALA-MBD.corp.ad.wrs.com>
 <20190315164236.rzbwe7reeprjv3um@linutronix.de>
In-Reply-To: <20190315164236.rzbwe7reeprjv3um@linutronix.de>
Content-Language: en-US
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
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "rostedt@goodmis.org" <rostedt@goodmis.org>, "Gortmaker, Paul  <Paul.Gortmaker@windriver.com>, tglx@linutronix.de" <tglx@linutronix.de>
List-ID: <linux-nvdimm@lists.01.org>


> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> owner@vger.kernel.org] On Behalf Of Sebastian Andrzej Siewior
> Sent: Saturday, March 16, 2019 00:43
> To: Liu, Yongxin
> Cc: linux-kernel@vger.kernel.org; linux-rt-users@vger.kernel.org;
> tglx@linutronix.de; rostedt@goodmis.org; dan.j.williams@intel.com;
> pagupta@redhat.com; Gortmaker, Paul; linux-nvdimm@lists.01.org
> Subject: Re: [PATCH RT] nvdimm: make lane acquirement RT aware
> 
> On 2019-03-11 00:44:58 [+0000], Liu, Yongxin wrote:
> > > but you still have the ndl_lock->lock which protects the resource. So
> in
> > > the unlikely (but possible event) that you switch CPUs after
> obtaining
> > > the CPU number you block on the lock. No harm is done, right?
> >
> > The resource "lane" can be acquired recursively, so "ndl_lock->lock" is
> a conditional lock.
> >
> > ndl_count->count is per CPU.
> > ndl_lock->lock is per lane.
> >
> > Here is an example:
> > Thread A  on CPU 5 --> nd_region_acquire_lane --> lane# 5 --> get
> "ndl_lock->lock"
> > --> nd_region_acquire_lane --> lane# 5 --> bypass "ndl_lock->lock" due
> to "ndl_count->count++".
> >
> > Thread B on CPU 5 --> nd_region_acquire_lane --> lane# 5 --> bypass
> "ndl_lock->lock" ("ndl_count->count"
> > was changed by Thread A)
> >
> > If we use raw_smp_processor_id(), no matter which CPU the thread was
> migrated to,
> > if there is another thread running on the old CPU, there will be race
> condition
> > due to per CPU variable "ndl_count->count".
> 
> so I've been looking at it again. The recursive locking could have been
> solved better. Like the local_lock() on -RT is doing it.
> Given that you lock with preempt_disable() there should be no in-IRQ
> usage.
> But in the "nd_region->num_lanes >= nr_cpu_ids" case you don't take any
> locks. That would be a problem with raw_smp_processor_id() approach.
> 
> So what about the completely untested patch here:
> 
> diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
> index 379bf4305e615..98c2e9df4b2e4 100644
> --- a/drivers/nvdimm/nd.h
> +++ b/drivers/nvdimm/nd.h
> @@ -109,7 +109,8 @@ unsigned sizeof_namespace_label(struct nvdimm_drvdata
> *ndd);
>  			res; res = next, next = next ? next->sibling : NULL)
> 
>  struct nd_percpu_lane {
> -	int count;
> +	struct task_struct *owner;
> +	int nestcnt;
>  	spinlock_t lock;
>  };
> 
> diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
> index e2818f94f2928..8a62f9833513f 100644
> --- a/drivers/nvdimm/region_devs.c
> +++ b/drivers/nvdimm/region_devs.c
> @@ -946,19 +946,17 @@ int nd_blk_region_init(struct nd_region *nd_region)
>   */
>  unsigned int nd_region_acquire_lane(struct nd_region *nd_region)
>  {
> +	struct nd_percpu_lane *ndl_lock;
>  	unsigned int cpu, lane;
> 
> -	cpu = get_cpu();
> -	if (nd_region->num_lanes < nr_cpu_ids) {
> -		struct nd_percpu_lane *ndl_lock, *ndl_count;
> -
> -		lane = cpu % nd_region->num_lanes;
> -		ndl_count = per_cpu_ptr(nd_region->lane, cpu);
> -		ndl_lock = per_cpu_ptr(nd_region->lane, lane);
> -		if (ndl_count->count++ == 0)
> -			spin_lock(&ndl_lock->lock);
> -	} else
> -		lane = cpu;
> +	cpu = raw_smp_processor_id();
> +	lane = cpu % nd_region->num_lanes;
> +	ndl_lock  = per_cpu_ptr(nd_region->lane, lane);
> +	if (ndl_lock->owner != current) {
> +		spin_lock(&ndl_lock->lock);
> +		ndl_lock->owner = current;
> +	}
> +	ndl_lock->nestcnt++;
> 
>  	return lane;
>  }
> @@ -966,17 +964,16 @@ EXPORT_SYMBOL(nd_region_acquire_lane);
> 
>  void nd_region_release_lane(struct nd_region *nd_region, unsigned int
> lane)
>  {
> -	if (nd_region->num_lanes < nr_cpu_ids) {
> -		unsigned int cpu = get_cpu();
> -		struct nd_percpu_lane *ndl_lock, *ndl_count;
> +	struct nd_percpu_lane *ndl_lock;
> 
> -		ndl_count = per_cpu_ptr(nd_region->lane, cpu);
> -		ndl_lock = per_cpu_ptr(nd_region->lane, lane);
> -		if (--ndl_count->count == 0)
> -			spin_unlock(&ndl_lock->lock);
> -		put_cpu();
> -	}
> -	put_cpu();
> +	ndl_lock = per_cpu_ptr(nd_region->lane, lane);
> +	WARN_ON(ndl_lock->nestcnt == 0);
> +	WARN_ON(ndl_lock->owner != current);
> +	if (--ndl_lock->nestcnt)
> +		return;
> +
> +	ndl_lock->owner = NULL;
> +	spin_unlock(&ndl_lock->lock);
>  }
>  EXPORT_SYMBOL(nd_region_release_lane);
> 
> @@ -1042,7 +1039,8 @@ static struct nd_region *nd_region_create(struct
> nvdimm_bus *nvdimm_bus,
> 
>  		ndl = per_cpu_ptr(nd_region->lane, i);
>  		spin_lock_init(&ndl->lock);
> -		ndl->count = 0;
> +		ndl->owner = NULL;
> +		ndl->nestcnt = 0;
>  	}
> 
>  	for (i = 0; i < ndr_desc->num_mappings; i++) {
> 
> > Thanks,
> > Yongxin
> 

Consider the recursive call to nd_region_acquire_lane() in the following situation.
Will there be a dead lock?


    Thread A                    Thread B
       |                           |
       |                           |
     CPU 1                       CPU 2
       |                           |
       |                           |
 get lock for Lane 1         get lock for Lane 2
       |                           |
       |                           |
 migrate to CPU 2            migrate to CPU 1
       |                           |
       |                           |
 wait lock for Lane 2        wait lock for Lane 1 
       |                           |
       |                           |
       _____________________________
                   |
                dead lock ?


Thanks,
Yognxin


> Sebastian
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

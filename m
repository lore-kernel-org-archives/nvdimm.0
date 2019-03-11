Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.windriver.com (mail.windriver.com [147.11.1.11])
 (using TLSv1.1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9530C211D59B2
 for <linux-nvdimm@lists.01.org>; Sun, 10 Mar 2019 17:45:47 -0700 (PDT)
From: "Liu, Yongxin" <Yongxin.Liu@windriver.com>
Subject: RE: [PATCH RT] nvdimm: make lane acquirement RT aware
Date: Mon, 11 Mar 2019 00:44:58 +0000
Message-ID: <597B109EC20B76429F71A8A97770610D12A5643B@ALA-MBD.corp.ad.wrs.com>
References: <20190306095709.23138-1-yongxin.liu@windriver.com>
 <20190307143344.ytsnbmot5tjzjhip@linutronix.de>
 <597B109EC20B76429F71A8A97770610D12A52669@ALA-MBD.corp.ad.wrs.com>
 <20190308094131.ge4wbsvz4p6xikdf@linutronix.de>
In-Reply-To: <20190308094131.ge4wbsvz4p6xikdf@linutronix.de>
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
> Sent: Friday, March 8, 2019 17:42
> To: Liu, Yongxin
> Cc: linux-kernel@vger.kernel.org; linux-rt-users@vger.kernel.org;
> tglx@linutronix.de; rostedt@goodmis.org; dan.j.williams@intel.com;
> pagupta@redhat.com; Gortmaker, Paul; linux-nvdimm@lists.01.org
> Subject: Re: [PATCH RT] nvdimm: make lane acquirement RT aware
> 
> On 2019-03-08 00:07:41 [+0000], Liu, Yongxin wrote:
> > The lane is critical resource which needs to be protected. One CPU can
> use only one
> > lane. If CPU number is greater than the number of total lane, the lane
> can be shared
> > among CPUs.
> >
> > In non-RT kernel, get_cpu() disable preemption by calling
> preempt_disable() first.
> > Only one thread on the same CPU can get the lane.
> >
> > In RT kernel, if we only use raw_smp_processor_id(), this doesn't
> protect the lane.
> > Thus two threads on the same CPU can get the same lane at the same time.
> >
> > In this patch, two-level lock can avoid race condition for the lane.
> 
> but you still have the ndl_lock->lock which protects the resource. So in
> the unlikely (but possible event) that you switch CPUs after obtaining
> the CPU number you block on the lock. No harm is done, right?

The resource "lane" can be acquired recursively, so "ndl_lock->lock" is a conditional lock.

ndl_count->count is per CPU.
ndl_lock->lock is per lane.

Here is an example:
Thread A  on CPU 5 --> nd_region_acquire_lane --> lane# 5 --> get "ndl_lock->lock"
--> nd_region_acquire_lane --> lane# 5 --> bypass "ndl_lock->lock" due to "ndl_count->count++".

Thread B on CPU 5 --> nd_region_acquire_lane --> lane# 5 --> bypass "ndl_lock->lock" ("ndl_count->count"
was changed by Thread A)

If we use raw_smp_processor_id(), no matter which CPU the thread was migrated to, 
if there is another thread running on the old CPU, there will be race condition 
due to per CPU variable "ndl_count->count".


Thanks,
Yongxin

> 
> Sebastian
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

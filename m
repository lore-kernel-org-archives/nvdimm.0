Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail5.wrs.com (mail5.windriver.com [192.103.53.11])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D5CD1211D67E2
 for <linux-nvdimm@lists.01.org>; Thu,  7 Mar 2019 16:09:59 -0800 (PST)
From: "Liu, Yongxin" <Yongxin.Liu@windriver.com>
Subject: RE: [PATCH RT] nvdimm: make lane acquirement RT aware
Date: Fri, 8 Mar 2019 00:07:41 +0000
Message-ID: <597B109EC20B76429F71A8A97770610D12A52669@ALA-MBD.corp.ad.wrs.com>
References: <20190306095709.23138-1-yongxin.liu@windriver.com>
 <20190307143344.ytsnbmot5tjzjhip@linutronix.de>
In-Reply-To: <20190307143344.ytsnbmot5tjzjhip@linutronix.de>
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
> Sent: Thursday, March 7, 2019 22:34
> To: Liu, Yongxin
> Cc: linux-kernel@vger.kernel.org; linux-rt-users@vger.kernel.org;
> tglx@linutronix.de; rostedt@goodmis.org; dan.j.williams@intel.com;
> pagupta@redhat.com; Gortmaker, Paul; linux-nvdimm@lists.01.org
> Subject: Re: [PATCH RT] nvdimm: make lane acquirement RT aware
> 
> On 2019-03-06 17:57:09 [+0800], Yongxin Liu wrote:
> > In this change, we replace get_cpu/put_cpu with local_lock_cpu/
> > local_unlock_cpu, and introduce per CPU variable "ndl_local_lock".
> > Due to preemption on RT, this lock can avoid race condition for the
> > same lane on the same CPU. When CPU number is greater than the lane
> > number, lane can be shared among CPUs. "ndl_lock->lock" is used to
> > protect the lane in this situation.
> 
> so what was the reason that get_cpu() can't be replaced with
> raw_smp_processor_id()?
> 
> Sebastian

The lane is critical resource which needs to be protected. One CPU can use only one
lane. If CPU number is greater than the number of total lane, the lane can be shared
among CPUs. 

In non-RT kernel, get_cpu() disable preemption by calling preempt_disable() first.
Only one thread on the same CPU can get the lane.

In RT kernel, if we only use raw_smp_processor_id(), this doesn't protect the lane. 
Thus two threads on the same CPU can get the same lane at the same time.

In this patch, two-level lock can avoid race condition for the lane.

          CPU A                  CPU B (B == A % num_lanes)
 
    task A1    task A2     task B1    task B2
       |          |           |          |
       |__________|           |__________|
            |                      |
       ndl_local_lock           ndl_local_lock
            |                      |
            |______________________|
                       |
                       |
                  ndl_lock->lock
                       |
                       |
                      lane

 
Thanks,
Yongxin
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

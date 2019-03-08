Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from Galois.linutronix.de (Galois.linutronix.de
 [IPv6:2a01:7a0:2:106d:700::1])
 (using TLSv1.2 with cipher AES128-SHA (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D7793211D681F
 for <linux-nvdimm@lists.01.org>; Fri,  8 Mar 2019 01:41:47 -0800 (PST)
Date: Fri, 8 Mar 2019 10:41:31 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [PATCH RT] nvdimm: make lane acquirement RT aware
Message-ID: <20190308094131.ge4wbsvz4p6xikdf@linutronix.de>
References: <20190306095709.23138-1-yongxin.liu@windriver.com>
 <20190307143344.ytsnbmot5tjzjhip@linutronix.de>
 <597B109EC20B76429F71A8A97770610D12A52669@ALA-MBD.corp.ad.wrs.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <597B109EC20B76429F71A8A97770610D12A52669@ALA-MBD.corp.ad.wrs.com>
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
To: "Liu, Yongxin" <Yongxin.Liu@windriver.com>
Cc: "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "rostedt@goodmis.org" <rostedt@goodmis.org>, "Gortmaker, Paul  <Paul.Gortmaker@windriver.com>, tglx@linutronix.de" <tglx@linutronix.de>
List-ID: <linux-nvdimm@lists.01.org>

On 2019-03-08 00:07:41 [+0000], Liu, Yongxin wrote:
> The lane is critical resource which needs to be protected. One CPU can use only one
> lane. If CPU number is greater than the number of total lane, the lane can be shared
> among CPUs. 
> 
> In non-RT kernel, get_cpu() disable preemption by calling preempt_disable() first.
> Only one thread on the same CPU can get the lane.
> 
> In RT kernel, if we only use raw_smp_processor_id(), this doesn't protect the lane. 
> Thus two threads on the same CPU can get the same lane at the same time.
> 
> In this patch, two-level lock can avoid race condition for the lane.

but you still have the ndl_lock->lock which protects the resource. So in
the unlikely (but possible event) that you switch CPUs after obtaining
the CPU number you block on the lock. No harm is done, right?

> Thanks,
> Yongxin

Sebastian
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

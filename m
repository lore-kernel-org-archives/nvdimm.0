Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from Galois.linutronix.de (Galois.linutronix.de
 [IPv6:2a01:7a0:2:106d:700::1])
 (using TLSv1.2 with cipher AES128-SHA (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EC1E7211D618E
 for <linux-nvdimm@lists.01.org>; Thu,  7 Mar 2019 06:34:00 -0800 (PST)
Date: Thu, 7 Mar 2019 15:33:44 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [PATCH RT] nvdimm: make lane acquirement RT aware
Message-ID: <20190307143344.ytsnbmot5tjzjhip@linutronix.de>
References: <20190306095709.23138-1-yongxin.liu@windriver.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190306095709.23138-1-yongxin.liu@windriver.com>
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
Cc: linux-rt-users@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, rostedt@goodmis.org, paul.gortmaker@windriver.com, tglx@linutronix.de
List-ID: <linux-nvdimm@lists.01.org>

On 2019-03-06 17:57:09 [+0800], Yongxin Liu wrote:
> In this change, we replace get_cpu/put_cpu with local_lock_cpu/
> local_unlock_cpu, and introduce per CPU variable "ndl_local_lock".
> Due to preemption on RT, this lock can avoid race condition for the
> same lane on the same CPU. When CPU number is greater than the lane
> number, lane can be shared among CPUs. "ndl_lock->lock" is used to
> protect the lane in this situation.

so what was the reason that get_cpu() can't be replaced with
raw_smp_processor_id()?

Sebastian
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

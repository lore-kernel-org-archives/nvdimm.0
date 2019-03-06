Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com
 [IPv6:2607:f8b0:4864:20::344])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 670A2211D56C9
 for <linux-nvdimm@lists.01.org>; Wed,  6 Mar 2019 08:35:33 -0800 (PST)
Received: by mail-ot1-x344.google.com with SMTP id e15so11285993otk.6
 for <linux-nvdimm@lists.01.org>; Wed, 06 Mar 2019 08:35:33 -0800 (PST)
MIME-Version: 1.0
References: <20190306095709.23138-1-yongxin.liu@windriver.com>
In-Reply-To: <20190306095709.23138-1-yongxin.liu@windriver.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 6 Mar 2019 08:35:21 -0800
Message-ID: <CAPcyv4h7a8QSvJiUqCd=r3KPaWwiPC_-9x3Jip6eY2XGJ5Wc0w@mail.gmail.com>
Subject: Re: [PATCH RT] nvdimm: make lane acquirement RT aware
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
Cc: linux-rt-users@vger.kernel.org, linux-nvdimm <linux-nvdimm@lists.01.org>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>, Paul Gortmaker <paul.gortmaker@windriver.com>, Thomas Gleixner <tglx@linutronix.de>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Mar 6, 2019 at 2:05 AM Yongxin Liu <yongxin.liu@windriver.com> wrote:
>
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

Looks ok to me in concept.

Acked-by: Dan Williams <dan.j.williams@intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

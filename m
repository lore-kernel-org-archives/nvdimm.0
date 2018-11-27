Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com
 [IPv6:2607:f8b0:4864:20::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 723EA21A02937
 for <linux-nvdimm@lists.01.org>; Mon, 26 Nov 2018 17:01:26 -0800 (PST)
Received: by mail-oi1-x241.google.com with SMTP id t204so17777174oie.7
 for <linux-nvdimm@lists.01.org>; Mon, 26 Nov 2018 17:01:26 -0800 (PST)
MIME-Version: 1.0
References: <154170028986.12967.2108024712555179678.stgit@ahduyck-desk1.jf.intel.com>
 <154170040562.12967.17831655390715808287.stgit@ahduyck-desk1.jf.intel.com>
In-Reply-To: <154170040562.12967.17831655390715808287.stgit@ahduyck-desk1.jf.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 26 Nov 2018 17:01:14 -0800
Message-ID: <CAPcyv4j5P7OWbof8gMUmFRswR4YVQAJEZTAPNGhUup_y3XRYiw@mail.gmail.com>
Subject: Re: [driver-core PATCH v6 1/9] workqueue: Provide queue_work_node to
 queue work near a given NUMA node
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
Cc: "Brown, Len" <len.brown@intel.com>, bvanassche@acm.org, Linux-pm mailing list <linux-pm@vger.kernel.org>, Greg KH <gregkh@linuxfoundation.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, jiangshanlai@gmail.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>, zwisler@kernel.org, Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Nov 8, 2018 at 10:06 AM Alexander Duyck
<alexander.h.duyck@linux.intel.com> wrote:
>
> Provide a new function, queue_work_node, which is meant to schedule work on
> a "random" CPU of the requested NUMA node. The main motivation for this is
> to help assist asynchronous init to better improve boot times for devices
> that are local to a specific node.
>
> For now we just default to the first CPU that is in the intersection of the
> cpumask of the node and the online cpumask. The only exception is if the
> CPU is local to the node we will just use the current CPU. This should work
> for our purposes as we are currently only using this for unbound work so
> the CPU will be translated to a node anyway instead of being directly used.
>
> As we are only using the first CPU to represent the NUMA node for now I am
> limiting the scope of the function so that it can only be used with unbound
> workqueues.
>
> Acked-by: Tejun Heo <tj@kernel.org>
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>

Acked-by: Dan Williams <dan.j.williams@intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com
 [IPv6:2607:f8b0:4864:20::343])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DE75621CB74A4
 for <linux-nvdimm@lists.01.org>; Mon, 26 Nov 2018 20:50:33 -0800 (PST)
Received: by mail-ot1-x343.google.com with SMTP id w25so18937455otm.13
 for <linux-nvdimm@lists.01.org>; Mon, 26 Nov 2018 20:50:33 -0800 (PST)
MIME-Version: 1.0
References: <154170028986.12967.2108024712555179678.stgit@ahduyck-desk1.jf.intel.com>
 <154170043632.12967.5339750954964165831.stgit@ahduyck-desk1.jf.intel.com>
In-Reply-To: <154170043632.12967.5339750954964165831.stgit@ahduyck-desk1.jf.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 26 Nov 2018 20:50:22 -0800
Message-ID: <CAPcyv4jzLes=Xj-YKSaTtg-suc9T5V0BqQoDb4scpx5m9xG-BA@mail.gmail.com>
Subject: Re: [driver-core PATCH v6 7/9] driver core: Attach devices on CPU
 local to device node
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

On Thu, Nov 8, 2018 at 10:07 AM Alexander Duyck
<alexander.h.duyck@linux.intel.com> wrote:
>
> Call the asynchronous probe routines on a CPU local to the device node. By
> doing this we should be able to improve our initialization time
> significantly as we can avoid having to access the device from a remote
> node which may introduce higher latency.
>
> For example, in the case of initializing memory for NVDIMM this can have a
> significant impact as initialing 3TB on remote node can take up to 39
> seconds while initialing it on a local node only takes 23 seconds. It is
> situations like this where we will see the biggest improvement.
>
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>

Looks good,

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

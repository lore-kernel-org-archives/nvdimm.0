Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com
 [IPv6:2607:f8b0:4864:20::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BC80F21BADAB2
 for <linux-nvdimm@lists.01.org>; Thu, 16 May 2019 11:27:47 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id w144so3241269oie.12
 for <linux-nvdimm@lists.01.org>; Thu, 16 May 2019 11:27:47 -0700 (PDT)
MIME-Version: 1.0
References: <1558022693-9631-1-git-send-email-cai@lca.pw>
In-Reply-To: <1558022693-9631-1-git-send-email-cai@lca.pw>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 16 May 2019 11:27:36 -0700
Message-ID: <CAPcyv4jJ4AX7OKLBMo3SSomrneRef6OB=qpBESiQwAinnM+How@mail.gmail.com>
Subject: Re: [PATCH] nvdimm: fix compilation warnings with W=1
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
To: Qian Cai <cai@lca.pw>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, May 16, 2019 at 9:05 AM Qian Cai <cai@lca.pw> wrote:
>
> Several places (dimm_devs.c, core.c etc) include label.h but only
> label.c uses NSINDEX_SIGNATURE, so move its definition to label.c
> instead.
>
> In file included from drivers/nvdimm/dimm_devs.c:23:
> drivers/nvdimm/label.h:41:19: warning: 'NSINDEX_SIGNATURE' defined but
> not used [-Wunused-const-variable=]
>
> Also, some places abuse "/**" which is only reserved for the kernel-doc.
>
> drivers/nvdimm/bus.c:648: warning: cannot understand function prototype:
> 'struct attribute_group nd_device_attribute_group = '
> drivers/nvdimm/bus.c:677: warning: cannot understand function prototype:
> 'struct attribute_group nd_numa_attribute_group = '
>
> Those are just some member assignments for the "struct attribute_group"
> instances and it can't be expressed in the kernel-doc.

Ah, good point, I missed that.

> Reviewed-by: Vishal Verma <vishal.l.verma@intel.com>
> Signed-off-by: Qian Cai <cai@lca.pw>

Looks good, I'll pull this in for a post -rc1 update.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

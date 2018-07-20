Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ua0-x244.google.com (mail-ua0-x244.google.com
 [IPv6:2607:f8b0:400c:c08::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1BF302097174E
 for <linux-nvdimm@lists.01.org>; Thu, 19 Jul 2018 18:54:31 -0700 (PDT)
Received: by mail-ua0-x244.google.com with SMTP id k8-v6so6492641uaq.12
 for <linux-nvdimm@lists.01.org>; Thu, 19 Jul 2018 18:54:30 -0700 (PDT)
MIME-Version: 1.0
References: <20180720001656.16990-1-vishal.l.verma@intel.com>
In-Reply-To: <20180720001656.16990-1-vishal.l.verma@intel.com>
From: Ross Zwisler <zwisler@gmail.com>
Date: Thu, 19 Jul 2018 19:54:17 -0600
Message-ID: <CAOxpaSUHXF2eKGvDG6-rx4jsnbtKh2m26+Mz8t+9rs+cFZFg=A@mail.gmail.com>
Subject: Re: [ndctl PATCH] Documentation,
 create-namespace: clarify fsdax wording
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
To: "Verma, Vishal L" <vishal.l.verma@intel.com>
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jul 19, 2018 at 6:17 PM Vishal Verma <vishal.l.verma@intel.com> wrote:
>
> Reword the description of the fsdax mode in the create-namespace
> documentation to better distinguish when DAX can be used vs. how the raw
> block device will use the page cache.
>
> Link: https://github.com/pmem/issues/issues/915
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  Documentation/ndctl/ndctl-create-namespace.txt | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/Documentation/ndctl/ndctl-create-namespace.txt b/Documentation/ndctl/ndctl-create-namespace.txt
> index 4b8b0d1..343733d 100644
> --- a/Documentation/ndctl/ndctl-create-namespace.txt
> +++ b/Documentation/ndctl/ndctl-create-namespace.txt
> @@ -68,10 +68,11 @@ OPTIONS
>           comes at the cost of allocating per-page metadata. The
>           capacity can be allocated from "System RAM", or from a
>           reserved portion of "Persistent Memory" (see the --map=
> -         option).  Note that a filesystem is required for dax
> -         operation, the resulting raw block device (/dev/pmemX) will
> -         use the page cache. See "devdax" mode for raw device access
> -         that supports dax.
> +         option).  NOTE: A filesystem that supports DAX is required
> +         for dax operation. If the raw block device (/dev/pmemX) is
> +         used directly without a filesystem, it will use the page
> +         cache. See "devdax" mode for raw device access that supports
> +         dax.

Looks good, you can add:

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

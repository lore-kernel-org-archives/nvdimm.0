Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-yw0-x233.google.com (mail-yw0-x233.google.com
 [IPv6:2607:f8b0:4002:c05::233])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 858E92095D2D6
 for <linux-nvdimm@lists.01.org>; Mon, 10 Jul 2017 11:39:24 -0700 (PDT)
Received: by mail-yw0-x233.google.com with SMTP id x125so39760612ywa.0
 for <linux-nvdimm@lists.01.org>; Mon, 10 Jul 2017 11:41:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170710183248.2417-1-willy@infradead.org>
References: <20170710183248.2417-1-willy@infradead.org>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 10 Jul 2017 11:41:08 -0700
Message-ID: <CAPcyv4ioWUmiHbaGVcpxuK-j0JrcGk-_VcpR6yQtQMUwcRTRcQ@mail.gmail.com>
Subject: Re: [PATCH] nvdimm: Remove minimum size requirement
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
To: Matthew Wilcox <willy@infradead.org>
Cc: Cheng-mean Liu <soccerl@microsoft.com>, Matthew Wilcox <mawilcox@microsoft.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jul 10, 2017 at 11:32 AM, Matthew Wilcox <willy@infradead.org> wrote:
> From: Matthew Wilcox <mawilcox@microsoft.com>
>
> There was no need to have a minimum size of 4MB for NV-DIMMs; it was
> just a sanity check.  Keep a check that it's at least one page in size
> because we really can't add less than a page to the memory map.  Promote
> the print statement from 'debug' level to 'warning', since there was no
> information for my colleague who stumbled over this problem while
> attempting to add a 2MB chunk of memory.
>
> Reported-by: Cheng-mean Liu <soccerl@microsoft.com>
> Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
> ---
>  drivers/nvdimm/namespace_devs.c | 6 +++---
>  include/uapi/linux/ndctl.h      | 4 ----
>  2 files changed, 3 insertions(+), 7 deletions(-)

Looks good to me, just one fix up:

>
> diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
> index 5f1c6756e57c..95169308078a 100644
> --- a/drivers/nvdimm/namespace_devs.c
> +++ b/drivers/nvdimm/namespace_devs.c
> @@ -1689,9 +1689,9 @@ struct nd_namespace_common *nvdimm_namespace_common_probe(struct device *dev)
>         }
>
>         size = nvdimm_namespace_capacity(ndns);
> -       if (size < ND_MIN_NAMESPACE_SIZE) {
> -               dev_dbg(&ndns->dev, "%pa, too small must be at least %#x\n",
> -                               &size, ND_MIN_NAMESPACE_SIZE);
> +       if (size < PAGE_SIZE) {

If we're going to change the print level away from 'debug' then I
think this should be "if (size && size < PAGE_SIZE)". The sub-system
pre-creates 0-sized devices that are later configured into full
namespaces, in those cases we shouldn't fire the warning.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

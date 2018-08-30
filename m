Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com
 [IPv6:2a00:1450:4864:20::144])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8ED0C21107442
 for <linux-nvdimm@lists.01.org>; Thu, 30 Aug 2018 08:37:47 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id l26-v6so7549101lfc.8
 for <linux-nvdimm@lists.01.org>; Thu, 30 Aug 2018 08:37:47 -0700 (PDT)
MIME-Version: 1.0
References: <20180830153813.GA26059@jordon-HP-15-Notebook-PC>
In-Reply-To: <20180830153813.GA26059@jordon-HP-15-Notebook-PC>
From: Souptick Joarder <jrdr.linux@gmail.com>
Date: Thu, 30 Aug 2018 21:10:35 +0530
Message-ID: <CAFqt6zbz6bb55BYvWHq4PwH64hUWQ8DnGV9U3hB3Mg4AO3PwjQ@mail.gmail.com>
Subject: Re: [PATCH] device-dax: Convert variable to vm_fault_t type
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
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>, linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>, zwisler@kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Aug 30, 2018 at 9:05 PM Souptick Joarder <jrdr.linux@gmail.com> wrote:
>
> As part of commit 226ab561075f ("device-dax: Convert to
> vmf_insert_mixed and vm_fault_t") in 4.19-rc1,
> 'rc' was not converted to vm_fault_t. Now converted.
>
> Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>

Sorry, I missed this initially.
> ---
>  drivers/dax/device.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/dax/device.c b/drivers/dax/device.c
> index 6fd4608..bbe4d72 100644
> --- a/drivers/dax/device.c
> +++ b/drivers/dax/device.c
> @@ -392,7 +392,8 @@ static vm_fault_t dev_dax_huge_fault(struct vm_fault *vmf,
>  {
>         struct file *filp = vmf->vma->vm_file;
>         unsigned long fault_size;
> -       int rc, id;
> +       vm_fault_t rc = VM_FAULT_SIGBUS;
> +       int id;
>         pfn_t pfn;
>         struct dev_dax *dev_dax = filp->private_data;
>
> --
> 1.9.1
>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

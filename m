Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x242.google.com (mail-oi0-x242.google.com
 [IPv6:2607:f8b0:4003:c06::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C8D2A2096FACA
 for <linux-nvdimm@lists.01.org>; Wed,  4 Jul 2018 07:40:22 -0700 (PDT)
Received: by mail-oi0-x242.google.com with SMTP id k81-v6so11138693oib.4
 for <linux-nvdimm@lists.01.org>; Wed, 04 Jul 2018 07:40:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180704064058.1344-1-yehs2007@zoho.com>
References: <20180704064058.1344-1-yehs2007@zoho.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 4 Jul 2018 07:40:21 -0700
Message-ID: <CAPcyv4hJ62nDgEUpOg4ttbZbKUQctGF_adfHOJy0tHBNraeLPQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] nvdimm/pmem: check the validity of the pointer pfn
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
To: Huaisheng Ye <yehs2007@zoho.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-s390 <linux-s390@vger.kernel.org>, Matthew Wilcox <mawilcox@microsoft.com>, NingTing Cheng <chengnt@lenovo.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Bart Van Assche <bart.vanassche@wdc.com>, Al Viro <viro@zeniv.linux.org.uk>, Greg KH <gregkh@linuxfoundation.org>, Martin Schwidefsky <schwidefsky@de.ibm.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jan Kara <jack@suse.com>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jul 3, 2018 at 11:40 PM, Huaisheng Ye <yehs2007@zoho.com> wrote:
> From: Huaisheng Ye <yehs1@lenovo.com>
>
> Some functions within fs/dax don't need to get gfn from direct_access.
> Assigning NULL to gfn of dax_direct_access is more intuitive and simple
> than offering a useless local variable.
>
> So direct_access needs to check validity of the pointer pfn For NULL
> assignment.
>
> Signed-off-by: Huaisheng Ye <yehs1@lenovo.com>
> ---
>  drivers/nvdimm/pmem.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
> index 9d71492..018f990 100644
> --- a/drivers/nvdimm/pmem.c
> +++ b/drivers/nvdimm/pmem.c
> @@ -233,7 +233,8 @@ __weak long __pmem_direct_access(struct pmem_device *pmem, pgoff_t pgoff,
>                                         PFN_PHYS(nr_pages))))
>                 return -EIO;
>         *kaddr = pmem->virt_addr + offset;
> -       *pfn = phys_to_pfn_t(pmem->phys_addr + offset, pmem->pfn_flags);
> +       if (pfn)
> +               *pfn = phys_to_pfn_t(pmem->phys_addr + offset, pmem->pfn_flags);
>
>         /*
>          * If badblocks are present, limit known good range to the

Looks good. You also need to update the unit test infrastructure
version of this operation in:

    tools/testing/nvdimm/pmem-dax.c
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

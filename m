Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x244.google.com (mail-oi0-x244.google.com
 [IPv6:2607:f8b0:4003:c06::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7C0A620972141
 for <linux-nvdimm@lists.01.org>; Wed,  4 Jul 2018 09:48:42 -0700 (PDT)
Received: by mail-oi0-x244.google.com with SMTP id w126-v6so11818863oie.7
 for <linux-nvdimm@lists.01.org>; Wed, 04 Jul 2018 09:48:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180704163823.9980-1-yehs2007@zoho.com>
References: <20180704163823.9980-1-yehs2007@zoho.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 4 Jul 2018 09:48:40 -0700
Message-ID: <CAPcyv4hgk89NKGhmZ1Z3XsGFzJAn1y+46WJn_61r8rj5bmqv6A@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] Assigning NULL to gfn of dax_direct_access if
 useless
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
Cc: Jens Axboe <axboe@kernel.dk>, linux-s390 <linux-s390@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, NingTing Cheng <chengnt@lenovo.com>, Jan Kara <jack@suse.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Matthew Wilcox <willy@infradead.org>, colyli <colyli@suse.de>, Bart Van Assche <bart.vanassche@wdc.com>, Al Viro <viro@zeniv.linux.org.uk>, Greg KH <gregkh@linuxfoundation.org>, Martin Schwidefsky <schwidefsky@de.ibm.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jul 4, 2018 at 9:38 AM, Huaisheng Ye <yehs2007@zoho.com> wrote:
> From: Huaisheng Ye <yehs1@lenovo.com>
>
> Changes since v1 [1]:
> * Collect Jan's reviewed-by.
> * According to Dan's suggestion, update the unit test infrastructure
>   tools/testing/nvdimm/pmem-dax.c for checking the validity of gfn.
>
> [1]: https://lkml.org/lkml/2018/7/4/81
>
> ---
>
> Some functions within fs/dax don't need to get gfn from direct_access.

Any reason you are calling it 'gfn'? I'm assuming that is a typo and
it should be 'pfn'.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

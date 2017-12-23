Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x242.google.com (mail-ot0-x242.google.com
 [IPv6:2607:f8b0:4003:c0f::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A803722085869
 for <linux-nvdimm@lists.01.org>; Fri, 22 Dec 2017 17:49:44 -0800 (PST)
Received: by mail-ot0-x242.google.com with SMTP id o39so7024401otd.7
 for <linux-nvdimm@lists.01.org>; Fri, 22 Dec 2017 17:54:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171215140947.26075-5-hch@lst.de>
References: <20171215140947.26075-1-hch@lst.de>
 <20171215140947.26075-5-hch@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 22 Dec 2017 17:54:33 -0800
Message-ID: <CAPcyv4i-TWnQ-fRVLB9kaSxJ+2QwZUEEixkTSwYGF-73fmemvw@mail.gmail.com>
Subject: Re: [PATCH 04/17] mm: pass the vmem_altmap to arch_add_memory and
 __add_pages
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
To: Christoph Hellwig <hch@lst.de>
Cc: linux-nvdimm@lists.01.org, X86 ML <x86@kernel.org>, linux-kernel@vger.kernel.org, Linux MM <linux-mm@kvack.org>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Dec 15, 2017 at 6:09 AM, Christoph Hellwig <hch@lst.de> wrote:
> We can just pass this on instead of having to do a radix tree lookup
> without proper locking 2 levels into the callchain.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
[..]
> diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
> index 8acdc35c2dfa..e26ade50ae18 100644
> --- a/arch/x86/mm/init_64.c
> +++ b/arch/x86/mm/init_64.c
> @@ -772,12 +772,12 @@ static void update_end_of_memory_vars(u64 start, u64 size)
>         }
>  }
>
> -int add_pages(int nid, unsigned long start_pfn,
> -             unsigned long nr_pages, bool want_memblock)
> +int add_pages(int nid, unsigned long start_pfn, unsigned long nr_pages,
> +               struct vmem_altmap *altmap, bool want_memblock)
>  {
>         int ret;
>
> -       ret = __add_pages(nid, start_pfn, nr_pages, want_memblock);
> +       ret = __add_pages(nid, start_pfn, nr_pages, NULL, want_memblock);
>         WARN_ON_ONCE(ret);

Should be 'altmap' instead of NULL.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

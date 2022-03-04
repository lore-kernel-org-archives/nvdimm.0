Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99EDAC7C
	for <nvdimm@lists.linux.dev>; Fri,  4 Mar 2022 15:30:53 +0000 (UTC)
Received: from localhost (unknown [IPv6:2601:281:8300:104d::5f6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id 458762B2;
	Fri,  4 Mar 2022 15:21:29 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 458762B2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1646407289; bh=AhHVtg/426WKGFSGTFlnmzgHgc/rCgdo3CzDRsHi0+U=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=I3ux9Nk937rQeghegNLHqwynXlUDCPBjc6XCc5xU2k9JBfKg23znK5PB2A7+q5Sb1
	 wi/IqKiBgXGlqHy8fWTkBD0R3cmC7B79cgCjsiYX3N3voagDXFFhX6ugQAYH6cz1WB
	 GLULLzOYIYtaLmHWI+8sGYicc8t/uZ9/0r08F2YFoVH8og07/Fb5QLvPvCX+6OfUgk
	 M2RXgXqAbkRwUQNm+JBxUw0gZ2JaTkWFQb75GREUjc1T5i8loQXva/A+M+yE2dXbo4
	 1ZtWBAJ5zXMT+frhWE8LP5FmBN7VPxeRT64AgHtBge4eiT6R1dRPxPH6moli6eiy+h
	 bzSfHxwdaAZPw==
From: Jonathan Corbet <corbet@lwn.net>
To: Joao Martins <joao.m.martins@oracle.com>, linux-mm@kvack.org
Cc: Dan Williams <dan.j.williams@intel.com>, Vishal Verma
 <vishal.l.verma@intel.com>, Matthew Wilcox <willy@infradead.org>, Jason
 Gunthorpe <jgg@ziepe.ca>, Jane Chu <jane.chu@oracle.com>, Muchun Song
 <songmuchun@bytedance.com>, Mike Kravetz <mike.kravetz@oracle.com>, Andrew
 Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>,
 nvdimm@lists.linux.dev, linux-doc@vger.kernel.org, Joao Martins
 <joao.m.martins@oracle.com>
Subject: Re: [PATCH v7 3/5] mm/hugetlb_vmemmap: move comment block to
 Documentation/vm
In-Reply-To: <20220303213252.28593-4-joao.m.martins@oracle.com>
References: <20220303213252.28593-1-joao.m.martins@oracle.com>
 <20220303213252.28593-4-joao.m.martins@oracle.com>
Date: Fri, 04 Mar 2022 08:21:28 -0700
Message-ID: <87r17hhhfr.fsf@meer.lwn.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Joao Martins <joao.m.martins@oracle.com> writes:

> In preparation for device-dax for using hugetlbfs compound page tail
> deduplication technique, move the comment block explanation into a
> common place in Documentation/vm.
>
> Cc: Muchun Song <songmuchun@bytedance.com>
> Cc: Mike Kravetz <mike.kravetz@oracle.com>
> Suggested-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> Reviewed-by: Muchun Song <songmuchun@bytedance.com>
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  Documentation/vm/index.rst         |   1 +
>  Documentation/vm/vmemmap_dedup.rst | 175 +++++++++++++++++++++++++++++
>  mm/hugetlb_vmemmap.c               | 168 +--------------------------
>  3 files changed, 177 insertions(+), 167 deletions(-)
>  create mode 100644 Documentation/vm/vmemmap_dedup.rst

Thanks for remembering to add this to the index.rst file!  That said, I
get the impression you didn't actually build the docs afterward and look
at the result; there are a number of things here that won't render the
way you might like.

> diff --git a/Documentation/vm/index.rst b/Documentation/vm/index.rst
> index 44365c4574a3..2fb612bb72c9 100644
> --- a/Documentation/vm/index.rst
> +++ b/Documentation/vm/index.rst
> @@ -37,5 +37,6 @@ algorithms.  If you are looking for advice on simply allocating memory, see the
>     transhuge
>     unevictable-lru
>     vmalloced-kernel-stacks
> +   vmemmap_dedup
>     z3fold
>     zsmalloc
> diff --git a/Documentation/vm/vmemmap_dedup.rst b/Documentation/vm/vmemmap_dedup.rst
> new file mode 100644
> index 000000000000..8143b2ce414d
> --- /dev/null
> +++ b/Documentation/vm/vmemmap_dedup.rst
> @@ -0,0 +1,175 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +.. _vmemmap_dedup:

This label isn't needed, I'd take it out.

> +==================================
> +Free some vmemmap pages of HugeTLB
> +==================================
> +
> +The struct page structures (page structs) are used to describe a physical
> +page frame. By default, there is a one-to-one mapping from a page frame to
> +it's corresponding page struct.
> +
> +HugeTLB pages consist of multiple base page size pages and is supported by
> +many architectures. See hugetlbpage.rst in the Documentation directory for
> +more details. On the x86-64 architecture, HugeTLB pages of size 2MB and 1GB
> +are currently supported. Since the base page size on x86 is 4KB, a 2MB
> +HugeTLB page consists of 512 base pages and a 1GB HugeTLB page consists of
> +4096 base pages. For each base page, there is a corresponding page struct.
> +
> +Within the HugeTLB subsystem, only the first 4 page structs are used to
> +contain unique information about a HugeTLB page. __NR_USED_SUBPAGE provides
> +this upper limit. The only 'useful' information in the remaining page structs
> +is the compound_head field, and this field is the same for all tail pages.
> +
> +By removing redundant page structs for HugeTLB pages, memory can be returned
> +to the buddy allocator for other uses.
> +
> +Different architectures support different HugeTLB pages. For example, the
> +following table is the HugeTLB page size supported by x86 and arm64
> +architectures. Because arm64 supports 4k, 16k, and 64k base pages and
> +supports contiguous entries, so it supports many kinds of sizes of HugeTLB
> +page.
> +
> ++--------------+-----------+-----------------------------------------------+
> +| Architecture | Page Size |                HugeTLB Page Size              |
> ++--------------+-----------+-----------+-----------+-----------+-----------+
> +|    x86-64    |    4KB    |    2MB    |    1GB    |           |           |
> ++--------------+-----------+-----------+-----------+-----------+-----------+
> +|              |    4KB    |   64KB    |    2MB    |    32MB   |    1GB    |
> +|              +-----------+-----------+-----------+-----------+-----------+
> +|    arm64     |   16KB    |    2MB    |   32MB    |     1GB   |           |
> +|              +-----------+-----------+-----------+-----------+-----------+
> +|              |   64KB    |    2MB    |  512MB    |    16GB   |           |
> ++--------------+-----------+-----------+-----------+-----------+-----------+
> +
> +When the system boot up, every HugeTLB page has more than one struct page
> +structs which size is (unit: pages):
> +
> +   struct_size = HugeTLB_Size / PAGE_SIZE * sizeof(struct page) / PAGE_SIZE

This, for example, needs to be in a literal block or you won't get what
you expect; that's true of all of the code samples and ascii-art
sections.  Easiest way to do that is to end the preceding text line with
:: instead of :

Thanks,

jon

Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1287D21309D13
 for <linux-nvdimm@lists.01.org>; Tue, 12 Jun 2018 13:14:22 -0700 (PDT)
Date: Tue, 12 Jun 2018 14:14:20 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v4 11/12] mm, memory_failure: Teach memory_failure()
 about dev_pagemap pages
Message-ID: <20180612201420.GA12706@linux.intel.com>
References: <152850182079.38390.8280340535691965744.stgit@dwillia2-desk3.amr.corp.intel.com>
 <152850187949.38390.1012249765651998342.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <152850187949.38390.1012249765651998342.stgit@dwillia2-desk3.amr.corp.intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jan Kara <jack@suse.cz>, Matthew Wilcox <mawilcox@microsoft.com>, linux-nvdimm@lists.01.org, linux-mm@kvack.org, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, linux-fsdevel@vger.kernel.org, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jun 08, 2018 at 04:51:19PM -0700, Dan Williams wrote:
>     mce: Uncorrected hardware memory error in user-access at af34214200
>     {1}[Hardware Error]: It has been corrected by h/w and requires no fur=
ther action
>     mce: [Hardware Error]: Machine check events logged
>     {1}[Hardware Error]: event severity: corrected
>     Memory failure: 0xaf34214: reserved kernel page still referenced by 1=
 users
>     [..]
>     Memory failure: 0xaf34214: recovery action for reserved kernel page: =
Failed
>     mce: Memory error not recovered
> =

> In contrast to typical memory, dev_pagemap pages may be dax mapped. With
> dax there is no possibility to map in another page dynamically since dax
> establishes 1:1 physical address to file offset associations. Also
> dev_pagemap pages associated with NVDIMM / persistent memory devices can
> internal remap/repair addresses with poison. While memory_failure()
> assumes that it can discard typical poisoned pages and keep them
> unmapped indefinitely, dev_pagemap pages may be returned to service
> after the error is cleared.
> =

> Teach memory_failure() to detect and handle MEMORY_DEVICE_HOST
> dev_pagemap pages that have poison consumed by userspace. Mark the
> memory as UC instead of unmapping it completely to allow ongoing access
> via the device driver (nd_pmem). Later, nd_pmem will grow support for
> marking the page back to WB when the error is cleared.
> =

> Cc: Jan Kara <jack@suse.cz>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: J=E9r=F4me Glisse <jglisse@redhat.com>
> Cc: Matthew Wilcox <mawilcox@microsoft.com>
> Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
<>
> +static int memory_failure_dev_pagemap(unsigned long pfn, int flags,
> +		struct dev_pagemap *pgmap)
> +{
> +	const bool unmap_success =3D true;
> +	unsigned long size;
> +	struct page *page;
> +	LIST_HEAD(tokill);
> +	int rc =3D -EBUSY;
> +	loff_t start;
> +
> +	/*
> +	 * Prevent the inode from being freed while we are interrogating
> +	 * the address_space, typically this would be handled by
> +	 * lock_page(), but dax pages do not use the page lock.
> +	 */
> +	page =3D dax_lock_page(pfn);
> +	if (!page)
> +		goto out;
> +
> +	if (hwpoison_filter(page)) {
> +		rc =3D 0;
> +		goto unlock;
> +	}
> +
> +	switch (pgmap->type) {
> +	case MEMORY_DEVICE_PRIVATE:
> +	case MEMORY_DEVICE_PUBLIC:
> +		/*
> +		 * TODO: Handle HMM pages which may need coordination
> +		 * with device-side memory.
> +		 */
> +		goto unlock;
> +	default:
> +		break;
> +	}
> +
> +	/*
> +	 * If the page is not mapped in userspace then report it as
> +	 * unhandled.
> +	 */
> +	size =3D dax_mapping_size(page);
> +	if (!size) {
> +		pr_err("Memory failure: %#lx: failed to unmap page\n", pfn);
> +		goto unlock;
> +	}
> +
> +	SetPageHWPoison(page);
> +
> +	/*
> +	 * Unlike System-RAM there is no possibility to swap in a
> +	 * different physical page at a given virtual address, so all
> +	 * userspace consumption of ZONE_DEVICE memory necessitates
> +	 * SIGBUS (i.e. MF_MUST_KILL)
> +	 */
> +	flags |=3D MF_ACTION_REQUIRED | MF_MUST_KILL;
> +	collect_procs(page, &tokill, flags & MF_ACTION_REQUIRED);

You know "flags & MF_ACTION_REQUIRED" will always be true, so you can just
pass in MF_ACTION_REQUIRED or even just "true".

> +
> +	start =3D (page->index << PAGE_SHIFT) & ~(size - 1);
> +	unmap_mapping_range(page->mapping, start, start + size, 0);
> +
> +	kill_procs(&tokill, flags & MF_MUST_KILL, !unmap_success, ilog2(size),

You know "flags & MF_MUST_KILL" will always be true, so you can just pass in
MF_MUST_KILL or even just "true".

Also, you can get rid of the constant "unmap_success" if you want and just
pass in false as the 3rd argument.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

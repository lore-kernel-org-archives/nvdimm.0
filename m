Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com
 [148.163.158.5])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 19E0421250C93
 for <linux-nvdimm@lists.01.org>; Thu, 20 Jun 2019 05:30:27 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
 by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id
 x5KCJPBd093689
 for <linux-nvdimm@lists.01.org>; Thu, 20 Jun 2019 08:30:26 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
 by mx0a-001b2d01.pphosted.com with ESMTP id 2t89t8h4nb-1
 (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
 for <linux-nvdimm@lists.01.org>; Thu, 20 Jun 2019 08:30:26 -0400
Received: from localhost
 by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
 Violators will be prosecuted
 for <linux-nvdimm@lists.01.org> from <rppt@linux.ibm.com>;
 Thu, 20 Jun 2019 13:30:24 +0100
Date: Thu, 20 Jun 2019 15:30:18 +0300
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: Re: [PATCH v10 10/13] mm: Document ZONE_DEVICE memory-model
 implications
References: <156092349300.979959.17603710711957735135.stgit@dwillia2-desk3.amr.corp.intel.com>
 <156092354985.979959.15763234410543451710.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <156092354985.979959.15763234410543451710.stgit@dwillia2-desk3.amr.corp.intel.com>
Message-Id: <20190620123017.GB18387@rapoport-lnx>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jun 18, 2019 at 10:52:29PM -0700, Dan Williams wrote:
> Explain the general mechanisms of 'ZONE_DEVICE' pages and list the users
> of 'devm_memremap_pages()'.
> 
> Cc: Jonathan Corbet <corbet@lwn.net>
> Reported-by: Mike Rapoport <rppt@linux.ibm.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

With one nit below

Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>

> ---
>  Documentation/vm/memory-model.rst |   39 +++++++++++++++++++++++++++++++++++++
>  1 file changed, 39 insertions(+)
> 
> diff --git a/Documentation/vm/memory-model.rst b/Documentation/vm/memory-model.rst
> index 382f72ace1fc..e0af47e02e78 100644
> --- a/Documentation/vm/memory-model.rst
> +++ b/Documentation/vm/memory-model.rst
> @@ -181,3 +181,42 @@ that is eventually passed to vmemmap_populate() through a long chain
>  of function calls. The vmemmap_populate() implementation may use the
>  `vmem_altmap` along with :c:func:`altmap_alloc_block_buf` helper to
>  allocate memory map on the persistent memory device.
> +
> +ZONE_DEVICE
> +===========
> +The `ZONE_DEVICE` facility builds upon `SPARSEMEM_VMEMMAP` to offer
> +`struct page` `mem_map` services for device driver identified physical
> +address ranges. The "device" aspect of `ZONE_DEVICE` relates to the fact
> +that the page objects for these address ranges are never marked online,
> +and that a reference must be taken against the device, not just the page
> +to keep the memory pinned for active use. `ZONE_DEVICE`, via
> +:c:func:`devm_memremap_pages`, performs just enough memory hotplug to
> +turn on :c:func:`pfn_to_page`, :c:func:`page_to_pfn`, and
> +:c:func:`get_user_pages` service for the given range of pfns. Since the
> +page reference count never drops below 1 the page is never tracked as
> +free memory and the page's `struct list_head lru` space is repurposed
> +for back referencing to the host device / driver that mapped the memory.
> +
> +While `SPARSEMEM` presents memory as a collection of sections,
> +optionally collected into memory blocks, `ZONE_DEVICE` users have a need
> +for smaller granularity of populating the `mem_map`. Given that
> +`ZONE_DEVICE` memory is never marked online it is subsequently never
> +subject to its memory ranges being exposed through the sysfs memory
> +hotplug api on memory block boundaries. The implementation relies on
> +this lack of user-api constraint to allow sub-section sized memory
> +ranges to be specified to :c:func:`arch_add_memory`, the top-half of
> +memory hotplug. Sub-section support allows for `PMD_SIZE` as the minimum
> +alignment granularity for :c:func:`devm_memremap_pages`.
> +
> +The users of `ZONE_DEVICE` are:

Sphinx wants an empty line here:
/home/rapoport/git/linux-docs/Documentation/vm/memory-model.rst:213: ERROR:
Unexpected indentation.

> +* pmem: Map platform persistent memory to be used as a direct-I/O target
> +  via DAX mappings.
> +
> +* hmm: Extend `ZONE_DEVICE` with `->page_fault()` and `->page_free()`
> +  event callbacks to allow a device-driver to coordinate memory management
> +  events related to device-memory, typically GPU memory. See
> +  Documentation/vm/hmm.rst.
> +
> +* p2pdma: Create `struct page` objects to allow peer devices in a
> +  PCI/-E topology to coordinate direct-DMA operations between themselves,
> +  i.e. bypass host memory.
> 

-- 
Sincerely yours,
Mike.

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

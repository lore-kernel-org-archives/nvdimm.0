From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 1/2] mm: fix cache mode of dax pmd mappings
Date: Thu, 8 Sep 2016 15:49:31 -0700
Message-ID: <20160908154931.73b8c075b8c8e4702f877bd7@linux-foundation.org>
References: <147328716869.35069.16311932814998156819.stgit@dwillia2-desk3.amr.corp.intel.com>
	<147328717393.35069.6384193370523015106.stgit@dwillia2-desk3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <147328717393.35069.6384193370523015106.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: owner-linux-mm@kvack.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm@ml01.01.org, Toshi Kani <toshi.kani@hpe.com>, Matthew Wilcox <mawilcox@microsoft.com>, Nilesh Choudhury <nilesh.choudhury@oracle.com>, linux-kernel@vger.kernel.org, stable@vger.kernel.org, linux-mm@kvack.org, dri-devel@lists.freedesktop.org, Ross Zwisler <ross.zwisler@linux.intel.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Kai Zhang <kai.ka.zhang@oracle.com>
List-Id: linux-nvdimm@lists.01.org

On Wed, 07 Sep 2016 15:26:14 -0700 Dan Williams <dan.j.williams@intel.com> wrote:

> track_pfn_insert() in vmf_insert_pfn_pmd() is marking dax mappings as
> uncacheable rendering them impractical for application usage.  DAX-pte
> mappings are cached and the goal of establishing DAX-pmd mappings is to
> attain more performance, not dramatically less (3 orders of magnitude).
> 
> track_pfn_insert() relies on a previous call to reserve_memtype() to
> establish the expected page_cache_mode for the range.  While memremap()
> arranges for reserve_memtype() to be called, devm_memremap_pages() does
> not.  So, teach track_pfn_insert() and untrack_pfn() how to handle
> tracking without a vma, and arrange for devm_memremap_pages() to
> establish the write-back-cache reservation in the memtype tree.

Acked-by: Andrew Morton <akpm@linux-foundation.org>

I'll grab [2/2].

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

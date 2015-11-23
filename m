Return-Path: <owner-linux-mm@kvack.org>
Message-ID: <1448319526.19320.58.camel@hpe.com>
Subject: Re: [PATCH] dax: Split pmd map when fallback on COW
From: Toshi Kani <toshi.kani@hpe.com>
Date: Mon, 23 Nov 2015 15:58:46 -0700
In-Reply-To: <1448309120-20911-1-git-send-email-toshi.kani@hpe.com>
References: <1448309120-20911-1-git-send-email-toshi.kani@hpe.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: owner-linux-mm@kvack.org
To: dan.j.williams@intel.com
Cc: kirill.shutemov@linux.intel.com, willy@linux.intel.com, ross.zwisler@linux.intel.com, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Mon, 2015-11-23 at 13:05 -0700, Toshi Kani wrote:
> An infinite loop of PMD faults was observed when attempted to
> mlock() a private read-only PMD mmap'd range of a DAX file.

Typo: the above description should be (remove "read-only"): 

An infinite loop of PMD faults was observed when attempted to mlock() a private
PMD mmap'd range of a DAX file.

-Toshi

> __dax_pmd_fault() simply returns with VM_FAULT_FALLBACK when
> falling back to PTE on COW.  However, __handle_mm_fault()
> returns without falling back to handle_pte_fault() because
> a PMD map is present in this case.
> 
> Change __dax_pmd_fault() to split the PMD map, if present,
> before returning with VM_FAULT_FALLBACK.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

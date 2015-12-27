Return-Path: <owner-linux-mm@kvack.org>
MIME-Version: 1.0
In-Reply-To: <CAA_GA1f44ADq7dw7LUM=rEex8m0vMXvGeOdW1YKkisbv51iuKw@mail.gmail.com>
References: <20151221054406.34542.64393.stgit@dwillia2-desk3.jf.intel.com>
	<CAA_GA1f44ADq7dw7LUM=rEex8m0vMXvGeOdW1YKkisbv51iuKw@mail.gmail.com>
Date: Sun, 27 Dec 2015 10:55:34 -0800
Message-ID: <CAPcyv4j5QRAy-pM=TcCVrY8tH8H7iOL36KojZOeHKuLdBOcwDg@mail.gmail.com>
Subject: Re: [-mm PATCH v4 00/18] get_user_pages() for dax pte and pmd mappings
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: owner-linux-mm@kvack.org
To: Bob Liu <lliubbo@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Dave Hansen <dave@sr71.net>, David Airlie <airlied@linux.ie>, Dave Hansen <dave.hansen@linux.intel.com>, Dave Chinner <david@fromorbit.com>, Linux-MM <linux-mm@kvack.org>, "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@lst.de>, Andrea Arcangeli <aarcange@redhat.com>, kbuild test robot <lkp@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, X86 ML <x86@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, Mel Gorman <mgorman@suse.de>, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Christoffer Dall <christoffer.dall@linaro.org>, Paolo Bonzini <pbonzini@redhat.com>, Logan Gunthorpe <logang@deltatee.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Sun, Dec 27, 2015 at 12:33 AM, Bob Liu <lliubbo@gmail.com> wrote:
> Hey Dan,
>
[..]
> What about space for page tables?
> Page tables(mapping all memory in PMEM to virtual address space) may
> also consume significantly DRAM space if  huge page is not enabled or
> split.
> Should we also consider to allocate pte page tables from PMEM in future?

On x86_64 these ranges are covered by gigabyte pages by default (see
init_memory_mapping()).  I don't see much incremental benefit from
allocating pte's from pmem.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

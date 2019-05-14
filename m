Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from aserp2130.oracle.com (aserp2130.oracle.com [141.146.126.79])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 62161212532FB
 for <linux-nvdimm@lists.01.org>; Tue, 14 May 2019 09:09:26 -0700 (PDT)
Date: Tue, 14 May 2019 09:09:06 -0700
From: Larry Bassel <larry.bassel@oracle.com>
Subject: Re: [PATCH, RFC 0/2] Share PMDs for FS/DAX on x86
Message-ID: <20190514160906.GB27569@ubuette>
References: <1557417933-15701-1-git-send-email-larry.bassel@oracle.com>
 <20190514122820.26zddpb27uxgrwzp@box>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190514122820.26zddpb27uxgrwzp@box>
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
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, willy@infradead.org, linux-mm@kvack.org, mike.kravetz@oracle.com
List-ID: <linux-nvdimm@lists.01.org>

On 14 May 19 15:28, Kirill A. Shutemov wrote:
> On Thu, May 09, 2019 at 09:05:31AM -0700, Larry Bassel wrote:
> > This patchset implements sharing of page table entries pointing
> > to 2MiB pages (PMDs) for FS/DAX on x86.
> 
> -EPARSE.
> 
> How do you share entries? Entries do not take any space, page tables that
> cointain these entries do.

Yes, I'll correct this in v2.

> 
> Have you checked if the patch makes memory consumption any better. I have
> doubts in it.

Yes I have -- the following is debugging output I have from my testing.
The (admittedly simple) test case is two copies of a program that mmaps
1GiB of a DAX/XFS file (with 2MiB page size), touches the first page
(physical 200400000 in this case) and then sleeps forever.

sharing disabled:

(process A)
[  420.369975] pgd_index = fe
[  420.369975] pgd = 00000000e1ebf83b
[  420.369975] pgd_val = 8000000405ca8067
[  420.369976] pud_index = 100
[  420.369976] pud = 00000000bd7a7df0
[  420.369976] pud_val = 4058f9067
[  420.369977] pmd_index = 0
[  420.369977] pmd = 00000000791e93d4
[  420.369977] pmd_val = 84000002004008e7
[  420.369978] pmd huge
[  420.369978] page_addr = 200400000, page_offset = 0
[  420.369979] vaddr = 7f4000000000, paddr = 200400000

(process B)
[  420.370013] pgd_index = fe
[  420.370014] pgd = 00000000a2bac60d
[  420.370014] pgd_val = 8000000405a8f067
[  420.370015] pud_index = 100
[  420.370015] pud = 00000000dcc3ff1a
[  420.370015] pud_val = 3fc713067
[  420.370016] pmd_index = 0
[  420.370016] pmd = 000000006b4679db
[  420.370016] pmd_val = 84000002004008e7
[  420.370017] pmd huge
[  420.370017] page_addr = 200400000, page_offset = 0
[  420.370018] vaddr = 7f4000000000, paddr = 200400000

sharing enabled:

(process A)
[  696.992342] pgd_index = fe
[  696.992342] pgd = 000000009612024b
[  696.992343] pgd_val = 8000000404725067
[  696.992343] pud_index = 100
[  696.992343] pud = 00000000c98ab17c
[  696.992344] pud_val = 4038e3067
[  696.992344] pmd_index = 0
[  696.992344] pmd = 000000002437681b
[  696.992344] pmd_val = 84000002004008e7
[  696.992345] pmd huge
[  696.992345] page_addr = 200400000, page_offset = 0
[  696.992345] vaddr = 7f4000000000, paddr = 200400000

(process B)
[  696.992351] pgd_index = fe
[  696.992351] pgd = 0000000012326848
[  696.992352] pgd_val = 800000040a953067
[  696.992352] pud_index = 100
[  696.992352] pud = 00000000f989bcf6
[  696.992352] pud_val = 4038e3067
[  696.992353] pmd_index = 0
[  696.992353] pmd = 000000002437681b
[  696.992353] pmd_val = 84000002004008e7
[  696.992353] pmd huge
[  696.992354] page_addr = 200400000, page_offset = 0
[  696.992354] vaddr = 7f4000000000, paddr = 200400000

Note that in the sharing enabled case, the pud_val and pmd are
the same for the two processes. In the disabled case we
have two separate pmds (and so more memory was allocated).

Also, (though not visible from the output above) the second
process did not take a page fault as the virtual->physical mapping
was already established thanks to the sharing.

Larry
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org
 [IPv6:2607:7c80:54:e::133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 147B52120B128
 for <linux-nvdimm@lists.01.org>; Thu, 25 Apr 2019 17:51:29 -0700 (PDT)
Date: Thu, 25 Apr 2019 17:51:24 -0700
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v2] mm: Fix modifying of page protection by
 insert_pfn_pmd()
Message-ID: <20190426005124.GA25606@bombadil.infradead.org>
References: <20190402115125.18803-1-aneesh.kumar@linux.ibm.com>
 <CAPcyv4hzRj5yxVJ5-7AZgzzBxEL02xf2xwhDv-U9_osWFm9kiA@mail.gmail.com>
 <20190424173833.GE19031@bombadil.infradead.org>
 <CAPcyv4gLGUa69svQnwjvruALZ0ChqUJZHQJ1Mt_Cjr1Jh_6vbQ@mail.gmail.com>
 <20190425073149.GA21215@quack2.suse.cz>
 <CAPcyv4iYMP4NWxa08zTdRxtc4UcbFFOCwbMZijB0bc2WcawggQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4iYMP4NWxa08zTdRxtc4UcbFFOCwbMZijB0bc2WcawggQ@mail.gmail.com>
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
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm <linux-nvdimm@lists.01.org>, "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>, stable <stable@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Chandan Rajendra <chandan@linux.ibm.com>, Andrew Morton <akpm@linux-foundation.org>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Apr 25, 2019 at 05:33:04PM -0700, Dan Williams wrote:
> On Thu, Apr 25, 2019 at 12:32 AM Jan Kara <jack@suse.cz> wrote:
> > > > We also call vmf_insert_pfn_pmd() in dax_insert_pfn_mkwrite() -- does
> > > > that need to change too?
> > >
> > > It wasn't clear to me that it was a problem. I think that one already
> > > happens to be pmd-aligned.
> >
> > Why would it need to be? The address is taken from vmf->address and that's
> > set up in __handle_mm_fault() like .address = address & PAGE_MASK. So I
> > don't see anything forcing PMD alignment of the virtual address...
> 
> True. So now I'm wondering if the masking should be done internal to
> the routine. Given it's prefixed vmf_ it seems to imply the api is
> prepared to take raw 'struct vm_fault' parameters. I think I'll go
> that route unless someone sees a reason to require the caller to
> handle this responsibility.

The vmf_ prefix was originally used to indicate 'returns a vm_fault_t'
instead of 'returns an errno'.  That said, I like the interpretation
you're coming up with here, and it makes me wonder if we shouldn't
change vmf_insert_pfn_pmd() to take (vmf, pfn, write) as arguments
instead of separate vma, address & pmd arguments.

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

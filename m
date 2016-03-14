Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 by ml01.01.org (Postfix) with ESMTP id 34FAD1A1E10
 for <linux-nvdimm@lists.01.org>; Mon, 14 Mar 2016 08:00:19 -0700 (PDT)
Date: Mon, 14 Mar 2016 11:00:19 -0400
From: Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH 1/3] pfn_t: Change the encoding
Message-ID: <20160314150019.GA23727@linux.intel.com>
References: <1457730784-9890-1-git-send-email-matthew.r.wilcox@intel.com>
 <1457730784-9890-2-git-send-email-matthew.r.wilcox@intel.com>
 <CAPcyv4g82US298_mCd75toj9kEeyDhw0cP_Ott0R8fOydWNsSg@mail.gmail.com>
 <20160312183005.GA2525@linux.intel.com>
 <CAPcyv4jSp7ThDO2eVWpsArRVa8TJBeuJdDZfPFSceHXthG1aww@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4jSp7ThDO2eVWpsArRVa8TJBeuJdDZfPFSceHXthG1aww@mail.gmail.com>
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
Cc: Linux MM <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, Matthew Wilcox <matthew.r.wilcox@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Sun, Mar 13, 2016 at 04:09:38PM -0700, Dan Williams wrote:
> On Sat, Mar 12, 2016 at 10:30 AM, Matthew Wilcox <willy@linux.intel.com> wrote:
> > On Fri, Mar 11, 2016 at 01:40:20PM -0800, Dan Williams wrote:
> >> Can we just bit swizzle a pfn_t on insertion/retrieval from the radix?
> >
> > Of course we *can*, but we end up doing more swizzling that way than we
> > do this way.  In the Brave New Future where we're storing pfn_t in the
> > radix tree, on a page fault we find the pfn_t in the radix tree then
> > we want to insert it into the page tables.  So DAX would first have to
> > convert the radix tree entry to a pfn_t, then the page table code has to
> > convert the pfn_t into a pte/pmd/pud (which we currently do by converting
> > a pfn_t to a pfn, then converting the pfn to a pte/pmd/pud, but I assume
> > that either the compiler optimises that into a single conversion, or we'll
> > add pfn_t_pte to each architecture in future if it's actually a problem).
> >
> > Much easier to look up a pfn_t in the radix tree and pass it directly
> > to vm_insert_mixed().
> >
> > If there's any part of the kernel that is doing a *lot* of conversion
> > between pfn_t and pfn, that surely indicates a place in the kernel where
> > we need to convert an interface from pfn to pfn_t.
> 
> So this is dependent on where pfn_t gets pushed in the future.  For
> example, if we revive using a pfn_t in a bio then I think the
> pfn_to_pfn_t() conversions will be more prevalent than the fs/dax.c
> radix usages.

Yes, we'll be converting to a pfn_t in more places than we are now
...  but what do we do with that pfn_t once we've got it into a bio?
Except for some rare cases (brd, maybe pmem), it gets converted into an
sg list which then gets DMA mapped, then the DMA addresses are converted
into whatever format the hardware wants.  As long as we convert the sg
list before we convert the bio, there aren't going to be any additional
conversions from pfn_t to pfn.  So I don't see this showing up as an
additional per-I/O cost.

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

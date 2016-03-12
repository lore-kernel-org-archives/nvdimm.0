Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 by ml01.01.org (Postfix) with ESMTP id 43F4F1A1F54
 for <linux-nvdimm@lists.01.org>; Sat, 12 Mar 2016 10:30:00 -0800 (PST)
Date: Sat, 12 Mar 2016 13:30:05 -0500
From: Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH 1/3] pfn_t: Change the encoding
Message-ID: <20160312183005.GA2525@linux.intel.com>
References: <1457730784-9890-1-git-send-email-matthew.r.wilcox@intel.com>
 <1457730784-9890-2-git-send-email-matthew.r.wilcox@intel.com>
 <CAPcyv4g82US298_mCd75toj9kEeyDhw0cP_Ott0R8fOydWNsSg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4g82US298_mCd75toj9kEeyDhw0cP_Ott0R8fOydWNsSg@mail.gmail.com>
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

On Fri, Mar 11, 2016 at 01:40:20PM -0800, Dan Williams wrote:
> On Fri, Mar 11, 2016 at 1:13 PM, Matthew Wilcox
> <matthew.r.wilcox@intel.com> wrote:
> > By moving the flag bits to the bottom, we encourage commonality
> > between SGs with pages and those using pfn_t.  We can also then insert
> > a pfn_t into a radix tree, as it uses the same two bits for indirect &
> > exceptional indicators.
> 
> It's not immediately clear to me what we gain with SG entry
> commonality.  The down side is that we lose the property that
> pfn_to_pfn_t() is a nop.  This was Dave's suggestion so that the
> nominal case did not change the binary layout of a typical pfn.

I understand that motivation!

> Can we just bit swizzle a pfn_t on insertion/retrieval from the radix?

Of course we *can*, but we end up doing more swizzling that way than we
do this way.  In the Brave New Future where we're storing pfn_t in the
radix tree, on a page fault we find the pfn_t in the radix tree then
we want to insert it into the page tables.  So DAX would first have to
convert the radix tree entry to a pfn_t, then the page table code has to
convert the pfn_t into a pte/pmd/pud (which we currently do by converting
a pfn_t to a pfn, then converting the pfn to a pte/pmd/pud, but I assume
that either the compiler optimises that into a single conversion, or we'll
add pfn_t_pte to each architecture in future if it's actually a problem).

Much easier to look up a pfn_t in the radix tree and pass it directly
to vm_insert_mixed().

If there's any part of the kernel that is doing a *lot* of conversion
between pfn_t and pfn, that surely indicates a place in the kernel where
we need to convert an interface from pfn to pfn_t.

(It occurs to me we can make the code simpler on architectures that
don't support PUDs.  The PFN_HUGE bit is still available to distinguish
between PMDs and PTEs, but we won't need to clear the bottom bit of the
PFN if PFN_HUGE is set, since nobody can add a PUD pfn to the radix tree).
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

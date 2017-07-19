Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6617D21D1B2AB
 for <linux-nvdimm@lists.01.org>; Wed, 19 Jul 2017 14:56:38 -0700 (PDT)
Date: Wed, 19 Jul 2017 15:58:31 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v3 1/5] mm: add vm_insert_mixed_mkwrite()
Message-ID: <20170719215831.GC10923@linux.intel.com>
References: <20170628220152.28161-1-ross.zwisler@linux.intel.com>
 <20170628220152.28161-2-ross.zwisler@linux.intel.com>
 <20170719141659.GB15908@quack2.suse.cz>
 <20170719175112.GA24588@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170719175112.GA24588@linux.intel.com>
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>, Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>, Theodore Ts'o <tytso@mit.edu>, Alexander Viro <viro@zeniv.linux.org.uk>, Andreas Dilger <adilger.kernel@dilger.ca>, Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>, Dave Hansen <dave.hansen@intel.com>, Ingo Molnar <mingo@redhat.com>, Jonathan Corbet <corbet@lwn.net>, Matthew Wilcox <mawilcox@microsoft.com>, Steven Rostedt <rostedt@goodmis.org>, linux-doc@vger.kernel.org, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jul 19, 2017 at 11:51:12AM -0600, Ross Zwisler wrote:
> On Wed, Jul 19, 2017 at 04:16:59PM +0200, Jan Kara wrote:
> > On Wed 28-06-17 16:01:48, Ross Zwisler wrote:
> > > To be able to use the common 4k zero page in DAX we need to have our PTE
> > > fault path look more like our PMD fault path where a PTE entry can be
> > > marked as dirty and writeable as it is first inserted, rather than waiting
> > > for a follow-up dax_pfn_mkwrite() => finish_mkwrite_fault() call.
> > > 
> > > Right now we can rely on having a dax_pfn_mkwrite() call because we can
> > > distinguish between these two cases in do_wp_page():
> > > 
> > > 	case 1: 4k zero page => writable DAX storage
> > > 	case 2: read-only DAX storage => writeable DAX storage
> > > 
> > > This distinction is made by via vm_normal_page().  vm_normal_page() returns
> > > false for the common 4k zero page, though, just as it does for DAX ptes.
> > > Instead of special casing the DAX + 4k zero page case, we will simplify our
> > > DAX PTE page fault sequence so that it matches our DAX PMD sequence, and
> > > get rid of dax_pfn_mkwrite() completely.
> > > 
> > > This means that insert_pfn() needs to follow the lead of insert_pfn_pmd()
> > > and allow us to pass in a 'mkwrite' flag.  If 'mkwrite' is set insert_pfn()
> > > will do the work that was previously done by wp_page_reuse() as part of the
> > > dax_pfn_mkwrite() call path.
> > > 
> > > Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> > 
> > Just one small comment below.
> > 
> > > @@ -1658,14 +1658,26 @@ static int insert_pfn(struct vm_area_struct *vma, unsigned long addr,
> > >  	if (!pte)
> > >  		goto out;
> > >  	retval = -EBUSY;
> > > -	if (!pte_none(*pte))
> > > -		goto out_unlock;
> > > +	if (!pte_none(*pte)) {
> > > +		if (mkwrite) {
> > > +			entry = *pte;
> > > +			goto out_mkwrite;
> > 
> > Can we maybe check here that (pte_pfn(*pte) == pfn_t_to_pfn(pfn)) and
> > return -EBUSY otherwise? That way we are sure insert_pfn() isn't doing
> > anything we don't expect 
> 
> Sure, that's fine.  I'll add it as a WARN_ON_ONCE() so it's a very loud
> failure.  If the pfns don't match I think we're insane (and would have been
> insane prior to this patch series as well) because we are getting a page fault
> and somehow have a different PFN already mapped at that location.

Umm...well, I added the warning, and during my regression testing hit a case
where the PFNs didn't match.  (generic/437 with both ext4 & XFS)

I've verified that this behavior happens with vanilla v4.12, so it's not a new
condition introduced by my patch.

I'm off tracking that down - there's a bug lurking somewhere, I think.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3743E2C3266;
	Wed, 20 May 2026 04:49:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779252579; cv=none; b=sal/iY9ZHI/v6cvRafKzwaQWAvkoH3oHiXJo1syTj5f9vkT4BZaK3Yk4s5PfAxV67RDWsCBj4lQidLxC5OM6mX3BAySuS/lhYLPpuV+p9cnrcJ0QAp3ulvcx+sa1R7Z9td9GufKGO8uDpWXYtDlkFOAEDCiTc/dOa0mSJ/kEwtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779252579; c=relaxed/simple;
	bh=tsG6ru1MSskiNeLeYJb7YmgjFyXpcchBrtO7IX97SW8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DL/OozueO3QolDPy6vqAjCjCQVPX66u/SVBtIlFiGccHMKkKAEYk0fTsaKMNScxX1odDsbSsXftTrT8vD50FzVb9muW3Nh+nUElR/Z3jIw0glzPDWkO0tFDiUqTezB7EbaaCb/BO1jhiPMAQ9wdCUK+ySUrQVmU8+4/SRkefZec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZTGSwtJw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZTGSwtJw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DDE41F000E9;
	Wed, 20 May 2026 04:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779252577;
	bh=Tk2ES+Q3aJ0Hik8oCA5uTW4MnCjo5aHhcTtkv4972Ck=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZTGSwtJwOo8pDeyMJs2WKS4u/0mO8JTu5XBp2wgVPVK8YtwUxoDHAW1cFpv1T8rcM
	 hmPKJRUDOpSaG8VQmetvCbeNXtV0w7oqEW5Zh6YE1pt/yUqM7TMkT5gaALgw0blL1P
	 biDwfFU5xLlGfnVut3my08IajnDqDr/LV51SbgIqGjZBLjLvU97TCzOL9cLVBPMGeu
	 xy8icAcL7LjpfY8ySeVxmFRBS2QfANLgUFCyjX4rj24rX6UXyP38OL2d4BBP3qK5gk
	 SVreGzzqfmkk41m43iY6FajidL64ANLCAxa4bSTUWbWX4DFeo+ypJCArXndJCQQokd
	 lCzkWMDVcCFeA==
Date: Wed, 20 May 2026 07:49:27 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Juhyung Park <qkrwngud825@gmail.com>,
	Vishal Moola <vishal.moola@gmail.com>
Cc: Dave Hansen <dave.hansen@intel.com>, linux-mm@kvack.org,
	stable@vger.kernel.org, Lu Baolu <baolu.lu@linux.intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, Dan Williams <djbw@kernel.org>,
	Dave Jiang <dave.jiang@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>, linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev, Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH] x86/mm: fix vmemmap leak on memory hot-remove
Message-ID: <ag09V3UyN2aWA7Wb@kernel.org>
References: <20260519151008.1399226-1-qkrwngud825@gmail.com>
 <5d00b63c-1802-450f-8e54-8da6c0aeedc2@intel.com>
 <CAD14+f2p7D6eco+-O0X6zWwi-XaxGLs0nQKDAC8eVWhQmB1VhA@mail.gmail.com>
 <e38e5fd0-db57-417b-a2d1-0521333ae7cb@intel.com>
 <CAD14+f3sohXj9SKEkRXGK_Mpbp73R5az-tsiHnHkj0poBHwpvw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAD14+f3sohXj9SKEkRXGK_Mpbp73R5az-tsiHnHkj0poBHwpvw@mail.gmail.com>

(adding Vishal)

On Wed, May 20, 2026 at 01:59:49AM +0900, Juhyung Park wrote:
> On Wed, May 20, 2026 at 1:41 AM Dave Hansen <dave.hansen@intel.com> wrote:
> >
> > On 5/19/26 09:27, Juhyung Park wrote:
> > > Hi Dave,
> > >
> > > On Wed, May 20, 2026 at 1:02 AM Dave Hansen <dave.hansen@intel.com> wrote:
> > >>
> > >> On 5/19/26 08:10, Juhyung Park wrote:
> > >>>  #endif
> > >>>       } else {
> > >>> -             pagetable_free(page_ptdesc(page));
> > >>> +             /*
> > >>> +              * Use __free_pages() to honor @order: vmemmap PMD leaves
> > >>> +              * freed here are not compound pages, so pagetable_free()
> > >>> +              * would lose leak 511 of 512 pages per 2 MB chunk.
> > >>> +              */
> > >>> +             __free_pages(page, order);
> > >>>       }
> > >>>  }
> > >>
> > >> I find myself really wondering how much of this came from a human and
> > >> how much from the LLM. Could you share that with us?
> > >
> > > Not my first kernel contribution, just so you know. (first in mm tho)
> > >
> > > I asked Claude to write both the commit body and comment and it was
> > > too verbose. I manually trimmed it down.
> > > Sorry if it still sounds too LLM-ish.
> >
> > Yeah, it still sounded really LLM-ish to me. Still rather chatty.
> >
> > > This was tested on a VM with virtualized CXL device and toggling it
> > > back and forth was visibly causing leaks. kmemleak was unable to catch
> > > this (rightfully so), so I skeptically asked Claude to see if it can
> > > figure it out while pwd was the kernel source the VM was running.
> > > "Access the VM at "ssh -p2223 root@192.168.0.185". There's a memory
> > > leak whenever CXL memory switches modes via: daxctl reconfigure-device
> > > --mode=system-ram dax0.0 --force, daxctl reconfigure-device
> > > --mode=devdax dax0.0 --force. Figure out why. If you need to reboot
> > > the VM, do not do it yourself and ask me."
> > >
> > > It did in 6 minutes and it basically told me to revert bf9e4e30f353. I
> > > was very skeptical and reviewed manually (with my short knowledge of
> > > mm) why this would be a correct fix.
> >
> > Neato.
> >
> > >> We're trying to get _away_ from using the 'struct page' APIs on page
> > >> tables. This goes backwards. Worst case, do:
> > >>
> > >>         /* vmemmap PMD leaves are not compound pages */
> > >>         for (i = 0; i < 1<<order; i++)
> > >>                 pagetable_free(page_ptdesc(&page[i]));
> > >>
> > >> Right?
> > >
> > > Shouldn't I worry about the loop overhead? With order == 9, that's 512
> > > iterations. That's compounded to O(N) when the entire memory size is
> > > in consideration.
> >
> > Is it optimal? No.
> >
> > Will anybody ever notice? Also no.
> >
> > Will anybody ever care? No sir.
> 
> Just spun a test with that loop. It doesn't fix the leak.
> 
> I hate to be the guy that copy-pastas LLM but this is outside my
> knowledge of mm. Claude suggests:
> "Each pagetable_free() on the tails is a no-op: When
> alloc_pages_node(node, gfp, order=9) returns without __GFP_COMP, the
> buddy allocator only sets _refcount = 1 on the head page. The other
> 511 pages (page[1] … page[511]) have _refcount = 0. There's no
> compound metadata, so they aren't "tails" in the folio sense either —
> they're just contiguous pages whose refcounts the allocator never
> touched."
> 
> Any ideas?
> 
> Thanks.
> 
> >
> > Can you measure the difference? I'd wager a beer: No again.
> >
> > Even if someone manages to notice, then you have a clear path to fix it
> > *right*: fix the ptdesc data structure to represent high-order allocations.

-- 
Sincerely yours,
Mike.

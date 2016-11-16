From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 01/21] mm: Join struct fault_env and vm_fault
Date: Wed, 16 Nov 2016 12:01:01 +0100
Message-ID: <20161116110101.GE21785@quack2.suse.cz>
References: <1478233517-3571-1-git-send-email-jack@suse.cz>
 <1478233517-3571-2-git-send-email-jack@suse.cz>
 <20161115215021.GA23021@node>
 <20161116105132.GR3142@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161116105132.GR3142-ndre7Fmf5hadTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

On Wed 16-11-16 11:51:32, Peter Zijlstra wrote:
> On Wed, Nov 16, 2016 at 12:50:21AM +0300, Kirill A. Shutemov wrote:
> > On Fri, Nov 04, 2016 at 05:24:57AM +0100, Jan Kara wrote:
> > > Currently we have two different structures for passing fault information
> > > around - struct vm_fault and struct fault_env. DAX will need more
> > > information in struct vm_fault to handle its faults so the content of
> > > that structure would become event closer to fault_env. Furthermore it
> > > would need to generate struct fault_env to be able to call some of the
> > > generic functions. So at this point I don't think there's much use in
> > > keeping these two structures separate. Just embed into struct vm_fault
> > > all that is needed to use it for both purposes.
> > > 
> > > Signed-off-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
> > 
> > I'm not necessary dislike this, but I remember Peter had objections before
> > when I proposed something similar.
> > 
> > Peter?
> 
> My objection was that it would be a layering violation. The 'filesystem'
> shouldn't know about page-tables, all it should do is return a page
> matching a specific offset.
> 
> So fault_env manages the core vm parts and has the page-table bits in,
> vm_fault manages the filesystem interface and gets us a page given an
> offset.
> 
> Now, I'm entirely out of touch wrt DAX, so I've not idea what that
> needs/wants.

Yeah, DAX does not have 'struct page' for its pages so it directly installs
PFNs in the page tables. As a result it needs to know about page tables and
stuff. Now I've abstracted knowledge about that into helper functions back
in mm/ but still we need to pass the information through the ->fault handler
into those helpers and vm_fault structure is simply natural for that.
So far we have tried to avoid that but the result was not pretty (special
return codes from DAX ->fault handlers essentially leaking information
about DAX internal locking into mm/ code to direct generic mm code to do
the right thing for DAX).

								Honza

> > > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > > index a92c8d73aeaf..657eb69eb87e 100644
> > > --- a/include/linux/mm.h
> > > +++ b/include/linux/mm.h
> > > @@ -292,10 +292,16 @@ extern pgprot_t protection_map[16];
> > >   * pgoff should be used in favour of virtual_address, if possible.
> > >   */
> > >  struct vm_fault {
> > > +	struct vm_area_struct *vma;	/* Target VMA */
> > >  	unsigned int flags;		/* FAULT_FLAG_xxx flags */
> > >  	gfp_t gfp_mask;			/* gfp mask to be used for allocations */
> > >  	pgoff_t pgoff;			/* Logical page offset based on vma */
> > > +	unsigned long address;		/* Faulting virtual address */
> > > +	void __user *virtual_address;	/* Faulting virtual address masked by
> > > +					 * PAGE_MASK */
> > > +	pmd_t *pmd;			/* Pointer to pmd entry matching
> > > +					 * the 'address'
> > > +					 */
> > >  
> > >  	struct page *cow_page;		/* Handler may choose to COW */
> > >  	struct page *page;		/* ->fault handlers should return a
> 
> Egads, horrific commenting style that :-)
-- 
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR

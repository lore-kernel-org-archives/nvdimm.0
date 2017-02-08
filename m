Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9A75682088
 for <linux-nvdimm@lists.01.org>; Wed,  8 Feb 2017 00:42:00 -0800 (PST)
Date: Wed, 8 Feb 2017 09:41:56 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] mm: replace FAULT_FLAG_SIZE with parameter to huge_fault
Message-ID: <20170208084156.GD26317@quack2.suse.cz>
References: <148615748258.43180.1690152053774975329.stgit@djiang5-desk3.ch.intel.com>
 <20170206143648.GA461@infradead.org>
 <CAPcyv4jHYR2-_SgD7a6ab5vWigYsDoSb7FZdTchP8Xg+BF-2yg@mail.gmail.com>
 <20170206172731.GA17515@infradead.org>
 <CAPcyv4hiwWebCT=qPccKqaQKAHydMYsg9+=pYh=SPkNzakLc1A@mail.gmail.com>
 <20170207084411.GA527@node.shutemov.name>
 <CAPcyv4h1LvbEqBi=F=BTtLrHHOvAH3MU2OBDs444-dzwNyupFQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4h1LvbEqBi=F=BTtLrHHOvAH3MU2OBDs444-dzwNyupFQ@mail.gmail.com>
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
Cc: linux-xfs@vger.kernel.org, Matthew Wilcox <mawilcox@microsoft.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Dave Hansen <dave.hansen@linux.intel.com>, Christoph Hellwig <hch@infradead.org>, Linux MM <linux-mm@kvack.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Jan Kara <jack@suse.com>, "Kirill A. Shutemov" <kirill@shutemov.name>, Andrew Morton <akpm@linux-foundation.org>, linux-ext4 <linux-ext4@vger.kernel.org>, Vlastimil Babka <vbabka@suse.cz>
List-ID: <linux-nvdimm@lists.01.org>

On Tue 07-02-17 08:56:56, Dan Williams wrote:
> On Tue, Feb 7, 2017 at 12:44 AM, Kirill A. Shutemov
> <kirill@shutemov.name> wrote:
> > On Mon, Feb 06, 2017 at 09:30:22AM -0800, Dan Williams wrote:
> >> On Mon, Feb 6, 2017 at 9:27 AM, Christoph Hellwig <hch@infradead.org> wrote:
> >> > On Mon, Feb 06, 2017 at 08:24:48AM -0800, Dan Williams wrote:
> >> >> > Also can be use this opportunity
> >> >> > to fold ->huge_fault into ->fault?
> >
> > BTW, for tmpfs we already use ->fault for both small and huge pages.
> > If ->fault returned THP, core mm look if it's possible to map the page as
> > huge in this particular VMA (due to size/alignment). If yes mm maps the
> > page with PMD, if not fallback to PTE.
> >
> > I think it would be nice to do the same for DAX: filesystem provides core
> > mm with largest page this part of file can be mapped with (base aligned
> > address + lenght for DAX) and core mm sort out the rest.
> 
> For DAX we would need plumb pfn_t into the core mm so that we have the
> PFN_DEV and PFN_MAP flags beyond the raw pfn.

So we can pass necessary information through struct vm_fault rather easily.
However due to DAX locking we cannot really "return" pfn for generic code
to install (we need to unlock radix tree locks after modifying page
tables). So if we want generic code to handle PFNs what needs to be done is
to teach finish_fault() to handle pfn_t which is passed to it and install
it in page tables.

Long term we could transition all page fault handlers (at least the
non-trivial ones) to using finish_fault() which would IMO make the code
flow easier to follow and export less of MM internals into drivers. However
there's so many fault handlers that I didn't have a good motivation to do
that yet.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

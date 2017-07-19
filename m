Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 44AFB21D0DE60
 for <linux-nvdimm@lists.01.org>; Wed, 19 Jul 2017 09:24:52 -0700 (PDT)
Date: Wed, 19 Jul 2017 10:26:45 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v3 3/5] dax: use common 4k zero page for dax mmap reads
Message-ID: <20170719162645.GA26445@linux.intel.com>
References: <20170628220152.28161-1-ross.zwisler@linux.intel.com>
 <20170628220152.28161-4-ross.zwisler@linux.intel.com>
 <20170719153314.GC15908@quack2.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170719153314.GC15908@quack2.suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: linux-xfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Matthew Wilcox <mawilcox@microsoft.com>, linux-doc@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>, Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>, Christoph Hellwig <hch@lst.de>, linux-mm@kvack.org, Dave Hansen <dave.hansen@intel.com>, Ingo Molnar <mingo@redhat.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jul 19, 2017 at 05:33:14PM +0200, Jan Kara wrote:
> On Wed 28-06-17 16:01:50, Ross Zwisler wrote:
> > Another major change is that we remove dax_pfn_mkwrite() from our fault
> > flow, and instead rely on the page fault itself to make the PTE dirty and
> > writeable.  The following description from the patch adding the
> > vm_insert_mixed_mkwrite() call explains this a little more:
> > 
> > ***
> >   To be able to use the common 4k zero page in DAX we need to have our PTE
> >   fault path look more like our PMD fault path where a PTE entry can be
> >   marked as dirty and writeable as it is first inserted, rather than
> >   waiting for a follow-up dax_pfn_mkwrite() => finish_mkwrite_fault() call.
> > 
> >   Right now we can rely on having a dax_pfn_mkwrite() call because we can
> >   distinguish between these two cases in do_wp_page():
> > 
> >   	case 1: 4k zero page => writable DAX storage
> >   	case 2: read-only DAX storage => writeable DAX storage
> > 
> >   This distinction is made by via vm_normal_page().  vm_normal_page()
> >   returns false for the common 4k zero page, though, just as it does for
> >   DAX ptes.  Instead of special casing the DAX + 4k zero page case, we will
> >   simplify our DAX PTE page fault sequence so that it matches our DAX PMD
> >   sequence, and get rid of dax_pfn_mkwrite() completely.
> > 
> >   This means that insert_pfn() needs to follow the lead of insert_pfn_pmd()
> >   and allow us to pass in a 'mkwrite' flag.  If 'mkwrite' is set
> >   insert_pfn() will do the work that was previously done by wp_page_reuse()
> >   as part of the dax_pfn_mkwrite() call path.
> > ***
> 
> Hum, thinking about this in context of this patch... So what if we have
> allocated storage, a process faults it read-only, we map it to page tables
> writeprotected. Then the process writes through mmap to the area - the code
> in handle_pte_fault() ends up in do_wp_page() if I'm reading it right.

Yep.

> Then, since we are missing ->pfn_mkwrite() handlers, the PTE will be marked
> writeable but radix tree entry stays clean - bug. Am I missing something?

I don't think we ever end up with a writeable PTE but with a clean radix tree
entry.  When we get the write fault we do a full fault through
dax_iomap_pte_fault() and dax_insert_mapping().

dax_insert_mapping() sets up the dirty radix tree entry via
dax_insert_mapping_entry() before it does anything with the page tables via
vm_insert_mixed_mkwrite().

So, this mkwrite fault path is exactly the path we would have taken if the
initial read to real storage hadn't happened, and we end up in the same end
state - with a dirty DAX radix tree entry and a writeable PTE.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

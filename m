Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4518521129985
 for <linux-nvdimm@lists.01.org>; Thu,  7 Jun 2018 07:38:41 -0700 (PDT)
Date: Thu, 7 Jun 2018 16:38:38 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: Question about Experimental of Filesystem DAX.
Message-ID: <20180607143838.6gdms3qlok6ikzrf@quack2.suse.cz>
References: <20180531112731.0CAC.E1E9C6FF@jp.fujitsu.com>
 <20180531150716.GA19764@linux.intel.com>
 <CAPcyv4jpffaM60tTdLTojhh0CDwcbVUdS8td7R6LKWM3bb15dw@mail.gmail.com>
 <20180531174636.GA7825@magnolia>
 <CAPcyv4gS1GCN9TFjngTmmHu83-uMgRpvvx842ZGnvxB3PbgU+Q@mail.gmail.com>
 <20180531230550.GN10363@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180531230550.GN10363@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>, "Darrick J. Wong" <darrick.wong@oracle.com>, NVDIMM-ML <linux-nvdimm@lists.01.org>, linux-xfs <linux-xfs@vger.kernel.org>, Yasunori Goto <y-goto@jp.fujitsu.com>, linux-ext4 <linux-ext4@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri 01-06-18 09:05:50, Dave Chinner wrote:
> On Thu, May 31, 2018 at 11:26:43AM -0700, Dan Williams wrote:
> > On Thu, May 31, 2018 at 10:46 AM, Darrick J. Wong
> > > The recent thread between Jan and Dan make me wonder if making mappings
> > > share struct pages is going to be a nightmare to add to the mm code,
> > > though...
> > 
> > It's going to be a bit messy because a singular page->mapping
> > association is fundamentally incompatible with DAX. Perhaps a linked
> > list of mapping "siblings"?
> 
> I'd much prefer the filesystem allocate/control the struct page that
> is inserted into mapping trees so we can have multiple struct pages
> pointing at the one physical page.  That way we can just insert
> these dynamic struct pages into the relevant mappings and it works
> the same way for both DAX and shared page cache pages.

Yes, that's one option but the overhead in terms of memory and CPU is
non-trivial and as Dan writes there are assumptions in MM code that
PFN<->struct page is 1:1 relationship (or possibly 1:0 as struct page can
be missing for certain types of pfns). But at this point I think the exact
data structure layout is not that important (whether there will be dynamic
struct pages or some other linkage). I think we first need to settle on
how responsibilities between MM and filesystems are going to be split.

> i.e. the filesystem knows they are shared physical blocks, the
> filesystem controls COW of physical blocks, the filesystem controls
> truncate/invalidation of physical blocks, the filesystem controls
> cache state of the physical blocks. So why are we designing
> infrastructure around the virtual memory and caching infrastructure
> that bypasses the layer that manages and arbitrates access to the
> physical storage?

I agree with this but let's see whether we are on the same page.  What MM
mostly cares about and in particular what Dan needs to solve is "given
struct page, give me all page tables that map this page". And it seems
completely fair to me to maintain such translation within MM code as the
filesystem generally does not care in too big detail about memory mappings
of files.  When something with the page is going happen (like breaking cow,
truncate, whatever), the filesystem just tells MM to invalidate all page
tables for the page and subsequent page faults will fill in updated
information - nothing new here.

Then there's a second slightly different question - and I suspect you are
speaking about that one - "given struct page, give me all radix trees
pointing to this page". This is more a filesystem caching question (even in
case of DAX, you can think of this as caching of inode + logical offset =>
physical block translations). Currently this translation is maintained by
page cache and again the filesystem is mostly ignorant of details of what
and when gets cached and just tells the MM when it should throw away the
cached information (through truncate/invalidate_inode_pages()).

With reflink and DAX / shared page cache these questions get more complex
to answer but in principle I don't see why the mapping from the struct page
to radix trees should not be maintained (with a help of the filesystem) in
generic code. Sure the interface now needs to be more flexible and in that
sense filesystems will be more in control what the page cache is doing -
e.g. ->readpage callback would probably need to be passed just inode +
logical offset and *the filesystem* will now need to find / allocate
approprite page, fill it up, and tell page cache this page is now caching
given offset in the file. And page cache will add this inode + offset to a
list of things caching this page. Do you agree or you had something
different in mind?

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

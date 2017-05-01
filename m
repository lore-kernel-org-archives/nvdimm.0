Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 706E021A04823
 for <linux-nvdimm@lists.01.org>; Mon,  1 May 2017 09:54:54 -0700 (PDT)
Date: Mon, 1 May 2017 10:54:51 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 1/2] dax: prevent invalidation of mapped DAX entries
Message-ID: <20170501165451.GB14837@linux.intel.com>
References: <20170420191446.GA21694@linux.intel.com>
 <20170421034437.4359-1-ross.zwisler@linux.intel.com>
 <20170425101041.GG2793@quack2.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170425101041.GG2793@quack2.suse.cz>
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
Cc: Latchesar Ionkov <lucho@ionkov.net>, Trond Myklebust <trond.myklebust@primarydata.com>, linux-mm@kvack.org, Christoph Hellwig <hch@lst.de>, linux-cifs@vger.kernel.org, Matthew Wilcox <mawilcox@microsoft.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Eric Van Hensbergen <ericvh@gmail.com>, linux-nvdimm@lists.01.org, Alexander Viro <viro@zeniv.linux.org.uk>, v9fs-developer@lists.sourceforge.net, Jens Axboe <axboe@kernel.dk>, linux-nfs@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>, samba-technical@lists.samba.org, linux-kernel@vger.kernel.org, Steve French <sfrench@samba.org>, Alexey Kuznetsov <kuznet@virtuozzo.com>, Johannes Weiner <hannes@cmpxchg.org>, linux-fsdevel@vger.kernel.org, Ron Minnich <rminnich@sandia.gov>, Andrew Morton <akpm@linux-foundation.org>, Anna Schumaker <anna.schumaker@netapp.com>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Apr 25, 2017 at 12:10:41PM +0200, Jan Kara wrote:
> On Thu 20-04-17 21:44:36, Ross Zwisler wrote:
> > dax_invalidate_mapping_entry() currently removes DAX exceptional entries
> > only if they are clean and unlocked.  This is done via:
> > 
> > invalidate_mapping_pages()
> >   invalidate_exceptional_entry()
> >     dax_invalidate_mapping_entry()
> > 
> > However, for page cache pages removed in invalidate_mapping_pages() there
> > is an additional criteria which is that the page must not be mapped.  This
> > is noted in the comments above invalidate_mapping_pages() and is checked in
> > invalidate_inode_page().
> > 
> > For DAX entries this means that we can can end up in a situation where a
> > DAX exceptional entry, either a huge zero page or a regular DAX entry,
> > could end up mapped but without an associated radix tree entry. This is
> > inconsistent with the rest of the DAX code and with what happens in the
> > page cache case.
> > 
> > We aren't able to unmap the DAX exceptional entry because according to its
> > comments invalidate_mapping_pages() isn't allowed to block, and
> > unmap_mapping_range() takes a write lock on the mapping->i_mmap_rwsem.
> > 
> > Since we essentially never have unmapped DAX entries to evict from the
> > radix tree, just remove dax_invalidate_mapping_entry().
> > 
> > Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> > Fixes: c6dcf52c23d2 ("mm: Invalidate DAX radix tree entries only if appropriate")
> > Reported-by: Jan Kara <jack@suse.cz>
> > Cc: <stable@vger.kernel.org>    [4.10+]
> 
> Just as a side note - we wouldn't really have to unmap the mapping range
> covered by the DAX exceptional entry. It would be enough to find out
> whether such range is mapped and bail out in that case. But that would
> still be pretty expensive for DAX - we'd have to do rmap walk similar as in
> dax_mapping_entry_mkclean() and IMHO it is not worth it. So I agree with
> what you did. You can add:
> 
> Reviewed-by: Jan Kara <jack@suse.cz>

Yep, that makes sense.  Thanks for the review.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

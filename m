From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 6/6] dax: Avoid page invalidation races and unnecessary
 radix tree traversals
Date: Mon, 3 Oct 2016 17:02:42 +0200
Message-ID: <20161003150242.GE14183@quack2.suse.cz>
References: <1474994615-29553-1-git-send-email-jack@suse.cz>
 <1474994615-29553-7-git-send-email-jack@suse.cz>
 <20160930085544.GD22381@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160930085544.GD22381-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

On Fri 30-09-16 01:55:44, Christoph Hellwig wrote:
> On Tue, Sep 27, 2016 at 06:43:35PM +0200, Jan Kara wrote:
> > Currently each filesystem (possibly through generic_file_direct_write()
> > or iomap_dax_rw()) takes care of invalidating page tables and evicting
> > hole pages from the radix tree when write(2) to the file happens. This
> > invalidation is only necessary when there is some block allocation
> > resulting from write(2). Furthermore in current place the invalidation
> > is racy wrt page fault instantiating a hole page just after we have
> > invalidated it.
> > 
> > So perform the page invalidation inside dax_do_io() where we can do it
> > only when really necessary and after blocks have been allocated so
> > nobody will be instantiating new hole pages anymore.
> > 
> > Signed-off-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
> 
> This looks fine with the comment from Dave addressed:
> 
> Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>

Thanks.

> > +				if (buffer_new(bh) &&
> > +				    inode->i_mapping->nrpages) {
> 
> Btw, it would be nice if the nrpages check could move into
> invalidate_inode_pages2_range instead of having to bother with it in
> the callers.

We cannot do that - someone can be possibly calling
invalidate_inode_pages2_range() to invalidate exceptional entries in the
given range (although I don't think there's currently any such caller). DAX
code currently needs it only to invalidate hole pages so that's why it can
do an optimization to call invalidate_inode_pages2_range() only when
mapping->nrpages > 0. But in general it would be a trap for
invalidate_inode_pages2_range() to work only if mapping->nrpages > 0...

								Honza
-- 
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR

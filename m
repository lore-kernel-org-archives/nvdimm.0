From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 4/6] xfs: Set BH_New for allocated DAX blocks in
 __xfs_get_blocks()
Date: Mon, 3 Oct 2016 16:44:43 +0200
Message-ID: <20161003144443.GB14183@quack2.suse.cz>
References: <1474994615-29553-1-git-send-email-jack@suse.cz>
 <1474994615-29553-5-git-send-email-jack@suse.cz>
 <20160927170118.GA15908@infradead.org>
 <20160927171707.GA30327@quack2.suse.cz>
 <20160928002255.GG9806@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160928002255.GG9806@dastard>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

On Wed 28-09-16 10:22:55, Dave Chinner wrote:
> On Tue, Sep 27, 2016 at 07:17:07PM +0200, Jan Kara wrote:
> > On Tue 27-09-16 10:01:18, Christoph Hellwig wrote:
> > > On Tue, Sep 27, 2016 at 06:43:33PM +0200, Jan Kara wrote:
> > > > So far we did not set BH_New for newly allocated blocks for DAX inodes
> > > > in __xfs_get_blocks() because we wanted to avoid zeroing done in generic
> > > > DAX code which was racy. Now the zeroing is gone so we can remove this
> > > > workaround and return BH_New for newly allocated blocks. DAX will use this
> > > > information to properly update mappings of the file.
> > > 
> > > __xfs_get_blocks isn't used by the DAX code any more.
> > > xfs_file_iomap_begin should already be doing the right thing for now.
> > 
> > OK, the changelog is stale but I actually took care to integrate this with
> > your iomap patches and for the new invalidation code in iomap_dax_actor()
> > to work we need this additional information...
> 
> So this applies to the iomap-4.9-dax branch in the XFS tree?

Yes.

> https://git.kernel.org/cgit/linux/kernel/git/dgc/linux-xfs.git/log/?h=iomap-4.9-dax
> 
> i.e. Do I need to merge the patchset with that branch?

This patch series cannot be immediately applied as it functionally depends
on the patches to allow safe clearing of dirty bits in DAX mappings.

								Honza
-- 
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR

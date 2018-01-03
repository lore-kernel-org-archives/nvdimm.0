Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D8B5D22280C30
 for <linux-nvdimm@lists.01.org>; Wed,  3 Jan 2018 08:04:51 -0800 (PST)
Date: Wed, 3 Jan 2018 17:09:53 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v4 12/18] xfs: use DEFINE_FSDAX_AOPS
Message-ID: <20180103160953.GN4911@quack2.suse.cz>
References: <151407695916.38751.2866053440557472361.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151407702457.38751.9874209243918617373.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20180102211539.GH4857@magnolia>
 <CAPcyv4hL4F0xDuFpWQ6ZEvtkMmhCa6V2oqr7bNFGeQQknNAf5w@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4hL4F0xDuFpWQ6ZEvtkMmhCa6V2oqr7bNFGeQQknNAf5w@mail.gmail.com>
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
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, "Darrick J. Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue 02-01-18 13:40:32, Dan Williams wrote:
> On Tue, Jan 2, 2018 at 1:15 PM, Darrick J. Wong <darrick.wong@oracle.com> wrote:
> > On Sat, Dec 23, 2017 at 04:57:04PM -0800, Dan Williams wrote:
> >> In preparation for the dax implementation to start associating dax pages
> >> to inodes via page->mapping, we need to provide a 'struct
> >> address_space_operations' instance for dax. Otherwise, direct-I/O
> >> triggers incorrect page cache assumptions and warnings.
> >>
> >> Cc: "Darrick J. Wong" <darrick.wong@oracle.com>
> >> Cc: linux-xfs@vger.kernel.org
> >> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> >> ---
> >>  fs/xfs/xfs_aops.c |    2 ++
> >>  fs/xfs/xfs_aops.h |    1 +
> >>  fs/xfs/xfs_iops.c |    5 ++++-
> >>  3 files changed, 7 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> >> index 21e2d70884e1..361915d53cef 100644
> >> --- a/fs/xfs/xfs_aops.c
> >> +++ b/fs/xfs/xfs_aops.c
> >> @@ -1492,3 +1492,5 @@ const struct address_space_operations xfs_address_space_operations = {
> >>       .is_partially_uptodate  = block_is_partially_uptodate,
> >>       .error_remove_page      = generic_error_remove_page,
> >>  };
> >> +
> >> +DEFINE_FSDAX_AOPS(xfs_dax_address_space_operations, xfs_vm_writepages);
> >
> > Hmm, if we ever re-enable changing the DAX flag on the fly, will
> > mapping->a_ops have to change dynamically too?
> >
> > How sure are we that we'll never have to set anything in the dax aops
> > other than ->writepages?
> >
> > (I also kinda wonder why not just make the callers savvy vs. a bunch of
> > dummy aops, but maybe that's been tried in a previous iteration?)
> 
> Matthew had similar feedback. I pushed back that I think more IS_DAX
> sprinkling increases the long term maintenance burden, but now that
> you've independently asked for the same thing I'm not opposed to
> changing my mind.
> 
> Either way this need to switch the address_space_operations, or
> synchronize against in-flight address_space_operations is going to
> complicate the "dynamic toggle the dax mode" feature.

ext4 already dynamically switches aops for journalled data vs
non-journalled data vs nodelalloc case. That being said I'm not quite sure
this is bug-free ;)

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

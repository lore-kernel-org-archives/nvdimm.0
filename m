Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3A42B2112B1DD
 for <linux-nvdimm@lists.01.org>; Wed, 12 Sep 2018 09:20:49 -0700 (PDT)
Date: Wed, 12 Sep 2018 18:20:46 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/2] ext4, dax: update dax check to skip journal inode
Message-ID: <20180912162046.GA23522@quack2.suse.cz>
References: <20180911154246.6844-1-toshi.kani@hpe.com>
 <20180911154246.6844-2-toshi.kani@hpe.com>
 <20180912092422.GA7782@quack2.suse.cz>
 <92faf51ac89e62dcd67e39cc66eef60966d1263c.camel@hpe.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <92faf51ac89e62dcd67e39cc66eef60966d1263c.camel@hpe.com>
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
To: "Kani, Toshi" <toshi.kani@hpe.com>
Cc: "jack@suse.cz" <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>, "tytso@mit.edu" <tytso@mit.edu>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed 12-09-18 15:47:12, Kani, Toshi wrote:
> On Wed, 2018-09-12 at 11:24 +0200, Jan Kara wrote:
> > On Tue 11-09-18 09:42:45, Toshi Kani wrote:
> > > Ext4 mount path calls ext4_iget() to obtain the journal inode.  This
> > > inode does not support DAX, and 'ext4_da_aops' needs to be set.  It
> > > currently works for the DAX mount case because ext4_iget() always set
> > > 'ext4_da_aops' to any regular files.
> > > 
> > >   ext4_fill_super
> > >     ext4_load_journal
> > >       ext4_get_journal_inode
> > >         ext4_iget
> > > 
> > > In preparation to fix ext4_iget() to set 'ext4_dax_aops' for DAX files,
> > > update ext4_should_use_dax() to return false for the journal inode.
> > > 
> > > Fixes: 5f0663bb4a64f588f0a2dd6d1be68d40f9af0086
> > > Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
> > > Cc: Jan Kara <jack@suse.cz>
> > > Cc: Dan Williams <dan.j.williams@intel.com>
> > > Cc: "Theodore Ts'o" <tytso@mit.edu>
> > > Cc: Andreas Dilger <adilger.kernel@dilger.ca>
> > 
> > The journal inode is similar to any other 'system' inode we have in ext4.
> > We don't really expect any of the address space operations to be called for
> > it because we don't use page cache with these inodes. Very similar
> > situation is with e.g. quota files. So to me it seems this patch is not
> > really necessary. Or did you observe any bad effects without this patch?
> 
> Yes, without this change, mount fails with the error below.  I believe
> .bmap operation in ext4_da_aops is necessary for this case.
> 
>   jbd2_journal_init_inode: Cannot locate journal superblock
>   EXT4-fs
> (pmem1): Could not load journal inode

Ah, OK, forgot about this. Then how about adding:
	.bmap                   = ext4_bmap,

to ext4_dax_aops? .bmap is completely fine for DAX inodes and there's no
reason to disallow it.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

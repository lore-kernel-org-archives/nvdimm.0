Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1CF3881EB2
 for <linux-nvdimm@lists.01.org>; Tue, 29 Nov 2016 00:53:09 -0800 (PST)
Date: Tue, 29 Nov 2016 09:53:03 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/6] dax: fix build breakage with ext4, dax and !iomap
Message-ID: <20161129085303.GA7550@quack2.suse.cz>
References: <1479926662-21718-1-git-send-email-ross.zwisler@linux.intel.com>
 <1479926662-21718-2-git-send-email-ross.zwisler@linux.intel.com>
 <20161124090239.GA24138@quack2.suse.cz>
 <20161128191504.GB6637@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20161128191504.GB6637@linux.intel.com>
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Jan Kara <jack@suse.cz>, Matthew Wilcox <mawilcox@microsoft.com>, Dave Chinner <david@fromorbit.com>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>, linux-mm@kvack.org, Ingo Molnar <mingo@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Mon 28-11-16 12:15:04, Ross Zwisler wrote:
> On Thu, Nov 24, 2016 at 10:02:39AM +0100, Jan Kara wrote:
> > On Wed 23-11-16 11:44:17, Ross Zwisler wrote:
> > > With the current Kconfig setup it is possible to have the following:
> > > 
> > > CONFIG_EXT4_FS=y
> > > CONFIG_FS_DAX=y
> > > CONFIG_FS_IOMAP=n	# this is in fs/Kconfig & isn't user accessible
> > > 
> > > With this config we get build failures in ext4_dax_fault() because the
> > > iomap functions in fs/dax.c are missing:
> > > 
> > > fs/built-in.o: In function `ext4_dax_fault':
> > > file.c:(.text+0x7f3ac): undefined reference to `dax_iomap_fault'
> > > file.c:(.text+0x7f404): undefined reference to `dax_iomap_fault'
> > > fs/built-in.o: In function `ext4_file_read_iter':
> > > file.c:(.text+0x7fc54): undefined reference to `dax_iomap_rw'
> > > fs/built-in.o: In function `ext4_file_write_iter':
> > > file.c:(.text+0x7fe9a): undefined reference to `dax_iomap_rw'
> > > file.c:(.text+0x7feed): undefined reference to `dax_iomap_rw'
> > > fs/built-in.o: In function `ext4_block_zero_page_range':
> > > inode.c:(.text+0x85c0d): undefined reference to `iomap_zero_range'
> > > 
> > > Now that the struct buffer_head based DAX fault paths and I/O path have
> > > been removed we really depend on iomap support being present for DAX.  Make
> > > this explicit by selecting FS_IOMAP if we compile in DAX support.
> > > 
> > > Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> > 
> > I've sent the same patch to Ted yesterday and he will probably queue it on
> > top of ext4 iomap patches. If it doesn't happen for some reason, feel free
> > to add:
> > 
> > Reviewed-by: Jan Kara <jack@suse.cz>
> 
> Cool, looks like Ted has pulled in your patch.
> 
> I think we still eventually want this patch because it cleans up our handling
> of FS_IOMAP.  With your patch we select it separately in both ext4 & ext2
> based on whether we include DAX, and we still have #ifdefs in fs/dax.c for
> FS_IOMAP.

Actually, based on Dave's request I've also sent Ted updated version which
did select FS_IOMAP in CONFIG_DAX section. However Ted didn't pull that
patch (yet?). Anyway, I don't care whose patch gets merged, I just wanted
to notify you of possible conflict.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

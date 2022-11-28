Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64718AD27
	for <nvdimm@lists.linux.dev>; Mon, 28 Nov 2022 23:08:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16DA4C433D6;
	Mon, 28 Nov 2022 23:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1669676896;
	bh=xmDWkkpCiCrDtqwlAEG/iOC4CyDHvYHC5ggXKZgViCM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bIzVbNaLrMmkKLiNRUOdJTh/0UY4Krs/3gxXj/U/B1iuRbecq5DfsXfE4hSCw/g/h
	 m+PuEcldMLu337SC1BMCgqhpTLMm2z/tYMQ/3egiYlnbeUQ6HXtzBeECooF9j0s8jP
	 bBIVvuzxLK0g53g67vaE9ihZOpTcuUmB3Qbq0h1YSylIMr6V0Vak+NbgiIa4or44nR
	 Budu5DByuiLkmGTG4sxeW/l38uXgMRFDAyMoio/vz4xgx5XqSUTQkS7awGet92y4lp
	 pgel+vNEERy2EjPfJsUKVhsq1BrqICiD8afXQTCzzXQE9J6EhNnyR6oZIlMdsKXWjw
	 vuFqeQGEDXOBw==
Date: Mon, 28 Nov 2022 15:08:15 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	david@fromorbit.com, dan.j.williams@intel.com
Subject: Re: [PATCH 0/2] fsdax,xfs: fix warning messages
Message-ID: <Y4U/XxlTx6SoELV0@magnolia>
References: <1669301694-16-1-git-send-email-ruansy.fnst@fujitsu.com>
 <Y4OuntOVjId9FLzL@magnolia>
 <113e8b0d-7349-94ac-c017-3624c34fe73b@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <113e8b0d-7349-94ac-c017-3624c34fe73b@fujitsu.com>

On Mon, Nov 28, 2022 at 10:16:23AM +0800, Shiyang Ruan wrote:
> 
> 
> 在 2022/11/28 2:38, Darrick J. Wong 写道:
> > On Thu, Nov 24, 2022 at 02:54:52PM +0000, Shiyang Ruan wrote:
> > > Many testcases failed in dax+reflink mode with warning message in dmesg.
> > > This also effects dax+noreflink mode if we run the test after a
> > > dax+reflink test.  So, the most urgent thing is solving the warning
> > > messages.
> > > 
> > > Patch 1 fixes some mistakes and adds handling of CoW cases not
> > > previously considered (srcmap is HOLE or UNWRITTEN).
> > > Patch 2 adds the implementation of unshare for fsdax.
> > > 
> > > With these fixes, most warning messages in dax_associate_entry() are
> > > gone.  But honestly, generic/388 will randomly failed with the warning.
> > > The case shutdown the xfs when fsstress is running, and do it for many
> > > times.  I think the reason is that dax pages in use are not able to be
> > > invalidated in time when fs is shutdown.  The next time dax page to be
> > > associated, it still remains the mapping value set last time.  I'll keep
> > > on solving it.
> > > 
> > > The warning message in dax_writeback_one() can also be fixed because of
> > > the dax unshare.
> > 
> > This cuts down the amount of test failures quite a bit, but I think
> > you're still missing a piece or two -- namely the part that refuses to
> > enable S_DAX mode on a reflinked file when the inode is being loaded
> > from disk.  However, thank you for fixing dax.c, because that was the
> > part I couldn't figure out at all. :)
> 
> I didn't include it[1] in this patchset...
> 
> [1] https://lore.kernel.org/linux-xfs/1663234002-17-1-git-send-email-ruansy.fnst@fujitsu.com/

Oh, ok.  I'll pull that one in.  All the remaining test failures seem to
be related to inode flag states or tests that trip over the lack of
delalloc on dax+reflink files.

--D

> 
> --
> Thanks,
> Ruan.
> 
> > 
> > --D
> > 
> > > 
> > > Shiyang Ruan (2):
> > >    fsdax,xfs: fix warning messages at dax_[dis]associate_entry()
> > >    fsdax,xfs: port unshare to fsdax
> > > 
> > >   fs/dax.c             | 166 ++++++++++++++++++++++++++++++-------------
> > >   fs/xfs/xfs_iomap.c   |   6 +-
> > >   fs/xfs/xfs_reflink.c |   8 ++-
> > >   include/linux/dax.h  |   2 +
> > >   4 files changed, 129 insertions(+), 53 deletions(-)
> > > 
> > > -- 
> > > 2.38.1
> > > 

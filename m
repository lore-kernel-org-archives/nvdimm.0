Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBE2F17F
	for <nvdimm@lists.linux.dev>; Mon,  9 Aug 2021 06:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=7FmgXzovyc5phIOk3kLbdD7QAz86Q3F4B8c/fhn138E=; b=AQm6rpTIzS8vUg89mB+/TNq77+
	u8XQ7o6eWID+fuPGA9NElU7fOwmtfywI5W/1l7fljBEy6Z3wXRepnzRUUS6DznuzZuXJMfDBK4aDg
	NiWZ7f1QNm/gSEi1b3btLVx3dCWeL7UC06aeNgmk39fWmM9uO9JJSQ0VfQLWP17gamqMenHBssPH4
	uR6IJwWd2qF1K7Y1s6b6IrG1YC3ZbpCQPlZil3ldKOLbmhCgXSp0gl208oG6PNckpAToZUYiaBwXw
	XcK6A7XsadRIN4YZV7HZMDUEhl9HlMaPLtDfnrisObaAiYzUv45U+KY9Edp3UQM+bVd/LzKIbnVRA
	t9n5nBHg==;
Received: from [2a02:1205:5023:1f80:c068:bd3d:78b3:7d37] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mCyWj-00AgKi-5E; Mon, 09 Aug 2021 06:12:53 +0000
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Shiyang Ruan <ruansy.fnst@fujitsu.com>,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	nvdimm@lists.linux.dev,
	cluster-devel@redhat.com
Subject: switch iomap to an iterator model v2
Date: Mon,  9 Aug 2021 08:12:14 +0200
Message-Id: <20210809061244.1196573-1-hch@lst.de>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

this series replies the existing callback-based iomap_apply to an iter based
model.  The prime aim here is to simply the DAX reflink support, which
requires iterating through two inodes, something that is rather painful
with the apply model.  It also helps to kill an indirect call per segment
as-is.  Compared to the earlier patchset from Matthew Wilcox that this
series is based upon it does not eliminate all indirect calls, but as the
upside it does not change the file systems at all (except for the btrfs
and gfs2 hooks which have slight prototype changes).


Changes since v1:
 - rebased to the lastes iomap-for-next tree
 - rename iter.c to core.c
 - turn iomap_iter.processed into a s64
 - rename a few variables
 - error out instead of just warn when a loop processed too much data
 - fix the readpage iter return value for inline data
 - better document the iomap_iter() calling conventions

Diffstat:
 b/fs/btrfs/inode.c       |    5 
 b/fs/buffer.c            |    4 
 b/fs/dax.c               |  578 ++++++++++++++++++++++-------------------------
 b/fs/gfs2/bmap.c         |    5 
 b/fs/internal.h          |    4 
 b/fs/iomap/Makefile      |    2 
 b/fs/iomap/buffered-io.c |  359 +++++++++++++----------------
 b/fs/iomap/core.c        |   79 ++++++
 b/fs/iomap/direct-io.c   |  164 ++++++-------
 b/fs/iomap/fiemap.c      |  101 +++-----
 b/fs/iomap/seek.c        |   98 ++++---
 b/fs/iomap/swapfile.c    |   38 +--
 b/fs/iomap/trace.h       |   35 +-
 b/include/linux/iomap.h  |   77 ++++--
 fs/iomap/apply.c         |   99 --------
 15 files changed, 799 insertions(+), 849 deletions(-)

Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79EEE168
	for <nvdimm@lists.linux.dev>; Mon, 19 Jul 2021 10:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=TAHG7VmPKhvLBzTtUSd5kmBCY111U0coTJMAcPHs2RA=; b=aocE/jzYVHDQJvz4PZL+Yq9Epo
	WzSCIzDH8zSuPHf5Ft3nT6ONISSTY0PVkr8o/taPu97PAWzAOgTVBHAizYz0fRIJ7GL8pmyONdf2w
	tQvVYLYbrUbB7ebAZ6MdDuKkTbqoUQhgsYLQuZk01sA0n0ggtuEqb1NZRx5gAgFqk2dCr6DzSTepg
	haDqyKJNFEK5yQEtBMmWHIxx5CpW+8VhPT/ZD8XL5qJg5jfYgnGDNyjJS+V1ikPQ6S+KfLLOsa2+d
	CVSsoySkdwQYFL1tIY/Y67/b/xvdo2/aEh90Yh2JaBzTYss0QSiv7GXazanUy681YVHbNTBR7iAEX
	STgOyjxQ==;
Received: from [2001:4bb8:193:7660:d2a4:8d57:2e55:21d0] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1m5QcL-006kSC-GM; Mon, 19 Jul 2021 10:35:26 +0000
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
Subject: RFC: switch iomap to an iterator model
Date: Mon, 19 Jul 2021 12:34:53 +0200
Message-Id: <20210719103520.495450-1-hch@lst.de>
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

This passes basic testing on XFS for block based file systems.  The DAX
changes are entirely untested as I haven't managed to get pmem work in
recent qemu.

Diffstat:
 b/fs/btrfs/inode.c       |    5 
 b/fs/buffer.c            |    4 
 b/fs/dax.c               |  578 ++++++++++++++++++++++-------------------------
 b/fs/gfs2/bmap.c         |    5 
 b/fs/internal.h          |    4 
 b/fs/iomap/Makefile      |    2 
 b/fs/iomap/buffered-io.c |  344 +++++++++++++--------------
 b/fs/iomap/direct-io.c   |  162 ++++++-------
 b/fs/iomap/fiemap.c      |  101 +++-----
 b/fs/iomap/iter.c        |   74 ++++++
 b/fs/iomap/seek.c        |   88 +++----
 b/fs/iomap/swapfile.c    |   38 +--
 b/fs/iomap/trace.h       |   35 +-
 b/include/linux/iomap.h  |   73 ++++-
 fs/iomap/apply.c         |   99 --------
 15 files changed, 777 insertions(+), 835 deletions(-)

Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C52F3FC4
	for <nvdimm@lists.linux.dev>; Mon, 23 Aug 2021 12:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=sfkVfOgG74aYLnhMI+d3SuhRKy5IdFLySI4HRvR755E=; b=v+RNWWQzXpfrQxjL0zkwnUqwFY
	LsJIrmvxJVdeDYpfG0kSJyKMJQ+xwYyHOAWdBKcWRRyw4g8WiaUOqY61UdYzorc9HoQqN6Sh7u9HD
	Di/+ale2RACtQ+b68boj108W8ueu4lJhNolGERvfTDd1nv3ICQt/YAPfujeliAu26gdmnZ6lka3kd
	dNT562U7MROIVArLLmqTNJuC24A3CoxxIFiUb5tdBvlS24wG4XFtMREyjE6Ib0mzODnAyLOIVd+yr
	7fu5bqNRTfmxHN5/8CQVZyCQ2eXDcCbkA34QG8SSXcgarm6r0GZByGK2C2wAks73XryoXcO4RSD5K
	oFSNxIew==;
Received: from [2001:4bb8:193:fd10:c6e8:3c08:6f8b:cbf0] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mI9Aa-009izg-W5; Mon, 23 Aug 2021 12:35:27 +0000
From: Christoph Hellwig <hch@lst.de>
To: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>
Cc: Mike Snitzer <snitzer@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	linux-xfs@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
Subject: dax_supported() related cleanups
Date: Mon, 23 Aug 2021 14:35:07 +0200
Message-Id: <20210823123516.969486-1-hch@lst.de>
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

this series first clarifies how to use fsdax in the Kconfig help a bit,
and te untangles the code path that checks if fsdax is supported.

Diffstat
 drivers/dax/super.c   |  191 +++++++++++++++++++-------------------------------
 drivers/md/dm-table.c |    9 --
 drivers/md/dm.c       |    2 
 fs/Kconfig            |   17 +++-
 fs/ext2/super.c       |    3 
 fs/ext4/super.c       |    3 
 fs/xfs/xfs_super.c    |   16 +++-
 include/linux/dax.h   |   41 +---------
 8 files changed, 113 insertions(+), 169 deletions(-)

Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 346AF3FCB
	for <nvdimm@lists.linux.dev>; Wed, 22 Sep 2021 17:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=ARgc5BTNEQt9FG8904QxPv30VGpYKOfYo9r3bA9lDKg=; b=WlNfNytjOVO7nSmbZow+kLL5Bv
	QPQCXq6UGc8G/xHRilX5R+ZKUS3aUd5BN4wUMDXyVmSCGgVflBgsJtunv2ZBqe3yDium0DTkrLDiV
	Zn30Roqv3z5VvhpTS0DKThiJQ+oUjF8sq4YPDPedTh+IcsTa/L5kYrHXvyCswlo074FOdjtqzAq/x
	jJ5JAPTRsmJSVTDql+KqOD7FBVqZoxzWli44Ta5ZW/J+IIr6wVNR9LqRJDUc/lJKO+Og2a3BWhWmN
	3BnxXzhifhAKuzy3W+rL8B/QNHTo0urx5ynSL/omjsIM5speYb3PRLxlLeflxcyJ+LHGiW6gF3AQ4
	+pmHFLMA==;
Received: from [2001:4bb8:184:72db:3a8e:1992:6715:6960] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mT68e-004zdc-Mh; Wed, 22 Sep 2021 17:34:58 +0000
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
Subject: dax_supported() related cleanups v2
Date: Wed, 22 Sep 2021 19:34:28 +0200
Message-Id: <20210922173431.2454024-1-hch@lst.de>
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
and then untangles the code path that checks if fsdax is supported.

Changes since v1:
 - improve the FS_DAX Kconfig help text further
 - write a proper commit log for a patch missing it

Diffstat
 drivers/dax/super.c   |  191 +++++++++++++++++++-------------------------------
 drivers/md/dm-table.c |    9 --
 drivers/md/dm.c       |    2 
 fs/Kconfig            |   21 ++++-
 fs/ext2/super.c       |    3 
 fs/ext4/super.c       |    3 
 fs/xfs/xfs_super.c    |   16 +++-
 include/linux/dax.h   |   41 +---------
 8 files changed, 117 insertions(+), 169 deletions(-)

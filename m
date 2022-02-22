Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30F2C66A7
	for <nvdimm@lists.linux.dev>; Tue, 22 Feb 2022 15:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=YyVH4oj53flKDl4o6G8llll8rWu5K49Wopw1JMTA1xQ=; b=O6ch8zKeyvbAZ1fRjY4PD5TW8M
	Et6jgk5KwIVYitQ2YzDJd9NJHtVLNaZkCe0EcCizD4CMzxzO+3jbAQHyQ97oNoLj6afPZBg20jIJI
	wI2bnoMAOQEK4yCBOB0FSlU4lTpisJX21uvhXCBOf0MRdq4JV7ZVryJXM+zBrVEHg3Ip6RJ+gRbkb
	Kk3hsR3x48wAOFyj3rZqpBddrw73R4G3Kxj3eok45Kum7Lj2a/7rtDOUCm9kaUSY0NnHbQiBt+umG
	LNK0C7a5sHMwpaZLLfj4+0Vxkk9Av1gjkUPYAQPpvyFzzY8zKJhvaBMn8w1aZwln0lQKqdWGPi+22
	U1HayEWw==;
Received: from [2001:4bb8:198:f8fc:c22a:ebfc:be8d:63c2] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nMXSI-00APnc-Q7; Tue, 22 Feb 2022 15:51:59 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Chris Zankel <chris@zankel.net>,
	Max Filippov <jcmvbkbc@gmail.com>,
	Justin Sanders <justin@coraid.com>,
	Philipp Reisner <philipp.reisner@linbit.com>,
	Lars Ellenberg <lars.ellenberg@linbit.com>,
	Denis Efremov <efremov@linux.com>,
	Minchan Kim <minchan@kernel.org>,
	Nitin Gupta <ngupta@vflare.org>,
	Coly Li <colyli@suse.de>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	linux-xtensa@linux-xtensa.org,
	linux-block@vger.kernel.org,
	drbd-dev@lists.linbit.com,
	linux-bcache@vger.kernel.org,
	nvdimm@lists.linux.dev
Subject: remove opencoded kmap of bio_vecs
Date: Tue, 22 Feb 2022 16:51:46 +0100
Message-Id: <20220222155156.597597-1-hch@lst.de>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

this series replaces various open coded kmaps of bio_vecs with higher
level helpers that use kmap_local_page underneath.

Diffstat:
 arch/xtensa/platforms/iss/simdisk.c |    4 ++--
 drivers/block/aoe/aoecmd.c          |    2 +-
 drivers/block/drbd/drbd_receiver.c  |    4 ++--
 drivers/block/drbd/drbd_worker.c    |    6 +++---
 drivers/block/floppy.c              |    6 ++----
 drivers/block/zram/zram_drv.c       |    9 ++-------
 drivers/md/bcache/request.c         |    4 ++--
 drivers/nvdimm/blk.c                |    7 +++----
 drivers/nvdimm/btt.c                |   10 ++++------
 9 files changed, 21 insertions(+), 31 deletions(-)

Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD19B72
	for <nvdimm@lists.linux.dev>; Mon, 20 Sep 2021 07:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=4O4s/JWEZYcY5KBbue3nA6xC3MQonW3QFLz1xJABeGA=; b=slC+zQ9npkKY6BSLM0o6g3aEj2
	sr48MLRU95ICGw6vD3MLidPL3KvuO363ouICvGp/nM7imifETBShyvOpfp89Q4v8r0hy8Nsf/8U/O
	0pvQ0RjYrNbBe7bVwNvfYSS8l7cbxqPl/jSXSdnPGP0fBWlJVfVjq5PKx2t3879O0kFMWRTljycA7
	Aa2JJ9OwepfZOdBcsT78FCGntTIVwk91pd2dlbFJ/ggoPabADwcGaqswgvG8pfsUI67q54ESuvT26
	eZbH+G8niA8BnakXqIcq0bllDXIUIv0dhrEEE0YkXwfhuSbLdVgDlx/m2K0omDkkkJyikDK09IT7P
	m5ikyeyQ==;
Received: from 213-225-6-64.nat.highway.a1.net ([213.225.6.64] helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mSDjr-002SWZ-F6; Mon, 20 Sep 2021 07:29:29 +0000
From: Christoph Hellwig <hch@lst.de>
To: Dan Williams <dan.j.williams@intel.com>,
	Jens Axboe <axboe@kernel.dk>
Cc: Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	linux-block@vger.kernel.org,
	nvdimm@lists.linux.dev
Subject: [PATCH 3/3] block: warn if ->groups is set when calling add_disk
Date: Mon, 20 Sep 2021 09:27:26 +0200
Message-Id: <20210920072726.1159572-4-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210920072726.1159572-1-hch@lst.de>
References: <20210920072726.1159572-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html

The proper API is to pass the groups to device_add_disk, but the code
used to also allow groups being set before calling *add_disk.  Warn
about that but keep the group pointer intact for now so that it can
be removed again after a grace period.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Fixes: 52b85909f85d ("block: fold register_disk into device_add_disk")
---
 block/genhd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/block/genhd.c b/block/genhd.c
index 7b6e5e1cf9564..409cf608cc5bd 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -439,7 +439,8 @@ int device_add_disk(struct device *parent, struct gendisk *disk,
 	dev_set_uevent_suppress(ddev, 1);
 
 	ddev->parent = parent;
-	ddev->groups = groups;
+	if (!WARN_ON_ONCE(ddev->groups))
+		ddev->groups = groups;
 	dev_set_name(ddev, "%s", disk->disk_name);
 	if (!(disk->flags & GENHD_FL_HIDDEN))
 		ddev->devt = MKDEV(disk->major, disk->first_minor);
-- 
2.30.2


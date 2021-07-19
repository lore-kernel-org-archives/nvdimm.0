Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A30E62FB0
	for <nvdimm@lists.linux.dev>; Mon, 19 Jul 2021 10:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=9dugrQS9wO0J3tZQfy/Jy6X12BDoYcovWE9tyiETJ9E=; b=ayoYO4G0ijhs8hVHr/WIOFh6Uv
	FBLG+bYsXHyt5jcPZ2bu2krBztVDXu26GjI7vucwlBaQBt31MilK/X/QKeIqFY5LB10ObDVRrScjP
	3q/UTdcz06WdiCcYKgOlSG0/XusKeSgEGiEmkfrBzU8jFXnNruxtq8+B+MGHoQLpnP5s5XYI7w9aD
	5iXuGg7iIWocM/Hj28KqWF1iSMutxmM4PsqX6r87H4qERRNWbxU0/06cUnhESCQmvhkx8kHcEBt/s
	rXDu+7nq1nXZGfPnqWpmWJuBNpccYsMmob9+C3GYBHSTVWRJasIzR7rpdkAWQOCSqoOrkC/+q8ik0
	zMyjXK4A==;
Received: from [2001:4bb8:193:7660:d2a4:8d57:2e55:21d0] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1m5QhL-006klu-F6; Mon, 19 Jul 2021 10:41:00 +0000
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
Subject: [PATCH 06/27] iomap: mark the iomap argument to iomap_read_inline_data const
Date: Mon, 19 Jul 2021 12:34:59 +0200
Message-Id: <20210719103520.495450-7-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210719103520.495450-1-hch@lst.de>
References: <20210719103520.495450-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html

iomap_read_inline_data never modifies the passed in iomap, so mark
it const.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/iomap/buffered-io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 75310f6fcf8401..e47380259cf7e1 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -207,7 +207,7 @@ struct iomap_readpage_ctx {
 
 static void
 iomap_read_inline_data(struct inode *inode, struct page *page,
-		struct iomap *iomap)
+		const struct iomap *iomap)
 {
 	size_t size = i_size_read(inode);
 	void *addr;
-- 
2.30.2


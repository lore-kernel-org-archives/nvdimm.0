Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B10472
	for <nvdimm@lists.linux.dev>; Mon, 29 Nov 2021 10:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=ZI8fdJdAHvC2/8mTH+7pB1lSA27KsqbHwcacuu5ur0Y=; b=ONr3+Hqhtmlw3mDkcAWneercGq
	rt6I893UuowUX/zXeALoSjQCy/x0sEwKWPAtbKgul2jhM//AAJ50ZfaX5683gI4sBwbXMSyAATkT/
	SNX+V/PjIZmsMIGQhQTl/xuRKuNf3I55iQy4OK3aEHxl0L159LvqS3w0Iklm5jB0Lh5kMAtlDQfBc
	7nkMbOC8pA6bEgwfn/eSwOZplpeGO13m5ytFJAIwNED0TUpotITZACvM0X9kWZoPw2kDHf+8w+1mX
	gziZR5lkN5mnJL+xEkocYcOZDVSJXOxruOgnTe7Cm3Q5xPbByWN7PeYVnTsIHbOOCVv7dQfA0yJzt
	nYhtSfpw==;
Received: from [2001:4bb8:184:4a23:724a:c057:c7bf:4643] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mrdng-0073O9-Bb; Mon, 29 Nov 2021 10:22:21 +0000
From: Christoph Hellwig <hch@lst.de>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Mike Snitzer <snitzer@redhat.com>,
	Ira Weiny <ira.weiny@intel.com>,
	dm-devel@redhat.com,
	linux-xfs@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-s390@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-erofs@lists.ozlabs.org,
	linux-ext4@vger.kernel.org,
	virtualization@lists.linux-foundation.org,
	"Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH 12/29] fsdax: remove a pointless __force cast in copy_cow_page_dax
Date: Mon, 29 Nov 2021 11:21:46 +0100
Message-Id: <20211129102203.2243509-13-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211129102203.2243509-1-hch@lst.de>
References: <20211129102203.2243509-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html

Despite its name copy_user_page expected kernel addresses, which is what
we already have.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/dax.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/dax.c b/fs/dax.c
index 4e3e5a283a916..73bd1439d8089 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -728,7 +728,7 @@ static int copy_cow_page_dax(struct block_device *bdev, struct dax_device *dax_d
 		return rc;
 	}
 	vto = kmap_atomic(to);
-	copy_user_page(vto, (void __force *)kaddr, vaddr, to);
+	copy_user_page(vto, kaddr, vaddr, to);
 	kunmap_atomic(vto);
 	dax_read_unlock(id);
 	return 0;
-- 
2.30.2


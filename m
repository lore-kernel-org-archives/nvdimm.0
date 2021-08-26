Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 919B13FC0
	for <nvdimm@lists.linux.dev>; Thu, 26 Aug 2021 13:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=gkQP9uUaGfS5wkgQnCeApEQiDrXMIWuavFG8HhovtVM=; b=YELdD3RiXQmIZRDAWJG6StBpiW
	8V8yP1Pv4+xmDpG2E0lNxgeQVUcF8r1bZUK3PKxOMkl+JoG7pViWpazRfEWyh1Dd8Alcl5lu3eFxK
	omCf4HTx5zmokNJEEJBiMLTzY8S1h7HjYcGxDlURxr9dXmrwM76ga0XO064FxQsJZg1uU858pPrkf
	ZKFur1VoreyfW3nGnHuCvCxW3SXVmbRiDrHrjwNUZUsrDRVsklWvmaUI/OuChxfvRbQ/xrsohUEB4
	eHoSSlPMjpIjQZDE6kAzD+aUk2EdEvW8xW31RVMNr6h3Z6NXZvlzgCfsP1HeksIyxiUTwnEKjHJ0i
	Owm2hheg==;
Received: from [2001:4bb8:193:fd10:d9d9:6c15:481b:99c4] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mJFra-00DM3M-3A; Thu, 26 Aug 2021 13:56:26 +0000
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
Subject: [PATCH 1/9] fsdax: improve the FS_DAX Kconfig description and help text
Date: Thu, 26 Aug 2021 15:55:02 +0200
Message-Id: <20210826135510.6293-2-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210826135510.6293-1-hch@lst.de>
References: <20210826135510.6293-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html

Rename the main option text to clarify it is for file system access,
and add a bit of text that explains how to actually switch a nvdimm
to a fsdax capable state.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/Kconfig | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/fs/Kconfig b/fs/Kconfig
index a7749c126b8e..bd21535a7620 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -43,7 +43,7 @@ source "fs/f2fs/Kconfig"
 source "fs/zonefs/Kconfig"
 
 config FS_DAX
-	bool "Direct Access (DAX) support"
+	bool "File system based Direct Access (DAX) support"
 	depends on MMU
 	depends on !(ARM || MIPS || SPARC)
 	select DEV_PAGEMAP_OPS if (ZONE_DEVICE && !FS_DAX_LIMITED)
@@ -53,8 +53,23 @@ config FS_DAX
 	  Direct Access (DAX) can be used on memory-backed block devices.
 	  If the block device supports DAX and the filesystem supports DAX,
 	  then you can avoid using the pagecache to buffer I/Os.  Turning
-	  on this option will compile in support for DAX; you will need to
-	  mount the filesystem using the -o dax option.
+	  on this option will compile in support for DAX.
+
+	  For a DAX device to support file system access it needs to have
+	  struct pages.  For the nfit based NVDIMMs this can be enabled
+	  using the ndctl utility:
+
+		# ndctl create-namespace --force --reconfig=namespace0.0 \
+			--mode=fsdax --map=mem
+
+	  See the 'create-namespace' man page for details on the overhead of
+	  --map=mem:
+	  https://docs.pmem.io/ndctl-user-guide/ndctl-man-pages/ndctl-create-namespace
+
+          For ndctl to work CONFIG_DEV_DAX needs to be enabled as well. For most
+	  file systems DAX support needs to be manually enabled globally or
+	  per-inode using a mount option as well.  See the file documentation in
+	  Documentation/filesystems/dax.rst for details.
 
 	  If you do not have a block device that is capable of using this,
 	  or if unsure, say N.  Saying Y will increase the size of the kernel
-- 
2.30.2


Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794344528;
	b=Y0KH3MtN7EKN7G7Nhw4NyWKHJ71le6gReIjNPrJ2/9gTNbYd6FUC6gbRSXeGjOj3D6Bx
	 ZfjMvFUGaO39yU+5WoXtxkk0ZJbEzizpoWZJRE0jR7Dgc0IUA0VZSc7Ist5IVA/U3FiXg
	 qJtKRECB4xqhW8VjOvJ9rCnfhm5qw+SdSgi0057XYeLzvqY7PEcUUUd/cbl0Oj3/qNqXY
	 2FzzNUbT4YqisDwaPgj6656lIGeUGV6kJxf9dNLmSsPw7szcOLQfdo7qs6V2EdZI47Bkp
	 64QAnDvhcnmbJAjTEpQEJJoPl3jhI/H6QcLadkxiDNJ7BbDGJfVlDfwYYwodGo6bUfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794344528;
	h=Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=TYw+lTDw9uZUPVqkSCGZ4s7jhz0x5pD5eMZjD1rHixE=;
	b=ryviXmyibKtB3Hh4TfypNislBJgzglgt+0VJmUdfggqyyl4oB0JLABOtEDPdvSJFdH37
	 kUGIe/TdyQHw4Urj/FGcsGodc4TDIn8G0T0czWwuPfJRvAw2yh3pDepIanCFACNuT0la6
	 W5bORA8nSr3w7ctQhFH4cMWj83hl0IAOWU8u0R6zmlgfvM7rTOxiMxTH+M5umeJXRGRJh
	 mu8mvddcjVg6AoNOURbSzxReIT13aRox8WPCOatVGrBxX5Qmk8CsTQbMucqNHmtvr+5Is
	 kdhviFKb45gdIQ8OPEMTD36ghHO1nopq3uKP8geO/1ZlWtZulCwgH4eu5N+QOXxFqmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A9E7606A320;
	Tue, 10 Nov 2026 21:02:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38C901F008A4;
	Tue, 10 Nov 2026 21:02:08 +0000 (UTC)
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-crypto@vger.kernel.org,
	dmaengine@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Alison Schofield <alison.schofield@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Jonathan Cameron <jic23@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Frank Li <Frank.Li@kernel.org>,
	Alistair Popple <apopple@nvidia.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH v2] MAINTAINERS: Update CXL, NVDIMM, DAX, and others for djbw
Date: Tue, 10 Nov 2026 14:01:52 -0700
Message-ID: <20261110210152.3494345-1-dave.jiang@intel.com>
X-Mailer: git-send-email 2.54.0
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Dan is no longer with us. Removing entries in MAINTAINERS to prevent
people from keep emailing his address.

Frank will take over for async_tx until the feature is removed.

Alistair will take over on fsdax with Alison continue to wrangle patches
for DAX overall patches.

Cc: Alison Schofield <alison.schofield@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Jonathan Cameron <jic23@kernel.org>
Cc: Vinod Koul <vkoul@kernel.org>
Cc: Frank Li <Frank.Li@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
Acked-by: Davidlohr Bueso <dave@stgolabs.net>
Acked-by: Vishal Verma <vishal.l.verma@intel.com>
Acked-by: Alison Schofield <alison.schofield@intel.com>
Acked-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>

---

v2:
- Add Frank as reviewer for async_tx.
- Alistair has been working on fsdax and agreed to be maintainer.
---
 MAINTAINERS | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 93abbb315065..58bdd5eff5c2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4294,7 +4294,7 @@ S:	Maintained
 F:	crypto/rsa*
 
 ASYNCHRONOUS TRANSFERS/TRANSFORMS (IOAT) API
-R:	Dan Williams <djbw@kernel.org>
+R:	Frank Li <Frank.li@oss.nxp.com>
 S:	Odd fixes
 W:	http://sourceforge.net/projects/xscaleiop
 F:	Documentation/crypto/async-tx-api.rst
@@ -6726,7 +6726,6 @@ M:	Jonathan Cameron <jic23@kernel.org>
 M:	Dave Jiang <dave.jiang@intel.com>
 M:	Alison Schofield <alison.schofield@intel.com>
 M:	Vishal Verma <vishal.l.verma@intel.com>
-M:	Dan Williams <djbw@kernel.org>
 R:	Ira Weiny <iweiny@kernel.org>
 R:	Li Ming <ming.li@zohomail.com>
 R:	Richard Cheng <icheng@nvidia.com>
@@ -7621,7 +7620,6 @@ S:	Maintained
 F:	scripts/dev-needs.sh
 
 DEVICE DIRECT ACCESS (DAX)
-M:	Dan Williams <djbw@kernel.org>
 M:	Vishal Verma <vishal.l.verma@intel.com>
 M:	Dave Jiang <dave.jiang@intel.com>
 M:	Alison Schofield <alison.schofield@intel.com>
@@ -10315,12 +10313,12 @@ F:	include/linux/fcntl.h
 F:	include/uapi/linux/fcntl.h
 
 FILESYSTEM DIRECT ACCESS (DAX)
-M:	Dan Williams <djbw@kernel.org>
+M:	Alistair Popple <apopple@nvidia.com>
 R:	Matthew Wilcox <willy@infradead.org>
 R:	Jan Kara <jack@suse.cz>
 L:	linux-fsdevel@vger.kernel.org
 L:	nvdimm@lists.linux.dev
-S:	Supported
+S:	Maintained
 F:	fs/dax.c
 F:	include/linux/dax.h
 F:	include/trace/events/fs_dax.h
@@ -13455,7 +13453,6 @@ F:	drivers/platform/x86/intel/hid.c
 
 INTEL I/OAT DMA DRIVER
 M:	Dave Jiang <dave.jiang@intel.com>
-R:	Dan Williams <djbw@kernel.org>
 L:	dmaengine@vger.kernel.org
 S:	Supported
 Q:	https://patchwork.kernel.org/project/linux-dmaengine/list/
@@ -15278,7 +15275,6 @@ K:	libie
 
 LIBNVDIMM BTT: BLOCK TRANSLATION TABLE
 M:	Vishal Verma <vishal.l.verma@intel.com>
-M:	Dan Williams <djbw@kernel.org>
 M:	Dave Jiang <dave.jiang@intel.com>
 M:	Alison Schofield <alison.schofield@intel.com>
 L:	nvdimm@lists.linux.dev
@@ -15288,7 +15284,6 @@ P:	Documentation/nvdimm/maintainer-entry-profile.rst
 F:	drivers/nvdimm/btt*
 
 LIBNVDIMM PMEM: PERSISTENT MEMORY DRIVER
-M:	Dan Williams <djbw@kernel.org>
 M:	Vishal Verma <vishal.l.verma@intel.com>
 M:	Dave Jiang <dave.jiang@intel.com>
 M:	Alison Schofield <alison.schofield@intel.com>
@@ -15307,7 +15302,6 @@ F:	Documentation/devicetree/bindings/pmem/pmem-region.yaml
 F:	drivers/nvdimm/of_pmem.c
 
 LIBNVDIMM: NON-VOLATILE MEMORY DEVICE SUBSYSTEM
-M:	Dan Williams <djbw@kernel.org>
 M:	Vishal Verma <vishal.l.verma@intel.com>
 M:	Dave Jiang <dave.jiang@intel.com>
 M:	Alison Schofield <alison.schofield@intel.com>

base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
-- 
2.54.0


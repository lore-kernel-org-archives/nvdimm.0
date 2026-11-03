Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793736965;
	b=SDgNFMWzAL+yVyPAJSAx4a//8pv2yZoDt12JXxvw+Da6TQZZhWNI1cpcD09xzLCf20lg
	 og+W5gRNbtWOH2eABtjIUt9IZHMANRI6FcE1dDc2gBbQnPdDmKMXJ6nHR8uYSzdF6uaZW
	 BGSNC5/Y8g64lMDKC2EbmnHK6c885RFW5BF1csdA1vCCAQPajDlOgsDRK4U2oIkc9xLpp
	 pxwZchzThS+VvPbqjZSgKt3Jww+tuBbQDv+Xs2mULAvGOFuUuAfVk7cS/osO7j3pNPoTg
	 i+WIEjy/uAB6p2QxiKlgyn6zSm9A+O6ofS8Tepz4y/+j7FBilYs+zLm/kmtuocDr9cQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793736965;
	h=Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=hYNTlkSNVOmO03JDGrtxWD2nbkkOaysUcNtUsh9A9Aw=;
	b=FepHrupdHZ81i+Cvq/kwClSIf7lnqJ/Q+u8ehkJg2N5vgg+m4b/xk+QkXOtoDZML/InA
	 86GsSPCm/9FJ5tPVP+IQVs2gbbjkbZ+946wiAfL4QCLJYL2SM1mFaZCX7qNPr8GE1jGbt
	 QFr70A4XcxsP0tqWgnogWyCDIIOTtZyxW9oAuVBiDymXa1vXKwhMtAH6uuPTbm878kUGT
	 LJBh5VwN/DP5BPG4SxyswW1IKd/ZD+Ky2xe45BIfHTIOTceIIsLljijXhk1dg8LZPNxHa
	 CvCAxPzwSOwo7f54oLXdhP55tZBdOEivoDksPo7Eb8uq+uk17i6+X2FUBQFEsdJ0FdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BD1C606A326;
	Tue,  3 Nov 2026 20:16:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 832AA1F000C1;
	Tue,  3 Nov 2026 20:16:04 +0000 (UTC)
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
	Frank Li <Frank.Li@kernel.org>
Subject: [PATCH] MAINTAINERS: Update CXL, NVDIMM, DAX, and others for djbw
Date: Tue,  3 Nov 2026 13:15:47 -0700
Message-ID: <20261103201547.4079847-1-dave.jiang@intel.com>
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

async_tx will be essentially orphaned. There has been discussion of
deprecation for the feature on the dmaengine mailing list.

fsdax will no longer have a maintainer. But there are reviewers still
and Alison Schofield will continue to wrangle patches for DAX overall.

Cc: Alison Schofield <alison.schofield@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Jonathan Cameron <jic23@kernel.org>
Cc: Vinod Koul <vkoul@kernel.org>
Cc: Frank Li <Frank.Li@kernel.org>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>

---
For FSDAX, Jan or Willy if you guys want to step up and be the
maintainer please let me know and I'll update the entry. Thanks.
---
 MAINTAINERS | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 14e4daf8ea8a..32b86033b5f1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4285,8 +4285,7 @@ S:	Maintained
 F:	crypto/rsa*
 
 ASYNCHRONOUS TRANSFERS/TRANSFORMS (IOAT) API
-R:	Dan Williams <djbw@kernel.org>
-S:	Odd fixes
+S:	Orphan
 W:	http://sourceforge.net/projects/xscaleiop
 F:	Documentation/crypto/async-tx-api.rst
 F:	crypto/async_tx/
@@ -6715,7 +6714,6 @@ M:	Jonathan Cameron <jic23@kernel.org>
 M:	Dave Jiang <dave.jiang@intel.com>
 M:	Alison Schofield <alison.schofield@intel.com>
 M:	Vishal Verma <vishal.l.verma@intel.com>
-M:	Dan Williams <djbw@kernel.org>
 R:	Ira Weiny <iweiny@kernel.org>
 R:	Li Ming <ming.li@zohomail.com>
 R:	Richard Cheng <icheng@nvidia.com>
@@ -7610,7 +7608,6 @@ S:	Maintained
 F:	scripts/dev-needs.sh
 
 DEVICE DIRECT ACCESS (DAX)
-M:	Dan Williams <djbw@kernel.org>
 M:	Vishal Verma <vishal.l.verma@intel.com>
 M:	Dave Jiang <dave.jiang@intel.com>
 M:	Alison Schofield <alison.schofield@intel.com>
@@ -10304,12 +10301,11 @@ F:	include/linux/fcntl.h
 F:	include/uapi/linux/fcntl.h
 
 FILESYSTEM DIRECT ACCESS (DAX)
-M:	Dan Williams <djbw@kernel.org>
 R:	Matthew Wilcox <willy@infradead.org>
 R:	Jan Kara <jack@suse.cz>
 L:	linux-fsdevel@vger.kernel.org
 L:	nvdimm@lists.linux.dev
-S:	Supported
+S:	Odd Fixes
 F:	fs/dax.c
 F:	include/linux/dax.h
 F:	include/trace/events/fs_dax.h
@@ -13444,7 +13440,6 @@ F:	drivers/platform/x86/intel/hid.c
 
 INTEL I/OAT DMA DRIVER
 M:	Dave Jiang <dave.jiang@intel.com>
-R:	Dan Williams <djbw@kernel.org>
 L:	dmaengine@vger.kernel.org
 S:	Supported
 Q:	https://patchwork.kernel.org/project/linux-dmaengine/list/
@@ -15267,7 +15262,6 @@ K:	libie
 
 LIBNVDIMM BTT: BLOCK TRANSLATION TABLE
 M:	Vishal Verma <vishal.l.verma@intel.com>
-M:	Dan Williams <djbw@kernel.org>
 M:	Dave Jiang <dave.jiang@intel.com>
 M:	Alison Schofield <alison.schofield@intel.com>
 L:	nvdimm@lists.linux.dev
@@ -15277,7 +15271,6 @@ P:	Documentation/nvdimm/maintainer-entry-profile.rst
 F:	drivers/nvdimm/btt*
 
 LIBNVDIMM PMEM: PERSISTENT MEMORY DRIVER
-M:	Dan Williams <djbw@kernel.org>
 M:	Vishal Verma <vishal.l.verma@intel.com>
 M:	Dave Jiang <dave.jiang@intel.com>
 M:	Alison Schofield <alison.schofield@intel.com>
@@ -15296,7 +15289,6 @@ F:	Documentation/devicetree/bindings/pmem/pmem-region.yaml
 F:	drivers/nvdimm/of_pmem.c
 
 LIBNVDIMM: NON-VOLATILE MEMORY DEVICE SUBSYSTEM
-M:	Dan Williams <djbw@kernel.org>
 M:	Vishal Verma <vishal.l.verma@intel.com>
 M:	Dave Jiang <dave.jiang@intel.com>
 M:	Alison Schofield <alison.schofield@intel.com>

base-commit: abf8c33470f78e2226ee3dcdc69004660020ab47
-- 
2.54.0


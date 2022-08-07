Received: from bg5.exmail.qq.com (unknown [43.155.67.158])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65A3F7A
	for <nvdimm@lists.linux.dev>; Sun,  7 Aug 2022 07:41:34 +0000 (UTC)
X-QQ-mid: bizesmtp90t1659858006tyl24yln
Received: from localhost.localdomain ( [182.148.15.41])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Sun, 07 Aug 2022 15:39:57 +0800 (CST)
X-QQ-SSF: 0100000000200040B000B00A0000000
X-QQ-FEAT: Ix4jrH1osPwSfnRcbmbAbEHyn46kFc7mesZS/C98ukIj45MHfWO694bXYAN+B
	zYcfYcXpYIItAdoTLfN8geAGaNDwlkl276OZvGYcyQ7Tq9uEeJ9cMKNyOtiL9MrHbRfeEJ7
	nsB0lHEU57+BqDzLyvu9rsZy6XE40s2zkxN76z+kM3FANGpUUnq5GjN6AivFZ5l7DfiF4d9
	Fxs3trisU1VVbIxCAZIf6vQPscL8pEZ4caWZJ9AH7VM9PiuSjs4F8yRG+pzvwhfy4BzzFln
	sbPlsXA+OY3cBgdOxoCJcwcIB25kZ8NaWdoMwb6tOe4CbMvLG7AJWtpLLPEz+J1b8GvaUkU
	qcgB3xq20lW8szt7EzpZFAba988I6WegbJ3Vp5eEcOwFqYf75VG4zOYIK2CHA==
X-QQ-GoodBg: 0
From: shaomin Deng <dengshaomin@cdjrlc.com>
To: dan.j.williams@intel.com,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	ira.weiny@intel.com,
	nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: shaomin Deng <dengshaomin@cdjrlc.com>
Subject: [PATCH] tools/testing/nvdimm: Fix typo in comments
Date: Sun,  7 Aug 2022 03:39:55 -0400
Message-Id: <20220807073955.5556-1-dengshaomin@cdjrlc.com>
X-Mailer: git-send-email 2.35.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybglogicsvr:qybglogicsvr4

Remove the repeated word "from" in comments.

Signed-off-by: shaomin Deng <dengshaomin@cdjrlc.com>
---
 tools/testing/nvdimm/test/nfit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
index c75abb497a1a..1694b89aa4a3 100644
--- a/tools/testing/nvdimm/test/nfit.c
+++ b/tools/testing/nvdimm/test/nfit.c
@@ -59,7 +59,7 @@
  * *) The first portion of dimm0 and dimm1 are interleaved as REGION0.
  *    A single PMEM namespace "pm0.0" is created using half of the
  *    REGION0 SPA-range.  REGION0 spans dimm0 and dimm1.  PMEM namespace
- *    allocate from from the bottom of a region.  The unallocated
+ *    allocate from the bottom of a region.  The unallocated
  *    portion of REGION0 aliases with REGION2 and REGION3.  That
  *    unallacted capacity is reclaimed as BLK namespaces ("blk2.0" and
  *    "blk3.0") starting at the base of each DIMM to offset (a) in those
-- 
2.35.1


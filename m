Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 023DF2C9C
	for <nvdimm@lists.linux.dev>; Sat, 18 Dec 2021 02:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639794316; x=1671330316;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=MfNr58JEznfg4qDno5tTuZ5AIAm2Hj+sj9gY+rLTQKg=;
  b=ZygTHpHs5Wr8YTVVXOKaEKZu0OmSI+iaIfL5vBgaRvXfPNymllowORCW
   zGfbeEw/RBVJNfw2NqFSt99WDKao1lEhuOiZddR/k4QKxySPFDRaSz7m4
   C8rs2F0UrpYLPYGcX0TPxSaNgluTqC2heJ6iXFRNvXdIx+QnrB1S5vhvE
   6PI/n4QesKfxwwqjwJZ0rMYOII5lPevpmQP+xutUzfXqP02XJht3/N5pO
   j+Z7exir3rBSo4paLdkeHivffn2v974Fe/TbFJAqMGB4aqQO/HzzsGT+J
   Pb2XUsqZuMdRkpQCgdynYegX4G6bu4eOw1VsSdNPJ0nDG0geSR6mLZoCD
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10201"; a="239686472"
X-IronPort-AV: E=Sophos;i="5.88,215,1635231600"; 
   d="scan'208";a="239686472"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2021 18:25:15 -0800
X-IronPort-AV: E=Sophos;i="5.88,215,1635231600"; 
   d="scan'208";a="520012886"
Received: from dalbrigh-mobl.amr.corp.intel.com (HELO vverma7-desk.amr.corp.intel.com) ([10.254.35.246])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2021 18:25:15 -0800
From: Vishal Verma <vishal.l.verma@intel.com>
To: <linux-cxl@vger.kernel.org>
Cc: <nvdimm@lists.linux.dev>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH] libcxl: fix potential NULL dereference in cxl_memdev_nvdimm_bridge_active()
Date: Fri, 17 Dec 2021 19:25:11 -0700
Message-Id: <20211218022511.314928-1-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.33.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1940; h=from:subject; bh=MfNr58JEznfg4qDno5tTuZ5AIAm2Hj+sj9gY+rLTQKg=; b=owGbwMvMwCXGf25diOft7jLG02pJDIl73Zp/szdyBsSwR35LKl7UWZ7Ls+rZCcYFmQ4TXj1WUHg8 0SO8o5SFQYyLQVZMkeXvno+Mx+S25/MEJjjCzGFlAhnCwMUpABPZuYOR4YDpqwnSvi+6fvkZ81424i qz+56u/sDh1rOD2wUKT8949oCR4V299QanrZt/nQn4t+xVe17Sar/rfzZtbe76vShljpFbAj8A
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp; fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF
Content-Transfer-Encoding: 8bit

Static analysis points out that the function above has a check for
'if (!bridge)', implying that bridge maybe NULL, but it is dereferenced
before the check, which could result in a NULL dereference.

Fix this by moving any accesses to the bridge structure after the NULL
check.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 cxl/lib/libcxl.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index f0664be..3390eb9 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -420,12 +420,15 @@ CXL_EXPORT int cxl_memdev_nvdimm_bridge_active(struct cxl_memdev *memdev)
 {
 	struct cxl_ctx *ctx = cxl_memdev_get_ctx(memdev);
 	struct cxl_nvdimm_bridge *bridge = memdev->bridge;
-	char *path = bridge->dev_buf;
-	int len = bridge->buf_len;
+	char *path;
+	int len;
 
 	if (!bridge)
 		return 0;
 
+	path = bridge->dev_buf;
+	len = bridge->buf_len;
+
 	if (snprintf(path, len, "%s/driver", bridge->dev_path) >= len) {
 		err(ctx, "%s: nvdimm bridge buffer too small!\n",
 				cxl_memdev_get_devname(memdev));

base-commit: 8f4e42c0c526e85b045fd0329df7cb904f511c98
prerequisite-patch-id: acc28fefb6680c477864561902d1560c300fa4a9
prerequisite-patch-id: c749c331eb4a521c8f0b0820e3dda7ac521926d0
prerequisite-patch-id: 9fc7ac4fe29689b9c4de00924a9e455cd9b58d53
prerequisite-patch-id: e019f2c873ac1b93d80b9c260336e5d3f46b0925
prerequisite-patch-id: b69ecc9d68ce5e7c79b62cea257663519f630da2
prerequisite-patch-id: 928a32f4c1ff844df809ccf1aba8315cac723d93
prerequisite-patch-id: ae29f23cedf529da1fe8e39f8cde1df827d75fa1
prerequisite-patch-id: f3d8fc575f5afed65be8a7b486962e8384eabc1a
prerequisite-patch-id: 74859f43302dcc442dfb1e29f6babad75d229bf1
prerequisite-patch-id: 696c2d5caf0bd4eac645035f72a7077efbf3e6cd
prerequisite-patch-id: e3ef7893a1df9ecc6b76dee78f2b27cc933ad891
-- 
2.33.1


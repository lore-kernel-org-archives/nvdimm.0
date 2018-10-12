Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 04FB52116DA3A
 for <linux-nvdimm@lists.01.org>; Fri, 12 Oct 2018 11:23:58 -0700 (PDT)
Subject: [PATCH 2/5] libnvdimm: fix incorrect output when nvdimm disable failed
From: Dave Jiang <dave.jiang@intel.com>
Date: Fri, 12 Oct 2018 11:23:58 -0700
Message-ID: <153936863837.55836.13460607811316925558.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <153936863308.55836.2972520178944977338.stgit@djiang5-desk3.ch.intel.com>
References: <153936863308.55836.2972520178944977338.stgit@djiang5-desk3.ch.intel.com>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Fix inocrrect dev_warn() in nvdimm_security_disable().

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/nvdimm/security.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvdimm/security.c b/drivers/nvdimm/security.c
index ef83bdf47c31..cf934c6025d9 100644
--- a/drivers/nvdimm/security.c
+++ b/drivers/nvdimm/security.c
@@ -256,7 +256,7 @@ int nvdimm_security_disable(struct nvdimm *nvdimm, unsigned int keyid)
 			(const struct nvdimm_key_data *)payload->data);
 	up_read(&key->sem);
 	if (rc < 0) {
-		dev_warn(dev, "unlock failed\n");
+		dev_warn(dev, "nvdimm disable failed\n");
 		goto out;
 	}
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com
 [148.163.158.5])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id ADD0A2021B719
 for <linux-nvdimm@lists.01.org>; Tue,  3 Sep 2019 22:09:50 -0700 (PDT)
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: [PATCH v7 5/7] libnvdimm/label: Remove the dpa align check
Date: Wed,  4 Sep 2019 10:38:20 +0530
Message-Id: <20190904050822.23139-6-aneesh.kumar@linux.ibm.com>
In-Reply-To: <20190904050822.23139-1-aneesh.kumar@linux.ibm.com>
References: <20190904050822.23139-1-aneesh.kumar@linux.ibm.com>
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
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

There's no strict requirement why slot_valid() needs to check for page alignment
and it would seem to actively hurt cross-page-size compatibility. Let's
delete the check and rely on checksum validation.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
---
 drivers/nvdimm/label.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
index 73e197babc2f..47a4828b8b31 100644
--- a/drivers/nvdimm/label.c
+++ b/drivers/nvdimm/label.c
@@ -353,11 +353,6 @@ static bool slot_valid(struct nvdimm_drvdata *ndd,
 	if (slot != __le32_to_cpu(nd_label->slot))
 		return false;
 
-	/* check that DPA allocations are page aligned */
-	if ((__le64_to_cpu(nd_label->dpa)
-				| __le64_to_cpu(nd_label->rawsize)) % SZ_4K)
-		return false;
-
 	/* check checksum */
 	if (namespace_label_has(ndd, checksum)) {
 		u64 sum, sum_save;
-- 
2.21.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

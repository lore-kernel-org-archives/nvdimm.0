Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id F3E0820958BF5
 for <linux-nvdimm@lists.01.org>; Tue, 19 Sep 2017 12:54:53 -0700 (PDT)
Subject: [PATCH 2/2] libnvdimm, namespace: fix btt claim class crash
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 19 Sep 2017 12:51:34 -0700
Message-ID: <150585069444.18066.1329567407748978657.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <150585068899.18066.14107564726083870194.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <150585068899.18066.14107564726083870194.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: linux-nvdimm@lists.01.org
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Maurice reports:

    BUG: unable to handle kernel NULL pointer dereference at 0000000000000028
    IP: holder_class_store+0x253/0x2b0 [libnvdimm]

...while trying to reconfigure an NVDIMM-N namespace into 'sector' /
'btt' mode. The crash points to this line:

    (gdb) li *(holder_class_store+0x253)
    0x7773 is in holder_class_store (drivers/nvdimm/namespace_devs.c:1420).
    1415            for (i = 0; i < nd_region->ndr_mappings; i++) {
    1416                    struct nd_mapping *nd_mapping = &nd_region->mapping[i];
    1417                    struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
    1418                    struct nd_namespace_index *nsindex;
    1419
    1420                    nsindex = to_namespace_index(ndd, ndd->ns_current);

...where we are failing because ndd is NULL due to NVDIMM-N dimms not
supporting labels.

Long story short, default to the BTTv1 format in the label-less /
NVDIMM-N case.

Fixes: 14e494542636 ("libnvdimm, btt: BTT updates for UEFI 2.7 format")
Cc: <stable@vger.kernel.org>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Reported-by: Maurice A. Saldivar <maurice.a.saldivar@hpe.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/namespace_devs.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index 1427a386a033..3e4d1e7998da 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -1417,6 +1417,15 @@ static int btt_claim_class(struct device *dev)
 		struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
 		struct nd_namespace_index *nsindex;
 
+		/*
+		 * If any of the DIMMs do not support labels the only
+		 * possible BTT format is v1.
+		 */
+		if (!ndd) {
+			loop_bitmask = 0;
+			break;
+		}
+
 		nsindex = to_namespace_index(ndd, ndd->ns_current);
 		if (nsindex == NULL)
 			loop_bitmask |= 1;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

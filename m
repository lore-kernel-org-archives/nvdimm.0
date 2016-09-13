Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t2353.austin.hpe.com (g2t2353.austin.hpe.com [15.233.44.26])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8CAC01A1E56
 for <linux-nvdimm@lists.01.org>; Tue, 13 Sep 2016 10:44:02 -0700 (PDT)
From: Brian Boylston <brian.boylston@hpe.com>
Subject: [ndctl PATCH v2 2/4] libndctl: record dsm family in add_dimm()
Date: Tue, 13 Sep 2016 12:41:38 -0500
Message-Id: <20160913174140.10810-3-brian.boylston@hpe.com>
In-Reply-To: <20160913174140.10810-1-brian.boylston@hpe.com>
References: <20160913174140.10810-1-brian.boylston@hpe.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

The recorded DSM family can be used to provide family-specific
functionality.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Brian Boylston <brian.boylston@hpe.com>
---
 ndctl/lib/libndctl.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index 9a9dc74..c824d83 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -136,6 +136,7 @@ struct ndctl_dimm {
 	unsigned short subsystem_revision_id;
 	unsigned short manufacturing_date;
 	unsigned char manufacturing_location;
+	unsigned long dsm_family;
 	unsigned long dsm_mask;
 	char *unique_id;
 	char *dimm_path;
@@ -1145,6 +1146,11 @@ static int add_dimm(void *parent, int id, const char *dimm_base)
 	if (sscanf(buf, "%d:%d", &dimm->major, &dimm->minor) != 2)
 		goto err_read;
 
+	sprintf(path, "%s/nfit/family", dimm_base);
+	if (sysfs_read_attr(ctx, path, buf) < 0)
+		goto err_read;
+	dimm->dsm_family = strtoul(buf, NULL, 0);
+
 	sprintf(path, "%s/commands", dimm_base);
 	if (sysfs_read_attr(ctx, path, buf) < 0)
 		goto err_read;
-- 
2.8.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

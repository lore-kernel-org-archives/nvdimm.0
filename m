Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g9t5009.houston.hpe.com (g9t5009.houston.hpe.com [15.241.48.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 82D5D1A1F21
 for <linux-nvdimm@lists.01.org>; Fri, 16 Sep 2016 13:11:58 -0700 (PDT)
From: Brian Boylston <brian.boylston@hpe.com>
Subject: [ndctl PATCH v3 2/4] libndctl: record dsm family in add_dimm()
Date: Fri, 16 Sep 2016 15:10:11 -0500
Message-Id: <20160916201013.555-3-brian.boylston@hpe.com>
In-Reply-To: <20160916201013.555-1-brian.boylston@hpe.com>
References: <20160916201013.555-1-brian.boylston@hpe.com>
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
Changes in v3:
  - Do not fail add_dimm() if the read of nfit/commands fails, just set
    dimm->dsm_family to -1 instead (suggested by Dan).  As part of this,
    I also moved the read to after the has_nfit() check.

 ndctl/lib/libndctl.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index 3c9a506..99938be 100644
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
@@ -1176,6 +1177,7 @@ static int add_dimm(void *parent, int id, const char *dimm_base)
 	dimm->subsystem_revision_id = -1;
 	dimm->manufacturing_date = -1;
 	dimm->manufacturing_location = -1;
+	dimm->dsm_family = -1;
 	for (i = 0; i < formats; i++)
 		dimm->format[i] = -1;
 
@@ -1239,6 +1241,10 @@ static int add_dimm(void *parent, int id, const char *dimm_base)
 	if (sysfs_read_attr(ctx, path, buf) == 0)
 		dimm->subsystem_revision_id = strtoul(buf, NULL, 0);
 
+	sprintf(path, "%s/nfit/family", dimm_base);
+	if (sysfs_read_attr(ctx, path, buf) == 0)
+		dimm->dsm_family = strtoul(buf, NULL, 0);
+
 	dimm->formats = formats;
 	sprintf(path, "%s/nfit/format", dimm_base);
 	if (sysfs_read_attr(ctx, path, buf) == 0)
-- 
2.8.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

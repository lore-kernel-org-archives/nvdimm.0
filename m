Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g9t5008.houston.hpe.com (g9t5008.houston.hpe.com [15.241.48.72])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2AB4D1A1E59
 for <linux-nvdimm@lists.01.org>; Thu,  8 Sep 2016 11:05:32 -0700 (PDT)
From: Brian Boylston <brian.boylston@hpe.com>
Subject: [ndctl PATCH] libndctl: adjust indentation in add_dimm()
Date: Thu,  8 Sep 2016 13:04:10 -0500
Message-Id: <20160908180410.548-1-brian.boylston@hpe.com>
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

Use tabs instead of spaces to match the rest of the code.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Brian Boylston <brian.boylston@hpe.com>
---
 ndctl/lib/libndctl.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index 5f354ac..93f79f7 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -1149,10 +1149,10 @@ static int add_dimm(void *parent, int id, const char *dimm_base)
 		goto err_read;
 	dimm->dsm_mask = parse_commands(buf, 1);
 
-        dimm->dimm_buf = calloc(1, strlen(dimm_base) + 50);
-        if (!dimm->dimm_buf)
-                goto err_read;
-        dimm->buf_len = strlen(dimm_base) + 50;
+	dimm->dimm_buf = calloc(1, strlen(dimm_base) + 50);
+	if (!dimm->dimm_buf)
+		goto err_read;
+	dimm->buf_len = strlen(dimm_base) + 50;
 
 	dimm->dimm_path = strdup(dimm_base);
 	if (!dimm->dimm_path)
-- 
2.8.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

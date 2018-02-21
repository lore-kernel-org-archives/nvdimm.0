Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0EC712034D8D4
 for <linux-nvdimm@lists.01.org>; Wed, 21 Feb 2018 14:56:57 -0800 (PST)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH 1/3] ndctl,
 inject-smart: cleanup uninitialized variable warnings
Date: Wed, 21 Feb 2018 16:02:50 -0700
Message-Id: <20180221230252.16632-2-vishal.l.verma@intel.com>
In-Reply-To: <20180221230252.16632-1-vishal.l.verma@intel.com>
References: <20180221230252.16632-1-vishal.l.verma@intel.com>
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

There were a couple of cases where we could try to unref a command that
had never been initialized. Fix those by always initializing the cmd
pointers to NULL.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 ndctl/inject-smart.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/ndctl/inject-smart.c b/ndctl/inject-smart.c
index 02f8b0e..45dbc8d 100644
--- a/ndctl/inject-smart.c
+++ b/ndctl/inject-smart.c
@@ -221,7 +221,7 @@ static int smart_init(void)
 static int smart_set_thresh(struct ndctl_dimm *dimm)
 {
 	const char *name = ndctl_dimm_get_devname(dimm);
-	struct ndctl_cmd *st_cmd, *sst_cmd;
+	struct ndctl_cmd *st_cmd = NULL, *sst_cmd = NULL;
 	int rc = -EOPNOTSUPP;
 
 	st_cmd = ndctl_dimm_cmd_new_smart_threshold(dimm);
@@ -332,7 +332,7 @@ out:
 static int smart_inject(struct ndctl_dimm *dimm)
 {
 	const char *name = ndctl_dimm_get_devname(dimm);
-	struct ndctl_cmd *si_cmd;
+	struct ndctl_cmd *si_cmd = NULL;
 	int rc = -EOPNOTSUPP;
 
 	send_inject_val(media_temperature)
-- 
2.14.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t2355.austin.hpe.com (g2t2355.austin.hpe.com [15.233.44.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CF4351A1E10
 for <linux-nvdimm@lists.01.org>; Tue, 28 Jun 2016 12:38:01 -0700 (PDT)
From: Toshi Kani <toshi.kani@hpe.com>
Subject: [PATCH 1/2] dm: update table type check for dax
Date: Tue, 28 Jun 2016 13:37:15 -0600
Message-Id: <1467142636-21094-2-git-send-email-toshi.kani@hpe.com>
In-Reply-To: <1467142636-21094-1-git-send-email-toshi.kani@hpe.com>
References: <1467142636-21094-1-git-send-email-toshi.kani@hpe.com>
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
To: snitzer@redhat.com
Cc: linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com, agk@redhat.com
List-ID: <linux-nvdimm@lists.01.org>

Allow table type DM_TYPE_BIO_BASED to extend with
DM_TYPE_DAX_BIO_BASED since DM_TYPE_DAX_BIO_BASED
supports bio-based requests.

Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
Cc: Mike Snitzer <snitzer@redhat.com>
Cc: Alasdair Kergon <agk@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>
---
 drivers/md/dm-ioctl.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index b59e3459..0f32791 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1267,6 +1267,15 @@ static int populate_table(struct dm_table *table,
 	return dm_table_complete(table);
 }
 
+static bool is_valid_type(unsigned cur, unsigned new)
+{
+	if (cur == new ||
+	    (cur == DM_TYPE_BIO_BASED && new == DM_TYPE_DAX_BIO_BASED))
+		return true;
+
+	return false;
+}
+
 static int table_load(struct dm_ioctl *param, size_t param_size)
 {
 	int r;
@@ -1309,7 +1318,7 @@ static int table_load(struct dm_ioctl *param, size_t param_size)
 			DMWARN("unable to set up device queue for new table.");
 			goto err_unlock_md_type;
 		}
-	} else if (dm_get_md_type(md) != dm_table_get_type(t)) {
+	} else if (!is_valid_type(dm_get_md_type(md), dm_table_get_type(t))) {
 		DMWARN("can't change device type after initial table load.");
 		r = -EINVAL;
 		goto err_unlock_md_type;
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

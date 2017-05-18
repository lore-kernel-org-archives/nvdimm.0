Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org [65.50.211.133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2DFA221A16EFB
 for <linux-nvdimm@lists.01.org>; Wed, 17 May 2017 23:28:35 -0700 (PDT)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 22/23] scsi_debug: switch to uuid_t
Date: Thu, 18 May 2017 08:27:04 +0200
Message-Id: <20170518062705.25902-23-hch@lst.de>
In-Reply-To: <20170518062705.25902-1-hch@lst.de>
References: <20170518062705.25902-1-hch@lst.de>
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
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, Shaohua Li <shli@kernel.org>, linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Steven Whitehouse <swhiteho@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi_debug.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 17249c3650fe..35ee09644cfb 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -245,7 +245,7 @@ struct sdebug_dev_info {
 	unsigned int channel;
 	unsigned int target;
 	u64 lun;
-	uuid_be lu_name;
+	uuid_t lu_name;
 	struct sdebug_host_info *sdbg_host;
 	unsigned long uas_bm[1];
 	atomic_t num_in_q;
@@ -965,7 +965,7 @@ static const u64 naa3_comp_c = 0x3111111000000000ULL;
 static int inquiry_vpd_83(unsigned char *arr, int port_group_id,
 			  int target_dev_id, int dev_id_num,
 			  const char *dev_id_str, int dev_id_str_len,
-			  const uuid_be *lu_name)
+			  const uuid_t *lu_name)
 {
 	int num, port_a;
 	char b[32];
@@ -3568,7 +3568,7 @@ static void sdebug_q_cmd_wq_complete(struct work_struct *work)
 }
 
 static bool got_shared_uuid;
-static uuid_be shared_uuid;
+static uuid_t shared_uuid;
 
 static struct sdebug_dev_info *sdebug_device_create(
 			struct sdebug_host_info *sdbg_host, gfp_t flags)
@@ -3578,12 +3578,12 @@ static struct sdebug_dev_info *sdebug_device_create(
 	devip = kzalloc(sizeof(*devip), flags);
 	if (devip) {
 		if (sdebug_uuid_ctl == 1)
-			uuid_be_gen(&devip->lu_name);
+			uuid_gen(&devip->lu_name);
 		else if (sdebug_uuid_ctl == 2) {
 			if (got_shared_uuid)
 				devip->lu_name = shared_uuid;
 			else {
-				uuid_be_gen(&shared_uuid);
+				uuid_gen(&shared_uuid);
 				got_shared_uuid = true;
 				devip->lu_name = shared_uuid;
 			}
-- 
2.11.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

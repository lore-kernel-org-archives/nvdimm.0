Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pg0-x242.google.com (mail-pg0-x242.google.com
 [IPv6:2607:f8b0:400e:c05::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2B451226462F8
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:15:21 -0800 (PST)
Received: by mail-pg0-x242.google.com with SMTP id e9so4831299pgs.10
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:21:39 -0800 (PST)
From: Andiry Xu <jix024@eng.ucsd.edu>
Subject: [RFC v2 69/83] Super: Add module param inplace_data_updates.
Date: Sat, 10 Mar 2018 10:18:50 -0800
Message-Id: <1520705944-6723-70-git-send-email-jix024@eng.ucsd.edu>
In-Reply-To: <1520705944-6723-1-git-send-email-jix024@eng.ucsd.edu>
References: <1520705944-6723-1-git-send-email-jix024@eng.ucsd.edu>
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
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
Cc: coughlan@redhat.com, miklos@szeredi.hu, Andiry Xu <jix024@cs.ucsd.edu>, david@fromorbit.com, jack@suse.com, swanson@cs.ucsd.edu, swhiteho@redhat.com, andiry.xu@gmail.com
List-ID: <linux-nvdimm@lists.01.org>

From: Andiry Xu <jix024@cs.ucsd.edu>

Provide inplace data updates option if people prefer inplace
updates to copy-on-write.

Signed-off-by: Andiry Xu <jix024@cs.ucsd.edu>
---
 fs/nova/nova.h  | 1 +
 fs/nova/super.c | 7 ++++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/nova/nova.h b/fs/nova/nova.h
index 1c2205e..6c94a9b 100644
--- a/fs/nova/nova.h
+++ b/fs/nova/nova.h
@@ -138,6 +138,7 @@ extern unsigned int nova_dbgmask;
 
 
 extern int measure_timing;
+extern int inplace_data_updates;
 
 
 extern unsigned int blk_type_to_shift[NOVA_BLOCK_TYPE_MAX];
diff --git a/fs/nova/super.c b/fs/nova/super.c
index 9710be8..980b1d7 100644
--- a/fs/nova/super.c
+++ b/fs/nova/super.c
@@ -43,10 +43,14 @@
 
 int measure_timing;
 int support_clwb;
+int inplace_data_updates;
 
 module_param(measure_timing, int, 0444);
 MODULE_PARM_DESC(measure_timing, "Timing measurement");
 
+module_param(inplace_data_updates, int, 0444);
+MODULE_PARM_DESC(inplace_data_updates, "Perform data updates in-place (i.e., not atomically)");
+
 module_param(nova_dbgmask, int, 0444);
 MODULE_PARM_DESC(nova_dbgmask, "Control debugging output");
 
@@ -541,7 +545,8 @@ static int nova_fill_super(struct super_block *sb, void *data, int silent)
 		goto out;
 	}
 
-	nova_dbg("measure timing %d\n", measure_timing);
+	nova_dbg("measure timing %d, inplace data update %d\n",
+			measure_timing, inplace_data_updates);
 
 	get_random_bytes(&random, sizeof(u32));
 	atomic_set(&sbi->next_generation, random);
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org [65.50.211.133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1A4D821A16ECB
 for <linux-nvdimm@lists.01.org>; Sun, 28 May 2017 03:20:07 -0700 (PDT)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 10/22] S390/sysinfo: use uuid_is_null instead of opencoding it
Date: Sun, 28 May 2017 13:19:56 +0300
Message-Id: <20170528102008.30276-11-hch@lst.de>
In-Reply-To: <20170528102008.30276-1-hch@lst.de>
References: <20170528102008.30276-1-hch@lst.de>
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
Cc: linux-xfs@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, Shaohua Li <shli@kernel.org>, linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>, linux-block@vger.kernel.org, Mimi Zohar <zohar@linux.vnet.ibm.com>, Steven Whitehouse <swhiteho@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

And switch to use uuid_t instead of the old uuid_be type.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 arch/s390/include/asm/sysinfo.h | 4 ++--
 arch/s390/kernel/sysinfo.c      | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/s390/include/asm/sysinfo.h b/arch/s390/include/asm/sysinfo.h
index e784bed6ed7f..2b498e58b914 100644
--- a/arch/s390/include/asm/sysinfo.h
+++ b/arch/s390/include/asm/sysinfo.h
@@ -109,7 +109,7 @@ struct sysinfo_2_2_2 {
 	unsigned short cpus_shared;
 	char reserved_4[3];
 	unsigned char vsne;
-	uuid_be uuid;
+	uuid_t uuid;
 	char reserved_5[160];
 	char ext_name[256];
 };
@@ -134,7 +134,7 @@ struct sysinfo_3_2_2 {
 		char reserved_1[3];
 		unsigned char evmne;
 		unsigned int reserved_2;
-		uuid_be uuid;
+		uuid_t uuid;
 	} vm[8];
 	char reserved_3[1504];
 	char ext_names[8][256];
diff --git a/arch/s390/kernel/sysinfo.c b/arch/s390/kernel/sysinfo.c
index eefcb54872a5..fb869b103825 100644
--- a/arch/s390/kernel/sysinfo.c
+++ b/arch/s390/kernel/sysinfo.c
@@ -242,7 +242,7 @@ static void print_ext_name(struct seq_file *m, int lvl,
 
 static void print_uuid(struct seq_file *m, int i, struct sysinfo_3_2_2 *info)
 {
-	if (!memcmp(&info->vm[i].uuid, &NULL_UUID_BE, sizeof(uuid_be)))
+	if (uuid_is_null(&info->vm[i].uuid))
 		return;
 	seq_printf(m, "VM%02d UUID:            %pUb\n", i, &info->vm[i].uuid);
 }
-- 
2.11.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

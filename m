Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org [65.50.211.133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9EC2821A16EFB
 for <linux-nvdimm@lists.01.org>; Wed, 17 May 2017 23:28:28 -0700 (PDT)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 20/23] sysctl: switch to use uuid_t
Date: Thu, 18 May 2017 08:27:02 +0200
Message-Id: <20170518062705.25902-21-hch@lst.de>
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
 kernel/sysctl_binary.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sysctl_binary.c b/kernel/sysctl_binary.c
index ece4b177052b..1ae520eed53c 100644
--- a/kernel/sysctl_binary.c
+++ b/kernel/sysctl_binary.c
@@ -1119,7 +1119,7 @@ static ssize_t bin_uuid(struct file *file,
 	/* Only supports reads */
 	if (oldval && oldlen) {
 		char buf[UUID_STRING_LEN + 1];
-		uuid_be uuid;
+		uuid_t uuid;
 
 		result = kernel_read(file, 0, buf, sizeof(buf) - 1);
 		if (result < 0)
@@ -1128,7 +1128,7 @@ static ssize_t bin_uuid(struct file *file,
 		buf[result] = '\0';
 
 		result = -EIO;
-		if (uuid_be_to_bin(buf, &uuid))
+		if (uuid_to_bin(buf, &uuid))
 			goto out;
 
 		if (oldlen > 16)
-- 
2.11.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

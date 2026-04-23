Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CC503822BB;
	Thu, 23 Apr 2026 17:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776963745; cv=none; b=kP3hj4nTYhE385oXdKDKlTSWpAx+zsstkLPlJeL8z3kl1a8y1Bu6OUDBMRChxEG/hImO36wKku4Qb/nAIZOKm9TXsOdQsU6SlCEzQRxic4Z5W/dzE5QS7i7gtEA5bkIe+HHZvH/CWSNAQYOpxpysLoglAiywrpvuXfS+XxoB4iQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776963745; c=relaxed/simple;
	bh=ocr6fd6xbunNGmuBXWUC4OxvUbjKtOF2u23N2M3zy7M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gNLUZk7DIHqKgLBy5ywiSlCZPiLPUotNtmpYAl0JNoTGrx3kjAc6Qzcae0hGhs1AX3UZInCVZaxGvx/VXW306I5fc7or8CxHf17OmnYrzH7AUGn0F4TkLOXoLRVfQDNLyPxHGz7hOu/U2rrTUWFdjYH9W0EyxVsEYgLNey8LkI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 480E0C2BCAF;
	Thu, 23 Apr 2026 17:02:25 +0000 (UTC)
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev
Cc: djbw@kernel.org,
	iweiny@kernel.org,
	pasha.tatashin@soleen.com,
	mclapinski@google.com,
	rppt@kernel.org,
	joao.m.martins@oracle.com,
	jic23@kernel.org,
	gourry@gourry.net,
	john@groves.net,
	rick.p.edgecombe@intel.com
Subject: [RFC PATCH 03/12] dax: Add fallocate support to device dax
Date: Thu, 23 Apr 2026 10:02:10 -0700
Message-ID: <20260423170219.281618-4-dave.jiang@intel.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260423170219.281618-1-dave.jiang@intel.com>
References: <20260423170219.281618-1-dave.jiang@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

fallocate() support is needed for the KVM guest_memfd selftest. Add a
version of fallocate() for device dax. This is a simplistic
implementation that just zeroes the specified range. It may need to
be revisited and implement map/unmap to support larger files.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/dax/device.c | 30 +++++++++++++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

diff --git a/drivers/dax/device.c b/drivers/dax/device.c
index 4ffa3ef60a57..705c59f469c2 100644
--- a/drivers/dax/device.c
+++ b/drivers/dax/device.c
@@ -10,6 +10,8 @@
 #include <linux/fs.h>
 #include <linux/mm.h>
 #include <linux/mman.h>
+#include <linux/range.h>
+#include <linux/falloc.h>
 #include "dax-private.h"
 #include "bus.h"
 
@@ -383,7 +385,31 @@ static int dax_release(struct inode *inode, struct file *filp)
 	return 0;
 }
 
-static const struct file_operations dax_fops = {
+static long dax_fallocate(struct file *file, int mode, loff_t offset,
+			  loff_t len)
+{
+	struct dev_dax *dev_dax = file->private_data;
+
+	if (!IS_ALIGNED(offset, dev_dax->align) ||
+	    !IS_ALIGNED(len, dev_dax->align))
+		return -EINVAL;
+
+	if (offset + len > dev_dax->cached_size)
+		return -ERANGE;
+
+	/* DAX device does not change size */
+	if (!(mode & FALLOC_FL_KEEP_SIZE))
+		return -EOPNOTSUPP;
+
+	if ((mode & ~FALLOC_FL_KEEP_SIZE) &&
+	    ((mode & (FALLOC_FL_PUNCH_HOLE | FALLOC_FL_ZERO_RANGE)) == 0))
+		return -EOPNOTSUPP;
+
+	memset(dev_dax->virt_addr + offset, 0, len);
+	return 0;
+}
+
+const struct file_operations dax_fops = {
 	.llseek = noop_llseek,
 	.owner = THIS_MODULE,
 	.open = dax_open,
@@ -391,7 +417,9 @@ static const struct file_operations dax_fops = {
 	.get_unmapped_area = dax_get_unmapped_area,
 	.mmap_prepare = dax_mmap_prepare,
 	.fop_flags = FOP_MMAP_SYNC,
+	.fallocate = dax_fallocate,
 };
+EXPORT_SYMBOL_GPL(dax_fops);
 
 static void dev_dax_cdev_del(void *cdev)
 {
-- 
2.53.0


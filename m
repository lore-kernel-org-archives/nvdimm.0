Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from heian.cn.fujitsu.com (mail.cn.fujitsu.com [183.91.158.132])
 by ml01.01.org (Postfix) with ESMTP id E1C39212017C0
 for <linux-nvdimm@lists.01.org>; Tue, 16 Apr 2019 18:27:28 -0700 (PDT)
From: Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
Subject: [RFC PATCH 1/4] fs/iomap: Introduce src_addr for COW in fsdax mode.
Date: Wed, 17 Apr 2019 09:27:12 +0800
Message-ID: <20190417012715.8287-2-ruansy.fnst@cn.fujitsu.com>
In-Reply-To: <20190417012715.8287-1-ruansy.fnst@cn.fujitsu.com>
References: <20190417012715.8287-1-ruansy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-xfs@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

When using reflink, coping the source blocks before writing data
into new allocated blocks is required.  In fsdax mode, we need a source
blocks' start address to handle the COW operation.

Signed-off-by: Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
---
 include/linux/iomap.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 0fefb5455bda..3b3aec2311c5 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -61,6 +61,10 @@ struct iomap {
 	u16			flags;	/* flags for mapping */
 	struct block_device	*bdev;	/* block device for I/O */
 	struct dax_device	*dax_dev; /* dax_dev for dax operations */
+	u64			src_addr; /* disk offset of mapping, bytes,
+					   * the source blocks' start address
+					   * for cow in dax
+					   */
 	void			*inline_data;
 	void			*private; /* filesystem private */
 
-- 
2.17.0



_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

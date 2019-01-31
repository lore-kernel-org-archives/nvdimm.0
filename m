Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from sender-pp-092.zoho.com (sender-pp-092.zoho.com [135.84.80.237])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CF3F5211B5A4C
 for <linux-nvdimm@lists.01.org>; Wed, 30 Jan 2019 18:32:29 -0800 (PST)
From: Huaisheng Ye <yehs2007@zoho.com>
Subject: [PATCH v3 4/5] Documentation/device-mapper: add optional parameter
 reinit
Date: Thu, 31 Jan 2019 10:29:54 +0800
Message-Id: <20190131022955.9920-5-yehs2007@zoho.com>
In-Reply-To: <20190131022955.9920-1-yehs2007@zoho.com>
References: <20190131022955.9920-1-yehs2007@zoho.com>
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
To: mpatocka@redhat.com, snitzer@redhat.com, agk@redhat.com
Cc: jack@suse.cz, corbet@lwn.net, linux-nvdimm@lists.01.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

From: Huaisheng Ye <yehs1@lenovo.com>

Add intro and usage guide for reinit.

Signed-off-by: Huaisheng Ye <yehs1@lenovo.com>
---
 Documentation/device-mapper/writecache.txt | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/device-mapper/writecache.txt b/Documentation/device-mapper/writecache.txt
index 01532b3..255c68c 100644
--- a/Documentation/device-mapper/writecache.txt
+++ b/Documentation/device-mapper/writecache.txt
@@ -45,6 +45,10 @@ Constructor parameters:
 		afterwards
 		- some underlying devices perform better with fua, some
 		  with nofua. The user should test it
+	reinit		(by default off)
+		applicable only to persistent memory - use the REINIT flag
+		when the surper block has messy data, that would cause fn ctr
+		failed to work with invalid magic or version in the superblock
 
 Status:
 1. error indicator - 0 if there was no error, otherwise error number
-- 
1.8.3.1


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

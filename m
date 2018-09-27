Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 207B32114B12D
 for <linux-nvdimm@lists.01.org>; Wed, 26 Sep 2018 17:58:52 -0700 (PDT)
Subject: [PATCH 5/5] libnvdimm: add documentation for ovewrite
From: Dave Jiang <dave.jiang@intel.com>
Date: Wed, 26 Sep 2018 17:58:51 -0700
Message-ID: <153800993154.57703.11911501312141795934.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <153800975246.57703.6532101433026481472.stgit@djiang5-desk3.ch.intel.com>
References: <153800975246.57703.6532101433026481472.stgit@djiang5-desk3.ch.intel.com>
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
To: dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Add overwrite command usages  to security documentation.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 Documentation/nvdimm/security.txt |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/Documentation/nvdimm/security.txt b/Documentation/nvdimm/security.txt
index 50cbb6cb96a1..ded5f0e3f7c3 100644
--- a/Documentation/nvdimm/security.txt
+++ b/Documentation/nvdimm/security.txt
@@ -91,6 +91,17 @@ its keyid should be passed in via sysfs.
 The command format for doing a secure erase is:
 erase <old keyid>
 
+9. Overwrite
+------------
+The command format for doing an overwrite is:
+overwrite <old keyid>
+
+Overwrite can be done without a key if security is not enabled. A key serial
+of 0 can be passed in to indicate no key.
+
+The sysfs attribute "security" can be polled to wait on overwrite completion.
+Overwrite can last tens of minutes or more depending on nvdimm size.
+
 An "old" key with the passphrase payload that is tied to the nvdimm should be
 injected with a key description that does not have the "nvdimm:" prefix and
 its keyid should be passed in via sysfs.

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

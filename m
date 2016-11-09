Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5DF6D81CC5
 for <linux-nvdimm@lists.01.org>; Wed,  9 Nov 2016 13:16:21 -0800 (PST)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 1/2] ndctl: add information about size suffixes to docs
Date: Wed,  9 Nov 2016 14:16:16 -0700
Message-Id: <1478726177-21904-1-git-send-email-ross.zwisler@linux.intel.com>
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
To: Dan Williams <dan.j.williams@intel.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Add information about the supported size suffixes to the documentation for
ndctl-create-namespace.  This prevents users from doing silly things like
$((32*1024*1024*1024)) on the command line when running ndctl commands.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 Documentation/ndctl-create-namespace.txt | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/Documentation/ndctl-create-namespace.txt b/Documentation/ndctl-create-namespace.txt
index a2f5e5b..5b62b95 100644
--- a/Documentation/ndctl-create-namespace.txt
+++ b/Documentation/ndctl-create-namespace.txt
@@ -79,8 +79,10 @@ OPTIONS
 -s::
 --size=::
 	For NVDIMM devices that support namespace labels, set the
-	namespace size.  Otherwise it defaults to the maximum size
-	specified by platform firmware.
+	namespace size in bytes.  Otherwise it defaults to the maximum
+	size specified by platform firmware.  This option supports the
+	suffixes "k" or "K" for KiB, "m" or "M" for MiB, "g" or "G" for
+	GiB and "t" or "T" for TiB.
 
 -e::
 --reconfig=::
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

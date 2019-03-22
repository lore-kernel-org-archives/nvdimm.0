Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3A541211E9593
 for <linux-nvdimm@lists.01.org>; Fri, 22 Mar 2019 16:50:20 -0700 (PDT)
Subject: [PATCH 1/2] ndctl: add warning about overwrite taking a long time
From: Dave Jiang <dave.jiang@intel.com>
Date: Fri, 22 Mar 2019 16:50:19 -0700
Message-ID: <155329861947.65870.13816593912382889728.stgit@djiang5-desk3.ch.intel.com>
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
To: vishal.l.verma@intel.com, dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Add warning note in man page that overwrite may take a long time to
execute.

Suggested-by: Robert Elliot <elliott@hpe.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 Documentation/ndctl/ndctl-sanitize-dimm.txt |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/ndctl/ndctl-sanitize-dimm.txt b/Documentation/ndctl/ndctl-sanitize-dimm.txt
index 797820dd..ebf4b995 100644
--- a/Documentation/ndctl/ndctl-sanitize-dimm.txt
+++ b/Documentation/ndctl/ndctl-sanitize-dimm.txt
@@ -49,7 +49,8 @@ include::xable-dimm-options.txt[]
 	Wipe the entire DIMM, including label data. This can take significant
 	time, and the command is non-blocking. With this option, the overwrite
 	request is merely submitted to the NVDIMM, and the completion is
-	asynchronous.
+	asynchronous. Depending on the medium and capacity, overwrite may take
+	tens of minutes to many hours.
 
 -m::
 --master_passphrase::

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

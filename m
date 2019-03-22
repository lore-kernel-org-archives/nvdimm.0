Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 77F93211E9593
 for <linux-nvdimm@lists.01.org>; Fri, 22 Mar 2019 16:50:25 -0700 (PDT)
Subject: [PATCH 2/2] ndctl: fix typo mistake for ndctl-sanitize-dimm
From: Dave Jiang <dave.jiang@intel.com>
Date: Fri, 22 Mar 2019 16:50:24 -0700
Message-ID: <155329862481.65870.9187421973976670178.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <155329861947.65870.13816593912382889728.stgit@djiang5-desk3.ch.intel.com>
References: <155329861947.65870.13816593912382889728.stgit@djiang5-desk3.ch.intel.com>
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

correct master_passphrase to master-passphrase

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 Documentation/ndctl/ndctl-sanitize-dimm.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/ndctl/ndctl-sanitize-dimm.txt b/Documentation/ndctl/ndctl-sanitize-dimm.txt
index ebf4b995..91abf471 100644
--- a/Documentation/ndctl/ndctl-sanitize-dimm.txt
+++ b/Documentation/ndctl/ndctl-sanitize-dimm.txt
@@ -53,7 +53,7 @@ include::xable-dimm-options.txt[]
 	tens of minutes to many hours.
 
 -m::
---master_passphrase::
+--master-passphrase::
 	Indicate that we are using the master passphrase to perform the erase.
 	This only is applicable to the 'crypto-erase' option.
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

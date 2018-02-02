Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 82FFE2237A4CD
 for <linux-nvdimm@lists.01.org>; Fri,  2 Feb 2018 15:42:02 -0800 (PST)
Subject: [PATCH] ndctl: add options to update firmware manpage
From: Dave Jiang <dave.jiang@intel.com>
Date: Fri, 02 Feb 2018 16:47:40 -0700
Message-ID: <151761526035.7565.535231308729807997.stgit@djiang5-desk3.ch.intel.com>
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
To: vishal.l.verma@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

update firmware is missing the long/short option in the manpage. Adding
the missing sections.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 Documentation/ndctl/ndctl-update-firmware.txt |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/Documentation/ndctl/ndctl-update-firmware.txt b/Documentation/ndctl/ndctl-update-firmware.txt
index d742302..dd90612 100644
--- a/Documentation/ndctl/ndctl-update-firmware.txt
+++ b/Documentation/ndctl/ndctl-update-firmware.txt
@@ -10,6 +10,23 @@ SYNOPSIS
 [verse]
 'ndctl update-firmware' -f <firmware_file> -d <dimm name>
 
+EXAMPLES
+--------
+
+Updating DIMM nmem0 with firmware file name firmwarefile.bin.
+[verse]
+ndctl update-firmware -f firmwarefile.bin -d nmem0
+
+OPTIONS
+-------
+-f::
+--firmware=::
+	The path and name of the firmware file to be updated.
+
+-d::
+--dimm=::
+	The DIMM name to be updated.
+
 COPYRIGHT
 ---------
 Copyright (c) 2016 - 2017, Intel Corporation. License GPLv2: GNU GPL

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

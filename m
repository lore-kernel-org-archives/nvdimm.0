Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3F79221E08115
 for <linux-nvdimm@lists.01.org>; Thu, 19 Apr 2018 08:11:37 -0700 (PDT)
From: Takashi Iwai <tiwai@suse.de>
Subject: [PATCH ndctl v2 1/3] Documentation: fix title and section markers
Date: Thu, 19 Apr 2018 17:11:18 +0200
Message-Id: <20180419151120.11041-2-tiwai@suse.de>
In-Reply-To: <20180419151120.11041-1-tiwai@suse.de>
References: <20180419151120.11041-1-tiwai@suse.de>
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
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

The length of the title and section marker has to be aligned with the
previous line.  This was caught when running asciidoctor, which is
more strict than asciidoc.

Also since asciidoctor doesn't like the verse block in some cases,
replace the code examples with simpler markers.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 Documentation/daxctl/daxctl-list.txt        | 13 +++++++------
 Documentation/ndctl/ndctl-disable-dimm.txt  |  2 +-
 Documentation/ndctl/ndctl-enable-region.txt |  2 +-
 Documentation/ndctl/ndctl-init-labels.txt   | 15 ++++++++++-----
 Documentation/ndctl/ndctl-list.txt          | 13 ++++++++-----
 Documentation/ndctl/ndctl-start-scrub.txt   |  6 ++++--
 Documentation/ndctl/ndctl-wait-scrub.txt    |  6 ++++--
 7 files changed, 35 insertions(+), 22 deletions(-)

diff --git a/Documentation/daxctl/daxctl-list.txt b/Documentation/daxctl/daxctl-list.txt
index 99ca4a1b4f28..cb82c3cc6fb2 100644
--- a/Documentation/daxctl/daxctl-list.txt
+++ b/Documentation/daxctl/daxctl-list.txt
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 
 daxctl-list(1)
-=============
+==============
 
 NAME
 ----
@@ -24,10 +24,9 @@ daxctl list --devices
 
 EXAMPLE
 -------
-[verse]
+----
 # daxctl list --regions --devices
 
-["literal"]
 {
   "id":1,
   "devices":[
@@ -37,6 +36,7 @@ EXAMPLE
     }
   ]
 }
+----
 
 OPTIONS
 -------
@@ -54,14 +54,14 @@ OPTIONS
 	tuple, or keyword 'all' to filter the listing. For
 	example to list the first device instance in region1:
 
-[verse]
+----
 # daxctl list --dev=1.0
 
-["literal"]
 {
   "chardev":"dax1.0",
   "size":3233808384
 }
+----
 
 -D::
 --devices::
@@ -82,7 +82,7 @@ OPTIONS
 	will be formatted as human readable strings with units, other
 	fields are converted to hexadecimal strings.  Example:
 
-[verse]
+----
 # daxctl list
 {
   "chardev":"dax1.0",
@@ -94,5 +94,6 @@ OPTIONS
   "chardev":"dax1.0",
   "size":"30.57 GiB (32.83 GB)"
 }
+----
 
 include::../copyright.txt[]
diff --git a/Documentation/ndctl/ndctl-disable-dimm.txt b/Documentation/ndctl/ndctl-disable-dimm.txt
index d5a8d19966cf..7706ac351abc 100644
--- a/Documentation/ndctl/ndctl-disable-dimm.txt
+++ b/Documentation/ndctl/ndctl-disable-dimm.txt
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 
 ndctl-disable-dimm(1)
-=======================
+=====================
 
 NAME
 ----
diff --git a/Documentation/ndctl/ndctl-enable-region.txt b/Documentation/ndctl/ndctl-enable-region.txt
index 6c4ad9fefb0a..e5cbddbe6cf7 100644
--- a/Documentation/ndctl/ndctl-enable-region.txt
+++ b/Documentation/ndctl/ndctl-enable-region.txt
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 
 ndctl-enable-region(1)
-====================
+======================
 
 NAME
 ----
diff --git a/Documentation/ndctl/ndctl-init-labels.txt b/Documentation/ndctl/ndctl-init-labels.txt
index 580d82aa99cf..736d52d03cab 100644
--- a/Documentation/ndctl/ndctl-init-labels.txt
+++ b/Documentation/ndctl/ndctl-init-labels.txt
@@ -26,7 +26,7 @@ the DIMM.
 EXAMPLE
 -------
 Find the DIMMs that comprise a given region:
-[verse]
+----
 # ndctl list -RD --region=region1
 {
   "dimms":[
@@ -51,23 +51,28 @@ Find the DIMMs that comprise a given region:
     }
   ]
 }
+----
 
 Disable that region so the DIMM label area can be written from
 userspace:
-[verse]
+----
 # ndctl disable-region region1
+----
 
 Initialize labels:
-[verse]
+----
 # ndctl init-labels nmem0
+----
 
 Re-enable the region:
-[verse]
+----
 # ndctl enable-region region1
+----
 
 Create a namespace in that region:
-[verse]
+----
 # ndctl create-namespace --region=region1
+----
 
 OPTIONS
 -------
diff --git a/Documentation/ndctl/ndctl-list.txt b/Documentation/ndctl/ndctl-list.txt
index 2abc572a6ad5..13ebdcdd55ff 100644
--- a/Documentation/ndctl/ndctl-list.txt
+++ b/Documentation/ndctl/ndctl-list.txt
@@ -23,10 +23,9 @@ ndctl list --namespaces --bus=all --region=all
 
 EXAMPLE
 -------
-[verse]
+----
 # ndctl list --buses --namespaces
 
-["literal"]
 {
   "provider":"nfit_test.1",
   "dev":"ndbus2",
@@ -55,6 +54,7 @@ EXAMPLE
     }
   ]
 }
+----
 
 OPTIONS
 -------
@@ -67,8 +67,9 @@ include::xable-region-options.txt[]
 	An 'nmemX' device name, or dimm id number. Filter listing by
 	devices that reference the given dimm. For example to see all
 	namespaces comprised of storage capacity on nmem0:
-[verse]
+----
 # ndctl list --dimm=nmem0 --namespaces
+----
 
 -n::
 --namespace=::
@@ -201,7 +202,7 @@ include::xable-region-options.txt[]
 
 include::human-option.txt[]
 
-[verse]
+----
 # ndctl list --region=7
 {
   "dev":"region7",
@@ -211,8 +212,9 @@ include::human-option.txt[]
   "iset_id":-6382611090938810793,
   "badblock_count":8
 }
+----
 
-[verse]
+----
 # ndctl list --human --region=7
 {
   "dev":"region7",
@@ -222,6 +224,7 @@ include::human-option.txt[]
   "iset_id":"0xa76c6907811fae57",
   "badblock_count":8
 }
+----
 
 include::../copyright.txt[]
 
diff --git a/Documentation/ndctl/ndctl-start-scrub.txt b/Documentation/ndctl/ndctl-start-scrub.txt
index 365918dec920..eb49fc28e9bc 100644
--- a/Documentation/ndctl/ndctl-start-scrub.txt
+++ b/Documentation/ndctl/ndctl-start-scrub.txt
@@ -24,7 +24,7 @@ EXAMPLE
 -------
 Start a scrub on all nvdimm buses in the system. The json listing report
 only includes the buses that support ARS operations.
-[verse]
+----
 
 # ndctl start-scrub
 [
@@ -39,12 +39,14 @@ only includes the buses that support ARS operations.
     "scrub_state":"active"
   }
 ]
+----
 
 When specifying an individual bus, or if there is only one bus in the
 system, the command reports whether ARS support is available.
-[verse]
+----
 # ndctl start-scrub e820
 error starting scrub: Operation not supported
+----
 
 OPTIONS
 -------
diff --git a/Documentation/ndctl/ndctl-wait-scrub.txt b/Documentation/ndctl/ndctl-wait-scrub.txt
index 6b5f61fcf48f..9aef68704d6b 100644
--- a/Documentation/ndctl/ndctl-wait-scrub.txt
+++ b/Documentation/ndctl/ndctl-wait-scrub.txt
@@ -25,7 +25,7 @@ EXAMPLE
 -------
 Wait for scrub on all nvdimm buses in the system. The json listing
 report at the end only includes the buses that support ARS operations.
-[verse]
+----
 # ndctl wait-scrub
 [
   {
@@ -39,12 +39,14 @@ report at the end only includes the buses that support ARS operations.
     "scrub_state":"idle"
   }
 ]
+----
 
 When specifying an individual bus, or if there is only one bus in the
 system, the command reports whether ARS support is available.
-[verse]
+----
 # ndctl wait-scrub e820
 error waiting for scrub completion: Operation not supported
+----
 
 OPTIONS
 -------
-- 
2.16.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

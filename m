Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2CE40226516D4
 for <linux-nvdimm@lists.01.org>; Thu, 12 Apr 2018 04:08:06 -0700 (PDT)
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
 by mx2.suse.de (Postfix) with ESMTP id AA23FADF9
 for <linux-nvdimm@lists.01.org>; Thu, 12 Apr 2018 11:08:03 +0000 (UTC)
From: Takashi Iwai <tiwai@suse.de>
Subject: [PATCH ndctl 1/2] Documentation: fix title and section markers
Date: Thu, 12 Apr 2018 13:07:54 +0200
Message-Id: <20180412110755.31644-2-tiwai@suse.de>
In-Reply-To: <20180412110755.31644-1-tiwai@suse.de>
References: <20180412110755.31644-1-tiwai@suse.de>
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
 Documentation/daxctl/daxctl-io.txt          |    5 +++--
 Documentation/daxctl/daxctl-list.txt        |   13 +++++++------
 Documentation/ndctl/ndctl-disable-dimm.txt  |    2 +-
 Documentation/ndctl/ndctl-enable-region.txt |    2 +-
 Documentation/ndctl/ndctl-init-labels.txt   |   15 ++++++++++-----
 Documentation/ndctl/ndctl-list.txt          |   13 ++++++++-----
 6 files changed, 30 insertions(+), 20 deletions(-)

--- a/Documentation/ndctl/ndctl-init-labels.txt
+++ b/Documentation/ndctl/ndctl-init-labels.txt
@@ -24,7 +24,7 @@ the DIMM.
 EXAMPLE
 -------
 Find the DIMMs that comprise a given region:
-[verse]
+----
 # ndctl list -RD --region=region1
 {
   "dimms":[
@@ -49,23 +49,28 @@ Find the DIMMs that comprise a given reg
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
--- a/Documentation/ndctl/ndctl-disable-dimm.txt
+++ b/Documentation/ndctl/ndctl-disable-dimm.txt
@@ -1,5 +1,5 @@
 ndctl-disable-dimm(1)
-=======================
+=====================
 
 NAME
 ----
--- a/Documentation/ndctl/ndctl-enable-region.txt
+++ b/Documentation/ndctl/ndctl-enable-region.txt
@@ -1,5 +1,5 @@
 ndctl-enable-region(1)
-====================
+======================
 
 NAME
 ----
--- a/Documentation/daxctl/daxctl-io.txt
+++ b/Documentation/daxctl/daxctl-io.txt
@@ -1,5 +1,5 @@
 daxctl-io(1)
-===========
+============
 
 NAME
 ----
@@ -25,7 +25,7 @@ will be performed.
 
 EXAMPLE
 -------
-[verse]
+----
 # daxctl io --zero /dev/dax1.0
 
 # daxctl io --input=/dev/dax1.0 --output=/home/myfile --len=2M --seek=4096
@@ -33,6 +33,7 @@ EXAMPLE
 # cat /dev/zero | daxctl io --output=/dev/dax1.0
 
 # daxctl io --input=/dev/zero --output=/dev/dax1.0 --skip=4096
+----
 
 OPTIONS
 -------
--- a/Documentation/daxctl/daxctl-list.txt
+++ b/Documentation/daxctl/daxctl-list.txt
@@ -1,5 +1,5 @@
 daxctl-list(1)
-=============
+==============
 
 NAME
 ----
@@ -22,10 +22,9 @@ daxctl list --devices
 
 EXAMPLE
 -------
-[verse]
+----
 # daxctl list --regions --devices
 
-["literal"]
 {
   "id":1,
   "devices":[
@@ -35,6 +34,7 @@ EXAMPLE
     }
   ]
 }
+----
 
 OPTIONS
 -------
@@ -52,14 +52,14 @@ OPTIONS
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
@@ -80,7 +80,7 @@ OPTIONS
 	will be formatted as human readable strings with units, other
 	fields are converted to hexadecimal strings.  Example:
 
-[verse]
+----
 # daxctl list
 {
   "chardev":"dax1.0",
@@ -92,6 +92,7 @@ OPTIONS
   "chardev":"dax1.0",
   "size":"30.57 GiB (32.83 GB)"
 }
+----
 
 COPYRIGHT
 ---------
--- a/Documentation/ndctl/ndctl-list.txt
+++ b/Documentation/ndctl/ndctl-list.txt
@@ -21,10 +21,9 @@ ndctl list --namespaces --bus=all --regi
 
 EXAMPLE
 -------
-[verse]
+----
 # ndctl list --buses --namespaces
 
-["literal"]
 {
   "provider":"nfit_test.1",
   "dev":"ndbus2",
@@ -53,6 +52,7 @@ EXAMPLE
     }
   ]
 }
+----
 
 OPTIONS
 -------
@@ -65,8 +65,9 @@ include::xable-region-options.txt[]
 	An 'nmemX' device name, or dimm id number. Filter listing by
 	devices that reference the given dimm. For example to see all
 	namespaces comprised of storage capacity on nmem0:
-[verse]
+----
 # ndctl list --dimm=nmem0 --namespaces
+----
 
 -n::
 --namespace=::
@@ -182,7 +183,7 @@ include::xable-region-options.txt[]
 
 include::human-option.txt[]
 
-[verse]
+----
 # ndctl list --region=7
 {
   "dev":"region7",
@@ -192,8 +193,9 @@ include::human-option.txt[]
   "iset_id":-6382611090938810793,
   "badblock_count":8
 }
+----
 
-[verse]
+----
 # ndctl list --human --region=7
 {
   "dev":"region7",
@@ -203,6 +205,7 @@ include::human-option.txt[]
   "iset_id":"0xa76c6907811fae57",
   "badblock_count":8
 }
+----
 
 COPYRIGHT
 ---------
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

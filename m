Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 01B2D81B11
 for <linux-nvdimm@lists.01.org>; Mon,  9 Jan 2017 17:11:57 -0800 (PST)
Subject: [PATCH 5/9] daxctl, list: add man page
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 09 Jan 2017 17:07:51 -0800
Message-ID: <148401047150.16217.7015648387163654132.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <148401044568.16217.6942951063735168785.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <148401044568.16217.6942951063735168785.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Document the 'daxctl list' command which emits the details of the
Device-DAX regions and device instances in the system:

  # daxctl list -DRi
  {
    "id":1,
    "devices":[
      {
        "chardev":"dax1.0",
        "size":3233808384
      }
    ]
  }

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 Documentation/Makefile.am     |    3 +-
 Documentation/daxctl-list.txt |   78 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 80 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/daxctl-list.txt

diff --git a/Documentation/Makefile.am b/Documentation/Makefile.am
index adcc9e7dde8e..6daeb5621af0 100644
--- a/Documentation/Makefile.am
+++ b/Documentation/Makefile.am
@@ -12,7 +12,8 @@ man1_MANS = \
 	ndctl-disable-namespace.1 \
 	ndctl-create-namespace.1 \
 	ndctl-destroy-namespace.1 \
-	ndctl-list.1
+	ndctl-list.1 \
+	daxctl-list.1
 
 CLEANFILES = $(man1_MANS)
 
diff --git a/Documentation/daxctl-list.txt b/Documentation/daxctl-list.txt
new file mode 100644
index 000000000000..168d410d12d8
--- /dev/null
+++ b/Documentation/daxctl-list.txt
@@ -0,0 +1,78 @@
+daxctl-list(1)
+=============
+
+NAME
+----
+daxctl-list - dump the platform Device-DAX regions, devices, and
+attributes in json.
+
+SYNOPSIS
+--------
+[verse]
+'daxctl list' [<options>]
+
+Walk all the device-dax-regions in the system and list all device
+instances along with some of their major attributes.
+
+Options can be specified to limit the output to objects of a certain
+class.  Where the classes are regions or devices.  By default, 'daxctl
+list' with no options is equivalent to:
+[verse]
+daxctl list --devices
+
+EXAMPLE
+-------
+[verse]
+# daxctl list --regions --devices
+
+["literal"]
+{
+  "id":1,
+  "devices":[
+    {
+      "chardev":"dax1.0",
+      "size":3233808384
+    }
+  ]
+}
+
+OPTIONS
+-------
+-r::
+--region=::
+	A device-dax region is a contiguous range of memory that
+	hosts one or more /dev/daxX.Y devices, where X is the region id
+	and Y is the device instance id. The keyword 'all' can be
+	specified to carry out the operation on every region in the
+	system.
+
+-d::
+--dev=::
+	Specify a dax device name, <region id>.<instance id>
+	tuple, or keyword 'all' to filter the listing. For
+	example to list the first device instance in region1:
+
+[verse]
+# daxctl list --dev=1.0
+
+["literal"]
+{
+  "chardev":"dax1.0",
+  "size":3233808384
+}
+
+-D::
+--devices::
+	Include device-dax instance info in the listing (default)
+
+-R::
+--regions::
+	Include region info in the listing
+
+-R::
+--regions::
+	Include region info in the listing
+
+-i::
+--idle::
+	Include idle (not enabled / zero-sized) devices in the listing

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

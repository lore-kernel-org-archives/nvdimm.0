Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8605A460
	for <nvdimm@lists.linux.dev>; Thu,  8 Dec 2022 21:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670534926; x=1702070926;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qXvelEiMTwbukozXF2WtDA7ys4aAkyA6mP/fqPxLdHc=;
  b=CbzwZCeoCdEWYmQhTvYhdboZwJS3IQ9P+rZXX6vrVB/pb0ursdehSmei
   zNziUKPZnZPXPu1jPpbg8372DxGRx/TTG24vIe1JhMr58XC85XTlMPmEE
   fyPZHxTrr3WJbYwzD0e+0GC+UwEXTYuHXAK/0LyPXiGnmBFlYu27ZuSkz
   Ku9yc6FLHhzE9+Qy3+ra3el27mojDsbB6l9I1QVGyoucWD4WabG+ILidU
   wZIfS2HLVeRk2ZYKL67ElVloYns/IklbET+Y3G1ivPHX7gcAPKCm296IC
   XaoyXhJqYHAGWTZ72/sqfsveqmqBW8S/fgugrxG3j7Q1js+0svAhlSHUJ
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="319170344"
X-IronPort-AV: E=Sophos;i="5.96,228,1665471600"; 
   d="scan'208";a="319170344"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 13:28:46 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="753756139"
X-IronPort-AV: E=Sophos;i="5.96,228,1665471600"; 
   d="scan'208";a="753756139"
Received: from kputnam-mobl1.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.251.25.149])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 13:28:45 -0800
Subject: [ndctl PATCH v2 08/18] cxl/list: Skip emitting pmem_size when it is
 zero
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: Alison Schofield <alison.schofield@intel.com>, vishal.l.verma@intel.com,
 nvdimm@lists.linux.dev, vishal.l.verma@intel.com
Date: Thu, 08 Dec 2022 13:28:45 -0800
Message-ID: <167053492504.582963.9545867906512429034.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <167053487710.582963.17616889985000817682.stgit@dwillia2-xfh.jf.intel.com>
References: <167053487710.582963.17616889985000817682.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

The typical case is that CXL devices are pure ram devices. Only emit
capacity sizes when they are non-zero to avoid confusion around whether
pmem is available via partitioning or not.

The confusion being that a user may assign more meaning to the zero size
value than it actually deserves. A zero value for either pmem or ram,
doesn't indicate the devices capability for either mode.  Use the -I
option to cxl list to include paritition info in the memdev listing.
That will explicitly show the ram and pmem capabilities of the device.

Do the same for ram_size on the odd case that someone builds a pure pmem
device.

Cc: Alison Schofield <alison.schofield@intel.com>
[alison: clarify changelog]
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 Documentation/cxl/cxl-list.txt |    5 -----
 cxl/json.c                     |   20 +++++++++++++-------
 2 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/Documentation/cxl/cxl-list.txt b/Documentation/cxl/cxl-list.txt
index 14a2b4bb5c2a..56229abcb053 100644
--- a/Documentation/cxl/cxl-list.txt
+++ b/Documentation/cxl/cxl-list.txt
@@ -70,7 +70,6 @@ configured.
 {
   "memdev":"mem0",
   "pmem_size":"256.00 MiB (268.44 MB)",
-  "ram_size":0,
   "serial":"0",
   "host":"0000:35:00.0"
 }
@@ -88,7 +87,6 @@ EXAMPLE
   {
     "memdev":"mem0",
     "pmem_size":268435456,
-    "ram_size":0,
     "serial":0,
     "host":"0000:35:00.0"
   }
@@ -101,7 +99,6 @@ EXAMPLE
       {
         "memdev":"mem0",
         "pmem_size":"256.00 MiB (268.44 MB)",
-        "ram_size":0,
         "serial":"0"
       }
     ]
@@ -129,7 +126,6 @@ OPTIONS
   {
     "memdev":"mem0",
     "pmem_size":268435456,
-    "ram_size":0,
     "serial":0
   },
   {
@@ -204,7 +200,6 @@ OPTIONS
 [
   {
     "memdev":"mem0",
-    "pmem_size":0,
     "ram_size":273535729664,
     "partition_info":{
       "total_size":273535729664,
diff --git a/cxl/json.c b/cxl/json.c
index 2f3639ede2f8..292e8428ccee 100644
--- a/cxl/json.c
+++ b/cxl/json.c
@@ -305,7 +305,7 @@ struct json_object *util_cxl_memdev_to_json(struct cxl_memdev *memdev,
 {
 	const char *devname = cxl_memdev_get_devname(memdev);
 	struct json_object *jdev, *jobj;
-	unsigned long long serial;
+	unsigned long long serial, size;
 	int numa_node;
 
 	jdev = json_object_new_object();
@@ -316,13 +316,19 @@ struct json_object *util_cxl_memdev_to_json(struct cxl_memdev *memdev,
 	if (jobj)
 		json_object_object_add(jdev, "memdev", jobj);
 
-	jobj = util_json_object_size(cxl_memdev_get_pmem_size(memdev), flags);
-	if (jobj)
-		json_object_object_add(jdev, "pmem_size", jobj);
+	size = cxl_memdev_get_pmem_size(memdev);
+	if (size) {
+		jobj = util_json_object_size(size, flags);
+		if (jobj)
+			json_object_object_add(jdev, "pmem_size", jobj);
+	}
 
-	jobj = util_json_object_size(cxl_memdev_get_ram_size(memdev), flags);
-	if (jobj)
-		json_object_object_add(jdev, "ram_size", jobj);
+	size = cxl_memdev_get_ram_size(memdev);
+	if (size) {
+		jobj = util_json_object_size(size, flags);
+		if (jobj)
+			json_object_object_add(jdev, "ram_size", jobj);
+	}
 
 	if (flags & UTIL_JSON_HEALTH) {
 		jobj = util_cxl_memdev_health_to_json(memdev, flags);


Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C34C53A3
	for <nvdimm@lists.linux.dev>; Tue, 12 Jul 2022 19:08:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657652901; x=1689188901;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZvrC3mmiPP30mAag7bEeXLiQg6Z2z4V+u6rk/1eZaa0=;
  b=L68n6IaAGpON63pmNAUYoCcIN0SVe1ULhF2KOze1EXVMh++MBbt0txbs
   NbDgoYgQZ4+vD9KInU7FCsLjbYc7Rn4f+BnX1sSwfDxdqDNcGI8nofnPK
   Ec4x39ezs7ElwPsREihWzfGrya4LSAsJlxRsAtQzyDY8kLtuzuRlz+V0A
   tuhCESfRDHr5MhgGEfZDWnIRS0RhFDvlaGp5e+oHJC2D65Esp58sDxjD5
   0LhBL2f3vRNvA4IFZMGn+YRtybc9dgidhsgla+jWWlCCXTQCarSutPqk8
   Ko3/g5ysHHn7ExTo5gXrTkATYZXNduICGWy/7KDThK2Ef/v76IFz9v7I9
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10406"; a="348995695"
X-IronPort-AV: E=Sophos;i="5.92,266,1650956400"; 
   d="scan'208";a="348995695"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2022 12:08:10 -0700
X-IronPort-AV: E=Sophos;i="5.92,266,1650956400"; 
   d="scan'208";a="653039516"
Received: from sheyting-mobl3.amr.corp.intel.com (HELO [192.168.1.117]) ([10.212.147.156])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2022 12:08:10 -0700
Subject: [ndctl PATCH 08/11] cxl/set-partition: Accept 'ram' as an alias for
 'volatile'
From: Dan Williams <dan.j.williams@intel.com>
To: vishal.l.verma@intel.com
Cc: Alison Schofield <alison.schofield@intel.com>, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org
Date: Tue, 12 Jul 2022 12:08:09 -0700
Message-ID: <165765288979.435671.2636624998478988147.stgit@dwillia2-xfh>
In-Reply-To: <165765284365.435671.13173937566404931163.stgit@dwillia2-xfh>
References: <165765284365.435671.13173937566404931163.stgit@dwillia2-xfh>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

'ram' is a more convenient shorthand for volatile memory.

Cc: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 Documentation/cxl/cxl-set-partition.txt |    2 +-
 cxl/memdev.c                            |    4 +++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/Documentation/cxl/cxl-set-partition.txt b/Documentation/cxl/cxl-set-partition.txt
index 1e548af77da2..f0126daf808b 100644
--- a/Documentation/cxl/cxl-set-partition.txt
+++ b/Documentation/cxl/cxl-set-partition.txt
@@ -37,7 +37,7 @@ include::memdev-option.txt[]
 
 -t::
 --type=::
-	Type of partition, 'pmem' or 'volatile', to modify.
+	Type of partition, 'pmem' or 'ram' (volatile), to modify.
 	Default: 'pmem'
 
 -s::
diff --git a/cxl/memdev.c b/cxl/memdev.c
index 9fcd8ae5724b..1cecad2dba4b 100644
--- a/cxl/memdev.c
+++ b/cxl/memdev.c
@@ -65,7 +65,7 @@ OPT_BOOLEAN('f', "force", &param.force,                                \
 
 #define SET_PARTITION_OPTIONS() \
 OPT_STRING('t', "type",  &param.type, "type",			\
-	"'pmem' or 'volatile' (Default: 'pmem')"),		\
+	"'pmem' or 'ram' (volatile) (Default: 'pmem')"),		\
 OPT_STRING('s', "size",  &param.size, "size",			\
 	"size in bytes (Default: all available capacity)"),	\
 OPT_BOOLEAN('a', "align",  &param.align,			\
@@ -355,6 +355,8 @@ static int action_setpartition(struct cxl_memdev *memdev,
 			/* default */;
 		else if (strcmp(param.type, "volatile") == 0)
 			type = CXL_SETPART_VOLATILE;
+		else if (strcmp(param.type, "ram") == 0)
+			type = CXL_SETPART_VOLATILE;
 		else {
 			log_err(&ml, "invalid type '%s'\n", param.type);
 			return -EINVAL;


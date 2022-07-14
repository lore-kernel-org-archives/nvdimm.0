Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 699B66006
	for <nvdimm@lists.linux.dev>; Thu, 14 Jul 2022 17:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657818194; x=1689354194;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=d6ApsR6hlkYxBPeMgixmyfChQYOVY7n3l02N3ta4pdo=;
  b=jUpEHwEeyafuyPMYPizFpVaWdksqlyMlBHQ2sKAV3Iu2cv96IzTDo527
   ddJk2ytDul9IE4b7uZ9DmHaMenI7YtpRWGq133AK8Uk4nws88/FvR60nj
   nvBfvL+zW3kZRWpReMALJAIW8qpCv0UoOk4KmOdf8xVryfjrtV5+9/pe1
   KmeyMlv6nOdaBUGgKTLMj7WckwBC4jU0b5OLi6NVF332UaskS+M0e2ToJ
   pizS2o166bZT+28uL2lgNULIy68vO0hzB/WUXWG7818LujCg2pWzM8ui6
   dvxB1ZeaXMn1fKqp+ZbTkGRv5vj2XMxrSDlhcczZ7JldyDf4OpNLrVBVO
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10408"; a="284331850"
X-IronPort-AV: E=Sophos;i="5.92,271,1650956400"; 
   d="scan'208";a="284331850"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2022 10:02:39 -0700
X-IronPort-AV: E=Sophos;i="5.92,271,1650956400"; 
   d="scan'208";a="593438298"
Received: from jlcone-mobl1.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.209.2.90])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2022 10:02:39 -0700
Subject: [ndctl PATCH v2 09/12] cxl/set-partition: Accept 'ram' as an alias
 for 'volatile'
From: Dan Williams <dan.j.williams@intel.com>
To: vishal.l.verma@intel.com
Cc: Alison Schofield <alison.schofield@intel.com>,
 Davidlohr Bueso <dave@stgolabs.net>, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org
Date: Thu, 14 Jul 2022 10:02:38 -0700
Message-ID: <165781815878.1555691.12251226240559355924.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <165781810717.1555691.1411727384567016588.stgit@dwillia2-xfh.jf.intel.com>
References: <165781810717.1555691.1411727384567016588.stgit@dwillia2-xfh.jf.intel.com>
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
Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
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


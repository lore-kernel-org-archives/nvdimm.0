Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1528A460
	for <nvdimm@lists.linux.dev>; Thu,  8 Dec 2022 21:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670534902; x=1702070902;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2gU+FCIDMTYBNsSr0cDrPz/tHZPBfxQbmub9NqW4knM=;
  b=WhMugn6n7na0h14pU/ads7t3z/q9UZOJkqYGAVIr96rzM2afu47fpLeK
   2YpnXjQs1IyTe5WMO2eA/2BXq0Fn2+6Ozy8HBNeJBXhDqTOtk47FobdaE
   LW9v51S/Kda7Uy2mD8lFcmL3xlzcblEJ3Jwj3rYauRt3H13xz6hOvDN5w
   4s84wKylK/Do8qQosKIVO3B6ZtvX0/N4GLw24nKQwHWxs2QhECe0/QnwF
   vhMHql1LctRSLQ7eItDwgUYtrRxpI0B3zAI6nRjiGu/YiqMSLbfYntKmv
   PszxUsXC8LHu6yZ3qP5YIxi3yDIpxcKti5gEQ+Jrjq+DWLiFaM6L3HzZX
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="318458776"
X-IronPort-AV: E=Sophos;i="5.96,228,1665471600"; 
   d="scan'208";a="318458776"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 13:28:22 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="976047111"
X-IronPort-AV: E=Sophos;i="5.96,228,1665471600"; 
   d="scan'208";a="976047111"
Received: from kputnam-mobl1.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.251.25.149])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 13:28:21 -0800
Subject: [ndctl PATCH v2 04/18] ndctl/clang-format: Fix space after for_each
 macros
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: vishal.l.verma@intel.com, alison.schofield@intel.com,
 nvdimm@lists.linux.dev, vishal.l.verma@intel.com
Date: Thu, 08 Dec 2022 13:28:21 -0800
Message-ID: <167053490140.582963.14276565576884840344.stgit@dwillia2-xfh.jf.intel.com>
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

Copy the approach taken in the kernel via:

commit 781121a7f6d1 ("clang-format: Fix space after for_each macros")

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 .clang-format |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/.clang-format b/.clang-format
index f372823c3248..448b7e7211ae 100644
--- a/.clang-format
+++ b/.clang-format
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 #
-# clang-format configuration file. Intended for clang-format >= 6.
+# clang-format configuration file. Intended for clang-format >= 11.
 # Copied from Linux's .clang-format
 #
 # For more information, see:
@@ -157,7 +157,7 @@ SpaceAfterTemplateKeyword: true
 SpaceBeforeAssignmentOperators: true
 SpaceBeforeCtorInitializerColon: true
 SpaceBeforeInheritanceColon: true
-SpaceBeforeParens: ControlStatements
+SpaceBeforeParens: ControlStatementsExceptForEachMacros
 SpaceBeforeRangeBasedForLoopColon: true
 SpaceInEmptyParentheses: false
 SpacesBeforeTrailingComments: 1


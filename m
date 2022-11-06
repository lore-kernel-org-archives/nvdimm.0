Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C978D500
	for <nvdimm@lists.linux.dev>; Sun,  6 Nov 2022 23:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667778430; x=1699314430;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2gU+FCIDMTYBNsSr0cDrPz/tHZPBfxQbmub9NqW4knM=;
  b=d8Q+bYON2gtFctVKxxteikEOjk90UUSSMFWQkedjFCTOYVsrS4wcpUKf
   WAFDONfhKQuTNCnEXqMv3VrowTYhoBVqGmF+E0vJ+DjfrFiaj/Ib5q63w
   /szt1sqVH0oNLCLi5U95l5DxyLt+xCU5x51T5Odj9t9Z9vXVCzUeQccL6
   HX4lEWc8HtRCy1V/bXlBeWDlus02bcxS6vNhCV8gcEVF3GcORVIzuDQBt
   RI77g0PAMPR3yEQgbdP7Cp09UgWKy3UPZOtcErCxkFAr5ohmwsuGCJnaw
   KnLILvikkWnvNHRoDy6ro0I9kihMynvHsj3282mg9dg58bzryqhES8g4m
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10523"; a="311422310"
X-IronPort-AV: E=Sophos;i="5.96,143,1665471600"; 
   d="scan'208";a="311422310"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2022 15:47:09 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10523"; a="964951379"
X-IronPort-AV: E=Sophos;i="5.96,143,1665471600"; 
   d="scan'208";a="964951379"
Received: from durgasin-mobl.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.212.240.219])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2022 15:47:09 -0800
Subject: [ndctl PATCH 04/15] ndctl/clang-format: Fix space after for_each
 macros
From: Dan Williams <dan.j.williams@intel.com>
To: vishal.l.verma@intel.com
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Date: Sun, 06 Nov 2022 15:47:08 -0800
Message-ID: <166777842874.1238089.4293045826403123016.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <166777840496.1238089.5601286140872803173.stgit@dwillia2-xfh.jf.intel.com>
References: <166777840496.1238089.5601286140872803173.stgit@dwillia2-xfh.jf.intel.com>
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


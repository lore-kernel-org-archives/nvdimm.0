Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C921D500
	for <nvdimm@lists.linux.dev>; Sun,  6 Nov 2022 23:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667778424; x=1699314424;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PmnMB0EJo7BqWBD1GuQkF9aVenGk+FT0gRp/npgZFcs=;
  b=drm0XIy7oAv7i1fk7Jdn12Ip1AIbToHLt+rMcL5nIQQR9fPbtuRI+dLH
   db3U6R8prJGeUMBGjKolgXANpMStFiifago44dsjJhM1iGhbKz/YpkylQ
   K3mFo/ilojexlMZDb37ctYf3vbZjJk7N/qrOitBJpvBBUehCx3UHH9OG2
   TpfaCM76FNFqdU9psMoBRvRW2WtUOy0pSShd+0DVuL/DTixbBJG2bqykk
   qMPjzAxZvLJ5XoZzW50pcsojMsmEVSqNQlOI5TgBzM+Pwi3mRE71ClP/B
   Cp93leCVk9qvPEbTegzKC4RBkl9/JhbaYntpliov1ymiefTj1qygeZ/EC
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10523"; a="374541045"
X-IronPort-AV: E=Sophos;i="5.96,143,1665471600"; 
   d="scan'208";a="374541045"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2022 15:47:03 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10523"; a="964951346"
X-IronPort-AV: E=Sophos;i="5.96,143,1665471600"; 
   d="scan'208";a="964951346"
Received: from durgasin-mobl.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.212.240.219])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2022 15:47:03 -0800
Subject: [ndctl PATCH 03/15] ndctl/clang-format: Move minimum version to 6
From: Dan Williams <dan.j.williams@intel.com>
To: vishal.l.verma@intel.com
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Date: Sun, 06 Nov 2022 15:47:03 -0800
Message-ID: <166777842304.1238089.14893633815148907315.stgit@dwillia2-xfh.jf.intel.com>
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

Follow the kernel change that did the same:

sed -i 's/^\(\s*\)#\(\S*\s\+\S*\) # Unknown to clang-format.*/\1\2/' .clang-format

commit 96232c7d4f84 ("clang-format: Update to clang-format >= 6")

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 .clang-format |   36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/.clang-format b/.clang-format
index b6169e15097c..f372823c3248 100644
--- a/.clang-format
+++ b/.clang-format
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 #
-# clang-format configuration file. Intended for clang-format >= 4.
+# clang-format configuration file. Intended for clang-format >= 6.
 # Copied from Linux's .clang-format
 #
 # For more information, see:
@@ -13,7 +13,7 @@ AccessModifierOffset: -4
 AlignAfterOpenBracket: Align
 AlignConsecutiveAssignments: false
 AlignConsecutiveDeclarations: false
-#AlignEscapedNewlines: Left # Unknown to clang-format-4.0
+AlignEscapedNewlines: Left
 AlignOperands: true
 AlignTrailingComments: false
 AllowAllParametersOfDeclarationOnNextLine: false
@@ -37,24 +37,24 @@ BraceWrapping:
   AfterObjCDeclaration: false
   AfterStruct: false
   AfterUnion: false
-  #AfterExternBlock: false # Unknown to clang-format-5.0
+  AfterExternBlock: false
   BeforeCatch: false
   BeforeElse: false
   IndentBraces: false
-  #SplitEmptyFunction: true # Unknown to clang-format-4.0
-  #SplitEmptyRecord: true # Unknown to clang-format-4.0
-  #SplitEmptyNamespace: true # Unknown to clang-format-4.0
+  SplitEmptyFunction: true
+  SplitEmptyRecord: true
+  SplitEmptyNamespace: true
 BreakBeforeBinaryOperators: None
 BreakBeforeBraces: Custom
-#BreakBeforeInheritanceComma: false # Unknown to clang-format-4.0
+BreakBeforeInheritanceComma: false
 BreakBeforeTernaryOperators: false
 BreakConstructorInitializersBeforeComma: false
-#BreakConstructorInitializers: BeforeComma # Unknown to clang-format-4.0
+BreakConstructorInitializers: BeforeComma
 BreakAfterJavaFieldAnnotations: false
 BreakStringLiterals: false
 ColumnLimit: 80
 CommentPragmas: '^ IWYU pragma:'
-#CompactNamespaces: false # Unknown to clang-format-4.0
+CompactNamespaces: false
 ConstructorInitializerAllOnOneLineOrOnePerLine: false
 ConstructorInitializerIndentWidth: 8
 ContinuationIndentWidth: 8
@@ -62,7 +62,7 @@ Cpp11BracedListStyle: false
 DerivePointerAlignment: false
 DisableFormat: false
 ExperimentalAutoDetectBinPacking: false
-#FixNamespaceComments: false # Unknown to clang-format-4.0
+FixNamespaceComments: false
 
 # Taken from:
 # while read -r sym; do
@@ -118,13 +118,13 @@ ForEachMacros:
   - 'ndctl_region_foreach'
   - 'udev_list_entry_foreach'
 
-#IncludeBlocks: Preserve # Unknown to clang-format-5.0
+IncludeBlocks: Preserve
 IncludeCategories:
   - Regex: '.*'
     Priority: 1
 IncludeIsMainRegex: '(Test)?$'
 IndentCaseLabels: false
-#IndentPPDirectives: None # Unknown to clang-format-5.0
+IndentPPDirectives: None
 IndentWidth: 8
 IndentWrappedFunctionNames: false
 JavaScriptQuotes: Leave
@@ -134,13 +134,13 @@ MacroBlockBegin: ''
 MacroBlockEnd: ''
 MaxEmptyLinesToKeep: 1
 NamespaceIndentation: None
-#ObjCBinPackProtocolList: Auto # Unknown to clang-format-5.0
+ObjCBinPackProtocolList: Auto
 ObjCBlockIndentWidth: 8
 ObjCSpaceAfterProperty: true
 ObjCSpaceBeforeProtocolList: true
 
 # Taken from git's rules
-#PenaltyBreakAssignment: 10 # Unknown to clang-format-4.0
+PenaltyBreakAssignment: 10
 PenaltyBreakBeforeFirstCallParameter: 30
 PenaltyBreakComment: 10
 PenaltyBreakFirstLessLess: 0
@@ -151,14 +151,14 @@ PenaltyReturnTypeOnItsOwnLine: 60
 PointerAlignment: Right
 ReflowComments: false
 SortIncludes: false
-#SortUsingDeclarations: false # Unknown to clang-format-4.0
+SortUsingDeclarations: false
 SpaceAfterCStyleCast: false
 SpaceAfterTemplateKeyword: true
 SpaceBeforeAssignmentOperators: true
-#SpaceBeforeCtorInitializerColon: true # Unknown to clang-format-5.0
-#SpaceBeforeInheritanceColon: true # Unknown to clang-format-5.0
+SpaceBeforeCtorInitializerColon: true
+SpaceBeforeInheritanceColon: true
 SpaceBeforeParens: ControlStatements
-#SpaceBeforeRangeBasedForLoopColon: true # Unknown to clang-format-5.0
+SpaceBeforeRangeBasedForLoopColon: true
 SpaceInEmptyParentheses: false
 SpacesBeforeTrailingComments: 1
 SpacesInAngles: false


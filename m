Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B937EA460
	for <nvdimm@lists.linux.dev>; Thu,  8 Dec 2022 21:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670534896; x=1702070896;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PmnMB0EJo7BqWBD1GuQkF9aVenGk+FT0gRp/npgZFcs=;
  b=DAtFqX+9VlEss3KNr6oVBRxNhmHQjbBi2ggJkQTuu3pQB0dLjvDpGmpl
   st9zHyaeeFgaKWGbGk1w8qE7pqoyD59OLgSj0dwOs3N2ltZmg4ELV7OV3
   J5BVpLHncVKC2c4/yowMQQSSxxSJBL4QZXU4a2+zIygiAyorNoUrwqzJm
   7RGyb/rn+PFRcWgjQdJSECVV5PuZnfQ3wx4BlVF3FWRNGFV+08WFP7uJu
   Xw5KfeBk4Oys81CMKbEC40EbIk1+Bdccz7QjnqfDqbh3ScBwlQU4G4dkj
   2BTENGNS3Y8oh0vxuOy4a4zv7O6FBwQhVPfHK3A5pU/QNPAFeDlh15QTL
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="318458759"
X-IronPort-AV: E=Sophos;i="5.96,228,1665471600"; 
   d="scan'208";a="318458759"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 13:28:16 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="976047069"
X-IronPort-AV: E=Sophos;i="5.96,228,1665471600"; 
   d="scan'208";a="976047069"
Received: from kputnam-mobl1.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.251.25.149])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 13:28:16 -0800
Subject: [ndctl PATCH v2 03/18] ndctl/clang-format: Move minimum version to 6
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: vishal.l.verma@intel.com, alison.schofield@intel.com,
 nvdimm@lists.linux.dev, vishal.l.verma@intel.com
Date: Thu, 08 Dec 2022 13:28:15 -0800
Message-ID: <167053489567.582963.2992876970826532169.stgit@dwillia2-xfh.jf.intel.com>
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


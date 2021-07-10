Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3D0117F
	for <nvdimm@lists.linux.dev>; Sat, 10 Jul 2021 01:12:44 +0000 (UTC)
Received: by mail-pl1-f175.google.com with SMTP id d1so697615plg.0
        for <nvdimm@lists.linux.dev>; Fri, 09 Jul 2021 18:12:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=B5P5PuZyafSwbyxbBKz7CUH21g9sFgp9pD+ZWs0x87I=;
        b=xV2Oduy2V5Vu8P+FKqV97cep3dEdhgM1joE4huw0PrHnZjnhkJfFRpI3JFPRnjzf8T
         39dwCBqPUboNJ/eOZePL6B2siymB808s3jtwII2jvf0TvCF6yzC3P3A/1czEedDPQd+7
         WHXoK9dhH1k569s0rmECDQZqorFecxKKf/AcyK3nMOOdEPAWNKrsrZ+PvM9vkYWl3i/w
         K/Xcudo4dZXxOBExl11D3E9hehQj+gbkfxZXv0iFfeAFbFwmbv835CmuTKL/GcFqJZ17
         Fa7u0+S8Ia3oIxsDCdf3pCnokB37f4oB/+fPwyh73GDlmf2NfqmSCHMjkFYEaMfjsSHC
         xX9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=B5P5PuZyafSwbyxbBKz7CUH21g9sFgp9pD+ZWs0x87I=;
        b=l23Da0EarLAXw4eZAi4ns8A4f5dDbNN9jJG1F2DapwujvdUUARuChClTuSlbmkvqtH
         belrO9R+GkwatPPN+Y7zT9P3ASro8VSvD9w4FLGkxgyvgQ6x5fDaJLul2c8bYczvkjgN
         LDz78rsGeq8v+qPElm3mX98abhaBA/BdrJc/AIK5wzfnNbaDyNzpAvBS7FAjktMhAJj0
         nUITYz72xktElRRAJVP3nTAydJhkk6pS8BFYQpKYVjUr3gFFuGWkpfucAAoTq05PZ5z7
         5o2di3bIy7b5bYlQoVeyee0ZdeD/OkidhICrbw3tn9Rx4bKi4LPvLdGXhx/NJLxpbcJR
         JTZQ==
X-Gm-Message-State: AOAM532gt+V7xZSMQ+4ar5YZDaMNLOS5h1ZZiYdr6xq4LsDi8pbta6Gv
	v6YAHzt4we4uDQ3rlt/hpfPR5XpJn44gh+6Z53XIpA==
X-Google-Smtp-Source: ABdhPJy/rhpXWzoy9pK4K5Gver0TfYMBuJk7dyMx2xASR9/RDjjuVKhNcK74nYqPv+/HfMHSaccoAeuR3WHHCslhrVs=
X-Received: by 2002:a17:90a:8589:: with SMTP id m9mr1606514pjn.168.1625879564474;
 Fri, 09 Jul 2021 18:12:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210701201005.3065299-1-vishal.l.verma@intel.com> <20210701201005.3065299-2-vishal.l.verma@intel.com>
In-Reply-To: <20210701201005.3065299-2-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 9 Jul 2021 18:12:33 -0700
Message-ID: <CAPcyv4h8aD2ZOzySrzo2y96LNfuhxDp75RA+_YUWFFVHoO91Jg@mail.gmail.com>
Subject: Re: [ndctl PATCH v3 01/21] ndctl: add .clang-format
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, linux-cxl@vger.kernel.org, 
	Ben Widawsky <ben.widawsky@intel.com>, Alison Schofield <alison.schofield@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, Jul 1, 2021 at 1:10 PM Vishal Verma <vishal.l.verma@intel.com> wrote:
>
> Copy the Linux kernel's .clang-format and modify it for ndctl. Only the
> 'ForEachMacros' section has been modified from the original kernel copy.
>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Reported-by: Ben Widawsky <ben.widawsky@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

Nice!

Reviewed-by: Dan Williams <dan.j.williams@intel.com>


> ---
>  .clang-format | 161 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 161 insertions(+)
>  create mode 100644 .clang-format
>
> diff --git a/.clang-format b/.clang-format
> new file mode 100644
> index 0000000..4e00fff
> --- /dev/null
> +++ b/.clang-format
> @@ -0,0 +1,161 @@
> +# SPDX-License-Identifier: GPL-2.0
> +#
> +# clang-format configuration file. Intended for clang-format >= 4.
> +# Copied from Linux's .clang-format
> +#
> +# For more information, see:
> +#
> +#   https://clang.llvm.org/docs/ClangFormat.html
> +#   https://clang.llvm.org/docs/ClangFormatStyleOptions.html
> +#
> +---
> +AccessModifierOffset: -4
> +AlignAfterOpenBracket: Align
> +AlignConsecutiveAssignments: false
> +AlignConsecutiveDeclarations: false
> +#AlignEscapedNewlines: Left # Unknown to clang-format-4.0
> +AlignOperands: true
> +AlignTrailingComments: false
> +AllowAllParametersOfDeclarationOnNextLine: false
> +AllowShortBlocksOnASingleLine: false
> +AllowShortCaseLabelsOnASingleLine: false
> +AllowShortFunctionsOnASingleLine: None
> +AllowShortIfStatementsOnASingleLine: false
> +AllowShortLoopsOnASingleLine: false
> +AlwaysBreakAfterDefinitionReturnType: None
> +AlwaysBreakAfterReturnType: None
> +AlwaysBreakBeforeMultilineStrings: false
> +AlwaysBreakTemplateDeclarations: false
> +BinPackArguments: true
> +BinPackParameters: true
> +BraceWrapping:
> +  AfterClass: false
> +  AfterControlStatement: false
> +  AfterEnum: false
> +  AfterFunction: true
> +  AfterNamespace: true
> +  AfterObjCDeclaration: false
> +  AfterStruct: false
> +  AfterUnion: false
> +  #AfterExternBlock: false # Unknown to clang-format-5.0
> +  BeforeCatch: false
> +  BeforeElse: false
> +  IndentBraces: false
> +  #SplitEmptyFunction: true # Unknown to clang-format-4.0
> +  #SplitEmptyRecord: true # Unknown to clang-format-4.0
> +  #SplitEmptyNamespace: true # Unknown to clang-format-4.0
> +BreakBeforeBinaryOperators: None
> +BreakBeforeBraces: Custom
> +#BreakBeforeInheritanceComma: false # Unknown to clang-format-4.0
> +BreakBeforeTernaryOperators: false
> +BreakConstructorInitializersBeforeComma: false
> +#BreakConstructorInitializers: BeforeComma # Unknown to clang-format-4.0
> +BreakAfterJavaFieldAnnotations: false
> +BreakStringLiterals: false
> +ColumnLimit: 80
> +CommentPragmas: '^ IWYU pragma:'
> +#CompactNamespaces: false # Unknown to clang-format-4.0
> +ConstructorInitializerAllOnOneLineOrOnePerLine: false
> +ConstructorInitializerIndentWidth: 8
> +ContinuationIndentWidth: 8
> +Cpp11BracedListStyle: false
> +DerivePointerAlignment: false
> +DisableFormat: false
> +ExperimentalAutoDetectBinPacking: false
> +#FixNamespaceComments: false # Unknown to clang-format-4.0
> +
> +# Taken from:
> +# while read -r sym; do
> +#      printf "  - '%s'\n" "$sym";
> +# done < \
> +#      <(cscope -dL6 "foreach|for_each" \
> +#      | awk '{ print $4 $5 }' | grep -E 'foreach|for_each' \
> +#      | sed -e 's/#define//' \
> +#              -e 's/*//' \
> +#              -e 's/://' \
> +#              -e 's/\(.*for_each.*\)(.*/\1/' \
> +#              -e 's/\(.*foreach.*\)(.*/\1/' \
> +#      | sort -u)
> +ForEachMacros:
> +  - 'daxctl_dev_foreach'
> +  - 'daxctl_mapping_foreach'
> +  - 'daxctl_region_foreach'
> +  - 'kmod_list_foreach'
> +  - 'kmod_list_foreach_reverse'
> +  - 'list_for_each'
> +  - 'list_for_each_off'
> +  - 'list_for_each_rev'
> +  - 'list_for_each_safe'
> +  - 'list_for_each_safe_off'
> +  - 'ndctl_btt_foreach'
> +  - 'ndctl_btt_foreach_safe'
> +  - 'ndctl_bus_foreach'
> +  - 'ndctl_dax_foreach'
> +  - 'ndctl_dax_foreach_safe'
> +  - 'ndctl_dimm_foreach'
> +  - 'ndctl_dimm_foreach_in_interleave_set'
> +  - 'ndctl_dimm_foreach_in_region'
> +  - 'ndctl_interleave_set_foreach'
> +  - 'ndctl_mapping_foreach'
> +  - 'ndctl_namespace_badblock_foreach'
> +  - 'ndctl_namespace_bb_foreach'
> +  - 'ndctl_namespace_foreach'
> +  - 'ndctl_namespace_foreach_safe'
> +  - 'ndctl_pfn_foreach'
> +  - 'ndctl_pfn_foreach_safe'
> +  - 'ndctl_region_badblock_foreach'
> +  - 'ndctl_region_foreach'
> +  - 'udev_list_entry_foreach'
> +
> +#IncludeBlocks: Preserve # Unknown to clang-format-5.0
> +IncludeCategories:
> +  - Regex: '.*'
> +    Priority: 1
> +IncludeIsMainRegex: '(Test)?$'
> +IndentCaseLabels: false
> +#IndentPPDirectives: None # Unknown to clang-format-5.0
> +IndentWidth: 8
> +IndentWrappedFunctionNames: false
> +JavaScriptQuotes: Leave
> +JavaScriptWrapImports: true
> +KeepEmptyLinesAtTheStartOfBlocks: false
> +MacroBlockBegin: ''
> +MacroBlockEnd: ''
> +MaxEmptyLinesToKeep: 1
> +NamespaceIndentation: None
> +#ObjCBinPackProtocolList: Auto # Unknown to clang-format-5.0
> +ObjCBlockIndentWidth: 8
> +ObjCSpaceAfterProperty: true
> +ObjCSpaceBeforeProtocolList: true
> +
> +# Taken from git's rules
> +#PenaltyBreakAssignment: 10 # Unknown to clang-format-4.0
> +PenaltyBreakBeforeFirstCallParameter: 30
> +PenaltyBreakComment: 10
> +PenaltyBreakFirstLessLess: 0
> +PenaltyBreakString: 10
> +PenaltyExcessCharacter: 100
> +PenaltyReturnTypeOnItsOwnLine: 60
> +
> +PointerAlignment: Right
> +ReflowComments: false
> +SortIncludes: false
> +#SortUsingDeclarations: false # Unknown to clang-format-4.0
> +SpaceAfterCStyleCast: false
> +SpaceAfterTemplateKeyword: true
> +SpaceBeforeAssignmentOperators: true
> +#SpaceBeforeCtorInitializerColon: true # Unknown to clang-format-5.0
> +#SpaceBeforeInheritanceColon: true # Unknown to clang-format-5.0
> +SpaceBeforeParens: ControlStatements
> +#SpaceBeforeRangeBasedForLoopColon: true # Unknown to clang-format-5.0
> +SpaceInEmptyParentheses: false
> +SpacesBeforeTrailingComments: 1
> +SpacesInAngles: false
> +SpacesInContainerLiterals: false
> +SpacesInCStyleCastParentheses: false
> +SpacesInParentheses: false
> +SpacesInSquareBrackets: false
> +Standard: Cpp03
> +TabWidth: 8
> +UseTab: Always
> +...
> --
> 2.31.1
>

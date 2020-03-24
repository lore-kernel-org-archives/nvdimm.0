Return-Path: <SRS0=DFBX=5J=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49F88C10DCE
	for <linux-nvdimm@archiver.kernel.org>; Tue, 24 Mar 2020 05:21:04 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2804F2073E
	for <linux-nvdimm@archiver.kernel.org>; Tue, 24 Mar 2020 05:21:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2804F2073E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 3558610FC388E;
	Mon, 23 Mar 2020 22:21:54 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=134.134.136.24; helo=mga09.intel.com; envelope-from=vishal.l.verma@intel.com; receiver=<UNKNOWN> 
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id D53D210FC388D
	for <linux-nvdimm@lists.01.org>; Mon, 23 Mar 2020 22:21:51 -0700 (PDT)
IronPort-SDR: /Z750v19e/pZVt1MhZ5TRwhoWa54Q8CfQd4ZFCIDlSXLeAEszsJt+U0zw8W72d4Q+3LRCAdxxX
 F6ySYo96/Tnw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2020 22:21:01 -0700
IronPort-SDR: BvDaOJNTdFUGir7DwItvqXte20C6SoQtTJyL562nRCpW6o6vnUeKoMAyN8iCtaDRNovkaOn3e3
 zkiRfugZdOCg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,299,1580803200";
   d="scan'208";a="246420051"
Received: from fmsmsx106.amr.corp.intel.com ([10.18.124.204])
  by orsmga003.jf.intel.com with ESMTP; 23 Mar 2020 22:21:00 -0700
Received: from fmsmsx111.amr.corp.intel.com (10.18.116.5) by
 FMSMSX106.amr.corp.intel.com (10.18.124.204) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 23 Mar 2020 22:21:00 -0700
Received: from fmsmsx125.amr.corp.intel.com ([169.254.2.68]) by
 fmsmsx111.amr.corp.intel.com ([169.254.12.42]) with mapi id 14.03.0439.000;
 Mon, 23 Mar 2020 22:21:00 -0700
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
CC: "Williams, Dan J" <dan.j.williams@intel.com>
Subject: [ANNOUNCE] ndctl v68
Thread-Topic: [ANNOUNCE] ndctl v68
Thread-Index: AQHWAZwBACJaOpizC0i858vE3CtFCw==
Date: Tue, 24 Mar 2020 05:21:00 +0000
Message-ID: <9c68af5d0bbdaaf29165f970e2b5095d6c89c6ff.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.5 (3.32.5-1.fc30) 
x-originating-ip: [10.255.6.108]
Content-ID: <BEE034BEC677B349947396C620B10440@intel.com>
MIME-Version: 1.0
Message-ID-Hash: TZB7IXUL2ELKT7DJ7X4KKFZOUHKEYH4H
X-Message-ID-Hash: TZB7IXUL2ELKT7DJ7X4KKFZOUHKEYH4H
X-MailFrom: vishal.l.verma@intel.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/TZB7IXUL2ELKT7DJ7X4KKFZOUHKEYH4H/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This release incorporates functionality up to the 5.6 kernel.

Highlights for this release include new commands to read-infoblock and
write-infoblock, improvements and tests related to alignment
constraints, misc build/compilation related fixes, and misc usability
and documentation fixes.

The shortlog for this release is appended below:

Auke Kok (3):
      ndctl/build: Do not use `check-news` when `NEWS` file is absent entirely.
      ndctl/build: Ensure header and other misc files are listed.
      ndctl/build: Add `header` as a prereq to Make rule where it is consumed.

Dan Williams (39):
      ndctl/namespace: Clarify that 'reconfigure' == 'destroy+create'
      ndctl/namespace: Fixup man page indentation
      ndctl/list: Add 'target_node' to region and namespace verbose listings
      ndctl/docs: Fix mailing list sign-up link
      ndctl/list: Drop named list objects from verbose listing
      daxctl/list: Avoid memory operations without resource data
      ndctl/build: Fix distcheck
      ndctl/namespace: Fix destroy-namespace accounting relative to seed devices
      ndctl/region: Support ndctl_region_{get, set}_align()
      ndctl/namespace: Emit better errors on failure
      ndctl/namespace: Check for region alignment violations
      ndctl/util: Up-level is_power_of_2() and introduce IS_ALIGNED
      ndctl/namespace: Validate resource alignment for dax-mode namespaces
      ndctl/namespace: Add read-infoblock command
      ndctl/test: Update dax-dev to handle multiple e820 ranges
      ndctl/namespace: Always zero info-blocks
      ndctl/namespace: Disable autorecovery of create-namespace failures
      ndctl/build: Fix EXTRA_DIST already defined errors
      ndctl/test: Checkout device-mapper + dax operation
      ndctl/test: Exercise sub-section sized namespace creation/deletion
      ndctl/namespace: Kill off the legacy mode names
      ndctl/namespace: Introduce mode-to-name and name-to-mode helpers
      ndctl/namespace: Validate namespace size within validate_namespace_options()
      ndctl/namespace: Clarify 16M minimum size requirement
      ndctl/test: Regression test 'failed to track'
      ndctl/dimm: Rework dimm command status reporting
      ndctl/dimm: Rework iteration to drop unaligned pointers
      ndctl/test: Fix typos / loss of tpm.handle in security test
      ndctl/test: Cleanup test-vs-production nvdimm module detection
      ndctl/test: Relax dax_pmem_compat requirement
      ndctl/namespace: Fix namespace-action vs namespace-mode confusion
      ndctl/namespace: Update 'pfn' infoblock definition
      ndctl/util: Return 0 for NULL arguments to parse_size64()
      ndctl/namespace: Fix read-info-block vs read-infoblock
      ndctl/namespace: Parse infoblocks from stdin
      ndctl/namespace: Add write-infoblock command
      ndctl/list: Add option to list configured + disabled namespaces
      ndctl/lib/namespace: Fix resource retrieval after size change
      ndctl/test: Regression test misaligned namespaces

Ira Weiny (1):
      ndctl: Clean up loop logic in query_fw_finish_status

Santosh Sivaraj (2):
      ndctl/namespace: Fix enable-namespace error for seed namespaces
      ndctl/zero-labels: Display error if regions are active

Vaibhav Jain (1):
      namespace/create: Don't create multiple namespaces unless greedy

Vishal Verma (7):
      ndctl/namespace: remove open coded is_namespace_active()
      ndctl/namespace: introduce ndctl_namespace_is_configuration_idle()
      ndctl/README: Update kernel documentation URL
      ndctl/lib: fix symbol redefinitions reported by GCC10
      ndctl: add util/filter.{c,h} to ndctl_SOURCES in Makefile.am
      ndctl/namespace: Fix a resource leak in file_write_infoblock
      ndctl: release v68

Yi Zhang (1):
      ndctl/test: add bus-id parameter for start-scrub/wait-scrub operation

redhairer (2):
      ndctl/test: add UUID_LIBS for blk_namespaces/pmem_namespaces/device_dax
      daxctl: Change region input type from INTEGER to STRING.
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org

Return-Path: <SRS0=Nr1R=GP=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFAB6C433DB
	for <linux-nvdimm@archiver.kernel.org>; Tue, 12 Jan 2021 00:34:21 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2A96822CF7
	for <linux-nvdimm@archiver.kernel.org>; Tue, 12 Jan 2021 00:34:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2A96822CF7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id A343F100EBB9C;
	Mon, 11 Jan 2021 16:34:20 -0800 (PST)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=192.55.52.115; helo=mga14.intel.com; envelope-from=vishal.l.verma@intel.com; receiver=<UNKNOWN> 
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 965EC100EBBBD
	for <linux-nvdimm@lists.01.org>; Mon, 11 Jan 2021 16:34:18 -0800 (PST)
IronPort-SDR: xyXt0Vs4cjnyiHH4+SiC7RtsmU7NhUaJtx+MTg/a2zVX3O9J4CToV4ZGT0Tf9kYkU8oZwYm3bL
 89rcl254Mrig==
X-IronPort-AV: E=McAfee;i="6000,8403,9861"; a="177185568"
X-IronPort-AV: E=Sophos;i="5.79,339,1602572400";
   d="scan'208";a="177185568"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2021 16:34:17 -0800
IronPort-SDR: cI7UoPEQA4/4q2uMDEWvbZi24HaW3LSdM1QhLOHCgx9LWdgHFdQ/lynRDrP9u1lCZDrgTJedrb
 /jxZ1c4phVsg==
X-IronPort-AV: E=Sophos;i="5.79,339,1602572400";
   d="scan'208";a="381212076"
Received: from ecbackus-mobl1.amr.corp.intel.com (HELO omniknight.intel.com) ([10.212.212.82])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2021 16:34:17 -0800
From: Vishal Verma <vishal.l.verma@intel.com>
To: <linux-cxl@vger.kernel.org>
Subject: [ndctl RFC PATCH 0/5] Initial CXL support
Date: Mon, 11 Jan 2021 17:33:58 -0700
Message-Id: <20210112003403.2944568-1-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Message-ID-Hash: HYBNVCNFSSTPATYWVT7LPWGMRNYFR62A
X-Message-ID-Hash: HYBNVCNFSSTPATYWVT7LPWGMRNYFR62A
X-MailFrom: vishal.l.verma@intel.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: linux-nvdimm@lists.01.org, Ben Widawsky <ben.widawsky@intel.com>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/HYBNVCNFSSTPATYWVT7LPWGMRNYFR62A/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This is an RFC patchset to add a new utility and library to support
CXL devices. This comprehends the kernel's sysfs layout for CXL
devices, and implements a command submission harness for CXL mailbox
commands via ioctl()s definied by the cxl_mem driver.

These patches include:
- libcxl representation of cxl_mem devices
- A command submission harness through libcxl
- A 'cxl-list' command which displays information about a device

Things missing, or next steps are:
- A test/libcxl.c to exercise all library interfaces
- Testing 'vendor specific' commands exported by the QEMU
  implementation[1]
- API documentation

The latest kernel patches can be found at [2].
An ndctl branch with these patches is also available at [3]

[1]: https://lore.kernel.org/qemu-devel/20210105165323.783725-1-ben.widawsky@intel.com/
[2]: https://gitlab.com/bwidawsk/linux/-/commits/cxl-2.0v3
[3]: https://github.com/pmem/ndctl/tree/cxl-2.0v1

Vishal Verma (5):
  cxl: add a cxl utility and libcxl library
  cxl: add a local copy of the cxl_mem UAPI header
  libcxl: add support for command query and submission
  libcxl: add accessors for retrieving 'Identify' information
  cxl/list: augment cxl-list with more data from the identify command

 Documentation/cxl/cxl-list.txt       |  65 +++
 Documentation/cxl/cxl.txt            |  34 ++
 Documentation/cxl/human-option.txt   |   8 +
 Documentation/cxl/verbose-option.txt |   5 +
 configure.ac                         |   3 +
 Makefile.am                          |   4 +-
 Makefile.am.in                       |   5 +
 cxl/lib/private.h                    |  87 ++++
 cxl/lib/libcxl.c                     | 714 +++++++++++++++++++++++++++
 cxl/builtin.h                        |   8 +
 cxl/cxl_mem.h                        | 176 +++++++
 cxl/libcxl.h                         |  66 +++
 util/filter.h                        |   2 +
 util/json.h                          |   4 +
 util/main.h                          |   3 +
 cxl/cxl.c                            |  95 ++++
 cxl/list.c                           | 138 ++++++
 util/filter.c                        |  20 +
 util/json.c                          |  46 ++
 Documentation/cxl/Makefile.am        |  58 +++
 cxl/Makefile.am                      |  21 +
 cxl/lib/Makefile.am                  |  32 ++
 cxl/lib/libcxl.pc.in                 |  11 +
 cxl/lib/libcxl.sym                   |  41 ++
 24 files changed, 1644 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/cxl/cxl-list.txt
 create mode 100644 Documentation/cxl/cxl.txt
 create mode 100644 Documentation/cxl/human-option.txt
 create mode 100644 Documentation/cxl/verbose-option.txt
 create mode 100644 cxl/lib/private.h
 create mode 100644 cxl/lib/libcxl.c
 create mode 100644 cxl/builtin.h
 create mode 100644 cxl/cxl_mem.h
 create mode 100644 cxl/libcxl.h
 create mode 100644 cxl/cxl.c
 create mode 100644 cxl/list.c
 create mode 100644 Documentation/cxl/Makefile.am
 create mode 100644 cxl/Makefile.am
 create mode 100644 cxl/lib/Makefile.am
 create mode 100644 cxl/lib/libcxl.pc.in
 create mode 100644 cxl/lib/libcxl.sym

-- 
2.29.2
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org

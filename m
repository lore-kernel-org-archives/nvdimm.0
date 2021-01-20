Return-Path: <SRS0=HRiO=GX=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_20,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D840FC433DB
	for <linux-nvdimm@archiver.kernel.org>; Wed, 20 Jan 2021 19:38:55 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 62570233FC
	for <linux-nvdimm@archiver.kernel.org>; Wed, 20 Jan 2021 19:38:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 62570233FC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id F284B100EB329;
	Wed, 20 Jan 2021 11:38:54 -0800 (PST)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=134.134.136.24; helo=mga09.intel.com; envelope-from=dan.j.williams@intel.com; receiver=<UNKNOWN> 
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 69602100EBB97
	for <linux-nvdimm@lists.01.org>; Wed, 20 Jan 2021 11:38:53 -0800 (PST)
IronPort-SDR: HWNscRWq47qgz65BvFVG2/P271yr/0syRTMssAmY4HAwOdNr1RfZ6Ca8p2eYdR3c1qEU/00eXA
 D9FJYtoCk2wA==
X-IronPort-AV: E=McAfee;i="6000,8403,9870"; a="179317736"
X-IronPort-AV: E=Sophos;i="5.79,361,1602572400";
   d="scan'208";a="179317736"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2021 11:38:52 -0800
IronPort-SDR: pzhuB8GNi4NcFuaNPvuKg3ijSwwxzX6vhRsPNgcaN3iWjTooCAwL1Ft65HVPryvJipqrsV6g1C
 Z27Es84BmAxw==
X-IronPort-AV: E=Sophos;i="5.79,361,1602572400";
   d="scan'208";a="501708581"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2021 11:38:52 -0800
Subject: [PATCH 0/3] cdev: Generic shutdown handling
From: Dan Williams <dan.j.williams@intel.com>
To: gregkh@linuxfoundation.org
Date: Wed, 20 Jan 2021 11:38:52 -0800
Message-ID: <161117153248.2853729.2452425259045172318.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
MIME-Version: 1.0
Message-ID-Hash: 3GWA4DV4NUWFM3RBQVKDDR62HRQE33WN
X-Message-ID-Hash: 3GWA4DV4NUWFM3RBQVKDDR62HRQE33WN
X-MailFrom: dan.j.williams@intel.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: Alexandre Belloni <alexandre.belloni@free-electrons.com>, Alexander Viro <viro@zeniv.linux.org.uk>, logang@deltatee.com, Hans Verkuil <hans.verkuil@cisco.com>, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/3GWA4DV4NUWFM3RBQVKDDR62HRQE33WN/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

After reviewing driver submissions with new cdev + ioctl usages one
common stumbling block is coordinating the shutdown of the ioctl path,
or other file operations, at driver ->remove() time. While cdev_del()
guarantees that no new file descriptors will be established, operations
on existing file descriptors can proceed indefinitely.

Given the observation that the kernel spends the resources for a percpu_ref
per request_queue shared with all block_devices on a gendisk, do the
same for all the cdev instances that share the same
cdev_add()-to-cdev_del() lifetime.

With this in place cdev_del() not only guarantees 'no new opens', but it
also guarantees 'no new operations invocations' and 'all threads running
in an operation handler have exited that handler'.

As a proof point of the way driver implementations open-code around this
gap in the api the libnvdimm ioctl path is reworked with a result of:

    4 files changed, 101 insertions(+), 153 deletions(-)

---

Dan Williams (3):
      cdev: Finish the cdev api with queued mode support
      libnvdimm/ida: Switch to non-deprecated ida helpers
      libnvdimm/ioctl: Switch to cdev_register_queued()


 drivers/nvdimm/btt_devs.c       |    6 +
 drivers/nvdimm/bus.c            |  177 +++++++++------------------------------
 drivers/nvdimm/core.c           |   14 ++-
 drivers/nvdimm/dax_devs.c       |    4 -
 drivers/nvdimm/dimm_devs.c      |   53 +++++++++---
 drivers/nvdimm/namespace_devs.c |   14 +--
 drivers/nvdimm/nd-core.h        |   14 ++-
 drivers/nvdimm/pfn_devs.c       |    4 -
 fs/char_dev.c                   |  108 ++++++++++++++++++++++--
 include/linux/cdev.h            |   21 ++++-
 10 files changed, 238 insertions(+), 177 deletions(-)
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org

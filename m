Return-Path: <SRS0=gNwG=YT=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F144CA9EA0
	for <linux-nvdimm@archiver.kernel.org>; Sat, 26 Oct 2019 01:20:38 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B2BF321D7B
	for <linux-nvdimm@archiver.kernel.org>; Sat, 26 Oct 2019 01:20:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B2BF321D7B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from new-ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 2F92D100EA602;
	Fri, 25 Oct 2019 18:21:47 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=134.134.136.31; helo=mga06.intel.com; envelope-from=dan.j.williams@intel.com; receiver=<UNKNOWN> 
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id DBFBB100EA601
	for <linux-nvdimm@lists.01.org>; Fri, 25 Oct 2019 18:21:44 -0700 (PDT)
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Oct 2019 18:20:34 -0700
X-IronPort-AV: E=Sophos;i="5.68,230,1569308400";
   d="scan'208";a="189096220"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.16])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Oct 2019 18:20:34 -0700
Subject: [ndctl PATCH 0/2] test/dax.sh: fixup and split by fs
From: Dan Williams <dan.j.williams@intel.com>
To: vishal.l.verma@intel.com
Date: Fri, 25 Oct 2019 18:06:17 -0700
Message-ID: <157205197710.4128114.10329643056047769577.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-2-gc94f
MIME-Version: 1.0
Message-ID-Hash: DZY6SMGXXEWOWXTD4ZLN6UYDPUWIHT4S
X-Message-ID-Hash: DZY6SMGXXEWOWXTD4ZLN6UYDPUWIHT4S
X-MailFrom: dan.j.williams@intel.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: linux-nvdimm@lists.01.org
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/DZY6SMGXXEWOWXTD4ZLN6UYDPUWIHT4S/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Vishal,

Here's a rework of patch4 from the huge page validation series, and a
lead in fix that was causing the apply-conflict on your end.

---

Dan Williams (2):
      test/dax.sh: Make dax.sh more robust vs small namespaces
      test/dax.sh: Split into ext4 and xfs tests


 test/Makefile.am |    3 +-
 test/dax-ext4.sh |    1 +
 test/dax-xfs.sh  |    1 +
 test/dax.sh      |  101 +++++++++++++++++++++++++++++++-----------------------
 4 files changed, 62 insertions(+), 44 deletions(-)
 create mode 120000 test/dax-ext4.sh
 create mode 120000 test/dax-xfs.sh
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org

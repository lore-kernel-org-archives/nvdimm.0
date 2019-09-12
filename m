Return-Path: <SRS0=iZWN=XH=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33622C49ED6
	for <linux-nvdimm@archiver.kernel.org>; Thu, 12 Sep 2019 02:54:53 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id F05202085B
	for <linux-nvdimm@archiver.kernel.org>; Thu, 12 Sep 2019 02:54:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F05202085B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=perches.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from [127.0.0.1] (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 62A47202C808F;
	Wed, 11 Sep 2019 19:54:58 -0700 (PDT)
Received-SPF: None (no SPF record) identity=mailfrom; client-ip=216.40.44.139;
 helo=smtprelay.hostedemail.com; envelope-from=joe@perches.com;
 receiver=linux-nvdimm@lists.01.org 
Received: from smtprelay.hostedemail.com (smtprelay0139.hostedemail.com
 [216.40.44.139])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B09F720215F74
 for <linux-nvdimm@lists.01.org>; Wed, 11 Sep 2019 19:54:57 -0700 (PDT)
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net
 [216.40.38.60])
 by smtprelay01.hostedemail.com (Postfix) with ESMTP id 36473100E806B;
 Thu, 12 Sep 2019 02:54:50 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: band82_814fcf5b47631
X-Filterd-Recvd-Size: 2846
Received: from joe-laptop.perches.com (unknown [47.151.152.152])
 (Authenticated sender: joe@perches.com)
 by omf16.hostedemail.com (Postfix) with ESMTPA;
 Thu, 12 Sep 2019 02:54:48 +0000 (UTC)
From: Joe Perches <joe@perches.com>
To: Dan Williams <dan.j.williams@intel.com>,
	linux-nvdimm@lists.01.org
Subject: [PATCH 00/13] nvdimm: Use more common kernel coding style
Date: Wed, 11 Sep 2019 19:54:30 -0700
Message-Id: <cover.1568256705.git.joe@perches.com>
X-Mailer: git-send-email 2.15.0
X-BeenThere: linux-nvdimm@lists.01.org
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Cc: linux-kernel@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>

Rather than have a local coding style, use the typical kernel style.

Joe Perches (13):
  nvdimm: Use more typical whitespace
  nvdimm: Move logical continuations to previous line
  nvdimm: Use octal permissions
  nvdimm: Use a more common kernel spacing style
  nvdimm: Use "unsigned int" in preference to "unsigned"
  nvdimm: Add and remove blank lines
  nvdimm: Use typical kernel brace styles
  nvdimm: Use typical kernel style indentation
  nvdimm: btt.h: Neaten #defines to improve readability
  nvdimm: namespace_devs: Move assignment operators
  nvdimm: Use more common logic testing styles and bare ; positions
  nvdimm: namespace_devs: Change progess typo to progress
  nvdimm: Miscellaneous neatening

 drivers/nvdimm/badrange.c       |  22 +-
 drivers/nvdimm/blk.c            |  39 ++--
 drivers/nvdimm/btt.c            | 249 +++++++++++----------
 drivers/nvdimm/btt.h            |  56 ++---
 drivers/nvdimm/btt_devs.c       |  68 +++---
 drivers/nvdimm/bus.c            | 138 ++++++------
 drivers/nvdimm/claim.c          |  50 ++---
 drivers/nvdimm/core.c           |  42 ++--
 drivers/nvdimm/dax_devs.c       |   3 +-
 drivers/nvdimm/dimm.c           |   3 +-
 drivers/nvdimm/dimm_devs.c      | 107 ++++-----
 drivers/nvdimm/e820.c           |   2 +-
 drivers/nvdimm/label.c          | 213 +++++++++---------
 drivers/nvdimm/label.h          |   6 +-
 drivers/nvdimm/namespace_devs.c | 472 +++++++++++++++++++++-------------------
 drivers/nvdimm/nd-core.h        |  31 +--
 drivers/nvdimm/nd.h             |  94 ++++----
 drivers/nvdimm/nd_virtio.c      |  20 +-
 drivers/nvdimm/of_pmem.c        |   6 +-
 drivers/nvdimm/pfn_devs.c       | 136 ++++++------
 drivers/nvdimm/pmem.c           |  57 ++---
 drivers/nvdimm/pmem.h           |   2 +-
 drivers/nvdimm/region.c         |  20 +-
 drivers/nvdimm/region_devs.c    | 160 +++++++-------
 drivers/nvdimm/security.c       | 138 ++++++------
 drivers/nvdimm/virtio_pmem.c    |  10 +-
 26 files changed, 1115 insertions(+), 1029 deletions(-)

-- 
2.15.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5D03B21B02845
 for <linux-nvdimm@lists.01.org>; Thu, 19 Jul 2018 11:47:49 -0700 (PDT)
From: Ross Zwisler <zwisler@kernel.org>
Subject: [PATCH 0/2] Update mail addresses, add FS DAX maintainer
Date: Thu, 19 Jul 2018 12:47:20 -0600
Message-Id: <20180719184722.19164-1-zwisler@kernel.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Jan Kara <jack@suse.cz>, Dave Jiang <dave.jiang@intel.com>, linux-nvdimm@lists.01.org
Cc: Ross Zwisler <zwisler@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

This series updates my preferred email for kernel work to my
zwisler@kernel.org mail address, and adds Jan as a maintainer for
filesystem DAX.  Thank you, Jan, for helping to keep filesystem DAX in a
happy state.

We are planning on pushing this up through the libnvdimm tree for the
v4.19 merge window.

Ross Zwisler (2):
  MAINTAINERS: update Ross Zwisler's email address
  MAINTAINERS: Add Jan Kara for filesystem DAX

 .mailmap    |  1 +
 MAINTAINERS | 13 +++++++------
 2 files changed, 8 insertions(+), 6 deletions(-)

-- 
2.14.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E4AE82034D8CD
 for <linux-nvdimm@lists.01.org>; Wed, 21 Feb 2018 14:56:56 -0800 (PST)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH 0/3] add -Wmaybe-uninitialized
Date: Wed, 21 Feb 2018 16:02:49 -0700
Message-Id: <20180221230252.16632-1-vishal.l.verma@intel.com>
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
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

A few misc updates. Add the -Wmaybe-uninitialized flag to configure, and
fix the warnings it results in.
Also in update.c, remove a new unnecessary if (cmd) - unref checks as
unref already handles the NULL case.

Vishal Verma (3):
  ndctl, inject-smart: cleanup uninitialized variable warnings
  ndctl, update: fix uninitialized variable warnings
  ndctl, update: remove the check for !cmd when dereferencing it

 ndctl/inject-smart.c | 4 ++--
 ndctl/update.c       | 8 +++-----
 2 files changed, 5 insertions(+), 7 deletions(-)

-- 
2.14.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

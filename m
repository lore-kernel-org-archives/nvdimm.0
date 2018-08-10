Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0F2D521BADAB6
 for <linux-nvdimm@lists.01.org>; Fri, 10 Aug 2018 15:56:30 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH 0/5] ndctl: misc static analysis fixes
Date: Fri, 10 Aug 2018 16:56:19 -0600
Message-Id: <20180810225624.32383-1-vishal.l.verma@intel.com>
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

Fix up various static analysis reports from recent (and not-so-recent)
patches.

Vishal Verma (5):
  ndctl, inject: fix a resource leak in ndctl_namespace_get_clear_unit
  ndctl: fix a resource leak in submit_get_firmware_info
  libndctl: fix a resource leak in ndctl_dimm_get_{{event_}flags,
    health}
  ndctl, test: fix a potential null pointer dereference in 'ndctl test'
  ndctl, test: fix a resource leak in check_smart_threshold

 ndctl/dimm.c         | 17 ++++++++++-------
 ndctl/lib/inject.c   | 12 +++++++-----
 ndctl/lib/libndctl.c |  3 +++
 ndctl/test.c         |  2 ++
 test/libndctl.c      |  1 +
 5 files changed, 23 insertions(+), 12 deletions(-)

-- 
2.14.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

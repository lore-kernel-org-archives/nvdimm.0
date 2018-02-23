Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g4t3426.houston.hpe.com (g4t3426.houston.hpe.com
 [15.241.140.75])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AB42B220F33CE
 for <linux-nvdimm@lists.01.org>; Fri, 23 Feb 2018 13:08:12 -0800 (PST)
From: Toshi Kani <toshi.kani@hpe.com>
Subject: [PATCH 0/2] update label size handlings per UEFI 2.7
Date: Fri, 23 Feb 2018 14:59:20 -0700
Message-Id: <20180223215922.25415-1-toshi.kani@hpe.com>
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
To: dan.j.williams@intel.com
Cc: linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

This patchset updates label storage size check and index block size
calculation according to UEFI 2.7 spec.

---
Toshi Kani (2):
 1/2 libnvdimm, label: change min label storage size per UEFI 2.7
 2/2 libnvdimm, label: change nvdimm_num_label_slots per UEFI 2.7

---
 drivers/nvdimm/label.c | 34 ++++++++++++++++++++++++----------
 drivers/nvdimm/label.h |  2 +-
 2 files changed, 25 insertions(+), 11 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

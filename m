Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com
 [IPv6:2607:f8b0:4864:20::730])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A2E63211E95B2
 for <linux-nvdimm@lists.01.org>; Fri, 22 Mar 2019 21:20:35 -0700 (PDT)
Received: by mail-qk1-x730.google.com with SMTP id s81so2434723qke.13
 for <linux-nvdimm@lists.01.org>; Fri, 22 Mar 2019 21:20:35 -0700 (PDT)
From: Dexuan Cui <dexuan.cui@gmail.com>
Subject: [ndctl PATCH v3 0/5] Add the support for Hyper-V virtual NVDIMM
Date: Sat, 23 Mar 2019 04:20:24 +0000
Message-Id: <20190323042028.4310-1-decui@microsoft.com>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: vishal.l.verma@intel.com, dan.j.williams@intel.com, dave.jiang@intel.com, linux-nvdimm@lists.01.org, mikelley@microsoft.com
Cc: qi.fuli@fujitsu.com
List-ID: <linux-nvdimm@lists.01.org>

Hi all,

I polished the first 2 patches following Vishal and Dan's comments.

And, I dropped this v2 patch:
[ndctl,v2,3/4] ndctl, lib: implement ndctl_dimm_get_cmd_family()
and re-implemented the support for "ndctl monitor" for Hyper-V by following
Vishal/Dan's suggestions. Thank you!

Please review the patchset.

Dexuan Cui (5):
  libndctl: Implement the "smart_get_health" dimm-op for Hyper-V
  libndctl: Implement the smart_get_shutdown_count dimm-op for Hyper-V
  ndctl, monitor: Don't require the support of ND_CMD_SMART_THRESHOLD
  libndctl: Add a new dimm-op cmd_is_supported()
  libndctl: Implement the "cmd_is_supported" dimm-op for Hyper-V

 ndctl/lib/Makefile.am |   1 +
 ndctl/lib/hyperv.c    | 183 ++++++++++++++++++++++++++++++++++++++++++
 ndctl/lib/hyperv.h    |  38 +++++++++
 ndctl/lib/libndctl.c  |   7 ++
 ndctl/lib/private.h   |   4 +
 ndctl/monitor.c       |  12 +--
 ndctl/ndctl.h         |   1 +
 7 files changed, 238 insertions(+), 8 deletions(-)
 create mode 100644 ndctl/lib/hyperv.c
 create mode 100644 ndctl/lib/hyperv.h

-- 
2.19.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

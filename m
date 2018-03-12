Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B2196224488BC
 for <linux-nvdimm@lists.01.org>; Mon, 12 Mar 2018 11:18:10 -0700 (PDT)
From: Tony Luck <tony.luck@intel.com>
Subject: [PATCH 0/5 V3] Teach EDAC about non-volatile DIMMs and add partial
 support to skx_edac
Date: Mon, 12 Mar 2018 11:24:25 -0700
Message-Id: <20180312182430.10335-1-tony.luck@intel.com>
In-Reply-To: <CAPcyv4iHr9nUAS0SiFeqqDkU8NXZ_x=rkD3YS010Dy-nbHJXmA@mail.gmail.com>
References: <CAPcyv4iHr9nUAS0SiFeqqDkU8NXZ_x=rkD3YS010Dy-nbHJXmA@mail.gmail.com>
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
To: Borislav Petkov <bp@suse.de>
Cc: Jean Delvare <jdelvare@suse.com>, linux-nvdimm@lists.01.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Qiuxu Zhuo <qiuxu.zhuo@intel.com>, linux-acpi@vger.kernel.org, Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>, Aristeu Rozanski <aris@redhat.com>, Mauro Carvalho Chehab <mchehab@kernel.org>, Len Brown <lenb@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

Add support for non-volatile DIMMS
[Repost with fixes from Ross Zwisler and Jean Delvare's comments]

Changes since previous version:

Parts 1-2 unchanged since last post
Part    3 Use new SPDX license header for new file include/acpi/nfit.h
Part    4 Fix some ~0ul that should be ~0ull
Part    5 Rationalize error handling for various different reasons
          that we didn't find the size of a non-volatile DIMM
          Fix some printk formats.
          Fix test for ~0ul that should be ~0ull
          Re-order code to avoid computing number of pages twice

Dan gave the thumb's up to run part 3 through the EDAC tree.

Tony Luck (5):
  EDAC: Drop duplicated array of strings for memory type names
  edac: Add new memory type for non-volatile DIMMs
  acpi, nfit: Add function to look up nvdimm device and provide SMBIOS
    handle
  firmware: dmi: Add function to look up a handle and return DIMM size
  EDAC, skx_edac: Detect non-volatile DIMMs

 drivers/acpi/nfit/core.c     | 27 ++++++++++++++++++
 drivers/edac/Kconfig         |  5 +++-
 drivers/edac/edac_mc.c       | 41 +++++++++++++--------------
 drivers/edac/edac_mc_sysfs.c | 26 ++---------------
 drivers/edac/skx_edac.c      | 66 ++++++++++++++++++++++++++++++++++++++++----
 drivers/firmware/dmi_scan.c  | 31 +++++++++++++++++++++
 include/acpi/nfit.h          | 18 ++++++++++++
 include/linux/dmi.h          |  2 ++
 include/linux/edac.h         |  3 ++
 9 files changed, 168 insertions(+), 51 deletions(-)
 create mode 100644 include/acpi/nfit.h

-- 
2.14.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

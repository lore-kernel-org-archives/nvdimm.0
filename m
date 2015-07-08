Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 1/3] pmem: add maintainer for include/linux/pmem.h
Date: Wed,  8 Jul 2015 10:00:19 -0600
Message-Id: <1436371221-30296-2-git-send-email-ross.zwisler@linux.intel.com>
In-Reply-To: <1436371221-30296-1-git-send-email-ross.zwisler@linux.intel.com>
References: <1436371221-30296-1-git-send-email-ross.zwisler@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, Greg KH <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

The file include/linux/pmem.h was recently created to hold the PMEM API,
and is logically part of the PMEM driver.  Add an entry for this file to
MAINTAINERS.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Greg KH <gregkh@linuxfoundation.org> 
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm@lists.01.org
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index d4164f80cb42..8f0826b2c036 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5952,6 +5952,7 @@ L:	linux-nvdimm@lists.01.org
 Q:	https://patchwork.kernel.org/project/linux-nvdimm/list/
 S:	Supported
 F:	drivers/nvdimm/pmem.c
+F:	include/linux/pmem.h
 
 LINUX FOR IBM pSERIES (RS/6000)
 M:	Paul Mackerras <paulus@au.ibm.com>
-- 
1.9.3


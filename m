Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH v2 1/6] pmem: add maintainer for include/linux/pmem.h
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 11 Jul 2015 10:40:42 -0400
Message-ID: <20150711144042.25013.64570.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20150711142806.25013.16924.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150711142806.25013.16924.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: linux-acpi@vger.kernel.org, ross.zwisler@linux.intel.com, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

From: Ross Zwisler <ross.zwisler@linux.intel.com>

The file include/linux/pmem.h was recently created to hold the PMEM API,
and is logically part of the PMEM driver.  Add an entry for this file to
MAINTAINERS.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 0e6b09150aad..a8306b25c13c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6134,6 +6134,7 @@ L:	linux-nvdimm@lists.01.org
 Q:	https://patchwork.kernel.org/project/linux-nvdimm/list/
 S:	Supported
 F:	drivers/nvdimm/pmem.c
+F:	include/linux/pmem.h
 
 LINUX FOR IBM pSERIES (RS/6000)
 M:	Paul Mackerras <paulus@au.ibm.com>


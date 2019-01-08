Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5AFA22119EF4E
 for <linux-nvdimm@lists.01.org>; Tue,  8 Jan 2019 12:04:36 -0800 (PST)
Subject: [pmdk PATCH] common/file: Make detection of device-dax instances
 more robust
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 08 Jan 2019 11:51:58 -0800
Message-ID: <154697711872.985876.15063592205044647642.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: marcin.slusarz@intel.com
Cc: pmem@googlegroups.com, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

In preparation for the kernel switching device-dax instances from the
"/sys/class/dax" subsystem to "/sys/bus/dax" [1], teach the device-dax
instance detection to be subsystem-type agnostic.

Note that the subsystem switch will require an administrator, or distro,
opt-in. The opt-in will either be at kernel compile time by disabling
the default compatibility driver in the kernel, or at runtime with a
modprobe policy to override which kernel module services device-dax
devices. The daxctl utility [2] will ship a command to install the
modprobe policy and include a man page that lists the potential
regression risk to older PMDK and other userspace tools that are hard
coded to "/sys/class/dax".

[1]: https://lwn.net/Articles/770128/
[2]: https://github.com/pmem/ndctl/tree/master/daxctl

Reported-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 src/common/file.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/common/file.c b/src/common/file.c
index ff36e70e1fff..e660c136506a 100644
--- a/src/common/file.c
+++ b/src/common/file.c
@@ -53,7 +53,6 @@
 #include "out.h"
 #include "mmap.h"
 
-#define DEVICE_DAX_PREFIX "/sys/class/dax"
 #define MAX_SIZE_LENGTH 64
 
 #define DEVICE_DAX_ZERO_LEN (2 * MEGABYTE)
@@ -180,7 +179,8 @@ get_file_type_internal(os_stat_t *st)
 		return OTHER_ERROR;
 	}
 
-	if (strcmp(DEVICE_DAX_PREFIX, rpath) != 0) {
+	char *basename = strrchr(rpath, '/');
+	if (!basename || strcmp("dax", basename+1) != 0) {
 		LOG(3, "%s path does not match device dax prefix path", rpath);
 		errno = EINVAL;
 		return OTHER_ERROR;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

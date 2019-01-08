Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0C145211A322C
 for <linux-nvdimm@lists.01.org>; Tue,  8 Jan 2019 11:46:56 -0800 (PST)
Subject: [fio PATCH] engines/devdax: Make detection of device-dax instances
 more robust
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 08 Jan 2019 11:34:19 -0800
Message-ID: <154697605958.939406.14480036379705502215.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: axboe@kernel.dk
Cc: fio@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

In preparation for the kernel switching device-dax instances from the
"/sys/class/dax" subsystem to "/sys/bus/dax" [1], teach the device-dax
instance detection to be subsystem-type agnostic.

Note that the subsystem switch will require an administrator, or distro
opt-in. The opt-in will either be at kernel compile time by disabling
the default compatibility driver in the kernel, or at runtime with a
modprobe policy to override which kernel module service device-dax
devices. The daxctl utility [2] will ship a command to install the
modprobe policy and include a man page that lists the potential
regression risk to older FIO and other userspace tools that are hard
coded to "/sys/class/dax".

[1]: https://lwn.net/Articles/770128/
[2]: https://github.com/pmem/ndctl/tree/master/daxctl

Reported-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 engines/dev-dax.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/engines/dev-dax.c b/engines/dev-dax.c
index 0660bba563e6..422ea634ff1d 100644
--- a/engines/dev-dax.c
+++ b/engines/dev-dax.c
@@ -259,7 +259,7 @@ fio_devdax_get_file_size(struct thread_data *td, struct fio_file *f)
 {
 	char spath[PATH_MAX];
 	char npath[PATH_MAX];
-	char *rpath;
+	char *rpath, *basename;
 	FILE *sfile;
 	uint64_t size;
 	struct stat st;
@@ -289,7 +289,8 @@ fio_devdax_get_file_size(struct thread_data *td, struct fio_file *f)
 	}
 
 	/* check if DAX device */
-	if (strcmp("/sys/class/dax", rpath)) {
+	basename = strrchr(rpath, '/');
+	if (!basename || strcmp("dax", basename+1)) {
 		log_err("%s: %s not a DAX device!\n",
 			td->o.name, f->file_name);
 	}

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

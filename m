Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5F84221198CC2
 for <linux-nvdimm@lists.01.org>; Thu, 27 Dec 2018 19:42:40 -0800 (PST)
Subject: [ndctl PATCH 1/7] ndctl, daxctl: Split builtin.h per-command
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 27 Dec 2018 19:30:03 -0800
Message-ID: <154596780371.164521.1371668722710070666.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <154596779833.164521.12632457592535372923.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <154596779833.164521.12632457592535372923.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

In preparation for adding more daxctl specific commands, split the
top-level builtin.h into command specific flavors. Leave the common
definitions in the top-level file.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 builtin.h        |   51 ---------------------------------------------------
 daxctl/builtin.h |    6 ++++++
 daxctl/daxctl.c  |    4 +---
 ndctl/builtin.h  |   33 +++++++++++++++++++++++++++++++++
 ndctl/ndctl.c    |    6 +++---
 util/main.c      |    2 +-
 util/main.h      |    7 ++++++-
 7 files changed, 50 insertions(+), 59 deletions(-)
 delete mode 100644 builtin.h
 create mode 100644 daxctl/builtin.h
 create mode 100644 ndctl/builtin.h

diff --git a/builtin.h b/builtin.h
deleted file mode 100644
index 675a6ce79b9c..000000000000
--- a/builtin.h
+++ /dev/null
@@ -1,51 +0,0 @@
-/*
- * Copyright(c) 2015-2017 Intel Corporation. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of version 2 of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- */
-#ifndef _NDCTL_BUILTIN_H_
-#define _NDCTL_BUILTIN_H_
-extern const char ndctl_usage_string[];
-extern const char ndctl_more_info_string[];
-
-struct cmd_struct {
-	const char *cmd;
-	int (*fn)(int, const char **, void *ctx);
-};
-
-int cmd_create_nfit(int argc, const char **argv, void *ctx);
-int cmd_enable_namespace(int argc, const char **argv, void *ctx);
-int cmd_create_namespace(int argc, const char **argv, void *ctx);
-int cmd_destroy_namespace(int argc, const char **argv, void *ctx);
-int cmd_disable_namespace(int argc, const char **argv, void *ctx);
-int cmd_check_namespace(int argc, const char **argv, void *ctx);
-int cmd_enable_region(int argc, const char **argv, void *ctx);
-int cmd_disable_region(int argc, const char **argv, void *ctx);
-int cmd_enable_dimm(int argc, const char **argv, void *ctx);
-int cmd_disable_dimm(int argc, const char **argv, void *ctx);
-int cmd_zero_labels(int argc, const char **argv, void *ctx);
-int cmd_read_labels(int argc, const char **argv, void *ctx);
-int cmd_write_labels(int argc, const char **argv, void *ctx);
-int cmd_init_labels(int argc, const char **argv, void *ctx);
-int cmd_check_labels(int argc, const char **argv, void *ctx);
-int cmd_inject_error(int argc, const char **argv, void *ctx);
-int cmd_wait_scrub(int argc, const char **argv, void *ctx);
-int cmd_start_scrub(int argc, const char **argv, void *ctx);
-int cmd_list(int argc, const char **argv, void *ctx);
-int cmd_monitor(int argc, const char **argv, void *ctx);
-#ifdef ENABLE_TEST
-int cmd_test(int argc, const char **argv, void *ctx);
-#endif
-#ifdef ENABLE_DESTRUCTIVE
-int cmd_bat(int argc, const char **argv, void *ctx);
-#endif
-int cmd_update_firmware(int argc, const char **argv, void *ctx);
-int cmd_inject_smart(int argc, const char **argv, void *ctx);
-#endif /* _NDCTL_BUILTIN_H_ */
diff --git a/daxctl/builtin.h b/daxctl/builtin.h
new file mode 100644
index 000000000000..131a5d86258b
--- /dev/null
+++ b/daxctl/builtin.h
@@ -0,0 +1,6 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright(c) 2015-2018 Intel Corporation. All rights reserved. */
+#ifndef _DAXCTL_BUILTIN_H_
+#define _DAXCTL_BUILTIN_H_
+int cmd_list(int argc, const char **argv, void *ctx);
+#endif /* _DAXCTL_BUILTIN_H_ */
diff --git a/daxctl/daxctl.c b/daxctl/daxctl.c
index 91a4600e262f..545e117a5aad 100644
--- a/daxctl/daxctl.c
+++ b/daxctl/daxctl.c
@@ -28,7 +28,7 @@
 #include <util/strbuf.h>
 #include <util/util.h>
 #include <util/main.h>
-#include <builtin.h>
+#include <daxctl/builtin.h>
 
 const char daxctl_usage_string[] = "daxctl [--version] [--help] COMMAND [ARGS]";
 const char daxctl_more_info_string[] =
@@ -66,8 +66,6 @@ static int cmd_help(int argc, const char **argv, void *ctx)
 	return help_show_man_page(argv[0], "daxctl", "DAXCTL_MAN_VIEWER");
 }
 
-int cmd_list(int argc, const char **argv, void *ctx);
-
 static struct cmd_struct commands[] = {
 	{ "version", cmd_version },
 	{ "list", cmd_list },
diff --git a/ndctl/builtin.h b/ndctl/builtin.h
new file mode 100644
index 000000000000..4ebc50406247
--- /dev/null
+++ b/ndctl/builtin.h
@@ -0,0 +1,33 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright(c) 2015-2018 Intel Corporation. All rights reserved. */
+#ifndef _NDCTL_BUILTIN_H_
+#define _NDCTL_BUILTIN_H_
+int cmd_create_nfit(int argc, const char **argv, void *ctx);
+int cmd_enable_namespace(int argc, const char **argv, void *ctx);
+int cmd_create_namespace(int argc, const char **argv, void *ctx);
+int cmd_destroy_namespace(int argc, const char **argv, void *ctx);
+int cmd_disable_namespace(int argc, const char **argv, void *ctx);
+int cmd_check_namespace(int argc, const char **argv, void *ctx);
+int cmd_enable_region(int argc, const char **argv, void *ctx);
+int cmd_disable_region(int argc, const char **argv, void *ctx);
+int cmd_enable_dimm(int argc, const char **argv, void *ctx);
+int cmd_disable_dimm(int argc, const char **argv, void *ctx);
+int cmd_zero_labels(int argc, const char **argv, void *ctx);
+int cmd_read_labels(int argc, const char **argv, void *ctx);
+int cmd_write_labels(int argc, const char **argv, void *ctx);
+int cmd_init_labels(int argc, const char **argv, void *ctx);
+int cmd_check_labels(int argc, const char **argv, void *ctx);
+int cmd_inject_error(int argc, const char **argv, void *ctx);
+int cmd_wait_scrub(int argc, const char **argv, void *ctx);
+int cmd_start_scrub(int argc, const char **argv, void *ctx);
+int cmd_list(int argc, const char **argv, void *ctx);
+int cmd_monitor(int argc, const char **argv, void *ctx);
+#ifdef ENABLE_TEST
+int cmd_test(int argc, const char **argv, void *ctx);
+#endif
+#ifdef ENABLE_DESTRUCTIVE
+int cmd_bat(int argc, const char **argv, void *ctx);
+#endif
+int cmd_update_firmware(int argc, const char **argv, void *ctx);
+int cmd_inject_smart(int argc, const char **argv, void *ctx);
+#endif /* _NDCTL_BUILTIN_H_ */
diff --git a/ndctl/ndctl.c b/ndctl/ndctl.c
index 73dabfac3908..9c930b92fe44 100644
--- a/ndctl/ndctl.c
+++ b/ndctl/ndctl.c
@@ -21,7 +21,7 @@
 #include <unistd.h>
 #include <sys/stat.h>
 #include <sys/types.h>
-#include <builtin.h>
+#include <ndctl/builtin.h>
 #include <ndctl/libndctl.h>
 #include <ccan/array_size/array_size.h>
 
@@ -30,8 +30,8 @@
 #include <util/util.h>
 #include <util/main.h>
 
-const char ndctl_usage_string[] = "ndctl [--version] [--help] COMMAND [ARGS]";
-const char ndctl_more_info_string[] =
+static const char ndctl_usage_string[] = "ndctl [--version] [--help] COMMAND [ARGS]";
+static const char ndctl_more_info_string[] =
 	"See 'ndctl help COMMAND' for more information on a specific command.\n"
 	" ndctl --list-cmds to see all available commands";
 
diff --git a/util/main.c b/util/main.c
index 5f35dd9d1c3e..a7992589cfcc 100644
--- a/util/main.c
+++ b/util/main.c
@@ -21,10 +21,10 @@
 #include <unistd.h>
 #include <sys/stat.h>
 #include <sys/types.h>
-#include <builtin.h>
 
 #include <util/strbuf.h>
 #include <util/util.h>
+#include <util/main.h>
 
 int main_handle_options(const char ***argv, int *argc, const char *usage_msg,
 		struct cmd_struct *cmds, int num_cmds)
diff --git a/util/main.h b/util/main.h
index bcfe9f304d6b..d61d10c79630 100644
--- a/util/main.h
+++ b/util/main.h
@@ -16,7 +16,12 @@
 
 #ifndef __MAIN_H__
 #define __MAIN_H__
-struct cmd_struct;
+
+struct cmd_struct {
+	const char *cmd;
+	int (*fn)(int, const char **, void *ctx);
+};
+
 int main_handle_options(const char ***argv, int *argc, const char *usage_msg,
 		struct cmd_struct *cmds, int num_cmds);
 void main_handle_internal_command(int argc, const char **argv, void *ctx,

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

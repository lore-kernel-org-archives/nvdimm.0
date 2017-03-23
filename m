Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x242.google.com (mail-ot0-x242.google.com
 [IPv6:2607:f8b0:4003:c0f::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 067B1802B8
 for <linux-nvdimm@lists.01.org>; Thu, 23 Mar 2017 16:47:54 -0700 (PDT)
Received: by mail-ot0-x242.google.com with SMTP id i50so21105434otd.0
 for <linux-nvdimm@lists.01.org>; Thu, 23 Mar 2017 16:47:53 -0700 (PDT)
From: Lijun Pan <lijunpan2000@gmail.com>
Subject: [PATCH 1/2] ndctl: Microsoft _DSM's support for "ndctl list --health"
 option
Date: Thu, 23 Mar 2017 18:47:50 -0500
Message-Id: <20170323234751.1468-1-lijunpan2000@gmail.com>
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
Cc: Lijun Pan <Lijun.Pan@dell.com>, Stuart Hayes <Stuart.Hayes@dell.com>
List-ID: <linux-nvdimm@lists.01.org>

From: Lijun Pan <Lijun.Pan@dell.com>

Add Microsoft's specific _DSM interface to retrieve the NVDIMM
health data from the server platforms supporting this interface.
Please refer to Microsoft _DSM spec[1] and JESD245A[2].

[1]. https://msdn.microsoft.com/library/windows/hardware/mt604741
[2]. https://www.jedec.org/sites/default/files/docs/JESD245A.pdf

Cc: Stuart Hayes <Stuart.Hayes@dell.com>
Signed-off-by: Lijun Pan <Lijun.Pan@dell.com>
---
 ndctl/Makefile.am      |   3 +-
 ndctl/builtin-list.c   |   6 ++-
 ndctl/lib/libndctl.c   |   5 ++
 ndctl/lib/libndctl.sym |   1 +
 ndctl/lib/ndctl-msft.h |  57 ++++++++++++++++++++++
 ndctl/libndctl.h.in    |   1 +
 ndctl/util/json-msft.c | 125 +++++++++++++++++++++++++++++++++++++++++++++++++
 util/json.h            |   1 +
 8 files changed, 197 insertions(+), 2 deletions(-)
 create mode 100644 ndctl/lib/ndctl-msft.h
 create mode 100644 ndctl/util/json-msft.c

diff --git a/ndctl/Makefile.am b/ndctl/Makefile.am
index c563e94..f85f9cb 100644
--- a/ndctl/Makefile.am
+++ b/ndctl/Makefile.am
@@ -10,7 +10,8 @@ ndctl_SOURCES = ndctl.c \
 		 ../util/log.c \
 		builtin-list.c \
 		builtin-test.c \
-		../util/json.c
+		../util/json.c \
+		util/json-msft.c
 
 if ENABLE_SMART
 ndctl_SOURCES += util/json-smart.c
diff --git a/ndctl/builtin-list.c b/ndctl/builtin-list.c
index e8d0070..d4e1d23 100644
--- a/ndctl/builtin-list.c
+++ b/ndctl/builtin-list.c
@@ -349,7 +349,11 @@ int cmd_list(int argc, const char **argv, void *ctx)
 			if (list.health) {
 				struct json_object *jhealth;
 
-				jhealth = util_dimm_health_to_json(dimm);
+				if (ndctl_dimm_get_dsm_family(dimm) == NVDIMM_FAMILY_MSFT)
+					jhealth = util_dimm_health_to_json_msft(dimm);
+				else
+					jhealth = util_dimm_health_to_json(dimm);
+
 				if (jhealth)
 					json_object_object_add(jdimm, "health",
 							jhealth);
diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index 565c969..019db9a 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -1361,6 +1361,11 @@ NDCTL_EXPORT unsigned char ndctl_dimm_get_manufacturing_location(
 	return dimm->manufacturing_location;
 }
 
+NDCTL_EXPORT unsigned long ndctl_dimm_get_dsm_family(struct ndctl_dimm *dimm)
+{
+	return dimm->dsm_family;
+}
+
 NDCTL_EXPORT unsigned short ndctl_dimm_get_format(struct ndctl_dimm *dimm)
 {
 	return dimm->format[0];
diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
index be2e368..b1d6e6f 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -48,6 +48,7 @@ global:
 	ndctl_dimm_get_subsystem_vendor;
 	ndctl_dimm_get_subsystem_device;
 	ndctl_dimm_get_subsystem_revision;
+	ndctl_dimm_get_dsm_family;
 	ndctl_dimm_get_format;
 	ndctl_dimm_get_formats;
 	ndctl_dimm_get_formatN;
diff --git a/ndctl/lib/ndctl-msft.h b/ndctl/lib/ndctl-msft.h
new file mode 100644
index 0000000..4985c24
--- /dev/null
+++ b/ndctl/lib/ndctl-msft.h
@@ -0,0 +1,57 @@
+/*
+ * Copyright (C) 2016-2017 Dell, Inc.
+ * Author: Lijun Pan <Lijun.Pan@dell.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU Lesser General Public License,
+ * version 2.1, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT ANY
+ * WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
+ * FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public License for
+ * more details.
+ */
+
+#ifndef _NDCTL_DELL_H_
+#define _NDCTL_DELL_H_
+
+#define DEV_NAME_MAX_LENGTH	12
+#define DEV_ID_MAX_LENGTH	3
+#define DEV_ID_MAX		128
+
+/* REFER TO SPEC https://msdn.microsoft.com/en-us/library/windows/hardware/mt604741(v=vs.85).aspx */
+#define SIZE_IN_FUNC0 0
+#define SIZE_IN_FUNC1 0
+#define SIZE_IN_FUNC2 0
+#define SIZE_IN_FUNC3 0
+#define SIZE_IN_FUNC4 0
+#define SIZE_IN_FUNC5 0
+#define SIZE_IN_FUNC7 0
+#define SIZE_IN_FUNC10 0
+#define SIZE_IN_FUNC11 0
+#define SIZE_IN_FUNC12 0
+
+#define SIZE_OUT_FUNC0 4
+#define SIZE_OUT_FUNC1 50
+#define SIZE_OUT_FUNC2 12
+#define SIZE_OUT_FUNC3 19
+#define SIZE_OUT_FUNC4 12
+#define SIZE_OUT_FUNC5 6
+#define SIZE_OUT_FUNC7 8
+#define SIZE_OUT_FUNC10 5
+#define SIZE_OUT_FUNC11 13
+#define SIZE_OUT_FUNC12 11
+#define SIZE_OUT_MAX 50
+
+#define FUNC0 0
+#define FUNC1 1
+#define FUNC2 2
+#define FUNC3 3
+#define FUNC4 4
+#define FUNC5 5
+#define FUNC7 7
+#define FUNC10 10
+#define FUNC11 11
+#define FUNC12 12
+
+#endif
diff --git a/ndctl/libndctl.h.in b/ndctl/libndctl.h.in
index c27581d..fb2c6e1 100644
--- a/ndctl/libndctl.h.in
+++ b/ndctl/libndctl.h.in
@@ -129,6 +129,7 @@ unsigned short ndctl_dimm_get_subsystem_device(struct ndctl_dimm *dimm);
 unsigned short ndctl_dimm_get_manufacturing_date(struct ndctl_dimm *dimm);
 unsigned char ndctl_dimm_get_manufacturing_location(struct ndctl_dimm *dimm);
 unsigned short ndctl_dimm_get_subsystem_revision(struct ndctl_dimm *dimm);
+unsigned long ndctl_dimm_get_dsm_family(struct ndctl_dimm *dimm);
 unsigned short ndctl_dimm_get_format(struct ndctl_dimm *dimm);
 int ndctl_dimm_get_formats(struct ndctl_dimm *dimm);
 int ndctl_dimm_get_formatN(struct ndctl_dimm *dimm, int i);
diff --git a/ndctl/util/json-msft.c b/ndctl/util/json-msft.c
new file mode 100644
index 0000000..9e41fde
--- /dev/null
+++ b/ndctl/util/json-msft.c
@@ -0,0 +1,125 @@
+#include <limits.h>
+#include <util/json.h>
+#include <uuid/uuid.h>
+#include <json-c/json.h>
+#include <ndctl/libndctl.h>
+#include <ccan/array_size/array_size.h>
+#include <errno.h>
+#include <fcntl.h>
+#include <string.h>
+#include <sys/ioctl.h>
+
+#ifdef HAVE_NDCTL_H
+#include <linux/ndctl.h>
+#else
+#include <ndctl.h>
+#endif
+
+#include "ndctl-msft.h"
+
+static int call_func(int func_num, int size_in, int size_out,
+		int fd, unsigned char *payload) {
+	struct nd_cmd_pkg *pkg;
+	int error;
+	int i;
+
+	memset(payload, 0, SIZE_OUT_MAX);
+	pkg = malloc(sizeof(struct nd_cmd_pkg) + size_in + size_out);
+	if (!pkg)
+		return -ENOMEM;
+
+	pkg->nd_family = NVDIMM_FAMILY_MSFT;
+	pkg->nd_command = func_num;
+	pkg->nd_size_in = size_in;
+	pkg->nd_size_out = size_out;
+	pkg->nd_fw_size = 0;
+
+	for (i = 0; i < 9; i++)
+		pkg->nd_reserved2[i] = 0;
+
+	for (i = 0; i < size_in; i++)
+		pkg->nd_payload[i] = 0;
+
+	for (i = 0; i < size_out; i++)
+		pkg->nd_payload[i + size_in] = 0;
+
+	error = ioctl(fd, ND_IOCTL_CALL, pkg);
+
+	if (error) {
+		fprintf(stderr, "ioctl returned errno %d\n", errno);
+		free(pkg);
+		return error;
+	}
+
+	for (i = 0; i < size_out; i++)
+		payload[i] = pkg->nd_payload[i + size_in];
+
+	free(pkg);
+	return 0;
+}
+
+struct json_object *util_dimm_health_to_json_msft(struct ndctl_dimm *dimm)
+{
+
+	struct json_object *jhealth = json_object_new_object();
+	struct json_object *jobj;
+	char dev_name[DEV_NAME_MAX_LENGTH + 1];
+	unsigned char payload[SIZE_OUT_MAX];
+	char str[100];
+	int fd;
+	int error;
+	int number;
+	double temp;
+
+	memset(dev_name, 0, DEV_NAME_MAX_LENGTH + 1);
+	snprintf(dev_name, DEV_NAME_MAX_LENGTH + 1, "/dev/nmem%d", ndctl_dimm_get_id(dimm));
+	fd = open(dev_name, O_RDWR);
+	if (fd == -1) {
+		fprintf(stderr, "error opening %s errno=%d\n", dev_name, errno);
+		goto err_fd;
+	}
+
+	error = call_func(FUNC10, SIZE_IN_FUNC10, SIZE_OUT_FUNC10, fd, payload);
+	if (!error) {
+		if (!!(payload[4] & 0x0F))
+			jobj = json_object_new_string("critical");
+		else
+			jobj = json_object_new_string("ok");
+		if (jobj)
+			json_object_object_add(jhealth, "health_state", jobj);
+	}
+
+	error = call_func(FUNC11, SIZE_IN_FUNC11, SIZE_OUT_FUNC11, fd, payload);
+	if (!error) {
+		/* refer to JESD245 spec section 7.8 to calculate the temperature */
+		number = (payload[7] & 0x0F) << 4 | (payload[6] & 0xF0) >> 4;
+		temp = number + !!(payload[6] & 0x08) * 0.5 + !!(payload[6] & 0x04) * 0.25;
+		jobj = json_object_new_double(temp);
+		if (jobj)
+			json_object_object_add(jhealth, "temperature_celsius", jobj);
+
+		memset(str, 0, 100);
+		snprintf(str, 100, "%d%%", payload[10]);
+		jobj = json_object_new_string(str);
+		if (jobj)
+			json_object_object_add(jhealth, "NVM_Lifetime", jobj);
+	}
+
+	error = call_func(FUNC4, SIZE_IN_FUNC4, SIZE_OUT_FUNC4, fd, payload);
+	if (!error) {
+		if (!!(payload[4] & 0x1))
+			jobj = json_object_new_string("success");
+		else
+			jobj = json_object_new_string("failure");
+		if (jobj)
+			json_object_object_add(jhealth, "last_save_operation", jobj);
+	}
+
+	close(fd);
+	return jhealth;
+
+err_fd:
+	json_object_put(jhealth);
+
+	return NULL;
+}
diff --git a/util/json.h b/util/json.h
index a9afb2d..3a41977 100644
--- a/util/json.h
+++ b/util/json.h
@@ -29,4 +29,5 @@ static inline struct json_object *util_dimm_health_to_json(
 	return NULL;
 }
 #endif
+struct json_object *util_dimm_health_to_json_msft(struct ndctl_dimm *dimm);
 #endif /* __NDCTL_JSON_H__ */
-- 
1.8.3.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

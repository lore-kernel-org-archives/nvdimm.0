Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x241.google.com (mail-ot0-x241.google.com
 [IPv6:2607:f8b0:4003:c0f::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 31D8F802B8
 for <linux-nvdimm@lists.01.org>; Thu, 23 Mar 2017 16:47:55 -0700 (PDT)
Received: by mail-ot0-x241.google.com with SMTP id a12so30688760ota.2
 for <linux-nvdimm@lists.01.org>; Thu, 23 Mar 2017 16:47:55 -0700 (PDT)
From: Lijun Pan <lijunpan2000@gmail.com>
Subject: [PATCH 2/2] ndctl: add msft-dsm command
Date: Thu, 23 Mar 2017 18:47:51 -0500
Message-Id: <20170323234751.1468-2-lijunpan2000@gmail.com>
In-Reply-To: <20170323234751.1468-1-lijunpan2000@gmail.com>
References: <20170323234751.1468-1-lijunpan2000@gmail.com>
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

"ndctl msft-dsm" shows more generic NVDIMM info (except health)
via calling _DSM functions.

Cc: Stuart Hayes <Stuart.Hayes@dell.com>
Signed-off-by: Lijun Pan <Lijun.Pan@dell.com>
---
 Documentation/Makefile.am        |   1 +
 Documentation/ndctl-msft-dsm.txt |  83 ++++++++++++++++++
 builtin.h                        |   1 +
 ndctl/Makefile.am                |   1 +
 ndctl/builtin-msft-dsm.c         | 173 +++++++++++++++++++++++++++++++++++++
 ndctl/ndctl.c                    |   1 +
 ndctl/util/json-msft.c           | 179 +++++++++++++++++++++++++++++++++++++++
 util/json.h                      |   1 +
 8 files changed, 440 insertions(+)
 create mode 100644 Documentation/ndctl-msft-dsm.txt
 create mode 100644 ndctl/builtin-msft-dsm.c

diff --git a/Documentation/Makefile.am b/Documentation/Makefile.am
index 6daeb56..0c04fde 100644
--- a/Documentation/Makefile.am
+++ b/Documentation/Makefile.am
@@ -13,6 +13,7 @@ man1_MANS = \
 	ndctl-create-namespace.1 \
 	ndctl-destroy-namespace.1 \
 	ndctl-list.1 \
+	ndctl-msft-dsm.1 \
 	daxctl-list.1
 
 CLEANFILES = $(man1_MANS)
diff --git a/Documentation/ndctl-msft-dsm.txt b/Documentation/ndctl-msft-dsm.txt
new file mode 100644
index 0000000..8fe03be
--- /dev/null
+++ b/Documentation/ndctl-msft-dsm.txt
@@ -0,0 +1,83 @@
+ndctl-msft-dsm(1)
+=================
+
+NAME
+----
+ndctl-msft-dsm - dump the NVDIMM hardware data in json via _DSM calls
+
+SYNOPSIS
+--------
+[verse]
+'ndctl msft-dsm' [<options>]
+
+Walk all the nvdimm buses in the system and list all attached devices
+along with some of their hardware data.
+
+Options can be specified to limit the output to devices of a certain
+class.  Where the classes are buses, dimms.
+
+EXAMPLE
+-------
+[verse]
+# ndctl msft-dsm --buses --dimms --idle
+
+["literal"]
+{
+  "provider":"ACPI.NFIT",
+  "dev":"ndbus0",
+  "dimms":[
+    {
+      "dev":"nmem0",
+      "id":"0000-00000000",
+      "state":"disabled",
+      "_DSM":{
+        "firmware_revision":23129,
+        "save_op_timeout":"70 seconds",
+        "restore_op_timeout":"45 seconds",
+        "erase_op_timeout":"5 seconds",
+        "arm_op_timeout":"10 seconds",
+        "firmware_op_timeout":"10 seconds",
+        "abort_op_timeout_milliseconds":255,
+        "averag_power_required_save_op_milliwatts":0,
+        "averag_idle_power_required_after_save_op_completes_milliwatts":0,
+        "min_voltage_ES_service_during_save_op_millivolts":5799,
+        "max_voltage_ES_service_during_save_op_millivolts":13799,
+        "NVM_lifetime_percentage_warning_threshold":0,
+        "NVM_lifetime_percentage_error_threshold":0,
+        "ES_lifetime_percentage_warning_threshold":0,
+        "ES_lifetime_percentage_error_threshold":0,
+        "ES_temperature_warning_threshold_celsius":0,
+        "ES_temperature_error_threshold_celsius":0,
+        "ES_lifetime_percentage":0,
+        "ES_current_temperature_celsius":0,
+        "ES_total_runtime_hours":0
+      }
+    }
+  ]
+}
+
+OPTIONS
+-------
+-b::
+--bus=::
+	A bus id. Filter listing by devices that reference the given bus.
+
+-d::
+--dimm=::
+	An 'nmemX' device name, or dimm id number. Filter listing by
+	devices that reference the given dimm.
+-B::
+--buses::
+	Include bus info in the listing
+
+-D::
+--dimms::
+	Include dimm info in the listing
+
+-i::
+--idle::
+	Include idle (not enabled) devices in the listing
+
+SEE ALSO
+--------
+linkndctl:ndctl-list[1]
diff --git a/builtin.h b/builtin.h
index 9b66196..425929d 100644
--- a/builtin.h
+++ b/builtin.h
@@ -22,6 +22,7 @@ int cmd_read_labels(int argc, const char **argv, void *ctx);
 int cmd_init_labels(int argc, const char **argv, void *ctx);
 int cmd_check_labels(int argc, const char **argv, void *ctx);
 int cmd_list(int argc, const char **argv, void *ctx);
+int cmd_msft_dsm(int argc, const char **argv, void *ctx);
 #ifdef ENABLE_TEST
 int cmd_test(int argc, const char **argv, void *ctx);
 #endif
diff --git a/ndctl/Makefile.am b/ndctl/Makefile.am
index f85f9cb..0519e52 100644
--- a/ndctl/Makefile.am
+++ b/ndctl/Makefile.am
@@ -9,6 +9,7 @@ ndctl_SOURCES = ndctl.c \
 		builtin-dimm.c \
 		 ../util/log.c \
 		builtin-list.c \
+		builtin-msft-dsm.c \
 		builtin-test.c \
 		../util/json.c \
 		util/json-msft.c
diff --git a/ndctl/builtin-msft-dsm.c b/ndctl/builtin-msft-dsm.c
new file mode 100644
index 0000000..c7a5f7d
--- /dev/null
+++ b/ndctl/builtin-msft-dsm.c
@@ -0,0 +1,173 @@
+#include <stdio.h>
+#include <errno.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <limits.h>
+#include <util/json.h>
+#include <util/filter.h>
+#include <json-c/json.h>
+#include <ndctl/libndctl.h>
+#include <util/parse-options.h>
+#include <ccan/array_size/array_size.h>
+
+#ifdef HAVE_NDCTL_H
+#include <linux/ndctl.h>
+#else
+#include <ndctl.h>
+#endif
+
+static struct {
+	bool buses;
+	bool dimms;
+	bool idle;
+} list;
+
+static struct {
+	const char *bus;
+	const char *type;
+	const char *dimm;
+} param;
+
+static int did_fail;
+static int jflag = JSON_C_TO_STRING_PRETTY;
+
+#define fail(fmt, ...) \
+do { \
+	did_fail = 1; \
+	fprintf(stderr, "ndctl-%s:%s:%d: " fmt, \
+			VERSION, __func__, __LINE__, ##__VA_ARGS__); \
+} while (0)
+
+static int num_list_flags(void)
+{
+	return list.buses + list.dimms;
+}
+
+int cmd_msft_dsm(int argc, const char **argv, void *ctx)
+{
+	const struct option options[] = {
+		OPT_STRING('b', "bus", &param.bus, "bus-id", "filter by bus"),
+		OPT_STRING('d', "dimm", &param.dimm, "dimm-id",
+				"filter by dimm"),
+		OPT_BOOLEAN('B', "buses", &list.buses, "include bus info"),
+		OPT_BOOLEAN('D', "dimms", &list.dimms, "include dimm info"),
+		OPT_BOOLEAN('i', "idle", &list.idle, "include idle devices"),
+		OPT_END(),
+	};
+	const char * const u[] = {
+		"ndctl msft-dsm [<options>]",
+		NULL
+	};
+	struct json_object *jdimms = NULL;
+	struct json_object *jbuses = NULL;
+	struct ndctl_bus *bus;
+	int i;
+
+        argc = parse_options(argc, argv, options, u, 0);
+	for (i = 0; i < argc; i++)
+		error("unknown parameter \"%s\"\n", argv[i]);
+
+	if (argc)
+		usage_with_options(u, options);
+
+	if (num_list_flags() == 0) {
+		list.buses = !!param.bus;
+		list.dimms = !!param.dimm;
+	}
+
+	ndctl_bus_foreach(ctx, bus) {
+		struct json_object *jbus = NULL;
+		struct ndctl_dimm *dimm;
+
+		if (!util_bus_filter(bus, param.bus)
+				|| !util_bus_filter_by_dimm(bus, param.dimm))
+			continue;
+
+		if (list.buses) {
+			if (!jbuses) {
+				jbuses = json_object_new_array();
+				if (!jbuses) {
+					fail("\n");
+					continue;
+				}
+			}
+
+			jbus = util_bus_to_json(bus);
+			if (!jbus) {
+				fail("\n");
+				continue;
+			}
+			json_object_array_add(jbuses, jbus);
+		}
+
+		ndctl_dimm_foreach(bus, dimm) {
+			struct json_object *jdimm;
+
+			/* are we emitting dimms? */
+			if (!list.dimms)
+				break;
+
+			if (!util_dimm_filter(dimm, param.dimm))
+				continue;
+
+			if (!list.idle && !ndctl_dimm_is_enabled(dimm))
+				continue;
+
+			if (!jdimms) {
+				jdimms = json_object_new_array();
+				if (!jdimms) {
+					fail("\n");
+					continue;
+				}
+
+				if (jbus)
+					json_object_object_add(jbus, "dimms", jdimms);
+			}
+
+			jdimm = util_dimm_to_json(dimm);
+			if (!jdimm) {
+				fail("\n");
+				continue;
+			}
+
+			if (ndctl_dimm_get_dsm_family(dimm) == NVDIMM_FAMILY_MSFT) {
+				struct json_object *jdsm;
+				jdsm = util_dimm_dsm_to_json_msft(dimm);
+				if (jdsm)
+					json_object_object_add(jdimm, "_DSM", jdsm);
+			}
+
+			/*
+			 * Without a bus we are collecting dimms anonymously
+			 * across the platform.
+			 */
+			json_object_array_add(jdimms, jdimm);
+		}
+
+		if (jbuses) {
+			jdimms = NULL;
+		}
+	}
+
+	if (jbuses)
+		util_display_json_array(stdout, jbuses, jflag);
+	else if ((!!jdimms) > 1) {
+		struct json_object *jplatform = json_object_new_object();
+
+		if (!jplatform) {
+			fail("\n");
+			return -ENOMEM;
+		}
+
+		if (jdimms)
+			json_object_object_add(jplatform, "dimms", jdimms);
+		printf("%s\n", json_object_to_json_string_ext(jplatform,
+					jflag));
+		json_object_put(jplatform);
+	} else if (jdimms)
+		util_display_json_array(stdout, jdimms, jflag);
+
+	if (did_fail)
+		return -ENOMEM;
+	return 0;
+}
diff --git a/ndctl/ndctl.c b/ndctl/ndctl.c
index 80a0491..aef2fc2 100644
--- a/ndctl/ndctl.c
+++ b/ndctl/ndctl.c
@@ -67,6 +67,7 @@ static struct cmd_struct commands[] = {
 	{ "check-labels", cmd_check_labels },
 	{ "list", cmd_list },
 	{ "help", cmd_help },
+	{ "msft-dsm", cmd_msft_dsm },
 	#ifdef ENABLE_TEST
 	{ "test", cmd_test },
 	#endif
diff --git a/ndctl/util/json-msft.c b/ndctl/util/json-msft.c
index 9e41fde..2dca173 100644
--- a/ndctl/util/json-msft.c
+++ b/ndctl/util/json-msft.c
@@ -79,6 +79,8 @@ struct json_object *util_dimm_health_to_json_msft(struct ndctl_dimm *dimm)
 		goto err_fd;
 	}
 
+	/* ======================== */
+
 	error = call_func(FUNC10, SIZE_IN_FUNC10, SIZE_OUT_FUNC10, fd, payload);
 	if (!error) {
 		if (!!(payload[4] & 0x0F))
@@ -115,6 +117,8 @@ struct json_object *util_dimm_health_to_json_msft(struct ndctl_dimm *dimm)
 			json_object_object_add(jhealth, "last_save_operation", jobj);
 	}
 
+	/* ======================== */
+
 	close(fd);
 	return jhealth;
 
@@ -123,3 +127,178 @@ err_fd:
 
 	return NULL;
 }
+
+struct json_object *util_dimm_dsm_to_json_msft(struct ndctl_dimm *dimm)
+{
+
+	struct json_object *jdsm = json_object_new_object();
+	struct json_object *jobj;
+	char dev_name[DEV_NAME_MAX_LENGTH + 1];
+	unsigned char payload[SIZE_OUT_MAX];
+	char str[100];
+	int fd;
+	int error;
+	int number;
+
+	memset(dev_name, 0, DEV_NAME_MAX_LENGTH + 1);
+	snprintf(dev_name, DEV_NAME_MAX_LENGTH + 1, "/dev/nmem%d", ndctl_dimm_get_id(dimm));
+	fd = open(dev_name, O_RDWR);
+	if (fd == -1) {
+		fprintf(stderr, "error opening %s errno=%d\n", dev_name, errno);
+		goto err_fd;
+	}
+
+	/* ======================== */
+
+	error = call_func(FUNC1, SIZE_IN_FUNC1, SIZE_OUT_FUNC1, fd, payload);
+	if (!error) {
+		number = payload[13] << 8 | payload[12];
+		jobj = json_object_new_int(number);
+		if (jobj)
+			json_object_object_add(jdsm, "firmware_revision", jobj);
+
+		number = ((payload[21] & 0x7f) << 8) | payload[20];
+		if (!!(payload[21] & 0x80)) {
+			memset(str, 0, 100);
+			snprintf(str, 100, "%d seconds", number);
+			jobj = json_object_new_string(str);
+		} else {
+			memset(str, 0, 100);
+			snprintf(str, 100, "%d milliseconds", number);
+			jobj = json_object_new_string(str);
+		}
+		if (jobj)
+			json_object_object_add(jdsm, "save_op_timeout", jobj);
+
+		number = ((payload[25] & 0x7f) << 8) | payload[24];
+		if (!!(payload[25] & 0x80)) {
+			memset(str, 0, 100);
+			snprintf(str, 100, "%d seconds", number);
+			jobj = json_object_new_string(str);
+		} else {
+			memset(str, 0, 100);
+			snprintf(str, 100, "%d milliseconds", number);
+			jobj = json_object_new_string(str);
+		}
+		if (jobj)
+			json_object_object_add(jdsm, "restore_op_timeout", jobj);
+
+		number = ((payload[29] & 0x7f) << 8) | payload[28];
+		if (!!(payload[29] & 0x80)) {
+			memset(str, 0, 100);
+			snprintf(str, 100, "%d seconds", number);
+			jobj = json_object_new_string(str);
+		} else {
+			memset(str, 0, 100);
+			snprintf(str, 100, "%d milliseconds", number);
+			jobj = json_object_new_string(str);
+		}
+		if (jobj)
+			json_object_object_add(jdsm, "erase_op_timeout", jobj);
+
+		number = ((payload[33] & 0x7f) << 8) | payload[32];
+		if (!!(payload[33] & 0x80)) {
+			memset(str, 0, 100);
+			snprintf(str, 100, "%d seconds", number);
+			jobj = json_object_new_string(str);
+		} else {
+			memset(str, 0, 100);
+			snprintf(str, 100, "%d milliseconds", number);
+			jobj = json_object_new_string(str);
+		}
+		if (jobj)
+			json_object_object_add(jdsm, "arm_op_timeout", jobj);
+
+		number = ((payload[37] & 0x7f) << 8) | payload[36];
+		if (!!(payload[37] & 0x80)) {
+			memset(str, 0, 100);
+			snprintf(str, 100, "%d seconds", number);
+			jobj = json_object_new_string(str);
+		} else {
+			memset(str, 0, 100);
+			snprintf(str, 100, "%d milliseconds", number);
+			jobj = json_object_new_string(str);
+		}
+		if (jobj)
+			json_object_object_add(jdsm, "firmware_op_timeout", jobj);
+
+		jobj = json_object_new_int(payload[40]);
+		if (jobj)
+			json_object_object_add(jdsm, "abort_op_timeout_milliseconds", jobj);
+	}
+
+
+	error = call_func(FUNC2, SIZE_IN_FUNC2, SIZE_OUT_FUNC2, fd, payload);
+	if (!error) {
+		jobj = json_object_new_int(payload[5] << 8 | payload[4]);
+		if (jobj)
+			json_object_object_add(jdsm, "averag_power_required_save_op_milliwatts", jobj);
+
+		jobj = json_object_new_int(payload[7] << 8 | payload[6]);
+		if (jobj)
+			json_object_object_add(jdsm, "averag_idle_power_required_after_save_op_completes_milliwatts", jobj);
+
+		jobj = json_object_new_int(payload[9] << 8 | payload[8]);
+		if (jobj)
+			json_object_object_add(jdsm, "min_voltage_ES_service_during_save_op_millivolts", jobj);
+
+		jobj = json_object_new_int(payload[11] << 8 | payload[10]);
+		if (jobj)
+			json_object_object_add(jdsm, "max_voltage_ES_service_during_save_op_millivolts", jobj);
+	}
+
+
+	error = call_func(FUNC5, SIZE_IN_FUNC5, SIZE_OUT_FUNC5, fd, payload);
+	if (!error) {
+		jobj = json_object_new_int(payload[4]);
+		if (jobj)
+			json_object_object_add(jdsm, "NVM_lifetime_percentage_warning_threshold", jobj);
+
+		jobj = json_object_new_int(payload[5]);
+		if (jobj)
+			json_object_object_add(jdsm, "NVM_lifetime_percentage_error_threshold", jobj);
+	}
+
+	error = call_func(FUNC7, SIZE_IN_FUNC7, SIZE_OUT_FUNC7, fd, payload);
+	if (!error) {
+		jobj = json_object_new_int(payload[4]);
+		if (jobj)
+			json_object_object_add(jdsm, "ES_lifetime_percentage_warning_threshold", jobj);
+
+		jobj = json_object_new_int(payload[5]);
+		if (jobj)
+			json_object_object_add(jdsm, "ES_lifetime_percentage_error_threshold", jobj);
+
+		jobj = json_object_new_int(payload[6]);
+		if (jobj)
+			json_object_object_add(jdsm, "ES_temperature_warning_threshold_celsius", jobj);
+
+		jobj = json_object_new_int(payload[7]);
+		if (jobj)
+			json_object_object_add(jdsm, "ES_temperature_error_threshold_celsius", jobj);
+	}
+
+	error = call_func(FUNC12, SIZE_IN_FUNC12, SIZE_OUT_FUNC12, fd, payload);
+	if (!error) {
+		jobj = json_object_new_int(payload[4]);
+		if (jobj)
+			json_object_object_add(jdsm, "ES_lifetime_percentage", jobj);
+
+		jobj = json_object_new_int((payload[6] << 8) | payload[5]);
+		if (jobj)
+			json_object_object_add(jdsm, "ES_current_temperature_celsius", jobj);
+
+		jobj = json_object_new_int((payload[8] << 8) | payload[7]);
+		if (jobj)
+			json_object_object_add(jdsm, "ES_total_runtime_hours", jobj);
+	}
+
+	/* ======================== */
+	close(fd);
+	return jdsm;
+
+err_fd:
+	json_object_put(jdsm);
+
+	return NULL;
+}
diff --git a/util/json.h b/util/json.h
index 3a41977..675132f 100644
--- a/util/json.h
+++ b/util/json.h
@@ -30,4 +30,5 @@ static inline struct json_object *util_dimm_health_to_json(
 }
 #endif
 struct json_object *util_dimm_health_to_json_msft(struct ndctl_dimm *dimm);
+struct json_object *util_dimm_dsm_to_json_msft(struct ndctl_dimm *dimm);
 #endif /* __NDCTL_JSON_H__ */
-- 
1.8.3.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

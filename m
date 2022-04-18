Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DE7FA29
	for <nvdimm@lists.linux.dev>; Mon, 18 Apr 2022 17:10:52 +0000 (UTC)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
	by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23IFg2CD020257;
	Mon, 18 Apr 2022 17:10:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : from : to : cc
 : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=Jcch8HH6yAyXSsJ5muSXjcRVMAju0r1IkdEJnbTZeBM=;
 b=NzST7nSn0SlwBLAhhUZq4S/ZH9klBLEPegkpu+8ZkhOu8q4u5Vid/jC0VV/oFlIJHWp1
 kStoHCSJqRLo2hFSls2PryqnHbZd3KaeZY3z6I5CVmf8+ZCusQnPaBCPsVzmhegVjei5
 Fj0gGfWqFVX4ePDqFXJEdnsllLQNvvrEhZmVv+rt/VAOgD0JI4gywnjFjJAg+FqKQl2p
 oMrGgNtoog6cwrwLTKBJbUDuag0GgMdYX3HW8W7s2RBWSH4eZVrfm7XBh7eOtwwokGhv
 PGMdTDzb2tM/JURSuHHhIkVVSR/lkQtIPJZwzClWu3U6oCC1WUGOMuG8WGGEva7U9Ep0 eg== 
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
	by mx0b-001b2d01.pphosted.com with ESMTP id 3fg75psujc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 18 Apr 2022 17:10:49 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
	by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23IH2onP002587;
	Mon, 18 Apr 2022 17:10:47 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
	by ppma02fra.de.ibm.com with ESMTP id 3fgu6u0vqk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 18 Apr 2022 17:10:47 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
	by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23IHAiQT44892654
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 18 Apr 2022 17:10:44 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 35042AE045;
	Mon, 18 Apr 2022 17:10:44 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 43ADAAE051;
	Mon, 18 Apr 2022 17:10:43 +0000 (GMT)
Received: from lep8c.aus.stglabs.ibm.com (unknown [9.40.192.207])
	by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
	Mon, 18 Apr 2022 17:10:43 +0000 (GMT)
Subject: [RFC ndctl PATCH 4/9] test: Introduce skip file to skip irrelevant
 tests
From: Shivaprasad G Bhat <sbhat@linux.ibm.com>
To: nvdimm@lists.linux.dev, dan.j.williams@intel.com, vishal.l.verma@intel.com
Cc: aneesh.kumar@linux.ibm.com, sbhat@linux.ibm.com, vaibhav@linux.ibm.com
Date: Mon, 18 Apr 2022 12:10:42 -0500
Message-ID: 
 <165030183808.3224737.13932338864318081260.stgit@lep8c.aus.stglabs.ibm.com>
In-Reply-To: 
 <165030175745.3224737.6985015146263991065.stgit@lep8c.aus.stglabs.ibm.com>
References: 
 <165030175745.3224737.6985015146263991065.stgit@lep8c.aus.stglabs.ibm.com>
User-Agent: StGit/1.1+40.g1b20
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: uT166OY8AmyI2bKtwQYnrE2r7IAceJ6b
X-Proofpoint-GUID: uT166OY8AmyI2bKtwQYnrE2r7IAceJ6b
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-18_02,2022-04-15_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 phishscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 impostorscore=0 mlxscore=0
 lowpriorityscore=0 malwarescore=0 priorityscore=1501 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204180101

Having a skip file containing the list of tests to be skipped on
a given platform is useful to avoid false negatives when running
the tests on multiple platforms.

The meson sets the specific environment variables during test.
Tests when run under meson or with these specific env variables,
are supposed to check the skip_INTEL|PAPR.js file and decide if
the current test is to skipped or not. The json file format is
chosen for the skip file as the current ndctl code base already
has the json dependencies linked to the sources.

The patch also adds the PAPR specific skip_PAPR.js file to skip
all the irrelevant and failing tests on the ndtest module.

Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
---
 ndctl/bat.c                   |    4 +--
 ndctl/test.c                  |    4 +--
 test.h                        |    4 +--
 test/ack-shutdown-count-set.c |    2 +
 test/common                   |   10 +++++++
 test/core.c                   |   62 ++++++++++++++++++++++++++++++++++++++++-
 test/dax-dev.c                |    2 +
 test/dax-pmd.c                |    2 +
 test/device-dax.c             |    2 +
 test/dsm-fail.c               |    2 +
 test/libndctl.c               |    2 +
 test/meson.build              |    1 +
 test/pmem_namespaces.c        |    2 +
 test/revoke-devmem.c          |    2 +
 test/skip_PAPR.js             |   34 ++++++++++++++++++++++
 15 files changed, 120 insertions(+), 15 deletions(-)
 create mode 100644 test/skip_PAPR.js

diff --git a/ndctl/bat.c b/ndctl/bat.c
index 13e964dc..53e9d951 100644
--- a/ndctl/bat.c
+++ b/ndctl/bat.c
@@ -32,9 +32,9 @@ int cmd_bat(int argc, const char **argv, struct ndctl_ctx *ctx)
 		usage_with_options(u, options);
 
 	if (force)
-		test = ndctl_test_new(UINT_MAX);
+		test = ndctl_test_new(UINT_MAX, argv[0]);
 	else
-		test = ndctl_test_new(0);
+		test = ndctl_test_new(0, argv[0]);
 
 	if (!test) {
 		fprintf(stderr, "failed to initialize test\n");
diff --git a/ndctl/test.c b/ndctl/test.c
index a0f5bc95..43b8c383 100644
--- a/ndctl/test.c
+++ b/ndctl/test.c
@@ -42,9 +42,9 @@ int cmd_test(int argc, const char **argv, struct ndctl_ctx *ctx)
 		usage_with_options(u, options);
 
 	if (force)
-		test = ndctl_test_new(UINT_MAX);
+		test = ndctl_test_new(UINT_MAX, argv[0]);
 	else
-		test = ndctl_test_new(0);
+		test = ndctl_test_new(0, argv[0]);
 	if (!test)
 		return EXIT_FAILURE;
 
diff --git a/test.h b/test.h
index 6cff4189..cb61e0d9 100644
--- a/test.h
+++ b/test.h
@@ -6,7 +6,7 @@
 
 struct ndctl_test;
 struct ndctl_ctx;
-struct ndctl_test *ndctl_test_new(unsigned int kver);
+struct ndctl_test *ndctl_test_new(unsigned int kver, const char *testname);
 int ndctl_test_result(struct ndctl_test *test, int rc);
 int ndctl_test_get_skipped(struct ndctl_test *test);
 int ndctl_test_get_attempted(struct ndctl_test *test);
@@ -23,7 +23,7 @@ struct kmod_module;
 int ndctl_test_init(struct kmod_ctx **ctx, struct kmod_module **mod,
 		struct ndctl_ctx *nd_ctx, int log_level,
 		struct ndctl_test *test);
-int ndctl_test_module_remove(struct kmod_ctx **ctx, struct kmod_module **mod,
+void ndctl_test_module_remove(struct kmod_ctx **ctx, struct kmod_module **mod,
 			struct ndctl_ctx *nd_ctx);
 
 struct ndctl_ctx;
diff --git a/test/ack-shutdown-count-set.c b/test/ack-shutdown-count-set.c
index 2d77aa07..5d38ad9d 100644
--- a/test/ack-shutdown-count-set.c
+++ b/test/ack-shutdown-count-set.c
@@ -118,7 +118,7 @@ static int test_ack_shutdown_count_set(int loglevel, struct ndctl_test *test,
 int main(int argc, char *argv[])
 {
 	char *test_env = getenv("NDCTL_TEST_FAMILY");
-	struct ndctl_test *test = ndctl_test_new(0);
+	struct ndctl_test *test = ndctl_test_new(0, argv[0]);
 	struct ndctl_ctx *ctx;
 	int rc;
 
diff --git a/test/common b/test/common
index d2cb3f73..31395ece 100644
--- a/test/common
+++ b/test/common
@@ -35,6 +35,16 @@ if [ ! -v NDCTL_TEST_FAMILY ]; then
 	export NDCTL_TEST_FAMILY=INTEL
 fi
 
+if [ -f "$(dirname $0)/skip_${NDCTL_TEST_FAMILY}.js" ]; then
+	length=$(cat $(dirname $0)/skip_${NDCTL_TEST_FAMILY}.js |\
+		sed 's|//.*||' | jq length)
+	for (( i=0; i<length; i++ )); do
+		test=$(cat $(dirname $0)/skip_${NDCTL_TEST_FAMILY}.js |\
+			sed 's|//.*||' | jq -e -r ".[${i}]")
+		[ "$test" == "${0##*/}" ] && exit 77;
+	done
+fi
+
 # NFIT_TEST_BUS[01]
 #
 NFIT_TEST_BUS0="nfit_test.0"
diff --git a/test/core.c b/test/core.c
index bc7542aa..130e4aed 100644
--- a/test/core.c
+++ b/test/core.c
@@ -7,6 +7,8 @@
 #include <errno.h>
 #include <stdio.h>
 #include <test.h>
+#include <unistd.h>
+#include <json-c/json.h>
 
 #include <util/log.h>
 #include <util/sysfs.h>
@@ -39,9 +41,67 @@ static unsigned int get_system_kver(void)
 	return KERNEL_VERSION(a,b,c);
 }
 
-struct ndctl_test *ndctl_test_new(unsigned int kver)
+static bool skip_current_test(char *skip_file, const char *curtest)
+{
+	FILE *fp;
+	char buffer[16384]; //16k large enough for file with comments
+	const char *curtestname = basename(curtest);
+	struct json_object *skip_array;
+	struct json_object *test;
+	const char *testname;
+	size_t i, size;
+
+	fp = fopen(skip_file, "r");
+	if (fp == NULL) {
+		fprintf(stderr, "Failed to open the %s file. Ignore, and continue..\n", skip_file);
+		return false;
+	}
+
+	size = fread(buffer, 1, 16384, fp);
+	if (size == 0) {
+		fprintf(stderr, "Failed to read the %s file. Ignore, and continue..\n", skip_file);
+		return false;
+	}
+	fclose(fp);
+
+	skip_array = json_tokener_parse(buffer);
+	if (json_object_get_type(skip_array) != json_type_array) {
+		fprintf(stderr, "Failed to parse the %s file. Ignore, and continue..\n", skip_file);
+		return false;
+	}
+
+	for (i = 0; i < json_object_array_length(skip_array); i++) {
+		test = json_object_array_get_idx(skip_array, i);
+		testname = json_object_get_string(test);
+		if (testname && strcmp(curtestname, testname) == 0)
+			return true;
+	}
+
+	return false;
+}
+
+struct ndctl_test *ndctl_test_new(unsigned int kver, const char *testpath)
 {
 	struct ndctl_test *test = calloc(1, sizeof(*test));
+	const char *data_path  = getenv("DATA_PATH");
+	const char *test_family = getenv("NDCTL_TEST_FAMILY");
+	char *skip_file = NULL;
+
+	if (test_family && data_path &&
+	    (asprintf(&skip_file, "%s/skip_%s.js", data_path, test_family) < 0)) {
+		fprintf(stderr, "test : allocation failed\n");
+		free(test);
+		return NULL;
+	}
+
+	if (skip_file &&
+		(access(skip_file, F_OK) == 0) &&
+		skip_current_test(skip_file, testpath)) {
+		fprintf(stderr, "test : skip requested in the skip_%s.js\n",
+			test_family);
+		ndctl_test_skip(test);
+		exit(ndctl_test_result(test, 77));
+	}
 
 	if (!test)
 		return NULL;
diff --git a/test/dax-dev.c b/test/dax-dev.c
index 6a1b76d6..2c9b6156 100644
--- a/test/dax-dev.c
+++ b/test/dax-dev.c
@@ -118,7 +118,7 @@ static int emit_e820_device(int loglevel, struct ndctl_test *test)
 
 int __attribute__((weak)) main(int argc, char *argv[])
 {
-	struct ndctl_test *test = ndctl_test_new(0);
+	struct ndctl_test *test = ndctl_test_new(0, argv[0]);
 	int rc;
 
 	if (!test) {
diff --git a/test/dax-pmd.c b/test/dax-pmd.c
index f8408759..7f74ea03 100644
--- a/test/dax-pmd.c
+++ b/test/dax-pmd.c
@@ -358,7 +358,7 @@ err_mmap:
 
 int __attribute__((weak)) main(int argc, char *argv[])
 {
-	struct ndctl_test *test = ndctl_test_new(0);
+	struct ndctl_test *test = ndctl_test_new(0, argv[0]);
 	int fd, rc;
 
 	if (!test) {
diff --git a/test/device-dax.c b/test/device-dax.c
index 49c9bc8b..14ea2f82 100644
--- a/test/device-dax.c
+++ b/test/device-dax.c
@@ -423,7 +423,7 @@ static int test_device_dax(int loglevel, struct ndctl_test *test,
 
 int __attribute__((weak)) main(int argc, char *argv[])
 {
-	struct ndctl_test *test = ndctl_test_new(0);
+	struct ndctl_test *test = ndctl_test_new(0, argv[0]);
 	struct ndctl_ctx *ctx;
 	int rc;
 
diff --git a/test/dsm-fail.c b/test/dsm-fail.c
index 65ac2bd4..e7a35ca6 100644
--- a/test/dsm-fail.c
+++ b/test/dsm-fail.c
@@ -364,7 +364,7 @@ int test_dsm_fail(int loglevel, struct ndctl_test *test, struct ndctl_ctx *ctx)
 
 int __attribute__((weak)) main(int argc, char *argv[])
 {
-	struct ndctl_test *test = ndctl_test_new(0);
+	struct ndctl_test *test = ndctl_test_new(0, argv[0]);
 	struct ndctl_ctx *ctx;
 	int rc;
 
diff --git a/test/libndctl.c b/test/libndctl.c
index df61f84c..de95c83e 100644
--- a/test/libndctl.c
+++ b/test/libndctl.c
@@ -2618,7 +2618,7 @@ int test_libndctl(int loglevel, struct ndctl_test *test, struct ndctl_ctx *ctx)
 
 int __attribute__((weak)) main(int argc, char *argv[])
 {
-	struct ndctl_test *test = ndctl_test_new(0);
+	struct ndctl_test *test = ndctl_test_new(0, argv[0]);
 	struct ndctl_ctx *ctx;
 	int rc;
 
diff --git a/test/meson.build b/test/meson.build
index 07a5bb6e..395b5333 100644
--- a/test/meson.build
+++ b/test/meson.build
@@ -9,6 +9,7 @@ libndctl_deps = [
   daxctl_dep,
   uuid,
   kmod,
+  json,
 ]
 
 ndctl_deps = libndctl_deps + [
diff --git a/test/pmem_namespaces.c b/test/pmem_namespaces.c
index 64207020..f3a00c79 100644
--- a/test/pmem_namespaces.c
+++ b/test/pmem_namespaces.c
@@ -251,7 +251,7 @@ int test_pmem_namespaces(int log_level, struct ndctl_test *test,
 
 int __attribute__((weak)) main(int argc, char *argv[])
 {
-	struct ndctl_test *test = ndctl_test_new(0);
+	struct ndctl_test *test = ndctl_test_new(0, argv[0]);
 	struct ndctl_ctx *ctx;
 	int rc;
 
diff --git a/test/revoke-devmem.c b/test/revoke-devmem.c
index 59d1a72d..c0d84e8b 100644
--- a/test/revoke-devmem.c
+++ b/test/revoke-devmem.c
@@ -124,7 +124,7 @@ out_devmem:
 
 int main(int argc, char *argv[])
 {
-	struct ndctl_test *test = ndctl_test_new(0);
+	struct ndctl_test *test = ndctl_test_new(0, argv[0]);
 	struct ndctl_ctx *ctx;
 	int rc;
 
diff --git a/test/skip_PAPR.js b/test/skip_PAPR.js
new file mode 100644
index 00000000..367257c4
--- /dev/null
+++ b/test/skip_PAPR.js
@@ -0,0 +1,34 @@
+// List of tests to be skipped on ndtest
+//
+// Append new test cases to this array below until support is added on ndtest.
+//
+["clear.sh",		// No error injection support on PPC.
+ "daxdev-errors.sh",	// 		""
+ "inject-error.sh",	// 		""
+ "pfn-meta-errors.sh",  //		""
+ "pmem-errors.sh",	//		""
+ "btt-errors.sh",	//		""
+ "label-compat.sh",	// Legacy namespace support test/irrelavent on
+			// ndtest.
+ "security.sh",		// No support on PPC yet.
+ "daxctl-create.sh",	// Depends on dax_hmem
+ "sub-section.sh",	// Tests using nd_e820, either duplication when
+			// running on INTEL host, or cannot be tested on
+			// PPC host.
+ "dax-dev",		//		""
+ "device-dax",		//		""
+ "device-dax-fio.sh",	//		""
+ "dax-ext4.sh",		//		""
+ "dax-xfs.sh",		//		""
+ "daxctl-devices.sh",	//		""
+ "revoke_devmem",	//		""
+ "align.sh",		//		""
+ "dm.sh",		//		""
+ "mmap.sh",		//		""
+ "monitor.sh",		// To be fixed
+ "inject-smart.sh",	//    ""
+ "libndctl"		//    ""
+]
+
+// NOTE: The libjson-c doesn't like comments in json files, so keep the file
+// extension as .js to pacify.



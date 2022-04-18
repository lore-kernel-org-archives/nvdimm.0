Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B434A30
	for <nvdimm@lists.linux.dev>; Mon, 18 Apr 2022 17:11:04 +0000 (UTC)
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23IEHTIu010782;
	Mon, 18 Apr 2022 17:11:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : from : to : cc
 : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=C5iGUS6+LIhOpp8qDvVGzFWsIWbCdUEefphv1q7H+Pg=;
 b=FXYdUG5YBMoXL/OqDNi11vdKw00oqCPGYDBCP5jhDOJ1u54n4yUeBKlV2kaO/Hx/0Fl7
 wIc06Gwb6vdD+BU/nclZW0BUqoSPXqhBxYRJC2bqDZtKUGLN2hmt0SfcXg6QpE7AdVaG
 rGGiRBLA/J1BKNlzMt3VX7moat7RouZnFWykZsjZW5Y7Sl7zWwdEfBvMY5L0cCVODHua
 Xk/c7kiUBk+TlscXxx1+ZigQ3BPvWD6DDsLoyHmRW6kBUEiqzUClDNyBlXWhMQYX8i8A
 6ZIvqlfnUQhnG/jy5sttr5xk0PFo8I144/VV4op28cO0BxKYsjLGWay1Mr5L0cN4/vip RQ== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
	by mx0a-001b2d01.pphosted.com with ESMTP id 3fg7vn93yn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 18 Apr 2022 17:11:03 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
	by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23IH2q7A018068;
	Mon, 18 Apr 2022 17:11:00 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
	by ppma03ams.nl.ibm.com with ESMTP id 3ffne8k1kv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 18 Apr 2022 17:11:00 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
	by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23IHAv0d46924234
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 18 Apr 2022 17:10:57 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2EAA4A4054;
	Mon, 18 Apr 2022 17:10:57 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3BF6CA405C;
	Mon, 18 Apr 2022 17:10:56 +0000 (GMT)
Received: from lep8c.aus.stglabs.ibm.com (unknown [9.40.192.207])
	by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
	Mon, 18 Apr 2022 17:10:56 +0000 (GMT)
Subject: [RFC ndctl PATCH 5/9] test: Assign provider name based on the test
 family
From: Shivaprasad G Bhat <sbhat@linux.ibm.com>
To: nvdimm@lists.linux.dev, dan.j.williams@intel.com, vishal.l.verma@intel.com
Cc: aneesh.kumar@linux.ibm.com, sbhat@linux.ibm.com, vaibhav@linux.ibm.com
Date: Mon, 18 Apr 2022 12:10:55 -0500
Message-ID: 
 <165030184936.3224737.4501499015485134399.stgit@lep8c.aus.stglabs.ibm.com>
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
X-Proofpoint-ORIG-GUID: HUoRoKsbV6tvOJKpY7KTiAiIlD54KMF_
X-Proofpoint-GUID: HUoRoKsbV6tvOJKpY7KTiAiIlD54KMF_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-18_02,2022-04-15_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 phishscore=0 suspectscore=0 bulkscore=0 lowpriorityscore=0 spamscore=0
 priorityscore=1501 impostorscore=0 mlxlogscore=999 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204180101

The provider name is used by test scripts in a hard-coded fashion
like nfit_test.X today.

With the kernel modules names being different per nvdimm family
and the provider name too would change because of that.

The patch reassigns the correct provider name based on the test family.

The default family and the provider is set to INTEL to keep the
original behaviour intact.

Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
---
 test.h                        |    6 ++++++
 test/ack-shutdown-count-set.c |   11 +++--------
 test/core.c                   |   23 +++++++++++++++++++----
 test/daxdev-errors.sh         |    2 +-
 test/dsm-fail.c               |   27 ++++++++++++++++++---------
 test/libndctl.c               |    8 ++++----
 test/pmem_namespaces.c        |    4 +++-
 7 files changed, 54 insertions(+), 27 deletions(-)

diff --git a/test.h b/test.h
index cb61e0d9..7c7f620c 100644
--- a/test.h
+++ b/test.h
@@ -6,6 +6,12 @@
 
 struct ndctl_test;
 struct ndctl_ctx;
+
+extern char TEST_PROVIDER0[15];
+extern char TEST_PROVIDER1[15];
+extern int ndctl_test_family;
+void init_env(void);
+
 struct ndctl_test *ndctl_test_new(unsigned int kver, const char *testname);
 int ndctl_test_result(struct ndctl_test *test, int rc);
 int ndctl_test_get_skipped(struct ndctl_test *test);
diff --git a/test/ack-shutdown-count-set.c b/test/ack-shutdown-count-set.c
index 5d38ad9d..d35ee717 100644
--- a/test/ack-shutdown-count-set.c
+++ b/test/ack-shutdown-count-set.c
@@ -56,7 +56,7 @@ static void reset_bus(struct ndctl_bus *bus)
 
 static int do_test(struct ndctl_ctx *ctx, struct ndctl_test *test)
 {
-	struct ndctl_bus *bus = ndctl_bus_get_by_provider(ctx, "nfit_test.0");
+	struct ndctl_bus *bus = ndctl_bus_get_by_provider(ctx, TEST_PROVIDER0);
 	struct ndctl_dimm *dimm;
 	struct ndctl_region *region;
 	struct log_ctx log_ctx;
@@ -117,17 +117,12 @@ static int test_ack_shutdown_count_set(int loglevel, struct ndctl_test *test,
 
 int main(int argc, char *argv[])
 {
-	char *test_env = getenv("NDCTL_TEST_FAMILY");
 	struct ndctl_test *test = ndctl_test_new(0, argv[0]);
 	struct ndctl_ctx *ctx;
 	int rc;
 
-	if (!test) {
-		fprintf(stderr, "failed to initialize test\n");
-		return EXIT_FAILURE;
-	}
-
-	if (test_env && strcmp(test_env, "PAPR") == 0)
+	init_env();
+	if (ndctl_test_family == NVDIMM_FAMILY_PAPR)
 		return ndctl_test_result(test, 77);
 
 	rc = ndctl_new(&ctx);
diff --git a/test/core.c b/test/core.c
index 130e4aed..f5cf6c82 100644
--- a/test/core.c
+++ b/test/core.c
@@ -24,6 +24,21 @@ struct ndctl_test {
 	int skip;
 };
 
+char TEST_PROVIDER0[15] = "nfit_test.0";
+char TEST_PROVIDER1[15] = "nfit_test.1";
+int ndctl_test_family = NVDIMM_FAMILY_INTEL;
+
+void init_env(void)
+{
+	char *test_env = getenv("NDCTL_TEST_FAMILY");
+
+	if (test_env && strcmp(test_env, "PAPR") == 0) {
+		ndctl_test_family = NVDIMM_FAMILY_PAPR;
+		strcpy(TEST_PROVIDER0, "ndtest.0");
+		strcpy(TEST_PROVIDER1, "ndtest.1");
+	}
+}
+
 static unsigned int get_system_kver(void)
 {
 	const char *kver = getenv("KVER");
@@ -177,9 +192,9 @@ void ndctl_test_module_remove(struct kmod_ctx **ctx, struct kmod_module **mod,
 		struct ndctl_region *region;
 
 		if ((strcmp(ndctl_bus_get_provider(bus),
-			   "nfit_test.0") != 0) &&
+			   TEST_PROVIDER0) != 0) &&
 			strcmp(ndctl_bus_get_provider(bus),
-				"nfit_test.1") != 0)
+				TEST_PROVIDER1) != 0)
 			continue;
 
 		ndctl_region_foreach(bus, region)
@@ -360,7 +375,7 @@ retry:
 			struct ndctl_region *region;
 
 			if (strcmp(ndctl_bus_get_provider(bus),
-				   "nfit_test.0") != 0)
+				   TEST_PROVIDER0) != 0)
 				continue;
 			ndctl_region_foreach(bus, region)
 				ndctl_region_disable_invalidate(region);
@@ -386,7 +401,7 @@ retry:
 		struct ndctl_region *region;
 		struct ndctl_dimm *dimm;
 
-		if (strcmp(ndctl_bus_get_provider(bus), "nfit_test.0") != 0)
+		if (strcmp(ndctl_bus_get_provider(bus), TEST_PROVIDER0) != 0)
 			continue;
 
 		ndctl_region_foreach (bus, region)
diff --git a/test/daxdev-errors.sh b/test/daxdev-errors.sh
index f32f8b80..d80a536c 100755
--- a/test/daxdev-errors.sh
+++ b/test/daxdev-errors.sh
@@ -66,7 +66,7 @@ test -x $TEST_PATH/daxdev-errors
 $TEST_PATH/daxdev-errors $busdev $region
 
 # check badblocks, should be empty
-if read sector len < /sys/bus/platform/devices/nfit_test.0/$busdev/$region/badblocks; then
+if read sector len < /sys/bus/platform/devices/$NFIT_TEST_BUS0/$busdev/$region/badblocks; then
 	echo "badblocks empty, expected"
 fi
 [ -n "$sector" ] && echo "fail: $LINENO" && exit 1
diff --git a/test/dsm-fail.c b/test/dsm-fail.c
index e7a35ca6..382d8da3 100644
--- a/test/dsm-fail.c
+++ b/test/dsm-fail.c
@@ -18,8 +18,6 @@
 #include <ndctl/ndctl.h>
 #include <test.h>
 
-#define DIMM_PATH "/sys/devices/platform/nfit_test.0/nfit_test_dimm/test_dimm0"
-
 static int reset_bus(struct ndctl_bus *bus)
 {
 	struct ndctl_region *region;
@@ -176,10 +174,11 @@ static int test_regions_enable(struct ndctl_bus *bus,
 
 static int do_test(struct ndctl_ctx *ctx, struct ndctl_test *test)
 {
-	struct ndctl_bus *bus = ndctl_bus_get_by_provider(ctx, "nfit_test.0");
+	struct ndctl_bus *bus = ndctl_bus_get_by_provider(ctx, TEST_PROVIDER0);
 	struct ndctl_region *region, *victim_region = NULL;
 	struct ndctl_dimm *dimm, *victim = NULL;
 	char path[1024], buf[SYSFS_ATTR_SIZE];
+	char *dimm_path;
 	struct log_ctx log_ctx;
 	unsigned int handle;
 	int rc, err = 0;
@@ -197,7 +196,14 @@ static int do_test(struct ndctl_ctx *ctx, struct ndctl_test *test)
 		return -ENXIO;
 	}
 
-	sprintf(path, "%s/handle", DIMM_PATH);
+	if (asprintf(&dimm_path,
+			"/sys/devices/platform/%s/nfit_test_dimm/test_dimm0",
+			TEST_PROVIDER0) < 0) {
+		fprintf(stderr, "Path allocation failed\n");
+		return -ENOMEM;
+	}
+
+	sprintf(path, "%s/handle", dimm_path);
 	rc = __sysfs_read_attr(&log_ctx, path, buf);
 	if (rc) {
 		fprintf(stderr, "failed to retrieve test dimm handle\n");
@@ -280,7 +286,7 @@ static int do_test(struct ndctl_ctx *ctx, struct ndctl_test *test)
 		goto out;
 
 
-	rc = set_dimm_response(DIMM_PATH, ND_CMD_GET_CONFIG_SIZE, -EACCES,
+	rc = set_dimm_response(dimm_path, ND_CMD_GET_CONFIG_SIZE, -EACCES,
 			&log_ctx);
 	if (rc)
 		goto out;
@@ -290,7 +296,7 @@ static int do_test(struct ndctl_ctx *ctx, struct ndctl_test *test)
 	rc = test_regions_enable(bus, victim, victim_region, true, 2);
 	if (rc)
 		goto out;
-	rc = set_dimm_response(DIMM_PATH, ND_CMD_GET_CONFIG_SIZE, 0, &log_ctx);
+	rc = set_dimm_response(dimm_path, ND_CMD_GET_CONFIG_SIZE, 0, &log_ctx);
 	if (rc)
 		goto out;
 
@@ -300,7 +306,7 @@ static int do_test(struct ndctl_ctx *ctx, struct ndctl_test *test)
 	if (rc)
 		goto out;
 
-	rc = set_dimm_response(DIMM_PATH, ND_CMD_GET_CONFIG_DATA, -EACCES,
+	rc = set_dimm_response(dimm_path, ND_CMD_GET_CONFIG_DATA, -EACCES,
 			&log_ctx);
 	if (rc)
 		goto out;
@@ -311,7 +317,7 @@ static int do_test(struct ndctl_ctx *ctx, struct ndctl_test *test)
 	rc = test_regions_enable(bus, victim, victim_region, false, 0);
 	if (rc)
 		goto out;
-	rc = set_dimm_response(DIMM_PATH, ND_CMD_GET_CONFIG_DATA, 0, &log_ctx);
+	rc = set_dimm_response(dimm_path, ND_CMD_GET_CONFIG_DATA, 0, &log_ctx);
 	if (rc)
 		goto out;
 	rc = dimms_disable(bus);
@@ -320,7 +326,7 @@ static int do_test(struct ndctl_ctx *ctx, struct ndctl_test *test)
 
  out:
 	err = rc;
-	sprintf(path, "%s/fail_cmd", DIMM_PATH);
+	sprintf(path, "%s/fail_cmd", dimm_path);
 	sprintf(buf, "0\n");
 	rc = __sysfs_write_attr(&log_ctx, path, buf);
 	if (rc)
@@ -333,6 +339,7 @@ static int do_test(struct ndctl_ctx *ctx, struct ndctl_test *test)
 		rc = -ENXIO;
 	}
 	reset_bus(bus);
+	free(dimm_path);
 
 	if (rc)
 		err = rc;
@@ -368,6 +375,8 @@ int __attribute__((weak)) main(int argc, char *argv[])
 	struct ndctl_ctx *ctx;
 	int rc;
 
+	init_env();
+
 	if (!test) {
 		fprintf(stderr, "failed to initialize test\n");
 		return EXIT_FAILURE;
diff --git a/test/libndctl.c b/test/libndctl.c
index de95c83e..ab9f73c9 100644
--- a/test/libndctl.c
+++ b/test/libndctl.c
@@ -73,8 +73,6 @@
  *    dimm.
  */
 
-static const char *NFIT_PROVIDER0 = "nfit_test.0";
-static const char *NFIT_PROVIDER1 = "nfit_test.1";
 #define SZ_4K   0x00001000
 #define SZ_128K 0x00020000
 #define SZ_7M   0x00700000
@@ -2496,7 +2494,7 @@ static void reset_bus(struct ndctl_bus *bus, enum dimm_reset reset)
 
 static int do_test0(struct ndctl_ctx *ctx, struct ndctl_test *test)
 {
-	struct ndctl_bus *bus = ndctl_bus_get_by_provider(ctx, NFIT_PROVIDER0);
+	struct ndctl_bus *bus = ndctl_bus_get_by_provider(ctx, TEST_PROVIDER0);
 	struct ndctl_region *region;
 	int rc;
 
@@ -2550,7 +2548,7 @@ static int do_test0(struct ndctl_ctx *ctx, struct ndctl_test *test)
 
 static int do_test1(struct ndctl_ctx *ctx, struct ndctl_test *test)
 {
-	struct ndctl_bus *bus = ndctl_bus_get_by_provider(ctx, NFIT_PROVIDER1);
+	struct ndctl_bus *bus = ndctl_bus_get_by_provider(ctx, TEST_PROVIDER1);
 	int rc;
 
 	if (!bus)
@@ -2622,6 +2620,8 @@ int __attribute__((weak)) main(int argc, char *argv[])
 	struct ndctl_ctx *ctx;
 	int rc;
 
+	init_env();
+
 	if (!test) {
 		fprintf(stderr, "failed to initialize test\n");
 		return EXIT_FAILURE;
diff --git a/test/pmem_namespaces.c b/test/pmem_namespaces.c
index f3a00c79..973c9ce3 100644
--- a/test/pmem_namespaces.c
+++ b/test/pmem_namespaces.c
@@ -193,7 +193,7 @@ int test_pmem_namespaces(int log_level, struct ndctl_test *test,
 		fprintf(stderr, "ACPI.NFIT unavailable falling back to nfit_test\n");
 		rc = ndctl_test_init(&kmod_ctx, &mod, NULL, log_level, test);
 		ndctl_invalidate(ctx);
-		bus = ndctl_bus_get_by_provider(ctx, "nfit_test.0");
+		bus = ndctl_bus_get_by_provider(ctx, TEST_PROVIDER0);
 		if (rc < 0 || !bus) {
 			rc = 77;
 			ndctl_test_skip(test);
@@ -255,6 +255,8 @@ int __attribute__((weak)) main(int argc, char *argv[])
 	struct ndctl_ctx *ctx;
 	int rc;
 
+	init_env();
+
 	comm = argv[0];
 	if (!test) {
 		fprintf(stderr, "failed to initialize test\n");



Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E80CDA29
	for <nvdimm@lists.linux.dev>; Mon, 18 Apr 2022 17:17:40 +0000 (UTC)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
	by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23IGZ44J020532;
	Mon, 18 Apr 2022 17:17:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : from : to : cc
 : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=Xr9rbaQv5l4JO7u2KQAoWXIrja3MNcKumsbbFm2lyCk=;
 b=RzUTR4wKerlLBj1/A1FIwrJaXJECySuHGSqjrx8WpBxgXZz3JzruX1sr5Fibr8MWMHtE
 LJs5W+sBCv+vI2+XB4oInAb9UPj+RoG42mbALrCnvCRWF4Pp9rdib9yVrI9H4jTg0TqY
 TEyqhwBw1Q2XGAYOgi+XO4Zd1yFiKrbdnQDtRhTsODunRKMvT9zvchFTZnjfPW3N3a2P
 ZI1XO2+IzqpKQ2b9eag+O9tES6dyp8BDBByB8kztYikeyb4zPt4/v8bji3lJJQQpJGuK
 b8Op6zaXdtYfmyUTYV5cG9UILKHsp9zURTnAr/ogzLie+ePKw4PM6fJsIoNtxZLOEYif Nw== 
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
	by mx0b-001b2d01.pphosted.com with ESMTP id 3fg75pt03d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 18 Apr 2022 17:17:38 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
	by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23IHE2rW021508;
	Mon, 18 Apr 2022 17:17:36 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
	by ppma04fra.de.ibm.com with ESMTP id 3ffvt9a1ve-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 18 Apr 2022 17:17:36 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
	by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23IH4nm729295100
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 18 Apr 2022 17:04:49 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 50D58A4054;
	Mon, 18 Apr 2022 17:17:33 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 66B4AA405B;
	Mon, 18 Apr 2022 17:17:32 +0000 (GMT)
Received: from lep8c.aus.stglabs.ibm.com (unknown [9.40.192.207])
	by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
	Mon, 18 Apr 2022 17:17:32 +0000 (GMT)
Subject: [ndctl v3 PATCH 8/9] test/inject-smart: Enable inject-smart tests on
 ndtest
From: Shivaprasad G Bhat <sbhat@linux.ibm.com>
To: nvdimm@lists.linux.dev, dan.j.williams@intel.com, vishal.l.verma@intel.com
Cc: aneesh.kumar@linux.ibm.com, sbhat@linux.ibm.com, vaibhav@linux.ibm.com
Date: Mon, 18 Apr 2022 12:17:31 -0500
Message-ID: 
 <165030210764.3224737.17752152448193088910.stgit@lep8c.aus.stglabs.ibm.com>
In-Reply-To: 
 <165030175745.3224737.6985015146263991065.stgit@lep8c.aus.stglabs.ibm.com>
References: 
 <165030175745.3224737.6985015146263991065.stgit@lep8c.aus.stglabs.ibm.com>
User-Agent: StGit/1.1+40.g1b20
Content-Type: text/plain; charset="utf-8"
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: prlWRqJyKlhnXf53Izg_zUDz2ncE6EhF
X-Proofpoint-GUID: prlWRqJyKlhnXf53Izg_zUDz2ncE6EhF
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-18_02,2022-04-15_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 phishscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 impostorscore=0 mlxscore=0
 lowpriorityscore=0 malwarescore=0 priorityscore=1501 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204180101

The ndtest driver does not have the payloads defined for various
smart fields like the media|ctrl temperature, threshold parameters
for the current PAPR PDSM.

So, the patch makes the below changes to have a valid inject-smart
test run on the ndtest driver.
test/inject-smart.sh - Test only the shutdown_state and dimm_health
as only those are supported on ndtest. Skip rest of the tests. Reorder
the code for cleanliness
list-list-smart-dimms.c - Separate out filter_dimm implementation for
papr family with the relevant check.

Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>

---

Depends on the kernel patch -
https://patchwork.kernel.org/project/linux-nvdimm/patch/165027233876.3035289.4353747702027907365.stgit@lep8c.aus.stglabs.ibm.com/

Changelog:

Since v2:
Link: https://patchwork.kernel.org/project/linux-nvdimm/patch/163102901146.260256.6712219128280188987.stgit@99912bbcb4c7/
* Addedd the init_env() call and use the bus name post environment
  initialization.
* Split the patch to have the libndctl test specific fixes separately
* Updating the skip file to not skip the test, as it works now with this
  patch

Since v1:
Link: https://patchwork.kernel.org/project/linux-nvdimm/patch/162737350565.3944327.6662473656483436466.stgit@lep8c.aus.stglabs.ibm.com/
* Updated the commit message description

 test/inject-smart.sh   |   14 +++++++++-----
 test/list-smart-dimm.c |   33 ++++++++++++++++++++++++++++++++-
 test/meson.build       |    2 +-
 test/skip_PAPR.js      |    3 +--
 4 files changed, 43 insertions(+), 9 deletions(-)

diff --git a/test/inject-smart.sh b/test/inject-smart.sh
index 80af058a..07d04fb6 100755
--- a/test/inject-smart.sh
+++ b/test/inject-smart.sh
@@ -4,7 +4,6 @@
 
 rc=77
 . $(dirname $0)/common
-bus="$NFIT_TEST_BUS0"
 inj_val="42"
 
 trap 'err $LINENO' ERR
@@ -152,14 +151,18 @@ do_tests()
 	$NDCTL inject-smart -b $bus --uninject-all $dimm
 
 	# start tests
-	for field in "${fields_val[@]}"; do
-		test_field $field $inj_val
-	done
-
 	for field in "${fields_bool[@]}"; do
 		test_field $field
 	done
 
+	if [ $NDCTL_TEST_FAMILY == "PAPR" ]; then
+		return
+	fi
+
+	for field in "${fields_val[@]}"; do
+		test_field $field $inj_val
+	done
+
 	for field in "${fields_thresh[@]}"; do
 		test_field $field $inj_val "thresh"
 	done
@@ -168,6 +171,7 @@ do_tests()
 check_min_kver "4.19" || do_skip "kernel $KVER may not support smart (un)injection"
 check_prereq "jq"
 _init
+bus="$NFIT_TEST_BUS0"
 rc=1
 
 jlist=$($TEST_PATH/list-smart-dimm -b $bus)
diff --git a/test/list-smart-dimm.c b/test/list-smart-dimm.c
index f94277e8..7ad6c751 100644
--- a/test/list-smart-dimm.c
+++ b/test/list-smart-dimm.c
@@ -7,6 +7,7 @@
 #include <ndctl/libndctl.h>
 #include <util/parse-options.h>
 
+#include <test.h>
 #include <ndctl/filter.h>
 #include <ndctl/ndctl.h>
 #include <ndctl/json.h>
@@ -28,6 +29,32 @@ static bool filter_region(struct ndctl_region *region,
 	return true;
 }
 
+static void filter_ndtest_dimm(struct ndctl_dimm *dimm,
+			       struct ndctl_filter_ctx *ctx)
+{
+	struct list_filter_arg *lfa = ctx->list;
+	struct json_object *jdimm;
+
+	if (!ndctl_dimm_is_cmd_supported(dimm, ND_CMD_SMART))
+		return;
+
+	if (!lfa->jdimms) {
+		lfa->jdimms = json_object_new_array();
+		if (!lfa->jdimms) {
+			fail("\n");
+			return;
+		}
+	}
+
+	jdimm = util_dimm_to_json(dimm, lfa->flags);
+	if (!jdimm) {
+		fail("\n");
+		return;
+	}
+
+	json_object_array_add(lfa->jdimms, jdimm);
+}
+
 static void filter_dimm(struct ndctl_dimm *dimm, struct ndctl_filter_ctx *ctx)
 {
 	struct list_filter_arg *lfa = ctx->list;
@@ -92,6 +119,7 @@ int main(int argc, const char *argv[])
 	struct ndctl_filter_ctx fctx = { 0 };
 	struct list_filter_arg lfa = { 0 };
 
+	init_env();
 	rc = ndctl_new(&ctx);
 	if (rc < 0)
 		return EXIT_FAILURE;
@@ -102,7 +130,10 @@ int main(int argc, const char *argv[])
 		usage_with_options(u, options);
 
 	fctx.filter_bus = filter_bus;
-	fctx.filter_dimm = filter_dimm;
+	if (ndctl_test_family == NVDIMM_FAMILY_PAPR)
+		fctx.filter_dimm = filter_ndtest_dimm;
+	else
+		fctx.filter_dimm = filter_dimm;
 	fctx.filter_region = filter_region;
 	fctx.filter_namespace = NULL;
 	fctx.list = &lfa;
diff --git a/test/meson.build b/test/meson.build
index b33fe3b9..1f804afd 100644
--- a/test/meson.build
+++ b/test/meson.build
@@ -76,7 +76,7 @@ daxdev_errors = executable('daxdev-errors', [
   include_directories : root_inc,
 )
 
-list_smart_dimm = executable('list-smart-dimm', [
+list_smart_dimm = executable('list-smart-dimm', testcore + [
     'list-smart-dimm.c',
     '../ndctl/filter.c',
     '../util/json.c',
diff --git a/test/skip_PAPR.js b/test/skip_PAPR.js
index ec967c98..97ceda82 100644
--- a/test/skip_PAPR.js
+++ b/test/skip_PAPR.js
@@ -25,8 +25,7 @@
  "align.sh",		//		""
  "dm.sh",		//		""
  "mmap.sh",		//		""
- "monitor.sh",		// To be fixed
- "inject-smart.sh"	//    ""
+ "monitor.sh"		// To be fixed
 ]
 
 // NOTE: The libjson-c doesn't like comments in json files, so keep the file



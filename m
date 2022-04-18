Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 422C7A29
	for <nvdimm@lists.linux.dev>; Mon, 18 Apr 2022 17:11:20 +0000 (UTC)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23IDwchX005167;
	Mon, 18 Apr 2022 17:11:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : from : to : cc
 : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=86IsUsPYdo0u1q9rI6lvz0XvnVoT1JCkxr0dhMA+A3o=;
 b=IuLb5bdY5czpKzqOqqrmlPK8FahblrzcytjvhZ172eDPWD6DLY7/F1ERzGVgo2HRyzP5
 4fQ5u0eD+wm8uNTZ06g009TzfB9NXEHLZeBot9j33ySDwoHjynluAVixmzmZHk+ovlwq
 ndavr67e/7C/WOM/OkzEJFO/93SU0mdEe4qoxX2qtR1s9Ff0GTzj1p8M5E9tVLjsrsHr
 H70o0LBodQg33c+6KkKoCLeOnSTkRfZ/5nspTekiziunwBqZ0UEVvktxljE9t5C2t1DI
 aBEwrwu9LH8Px+3S3a//zTQyx8ccKCv5KUCT0BHGZhNSnATDmTR67I7WhSLCkxFJqUZp LA== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
	by mx0a-001b2d01.pphosted.com with ESMTP id 3fg7ek9mcv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 18 Apr 2022 17:11:17 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
	by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23IH34Qu018103;
	Mon, 18 Apr 2022 17:11:16 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
	by ppma03ams.nl.ibm.com with ESMTP id 3ffne8k1m1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 18 Apr 2022 17:11:15 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
	by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23IHBDfQ41091452
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 18 Apr 2022 17:11:13 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E747CA4051;
	Mon, 18 Apr 2022 17:11:12 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DE15CA4040;
	Mon, 18 Apr 2022 17:11:11 +0000 (GMT)
Received: from lep8c.aus.stglabs.ibm.com (unknown [9.40.192.207])
	by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
	Mon, 18 Apr 2022 17:11:11 +0000 (GMT)
Subject: [RFC ndctl PATCH 6/9] test: Enable PAPR test family tests after INTEL
 family tests
From: Shivaprasad G Bhat <sbhat@linux.ibm.com>
To: nvdimm@lists.linux.dev, dan.j.williams@intel.com, vishal.l.verma@intel.com
Cc: aneesh.kumar@linux.ibm.com, sbhat@linux.ibm.com, vaibhav@linux.ibm.com
Date: Mon, 18 Apr 2022 12:11:11 -0500
Message-ID: 
 <165030186233.3224737.11514053958670858450.stgit@lep8c.aus.stglabs.ibm.com>
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
X-Proofpoint-ORIG-GUID: GJtZzEbfflFSyc-HSU0tQVqFSYv7E2pr
X-Proofpoint-GUID: GJtZzEbfflFSyc-HSU0tQVqFSYv7E2pr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-18_02,2022-04-15_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 mlxscore=0 bulkscore=0 adultscore=0 spamscore=0
 mlxlogscore=999 impostorscore=0 phishscore=0 suspectscore=0 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204180101

The patch here attempts to run tests per-family loading
their respective kernel test modules based on the environment
variable set by the meson scripts. The skip_PAPR.js file is
added to ensure there are no false negatives from PAPR family.

The behaviour can be overridden by configure option
-Dtest-families=INTEL Or PAPR to run the tests for the specific
family.

When not running the "meson test" but running tests individually
the patch takes precaution to set the default settings to INTEL
to keep the current behaviour unaffected on individual tests.

Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
---
 meson.build       |   10 +++++++++
 meson_options.txt |    2 ++
 test/common       |   42 ++++++++++++++++++++++++++++++++--------
 test/core.c       |   17 +++++++++++++++-
 test/libndctl.c   |    2 +-
 test/meson.build  |   56 ++++++++++++++++++++++++++++++-----------------------
 6 files changed, 95 insertions(+), 34 deletions(-)

diff --git a/meson.build b/meson.build
index 42e11aa2..bf44ba4f 100644
--- a/meson.build
+++ b/meson.build
@@ -14,6 +14,16 @@ project('ndctl', 'c',
   ],
 )
 
+families = [ 'INTEL', 'PAPR' ]
+if get_option('test-families') != ''
+  families_str=get_option('test-families').split(',')
+  foreach f : families_str
+    if not families.contains(f.to_upper().strip())
+      error('Invalid test_family "@0@" specified.'.format(f))
+    endif
+  endforeach
+endif
+
 # rootprefixdir and rootlibdir setup copied from systemd:
 rootprefixdir = get_option('rootprefix')
 rootprefix_default = '/usr'
diff --git a/meson_options.txt b/meson_options.txt
index aa4a6dc8..95dfb395 100644
--- a/meson_options.txt
+++ b/meson_options.txt
@@ -7,6 +7,8 @@ option('keyutils', type : 'feature', value : 'enabled',
   description : 'enable nvdimm device passphrase management')
 option('test', type : 'feature', value : 'disabled',
   description : 'enable shipping tests in ndctl')
+option('test-families', type : 'string', value : 'INTEL,PAPR',
+  description : 'specify command separated test families in ndctl. Default is INTEL,PAPR')
 option('destructive', type : 'feature', value : 'disabled',
   description : 'enable tests that may clobber live system resources')
 option('poison', type : 'feature', value : 'enabled',
diff --git a/test/common b/test/common
index 31395ece..743f63bf 100644
--- a/test/common
+++ b/test/common
@@ -124,7 +124,7 @@ _cleanup()
 {
 	$NDCTL disable-region -b $NFIT_TEST_BUS0 all
 	$NDCTL disable-region -b $NFIT_TEST_BUS1 all
-	modprobe -r nfit_test
+	modprobe -r $TEST_MODULE
 	if [ $NDCTL_TEST_FAMILY == "INTEL" ]; then
 		modprobe -r nfit
 	fi
@@ -132,14 +132,40 @@ _cleanup()
 
 _init()
 {
-	set +e
-	modprobe nfit_test
-	if [ $? -ne 0 ]; then
-		echo "Could not load the nfit_test module."
-		exit 77
+	modules=$(awk -F" " 'BEGIN {ORS=" "} {print $1}' /proc/modules)
+	if [ "$NDCTL_TEST_FAMILY" == "PAPR" ]; then
+		TEST_MODULE="ndtest"
+		if [[ " ${modules[*]} "  =~ " nfit " ]] ||
+			[[ " ${modules[*]} " =~ " nfit_test " ]]; then
+			echo "The test module ${TEST_MODULE}.ko conflicts "
+			echo "with nfit and nfit_test. Unload them and retry.."
+			exit 77
+		fi
+		NFIT_TEST_BUS0=ndtest.0
+		NFIT_TEST_BUS1=ndtest.1
+	else
+		TEST_MODULE="nfit_test"
+		if [[ " ${modules[*]} " =~ "ndtest" ]]; then
+			echo "The test module ${TEST_MODULE}.ko conflicts "
+			echo "with ndtest. Unload it and retry.."
+			exit 77
+		fi
+	fi
+	if [ -d "/lib/modules/`uname -r`/extra/test" ]; then
+		if [ -f "/lib/modules/`uname -r`/extra/test/${TEST_MODULE}.ko" ]; then
+			set +e
+			modprobe ${TEST_MODULE}
+			if [ $? -ne 0 ]; then
+				echo "Could not load the ${TEST_MODULE} module."
+				exit 77
+			fi
+			set -e
+			trap _cleanup EXIT INT TERM HUP PIPE
+		else
+			echo "The test module ${TEST_MODULE}.ko not found. Skipping.."
+			exit 77
+		fi
 	fi
-	set -e
-	trap _cleanup EXIT INT TERM HUP PIPE
 }
 
 # json2var
diff --git a/test/core.c b/test/core.c
index f5cf6c82..ee7f5182 100644
--- a/test/core.c
+++ b/test/core.c
@@ -260,6 +260,18 @@ int ndctl_test_init(struct kmod_ctx **ctx, struct kmod_module **mod,
 	if (test_env && strcmp(test_env, "PAPR") == 0)
 		family = NVDIMM_FAMILY_PAPR;
 
+	if ((family == NVDIMM_FAMILY_INTEL) &&
+		(access("/sys/module/ndtest/initstate", F_OK) == 0)) {
+		fprintf(stderr,
+			"PAPR specific ndtest module loaded while attempting to test nfit_test\n");
+		return -ENOTSUP;
+	} else if ((family == NVDIMM_FAMILY_PAPR) &&
+		   ((access("/sys/module/nfit_test/initstate", F_OK) == 0) ||
+		    (access("/sys/module/nfit/initstate", F_OK) == 0))) {
+		fprintf(stderr, "nfit/nfit_test module loaded while attempting to test ndtest\n");
+		return -ENOTSUP;
+	}
+
 	if (family == -1) {
 		log_err(&log_ctx, "Cannot determine NVDIMM family\n");
 		return -ENOTSUP;
@@ -363,7 +375,10 @@ retry:
 		return -ENXIO;
 	}
 
-	rc = kmod_module_new_from_name(*ctx, "nfit_test", mod);
+	if (family == NVDIMM_FAMILY_INTEL)
+		rc = kmod_module_new_from_name(*ctx, "nfit_test", mod);
+	else
+		rc = kmod_module_new_from_name(*ctx, "ndtest", mod);
 	if (rc < 0) {
 		kmod_unref(*ctx);
 		return rc;
diff --git a/test/libndctl.c b/test/libndctl.c
index ab9f73c9..a70c1ed7 100644
--- a/test/libndctl.c
+++ b/test/libndctl.c
@@ -2596,7 +2596,7 @@ int test_libndctl(int loglevel, struct ndctl_test *test, struct ndctl_ctx *ctx)
 	err = ndctl_test_init(&kmod_ctx, &mod, ctx, loglevel, test);
 	if (err < 0) {
 		ndctl_test_skip(test);
-		fprintf(stderr, "nfit_test unavailable skipping tests\n");
+		fprintf(stderr, "test module couldnt not be loaded, skipping tests\n");
 		return 77;
 	}
 
diff --git a/test/meson.build b/test/meson.build
index 395b5333..b33fe3b9 100644
--- a/test/meson.build
+++ b/test/meson.build
@@ -177,6 +177,11 @@ tests = [
   [ 'track-uuid.sh',          track_uuid,	  'ndctl' ],
 ]
 
+families_string = get_option('test-families')
+if families_string != ''
+  families=families_string.split(',')
+endif
+
 if get_option('destructive').enabled()
   sub_section = find_program('sub-section.sh')
   dax_ext4 = find_program('dax-ext4.sh')
@@ -212,28 +217,31 @@ if get_option('keyutils').enabled()
   ]
 endif
 
-foreach t : tests
-  test(t[0], t[1],
-    is_parallel : false,
-    depends : [
-      ndctl_tool,
-      daxctl_tool,
-      cxl_tool,
-      smart_notify,
-      list_smart_dimm,
-      dax_pmd,
-      dax_errors,
-      daxdev_errors,
-      dax_dev,
-      mmap,
-    ],
-    suite: t[2],
-    timeout : 0,
-    env : [
-      'NDCTL=@0@'.format(ndctl_tool.full_path()),
-      'DAXCTL=@0@'.format(daxctl_tool.full_path()),
-      'TEST_PATH=@0@'.format(meson.current_build_dir()),
-      'DATA_PATH=@0@'.format(meson.current_source_dir()),
-    ],
-  )
+foreach f : families
+  foreach t : tests
+    test(t[0], t[1],
+      is_parallel : false,
+      depends : [
+        ndctl_tool,
+        daxctl_tool,
+        cxl_tool,
+        smart_notify,
+        list_smart_dimm,
+        dax_pmd,
+        dax_errors,
+        daxdev_errors,
+        dax_dev,
+        mmap,
+      ],
+      suite: [ t[2], f ],
+      timeout : 0,
+      env : [
+        'NDCTL=@0@'.format(ndctl_tool.full_path()),
+        'DAXCTL=@0@'.format(daxctl_tool.full_path()),
+        'TEST_PATH=@0@'.format(meson.current_build_dir()),
+        'DATA_PATH=@0@'.format(meson.current_source_dir()),
+        'NDCTL_TEST_FAMILY=@0@'.format(f.to_upper().strip()),
+      ],
+    )
+  endforeach
 endforeach



Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A85672FB6
	for <nvdimm@lists.linux.dev>; Tue, 27 Jul 2021 08:12:01 +0000 (UTC)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16R89kmr137436;
	Tue, 27 Jul 2021 04:11:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : from : to : cc
 : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=IA/3u4+R21l7i/YEcKDY3jnF7Mk15pkz8358D3Pe3sY=;
 b=QnH5rCwLFYV0JBUwXpmb4tB/zc/R/aSOG1EyDPJW5D5NBzAs6RU0jvPLF3XMDYJEHID+
 o4gUI14T62O7ILFFww63RN7DXLdZskZpSpYHp2vMaRblNQNwgf4leI9oSrwfs64cb/MM
 jKzyrEOUsU9LgiqHnEJFhPoUqAVIUXfUpV80Lw3Uz4SGHuKo0yTLNhG91jH5+TRc8n+t
 3ANtrC9GOFHsN4iF6Zti4GikkOS7c4HqecruNWxiTV+mxngwhlId6ZkRWSAQzgmQwmL1
 PTPQkEd8xK9IZ0uy23R7qdtjav3kRjyP1VnBwlJTtZitzxRe8bDPr4M5Nfxec1NnB0rM sw== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
	by mx0a-001b2d01.pphosted.com with ESMTP id 3a2dk9t516-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 27 Jul 2021 04:11:59 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
	by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16R83W0D016847;
	Tue, 27 Jul 2021 08:11:56 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
	by ppma03ams.nl.ibm.com with ESMTP id 3a235yg8wf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 27 Jul 2021 08:11:56 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
	by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16R8BqLv19464686
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 27 Jul 2021 08:11:52 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C9B8DA4051;
	Tue, 27 Jul 2021 08:11:52 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 83FE1A4057;
	Tue, 27 Jul 2021 08:11:51 +0000 (GMT)
Received: from lep8c.aus.stglabs.ibm.com (unknown [9.40.192.207])
	by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
	Tue, 27 Jul 2021 08:11:51 +0000 (GMT)
Subject: [PATCH 1/3] test/inject-smart: Enable inject-smart tests on ndtest
From: Shivaprasad G Bhat <sbhat@linux.ibm.com>
To: nvdimm@lists.linux.dev
Cc: aneesh.kumar@linux.ibm.com, sbhat@linux.ibm.com, vaibhav@linux.ibm.com,
        santosh@fossix.org, dan.j.williams@intel.com, ira.weiny@intel.com,
        vishal.l.verma@intel.com
Date: Tue, 27 Jul 2021 03:11:50 -0500
Message-ID: 
 <162737350565.3944327.6662473656483436466.stgit@lep8c.aus.stglabs.ibm.com>
In-Reply-To: 
 <162737349828.3944327.12958894438783947695.stgit@lep8c.aus.stglabs.ibm.com>
References: 
 <162737349828.3944327.12958894438783947695.stgit@lep8c.aus.stglabs.ibm.com>
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
X-Proofpoint-ORIG-GUID: bFtN_f5p77pZziruKC8Y5H9hJf5KxWXH
X-Proofpoint-GUID: bFtN_f5p77pZziruKC8Y5H9hJf5KxWXH
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-27_05:2021-07-27,2021-07-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 clxscore=1015
 mlxscore=0 mlxlogscore=999 spamscore=0 priorityscore=1501 impostorscore=0
 adultscore=0 bulkscore=0 malwarescore=0 lowpriorityscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2107270046

The ndtest driver does not have the payloads defined for various
smart fields like the media|ctrl temperature, threshold parameters
for the current PAPR PDSM.

So, the patch makes the below changes to have a valid inject-smart
test run on the ndtest driver.
test/libndctl.c - add separate checks to verify only relavent fields
on ndtest.
test/inject-smart.sh - Test only the shutdown_state and dimm_health
as only those are supported on ndtest. Skip rest of the tests. Reorder
the code for cleanliness
list-list-smart-dimms.c - Separate out filter_dimm implementation for
papr family with the relavent check.

Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
---
 test/inject-smart.sh   |   12 ++++++++----
 test/libndctl.c        |   46 ++++++++++++++++++++++++++++++++++++++++++++++
 test/list-smart-dimm.c |   36 +++++++++++++++++++++++++++++++++++-
 3 files changed, 89 insertions(+), 5 deletions(-)

diff --git a/test/inject-smart.sh b/test/inject-smart.sh
index 4ca83b8b..909c5b17 100755
--- a/test/inject-smart.sh
+++ b/test/inject-smart.sh
@@ -152,14 +152,18 @@ do_tests()
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
diff --git a/test/libndctl.c b/test/libndctl.c
index d9b50f41..ed7f9cc1 100644
--- a/test/libndctl.c
+++ b/test/libndctl.c
@@ -2211,6 +2211,46 @@ struct smart {
 		     life_used, shutdown_state, shutdown_count, vendor_size;
 };
 
+static int check_smart_ndtest(struct ndctl_bus *bus, struct ndctl_dimm *dimm,
+			struct check_cmd *check)
+{
+	static const struct smart smart_data = {
+		.flags = ND_SMART_HEALTH_VALID | ND_SMART_SHUTDOWN_VALID
+			| ND_SMART_SHUTDOWN_COUNT_VALID | ND_SMART_USED_VALID,
+		.health = ND_SMART_NON_CRITICAL_HEALTH,
+		.life_used = 5,
+		.shutdown_state = 0,
+		.shutdown_count = 42,
+		.vendor_size = 0,
+	};
+	struct ndctl_cmd *cmd = ndctl_dimm_cmd_new_smart(dimm);
+	int rc;
+
+	if (!cmd) {
+		fprintf(stderr, "%s: dimm: %#x failed to create cmd\n",
+				__func__, ndctl_dimm_get_handle(dimm));
+		return -ENXIO;
+	}
+
+	rc = ndctl_cmd_submit(cmd);
+	if (rc < 0) {
+		fprintf(stderr, "%s: dimm: %#x failed to submit cmd: %d\n",
+			__func__, ndctl_dimm_get_handle(dimm), rc);
+		ndctl_cmd_unref(cmd);
+		return rc;
+	}
+
+	__check_smart(dimm, cmd, flags, -1);
+	__check_smart(dimm, cmd, health, -1);
+	__check_smart(dimm, cmd, life_used, -1);
+	__check_smart(dimm, cmd, shutdown_state, -1);
+	__check_smart(dimm, cmd, shutdown_count, -1);
+	__check_smart(dimm, cmd, vendor_size, -1);
+
+	check->cmd = cmd;
+	return 0;
+}
+
 static int check_smart(struct ndctl_bus *bus, struct ndctl_dimm *dimm,
 		struct check_cmd *check)
 {
@@ -2434,6 +2474,12 @@ static int check_commands(struct ndctl_bus *bus, struct ndctl_dimm *dimm,
 	};
 
 	unsigned int i, rc = 0;
+	char *test_env = getenv("NDCTL_TEST_FAMILY");
+
+	if (test_env && strcmp(test_env, "PAPR") == 0) {
+		dimm_commands &= ~(1 << ND_CMD_SMART_THRESHOLD);
+		__check_dimm_cmds[ND_CMD_SMART].check_fn = &check_smart_ndtest;
+	}
 
 	/*
 	 * The kernel did not start emulating v1.2 namespace spec smart data
diff --git a/test/list-smart-dimm.c b/test/list-smart-dimm.c
index 00c24e11..98a1f03b 100644
--- a/test/list-smart-dimm.c
+++ b/test/list-smart-dimm.c
@@ -26,6 +26,32 @@ static bool filter_region(struct ndctl_region *region,
 	return true;
 }
 
+static void filter_ndtest_dimm(struct ndctl_dimm *dimm,
+			       struct util_filter_ctx *ctx)
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
 static void filter_dimm(struct ndctl_dimm *dimm, struct util_filter_ctx *ctx)
 {
 	struct list_filter_arg *lfa = ctx->list;
@@ -89,6 +115,11 @@ int main(int argc, const char *argv[])
 	};
 	struct util_filter_ctx fctx = { 0 };
 	struct list_filter_arg lfa = { 0 };
+	char *test_env = getenv("NDCTL_TEST_FAMILY");
+	int family = NVDIMM_FAMILY_INTEL;
+
+	if (test_env && strcmp(test_env, "PAPR") == 0)
+		family = NVDIMM_FAMILY_PAPR;
 
 	rc = ndctl_new(&ctx);
 	if (rc < 0)
@@ -100,7 +131,10 @@ int main(int argc, const char *argv[])
 		usage_with_options(u, options);
 
 	fctx.filter_bus = filter_bus;
-	fctx.filter_dimm = filter_dimm;
+	if (family == NVDIMM_FAMILY_PAPR)
+		fctx.filter_dimm = filter_ndtest_dimm;
+	else
+		fctx.filter_dimm = filter_dimm;
 	fctx.filter_region = filter_region;
 	fctx.filter_namespace = NULL;
 	fctx.list = &lfa;



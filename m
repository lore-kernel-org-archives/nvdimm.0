Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F75E72
	for <nvdimm@lists.linux.dev>; Tue,  7 Sep 2021 15:37:20 +0000 (UTC)
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
	by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 187FXB0f184623;
	Tue, 7 Sep 2021 11:37:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : from : to : cc
 : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=Flz3rIB7rqOUe3YRENkcLgeILPZVbfzSLe27lTMm4CQ=;
 b=jIiKcp7+dXWetrF/JSR1jf1pSD4dh84GMh47DJXx8BZWaW3TsXGLiCnElOfs/LDN+hv4
 68e1X5IcywPUSaqkA3Gl1APv4XYiFqIDrGS9el9a4+FDWOqcr/02OXEl1Ir4ZPHkocDn
 2LWrMHjZZrnY9lioe9VAn+HVqbvPOGDaypbIylPVu6YDRin0PEI6y2h7wwJIpdfHB7MY
 +y3g+Zmc0PS+Xlmrn+EbUrqTF4Y4CT7hfz3BodRnwvq5GSk5QBFBC7YxxaINQQU5duR0
 GT76R14DfPLKo8B0mMhmdksfTx1P66gDgsY5lyiBYh5FZ6e+fCbGRhBAfw4mb7yQXOaT LA== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
	by mx0b-001b2d01.pphosted.com with ESMTP id 3ax6tm7458-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 Sep 2021 11:37:17 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
	by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 187FS48K027340;
	Tue, 7 Sep 2021 15:37:16 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
	by ppma04ams.nl.ibm.com with ESMTP id 3av0e9hmax-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 Sep 2021 15:37:15 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
	by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 187FbC7Z36110776
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 7 Sep 2021 15:37:12 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C34C911C05C;
	Tue,  7 Sep 2021 15:37:11 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A403F11C083;
	Tue,  7 Sep 2021 15:37:10 +0000 (GMT)
Received: from [172.17.0.2] (unknown [9.40.192.207])
	by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
	Tue,  7 Sep 2021 15:37:10 +0000 (GMT)
Subject: [PATCH v2 1/3] test/inject-smart: Enable inject-smart tests on ndtest
From: Shivaprasad G Bhat <sbhat@linux.ibm.com>
To: nvdimm@lists.linux.dev
Cc: aneesh.kumar@linux.ibm.com, sbhat@linux.ibm.com, vaibhav@linux.ibm.com,
        dan.j.williams@intel.com, ira.weiny@intel.com,
        vishal.l.verma@intel.com
Date: Tue, 07 Sep 2021 15:37:09 +0000
Message-ID: <163102901146.260256.6712219128280188987.stgit@99912bbcb4c7>
In-Reply-To: <163102900429.260256.4127745415928272196.stgit@99912bbcb4c7>
References: <163102900429.260256.4127745415928272196.stgit@99912bbcb4c7>
User-Agent: StGit/1.1+40.g1b20
Content-Type: text/plain; charset="utf-8"
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 7coqxtDkKxRBmGDn9LAoZ38dm1YQJGrU
X-Proofpoint-GUID: 7coqxtDkKxRBmGDn9LAoZ38dm1YQJGrU
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-09-07_05:2021-09-07,2021-09-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 priorityscore=1501 spamscore=0 mlxscore=0 phishscore=0 bulkscore=0
 clxscore=1015 impostorscore=0 adultscore=0 mlxlogscore=826
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2108310000 definitions=main-2109070101

The ndtest driver supports the usafe_shutdown and fatal dimm
state for the current PAPR dsm.

This patch implements various ndctl_cmd_smart_inject*
functions which are supportable with the current PAPR dsm and
fixes the inject-smart.sh to exploit them. The inject-smart
testing order is changed to test the flag based tests first
followed by value based ones as that is much cleaner.

The PAPR dsm doesn't have the payload structures defined for the
smart thresholds. So, the patch carefully skips the threshold
flag checks when required in the list-smart-dimms.

test/libndctl: Enable libndctl tests on ndtest

The ndtest/papr dsm dont have the smart threshold payloads defined
and various smart fields like media/ctrl temeratures, spares etc.

Test only whats relavent and disable/skip the rest.

Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
---
Changelog:

Since v1:
Link: https://patchwork.kernel.org/project/linux-nvdimm/patch/162737350565.3944327.6662473656483436466.stgit@lep8c.aus.stglabs.ibm.com/
* Updated the commit message description

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



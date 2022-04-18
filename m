Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB46DA29
	for <nvdimm@lists.linux.dev>; Mon, 18 Apr 2022 17:10:25 +0000 (UTC)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23IGIiK0016996;
	Mon, 18 Apr 2022 17:10:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : from : to : cc
 : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=OsEke/7OB8/xkVaFAhd/D0jZL1z6mL5+MBiR2jh4bBQ=;
 b=XjpL9qn7a0rVxgpLPW8WQhbUEK8bOThaPCDVtHnVyYZeqML4xFz647L5KLiqInXlDcEq
 mOsa+8Ko+NL60Rcru6xd0nHTVenrXecxSW7A0s04X/UlgmfKfPLQmEvD2F4PuTjmvN2d
 M/i229+bDfvcfzohpLHK0/CSlBfQutYJxVP75+AaUYdtMvL5zHFdVHrdjh8S4hZ6Jb+Y
 IUjWWpNN5sXXbv0Q7vBd8QUhDTDNd6nFGMTmspXtA1GKF0fyCaHZSouTLQBhK67iI6wC
 ss53yBgLHnRL+GDHbGKlHKkm4ko49y0S5l1B7qjLiCTCndVcyiDmsEojMcRGnWE5itU3 2w== 
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
	by mx0a-001b2d01.pphosted.com with ESMTP id 3fg7d6s7ef-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 18 Apr 2022 17:10:24 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
	by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23IH2pUY027218;
	Mon, 18 Apr 2022 17:10:21 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
	by ppma01fra.de.ibm.com with ESMTP id 3ffne8tdfe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 18 Apr 2022 17:10:21 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
	by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23IHAI9w37945758
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 18 Apr 2022 17:10:18 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5FD9542047;
	Mon, 18 Apr 2022 17:10:18 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 746264203F;
	Mon, 18 Apr 2022 17:10:17 +0000 (GMT)
Received: from lep8c.aus.stglabs.ibm.com (unknown [9.40.192.207])
	by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
	Mon, 18 Apr 2022 17:10:17 +0000 (GMT)
Subject: [RFC ndctl PATCH 2/9] test: core: Fix module unload failures
From: Shivaprasad G Bhat <sbhat@linux.ibm.com>
To: nvdimm@lists.linux.dev, dan.j.williams@intel.com, vishal.l.verma@intel.com
Cc: aneesh.kumar@linux.ibm.com, sbhat@linux.ibm.com, vaibhav@linux.ibm.com
Date: Mon, 18 Apr 2022 12:10:16 -0500
Message-ID: 
 <165030181048.3224737.7100905803654677976.stgit@lep8c.aus.stglabs.ibm.com>
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
X-Proofpoint-ORIG-GUID: 58wJGlHTaJb70Rx-FKjo5fKgxXIW4hCX
X-Proofpoint-GUID: 58wJGlHTaJb70Rx-FKjo5fKgxXIW4hCX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-18_02,2022-04-15_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 lowpriorityscore=0 impostorscore=0 mlxlogscore=999 phishscore=0
 clxscore=1015 spamscore=0 malwarescore=0 priorityscore=1501 mlxscore=0
 adultscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2202240000 definitions=main-2204180101

The kmod_module_remove_module() called by the tests without
disabling the regions from the test provider. So, the module
remove fails during many of the tests.

The patch writes a wrapper which properly disables the test provider
specific regions before calling the kmod_module_remove_module().

Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
---
 test.h                        |    2 ++
 test/ack-shutdown-count-set.c |    4 ++--
 test/core.c                   |   28 ++++++++++++++++++++++++++++
 test/dsm-fail.c               |    4 ++--
 test/libndctl.c               |    3 +--
 test/pmem_namespaces.c        |   23 ++++++-----------------
 6 files changed, 41 insertions(+), 23 deletions(-)

diff --git a/test.h b/test.h
index b2267e66..6cff4189 100644
--- a/test.h
+++ b/test.h
@@ -23,6 +23,8 @@ struct kmod_module;
 int ndctl_test_init(struct kmod_ctx **ctx, struct kmod_module **mod,
 		struct ndctl_ctx *nd_ctx, int log_level,
 		struct ndctl_test *test);
+int ndctl_test_module_remove(struct kmod_ctx **ctx, struct kmod_module **mod,
+			struct ndctl_ctx *nd_ctx);
 
 struct ndctl_ctx;
 int test_parent_uuid(int loglevel, struct ndctl_test *test, struct ndctl_ctx *ctx);
diff --git a/test/ack-shutdown-count-set.c b/test/ack-shutdown-count-set.c
index f091a404..2d77aa07 100644
--- a/test/ack-shutdown-count-set.c
+++ b/test/ack-shutdown-count-set.c
@@ -109,9 +109,9 @@ static int test_ack_shutdown_count_set(int loglevel, struct ndctl_test *test,
 	}
 
 	result = do_test(ctx, test);
-	kmod_module_remove_module(mod, 0);
 
-	kmod_unref(kmod_ctx);
+	ndctl_test_module_remove(&kmod_ctx, &mod, ctx);
+
 	return result;
 }
 
diff --git a/test/core.c b/test/core.c
index 5d1aa237..7b23e258 100644
--- a/test/core.c
+++ b/test/core.c
@@ -107,6 +107,34 @@ int ndctl_test_get_skipped(struct ndctl_test *test)
 	return test->skip;
 }
 
+void ndctl_test_module_remove(struct kmod_ctx **ctx, struct kmod_module **mod,
+				struct ndctl_ctx *nd_ctx)
+{
+	struct ndctl_bus *bus;
+	int rc;
+
+	ndctl_bus_foreach(nd_ctx, bus) {
+		struct ndctl_region *region;
+
+		if ((strcmp(ndctl_bus_get_provider(bus),
+			   "nfit_test.0") != 0) &&
+			strcmp(ndctl_bus_get_provider(bus),
+				"nfit_test.1") != 0)
+			continue;
+
+		ndctl_region_foreach(bus, region)
+			ndctl_region_disable_invalidate(region);
+	}
+
+	rc = kmod_module_remove_module(*mod, 0);
+	if (rc < 0 && rc != -ENOENT) {
+		fprintf(stderr, "couldn't remove module %s\n",
+				    strerror(-rc));
+	}
+
+	kmod_unref(*ctx);
+}
+
 int ndctl_test_init(struct kmod_ctx **ctx, struct kmod_module **mod,
 		struct ndctl_ctx *nd_ctx, int log_level,
 		struct ndctl_test *test)
diff --git a/test/dsm-fail.c b/test/dsm-fail.c
index 5b443dcd..65ac2bd4 100644
--- a/test/dsm-fail.c
+++ b/test/dsm-fail.c
@@ -356,9 +356,9 @@ int test_dsm_fail(int loglevel, struct ndctl_test *test, struct ndctl_ctx *ctx)
 	}
 
 	result = do_test(ctx, test);
-	kmod_module_remove_module(mod, 0);
 
-	kmod_unref(kmod_ctx);
+	ndctl_test_module_remove(&kmod_ctx, &mod, ctx);
+
 	return result;
 }
 
diff --git a/test/libndctl.c b/test/libndctl.c
index 51245cf4..df61f84c 100644
--- a/test/libndctl.c
+++ b/test/libndctl.c
@@ -2612,8 +2612,7 @@ int test_libndctl(int loglevel, struct ndctl_test *test, struct ndctl_ctx *ctx)
 
 	if (i >= ARRAY_SIZE(do_test))
 		result = EXIT_SUCCESS;
-	kmod_module_remove_module(mod, 0);
-	kmod_unref(kmod_ctx);
+	ndctl_test_module_remove(&kmod_ctx, &mod, ctx);
 	return result;
 }
 
diff --git a/test/pmem_namespaces.c b/test/pmem_namespaces.c
index 4bafff51..64207020 100644
--- a/test/pmem_namespaces.c
+++ b/test/pmem_namespaces.c
@@ -198,7 +198,7 @@ int test_pmem_namespaces(int log_level, struct ndctl_test *test,
 			rc = 77;
 			ndctl_test_skip(test);
 			fprintf(stderr, "nfit_test unavailable skipping tests\n");
-			goto err_module;
+			goto exit;
 		}
 	}
 
@@ -214,7 +214,7 @@ int test_pmem_namespaces(int log_level, struct ndctl_test *test,
 		if (rc < 0) {
 			fprintf(stderr, "failed to zero %s\n",
 					ndctl_dimm_get_devname(dimm));
-			goto err;
+			goto exit;
 		}
 	}
 
@@ -228,14 +228,14 @@ int test_pmem_namespaces(int log_level, struct ndctl_test *test,
 	if (!pmem_region || ndctl_region_enable(pmem_region) < 0) {
 		fprintf(stderr, "%s: failed to find PMEM region\n", comm);
 		rc = -ENODEV;
-		goto err;
+		goto exit;
 	}
 
 	rc = -ENODEV;
 	ndns = create_pmem_namespace(pmem_region);
 	if (!ndns) {
 		fprintf(stderr, "%s: failed to create PMEM namespace\n", comm);
-		goto err;
+		goto exit;
 	}
 
 	sprintf(bdev, "/dev/%s", ndctl_namespace_get_block_device(ndns));
@@ -243,20 +243,9 @@ int test_pmem_namespaces(int log_level, struct ndctl_test *test,
 
 	disable_pmem_namespace(ndns);
 
- err:
-	/* unload nfit_test */
-	bus = ndctl_bus_get_by_provider(ctx, "nfit_test.0");
-	if (bus)
-		ndctl_region_foreach(bus, region)
-			ndctl_region_disable_invalidate(region);
-	bus = ndctl_bus_get_by_provider(ctx, "nfit_test.1");
-	if (bus)
-		ndctl_region_foreach(bus, region)
-			ndctl_region_disable_invalidate(region);
-	kmod_module_remove_module(mod, 0);
+ exit:
+	ndctl_test_module_remove(&kmod_ctx, &mod, ctx);
 
- err_module:
-	kmod_unref(kmod_ctx);
 	return rc;
 }
 



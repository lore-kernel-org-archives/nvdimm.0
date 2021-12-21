Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50D172C82
	for <nvdimm@lists.linux.dev>; Tue, 21 Dec 2021 14:45:14 +0000 (UTC)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BLDe3E4007416;
	Tue, 21 Dec 2021 14:45:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : from : to : cc
 : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=pp1;
 bh=JZIucTQP22m3OkJ/9eYdM7emApqGxg8/H+46VuJTq8c=;
 b=Sa7Y9yQicsyQNGZRsEI0Xvv1jQBidyeK9aK8+McsbZ6zZxykoqiAlx/LTdUQ4n4fjVCm
 edKJFO8KdXoPQbjcB/M4/am3jhkBRvH12dz3iAcsseWw7LputuuNF5U+StM7c3zKsB8g
 dmIFnvAHTnYdzzoRLAmNd7W4d0wI8xb1ufp2VMUqUcHtNm55ZBc3oyOeRjSBDyhVP9ef
 mMkkbnSD4E24e/Vq6Shar+89f9wyPYkTKQPSNuS/0ndYngGUTsvcaPEkYjDW6Bu3MIYX
 tkR3zUxZ+AAbjUF9aQDU1kN7Nmbe5iqYXYaM1ECR0sDgYawJ8KoEa7SbBw2EdGgp/n7n NA== 
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
	by mx0a-001b2d01.pphosted.com with ESMTP id 3d3g0u9daa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Dec 2021 14:45:11 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
	by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1BLEhkkl028957;
	Tue, 21 Dec 2021 14:45:10 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
	by ppma06fra.de.ibm.com with ESMTP id 3d16wjwmcb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Dec 2021 14:45:10 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
	by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1BLEj5C036438510
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Dec 2021 14:45:05 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 368244207D;
	Tue, 21 Dec 2021 14:45:05 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3979742047;
	Tue, 21 Dec 2021 14:45:04 +0000 (GMT)
Received: from lep8c.aus.stglabs.ibm.com (unknown [9.40.192.207])
	by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
	Tue, 21 Dec 2021 14:45:04 +0000 (GMT)
Subject: [ndctl REPOST PATCH v3] libndctl: Update nvdimm flags in
 ndctl_cmd_submit()
From: Shivaprasad G Bhat <sbhat@linux.ibm.com>
To: nvdimm@lists.linux.dev
Cc: aneesh.kumar@linux.ibm.com, sbhat@linux.ibm.com, vaibhav@linux.ibm.com,
        dan.j.williams@intel.com, ira.weiny@intel.com,
        vishal.l.verma@intel.com
Date: Tue, 21 Dec 2021 08:45:02 -0600
Message-ID: 
 <164009789816.744139.2870779016511283907.stgit@lep8c.aus.stglabs.ibm.com>
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
X-Proofpoint-GUID: RbRm495FC8zK38LJY2jaaFhCe75hjhKr
X-Proofpoint-ORIG-GUID: RbRm495FC8zK38LJY2jaaFhCe75hjhKr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-21_04,2021-12-21_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 adultscore=0
 lowpriorityscore=0 mlxlogscore=999 spamscore=0 mlxscore=0 clxscore=1015
 impostorscore=0 bulkscore=0 suspectscore=0 priorityscore=1501 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112210068

From: Vaibhav Jain <vaibhav@linux.ibm.com>

Presently after performing an inject-smart the nvdimm flags reported are
out of date as shown below where no 'smart_notify' or 'flush_fail' flags
were reported even though they are set after injecting the smart error:

$ sudo inject-smart -fU nmem0
[
  {
    "dev":"nmem0",
    "health":{
      "health_state":"fatal",
      "shutdown_state":"dirty",
      "shutdown_count":0
    }
  }
]
$ sudo cat /sys/class/nd/ndctl0/device/nmem0/papr/flags
flush_fail smart_notify

This happens because nvdimm flags are only parsed once during its probe
and not refreshed even after a inject-smart operation makes them out of
date. To fix this the patch forces an update of nvdimm flags via newly
introduced ndctl_refresh_dimm_flags() thats called successfully submitting
a 'struct ndctl_cmd' in ndctl_cmd_submit(). This ensures that correct
nvdimm flags are reported after an interaction with the kernel module which
may trigger a change nvdimm-flags. With this implemented correct nvdimm
flags are reported after a inject-smart operation:

$ sudo ndctl inject-smart -fU nmem0
[
  {
    "dev":"nmem0",
    "flag_failed_flush":true,
    "flag_smart_event":true,
    "health":{
      "health_state":"fatal",
      "shutdown_state":"dirty",
      "shutdown_count":0
    }
  }
]

The patch refactors populate_dimm_attributes() to move the nvdimm flags
parsing code to the newly introduced ndctl_refresh_dimm_flags()
export. Since reading nvdimm flags requires constructing path using
'bus_prefix' which is only available during add_dimm(), the patch
introduces a new member 'struct ndctl_dimm.bus_prefix' to cache its
value. During ndctl_refresh_dimm_flags() the cached bus_prefix is used to
read the contents of the nvdimm flag file and pass it on to the appropriate
flag parsing function. Finally ndctl_refresh_dimm_flags() is invoked at the
end of ndctl_cmd_submit() if nd-command submission succeeds.

Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
---
 ndctl/lib/libndctl.c |   52 +++++++++++++++++++++++++++++++++++++-------------
 ndctl/lib/private.h  |    1 +
 ndctl/libndctl.h     |    1 +
 3 files changed, 40 insertions(+), 14 deletions(-)

diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index 36ad1e7b..70b556bd 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -608,6 +608,7 @@ static void free_dimm(struct ndctl_dimm *dimm)
 	free(dimm->unique_id);
 	free(dimm->dimm_buf);
 	free(dimm->dimm_path);
+	free(dimm->bus_prefix);
 	if (dimm->module)
 		kmod_module_unref(dimm->module);
 	if (dimm->health_eventfd > -1)
@@ -1670,14 +1671,34 @@ static int ndctl_bind(struct ndctl_ctx *ctx, struct kmod_module *module,
 static int ndctl_unbind(struct ndctl_ctx *ctx, const char *devpath);
 static struct kmod_module *to_module(struct ndctl_ctx *ctx, const char *alias);
 
+void ndctl_refresh_dimm_flags(struct ndctl_dimm *dimm)
+{
+	struct ndctl_ctx *ctx = dimm->bus->ctx;
+	char *path = dimm->dimm_buf;
+	char buf[SYSFS_ATTR_SIZE];
+
+	/* Construct path to dimm flags sysfs file */
+	sprintf(path, "%s/%s/flags", dimm->dimm_path, dimm->bus_prefix);
+
+	if (sysfs_read_attr(ctx, path, buf) < 0)
+		return;
+
+	/* Reset the flags */
+	dimm->flags.flags = 0;
+	if (ndctl_bus_has_nfit(dimm->bus))
+		parse_nfit_mem_flags(dimm, buf);
+	else if (ndctl_bus_is_papr_scm(dimm->bus))
+		parse_papr_flags(dimm, buf);
+}
+
 static int populate_dimm_attributes(struct ndctl_dimm *dimm,
-				    const char *dimm_base,
-				    const char *bus_prefix)
+				    const char *dimm_base)
 {
 	int i, rc = -1;
 	char buf[SYSFS_ATTR_SIZE];
 	struct ndctl_ctx *ctx = dimm->bus->ctx;
 	char *path = calloc(1, strlen(dimm_base) + 100);
+	const char *bus_prefix = dimm->bus_prefix;
 
 	if (!path)
 		return -ENOMEM;
@@ -1761,16 +1782,10 @@ static int populate_dimm_attributes(struct ndctl_dimm *dimm,
 	}
 
 	sprintf(path, "%s/%s/flags", dimm_base, bus_prefix);
-	if (sysfs_read_attr(ctx, path, buf) == 0) {
-		if (ndctl_bus_has_nfit(dimm->bus))
-			parse_nfit_mem_flags(dimm, buf);
-		else if (ndctl_bus_is_papr_scm(dimm->bus)) {
-			dimm->cmd_family = NVDIMM_FAMILY_PAPR;
-			parse_papr_flags(dimm, buf);
-		}
-	}
-
 	dimm->health_eventfd = open(path, O_RDONLY|O_CLOEXEC);
+
+	ndctl_refresh_dimm_flags(dimm);
+
 	rc = 0;
  err_read:
 
@@ -1826,8 +1841,9 @@ static int add_papr_dimm(struct ndctl_dimm *dimm, const char *dimm_base)
 
 		rc = 0;
 	} else if (strcmp(buf, "nvdimm_test") == 0) {
+		dimm->cmd_family = NVDIMM_FAMILY_PAPR;
 		/* probe via common populate_dimm_attributes() */
-		rc = populate_dimm_attributes(dimm, dimm_base, "papr");
+		rc = populate_dimm_attributes(dimm, dimm_base);
 	}
 out:
 	free(path);
@@ -1924,9 +1940,13 @@ static void *add_dimm(void *parent, int id, const char *dimm_base)
 	dimm->formats = formats;
 	/* Check if the given dimm supports nfit */
 	if (ndctl_bus_has_nfit(bus)) {
-		rc = populate_dimm_attributes(dimm, dimm_base, "nfit");
+		dimm->bus_prefix = strdup("nfit");
+		rc = dimm->bus_prefix ?
+			populate_dimm_attributes(dimm, dimm_base) : -ENOMEM;
 	} else if (ndctl_bus_has_of_node(bus)) {
-		rc = add_papr_dimm(dimm, dimm_base);
+		dimm->bus_prefix = strdup("papr");
+		rc = dimm->bus_prefix ?
+			add_papr_dimm(dimm, dimm_base) : -ENOMEM;
 	}
 
 	if (rc == -ENODEV) {
@@ -3506,6 +3526,10 @@ NDCTL_EXPORT int ndctl_cmd_submit(struct ndctl_cmd *cmd)
 		rc = -ENXIO;
 	}
 	close(fd);
+
+	/* update dimm-flags if command submitted successfully */
+	if (!rc && cmd->dimm)
+		ndctl_refresh_dimm_flags(cmd->dimm);
  out:
 	cmd->status = rc;
 	return rc;
diff --git a/ndctl/lib/private.h b/ndctl/lib/private.h
index d442e6c1..cd2265ff 100644
--- a/ndctl/lib/private.h
+++ b/ndctl/lib/private.h
@@ -75,6 +75,7 @@ struct ndctl_dimm {
 	char *unique_id;
 	char *dimm_path;
 	char *dimm_buf;
+	char *bus_prefix;
 	int health_eventfd;
 	int buf_len;
 	int id;
diff --git a/ndctl/libndctl.h b/ndctl/libndctl.h
index 4d5cdbf6..b1bafd6d 100644
--- a/ndctl/libndctl.h
+++ b/ndctl/libndctl.h
@@ -223,6 +223,7 @@ int ndctl_dimm_is_active(struct ndctl_dimm *dimm);
 int ndctl_dimm_is_enabled(struct ndctl_dimm *dimm);
 int ndctl_dimm_disable(struct ndctl_dimm *dimm);
 int ndctl_dimm_enable(struct ndctl_dimm *dimm);
+void ndctl_refresh_dimm_flags(struct ndctl_dimm *dimm);
 
 struct ndctl_cmd;
 struct ndctl_cmd *ndctl_bus_cmd_new_ars_cap(struct ndctl_bus *bus,



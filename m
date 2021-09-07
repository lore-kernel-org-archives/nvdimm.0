Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 077D272
	for <nvdimm@lists.linux.dev>; Tue,  7 Sep 2021 13:42:11 +0000 (UTC)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 187DX3cG132536;
	Tue, 7 Sep 2021 09:42:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : from : to : cc
 : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=pp1; bh=dsI15OdfGP8KiDSbPtLlsBpbXT/kL5vzE6dzj/2DeC0=;
 b=sEk4gSisSWdGJpwYHUs3ZTqvu6Erj0X6DRgtgwGkNvDnXQoACANbZyPCIPqNG2oyoNPG
 F8YvVtTWfQIjdz/OBtbCl4hk7GQuY53J8Tl8l4EVGn+0pvgT1XEZHBiVsDlaoHUF51an
 vC/UP4GlujhplayZsUiim/xPsrOg00ZFrmaqQ+Xo/VNwR79qEBrKJmBydtmochDHdNjY
 eCDwysN61Tr+0hv8psvrLf/QDDuWApvmksejMrbtUc/IuxBksGBHDO6jsT1PAK0P+dVL
 58yGh9nsjT5J85pxD3CaGpuquCDWAqovZjMxbqDVkQNyS+LI0oQPykOO1LvbtK4oJOvi Yg== 
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
	by mx0a-001b2d01.pphosted.com with ESMTP id 3ax7pctn5v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 Sep 2021 09:42:03 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
	by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 187DWC1u001521;
	Tue, 7 Sep 2021 13:42:01 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
	by ppma06fra.de.ibm.com with ESMTP id 3av02jexn1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 Sep 2021 13:42:01 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
	by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 187DbgtB46924200
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 7 Sep 2021 13:37:42 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BB70DA4064;
	Tue,  7 Sep 2021 13:41:57 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9C87CA405C;
	Tue,  7 Sep 2021 13:41:56 +0000 (GMT)
Received: from [172.17.0.2] (unknown [9.40.192.207])
	by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
	Tue,  7 Sep 2021 13:41:56 +0000 (GMT)
Subject: [PATCH v3] libndctl: Update nvdimm flags in ndctl_cmd_submit()
From: Shivaprasad G Bhat <sbhat@linux.ibm.com>
To: nvdimm@lists.linux.dev
Cc: aneesh.kumar@linux.ibm.com, sbhat@linux.ibm.com, vaibhav@linux.ibm.com,
        dan.j.williams@intel.com, ira.weiny@intel.com,
        vishal.l.verma@intel.com
Date: Tue, 07 Sep 2021 13:41:55 +0000
Message-ID: <163102209592.258287.14338386691421639038.stgit@99912bbcb4c7>
User-Agent: StGit/1.1+40.g1b20
Content-Type: text/plain; charset="utf-8"
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 2t1CrjActjdm0Sypn8kvYbC5JKEk__nL
X-Proofpoint-ORIG-GUID: 2t1CrjActjdm0Sypn8kvYbC5JKEk__nL
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-09-07_04:2021-09-07,2021-09-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 impostorscore=0 bulkscore=0 clxscore=1011 mlxscore=0 adultscore=0
 spamscore=0 lowpriorityscore=0 phishscore=0 mlxlogscore=999
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2108310000 definitions=main-2109070089

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
Changelog:

Since v2:
Link: https://lore.kernel.org/nvdimm/20210716072104.11808-1-vaibhav@linux.ibm.com
* Fixed an issue of "nvdimm_test" cmd_family not being set in add_papr_dimm(). [Shiva]
* Fixed an issue of "health_eventfd" not being populated correctly in
populate_dimm_attributes. [Shiva]
* Check if the 'cmd' is dimm specific in ndctl_cmd_submit() and only then call
ndctl_refresh_dimm_flags() [Shiva]

Since v1:
Link: https://lore.kernel.org/nvdimm/20210713202523.190113-1-vaibhav@linux.ibm.com
* Remove the export of ndctl_refresh_dimm_flags().
* Remove the call to ndctl_refresh_dimm_flags() from dimm_inject_smart().
* Add call to ndctl_refresh_dimm_flags() at end of ndctl_cmd_submit().
---
 ndctl/lib/libndctl.c |   52 +++++++++++++++++++++++++++++++++++++-------------
 ndctl/lib/private.h  |    1 +
 ndctl/libndctl.h     |    1 +
 3 files changed, 40 insertions(+), 14 deletions(-)

diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index bb0ea094..4a7c2e5f 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -588,6 +588,7 @@ static void free_dimm(struct ndctl_dimm *dimm)
 	free(dimm->unique_id);
 	free(dimm->dimm_buf);
 	free(dimm->dimm_path);
+	free(dimm->bus_prefix);
 	if (dimm->module)
 		kmod_module_unref(dimm->module);
 	if (dimm->health_eventfd > -1)
@@ -1650,14 +1651,34 @@ static int ndctl_bind(struct ndctl_ctx *ctx, struct kmod_module *module,
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
@@ -1741,16 +1762,10 @@ static int populate_dimm_attributes(struct ndctl_dimm *dimm,
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
 
@@ -1806,8 +1821,9 @@ static int add_papr_dimm(struct ndctl_dimm *dimm, const char *dimm_base)
 
 		rc = 0;
 	} else if (strcmp(buf, "nvdimm_test") == 0) {
+		dimm->cmd_family = NVDIMM_FAMILY_PAPR;
 		/* probe via common populate_dimm_attributes() */
-		rc = populate_dimm_attributes(dimm, dimm_base, "papr");
+		rc = populate_dimm_attributes(dimm, dimm_base);
 	}
 out:
 	free(path);
@@ -1904,9 +1920,13 @@ static void *add_dimm(void *parent, int id, const char *dimm_base)
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
@@ -3486,6 +3506,10 @@ NDCTL_EXPORT int ndctl_cmd_submit(struct ndctl_cmd *cmd)
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
index 8f4510e5..a4b920ca 100644
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
index 87d07b74..cdadd5fd 100644
--- a/ndctl/libndctl.h
+++ b/ndctl/libndctl.h
@@ -214,6 +214,7 @@ int ndctl_dimm_is_active(struct ndctl_dimm *dimm);
 int ndctl_dimm_is_enabled(struct ndctl_dimm *dimm);
 int ndctl_dimm_disable(struct ndctl_dimm *dimm);
 int ndctl_dimm_enable(struct ndctl_dimm *dimm);
+void ndctl_refresh_dimm_flags(struct ndctl_dimm *dimm);
 
 struct ndctl_cmd;
 struct ndctl_cmd *ndctl_bus_cmd_new_ars_cap(struct ndctl_bus *bus,



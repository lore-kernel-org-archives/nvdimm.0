Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A5676375
	for <nvdimm@lists.linux.dev>; Tue, 22 Feb 2022 12:15:42 +0000 (UTC)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21MBmhIO003691;
	Tue, 22 Feb 2022 12:15:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=HzWL85VV+sDLuDVzffCPAfdjQUxiVsXrDjp0zBk5V2s=;
 b=bRLagwH+U4oww3SysvwiJOh6Ft4lxsMMBOpqF6/fChACw7OI+vRLJZwkdrIhBPRY+O2E
 yIklpIIoHLz6YqI4SBodvh+6W0QBOWgLr6fTU63baVhgU3AyWQsyjCgwreWoHp/ADb0r
 PZqI/EsbZOZV5qnRz6S3wegtX9mcbrJKdIIjABx0D/OsR6IuFdax++KkrsJRugI7AhBC
 7LeCg9/KKKbGZtOZLf8/w+eRbBgPTz4NuBSh8wJu6BHI6ybvQO/IJLPQtCW8U7Xup3Ym
 /AJDjXW+AbOpjyZFYkS0M8acBLchtchP2Vf4fCPrgUmKNXQ7mXaN9t6rmofvHYS/wyt7 6Q== 
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
	by mx0a-001b2d01.pphosted.com with ESMTP id 3ecy9g8kpw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 22 Feb 2022 12:15:33 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
	by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21MCDPQp008200;
	Tue, 22 Feb 2022 12:15:31 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
	by ppma02fra.de.ibm.com with ESMTP id 3ear691b4t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 22 Feb 2022 12:15:31 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
	by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21MCFRDo44237194
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Feb 2022 12:15:27 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 94223AE051;
	Tue, 22 Feb 2022 12:15:27 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 581CFAE053;
	Tue, 22 Feb 2022 12:15:24 +0000 (GMT)
Received: from vajain21.in.ibm.com (unknown [9.43.38.119])
	by d06av26.portsmouth.uk.ibm.com (Postfix) with SMTP;
	Tue, 22 Feb 2022 12:15:24 +0000 (GMT)
Received: by vajain21.in.ibm.com (sSMTP sendmail emulation); Tue, 22 Feb 2022 17:45:23 +0530
From: Vaibhav Jain <vaibhav@linux.ibm.com>
To: nvdimm@lists.linux.dev
Cc: Vaibhav Jain <vaibhav@linux.ibm.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Ira Weiny <ira.weiny@intel.com>,
        Shivaprasad G Bhat <sbhat@linux.ibm.com>
Subject: [ndctl PATCH v5] ndctl,libndctl: Update nvdimm flags after smart-inject
Date: Tue, 22 Feb 2022 17:45:19 +0530
Message-Id: <20220222121519.1674117-1-vaibhav@linux.ibm.com>
X-Mailer: git-send-email 2.35.1
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: kxYDcXHcyY2HM-AE0v6x1U7koJpLTwd4
X-Proofpoint-GUID: kxYDcXHcyY2HM-AE0v6x1U7koJpLTwd4
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-22_02,2022-02-21_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 phishscore=0 clxscore=1015 mlxscore=0 lowpriorityscore=0
 impostorscore=0 mlxlogscore=999 suspectscore=0 adultscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202220072

Presently after performing an inject-smart command the nvdimm flags reported are
out of date as shown below where no 'smart_notify' or 'flush_fail' flags were
reported even though they are set after injecting the smart error:

$ sudo ndctl inject-smart -fU nmem0
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
introduced export from libndctl named ndctl_dimm_refresh_flags() thats called
from dimm_inject_smart() after inject-smart command is successfully
submitted. This ensures that correct nvdimm flags are displayed later in that
function. With this implemented correct nvdimm flags are reported after a
inject-smart operation:

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
parsing code to the newly introduced ndctl_dimm_refresh_flags()
export. Since reading nvdimm flags requires constructing path using
'bus_prefix' which is only available during add_dimm(), the patch
introduces a new member 'struct ndctl_dimm.bus_prefix' to cache its
value. During ndctl_dimm_refresh_flags() the cached bus_prefix is used to
read the contents of the nvdimm flag file and pass it on to the appropriate
flag parsing function. Finally dimm_inject_smart() is updated to issue call to
ndctl_dimm_refresh_flags() before generating json output of the nvdimm status

Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
---
Changelog:

Since v4:
https://lore.kernel.org/nvdimm/20220124205822.1492702-1-vaibhav@linux.ibm.com

* Instead of updating nvdimm flags in cmd_submit() only refresh when for
inject-smart command [ Vishal ]
* Added the export of ndctl_dimm_refresh_flags() to libndctl exports [ Vishal ]
* Updated changes to add_dimm() to make then more readable [ Vishal ]
* Updated patch description.
---
 ndctl/inject-smart.c   |  4 +++
 ndctl/lib/libndctl.c   | 55 +++++++++++++++++++++++++++++++-----------
 ndctl/lib/libndctl.sym |  4 +++
 ndctl/lib/private.h    |  1 +
 ndctl/libndctl.h       |  1 +
 5 files changed, 51 insertions(+), 14 deletions(-)

diff --git a/ndctl/inject-smart.c b/ndctl/inject-smart.c
index bd8c01e000d4..d7da5ad8c425 100644
--- a/ndctl/inject-smart.c
+++ b/ndctl/inject-smart.c
@@ -467,6 +467,10 @@ static int dimm_inject_smart(struct ndctl_dimm *dimm)
 		jdimms = json_object_new_array();
 		if (!jdimms)
 			goto out;
+
+		/* Ensure the dimm flags are upto date before reporting them */
+		ndctl_dimm_refresh_flags(dimm);
+
 		jdimm = util_dimm_to_json(dimm, sctx.flags);
 		if (!jdimm)
 			goto out;
diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index 5979a92c113c..8b92d0419871 100644
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
 
+NDCTL_EXPORT void ndctl_dimm_refresh_flags(struct ndctl_dimm *dimm)
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
+	ndctl_dimm_refresh_flags(dimm);
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
@@ -1924,9 +1940,20 @@ static void *add_dimm(void *parent, int id, const char *dimm_base)
 	dimm->formats = formats;
 	/* Check if the given dimm supports nfit */
 	if (ndctl_bus_has_nfit(bus)) {
-		rc = populate_dimm_attributes(dimm, dimm_base, "nfit");
+		dimm->bus_prefix = strdup("nfit");
+		if (!dimm->bus_prefix) {
+			rc = -ENOMEM;
+			goto out;
+		}
+		rc =  populate_dimm_attributes(dimm, dimm_base);
+
 	} else if (ndctl_bus_has_of_node(bus)) {
-		rc = add_papr_dimm(dimm, dimm_base);
+		dimm->bus_prefix = strdup("papr");
+		if (!dimm->bus_prefix) {
+			rc = -ENOMEM;
+			goto out;
+		}
+		rc =  add_papr_dimm(dimm, dimm_base);
 	}
 
 	if (rc == -ENODEV) {
diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
index 3557b32c50ea..f1f9edd4b6ff 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -458,3 +458,7 @@ LIBNDCTL_26 {
 	ndctl_set_config_path;
 	ndctl_get_config_path;
 } LIBNDCTL_25;
+
+LIBNDCTL_27 {
+	ndctl_dimm_refresh_flags;
+} LIBNDCTL_26;
diff --git a/ndctl/lib/private.h b/ndctl/lib/private.h
index 4d8622978790..e5c56295556d 100644
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
index 4d5cdbf6f619..57cf93d8d151 100644
--- a/ndctl/libndctl.h
+++ b/ndctl/libndctl.h
@@ -223,6 +223,7 @@ int ndctl_dimm_is_active(struct ndctl_dimm *dimm);
 int ndctl_dimm_is_enabled(struct ndctl_dimm *dimm);
 int ndctl_dimm_disable(struct ndctl_dimm *dimm);
 int ndctl_dimm_enable(struct ndctl_dimm *dimm);
+void ndctl_dimm_refresh_flags(struct ndctl_dimm *dimm);
 
 struct ndctl_cmd;
 struct ndctl_cmd *ndctl_bus_cmd_new_ars_cap(struct ndctl_bus *bus,

base-commit: 6e85cac1958f920f231b94ff570ac0e434595b7d
-- 
2.35.1


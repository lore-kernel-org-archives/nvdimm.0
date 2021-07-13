Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84FDF70
	for <nvdimm@lists.linux.dev>; Tue, 13 Jul 2021 20:25:40 +0000 (UTC)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16DK3FVu129644;
	Tue, 13 Jul 2021 16:25:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=hDeCj9/erf7CHN8S/eg01VycwqfEHx6NYeRZrb1NPmk=;
 b=lPuZkIdbMF1l+0VXvgK/P9CAdg+TCXHaC6w4S0RHH4bY5ftOYRifbXFYvsLRHeYzLzPb
 ztSep9ayNqI+Nb98S1AsgMQZExfXHbmb/b9McpB7bhJ7ohxXyh5joWuYot0Gw/e3OVwo
 mZdmi9h2e7cLCT1n2AgyO54tFNQst3NdDsTUsPYZ2FCopqHeZchp6lXIp1M8O6PTG9BU
 aOFFsIpDbPIX2HZH9u3on6K22LPRe0kXbOAE7Su7t7u1C6ahvgEKijf123JeKrCyMQ9/
 3vNrodR8pC6dRQrzG9DAniWegeH6FBE7HtaDE8niM9ImMzT+wFq/2q+QTC7/oGpg/5I6 TA== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
	by mx0a-001b2d01.pphosted.com with ESMTP id 39s8vfugw3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 13 Jul 2021 16:25:33 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
	by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16DKCUBg020093;
	Tue, 13 Jul 2021 20:25:31 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
	by ppma06ams.nl.ibm.com with ESMTP id 39q2th9fh5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 13 Jul 2021 20:25:30 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
	by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16DKNJ9f28049742
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Jul 2021 20:23:19 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B82DBA4040;
	Tue, 13 Jul 2021 20:25:27 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4FE9AA4051;
	Tue, 13 Jul 2021 20:25:25 +0000 (GMT)
Received: from vajain21.in.ibm.com (unknown [9.199.55.46])
	by d06av23.portsmouth.uk.ibm.com (Postfix) with SMTP;
	Tue, 13 Jul 2021 20:25:25 +0000 (GMT)
Received: by vajain21.in.ibm.com (sSMTP sendmail emulation); Wed, 14 Jul 2021 01:55:24 +0530
From: Vaibhav Jain <vaibhav@linux.ibm.com>
To: nvdimm@lists.linux.dev
Cc: Vaibhav Jain <vaibhav@linux.ibm.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Ira Weiny <ira.weiny@intel.com>,
        Shivaprasad G Bhat <sbhat@linux.ibm.com>
Subject: [ndctl PATCH] libndctl: Update nvdimm flags after inject-smart
Date: Wed, 14 Jul 2021 01:55:23 +0530
Message-Id: <20210713202523.190113-1-vaibhav@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: OXxElL__dEQ7LdEPqoej0cDdpSepXPbR
X-Proofpoint-GUID: OXxElL__dEQ7LdEPqoej0cDdpSepXPbR
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-13_12:2021-07-13,2021-07-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 priorityscore=1501 mlxscore=0 phishscore=0 bulkscore=0 suspectscore=0
 impostorscore=0 mlxlogscore=999 clxscore=1015 spamscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107130124

Presently after performing a inject-smart the nvdimm flags reported are out
of date as shown below where no 'smart_notify' or 'flush_fail' flags were
reported even though they are set after injecting the smart error:

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

This happens because nvdimm flags are only parsed once during its probe and
not refreshed even after a inject-smart operation makes them out of
date. To fix this the patch adds a new export from libndctl named as
ndctl_refresh_dimm_flags() that can be called after inject-smart that
forces a refresh of nvdimm flags. This ensures that correct nvdimm flags
are reported after the inject-smart operation as shown below:

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
flag parsing function.

Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
---
 ndctl/inject-smart.c   |  3 +++
 ndctl/lib/libndctl.c   | 45 +++++++++++++++++++++++++++++-------------
 ndctl/lib/libndctl.sym |  4 ++++
 ndctl/lib/private.h    |  1 +
 ndctl/libndctl.h       |  1 +
 5 files changed, 40 insertions(+), 14 deletions(-)

diff --git a/ndctl/inject-smart.c b/ndctl/inject-smart.c
index ef0620f55531..6d9abe612e73 100644
--- a/ndctl/inject-smart.c
+++ b/ndctl/inject-smart.c
@@ -463,6 +463,9 @@ static int dimm_inject_smart(struct ndctl_dimm *dimm)
 			goto out;
 	}
 
+	/* Force update of dimm flags after smart-inject */
+	ndctl_refresh_dimm_flags(dimm);
+
 	if (rc == 0) {
 		jdimms = json_object_new_array();
 		if (!jdimms)
diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index bb0ea094a153..59ea656e205d 100644
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
 
+NDCTL_EXPORT void ndctl_refresh_dimm_flags(struct ndctl_dimm *dimm)
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
@@ -1740,15 +1761,7 @@ static int populate_dimm_attributes(struct ndctl_dimm *dimm,
 			dimm->format[i] = strtoul(buf, NULL, 0);
 	}
 
-	sprintf(path, "%s/%s/flags", dimm_base, bus_prefix);
-	if (sysfs_read_attr(ctx, path, buf) == 0) {
-		if (ndctl_bus_has_nfit(dimm->bus))
-			parse_nfit_mem_flags(dimm, buf);
-		else if (ndctl_bus_is_papr_scm(dimm->bus)) {
-			dimm->cmd_family = NVDIMM_FAMILY_PAPR;
-			parse_papr_flags(dimm, buf);
-		}
-	}
+	ndctl_refresh_dimm_flags(dimm);
 
 	dimm->health_eventfd = open(path, O_RDONLY|O_CLOEXEC);
 	rc = 0;
@@ -1807,7 +1820,7 @@ static int add_papr_dimm(struct ndctl_dimm *dimm, const char *dimm_base)
 		rc = 0;
 	} else if (strcmp(buf, "nvdimm_test") == 0) {
 		/* probe via common populate_dimm_attributes() */
-		rc = populate_dimm_attributes(dimm, dimm_base, "papr");
+		rc = populate_dimm_attributes(dimm, dimm_base);
 	}
 out:
 	free(path);
@@ -1904,9 +1917,13 @@ static void *add_dimm(void *parent, int id, const char *dimm_base)
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
diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
index 58afb74229fe..a498535af283 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -455,3 +455,7 @@ LIBNDCTL_25 {
 LIBNDCTL_26 {
 	ndctl_bus_nfit_translate_spa;
 } LIBNDCTL_25;
+
+LIBNDCTL_27 {
+	ndctl_refresh_dimm_flags;
+} LIBNDCTL_26;
diff --git a/ndctl/lib/private.h b/ndctl/lib/private.h
index 8f4510e562c4..a4b920ca0c94 100644
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
index 3a5013007038..54539ac7a6c2 100644
--- a/ndctl/libndctl.h
+++ b/ndctl/libndctl.h
@@ -221,6 +221,7 @@ int ndctl_dimm_is_active(struct ndctl_dimm *dimm);
 int ndctl_dimm_is_enabled(struct ndctl_dimm *dimm);
 int ndctl_dimm_disable(struct ndctl_dimm *dimm);
 int ndctl_dimm_enable(struct ndctl_dimm *dimm);
+void ndctl_refresh_dimm_flags(struct ndctl_dimm *dimm);
 
 struct ndctl_cmd;
 struct ndctl_cmd *ndctl_bus_cmd_new_ars_cap(struct ndctl_bus *bus,
-- 
2.31.1


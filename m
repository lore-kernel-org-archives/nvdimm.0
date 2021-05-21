Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42B1370
	for <nvdimm@lists.linux.dev>; Fri, 21 May 2021 11:27:02 +0000 (UTC)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14LB4PHC023662;
	Fri, 21 May 2021 07:27:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=dKfjOX2hF6K6QWq3eIPA60Cg4fh9M2KFHLkxt0IirgE=;
 b=cPSQd87rtjEjOsH2RH2XB6xK+1FE+EHenyZMkauKNVihMe9HuvH2rA8uWbsJqwiOhiQY
 A9rnSSkYVa0q21gcah3Cd/UQ9Bg3n3Zd49MmV5U7w9DjG8EHoUI/pdL+Z4Gc8HgXdEXR
 aWLC9cB2wurWyPPKU5Zt6ULRcvR2eP3uPXLhVcKutDAlx1iPi3z/F+YR/8lZvoJYrXLD
 tCcBNmk1p+/wP5RdaQWlsdt9QZ2iZRgstrR3ukvuA+B9fdloaxFL1XkObcTFNkdlyJIQ
 MeYtcBGBzKiNxNlrwkI/GoqQY5+y5j58VckodtSTBkyPT65aCxTEhiciyM4iCgP0r1KP vA== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
	by mx0a-001b2d01.pphosted.com with ESMTP id 38p9pubvh7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 21 May 2021 07:27:01 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
	by ppma06ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14LB8BPR014388;
	Fri, 21 May 2021 11:26:59 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
	by ppma06ams.nl.ibm.com with ESMTP id 38j5jgu3gq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 21 May 2021 11:26:59 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
	by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14LBQSJK26542402
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 May 2021 11:26:28 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6F8CF11C04C;
	Fri, 21 May 2021 11:26:56 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 28CC711C04A;
	Fri, 21 May 2021 11:26:54 +0000 (GMT)
Received: from vajain21.in.ibm.com (unknown [9.102.3.140])
	by d06av25.portsmouth.uk.ibm.com (Postfix) with SMTP;
	Fri, 21 May 2021 11:26:53 +0000 (GMT)
Received: by vajain21.in.ibm.com (sSMTP sendmail emulation); Fri, 21 May 2021 16:56:53 +0530
From: Vaibhav Jain <vaibhav@linux.ibm.com>
To: nvdimm@lists.linux.dev
Cc: Vaibhav Jain <vaibhav@linux.ibm.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Ira Weiny <ira.weiny@intel.com>
Subject: [ndctl PATCH] libndctl/papr: Add support for reporting shutdown-count
Date: Fri, 21 May 2021 16:56:49 +0530
Message-Id: <20210521112649.417210-1-vaibhav@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 6IOcXj_ABrnEne0KPyHdEhqEVBkr6L6R
X-Proofpoint-GUID: 6IOcXj_ABrnEne0KPyHdEhqEVBkr6L6R
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-21_04:2021-05-20,2021-05-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 bulkscore=0
 priorityscore=1501 suspectscore=0 phishscore=0 mlxscore=0 impostorscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 spamscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105210069

Add support for reporting dirty-shutdown-count (DSC) for PAPR based
NVDIMMs. The sysfs attribute exposing this value is located at
nmemX/papr/dirty_shutdown.

This counter is also returned in payload for PAPR_PDSM_HEALTH as newly
introduced member 'dimm_dsc' in 'struct nd_papr_pdsm_health'. Presence
of 'DSC' is indicated by the PDSM_DIMM_DSC_VALID extension flag.

The patch implements 'ndctl_dimm_ops.smart_get_shutdown_count'
callback in implemented as papr_smart_get_shutdown_count().

Kernel side changes to support reporting DSC have been proposed at
[1]. With updated kernel 'ndctl list -DH' reports following output on
PPC64:

$ sudo ndctl list -DH
[
  {
    "dev":"nmem0",
    "health":{
      "health_state":"ok",
      "life_used_percentage":50,
      "shutdown_state":"clean",
      "shutdown_count":10
    }
  }
]

Link: https://lore.kernel.org/nvdimm/20210521111023.413732-1-vaibhav@linux.ibm.com
Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
---
 ndctl/lib/libndctl.c  |  6 +++++-
 ndctl/lib/papr.c      | 23 +++++++++++++++++++++++
 ndctl/lib/papr_pdsm.h |  6 ++++++
 3 files changed, 34 insertions(+), 1 deletion(-)

diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index aa36a3c87c57..6ee426ae30e1 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -1795,8 +1795,12 @@ static int add_papr_dimm(struct ndctl_dimm *dimm, const char *dimm_base)
 
 		/* Allocate monitor mode fd */
 		dimm->health_eventfd = open(path, O_RDONLY|O_CLOEXEC);
-		rc = 0;
+		/* Get the dirty shutdown counter value */
+		sprintf(path, "%s/papr/dirty_shutdown", dimm_base);
+		if (sysfs_read_attr(ctx, path, buf) == 0)
+			dimm->dirty_shutdown = strtoll(buf, NULL, 0);
 
+		rc = 0;
 	} else if (strcmp(buf, "nvdimm_test") == 0) {
 		/* probe via common populate_dimm_attributes() */
 		rc = populate_dimm_attributes(dimm, dimm_base, "papr");
diff --git a/ndctl/lib/papr.c b/ndctl/lib/papr.c
index 9c6f2f045fc2..42ff200dc588 100644
--- a/ndctl/lib/papr.c
+++ b/ndctl/lib/papr.c
@@ -165,6 +165,9 @@ static unsigned int papr_smart_get_flags(struct ndctl_cmd *cmd)
 		if (health.extension_flags & PDSM_DIMM_HEALTH_RUN_GAUGE_VALID)
 			flags |= ND_SMART_USED_VALID;
 
+		if (health.extension_flags &  PDSM_DIMM_DSC_VALID)
+			flags |= ND_SMART_SHUTDOWN_COUNT_VALID;
+
 		return flags;
 	}
 
@@ -236,6 +239,25 @@ static unsigned int papr_smart_get_life_used(struct ndctl_cmd *cmd)
 		(100 - health.dimm_fuel_gauge) : 0;
 }
 
+static unsigned int papr_smart_get_shutdown_count(struct ndctl_cmd *cmd)
+{
+
+	struct nd_papr_pdsm_health health;
+
+	/* Ignore in case of error or invalid pdsm */
+	if (!cmd_is_valid(cmd) ||
+	    to_pdsm(cmd)->cmd_status != 0 ||
+	    to_pdsm_cmd(cmd) != PAPR_PDSM_HEALTH)
+		return 0;
+
+	/* get the payload from command */
+	health = to_payload(cmd)->health;
+
+	return (health.extension_flags & PDSM_DIMM_DSC_VALID) ?
+		(health.dimm_dsc) : 0;
+
+}
+
 struct ndctl_dimm_ops * const papr_dimm_ops = &(struct ndctl_dimm_ops) {
 	.cmd_is_supported = papr_cmd_is_supported,
 	.smart_get_flags = papr_smart_get_flags,
@@ -245,4 +267,5 @@ struct ndctl_dimm_ops * const papr_dimm_ops = &(struct ndctl_dimm_ops) {
 	.smart_get_health = papr_smart_get_health,
 	.smart_get_shutdown_state = papr_smart_get_shutdown_state,
 	.smart_get_life_used = papr_smart_get_life_used,
+	.smart_get_shutdown_count = papr_smart_get_shutdown_count,
 };
diff --git a/ndctl/lib/papr_pdsm.h b/ndctl/lib/papr_pdsm.h
index 1bac8a7fc933..f45b1e40c075 100644
--- a/ndctl/lib/papr_pdsm.h
+++ b/ndctl/lib/papr_pdsm.h
@@ -75,6 +75,9 @@
 /* Indicate that the 'dimm_fuel_gauge' field is valid */
 #define PDSM_DIMM_HEALTH_RUN_GAUGE_VALID 1
 
+/* Indicate that the 'dimm_dsc' field is valid */
+#define PDSM_DIMM_DSC_VALID 2
+
 /*
  * Struct exchanged between kernel & ndctl in for PAPR_PDSM_HEALTH
  * Various flags indicate the health status of the dimm.
@@ -103,6 +106,9 @@ struct nd_papr_pdsm_health {
 
 			/* Extension flag PDSM_DIMM_HEALTH_RUN_GAUGE_VALID */
 			__u16 dimm_fuel_gauge;
+
+			/* Extension flag PDSM_DIMM_DSC_VALID */
+			__u64 dimm_dsc;
 		};
 		__u8 buf[ND_PDSM_PAYLOAD_MAX_SIZE];
 	};
-- 
2.31.1


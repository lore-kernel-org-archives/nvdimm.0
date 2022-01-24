Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCD68168
	for <nvdimm@lists.linux.dev>; Mon, 24 Jan 2022 18:56:30 +0000 (UTC)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20OIC231022018;
	Mon, 24 Jan 2022 18:56:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=WmjqFZ8hk4hAAFpK7iUMGLapCLvnerjFf/qAqsEhhoQ=;
 b=X3UP8Itf09K2x+FSs/jn9SH2luIfGIA7fcGux+1ntmau715PHECg4QXBq2AjZq83UZB6
 7zfn4d5MBJDrqylUuyO7DKA/rrzIrMmq7ctdR/jbe0e+xlK3xvNLX5aecwtmlgHB+v7o
 5Zhqvu1qblyu3auOYt3VfM0cy7NPjnONEcDxm87f5o4G/t6X1YquTNWtRba9D6lZxPBu
 IuMG9iGbrDHimWQhlcWrwNq2kcfz9ZaQupcdy8JrMGyIQsdXJZ/5P7RyZd9ATLA6dHMu
 tZOsRly+Seco5WvZloJhLMSGjb60ckOJUdkC48N+nqm5NP3NvB2O+Ko7cY1STAg4V9g3 ew== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
	by mx0a-001b2d01.pphosted.com with ESMTP id 3dt163guqs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 24 Jan 2022 18:56:22 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
	by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20OIqHVi004889;
	Mon, 24 Jan 2022 18:56:21 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
	by ppma06ams.nl.ibm.com with ESMTP id 3dr96j7fjf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 24 Jan 2022 18:56:21 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
	by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20OIkiJq43254070
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 Jan 2022 18:46:44 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 19E62A4062;
	Mon, 24 Jan 2022 18:56:15 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3E23CA405B;
	Mon, 24 Jan 2022 18:56:12 +0000 (GMT)
Received: from vajain21.in.ibm.com (unknown [9.43.98.202])
	by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with SMTP;
	Mon, 24 Jan 2022 18:56:11 +0000 (GMT)
Received: by vajain21.in.ibm.com (sSMTP sendmail emulation); Tue, 25 Jan 2022 00:26:11 +0530
From: Vaibhav Jain <vaibhav@linux.ibm.com>
To: nvdimm@lists.linux.dev
Cc: Vaibhav Jain <vaibhav@linux.ibm.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Ira Weiny <ira.weiny@intel.com>,
        Shivaprasad G Bhat <sbhat@linux.ibm.com>
Subject: [ndctl PATCH v3] libndctl/papr: Add support for reporting shutdown-count
Date: Tue, 25 Jan 2022 00:26:05 +0530
Message-Id: <20220124185605.1465681-1-vaibhav@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: dJQB7D7kXvAMKnPfFXjo7TXudVN9tXtn
X-Proofpoint-ORIG-GUID: dJQB7D7kXvAMKnPfFXjo7TXudVN9tXtn
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
 definitions=2022-01-24_09,2022-01-24_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 spamscore=0 lowpriorityscore=0 malwarescore=0 mlxlogscore=999 adultscore=0
 priorityscore=1501 suspectscore=0 impostorscore=0 clxscore=1015 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2201240121

Add support for reporting dirty-shutdown-count (DSC) for PAPR based
NVDIMMs. The sysfs attribute exposing this value is located at
nmemX/papr/dirty_shutdown.

This counter is also returned in payload for PAPR_PDSM_HEALTH as newly
introduced member 'dimm_dsc' in 'struct nd_papr_pdsm_health'. Presence
of 'DSC' is indicated by the PDSM_DIMM_DSC_VALID extension flag.

The patch implements 'ndctl_dimm_ops.smart_get_shutdown_count'
callback in implemented as papr_smart_get_shutdown_count().

Kernel side changes to support reporting DSC have been merged to linux kernel
via patch proposed at [1]. With updated kernel 'ndctl list -DH' reports
following output on PPC64:

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

[1] http://patchwork.ozlabs.org/project/linuxppc-dev/patch/20210624080621.252038-1-vaibhav@linux.ibm.com
Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
---
Changelog:

v3:
* Updated the patch description to point to merged kernel patch.
* Rebased the patch to latest ndctl-pending tree.

Resend:
* Added ack by Aneesh.
* Minor fix to changelog of v2 patch

v2:
* Rebased the patch on latest ppc-next tree
* s/psdm/pdsm/g   [ Santosh ]
---
 ndctl/lib/libndctl.c  |  6 +++++-
 ndctl/lib/papr.c      | 23 +++++++++++++++++++++++
 ndctl/lib/papr_pdsm.h |  6 ++++++
 3 files changed, 34 insertions(+), 1 deletion(-)

diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index 47a234ccc8ce..5979a92c113c 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -1819,8 +1819,12 @@ static int add_papr_dimm(struct ndctl_dimm *dimm, const char *dimm_base)
 
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
index 43b8412b2073..46cf9c1b7341 100644
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
2.34.1


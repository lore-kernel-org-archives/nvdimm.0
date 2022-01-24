Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5436F2CA7
	for <nvdimm@lists.linux.dev>; Mon, 24 Jan 2022 20:37:49 +0000 (UTC)
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
	by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20OK04D0017417;
	Mon, 24 Jan 2022 20:37:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=eWMPo7qDP8elmkl4MijzTJgj5k/VIDvHWLKgtVhILwU=;
 b=l1dhlcAZFYbEAP7qlp/x+vEsva78WyWiYI53C5HW1cbido5SLNo6Z8ATubm+VohYii/0
 Aqvu+UnRqNsbo3DEpMitD3aRxVRJ+fkCUI2mt3r5ZWYs3F0Hxx0c00RD0JE7ayuWxal9
 fxRGaBunFZwW9RGY/IvYai4ywVsFOLoo5v5Ly+toQlfdJ405EmikUU9G2bteA8ck3I8L
 7LZR/RXrLMSC+C4VbuLaGY2mp6PZ8AX3pp15n8z8lTfstvmR14PYkes68ZGdmtAxHwjW
 Un+TwybQchXh/0aI0WqCuLLTXr3rofvHpKfJP3KImq87vu91FpY1sGHqIhV2iKS6T3Qu fQ== 
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
	by mx0b-001b2d01.pphosted.com with ESMTP id 3dt09w4c4u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 24 Jan 2022 20:37:46 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
	by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20OKIqv1024853;
	Mon, 24 Jan 2022 20:37:45 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
	by ppma04fra.de.ibm.com with ESMTP id 3dr9j96xck-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 24 Jan 2022 20:37:45 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
	by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20OKbfXn38994248
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 Jan 2022 20:37:41 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8C67542045;
	Mon, 24 Jan 2022 20:37:41 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C8B994203F;
	Mon, 24 Jan 2022 20:37:38 +0000 (GMT)
Received: from vajain21.in.ibm.com (unknown [9.43.98.202])
	by d06av24.portsmouth.uk.ibm.com (Postfix) with SMTP;
	Mon, 24 Jan 2022 20:37:38 +0000 (GMT)
Received: by vajain21.in.ibm.com (sSMTP sendmail emulation); Tue, 25 Jan 2022 02:07:37 +0530
From: Vaibhav Jain <vaibhav@linux.ibm.com>
To: nvdimm@lists.linux.dev
Cc: Vaibhav Jain <vaibhav@linux.ibm.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Ira Weiny <ira.weiny@intel.com>,
        Shivaprasad G Bhat <sbhat@linux.ibm.com>
Subject: [ndctl PATCH v4] libndctl, intel: Indicate supported smart-inject types
Date: Tue, 25 Jan 2022 02:07:35 +0530
Message-Id: <20220124203735.1490186-1-vaibhav@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: XeotHh0yX38bwxGwOz4pPgYdtX3wu67L
X-Proofpoint-ORIG-GUID: XeotHh0yX38bwxGwOz4pPgYdtX3wu67L
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
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 suspectscore=0 spamscore=0 impostorscore=0 malwarescore=0
 lowpriorityscore=0 clxscore=1015 mlxscore=0 phishscore=0 adultscore=0
 bulkscore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2201240134

Presently the inject-smart code assumes support for injecting all
smart-errors namely media-temperature, controller-temperature,
spares-remaining, fatal-health and unsafe-shutdown. This assumption
may break in case of other non-Intel NVDIMM types namely PAPR NVDIMMs
which presently only have support for injecting unsafe-shutdown and
fatal health events.

Trying to inject-smart errors on PAPR NVDIMMs causes problems as
smart_inject() prematurely exits when trying to inject
media-temperature smart-error errors out.

To fix this issue the patch proposes extending the definition of
dimm_op 'smart_inject_supported' to return bitmap of flags indicating
the type of smart-error injections supported by an NVDIMM. These types
are indicated by the newly introduced defines ND_SMART_INJECT_* . A
dimm-ops provide can return an bitmap composed of these flags back
from its implementation of 'smart_inject_supported' to indicate to
dimm_inject_smart() which type of smart-error injection it
supports. In case of an error the dimm-op is still expected to return
a negative error code back to the caller.

The patch updates intel_dimm_smart_inject_supported() to return a
bitmap composed of all ND_SMART_INJECT_* flags to indicate support for
all smart-error types.

Finally the patch also updates smart_inject() to test for specific
ND_START_INJECT_* flags before sending a smart-inject command via
dimm-provider.

Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
---
Changelog:

Since v3:
https://lore.kernel.org/all/164009760609.743207.15606385364785007374.stgit@lep8c.aus.stglabs.ibm.com/
* Spit the patch from the original patch series
* Rebase the patch onto ndctl-pending tree that includes changes to switch to
meson build system.
---
 ndctl/inject-smart.c | 31 ++++++++++++++++++++++++-------
 ndctl/lib/intel.c    |  7 ++++++-
 ndctl/libndctl.h     |  8 ++++++++
 3 files changed, 38 insertions(+), 8 deletions(-)

diff --git a/ndctl/inject-smart.c b/ndctl/inject-smart.c
index 2b9d7e85241c..bd8c01e000d4 100644
--- a/ndctl/inject-smart.c
+++ b/ndctl/inject-smart.c
@@ -395,18 +395,26 @@ out:
 	} \
 }
 
-static int smart_inject(struct ndctl_dimm *dimm)
+static int smart_inject(struct ndctl_dimm *dimm, unsigned int inject_types)
 {
 	const char *name = ndctl_dimm_get_devname(dimm);
 	struct ndctl_cmd *si_cmd = NULL;
 	int rc = -EOPNOTSUPP;
 
-	send_inject_val(media_temperature)
-	send_inject_val(ctrl_temperature)
-	send_inject_val(spares)
-	send_inject_bool(fatal)
-	send_inject_bool(unsafe_shutdown)
+	if (inject_types & ND_SMART_INJECT_MEDIA_TEMPERATURE)
+		send_inject_val(media_temperature);
 
+	if (inject_types & ND_SMART_INJECT_CTRL_TEMPERATURE)
+		send_inject_val(ctrl_temperature);
+
+	if (inject_types & ND_SMART_INJECT_SPARES_REMAINING)
+		send_inject_val(spares);
+
+	if (inject_types & ND_SMART_INJECT_HEALTH_STATE)
+		send_inject_bool(fatal);
+
+	if (inject_types & ND_SMART_INJECT_UNCLEAN_SHUTDOWN)
+		send_inject_bool(unsafe_shutdown);
 out:
 	ndctl_cmd_unref(si_cmd);
 	return rc;
@@ -417,6 +425,7 @@ static int dimm_inject_smart(struct ndctl_dimm *dimm)
 	struct json_object *jhealth;
 	struct json_object *jdimms;
 	struct json_object *jdimm;
+	unsigned int supported_types;
 	int rc;
 
 	rc = ndctl_dimm_smart_inject_supported(dimm);
@@ -433,6 +442,14 @@ static int dimm_inject_smart(struct ndctl_dimm *dimm)
 		error("%s: smart injection not supported by either platform firmware or the kernel.",
 			ndctl_dimm_get_devname(dimm));
 		return rc;
+	default:
+		if (rc < 0) {
+			error("%s: Unknown error %d while checking for smart injection support",
+			      ndctl_dimm_get_devname(dimm), rc);
+			return rc;
+		}
+		supported_types = rc;
+		break;
 	}
 
 	if (sctx.op_mask & (1 << OP_SET)) {
@@ -441,7 +458,7 @@ static int dimm_inject_smart(struct ndctl_dimm *dimm)
 			goto out;
 	}
 	if (sctx.op_mask & (1 << OP_INJECT)) {
-		rc = smart_inject(dimm);
+		rc = smart_inject(dimm, supported_types);
 		if (rc)
 			goto out;
 	}
diff --git a/ndctl/lib/intel.c b/ndctl/lib/intel.c
index a3df26e6bc58..1314854553d5 100644
--- a/ndctl/lib/intel.c
+++ b/ndctl/lib/intel.c
@@ -455,7 +455,12 @@ static int intel_dimm_smart_inject_supported(struct ndctl_dimm *dimm)
 		return -EIO;
 	}
 
-	return 0;
+	/* Indicate all smart injection types are supported */
+	return ND_SMART_INJECT_SPARES_REMAINING |
+		ND_SMART_INJECT_MEDIA_TEMPERATURE |
+		ND_SMART_INJECT_CTRL_TEMPERATURE |
+		ND_SMART_INJECT_HEALTH_STATE |
+		ND_SMART_INJECT_UNCLEAN_SHUTDOWN;
 }
 
 static const char *intel_cmd_desc(int fn)
diff --git a/ndctl/libndctl.h b/ndctl/libndctl.h
index b59026c1c476..4d5cdbf6f619 100644
--- a/ndctl/libndctl.h
+++ b/ndctl/libndctl.h
@@ -69,6 +69,13 @@ extern "C" {
 #define ND_EVENT_HEALTH_STATE		(1 << 3)
 #define ND_EVENT_UNCLEAN_SHUTDOWN	(1 << 4)
 
+/* Flags indicating support for various smart injection types */
+#define ND_SMART_INJECT_SPARES_REMAINING	(1 << 0)
+#define ND_SMART_INJECT_MEDIA_TEMPERATURE	(1 << 1)
+#define ND_SMART_INJECT_CTRL_TEMPERATURE	(1 << 2)
+#define ND_SMART_INJECT_HEALTH_STATE		(1 << 3)
+#define ND_SMART_INJECT_UNCLEAN_SHUTDOWN	(1 << 4)
+
 size_t ndctl_min_namespace_size(void);
 size_t ndctl_sizeof_namespace_index(void);
 size_t ndctl_sizeof_namespace_label(void);
@@ -311,6 +318,7 @@ int ndctl_cmd_smart_inject_spares(struct ndctl_cmd *cmd, bool enable,
 		unsigned int spares);
 int ndctl_cmd_smart_inject_fatal(struct ndctl_cmd *cmd, bool enable);
 int ndctl_cmd_smart_inject_unsafe_shutdown(struct ndctl_cmd *cmd, bool enable);
+/* Returns a bitmap of ND_SMART_INJECT_* supported */
 int ndctl_dimm_smart_inject_supported(struct ndctl_dimm *dimm);
 
 struct ndctl_cmd *ndctl_dimm_cmd_new_vendor_specific(struct ndctl_dimm *dimm,
-- 
2.34.1


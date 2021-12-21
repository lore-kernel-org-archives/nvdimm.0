Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDD902C82
	for <nvdimm@lists.linux.dev>; Tue, 21 Dec 2021 14:40:25 +0000 (UTC)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BLCWfpj007740;
	Tue, 21 Dec 2021 14:40:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : from : to : cc
 : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=sjPeS5cX+TEE1lufoU5iCpgFYr0H033gSGLWs8ZHwIk=;
 b=B8mgghM8hWJoSeNMXBHkaHz4qzNIUNgIlY4NtqRHC5idtQus+lG7DUUWXYazMkDdPEvf
 ib3gODPuv9X8f69syznjhS+PCgiGmaesT2qaryY4k5IschApjmU+Qak2VJWCK+MNpJrQ
 rsq14RdQ67ig0TVHiHtRgbVIh3GjDexD+xYkbxaTrvZgRBC/t02wSJrkjpYBtVcmyAyO
 LFgnuRoWkEpR9iChu4D7itaCQy21qeB9g8lPWDn2L5nez+r29mWS4wzafhKLDssN3l0p
 H3BNCg6txQpPKX5WEBFZPtVXoSYQDm9kjEch8HQ5S+rL39HUOYqZu/4YWNCixhmaLpoH hw== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
	by mx0a-001b2d01.pphosted.com with ESMTP id 3d3f182msp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Dec 2021 14:40:18 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
	by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1BLEcd2R004346;
	Tue, 21 Dec 2021 14:40:16 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
	by ppma03ams.nl.ibm.com with ESMTP id 3d179aes1j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Dec 2021 14:40:16 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
	by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1BLEVxGX30867716
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Dec 2021 14:31:59 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 295D04C052;
	Tue, 21 Dec 2021 14:40:12 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 237264C058;
	Tue, 21 Dec 2021 14:40:11 +0000 (GMT)
Received: from lep8c.aus.stglabs.ibm.com (unknown [9.40.192.207])
	by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
	Tue, 21 Dec 2021 14:40:10 +0000 (GMT)
Subject: [ndctl REPOST PATCH v3 1/2] libndctl,
 intel: Indicate supported smart-inject types
From: Shivaprasad G Bhat <sbhat@linux.ibm.com>
To: nvdimm@lists.linux.dev
Cc: aneesh.kumar@linux.ibm.com, sbhat@linux.ibm.com, vaibhav@linux.ibm.com,
        dan.j.williams@intel.com, ira.weiny@intel.com,
        vishal.l.verma@intel.com
Date: Tue, 21 Dec 2021 08:40:10 -0600
Message-ID: 
 <164009760609.743207.15606385364785007374.stgit@lep8c.aus.stglabs.ibm.com>
In-Reply-To: 
 <164009759905.743207.9222152578609029206.stgit@lep8c.aus.stglabs.ibm.com>
References: 
 <164009759905.743207.9222152578609029206.stgit@lep8c.aus.stglabs.ibm.com>
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
X-Proofpoint-ORIG-GUID: gOUgGmWSGNK7g8dopufU5SHRiUcjpcu0
X-Proofpoint-GUID: gOUgGmWSGNK7g8dopufU5SHRiUcjpcu0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-21_04,2021-12-21_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 phishscore=0
 priorityscore=1501 suspectscore=0 mlxscore=0 mlxlogscore=999
 malwarescore=0 adultscore=0 bulkscore=0 lowpriorityscore=0 impostorscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112210068

From: Vaibhav Jain <vaibhav@linux.ibm.com>

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
 ndctl/inject-smart.c |   31 ++++++++++++++++++++++++-------
 ndctl/lib/intel.c    |    7 ++++++-
 ndctl/libndctl.h     |    8 ++++++++
 3 files changed, 38 insertions(+), 8 deletions(-)

diff --git a/ndctl/inject-smart.c b/ndctl/inject-smart.c
index 9077bca2..c3c5fa5f 100644
--- a/ndctl/inject-smart.c
+++ b/ndctl/inject-smart.c
@@ -393,18 +393,26 @@ out:
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
@@ -415,6 +423,7 @@ static int dimm_inject_smart(struct ndctl_dimm *dimm)
 	struct json_object *jhealth;
 	struct json_object *jdimms;
 	struct json_object *jdimm;
+	unsigned int supported_types;
 	int rc;
 
 	rc = ndctl_dimm_smart_inject_supported(dimm);
@@ -431,6 +440,14 @@ static int dimm_inject_smart(struct ndctl_dimm *dimm)
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
@@ -439,7 +456,7 @@ static int dimm_inject_smart(struct ndctl_dimm *dimm)
 			goto out;
 	}
 	if (sctx.op_mask & (1 << OP_INJECT)) {
-		rc = smart_inject(dimm);
+		rc = smart_inject(dimm, supported_types);
 		if (rc)
 			goto out;
 	}
diff --git a/ndctl/lib/intel.c b/ndctl/lib/intel.c
index a3df26e6..13148545 100644
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
index b59026c1..4d5cdbf6 100644
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



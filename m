Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E6A32FAF
	for <nvdimm@lists.linux.dev>; Mon, 12 Jul 2021 17:31:50 +0000 (UTC)
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16CH33V6170020;
	Mon, 12 Jul 2021 13:31:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=rhQOJsGDSyxOtbm35TgtJrI/L8kTZW1/jfb1xArkdL0=;
 b=DbK0hNMIr1KC45GRXsfaFRWvA/4dq+9iIbCGBd7Cgh1I9mFKYysT3p4pGUmf4hBK74j/
 8SJZl4b8Idp4k05Si5tblHi/H3kdSr9YzraxqTfxcgxZ2KHYlhuQP83jvFjaDHJebk81
 J8AWXSZvWA1SUtraozF1LSsPhBdrZ4jKB/Lzkf+e+R1VQ2NAXm3BQlXFQtxBeS171aaG
 ZvXaPxuD9dyFrA3BeKUQ1Azou+ATTEUvAb/m/GsR8sqPotNlKzXblv0Hxm+LEMpZCnXX
 qwGijH39CRE+0rEAfjeaqQaDXFz0OASNzT4zmcxQYRTlSx+X5sQ5zuAyeytj0vzirJnV hg== 
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
	by mx0a-001b2d01.pphosted.com with ESMTP id 39qrgkhcm3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 12 Jul 2021 13:31:45 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
	by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16CHVhrn015085;
	Mon, 12 Jul 2021 17:31:43 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
	by ppma05fra.de.ibm.com with ESMTP id 39q368gfhk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 12 Jul 2021 17:31:43 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
	by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16CHTXim34931146
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 12 Jul 2021 17:29:33 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 01ABAAE04D;
	Mon, 12 Jul 2021 17:31:40 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 87B56AE045;
	Mon, 12 Jul 2021 17:31:37 +0000 (GMT)
Received: from vajain21.in.ibm.com (unknown [9.85.98.133])
	by d06av26.portsmouth.uk.ibm.com (Postfix) with SMTP;
	Mon, 12 Jul 2021 17:31:37 +0000 (GMT)
Received: by vajain21.in.ibm.com (sSMTP sendmail emulation); Mon, 12 Jul 2021 23:01:36 +0530
From: Vaibhav Jain <vaibhav@linux.ibm.com>
To: nvdimm@lists.linux.dev
Cc: Vaibhav Jain <vaibhav@linux.ibm.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Ira Weiny <ira.weiny@intel.com>,
        Shivaprasad G Bhat <sbhat@linux.ibm.com>
Subject: [ndctl PATCH 1/2] libndctl, intel: Indicate supported smart-inject types
Date: Mon, 12 Jul 2021 23:01:31 +0530
Message-Id: <20210712173132.1205192-2-vaibhav@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210712173132.1205192-1-vaibhav@linux.ibm.com>
References: <20210712173132.1205192-1-vaibhav@linux.ibm.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: IVAtTHtS8sg70_6jEx9m49EyPzFESmD1
X-Proofpoint-GUID: IVAtTHtS8sg70_6jEx9m49EyPzFESmD1
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-12_09:2021-07-12,2021-07-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 priorityscore=1501 mlxlogscore=999 spamscore=0 suspectscore=0 mlxscore=0
 malwarescore=0 phishscore=0 clxscore=1015 bulkscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107120126

Presently the inject-smart code assumes support injecting all
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
---
 ndctl/inject-smart.c | 33 ++++++++++++++++++++++++++-------
 ndctl/lib/intel.c    |  7 ++++++-
 ndctl/libndctl.h     |  8 ++++++++
 3 files changed, 40 insertions(+), 8 deletions(-)

diff --git a/ndctl/inject-smart.c b/ndctl/inject-smart.c
index 9077bca256e4..ef0620f55531 100644
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
@@ -415,8 +423,10 @@ static int dimm_inject_smart(struct ndctl_dimm *dimm)
 	struct json_object *jhealth;
 	struct json_object *jdimms;
 	struct json_object *jdimm;
+	unsigned int supported_types;
 	int rc;
 
+	/* Get supported smart injection types */
 	rc = ndctl_dimm_smart_inject_supported(dimm);
 	switch (rc) {
 	case -ENOTTY:
@@ -431,6 +441,15 @@ static int dimm_inject_smart(struct ndctl_dimm *dimm)
 		error("%s: smart injection not supported by either platform firmware or the kernel.",
 			ndctl_dimm_get_devname(dimm));
 		return rc;
+	default:
+		if (rc < 0) {
+			error("%s: Unknown error %d while checking for smart injection support",
+			      ndctl_dimm_get_devname(dimm), rc);
+			return rc;
+		}
+		/* Assigning to an unsigned type since rc < 0 */
+		supported_types = rc;
+		break;
 	}
 
 	if (sctx.op_mask & (1 << OP_SET)) {
@@ -439,7 +458,7 @@ static int dimm_inject_smart(struct ndctl_dimm *dimm)
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
index 87d07b74ef8b..3a5013007038 100644
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
@@ -309,6 +316,7 @@ int ndctl_cmd_smart_inject_spares(struct ndctl_cmd *cmd, bool enable,
 		unsigned int spares);
 int ndctl_cmd_smart_inject_fatal(struct ndctl_cmd *cmd, bool enable);
 int ndctl_cmd_smart_inject_unsafe_shutdown(struct ndctl_cmd *cmd, bool enable);
+/* Returns a bitmap of ND_SMART_INJECT_* supported */
 int ndctl_dimm_smart_inject_supported(struct ndctl_dimm *dimm);
 
 struct ndctl_cmd *ndctl_dimm_cmd_new_vendor_specific(struct ndctl_dimm *dimm,
-- 
2.31.1


Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61F1629CA
	for <nvdimm@lists.linux.dev>; Fri, 22 Oct 2021 14:57:22 +0000 (UTC)
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19MDxoUp029527;
	Fri, 22 Oct 2021 10:57:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : from : to : cc
 : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=9K6okYofoms/fw9pO9lBzzA1gdACxhwQua4Tkdzi8oA=;
 b=h5T0g7dzQUzDZVxX/HwLfqe2gPGCYG2klPQQoAt6I4TolmURGIN7yblF2WHZXnO9ikAC
 JJjA+if0ZzHUotOHC6J78S5XULvWQa1MigiYZkEQsYkIQdiztRSNwGfJtaz/SkThYAnj
 dlDsI/OUrrPe1PdC8qwDShABmU/maDsKdj/OvTzwURESxrfqqkARF1aBWXNsWjMWx4Xa
 QllWoh8vWr2DU5nfQe5/frL29vT5NW4HRydXf4cBiX0627y9GyL/LSgmeUTZsy5924oW
 51XsIOEffsSQgjBGWV3H0QC03a16o6G/9vaoZvFM37qu07SM/lntZt/99woff48w3kNr Xg== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
	by mx0a-001b2d01.pphosted.com with ESMTP id 3bukh569du-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 22 Oct 2021 10:57:15 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
	by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19MEqUw2009673;
	Fri, 22 Oct 2021 14:57:13 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
	by ppma04ams.nl.ibm.com with ESMTP id 3bqpcbhhfu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 22 Oct 2021 14:57:12 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
	by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19MEpDD455443858
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 22 Oct 2021 14:51:13 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 84A5211C052;
	Fri, 22 Oct 2021 14:57:09 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7221911C050;
	Fri, 22 Oct 2021 14:57:08 +0000 (GMT)
Received: from lep8c.aus.stglabs.ibm.com (unknown [9.40.192.207])
	by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
	Fri, 22 Oct 2021 14:57:08 +0000 (GMT)
Subject: [REPOST PATCH v2 1/2] libndctl,
 intel: Indicate supported smart-inject types
From: Shivaprasad G Bhat <sbhat@linux.ibm.com>
To: nvdimm@lists.linux.dev
Cc: aneesh.kumar@linux.ibm.com, sbhat@linux.ibm.com, vaibhav@linux.ibm.com,
        dan.j.williams@intel.com, ira.weiny@intel.com,
        vishal.l.verma@intel.com
Date: Fri, 22 Oct 2021 09:57:07 -0500
Message-ID: 
 <163491461724.1641479.6370717053054036222.stgit@lep8c.aus.stglabs.ibm.com>
In-Reply-To: 
 <163491461011.1641479.7752723100626280911.stgit@lep8c.aus.stglabs.ibm.com>
References: 
 <163491461011.1641479.7752723100626280911.stgit@lep8c.aus.stglabs.ibm.com>
User-Agent: StGit/1.1+40.g1b20
Content-Type: text/plain; charset="utf-8"
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 4mxNtE7Sh4EyWKcTGYX6vsRhkxmm4ICv
X-Proofpoint-ORIG-GUID: 4mxNtE7Sh4EyWKcTGYX6vsRhkxmm4ICv
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-22_04,2021-10-22_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 adultscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0
 mlxlogscore=999 spamscore=0 phishscore=0 suspectscore=0 clxscore=1015
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110220083

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
---
Changelog:

Since v1:
Link: https://lore.kernel.org/nvdimm/20210712173132.1205192-2-vaibhav@linux.ibm.com
* Minor update to patch description

 ndctl/inject-smart.c |   33 ++++++++++++++++++++++++++-------
 ndctl/lib/intel.c    |    7 ++++++-
 ndctl/libndctl.h     |    8 ++++++++
 3 files changed, 40 insertions(+), 8 deletions(-)

diff --git a/ndctl/inject-smart.c b/ndctl/inject-smart.c
index 9077bca2..ef0620f5 100644
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
index cdadd5fd..54539ac7 100644
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
@@ -310,6 +317,7 @@ int ndctl_cmd_smart_inject_spares(struct ndctl_cmd *cmd, bool enable,
 		unsigned int spares);
 int ndctl_cmd_smart_inject_fatal(struct ndctl_cmd *cmd, bool enable);
 int ndctl_cmd_smart_inject_unsafe_shutdown(struct ndctl_cmd *cmd, bool enable);
+/* Returns a bitmap of ND_SMART_INJECT_* supported */
 int ndctl_dimm_smart_inject_supported(struct ndctl_dimm *dimm);
 
 struct ndctl_cmd *ndctl_dimm_cmd_new_vendor_specific(struct ndctl_dimm *dimm,



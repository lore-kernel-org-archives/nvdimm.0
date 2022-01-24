Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0A102FAF
	for <nvdimm@lists.linux.dev>; Mon, 24 Jan 2022 20:38:17 +0000 (UTC)
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20OIZhn5025757;
	Mon, 24 Jan 2022 20:38:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=BZzyPNBoQ8RqJBZOag6uMGhZ5WCwpE7r7v67zbQ5CyM=;
 b=V7OaBD3JyWbExq/6RbX9b7XfzEwSIeLHYs2tYQvSSOc51HKr2rDE3PcAgZS5WOhU16Th
 OcxmkPIWWPuneyIGfHYt3JsKl4nTBkuCyv3QmOH9Vdwy6VW2eZQWxEzAb3xCWM7hq16O
 /kwFAnFWxt6YxP5Ysn12BWUan5KChG+Us9Nw+O7rdb8NNjF10b1ksXBdFJv5k3VPLV5c
 NeVfOFnUmxhw+dICiFNQ/esyhZshUTIogsrfbLpQTv3uq7pETj/VBeq/4kXMlOKcsNLQ
 2g+9l+07Ekr8Bi6ijq8OBTbcuo/rd2lECr2jOrT1s+M2WlEZkeyFLaB1FldYqiMKNupX bA== 
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
	by mx0a-001b2d01.pphosted.com with ESMTP id 3dt0tukfan-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 24 Jan 2022 20:38:16 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
	by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20OKbMp3022793;
	Mon, 24 Jan 2022 20:38:14 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
	by ppma01fra.de.ibm.com with ESMTP id 3dr9j96x24-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 24 Jan 2022 20:38:13 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
	by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20OKcAog40501740
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 Jan 2022 20:38:10 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8BE4DA405F;
	Mon, 24 Jan 2022 20:38:10 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C8AECA405B;
	Mon, 24 Jan 2022 20:38:07 +0000 (GMT)
Received: from vajain21.in.ibm.com (unknown [9.43.98.202])
	by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with SMTP;
	Mon, 24 Jan 2022 20:38:07 +0000 (GMT)
Received: by vajain21.in.ibm.com (sSMTP sendmail emulation); Tue, 25 Jan 2022 02:08:06 +0530
From: Vaibhav Jain <vaibhav@linux.ibm.com>
To: nvdimm@lists.linux.dev
Cc: Vaibhav Jain <vaibhav@linux.ibm.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Ira Weiny <ira.weiny@intel.com>,
        Shivaprasad G Bhat <sbhat@linux.ibm.com>
Subject: [ndctl PATCH v4] libndctl/papr: Add limited support for inject-smart
Date: Tue, 25 Jan 2022 02:08:04 +0530
Message-Id: <20220124203804.1490254-1-vaibhav@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: S2q15eIi2Zdm1oQ66FuOv3p8G5nmoITg
X-Proofpoint-ORIG-GUID: S2q15eIi2Zdm1oQ66FuOv3p8G5nmoITg
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
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 adultscore=0 bulkscore=0 mlxlogscore=999 impostorscore=0
 clxscore=1015 suspectscore=0 phishscore=0 mlxscore=0 priorityscore=1501
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201240134

Implements support for ndctl inject-smart command by providing an
implementation of 'smart_inject*' dimm-ops callbacks. Presently only
support for injecting unsafe-shutdown and fatal-health states is
available.

The patch also introduce various PAPR PDSM structures that are used to
communicate the inject-smart errors to the papr_scm kernel
module. This is done via SMART_INJECT PDSM which sends a payload of
type 'struct nd_papr_pdsm_smart_inject'.

With the patch following output from ndctl inject-smart command is
expected for PAPR NVDIMMs:

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

$ sudo ndctl inject-smart -N nmem0
[
  {
    "dev":"nmem0",
    "health":{
      "health_state":"ok",
      "shutdown_state":"clean",
      "shutdown_count":0
    }
  }
]

The patch depends on the kernel PAPR PDSM implementation for
PDSM_SMART_INJECT posted at [1].

[1] : https://lore.kernel.org/nvdimm/20220124202204.1488346-1-vaibhav@linux.ibm.com/
Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>

---
Changelog:

Since v3:
https://lore.kernel.org/all/164009761730.743207.3802102461166326223.stgit@lep8c.aus.stglabs.ibm.com/
* Spit the patch from its previous patch series.
* Updated the patch description to include link to new version of the kernel
patch.
* Rebased this on top of latest ndctl-pending tree that includes changes to
switch to meson build system.
---
 ndctl/lib/papr.c      | 61 +++++++++++++++++++++++++++++++++++++++++++
 ndctl/lib/papr_pdsm.h | 17 ++++++++++++
 2 files changed, 78 insertions(+)

diff --git a/ndctl/lib/papr.c b/ndctl/lib/papr.c
index 46cf9c1b7341..7a1d5595b12e 100644
--- a/ndctl/lib/papr.c
+++ b/ndctl/lib/papr.c
@@ -221,6 +221,41 @@ static unsigned int papr_smart_get_shutdown_state(struct ndctl_cmd *cmd)
 	return health.dimm_bad_shutdown;
 }
 
+static int papr_smart_inject_supported(struct ndctl_dimm *dimm)
+{
+	if (!ndctl_dimm_is_cmd_supported(dimm, ND_CMD_CALL))
+		return -EOPNOTSUPP;
+
+	if (!test_dimm_dsm(dimm, PAPR_PDSM_SMART_INJECT))
+		return -EIO;
+
+	return ND_SMART_INJECT_HEALTH_STATE | ND_SMART_INJECT_UNCLEAN_SHUTDOWN;
+}
+
+static int papr_smart_inject_valid(struct ndctl_cmd *cmd)
+{
+	if (cmd->type != ND_CMD_CALL ||
+	    to_pdsm(cmd)->cmd_status != 0 ||
+	    to_pdsm_cmd(cmd) != PAPR_PDSM_SMART_INJECT)
+		return -EINVAL;
+
+	return 0;
+}
+
+static struct ndctl_cmd *papr_new_smart_inject(struct ndctl_dimm *dimm)
+{
+	struct ndctl_cmd *cmd;
+
+	cmd = allocate_cmd(dimm, PAPR_PDSM_SMART_INJECT,
+			sizeof(struct nd_papr_pdsm_smart_inject));
+	if (!cmd)
+		return NULL;
+	/* Set the input payload size */
+	to_ndcmd(cmd)->nd_size_in = ND_PDSM_HDR_SIZE +
+		sizeof(struct nd_papr_pdsm_smart_inject);
+	return cmd;
+}
+
 static unsigned int papr_smart_get_life_used(struct ndctl_cmd *cmd)
 {
 	struct nd_papr_pdsm_health health;
@@ -255,11 +290,37 @@ static unsigned int papr_smart_get_shutdown_count(struct ndctl_cmd *cmd)
 
 	return (health.extension_flags & PDSM_DIMM_DSC_VALID) ?
 		(health.dimm_dsc) : 0;
+}
+
+static int papr_cmd_smart_inject_fatal(struct ndctl_cmd *cmd, bool enable)
+{
+	if (papr_smart_inject_valid(cmd) < 0)
+		return -EINVAL;
+
+	to_payload(cmd)->inject.flags |= PDSM_SMART_INJECT_HEALTH_FATAL;
+	to_payload(cmd)->inject.fatal_enable = enable;
 
+	return 0;
+}
+
+static int papr_cmd_smart_inject_unsafe_shutdown(struct ndctl_cmd *cmd,
+						 bool enable)
+{
+	if (papr_smart_inject_valid(cmd) < 0)
+		return -EINVAL;
+
+	to_payload(cmd)->inject.flags |= PDSM_SMART_INJECT_BAD_SHUTDOWN;
+	to_payload(cmd)->inject.unsafe_shutdown_enable = enable;
+
+	return 0;
 }
 
 struct ndctl_dimm_ops * const papr_dimm_ops = &(struct ndctl_dimm_ops) {
 	.cmd_is_supported = papr_cmd_is_supported,
+	.new_smart_inject = papr_new_smart_inject,
+	.smart_inject_supported = papr_smart_inject_supported,
+	.smart_inject_fatal = papr_cmd_smart_inject_fatal,
+	.smart_inject_unsafe_shutdown = papr_cmd_smart_inject_unsafe_shutdown,
 	.smart_get_flags = papr_smart_get_flags,
 	.get_firmware_status =  papr_get_firmware_status,
 	.xlat_firmware_status = papr_xlat_firmware_status,
diff --git a/ndctl/lib/papr_pdsm.h b/ndctl/lib/papr_pdsm.h
index f45b1e40c075..20ac20f89acd 100644
--- a/ndctl/lib/papr_pdsm.h
+++ b/ndctl/lib/papr_pdsm.h
@@ -121,12 +121,29 @@ struct nd_papr_pdsm_health {
 enum papr_pdsm {
 	PAPR_PDSM_MIN = 0x0,
 	PAPR_PDSM_HEALTH,
+	PAPR_PDSM_SMART_INJECT,
 	PAPR_PDSM_MAX,
 };
+/* Flags for injecting specific smart errors */
+#define PDSM_SMART_INJECT_HEALTH_FATAL		(1 << 0)
+#define PDSM_SMART_INJECT_BAD_SHUTDOWN		(1 << 1)
+
+struct nd_papr_pdsm_smart_inject {
+	union {
+		struct {
+			/* One or more of PDSM_SMART_INJECT_ */
+			__u32 flags;
+			__u8 fatal_enable;
+			__u8 unsafe_shutdown_enable;
+		};
+		__u8 buf[ND_PDSM_PAYLOAD_MAX_SIZE];
+	};
+};
 
 /* Maximal union that can hold all possible payload types */
 union nd_pdsm_payload {
 	struct nd_papr_pdsm_health health;
+	struct nd_papr_pdsm_smart_inject inject;
 	__u8 buf[ND_PDSM_PAYLOAD_MAX_SIZE];
 } __attribute__((packed));
 
-- 
2.34.1


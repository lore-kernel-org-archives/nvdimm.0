Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CABF52FB0
	for <nvdimm@lists.linux.dev>; Mon, 12 Jul 2021 17:31:52 +0000 (UTC)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16CH3PMO138430;
	Mon, 12 Jul 2021 13:31:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=49tuQyMwhJ0qGz86jmoH9embYIvNRZpH7JWY7skmTtw=;
 b=sG2+sQFSdyOIL/UAxIjXXXsQqBg+cp1/dbceK+hMUCufEo0IvzCxy3IAHisggTNG8i+G
 mmcbG02NWFSQ30mhRauyZZ186RW9Av6ou8Rx+n2D/OBlLLIoyIE+L3TuM7vVGlsNZUF5
 Ml1FZ4dLA18vp+kf5b+61SgUq81UtGJLtAehuKMm0nYZyBUfEOTpTomqz7QO2CzHs8TT
 uwpNNmensjIUHY4bGbDOaqDKOUCYyfdSNSxIoZNhwmryiqpuMm1ZRty0DBFxQ26eQ6Hp
 d1zJA2FqbP0BZ2GBe2CppzUvAlfMYuUoLPIS6AYTWO1lR6h3wmBXwr2dsaiKrG6pxSRx fw== 
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
	by mx0a-001b2d01.pphosted.com with ESMTP id 39rn581j3y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 12 Jul 2021 13:31:49 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
	by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16CHTLQt027484;
	Mon, 12 Jul 2021 17:31:46 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
	by ppma01fra.de.ibm.com with ESMTP id 39q3688ffy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 12 Jul 2021 17:31:46 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
	by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16CHVhV332047544
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 12 Jul 2021 17:31:43 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 769B252050;
	Mon, 12 Jul 2021 17:31:43 +0000 (GMT)
Received: from vajain21.in.ibm.com (unknown [9.85.98.133])
	by d06av21.portsmouth.uk.ibm.com (Postfix) with SMTP id 0DA7752067;
	Mon, 12 Jul 2021 17:31:40 +0000 (GMT)
Received: by vajain21.in.ibm.com (sSMTP sendmail emulation); Mon, 12 Jul 2021 23:01:40 +0530
From: Vaibhav Jain <vaibhav@linux.ibm.com>
To: nvdimm@lists.linux.dev
Cc: Vaibhav Jain <vaibhav@linux.ibm.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Ira Weiny <ira.weiny@intel.com>,
        Shivaprasad G Bhat <sbhat@linux.ibm.com>
Subject: [ndctl PATCH 2/2] libndctl/papr: Add limited support for inject-smart
Date: Mon, 12 Jul 2021 23:01:32 +0530
Message-Id: <20210712173132.1205192-3-vaibhav@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210712173132.1205192-1-vaibhav@linux.ibm.com>
References: <20210712173132.1205192-1-vaibhav@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: GDW46NassygpWxEhxVEx_IXypEklCd1N
X-Proofpoint-ORIG-GUID: GDW46NassygpWxEhxVEx_IXypEklCd1N
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-12_09:2021-07-12,2021-07-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 mlxlogscore=930 bulkscore=0 malwarescore=0 clxscore=1015
 spamscore=0 mlxscore=0 priorityscore=1501 adultscore=0 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107120126

Implements support for ndctl inject-smart command by providing an
implementation of 'smart_inject*' dimm-ops callbacks. Presently only
support for injecting unsafe-shutdown and fatal-health states is
available.

The patch also introduce various PAPR PDSM structures that are used to
communicate the inject-smart errors to the papr_scm kernel
module. This is done via SMART_INJECT PDSM which sends a payload of
type 'struct nd_papr_pdsm_smart_inject'.

The patch depends on the kernel PAPR PDSM implementation for
PDSM_SMART_INJECT posted at [1].

[1] : https://lore.kernel.org/nvdimm/20210712084819.1150350-1-vaibhav@linux.ibm.com
Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
---
 ndctl/lib/papr.c      | 61 +++++++++++++++++++++++++++++++++++++++++++
 ndctl/lib/papr_pdsm.h | 17 ++++++++++++
 2 files changed, 78 insertions(+)

diff --git a/ndctl/lib/papr.c b/ndctl/lib/papr.c
index 42ff200dc588..b797e1e5fe8b 100644
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
2.31.1


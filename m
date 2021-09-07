Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0953272
	for <nvdimm@lists.linux.dev>; Tue,  7 Sep 2021 13:59:42 +0000 (UTC)
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 187DXdk0172570;
	Tue, 7 Sep 2021 09:59:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : from : to : cc
 : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=xNZEFeTeoufTsnzkVZeXn23t4m9XjfpturvRq5+J/P8=;
 b=Dp/I0iIyGacxxDBZt8YrMwxlOogPlY1zXtaQ0v/3uyxegnsqKleJ5dido2Wufc/V3EFe
 BDZEXYV7xFa3fUA4o2OsIqcMZdwWFiGUwGjjiEMSro07yNyq6okUOc5mge3oTWy2nvyn
 AFuGZWBCXZtmaLkZOPNr0F6G6xG1NjXJdJV3xkerEQngqDNrBkd5KYN6VtZ45oiCofgB
 uj/zLWl9RaBdmyNhUKH5X826FJLt3u46BY5dBSsteYq2WRCJofpwly4GaDGbhHpdk6zA
 1MUaOrzShbzynb4php/wZTP1iOBNcAhCK9Y2g+cqv9yjunRbwgJHqPQF/+Kw2U6GcZkE 0A== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
	by mx0a-001b2d01.pphosted.com with ESMTP id 3ax46mrgep-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 Sep 2021 09:59:40 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
	by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 187Dw4Vn025729;
	Tue, 7 Sep 2021 13:59:38 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
	by ppma06ams.nl.ibm.com with ESMTP id 3av02jramb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 Sep 2021 13:59:38 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
	by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 187DxZVu50528676
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 7 Sep 2021 13:59:35 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 17D1D42041;
	Tue,  7 Sep 2021 13:59:35 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0140B42047;
	Tue,  7 Sep 2021 13:59:34 +0000 (GMT)
Received: from [172.17.0.2] (unknown [9.40.192.207])
	by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
	Tue,  7 Sep 2021 13:59:33 +0000 (GMT)
Subject: [PATCH v2 2/2] libndctl/papr: Add limited support for inject-smart
From: Shivaprasad G Bhat <sbhat@linux.ibm.com>
To: nvdimm@lists.linux.dev
Cc: aneesh.kumar@linux.ibm.com, sbhat@linux.ibm.com, vaibhav@linux.ibm.com,
        dan.j.williams@intel.com, ira.weiny@intel.com,
        vishal.l.verma@intel.com
Date: Tue, 07 Sep 2021 13:59:32 +0000
Message-ID: <163102316421.258999.7709855729118969636.stgit@99912bbcb4c7>
In-Reply-To: <163102311841.258999.14260383111577082134.stgit@99912bbcb4c7>
References: <163102311841.258999.14260383111577082134.stgit@99912bbcb4c7>
User-Agent: StGit/1.1+40.g1b20
Content-Type: text/plain; charset="utf-8"
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: WqS83rsA1M_QPGJqqjt7fZ_aeWCsYA0q
X-Proofpoint-ORIG-GUID: WqS83rsA1M_QPGJqqjt7fZ_aeWCsYA0q
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-09-07_04:2021-09-07,2021-09-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 impostorscore=0 mlxscore=0 bulkscore=0 clxscore=1015
 malwarescore=0 mlxlogscore=945 suspectscore=0 phishscore=0
 priorityscore=1501 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2108310000 definitions=main-2109070089

From: Vaibhav Jain <vaibhav@linux.ibm.com>

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

[1] : https://patchwork.kernel.org/project/linux-nvdimm/patch/163091917031.334.16212158243308361834.stgit@82313cf9f602/
Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
---
Changelog:

Since v1:
Link: https://lore.kernel.org/nvdimm/20210712173132.1205192-3-vaibhav@linux.ibm.com/
* Updates to patch description.

 ndctl/lib/papr.c      |   61 +++++++++++++++++++++++++++++++++++++++++++++++++
 ndctl/lib/papr_pdsm.h |   17 ++++++++++++++
 2 files changed, 78 insertions(+)

diff --git a/ndctl/lib/papr.c b/ndctl/lib/papr.c
index 42ff200d..b797e1e5 100644
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
index f45b1e40..20ac20f8 100644
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
 



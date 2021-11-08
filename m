Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC7BA68
	for <nvdimm@lists.linux.dev>; Mon,  8 Nov 2021 14:28:46 +0000 (UTC)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A8EH4xF013551;
	Mon, 8 Nov 2021 14:28:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : from : to : cc
 : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=0iKs16TfWPnW3VZHReReiU5w4B2x0kuoJCO2KMlBIYI=;
 b=VND5cxzvDWsjGa0TPBtx53ye+BlsQCDd5NX9dNK6+WkPTlJc23Zvnbgl1BWkMGHM/L9I
 K/3dgaIsTuC6i5opuZLwQY375Sxs1jJFdcCwg9kldBjgRs83PYRAVVKIaUa4Make3rVn
 BdsG7VRFmLvgOgNXrWCPAJFzwkYG1InwxSVHW12KmgV3YZHHHgqIDgAzbfbsgTFtBW/y
 ERP7+DiZTAnZcqLcpf4ZQbuCVlGn4aOLQ3KHKxsZSOvyuAjdjpQt0ZRG6bT5cinILNvp
 CbwnuJVDz2dO+YidBhfCOgNY/bfZeKZ4G5Dyp4jc+6z5jBBkkzHoxUovxrk7iiL1qJ40 EA== 
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
	by mx0a-001b2d01.pphosted.com with ESMTP id 3c6qeyjqg9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 08 Nov 2021 14:28:44 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
	by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1A8EP8XZ007564;
	Mon, 8 Nov 2021 14:28:42 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
	by ppma01fra.de.ibm.com with ESMTP id 3c5hb9dv5s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 08 Nov 2021 14:28:42 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
	by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1A8ESciD65143048
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 8 Nov 2021 14:28:38 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 71C2B52051;
	Mon,  8 Nov 2021 14:28:38 +0000 (GMT)
Received: from lep8c.aus.stglabs.ibm.com (unknown [9.40.192.207])
	by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 6FA8352052;
	Mon,  8 Nov 2021 14:28:37 +0000 (GMT)
Subject: [PATCH v3 2/2] libndctl/papr: Add limited support for inject-smart
From: Shivaprasad G Bhat <sbhat@linux.ibm.com>
To: nvdimm@lists.linux.dev
Cc: aneesh.kumar@linux.ibm.com, sbhat@linux.ibm.com, vaibhav@linux.ibm.com,
        dan.j.williams@intel.com, ira.weiny@intel.com,
        vishal.l.verma@intel.com
Date: Mon, 08 Nov 2021 08:28:36 -0600
Message-ID: 
 <163638170266.400685.7316845449295676032.stgit@lep8c.aus.stglabs.ibm.com>
In-Reply-To: 
 <163638167629.400685.8268507373653839032.stgit@lep8c.aus.stglabs.ibm.com>
References: 
 <163638167629.400685.8268507373653839032.stgit@lep8c.aus.stglabs.ibm.com>
User-Agent: StGit/1.1+40.g1b20
Content-Type: text/plain; charset="utf-8"
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 2e8vZ878kTB8LRtsK1Xd4i0pKq8WetkR
X-Proofpoint-ORIG-GUID: 2e8vZ878kTB8LRtsK1Xd4i0pKq8WetkR
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-08_05,2021-11-08_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 mlxscore=0 clxscore=1015 mlxlogscore=943 suspectscore=0
 lowpriorityscore=0 malwarescore=0 impostorscore=0 bulkscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111080087

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
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
---
Changelog:
Since v2:
Link : https://lore.kernel.org/nvdimm/163102316421.258999.7709855729118969636.stgit@99912bbcb4c7/
* Added the Reviewed-by: Ira tag

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
 



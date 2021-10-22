Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B37292C8B
	for <nvdimm@lists.linux.dev>; Fri, 22 Oct 2021 14:58:19 +0000 (UTC)
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19MEw9Et004460;
	Fri, 22 Oct 2021 10:58:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : from : to : cc
 : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=xNZEFeTeoufTsnzkVZeXn23t4m9XjfpturvRq5+J/P8=;
 b=dJk3561uJag3UZR+aycd5anMYq9BK2jp/C7wG0kJsG4rLg0OlWrZEPblDxyDSFfHsAW4
 8G232vZ9SHKxXJH1lr1Cltlx13T5ZqGcbBjdDjNOki3l9RQ5s8uZW5Mgcx3QSxgO+iWS
 94bDGf4KONve6w5MboyTd30TiQ9jFMa4pJ29QMOtYWm45i750wBuzULU096yBucK9/Ba
 flqu9hERUqGw0OLCUm9muTFMuswJR/dd15aC1Vrbokeed7aXlm97D4+acdZ+FsfiTGOZ
 XHlgGMA+8No7nj2z/mtqO3OH3Un/6maj3LeVUzi4wY1kqTRYXlEiiBFnPSV67/1GsZ+6 5Q== 
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
	by mx0a-001b2d01.pphosted.com with ESMTP id 3buyha803s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 22 Oct 2021 10:58:18 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
	by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19MEvmto008157;
	Fri, 22 Oct 2021 14:58:16 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
	by ppma05fra.de.ibm.com with ESMTP id 3bqpcap0hk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 22 Oct 2021 14:58:16 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
	by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19MEwCOp52756748
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 22 Oct 2021 14:58:12 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A6EB14204B;
	Fri, 22 Oct 2021 14:58:12 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9A14A42042;
	Fri, 22 Oct 2021 14:58:11 +0000 (GMT)
Received: from lep8c.aus.stglabs.ibm.com (unknown [9.40.192.207])
	by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
	Fri, 22 Oct 2021 14:58:11 +0000 (GMT)
Subject: [REPOST PATCH v2 2/2] libndctl/papr: Add limited support for
 inject-smart
From: Shivaprasad G Bhat <sbhat@linux.ibm.com>
To: nvdimm@lists.linux.dev
Cc: aneesh.kumar@linux.ibm.com, sbhat@linux.ibm.com, vaibhav@linux.ibm.com,
        dan.j.williams@intel.com, ira.weiny@intel.com,
        vishal.l.verma@intel.com
Date: Fri, 22 Oct 2021 09:58:10 -0500
Message-ID: 
 <163491463468.1641479.2722334385346179478.stgit@lep8c.aus.stglabs.ibm.com>
In-Reply-To: 
 <163491461011.1641479.7752723100626280911.stgit@lep8c.aus.stglabs.ibm.com>
References: 
 <163491461011.1641479.7752723100626280911.stgit@lep8c.aus.stglabs.ibm.com>
User-Agent: StGit/1.1+40.g1b20
Content-Type: text/plain; charset="utf-8"
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 2rLhloRDdyY41mRu2dfqLDfU5AKjQs8r
X-Proofpoint-GUID: 2rLhloRDdyY41mRu2dfqLDfU5AKjQs8r
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
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxscore=0
 malwarescore=0 spamscore=0 lowpriorityscore=0 impostorscore=0
 suspectscore=0 phishscore=0 mlxlogscore=843 priorityscore=1501
 clxscore=1015 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110220083

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
 



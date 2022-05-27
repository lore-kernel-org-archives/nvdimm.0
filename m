Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 168391854
	for <nvdimm@lists.linux.dev>; Fri, 27 May 2022 10:30:43 +0000 (UTC)
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24R9gCPT024008;
	Fri, 27 May 2022 10:30:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=rqZmCcBssAhfzhJcfMohy9uQbB7bA0menjgeT37QGTM=;
 b=KAEr2SzuuThNP0F3F9keKO+h8MLaI/SRCRP/2gjmmANwyN0CY6AMEhC9XEX0FQ6KT2kJ
 t2+Nmyyw8rPu76fSChwX0/jZknqzPtxqhYYrrZwNxAflffbBcLDxn+cK2X0RVpCs4j5d
 zxk5JCebP1eXcexYeGaXjqQrJ9TR6NwhjncgrCTSX6a9l6koQiLqVRlATVbV9TgJzCGm
 iar84gGlERTHgNVwpEdy4mKL2a+Y4IgoNrvQ96+2Vifg56A4iw2h4iLtZFSkCn12ILCZ
 JXZmnwDmeZJKPT7O9vkYRQzL8cKar3fcm6SODSGMZoC7jfavvKKFwkJJcbNODEelqWka FQ== 
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gav84guqc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 27 May 2022 10:30:42 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
	by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24RALDdi019796;
	Fri, 27 May 2022 10:30:39 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
	by ppma02fra.de.ibm.com with ESMTP id 3g9s6ma30f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 27 May 2022 10:30:39 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
	by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24RAUaXn18022898
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 May 2022 10:30:36 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 439A35204F;
	Fri, 27 May 2022 10:30:36 +0000 (GMT)
Received: from li-efb8054c-3504-11b2-a85c-ca10df28279e.ibm.com.com (unknown [9.43.36.181])
	by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 9C77352050;
	Fri, 27 May 2022 10:30:33 +0000 (GMT)
From: Tarun Sahu <tsahu@linux.ibm.com>
To: nvdimm@lists.linux.dev
Cc: tsahu@linux.ibm.com, dan.j.williams@intel.com, vishal.l.verma@intel.com,
        aneesh.kumar@linux.ibm.com, sbhat@linux.ibm.com, vaibhav@linux.ibm.com
Subject: [PATCH v4 2/2] ndctl/namespace: Implement write-infoblock for sector mode namespaces
Date: Fri, 27 May 2022 16:00:21 +0530
Message-Id: <20220527103021.452651-3-tsahu@linux.ibm.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220527103021.452651-1-tsahu@linux.ibm.com>
References: <20220527103021.452651-1-tsahu@linux.ibm.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: vojJ6Sm9nr-Pi6PO90tAbwyn00s7bSKv
X-Proofpoint-ORIG-GUID: vojJ6Sm9nr-Pi6PO90tAbwyn00s7bSKv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-27_03,2022-05-25_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 clxscore=1015 suspectscore=0 impostorscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 phishscore=0 malwarescore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2205270047

While writing to the infoblock for sector mode, collected
namespace info in ns_info structure can be used to write the
original infoblock values except the ones that have been
provided by parameter arguments to write-infoblock command.

Currently, this patch allows only uuid and parent_uuid to be
changed. In future, support for other values can be implemented
easily by adding condition inside write_btt_sb() function, which
has been created to write BTT sector mode specific namespace.

$ ./ndctl read-infoblock namespace0.0 -j
[
  {
    "dev":"namespace0.0",
    "signature":"BTT_ARENA_INFO",
    "uuid":"7296ebd6-7039-4d02-9ed9-ac5f351ff0e4",
    "parent_uuid":"46850d31-8fb5-4492-b630-9f3cd7b77500",
    "flags":0,
    "version":"2.0",
    "external_lbasize":4096,
    "external_nlba":8380160,
    "internal_lbasize":4096,
    "internal_nlba":8380416,
    "nfree":256,
    "infosize":4096,
    "nextoff":0,
    "dataoff":4096,
    "mapoff":34326196224,
    "logoff":34359717888,
    "info2off":34359734272
  }
]
read 1 infoblock

$ ./ndctl write-infoblock namespace0.0 \
>	--uuid "d0b19883-0874-4847-8c71-71549590949c"
wrote 1 infoblock

$ ./ndctl read-infoblock namespace0.0 -j
[
  {
    "dev":"namespace0.0",
    "signature":"BTT_ARENA_INFO",
    "uuid":"d0b19883-0874-4847-8c71-71549590949c",
    "parent_uuid":"46850d31-8fb5-4492-b630-9f3cd7b77500",
    "flags":0,
    "version":"2.0",
    "external_lbasize":4096,
    "external_nlba":8380160,
    "internal_lbasize":4096,
    "internal_nlba":8380416,
    "nfree":256,
    "infosize":4096,
    "nextoff":0,
    "dataoff":4096,
    "mapoff":34326196224,
    "logoff":34359717888,
    "info2off":34359734272
  }
]
read 1 infoblock

Signed-off-by: Tarun Sahu <tsahu@linux.ibm.com>
---
 ndctl/namespace.c | 54 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/ndctl/namespace.c b/ndctl/namespace.c
index e890fc2..2b0c821 100644
--- a/ndctl/namespace.c
+++ b/ndctl/namespace.c
@@ -253,6 +253,7 @@ static int set_defaults(enum device_action action)
 			break;
 		case NDCTL_NS_MODE_FSDAX:
 		case NDCTL_NS_MODE_DEVDAX:
+		case NDCTL_NS_MODE_SECTOR:
 			break;
 		default:
 			if (action == ACTION_WRITE_INFOBLOCK) {
@@ -2021,6 +2022,48 @@ static int write_pfn_sb(int fd, unsigned long long size, const char *sig,
 	return 0;
 }
 
+static int write_btt_sb(const int fd, unsigned long long size, struct ns_info *ns_info)
+{
+	int rc = 0;
+	uuid_t uuid, parent_uuid;
+
+	// updating the original values which are asked to change,
+	// rest will be unchanged
+	if (param.uuid) {
+		rc = uuid_parse(param.uuid, uuid);
+		if (rc) {
+			error("Failed to parse UUID");
+			return rc;
+		}
+		memcpy(((struct btt_sb *)(ns_info->ns_sb_buf + ns_info->offset))->uuid,
+				uuid, sizeof(uuid_t));
+	}
+	if (param.parent_uuid) {
+		rc = uuid_parse(param.parent_uuid, parent_uuid);
+		if (rc) {
+			error("Failed to parse UUID");
+			return rc;
+		}
+		memcpy(((struct btt_sb *)(ns_info->ns_sb_buf + ns_info->offset))->parent_uuid,
+				parent_uuid, sizeof(uuid_t));
+	}
+
+	if (pwrite(fd, ns_info->ns_sb_buf + ns_info->offset, sizeof(struct btt_sb),
+			       ns_info->offset) < 0) {
+		pr_verbose("Unable to write the info block: %s\n",
+				strerror(errno));
+		rc = -errno;
+	}
+
+	if (pwrite(fd, ns_info->ns_sb_buf + ns_info->offset, sizeof(struct btt_sb),
+				size - sizeof(struct btt_sb)) < 0) {
+		pr_verbose("Unable to write the info block: %s\n",
+			strerror(errno));
+		rc = -errno;
+	}
+	return rc;
+}
+
 static int file_write_infoblock(const char *path, struct ns_info *ns_info)
 {
 	unsigned long long size = parse_size64(param.size);
@@ -2068,6 +2111,14 @@ static int file_write_infoblock(const char *path, struct ns_info *ns_info)
 	case NDCTL_NS_MODE_DEVDAX:
 		rc = write_pfn_sb(fd, size, DAX_SIG, ns_info);
 		break;
+	case NDCTL_NS_MODE_SECTOR:
+		if (ns_info->mode == NDCTL_NS_MODE_SECTOR)
+			rc = write_btt_sb(fd, size, ns_info);
+		else {
+			pr_verbose("Conversion from non-sector to sector mode not allowed");
+			rc = -EPERM;
+		}
+		break;
 	case NDCTL_NS_MODE_UNKNOWN:
 		switch (ns_info->mode) {
 		case NDCTL_NS_MODE_FSDAX:
@@ -2076,6 +2127,9 @@ static int file_write_infoblock(const char *path, struct ns_info *ns_info)
 		case NDCTL_NS_MODE_DEVDAX:
 			rc = write_pfn_sb(fd, size, DAX_SIG, ns_info);
 			break;
+		case NDCTL_NS_MODE_SECTOR:
+			rc = write_btt_sb(fd, size, ns_info);
+			break;
 		default:
 			rc = -EINVAL;
 			break;
-- 
2.35.1


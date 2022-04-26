Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C306F2592
	for <nvdimm@lists.linux.dev>; Tue, 26 Apr 2022 17:22:42 +0000 (UTC)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23QGMgDV020739;
	Tue, 26 Apr 2022 17:22:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=+xKmQ5+6OKJrirCFGVI1eDolkGKXLzAZjNvUjWvJNPI=;
 b=LFzrYjx5lKlDETln6xFa1o5rVyq9MeOaII6PfSmj73mbUMC2QBjOFAFTcEw3KprhWzKQ
 uAv4WJU2WCDLtEeTQmRGkZTTZnW55mSMdY6r329UmJHnntt9sWx+f0gNSg/Q5JElbIuA
 Yan59NAVySO1nOCeqaXlbOX1pP8PYrc4xHwZ0hrQD85m/joNBN/OGBWZmGUT8Gm8paMj
 LWkLCjxoDFArGgKGhjIEg3sMmjS8VGpAmnDgw9WVfyAOKR/KTJw7ZSEUa1RqfguXPZDn
 +hdWxNECeTI8HqNvY5Wj0XgALOhyUgpNpQ/iqYcvTVHDZrugc9tZn1PD7tOqn0FuZnFl sw== 
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fpjc9v29n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 26 Apr 2022 17:22:40 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
	by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23QHCjrm021742;
	Tue, 26 Apr 2022 17:22:38 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
	by ppma06fra.de.ibm.com with ESMTP id 3fm8qhkqgy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 26 Apr 2022 17:22:38 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
	by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23QHMlKw7995962
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Apr 2022 17:22:47 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 363A64203F;
	Tue, 26 Apr 2022 17:22:35 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9056642041;
	Tue, 26 Apr 2022 17:22:32 +0000 (GMT)
Received: from li-efb8054c-3504-11b2-a85c-ca10df28279e.ibm.com.com (unknown [9.43.5.136])
	by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
	Tue, 26 Apr 2022 17:22:32 +0000 (GMT)
From: Tarun Sahu <tsahu@linux.ibm.com>
To: nvdimm@lists.linux.dev
Cc: tsahu@linux.ibm.com, dan.j.williams@intel.com, vishal.l.verma@intel.com,
        aneesh.kumar@linux.ibm.com, sbhat@linux.ibm.com, vaibhav@linux.ibm.com
Subject: [PATCH v3 2/2] ndctl/namespace:Implement write-infoblock for sector mode namespaces
Date: Tue, 26 Apr 2022 22:50:56 +0530
Message-Id: <20220426172056.122789-3-tsahu@linux.ibm.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220426172056.122789-1-tsahu@linux.ibm.com>
References: <20220426172056.122789-1-tsahu@linux.ibm.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ohyB6iSjw-RGMD7f4CA0OzpfM_jbXGC3
X-Proofpoint-GUID: ohyB6iSjw-RGMD7f4CA0OzpfM_jbXGC3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-26_05,2022-04-26_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 malwarescore=0 clxscore=1015 priorityscore=1501 mlxscore=0
 suspectscore=0 mlxlogscore=999 impostorscore=0 bulkscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204260109

Following to the previous patch in this series,
once the namespace info has been collected in ns_info,
while writing to the infoblock for sector mode, it can be
written with original infoblock values except the ones that
have been provided by parameter arguments to write-infoblock command.

Currently, this patch allows only uuid and parent_uuid to be
changed, In future support for other values can be implemented
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
index cca9a51..e802db2 100644
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
@@ -2014,6 +2015,48 @@ static int write_pfn_sb(int fd, unsigned long long size, const char *sig,
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
@@ -2061,6 +2104,14 @@ static int file_write_infoblock(const char *path, struct ns_info *ns_info)
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
@@ -2069,6 +2120,9 @@ static int file_write_infoblock(const char *path, struct ns_info *ns_info)
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


Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE75723BD
	for <nvdimm@lists.linux.dev>; Wed, 13 Apr 2022 03:53:11 +0000 (UTC)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23D3qZbJ028628;
	Wed, 13 Apr 2022 03:53:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=t8et5btTdn0XUuI2zyT4/CCSE65QZSafGCuuLaSizlk=;
 b=kjYB8L0r+trglbQE/GBOWjNpn8ruTZDzVHNLJubt929GAOYdHBLxuAHQi64PVE7Bkhva
 FmkIQb5r43vCaSHc4nCq7v+auNuVd9o+FNDUYa3YnvFcV2s/jR20sAXVl5yQrkJZ/8Ew
 95d813xZQmxNVMEzh0R4HYp1GpPArfEP9es+uA4A4JuivcaVuMUVvhGqaYf6joZNF3VB
 9nTMljtckJkctcPrO4gplkqUgDllMjGSfgzMjY5ASkpTWMslLCtqGOM1EOJ6LSpF9NNO
 YzHz1e15q/bC4jQcUADwIimss4a1DSsoWny2Zpslm9sF75jY3I8XpCD+Zoeq/qMvxwTz jQ== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
	by mx0a-001b2d01.pphosted.com with ESMTP id 3fdq0g805q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 Apr 2022 03:53:08 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
	by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23D3q4gD008196;
	Wed, 13 Apr 2022 03:53:07 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
	by ppma04ams.nl.ibm.com with ESMTP id 3fb1s8x1m2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 Apr 2022 03:53:06 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
	by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23D3r3Hn36766028
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Apr 2022 03:53:03 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 245A642042;
	Wed, 13 Apr 2022 03:53:03 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2AFC74203F;
	Wed, 13 Apr 2022 03:53:00 +0000 (GMT)
Received: from li-efb8054c-3504-11b2-a85c-ca10df28279e.ibm.com.com (unknown [9.43.41.9])
	by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
	Wed, 13 Apr 2022 03:52:59 +0000 (GMT)
From: Tarun Sahu <tsahu@linux.ibm.com>
To: nvdimm@lists.linux.dev
Cc: tsahu@linux.ibm.com, dan.j.williams@intel.com, vishal.l.verma@intel.com,
        aneesh.kumar@linux.ibm.com, sbhat@linux.ibm.com, vaibhav@linux.ibm.com
Subject: [PATCH 1/2] ndctl/namespace:Fix multiple issues with write-infoblock
Date: Wed, 13 Apr 2022 09:22:51 +0530
Message-Id: <20220413035252.161527-2-tsahu@linux.ibm.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220413035252.161527-1-tsahu@linux.ibm.com>
References: <20220413035252.161527-1-tsahu@linux.ibm.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 6-yJPrOam11wGPHcBHsRQzak-bpUXpf4
X-Proofpoint-GUID: 6-yJPrOam11wGPHcBHsRQzak-bpUXpf4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-12_06,2022-04-12_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 mlxlogscore=999 adultscore=0 lowpriorityscore=0 bulkscore=0 phishscore=0
 malwarescore=0 clxscore=1015 mlxscore=0 suspectscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204130018

Write-infoblock command-
1. update the alignment to default value if not passed as parameter
2. convert any type of namespace to fsdax if parameter -m is not 
specified
3. Incorrectly updating the uuid and parent_uuid if corresponding
parameter is not specified

Considering the above three issues, we first needed to read the
original infoblock if available, and update the align, uuid, parent_uuid
to its original value while writing the infoblock if corresponding
parameter is not passed.

This will resolve the 1, 3 issues. To resolve 2, instead of setting
the value of param.mode to fsdax by default, set it to unknown and
fetch the value of namespace mode type while reading the namespace info
and update only the parameter passed related to the namespace mode.

Originally the file-read-infoblock function read the infoblock in
binary or json format based on parameter -j (passed or not).
By default getting json and parsing the original values is one of
the way to resolve the issue, but it will create complexity in
functionality as everytime, there is a need to update the parameter,
the type of namespace mode will have to be checked that is too by
reading the signature values of infoblock.
(ref: parse_namespace_infoblock) as namespace is disabled for
read/write infoblock command.

Instead, To make the process easier and to support future adaptability
for incoming issues or feature, where details of namespace infoblock,
mode, offset in backup infoblock is required in general for fsdax,
devdax, or sector mode, I created a new structure which store,
buffer of infoblock, mode of infoblock, and offset value at which the
infoblock is available in buffer. (struct ns_info)

struct ns_info{
    void *ns_sb_buf;
    enum ndctl_namespace_mode mode;
    size_t offset;
}

There is one constructor ns_info_init(struct ns_info *ns_info) which
allocate INFOBLOCK_SZ bytes of memory to ns_info->ns_sb_buf. This buf
once allocated, can be reused in file_read_infoblock,
file_write_infoblock, write_pfn_sb, parse_namespace_infoblock, without
worrying about creating buf and freeing buf at many places for the same
purpose/task. this structure can also store the infoblock data in this
buffer, which can be checked for its original values to update it while
writing the infoblock.

There is one destructor ns_info_destroy(struct ns_info *ns_info) which
free the buffer, allocated at the time of ns_info_init(struct ns_info)

This patch change the declaration of following functions to pass
ns_info,

file_read_infoblock()
file_write_infoblock()
parse_namespace_infoblock()
write_pfn_sb()

Before and after the patch results:
Before:: (namespace2.0 is disabled and is of type devdax)
$ ./ndctl read-infoblock namespace2.0 -j
[
  {
    "dev":"namespace2.0",
    "signature":"NVDIMM_DAX_INFO",
    "uuid":"4a9b5f94-0710-499c-9125-ff9edf2500fe",
    "parent_uuid":"06bedb5d-3685-43c0-b6d7-c7e9d43c3887",
    "flags":0,
    "version":"1.4",
    "dataoff":16777216,
    "npfns":245504,
    "mode":2,
    "start_pad":0,
    "end_trunc":0,
    "align":16777216,
    "page_size":65536,
    "page_struct_size":64
  }
]
read 1 infoblock

$ ./ndctl write-infoblock namespace2.0 -m devdax -M dev
wrote 1 infoblock

$ ./ndctl read-infoblock namespace2.0 -j
[
  {
    "dev":"namespace2.0",
    "signature":"NVDIMM_DAX_INFO",
    "uuid":"fbd36f27-a5d7-4b7a-8414-8367195450da",
    "parent_uuid":"06bedb5d-3685-43c0-b6d7-c7e9d43c3887",
    "flags":0,
    "version":"1.4",
    "dataoff":16777216,
    "npfns":245504,
    "mode":2,
    "start_pad":0,
    "end_trunc":0,
    "align":65536,
    "page_size":65536,
    "page_struct_size":64
  }
]
read 1 infoblock

After:: (namespace2.0 is disabled and is of type devdax)
$ ./ndctl read-infoblock namespace2.0 -j
[
  {
    "dev":"namespace2.0",
    "signature":"NVDIMM_DAX_INFO",
    "uuid":"0867d20c-f097-4043-b4dd-7e8b26e99b05",
    "parent_uuid":"85a6e354-077a-4140-b6c0-4b5d0393951b",
    "flags":0,
    "version":"1.4",
    "dataoff":16777216,
    "npfns":245504,
    "mode":2,
    "start_pad":0,
    "end_trunc":0,
    "align":16777216,
    "page_size":65536,
    "page_struct_size":64
  }
]
read 1 infoblock

(align is not passed)
$ ./ndctl write-infoblock namespace2.0 -m devdax -M dev
wrote 1 infoblock

$ ./ndctl read-infoblock namespace2.0 -j
[
  {
    "dev":"namespace2.0",
    "signature":"NVDIMM_DAX_INFO",
    "uuid":"0867d20c-f097-4043-b4dd-7e8b26e99b05",
    "parent_uuid":"85a6e354-077a-4140-b6c0-4b5d0393951b",
    "flags":0,
    "version":"1.4",
    "dataoff":16777216,
    "npfns":245504,
    "mode":2,
    "start_pad":0,
    "end_trunc":0,
    "align":16777216,
    "page_size":65536,
    "page_struct_size":64
  }
]
read 1 infoblock

align value is retained.

similiary can be tested for uuid and parent_uuid.

$ ./ndctl read-infoblock namespace2.0 -j
Before:
[
  {
    "dev":"namespace2.0",
    "signature":"BTT_ARENA_INFO",
    "uuid":"a989fda3-d6fd-41eb-b621-d773d1e9c177",
    "parent_uuid":"80e131f6-d168-4c27-9152-b4f13106dba6",
    "flags":0,
    "version":"2.0",
    "external_lbasize":4096,
    "external_nlba":3928060,
    "internal_lbasize":4096,
    "internal_nlba":3928316,
    "nfree":256,
    "infosize":4096,
    "nextoff":0,
    "dataoff":4096,
    "mapoff":16090394624,
    "logoff":16106106880,
    "info2off":16106123264
  }
]
read 1 infoblock

$ ./ndctl write-infoblock namespace2.0
wrote 1 infoblock

$ ./ndctl read-infoblock namespace2.0 -j
[
  {
    "dev":"namespace2.0",
    "signature":"NVDIMM_PFN_INFO",
    "uuid":"b04b59de-290f-45da-956c-4364a77175ce",
    "parent_uuid":"80e131f6-d168-4c27-9152-b4f13106dba6",
    "flags":0,
    "version":"1.4",
    "dataoff":16777216,
    "npfns":245504,
    "mode":2,
    "start_pad":0,
    "end_trunc":0,
    "align":65536,
    "page_size":65536,
    "page_struct_size":64
  }
]
read 1 infoblock

After:
$ ./ndctl read-infoblock namespace2.0 -j
[
  {
    "dev":"namespace2.0",
    "signature":"BTT_ARENA_INFO",
    "uuid":"2c9cd4b6-3091-466c-9ad9-30745e328ddd",
    "parent_uuid":"8e810770-a135-4d64-8e65-e09984b7b33b",
    "flags":0,
    "version":"2.0",
    "external_lbasize":4096,
    "external_nlba":3928060,
    "internal_lbasize":4096,
    "internal_nlba":3928316,
    "nfree":256,
    "infosize":4096,
    "nextoff":0,
    "dataoff":4096,
    "mapoff":16090394624,
    "logoff":16106106880,
    "info2off":16106123264
  }
]
read 1 infoblock

$ ./ndctl write-infoblock namespace2.0
error checking infoblocks: Invalid argument
wrote 0 infoblocks

$ ./ndctl read-infoblock namespace2.0 -j
[
  {
    "dev":"namespace2.0",
    "signature":"BTT_ARENA_INFO",
    "uuid":"2c9cd4b6-3091-466c-9ad9-30745e328ddd",
    "parent_uuid":"8e810770-a135-4d64-8e65-e09984b7b33b",
    "flags":0,
    "version":"2.0",
    "external_lbasize":4096,
    "external_nlba":3928060,
    "internal_lbasize":4096,
    "internal_nlba":3928316,
    "nfree":256,
    "infosize":4096,
    "nextoff":0,
    "dataoff":4096,
    "mapoff":16090394624,
    "logoff":16106106880,
    "info2off":16106123264
  }
]
read 1 infoblock

Sector mode hasn't been changed to fsdax, as parameter -m
is not passed explicitly to ask the change.

Similiarly can be tested with devdax type namespace.

As this patch resolves only bug issues, next patch in this series
work on support to write-infoblock for sector mode. So for sector
mode, instead of getting the following output

error checking infoblocks: Invalid argument
wrote 0 infoblocks

we will get
wrote 1 infoblock

Signed-off-by: Tarun Sahu <tsahu@linux.ibm.com>
---
 ndctl/namespace.c | 247 +++++++++++++++++++++++++++++++---------------
 ndctl/namespace.h |   7 ++
 2 files changed, 173 insertions(+), 81 deletions(-)

diff --git a/ndctl/namespace.c b/ndctl/namespace.c
index 257b58c..4555a63 100644
--- a/ndctl/namespace.c
+++ b/ndctl/namespace.c
@@ -256,7 +256,7 @@ static int set_defaults(enum device_action action)
 			break;
 		}
 	} else if (action == ACTION_WRITE_INFOBLOCK) {
-		param.mode = "fsdax";
+		param.mode = "unknown";
 	} else if (!param.reconfig && param.type) {
 		if (strcmp(param.type, "pmem") == 0)
 			param.mode = "fsdax";
@@ -1750,70 +1750,105 @@ err:
 
 #define INFOBLOCK_SZ SZ_8K
 
-static int parse_namespace_infoblock(char *_buf, struct ndctl_namespace *ndns,
+static int ns_info_init(struct ns_info *ns_info)
+{
+	char *buf = NULL;
+
+	if (!ns_info)
+		return -EINVAL;
+	buf = calloc(1, INFOBLOCK_SZ);
+	if (!buf)
+		return -ENOMEM;
+	ns_info->ns_sb_buf = buf;
+	ns_info->mode = NDCTL_NS_MODE_UNKNOWN;
+	return 0;
+}
+
+static void ns_info_destroy(struct ns_info *ns_info)
+{
+	if (ns_info && ns_info->ns_sb_buf)
+		free(ns_info->ns_sb_buf);
+}
+
+static int parse_namespace_infoblock(struct ns_info *ns_info, struct ndctl_namespace *ndns,
 		const char *path, struct read_infoblock_ctx *ri_ctx)
 {
 	int rc;
-	void *buf = _buf;
+	void *buf = ns_info->ns_sb_buf;
 	unsigned long flags = param.human ? UTIL_JSON_HUMAN : 0;
 	struct btt_sb *btt1_sb = buf + SZ_4K, *btt2_sb = buf;
-	struct json_object *jblock = NULL, *jblocks = ri_ctx->jblocks;
+	struct json_object *jblock = NULL, *jblocks = NULL;
 	struct pfn_sb *pfn_sb = buf + SZ_4K, *dax_sb = buf + SZ_4K;
 
-	if (!param.json && !param.human) {
-		rc = fwrite(buf, 1, INFOBLOCK_SZ, ri_ctx->f_out);
-		if (rc != INFOBLOCK_SZ)
-			return -EIO;
-		fflush(ri_ctx->f_out);
-		return 0;
-	}
+	if (ri_ctx) {
+		jblocks = ri_ctx->jblocks;
+
+		if (!param.json && !param.human) {
+			rc = fwrite(buf, 1, INFOBLOCK_SZ, ri_ctx->f_out);
+			if (rc != INFOBLOCK_SZ)
+				return -EIO;
+			fflush(ri_ctx->f_out);
+			return 0;
+		}
 
-	if (!jblocks) {
-		jblocks = json_object_new_array();
-		if (!jblocks)
-			return -ENOMEM;
-		ri_ctx->jblocks = jblocks;
+		if (!jblocks) {
+			jblocks = json_object_new_array();
+			if (!jblocks)
+				return -ENOMEM;
+			ri_ctx->jblocks = jblocks;
+		}
 	}
 
 	if (memcmp(btt1_sb->signature, BTT_SIG, BTT_SIG_LEN) == 0) {
-		jblock = btt_parse(btt1_sb, ndns, path, flags);
-		if (jblock)
-			json_object_array_add(jblocks, jblock);
+		ns_info->offset = BTT1_START_OFFSET;
+		ns_info->mode = NDCTL_NS_MODE_SECTOR;
+		if (ri_ctx) {
+			jblock = btt_parse(btt1_sb, ndns, path, flags);
+			if (jblock)
+				json_object_array_add(jblocks, jblock);
+		}
 	}
 
 	if (memcmp(btt2_sb->signature, BTT_SIG, BTT_SIG_LEN) == 0) {
-		jblock = btt_parse(btt2_sb, ndns, path, flags);
-		if (jblock)
-			json_object_array_add(jblocks, jblock);
+		ns_info->offset = BTT2_START_OFFSET;
+		ns_info->mode = NDCTL_NS_MODE_SECTOR;
+		if (ri_ctx) {
+			jblock = btt_parse(btt2_sb, ndns, path, flags);
+			if (jblock)
+				json_object_array_add(jblocks, jblock);
+		}
 	}
 
 	if (memcmp(pfn_sb->signature, PFN_SIG, PFN_SIG_LEN) == 0) {
-		jblock = pfn_parse(pfn_sb, ndns, path, flags);
-		if (jblock)
-			json_object_array_add(jblocks, jblock);
+		ns_info->offset = SZ_4K;
+		ns_info->mode = NDCTL_NS_MODE_FSDAX;
+		if (ri_ctx) {
+			jblock = pfn_parse(pfn_sb, ndns, path, flags);
+			if (jblock)
+				json_object_array_add(jblocks, jblock);
+		}
 	}
 
 	if (memcmp(dax_sb->signature, DAX_SIG, PFN_SIG_LEN) == 0) {
-		jblock = pfn_parse(dax_sb, ndns, path, flags);
-		if (jblock)
-			json_object_array_add(jblocks, jblock);
+		ns_info->offset = SZ_4K;
+		ns_info->mode = NDCTL_NS_MODE_DEVDAX;
+		if (ri_ctx) {
+			jblock = pfn_parse(dax_sb, ndns, path, flags);
+			if (jblock)
+				json_object_array_add(jblocks, jblock);
+		}
 	}
 
 	return 0;
 }
 
 static int file_read_infoblock(const char *path, struct ndctl_namespace *ndns,
-		struct read_infoblock_ctx *ri_ctx)
+		struct read_infoblock_ctx *ri_ctx, struct ns_info *ns_info)
 {
 	const char *devname = ndns ? ndctl_namespace_get_devname(ndns) : "";
 	const char *cmd = "read-infoblock";
-	void *buf = NULL;
 	int fd = -1, rc;
 
-	buf = calloc(1, INFOBLOCK_SZ);
-	if (!buf)
-		return -ENOMEM;
-
 	if (!path) {
 		fd = STDIN_FILENO;
 		path = "<stdin>";
@@ -1827,7 +1862,7 @@ static int file_read_infoblock(const char *path, struct ndctl_namespace *ndns,
 		goto out;
 	}
 
-	rc = read(fd, buf, INFOBLOCK_SZ);
+	rc = read(fd, ns_info->ns_sb_buf, INFOBLOCK_SZ);
 	if (rc < INFOBLOCK_SZ) {
 		pr_verbose("%s: %s failed to read %s: %s\n",
 				cmd, devname, path, strerror(errno));
@@ -1837,10 +1872,8 @@ static int file_read_infoblock(const char *path, struct ndctl_namespace *ndns,
 			rc = -EIO;
 		goto out;
 	}
-
-	rc = parse_namespace_infoblock(buf, ndns, path, ri_ctx);
+	rc = parse_namespace_infoblock(ns_info, ndns, path, ri_ctx);
 out:
-	free(buf);
 	if (fd >= 0 && fd != STDIN_FILENO)
 		close(fd);
 	return rc;
@@ -1857,10 +1890,10 @@ static unsigned long PHYS_PFN(unsigned long long phys)
 
 /* Derived from nd_pfn_init() in kernel version v5.5 */
 static int write_pfn_sb(int fd, unsigned long long size, const char *sig,
-		void *buf)
+		struct ns_info *ns_info)
 {
 	unsigned long npfns, align, pfn_align;
-	struct pfn_sb *pfn_sb = buf + SZ_4K;
+	struct pfn_sb *pfn_sb = ns_info->ns_sb_buf + SZ_4K;
 	unsigned long long start, offset;
 	uuid_t uuid, parent_uuid;
 	u32 end_trunc, start_pad;
@@ -1874,24 +1907,60 @@ static int write_pfn_sb(int fd, unsigned long long size, const char *sig,
 	align = max(pfn_align, SUBSECTION_SIZE);
 	if (param.uuid)
 		uuid_parse(param.uuid, uuid);
-	else
-		uuid_generate(uuid);
-
+	else {
+		switch (ns_info->mode) {
+		case NDCTL_NS_MODE_FSDAX:
+		case NDCTL_NS_MODE_DEVDAX:
+			memcpy(uuid,
+				((struct pfn_sb *)(ns_info->ns_sb_buf + ns_info->offset))->uuid,
+				sizeof(uuid_t));
+			break;
+		case NDCTL_NS_MODE_SECTOR:
+			memcpy(uuid,
+				((struct btt_sb *)(ns_info->ns_sb_buf + ns_info->offset))->uuid,
+				sizeof(uuid_t));
+			break;
+		default:
+			uuid_generate(uuid);
+			break;
+		}
+	}
 	if (param.parent_uuid)
 		uuid_parse(param.parent_uuid, parent_uuid);
-	else
-		memset(parent_uuid, 0, sizeof(uuid_t));
+	else {
+		switch (ns_info->mode) {
+		case NDCTL_NS_MODE_FSDAX:
+		case NDCTL_NS_MODE_DEVDAX:
+			memcpy(parent_uuid,
+				((struct pfn_sb *)(ns_info->ns_sb_buf + ns_info->offset))->
+				parent_uuid, sizeof(uuid_t));
+			break;
+		case NDCTL_NS_MODE_SECTOR:
+			memcpy(parent_uuid,
+				((struct btt_sb *)(ns_info->ns_sb_buf + ns_info->offset))->
+				parent_uuid, sizeof(uuid_t));
+			break;
+		default:
+			memset(parent_uuid, 0, sizeof(uuid_t));
+			break;
+		}
+	}
 
 	if (strcmp(param.map, "dev") == 0)
 		mode = PFN_MODE_PMEM;
 	else
 		mode = PFN_MODE_RAM;
 
+	// If originally the namespace was of sector type with backup
+	// infoblock offset 0, resetting those bits.
+	memset(ns_info->ns_sb_buf, 0, SZ_4K);
+
 	/*
 	 * Unlike the kernel implementation always set start_pad and
 	 * end_trunc relative to the specified --offset= option to allow
 	 * testing legacy / "buggy" configurations.
 	 */
+
 	start_pad = ALIGN(start, align) - start;
 	end_trunc = start + size - ALIGN_DOWN(start + size, align);
 	if (mode == PFN_MODE_PMEM) {
@@ -1933,17 +2002,16 @@ static int write_pfn_sb(int fd, unsigned long long size, const char *sig,
 	checksum = fletcher64(pfn_sb, sizeof(*pfn_sb), 0);
 	pfn_sb->checksum = cpu_to_le64(checksum);
 
-	rc = write(fd, buf, INFOBLOCK_SZ);
+	rc = write(fd, ns_info->ns_sb_buf, INFOBLOCK_SZ);
 	if (rc < INFOBLOCK_SZ)
 		return -EIO;
 	return 0;
 }
 
-static int file_write_infoblock(const char *path)
+static int file_write_infoblock(const char *path, struct ns_info *ns_info)
 {
 	unsigned long long size = parse_size64(param.size);
 	int fd = -1, rc;
-	void *buf;
 
 	if (param.std_out)
 		fd = STDOUT_FILENO;
@@ -1980,25 +2048,30 @@ static int file_write_infoblock(const char *path)
 		}
 	}
 
-	buf = calloc(INFOBLOCK_SZ, 1);
-	if (!buf) {
-		rc = -ENOMEM;
-		goto out;
-	}
-
 	switch (util_nsmode(param.mode)) {
 	case NDCTL_NS_MODE_FSDAX:
-		rc = write_pfn_sb(fd, size, PFN_SIG, buf);
+		rc = write_pfn_sb(fd, size, PFN_SIG, ns_info);
 		break;
 	case NDCTL_NS_MODE_DEVDAX:
-		rc = write_pfn_sb(fd, size, DAX_SIG, buf);
+		rc = write_pfn_sb(fd, size, DAX_SIG, ns_info);
+		break;
+	case NDCTL_NS_MODE_UNKNOWN:
+		switch (ns_info->mode) {
+		case NDCTL_NS_MODE_FSDAX:
+			rc = write_pfn_sb(fd, size, PFN_SIG, ns_info);
+			break;
+		case NDCTL_NS_MODE_DEVDAX:
+			rc = write_pfn_sb(fd, size, DAX_SIG, ns_info);
+			break;
+		default:
+			rc = -EINVAL;
+			break;
+		}
 		break;
 	default:
 		rc = -EINVAL;
 		break;
 	}
-
-	free(buf);
 out:
 	if (fd >= 0 && fd != STDOUT_FILENO)
 		close(fd);
@@ -2029,9 +2102,9 @@ static int namespace_rw_infoblock(struct ndctl_namespace *ndns,
 	uuid_t uuid;
 	char str[40];
 	char path[50];
-	const char *save;
 	const char *cmd = write ? "write-infoblock" : "read-infoblock";
 	const char *devname = ndctl_namespace_get_devname(ndns);
+	struct ns_info ns_info;
 
 	if (ndctl_namespace_is_active(ndns)) {
 		pr_verbose("%s: %s enabled, must be disabled\n", cmd, devname);
@@ -2045,21 +2118,22 @@ static int namespace_rw_infoblock(struct ndctl_namespace *ndns,
 		goto out;
 	}
 
-	save = param.parent_uuid;
-	if (!param.parent_uuid) {
-		ndctl_namespace_get_uuid(ndns, uuid);
-		uuid_unparse(uuid, str);
-		param.parent_uuid = str;
-	}
-
 	sprintf(path, "/dev/%s", ndctl_namespace_get_block_device(ndns));
-	if (write) {
+	if (ns_info_init(&ns_info) != 0)
+		goto out;
+
+	rc = file_read_infoblock(path, ndns, ri_ctx, &ns_info);
+	if (!rc && write) {
 		unsigned long long align;
 		bool align_provided = true;
 
 		if (!param.align) {
 			align = ndctl_get_default_alignment(ndns);
-
+			if (ns_info.mode == NDCTL_NS_MODE_FSDAX ||
+					ns_info.mode == NDCTL_NS_MODE_DEVDAX) {
+				align = ((struct pfn_sb *)(ns_info.ns_sb_buf + ns_info.offset))->
+					align;
+			}
 			if (asprintf((char **)&param.align, "%llu", align) < 0) {
 				rc = -EINVAL;
 				goto out;
@@ -2078,18 +2152,16 @@ static int namespace_rw_infoblock(struct ndctl_namespace *ndns,
 				rc = -EINVAL;
 			}
 		}
-
 		if (!rc)
-			rc = file_write_infoblock(path);
+			rc = file_write_infoblock(path, &ns_info);
 
 		if (!align_provided) {
 			free((char *)param.align);
 			param.align = NULL;
 		}
-	} else
-		rc = file_read_infoblock(path, ndns, ri_ctx);
-	param.parent_uuid = save;
+	}
 out:
+	ns_info_destroy(&ns_info);
 	ndctl_namespace_set_raw_mode(ndns, 0);
 	ndctl_namespace_disable_invalidate(ndns);
 	return rc;
@@ -2121,11 +2193,17 @@ static int do_xaction_namespace(const char *namespace,
 		}
 
 		if (param.infile || !namespace) {
-			rc = file_read_infoblock(param.infile, NULL, &ri_ctx);
-			if (ri_ctx.jblocks)
-				util_display_json_array(ri_ctx.f_out, ri_ctx.jblocks, 0);
-			if (rc >= 0)
-				(*processed)++;
+			struct ns_info ns_info;
+
+			rc = ns_info_init(&ns_info);
+			if (!rc) {
+				rc = file_read_infoblock(param.infile, NULL, &ri_ctx, &ns_info);
+				if (ri_ctx.jblocks)
+					util_display_json_array(ri_ctx.f_out, ri_ctx.jblocks, 0);
+				if (rc >= 0)
+					(*processed)++;
+			}
+			ns_info_destroy(&ns_info);
 			return rc;
 		}
 	}
@@ -2133,10 +2211,15 @@ static int do_xaction_namespace(const char *namespace,
 	if (action == ACTION_WRITE_INFOBLOCK && !namespace) {
 		if (!param.align)
 			param.align = "2M";
+		struct ns_info ns_info;
 
-		rc = file_write_infoblock(param.outfile);
-		if (rc >= 0)
-			(*processed)++;
+		rc = ns_info_init(&ns_info);
+		if (!rc) {
+			rc = file_write_infoblock(param.outfile, &ns_info);
+			if (rc >= 0)
+				(*processed)++;
+		}
+		ns_info_destroy(&ns_info);
 		return rc;
 	}
 
@@ -2447,3 +2530,5 @@ int cmd_write_infoblock(int argc, const char **argv, struct ndctl_ctx *ctx)
 	fprintf(stderr, "wrote %d infoblock%s\n", write, write == 1 ? "" : "s");
 	return rc;
 }
+
+
diff --git a/ndctl/namespace.h b/ndctl/namespace.h
index 57735eb..a406c18 100644
--- a/ndctl/namespace.h
+++ b/ndctl/namespace.h
@@ -8,6 +8,7 @@
 #include <util/fletcher.h>
 #include <ccan/endian/endian.h>
 #include <ccan/short_types/short_types.h>
+#include <ndctl/libndctl.h>
 
 enum {
 	NSINDEX_SIG_LEN = 16,
@@ -233,6 +234,12 @@ union info_block {
 	struct btt_sb btt_sb;
 };
 
+struct ns_info {
+	void *ns_sb_buf;
+	enum ndctl_namespace_mode mode;
+	size_t offset;
+};
+
 static inline bool verify_infoblock_checksum(union info_block *sb)
 {
 	uint64_t sum;
-- 
2.18.1


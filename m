Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 646C363DB
	for <nvdimm@lists.linux.dev>; Fri,  4 Aug 2023 08:49:58 +0000 (UTC)
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3748iE6J009975;
	Fri, 4 Aug 2023 08:49:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=HlGafgXUJC2jwpv5orX/Brl5hTY21bN7YrNFc+p866g=;
 b=j3FHABhm0GzuS9MaPj7ZHh+WdFL026vQJuZWmNB1Z8eQWQcdxw3jYV2zFeCY7RLBVJ7g
 YDXwE+/XNoAQIKdt1uppYSAlDjT06iRQal+VD9KcyJNdPe8LNgUqN2C/19HgP/Q16xSh
 1A9ShWABqv3KurixdVeHuhumPze4Jdd5y9km/LH2v4EbogyC2p+NmQXF6G8hEbOs/vhJ
 59ATSpFWMC0ZLKoVu6+3rbv6kn3aqfOsafjFEAB291NQdLyCRcELgWskcxiy0ExSZyQM
 /f8BlDeMbqzyow/UsVqSNrZPZLZntEE1Q8DHlNp3Jfv8TrOMqA19/6aPMnCsjiHRfVMh Pw== 
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3s8x3003te-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 04 Aug 2023 08:49:50 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 37474IfG027806;
	Fri, 4 Aug 2023 08:49:49 GMT
Received: from smtprelay02.wdc07v.mail.ibm.com ([172.16.1.69])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3s8kp2v4cx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 04 Aug 2023 08:49:49 +0000
Received: from smtpav01.dal12v.mail.ibm.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
	by smtprelay02.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3748nn3C66388284
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 4 Aug 2023 08:49:49 GMT
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0DEB858058;
	Fri,  4 Aug 2023 08:49:49 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5CA5558057;
	Fri,  4 Aug 2023 08:49:47 +0000 (GMT)
Received: from skywalker.ibmuc.com (unknown [9.43.22.158])
	by smtpav01.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  4 Aug 2023 08:49:47 +0000 (GMT)
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
To: nvdimm@lists.linux.dev, dan.j.williams@intel.com, vishal.l.verma@intel.com
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: [PATCH 1/2] nvdimm/pfn_dev: Prevent the creation of zero-sized namespaces
Date: Fri,  4 Aug 2023 14:19:33 +0530
Message-ID: <20230804084934.171056-1-aneesh.kumar@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: qf7w948EoTvZCv9-A5wMLHW-TZUnHRCh
X-Proofpoint-GUID: qf7w948EoTvZCv9-A5wMLHW-TZUnHRCh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-08-04_06,2023-08-03_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 clxscore=1015 impostorscore=0 priorityscore=1501
 phishscore=0 spamscore=0 malwarescore=0 bulkscore=0 lowpriorityscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2308040075

On architectures that have different page size values used for kernel
direct mapping and userspace mappings, the user can end up creating zero-sized
namespaces as shown below

:/sys/bus/nd/devices/region1# cat align
0x1000000
/sys/bus/nd/devices/region1# echo 0x200000 > align
/sys/bus/nd/devices/region1/dax1.0# cat supported_alignments
65536 16777216
 $ ndctl create-namespace -r region1 -m devdax -s 18M --align 64K
{
  "dev":"namespace1.0",
  "mode":"devdax",
  "map":"dev",
  "size":0,
  "uuid":"3094329a-0c66-4905-847e-357223e56ab0",
  "daxregion":{
    "id":1,
    "size":0,
    "align":65536
  },
  "align":65536
}
similarily for fsdax

 $ ndctl create-namespace -r region1 -m fsdax  -s 18M --align 64K
{
  "dev":"namespace1.0",
  "mode":"fsdax",
  "map":"dev",
  "size":0,
  "uuid":"45538a6f-dec7-405d-b1da-2a4075e06232",
  "sector_size":512,
  "align":65536,
  "blockdev":"pmem1"
}

In commit 9ffc1d19fc4a ("mm/memremap_pages: Introduce memremap_compat_align()")
memremap_compat_align was added to make sure the kernel always creates
namespaces with 16MB alignment. But the user can still override the
region alignment and no input validation is done in the region alignment
values to retain the flexibility user had before. However, the kernel
ensures that only part of the namespace that can be mapped via kernel
direct mapping page size is enabled. This is achieved by tracking the
unmapped part of the namespace in pfn_sb->end_trunc. The kernel also
ensures that the start address of the namespace is also aligned to the
kernel direct mapping page size.

Depending on the user request, the kernel implements userspace mapping
alignment by updating pfn device alignment attribute and this value is
used to adjust the start address for userspace mappings. This is tracked
in pfn_sb->dataoff. Hence the available size for userspace mapping is:

usermapping_size = size of the namespace - pfn_sb->end_trun - pfn_sb->dataoff

If the kernel finds the user mapping size zero then don't allow the
creation of namespace.

After fix:
$ ndctl create-namespace -f  -r region1 -m devdax  -s 18M --align 64K
libndctl: ndctl_dax_enable: dax1.1: failed to enable
  Error: namespace1.2: failed to enable

failed to create namespace: No such device or address

And existing zero sized namespace will be marked disabled.
root@ltczz75-lp2:/home/kvaneesh# ndctl  list -N -r region1 -i
[
  {
    "dev":"namespace1.0",
    "mode":"raw",
    "size":18874368,
    "uuid":"94a90fb0-8e78-4fb6-a759-ffc62f9fa181",
    "sector_size":512,
    "state":"disabled"
  },

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
---
 drivers/nvdimm/pfn_devs.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
index af7d9301520c..36b904a129b9 100644
--- a/drivers/nvdimm/pfn_devs.c
+++ b/drivers/nvdimm/pfn_devs.c
@@ -453,7 +453,7 @@ int nd_pfn_validate(struct nd_pfn *nd_pfn, const char *sig)
 	struct resource *res;
 	enum nd_pfn_mode mode;
 	struct nd_namespace_io *nsio;
-	unsigned long align, start_pad;
+	unsigned long align, start_pad, end_trunc;
 	struct nd_pfn_sb *pfn_sb = nd_pfn->pfn_sb;
 	struct nd_namespace_common *ndns = nd_pfn->ndns;
 	const uuid_t *parent_uuid = nd_dev_to_uuid(&ndns->dev);
@@ -503,6 +503,7 @@ int nd_pfn_validate(struct nd_pfn *nd_pfn, const char *sig)
 	align = le32_to_cpu(pfn_sb->align);
 	offset = le64_to_cpu(pfn_sb->dataoff);
 	start_pad = le32_to_cpu(pfn_sb->start_pad);
+	end_trunc = le32_to_cpu(pfn_sb->end_trunc);
 	if (align == 0)
 		align = 1UL << ilog2(offset);
 	mode = le32_to_cpu(pfn_sb->mode);
@@ -610,6 +611,10 @@ int nd_pfn_validate(struct nd_pfn *nd_pfn, const char *sig)
 		return -EOPNOTSUPP;
 	}
 
+	if (offset >= (res->end - res->start + 1 - start_pad - end_trunc)) {
+		dev_err(&nd_pfn->dev, "bad offset with small namespace\n");
+		return -EOPNOTSUPP;
+	}
 	return 0;
 }
 EXPORT_SYMBOL(nd_pfn_validate);
@@ -810,7 +815,8 @@ static int nd_pfn_init(struct nd_pfn *nd_pfn)
 	else
 		return -ENXIO;
 
-	if (offset >= size) {
+	if (offset >= (size - end_trunc)) {
+		/* This implies we result in zero size devices */
 		dev_err(&nd_pfn->dev, "%s unable to satisfy requested alignment\n",
 				dev_name(&ndns->dev));
 		return -ENXIO;
-- 
2.41.0


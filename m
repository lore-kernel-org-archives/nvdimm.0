Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A4F220EC
	for <nvdimm@lists.linux.dev>; Wed,  9 Aug 2023 05:35:35 +0000 (UTC)
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3795Sthp002122;
	Wed, 9 Aug 2023 05:35:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=LLZ+e5w6TJ/+2tBeGqQqRgGDC3vCpOdZrPOOq+NY3pg=;
 b=M8pb19OSVztn4wg0joWsLq0F1ZSMXFGmI3Xe6ghBYUmJngeJ3Jh5TejTnVJyQeiCjWfa
 HzjX20w5314dEEeJ74tntHewM+IUTuhUD+GBl8NFUneQyUwgKh1ECblVOgSNKq4jn94J
 zr7A/5wJ9jNqAmGangQnk/2vctcBYHo7ME1Gc9dVYUFapipTCix3Az7TG8tQfqNUO0SV
 asElsqMxvwKukc3WYduJ+v+Excvv/AAHuWP+j8EpxhwP0kbFqhX1tfAiag87uOGsD1Fk
 KsRlt5lCsLtyqSjnIfatQCd/ABX/w4cQ73XFeeZ/xHu/rOGAJVWZC2+Bu3ThMNBe/lpa wA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sc4pk0aww-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 09 Aug 2023 05:35:28 +0000
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3795U3VD005733;
	Wed, 9 Aug 2023 05:35:27 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sc4pk0av6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 09 Aug 2023 05:35:27 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3793UbvI015374;
	Wed, 9 Aug 2023 05:35:25 GMT
Received: from smtprelay02.dal12v.mail.ibm.com ([172.16.1.4])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3sb3f2xxr6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 09 Aug 2023 05:35:25 +0000
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
	by smtprelay02.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3795ZObM17498808
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 9 Aug 2023 05:35:25 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B4E0C5805B;
	Wed,  9 Aug 2023 05:35:24 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B05DD5805D;
	Wed,  9 Aug 2023 05:35:22 +0000 (GMT)
Received: from skywalker.in.ibm.com (unknown [9.109.212.144])
	by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  9 Aug 2023 05:35:22 +0000 (GMT)
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
To: nvdimm@lists.linux.dev, dan.j.williams@intel.com, vishal.l.verma@intel.com
Cc: Jeff Moyer <jmoyer@redhat.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: [PATCH v2 1/2] nvdimm/pfn_dev: Prevent the creation of zero-sized namespaces
Date: Wed,  9 Aug 2023 11:05:11 +0530
Message-ID: <20230809053512.350660-1-aneesh.kumar@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: EfPJxvJv9pvE8KPf5aTcCJsEzvEbtaWL
X-Proofpoint-ORIG-GUID: vKcCi94YW1LYqDLilX8MZDAeHkO-x20k
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-08-09_03,2023-08-08_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 adultscore=0 clxscore=1015 phishscore=0 priorityscore=1501
 impostorscore=0 spamscore=0 suspectscore=0 bulkscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2308090049

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
Changes from v1:
* Use resource_size() helper instead of opencoding it

 drivers/nvdimm/pfn_devs.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
index af7d9301520c..0777b1626f6c 100644
--- a/drivers/nvdimm/pfn_devs.c
+++ b/drivers/nvdimm/pfn_devs.c
@@ -452,8 +452,9 @@ int nd_pfn_validate(struct nd_pfn *nd_pfn, const char *sig)
 	u64 checksum, offset;
 	struct resource *res;
 	enum nd_pfn_mode mode;
+	resource_size_t res_size;
 	struct nd_namespace_io *nsio;
-	unsigned long align, start_pad;
+	unsigned long align, start_pad, end_trunc;
 	struct nd_pfn_sb *pfn_sb = nd_pfn->pfn_sb;
 	struct nd_namespace_common *ndns = nd_pfn->ndns;
 	const uuid_t *parent_uuid = nd_dev_to_uuid(&ndns->dev);
@@ -503,6 +504,7 @@ int nd_pfn_validate(struct nd_pfn *nd_pfn, const char *sig)
 	align = le32_to_cpu(pfn_sb->align);
 	offset = le64_to_cpu(pfn_sb->dataoff);
 	start_pad = le32_to_cpu(pfn_sb->start_pad);
+	end_trunc = le32_to_cpu(pfn_sb->end_trunc);
 	if (align == 0)
 		align = 1UL << ilog2(offset);
 	mode = le32_to_cpu(pfn_sb->mode);
@@ -584,7 +586,8 @@ int nd_pfn_validate(struct nd_pfn *nd_pfn, const char *sig)
 	 */
 	nsio = to_nd_namespace_io(&ndns->dev);
 	res = &nsio->res;
-	if (offset >= resource_size(res)) {
+	res_size = resource_size(res);
+	if (offset >= res_size) {
 		dev_err(&nd_pfn->dev, "pfn array size exceeds capacity of %s\n",
 				dev_name(&ndns->dev));
 		return -EOPNOTSUPP;
@@ -610,6 +613,10 @@ int nd_pfn_validate(struct nd_pfn *nd_pfn, const char *sig)
 		return -EOPNOTSUPP;
 	}
 
+	if (offset >= (res_size - start_pad - end_trunc)) {
+		dev_err(&nd_pfn->dev, "bad offset with small namespace\n");
+		return -EOPNOTSUPP;
+	}
 	return 0;
 }
 EXPORT_SYMBOL(nd_pfn_validate);
@@ -810,7 +817,8 @@ static int nd_pfn_init(struct nd_pfn *nd_pfn)
 	else
 		return -ENXIO;
 
-	if (offset >= size) {
+	if (offset >= (size - end_trunc)) {
+		/* This results in zero size devices */
 		dev_err(&nd_pfn->dev, "%s unable to satisfy requested alignment\n",
 				dev_name(&ndns->dev));
 		return -ENXIO;
-- 
2.41.0


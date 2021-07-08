Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D98772
	for <nvdimm@lists.linux.dev>; Thu,  8 Jul 2021 02:57:27 +0000 (UTC)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1682WdWQ158680;
	Wed, 7 Jul 2021 22:57:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : from : to : cc
 : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=pp1; bh=z/3BMmiP2a2SdNmLJvAuYOQNLT3A/HcMFBVqSbsWiw0=;
 b=OwFJOBdcFm13Lxqa/nZQFAOwi7ohGuJ9VLUdjuSaDLByP03Y8wh6hKC4OAPwE76Kolgh
 IxgocL2dgz9pDonPzP/gWeHm8z9zjXltcQNEDEa95W/IkswRWKNImPTxZC0ixoHdby1G
 wHqBmo3WJu0cV8OeHaPasqCGsHZ3+jTkALRuX7ewS9tJhafuvjUHs/1bqHDKQl2xjJ34
 uKZE2YG1Qe7rOZLDqRCMSm8q6AnNb4Vpnc2ILiIJ8Pj2IVdCJjpJ66DCV3xyXUiS/v4H
 PN6JTlSTehrfUiSl06osqtnmWI9DwcxINCsPj2KkSjkMmH2XvZfpTgo7AU/Xnq/PD6ku hg== 
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
	by mx0a-001b2d01.pphosted.com with ESMTP id 39mm671t3q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 07 Jul 2021 22:57:09 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
	by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1682rNRB018954;
	Thu, 8 Jul 2021 02:57:07 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
	by ppma02fra.de.ibm.com with ESMTP id 39jfh892fs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 08 Jul 2021 02:57:07 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
	by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1682v5Tn26018154
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 8 Jul 2021 02:57:05 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 46616A4057;
	Thu,  8 Jul 2021 02:57:05 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 219EEA4040;
	Thu,  8 Jul 2021 02:57:04 +0000 (GMT)
Received: from lep8c.aus.stglabs.ibm.com (unknown [9.40.192.207])
	by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
	Thu,  8 Jul 2021 02:57:03 +0000 (GMT)
Subject: [PATCH REBASED v5 0/3] spapr: nvdimm: Introduce spapr-nvdimm device
From: Shivaprasad G Bhat <sbhat@linux.ibm.com>
To: david@gibson.dropbear.id.au, groug@kaod.org, qemu-ppc@nongnu.org
Cc: qemu-devel@nongnu.org, aneesh.kumar@linux.ibm.com, nvdimm@lists.linux.dev,
        kvm-ppc@vger.kernel.org, bharata@linux.vnet.ibm.com
Date: Wed, 07 Jul 2021 21:57:03 -0500
Message-ID: 
 <162571302321.1030381.15196355582642786915.stgit@lep8c.aus.stglabs.ibm.com>
User-Agent: StGit/0.19
Content-Type: text/plain; charset="utf-8"
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: oeKswYuuXQByvdgwYgysj44RNvCJKn1g
X-Proofpoint-ORIG-GUID: oeKswYuuXQByvdgwYgysj44RNvCJKn1g
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-08_01:2021-07-06,2021-07-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 adultscore=0
 lowpriorityscore=0 spamscore=0 mlxscore=0 priorityscore=1501 phishscore=0
 clxscore=1011 mlxlogscore=999 malwarescore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107080011

If the device backend is not persistent memory for the nvdimm, there
is need for explicit IO flushes to ensure persistence.

On SPAPR, the issue is addressed by adding a new hcall to request for
an explicit flush from the guest when the backend is not pmem.
So, the approach here is to convey when the hcall flush is required
in a device tree property. The guest once it knows the device needs
explicit flushes, makes the hcall as and when required.

It was suggested to create a new device type to address the
explicit flush for such backends on PPC instead of extending the
generic nvdimm device with new property. So, the patch introduces
the spapr-nvdimm device. The new device inherits the nvdimm device
with the new bahviour such that if the backend has pmem=no, the
device tree property is set.

The below demonstration shows the map_sync behavior for non-pmem
backends.
(https://github.com/avocado-framework-tests/avocado-misc-tests/blob/master/memory/ndctl.py.data/map_sync.c)

The pmem0 is from spapr-nvdimm with with backend pmem=yes, and pmem1 is
from spapr-nvdimm with pmem=no, mounted as
/dev/pmem0 on /mnt1 type xfs (rw,relatime,attr2,dax=always,inode64,logbufs=8,logbsize=32k,noquota)
/dev/pmem1 on /mnt2 type xfs (rw,relatime,attr2,dax=always,inode64,logbufs=8,logbsize=32k,noquota)

[root@atest-guest ~]# ./mapsync /mnt1/newfile ----> When pmem=yes
[root@atest-guest ~]# ./mapsync /mnt2/newfile ----> when pmem=no
Failed to mmap  with Operation not supported

First patch implements the hcall, adds the necessary
vmstate properties to spapr machine structure for carrying the hcall
status during save-restore. The nature of the hcall being asynchronus,
the patch uses aio utilities to offload the flush. The second patch
introduces the spapr-nvdimm device, adds the device tree property
for the guest when spapr-nvdimm is used with pmem="no" on the backend.

The kernel changes to exploit this hcall is at
https://github.com/linuxppc/linux/commit/75b7c05ebf9026.patch

---
v4 - https://lists.gnu.org/archive/html/qemu-devel/2021-04/msg05982.html
Changes from v4:
      - Introduce spapr-nvdimm device with nvdimm device as the parent.
      - The new spapr-nvdimm has no new properties. As this is a new
        device and there is no migration related dependencies to be
        taken care of, the device behavior is made to set the device tree
        property and enable hcall when the device type spapr-nvdimm is
        used with pmem="no"
      - Fixed commit messages
      - Added checks to ensure the backend is actualy file and not memory
      - Addressed things pointed out by Eric

v3 - https://lists.gnu.org/archive/html/qemu-devel/2021-03/msg07916.html
Changes from v3:
      - Fixed the forward declaration coding guideline violations in 1st patch.
      - Removed the code waiting for the flushes to complete during migration,
        instead restart the flush worker on destination qemu in post load.
      - Got rid of the randomization of the flush tokens, using simple
        counter.
      - Got rid of the redundant flush state lock, relying on the BQL now.
      - Handling the memory-backend-ram usage
      - Changed the sync-dax symantics from on/off to 'unsafe','writeback' and 'direct'.
	Added prevention code using 'writeback' on arm and x86_64.
      - Fixed all the miscellaneous comments.

v2 - https://lists.gnu.org/archive/html/qemu-devel/2020-11/msg07031.html
Changes from v2:
      - Using the thread pool based approach as suggested
      - Moved the async hcall handling code to spapr_nvdimm.c along
        with some simplifications
      - Added vmstate to preserve the hcall status during save-restore
        along with pre_save handler code to complete all ongoning flushes.
      - Added hw_compat magic for sync-dax 'on' on previous machines.
      - Miscellanious minor fixes.

v1 - https://lists.gnu.org/archive/html/qemu-devel/2020-11/msg06330.html
Changes from v1
      - Fixed a missed-out unlock
      - using QLIST_FOREACH instead of QLIST_FOREACH_SAFE while generating token

Shivaprasad G Bhat (2):
      spapr: nvdimm: Implement H_SCM_FLUSH hcall
      spapr: nvdimm: Introduce spapr-nvdimm device


 hw/ppc/spapr.c                |    6 +
 hw/ppc/spapr_nvdimm.c         |  286 +++++++++++++++++++++++++++++++++++++++++
 include/hw/ppc/spapr.h        |   11 +-
 include/hw/ppc/spapr_nvdimm.h |   17 ++
 4 files changed, 319 insertions(+), 1 deletion(-)

--
Signature


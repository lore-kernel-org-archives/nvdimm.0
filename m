Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6063272
	for <nvdimm@lists.linux.dev>; Tue, 27 Jul 2021 08:11:50 +0000 (UTC)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16R8BFit055095;
	Tue, 27 Jul 2021 04:11:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : from : to : cc
 : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=pp1; bh=a9fgckXOPYhGRhokCuaedi5UOwQGzm+bXaPE2UAzPws=;
 b=baBZE39JCq1fSN1RX01pAVLzeYH8lVV95jSLGZg9ceh45Xk1ayG3Ejz3MbkueGbV2NrN
 LMRptKVQaRmQ7M9viJC1ZfgUamTHm44R/Vw1WFAX/wNfJ40fxAT42NOVEBB4EHYh0VOf
 HxDqU8mhrig1jlV3ensNgLzJDu126hZH7ZK2psK7GSKLPqVABN08N+qTXLPXrnckzxq6
 r5n5qTtOUDMIPCQ9+QGQsUlRX9Op2atzaqs28l5z1+NFJvm2hEvVeE8nABEgEXKt1oI8
 ZRRt9iygsVtR/VW7nCWW3tlzizEccPGc9N7phuFtajO2mlP3so5wC0kgCnR637mLQvf5 /w== 
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
	by mx0a-001b2d01.pphosted.com with ESMTP id 3a2e108pva-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 27 Jul 2021 04:11:46 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
	by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16R82hH0003020;
	Tue, 27 Jul 2021 08:11:44 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
	by ppma01fra.de.ibm.com with ESMTP id 3a235kr5v8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 27 Jul 2021 08:11:43 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
	by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16R893M127197844
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 27 Jul 2021 08:09:03 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 69CEF5204F;
	Tue, 27 Jul 2021 08:11:40 +0000 (GMT)
Received: from lep8c.aus.stglabs.ibm.com (unknown [9.40.192.207])
	by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 2756A5206B;
	Tue, 27 Jul 2021 08:11:39 +0000 (GMT)
Subject: [PATCH 0/3] test:ndtest: Fix various test cases on ndtest
From: Shivaprasad G Bhat <sbhat@linux.ibm.com>
To: nvdimm@lists.linux.dev
Cc: aneesh.kumar@linux.ibm.com, sbhat@linux.ibm.com, vaibhav@linux.ibm.com,
        santosh@fossix.org, dan.j.williams@intel.com, ira.weiny@intel.com,
        vishal.l.verma@intel.com
Date: Tue, 27 Jul 2021 03:11:38 -0500
Message-ID: 
 <162737349828.3944327.12958894438783947695.stgit@lep8c.aus.stglabs.ibm.com>
User-Agent: StGit/1.1+40.g1b20
Content-Type: text/plain; charset="utf-8"
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: n2UW4pECs7rylkaFC1cc7hgGYxI6Z9oZ
X-Proofpoint-ORIG-GUID: n2UW4pECs7rylkaFC1cc7hgGYxI6Z9oZ
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-27_05:2021-07-27,2021-07-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxlogscore=526
 malwarescore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0
 mlxscore=0 clxscore=1011 phishscore=0 bulkscore=0 impostorscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107270046

papr_scm[1] and ndtest[2] now support PDSMs for injecting smart errors
that can exercise various libndctl code paths. The following patch
series updates libndctl to support injecting these inject-smart events
to an nvdimm. Since the support for inject-smart is presently limited
to injecting fatal-health and dirty-shutdown the patch-series tweaks
the ndctl tests to only exercise certain applicable tests for PAPR
nvdimms.

The patches to be applied on the series[3] which added the necessary
smart error injection support. 

The make check results look like this below.

PASS: libndctl
PASS: dsm-fail
FAIL: dpa-alloc
FAIL: parent-uuid
PASS: multi-pmem
PASS: create.sh
FAIL: clear.sh
FAIL: pmem-errors.sh
FAIL: daxdev-errors.sh
PASS: multi-dax.sh
PASS: btt-check.sh
FAIL: label-compat.sh
PASS: blk-exhaust.sh
PASS: sector-mode.sh
FAIL: inject-error.sh
SKIP: btt-errors.sh
SKIP: hugetlb
PASS: btt-pad-compat.sh
SKIP: firmware-update.sh
SKIP: ack-shutdown-count-set
PASS: rescan-partitions.sh
PASS: inject-smart.sh
PASS: monitor.sh
PASS: max_available_extent_ns.sh
FAIL: pfn-meta-errors.sh
PASS: track-uuid.sh
============================================================================
Testsuite summary for ndctl 71.35.gf8b89d5
============================================================================
# TOTAL: 26
# PASS:  14
# SKIP:  4
# XFAIL: 0
# FAIL:  8
# XPASS: 0
# ERROR: 0
============================================================================

[1] : https://patchwork.kernel.org/project/linux-nvdimm/patch/20210712084819.1150350-1-vaibhav@linux.ibm.com/
[2] : https://www.mail-archive.com/nvdimm@lists.linux.dev/msg00590.html
[3] : https://www.mail-archive.com/nvdimm@lists.linux.dev/msg00426.html

---

Shivaprasad G Bhat (3):
      test/inject-smart: Enable inject-smart tests on ndtest
      ndtest/ack-shutdown-count: Skip the test on ndtest
      test/monitor.sh: Partially skip monitor test on ndtest


 test/ack-shutdown-count-set.c |  4 +++
 test/inject-smart.sh          | 12 ++++++---
 test/libndctl.c               | 46 +++++++++++++++++++++++++++++++++++
 test/list-smart-dimm.c        | 36 ++++++++++++++++++++++++++-
 test/monitor.sh               | 11 ++++++++-
 5 files changed, 103 insertions(+), 6 deletions(-)

--
Signature


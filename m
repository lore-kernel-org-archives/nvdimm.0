Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB78872
	for <nvdimm@lists.linux.dev>; Fri, 22 Oct 2021 17:47:07 +0000 (UTC)
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
	by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19MGRFfK016190;
	Fri, 22 Oct 2021 13:47:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : from : to : cc
 : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=pp1; bh=YR0uFKHuchxfPyamNB7isSc1s+WC95FtXW10xNxJKX8=;
 b=c5H49TKOkyypKyTkoCfk9ZWmQ8bpEbqWflTSaA3aytRo0brTaXOJfUXXlDv1siRAD3DB
 sZQtH8LYVfs7n4g/3sAlCqiWhO/nCbagxc3W7lpqfZGFGgeJgGmPk+66R2X30Lj0c/xe
 w8cJHVcEFZC28ZgxBJO7Iop+9u71yAiSLBERlhLe7Cz6Zf/59TdHQguPowNzgt9tLyJx
 OIlb4Mxzuv5Es7ID+L6jmdd6xFVYVzePfNqx0tsWgj9S7E3vZ6VaWp4z6zUE22ZLQXh9
 X72zTJWkMprwSuXBblNY71kVXrTIdUBmVMBiaqv8m9kK6vkSUDTAa8LhXg8B5nUox6s2 JQ== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
	by mx0b-001b2d01.pphosted.com with ESMTP id 3buwdex1eu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 22 Oct 2021 13:47:04 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
	by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19MHfqj4012290;
	Fri, 22 Oct 2021 17:47:03 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
	by ppma06ams.nl.ibm.com with ESMTP id 3bqp0ktmjc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 22 Oct 2021 17:47:02 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
	by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19MHkxwb60424696
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 22 Oct 2021 17:46:59 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 747314C066;
	Fri, 22 Oct 2021 17:46:59 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6867A4C050;
	Fri, 22 Oct 2021 17:46:58 +0000 (GMT)
Received: from lep8c.aus.stglabs.ibm.com (unknown [9.40.192.207])
	by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
	Fri, 22 Oct 2021 17:46:58 +0000 (GMT)
Subject: [REPOST PATCH v2 0/3] test:ndtest: Fix various test cases on ndtest
From: Shivaprasad G Bhat <sbhat@linux.ibm.com>
To: nvdimm@lists.linux.dev
Cc: aneesh.kumar@linux.ibm.com, sbhat@linux.ibm.com, vaibhav@linux.ibm.com,
        dan.j.williams@intel.com, ira.weiny@intel.com,
        vishal.l.verma@intel.com
Date: Fri, 22 Oct 2021 12:46:57 -0500
Message-ID: 
 <163492481743.1652625.4203942321686969839.stgit@lep8c.aus.stglabs.ibm.com>
User-Agent: StGit/1.1+40.g1b20
Content-Type: text/plain; charset="utf-8"
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: IM-ScUpddsxuKhXHhhWnCaBYsvdNNOxx
X-Proofpoint-ORIG-GUID: IM-ScUpddsxuKhXHhhWnCaBYsvdNNOxx
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
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 spamscore=0
 priorityscore=1501 malwarescore=0 mlxlogscore=419 clxscore=1015
 phishscore=0 mlxscore=0 lowpriorityscore=0 bulkscore=0 impostorscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110220101

Changes since v1:
Link: https://patchwork.kernel.org/project/linux-nvdimm/cover/162737349828.3944327.12958894438783947695.stgit@lep8c.aus.stglabs.ibm.com/
* Updated patch descriptions

papr_scm[1] and ndtest[2] now support PDSMs for injecting smart errors
that can exercise various libndctl code paths. The following patch
series updates libndctl to support injecting these inject-smart events
to an nvdimm. Since the support for inject-smart is presently limited
to injecting fatal-health and dirty-shutdown the patch-series tweaks
the ndctl tests to only exercise certain applicable tests for PAPR
nvdimms.

The patches to be applied on the series[3] which added the necessary
smart error injection support.

The make check results look like this below on PPC64LE system.

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

[1] : https://patchwork.kernel.org/project/linux-nvdimm/patch/163091917031.334.16212158243308361834.stgit@82313cf9f602/
[2] : https://patchwork.kernel.org/project/linux-nvdimm/patch/163091957728.562.4766998781117968879.stgit@82313cf9f602/
[3] : https://patchwork.kernel.org/project/linux-nvdimm/list/?series=543183

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


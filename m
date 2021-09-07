Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7702D72
	for <nvdimm@lists.linux.dev>; Tue,  7 Sep 2021 13:58:53 +0000 (UTC)
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 187DXIeL010221;
	Tue, 7 Sep 2021 09:58:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : from : to : cc
 : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=pp1; bh=62/2opQBQnSIpwKuf5ueIxmXWHdx95UlecFJ1KUK8vU=;
 b=XdWRk8lR8p57LDswlSEOBryjwchPRHcstkHwy9MHQDHP5YRz9JN/NL8pGVaArUgucer5
 2h2tKFkIETh1Dp7ilXt8ThwmwdrcFtZNxGrrebsTAEO32SGCHcrJ3CwVRvT9DwaK+l5S
 DFjiVpSeHH/zb3QPPoafrzE5Jt7K5zHZX1I0+alsonI9FNX/06Ej17Q8JOiYb2ihFfsX
 pMjRm2k016jIp//t3YfVQV43+IworU81ri6fX//gRaDWs1BPhHd+H99Tmcv6YhJ7zdsk
 3rodwTB5+uqPAO5oW8BaaeoU6S7kIzdp/3JgPJSrJitruMTSl7braQxoWIl8wHZz0kid Aw== 
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
	by mx0a-001b2d01.pphosted.com with ESMTP id 3awvb614a3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 Sep 2021 09:58:46 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
	by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 187Dw82m013825;
	Tue, 7 Sep 2021 13:58:44 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
	by ppma05fra.de.ibm.com with ESMTP id 3av0e971y3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 Sep 2021 13:58:44 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
	by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 187Dweq729622710
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 7 Sep 2021 13:58:40 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6CE7CA4053;
	Tue,  7 Sep 2021 13:58:40 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5B554A4040;
	Tue,  7 Sep 2021 13:58:39 +0000 (GMT)
Received: from [172.17.0.2] (unknown [9.40.192.207])
	by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
	Tue,  7 Sep 2021 13:58:39 +0000 (GMT)
Subject: [PATCH v2 0/2] papr: Implement initial support for injecting smart
 errors
From: Shivaprasad G Bhat <sbhat@linux.ibm.com>
To: nvdimm@lists.linux.dev
Cc: aneesh.kumar@linux.ibm.com, sbhat@linux.ibm.com, vaibhav@linux.ibm.com,
        dan.j.williams@intel.com, ira.weiny@intel.com,
        vishal.l.verma@intel.com
Date: Tue, 07 Sep 2021 13:58:38 +0000
Message-ID: <163102311841.258999.14260383111577082134.stgit@99912bbcb4c7>
User-Agent: StGit/1.1+40.g1b20
Content-Type: text/plain; charset="utf-8"
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: poSr6k2kos1-GF-_nQGgZ349udte5kbI
X-Proofpoint-ORIG-GUID: poSr6k2kos1-GF-_nQGgZ349udte5kbI
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-09-07_04:2021-09-07,2021-09-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 mlxlogscore=999 impostorscore=0 lowpriorityscore=0 priorityscore=1501
 clxscore=1015 mlxscore=0 phishscore=0 adultscore=0 bulkscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2108310000 definitions=main-2109070089

From: Vaibhav Jain <vaibhav@linux.ibm.com>

Changes since v1:
Link: https://patchwork.kernel.org/project/linux-nvdimm/cover/20210712173132.1205192-1-vaibhav@linux.ibm.com/
* Minor update to patch description
* The changes are based on the new kernel patch [1]

The patch series implements limited support for injecting smart errors for PAPR
NVDIMMs via ndctl-inject-smart(1) command. SMART errors are emulating in
papr_scm module as presently PAPR doesn't support injecting smart errors on an
NVDIMM. Currently support for injecting 'fatal' health state and 'dirty'
shutdown state is implemented. With the proposed ndctl patched and with
corresponding kernel patch [1] following command flow is expected:

$ sudo ndctl list -DH -d nmem0
...
      "health_state":"ok",
      "shutdown_state":"clean",
...
 # inject unsafe shutdown and fatal health error
$ sudo ndctl inject-smart nmem0 -Uf
...
      "health_state":"fatal",
      "shutdown_state":"dirty",
...
 # uninject all errors
$ sudo ndctl inject-smart nmem0 -N
...
      "health_state":"ok",
      "shutdown_state":"clean",
...

Structure of the patch series
=============================

* First patch updates 'inject-smart' code to not always assume support for
  injecting all smart-errors. It also updates 'intel.c' to explicitly indicate
  the type of smart-inject errors supported.

* Update 'papr.c' to add support for injecting smart 'fatal' health and
  'dirty-shutdown' errors.

[1] : https://patchwork.kernel.org/project/linux-nvdimm/patch/163091917031.334.16212158243308361834.stgit@82313cf9f602/
---

Vaibhav Jain (2):
      libndctl, intel: Indicate supported smart-inject types
      libndctl/papr: Add limited support for inject-smart


 ndctl/inject-smart.c  | 33 ++++++++++++++++++-----
 ndctl/lib/intel.c     |  7 ++++-
 ndctl/lib/papr.c      | 61 +++++++++++++++++++++++++++++++++++++++++++
 ndctl/lib/papr_pdsm.h | 17 ++++++++++++
 ndctl/libndctl.h      |  8 ++++++
 5 files changed, 118 insertions(+), 8 deletions(-)

--
Signature



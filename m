Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B75D2C8B
	for <nvdimm@lists.linux.dev>; Fri, 22 Oct 2021 14:56:59 +0000 (UTC)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
	by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19MD03Ee024202;
	Fri, 22 Oct 2021 10:56:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : from : to : cc
 : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=pp1; bh=62/2opQBQnSIpwKuf5ueIxmXWHdx95UlecFJ1KUK8vU=;
 b=h4f8vVjsz92eOpLVNhALcpH68byGIN4IHZht4gfObOCiaMwz1NyEm0YF6sl93uNq0wKj
 dPHiq7n6r9vY/HT/t7z8qGKXYEJHySAzeeyGIiQF8/SsAkaUEAclQ+K1k6c9B1HMszT+
 D1qbk7DPfOIqBE1qIPzZrwvHoAPeL//dT0VKU4W33HcixgkgZUfZWGKy+UXZ/28zNpPi
 4CTcDWO/QW2WwsbzhYNycJUobW+4JAuSN7AvkYGEcmzVB4TRXHJOxj79DPtaqLNBIabD
 bNstSF0MQmj9pXqaq2ZAOHli+jc2/XjDOSzU2fJmD9H4QilW0WlOJWWbYYRH2HFS7IVW fw== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
	by mx0b-001b2d01.pphosted.com with ESMTP id 3buue0nfpa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 22 Oct 2021 10:56:57 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
	by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19MEqUvv009673;
	Fri, 22 Oct 2021 14:56:55 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
	by ppma04ams.nl.ibm.com with ESMTP id 3bqpcbhhe5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 22 Oct 2021 14:56:55 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
	by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19MEorKT64160120
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 22 Oct 2021 14:50:53 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 18CD24C04E;
	Fri, 22 Oct 2021 14:56:52 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0C8A34C044;
	Fri, 22 Oct 2021 14:56:51 +0000 (GMT)
Received: from lep8c.aus.stglabs.ibm.com (unknown [9.40.192.207])
	by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
	Fri, 22 Oct 2021 14:56:50 +0000 (GMT)
Subject: [REPOST PATCH v2 0/2] papr: Implement initial support for injecting
 smart errors
From: Shivaprasad G Bhat <sbhat@linux.ibm.com>
To: nvdimm@lists.linux.dev
Cc: aneesh.kumar@linux.ibm.com, sbhat@linux.ibm.com, vaibhav@linux.ibm.com,
        dan.j.williams@intel.com, ira.weiny@intel.com,
        vishal.l.verma@intel.com
Date: Fri, 22 Oct 2021 09:56:50 -0500
Message-ID: 
 <163491461011.1641479.7752723100626280911.stgit@lep8c.aus.stglabs.ibm.com>
User-Agent: StGit/1.1+40.g1b20
Content-Type: text/plain; charset="utf-8"
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: AJq96eJOVsdIwxGnYEFotCyZwzhuPDMv
X-Proofpoint-ORIG-GUID: AJq96eJOVsdIwxGnYEFotCyZwzhuPDMv
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
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 lowpriorityscore=0 priorityscore=1501 adultscore=0 spamscore=0
 mlxlogscore=920 suspectscore=0 bulkscore=0 malwarescore=0 phishscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110220083

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



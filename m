Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77D9517F
	for <nvdimm@lists.linux.dev>; Mon, 12 Jul 2021 17:31:46 +0000 (UTC)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16CH4Col166904;
	Mon, 12 Jul 2021 13:31:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=d+NPXPrxjxURNm5T6ThGOr0CJwOEjhMApSpRG5jma3s=;
 b=J1pn2uM3VGCvCwbYJO8EVr1LY3EyrGYdEXvZsUoYuhYvZUw/eIaW1+0aqQu/aMWfur0Q
 iAHGIbi/BpGcZBISdb4EdN2Usu/dWiOjEOC9ffMEWUmYfjN+a3qLNQ2HnEcd4yrS02X7
 ZzM5bf79NiWo1oAMkruuyxkrY9RWxj15a0xTMk0ukOpYc0lDehumTRsbd0Z7CxcuFKPQ
 RHeeBpzDEtSGUNigWfGytpXSOV7BU6/Ud9MzRmDYNFAdXyAj2Mwd1j1cjSKaSPF44Kn+
 sMP0IH+TeFeJjlwowSwC7mYxytBDVulk2qymzOxLk5rQ059MB+YaetBjICdy2hJ/qdJk 9w== 
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
	by mx0a-001b2d01.pphosted.com with ESMTP id 39qs2v9a9n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 12 Jul 2021 13:31:42 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
	by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16CHVe9w008341;
	Mon, 12 Jul 2021 17:31:40 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
	by ppma04fra.de.ibm.com with ESMTP id 39q368gfh6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 12 Jul 2021 17:31:40 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
	by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16CHVanA33620388
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 12 Jul 2021 17:31:36 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7B9DE11C069;
	Mon, 12 Jul 2021 17:31:36 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 101C611C05E;
	Mon, 12 Jul 2021 17:31:34 +0000 (GMT)
Received: from vajain21.in.ibm.com (unknown [9.85.98.133])
	by d06av25.portsmouth.uk.ibm.com (Postfix) with SMTP;
	Mon, 12 Jul 2021 17:31:33 +0000 (GMT)
Received: by vajain21.in.ibm.com (sSMTP sendmail emulation); Mon, 12 Jul 2021 23:01:33 +0530
From: Vaibhav Jain <vaibhav@linux.ibm.com>
To: nvdimm@lists.linux.dev
Cc: Vaibhav Jain <vaibhav@linux.ibm.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Ira Weiny <ira.weiny@intel.com>,
        Shivaprasad G Bhat <sbhat@linux.ibm.com>
Subject: [ndctl PATCH 0/2] papr: Implement initial support for injecting smart errors
Date: Mon, 12 Jul 2021 23:01:30 +0530
Message-Id: <20210712173132.1205192-1-vaibhav@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Vu8zLfmIt2CoMnaqyyTdHXIvQCgSpLIM
X-Proofpoint-GUID: Vu8zLfmIt2CoMnaqyyTdHXIvQCgSpLIM
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-12_09:2021-07-12,2021-07-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 malwarescore=0 impostorscore=0 bulkscore=0 phishscore=0
 suspectscore=0 mlxscore=0 adultscore=0 priorityscore=1501 spamscore=0
 mlxlogscore=927 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107120126

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
2.31.1


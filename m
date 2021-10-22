Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F20E272
	for <nvdimm@lists.linux.dev>; Fri, 22 Oct 2021 17:48:02 +0000 (UTC)
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
	by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19MFEaT7001063;
	Fri, 22 Oct 2021 13:48:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : from : to : cc
 : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=b2V2wcDU65RED1OelQ+XajOZAmLDefrZ082+h5fwr10=;
 b=ipDbF3+WKpvba7vMTd+JyyaYo4d4AjI26w31Cfj87BsLvl+JGeY5biwKYsv4ToNmEAU+
 WIaERRl1wVyiMYzk486wkkLoXimWKPxbY6KfT3hcuFW4nMsizrRf4Ky1PW3g9Ftb1SNS
 kamdA3ZCFFhqPiopBdW3zW8JkonTRkiUHQxdJMidEoG97mMWWKxgrAdj0SWWxSgbeI1g
 mGklLnV57iezeTEU21xlzhLyNx1fIxAxgWsQd+LkVdCxAsitqq1ZXKQCJSsRmuV59Qbg
 Ma0E6XxEBTF5daqLsl1bSspotFYJSxqW6iu4z8HQXHENzFv/v9Ojkn7MW2c1495pAW0c xg== 
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
	by mx0b-001b2d01.pphosted.com with ESMTP id 3bux2854s2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 22 Oct 2021 13:48:00 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
	by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19MHlsq9012082;
	Fri, 22 Oct 2021 17:47:59 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
	by ppma04fra.de.ibm.com with ESMTP id 3bqpccey83-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 22 Oct 2021 17:47:58 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
	by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19MHfxDq54723032
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 22 Oct 2021 17:41:59 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 89B0252051;
	Fri, 22 Oct 2021 17:47:55 +0000 (GMT)
Received: from lep8c.aus.stglabs.ibm.com (unknown [9.40.192.207])
	by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 845095204F;
	Fri, 22 Oct 2021 17:47:54 +0000 (GMT)
Subject: [REPOST PATCH v2 3/3] test/monitor.sh: Partially skip monitor test on
 ndtest
From: Shivaprasad G Bhat <sbhat@linux.ibm.com>
To: nvdimm@lists.linux.dev
Cc: aneesh.kumar@linux.ibm.com, sbhat@linux.ibm.com, vaibhav@linux.ibm.com,
        dan.j.williams@intel.com, ira.weiny@intel.com,
        vishal.l.verma@intel.com
Date: Fri, 22 Oct 2021 12:47:53 -0500
Message-ID: 
 <163492485552.1652625.8655154350414191971.stgit@lep8c.aus.stglabs.ibm.com>
In-Reply-To: 
 <163492481743.1652625.4203942321686969839.stgit@lep8c.aus.stglabs.ibm.com>
References: 
 <163492481743.1652625.4203942321686969839.stgit@lep8c.aus.stglabs.ibm.com>
User-Agent: StGit/1.1+40.g1b20
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: moIQ-_srQ_OD-PYnRFMqZCl45H_-cWDk
X-Proofpoint-ORIG-GUID: moIQ-_srQ_OD-PYnRFMqZCl45H_-cWDk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-22_04,2021-10-22_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 priorityscore=1501 impostorscore=0 mlxscore=0 malwarescore=0 phishscore=0
 adultscore=0 spamscore=0 bulkscore=0 clxscore=1015 lowpriorityscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110220101

The ndtest/papr pdsm has the unclean shutdown inject support.
Rest of the tests in monitor.sh are injecting temperature,
spares with thresholds and monitoring on them. These test cases
are irrelavent on papr, skip them.

Its convenient/cleaner to reorder the tests than selectively
adding test environment checks for each of the tests. So,
reordering to call the dimm events test first.

Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
---
 test/monitor.sh |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/test/monitor.sh b/test/monitor.sh
index 28c55415..b78ed093 100755
--- a/test/monitor.sh
+++ b/test/monitor.sh
@@ -143,6 +143,10 @@ test_filter_dimmevent()
 	check_result "$monitor_dimms"
 	stop_monitor
 
+	if [ $NDCTL_TEST_FAMILY == "PAPR" ]; then
+		return
+	fi
+
 	inject_value=$($NDCTL list -H -d $monitor_dimms | jq -r .[]."health"."spares_threshold")
 	inject_value=$((inject_value - 1))
 	start_monitor "-d $monitor_dimms -D dimm-spares-remaining"
@@ -160,12 +164,17 @@ test_filter_dimmevent()
 
 do_tests()
 {
+	test_filter_dimmevent
+
+	if [ $NDCTL_TEST_FAMILY == "PAPR" ]; then
+		return
+	fi
+
 	test_filter_dimm
 	test_filter_bus
 	test_filter_region
 	test_filter_namespace
 	test_conf_file
-	test_filter_dimmevent
 }
 
 modprobe nfit_test



Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AA3C7F
	for <nvdimm@lists.linux.dev>; Tue, 13 Sep 2022 10:26:39 +0000 (UTC)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28DA9CfT005965;
	Tue, 13 Sep 2022 10:26:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : reply-to : to : cc : date : in-reply-to : references : content-type
 : mime-version : content-transfer-encoding; s=pp1;
 bh=7gltwm/9IDBjgB3hqSJXmIHXH+c6SVFWA4edaNOdYtY=;
 b=gSyXeG2wHzVG0p5VCHApomSt9wNmJH1Juna6J9rGi5QivQDpduZecwaj4Y7ysLqADmES
 HKkhWZoMoGp7wgHuXMupRFwJyPEwQsVnO/jAuWsPtTjwYpCPil4TrQErYgcyMrocgiS8
 2mdwqqoIY6pNSzUd43SuRFu/PUTVspahY8PQBnVBG8/r5jzouKgG+wfmMhkuuZTVNkqT
 YjCH+YoDJSHCb/XAqZrjQYk0JJEpZ7ScR1CFsYcunbRZQMDFmRfYl8ecCPXMW+thAEWZ
 aKQeflUpfLGOKhJQxsruQQZFiCFN0jFiA5ASRd6T2PXlEpjpQ0S+pJ8QlZK4eFnmdtRp 0w== 
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jjq7a1r2y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 13 Sep 2022 10:26:16 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
	by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 28DAKxbb028368;
	Tue, 13 Sep 2022 10:26:14 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
	by ppma04fra.de.ibm.com with ESMTP id 3jgj78tps4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 13 Sep 2022 10:26:14 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
	by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 28DAMS6A15270194
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Sep 2022 10:22:28 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 544F352051;
	Tue, 13 Sep 2022 10:26:11 +0000 (GMT)
Received: from tarunpc (unknown [9.43.126.220])
	by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id CB23352050;
	Tue, 13 Sep 2022 10:26:07 +0000 (GMT)
Message-ID: <e9bb18bae97df6cb574070533198adfb4553c44b.camel@linux.ibm.com>
Subject: Re: [PATCH v4 0/2]ndctl/namespace: Fix and improve write-infoblock
From: Tarun Sahu <tsahu@linux.ibm.com>
Reply-To: tsahu@linux.ibm.com
To: "Verma, Vishal L" <vishal.l.verma@intel.com>,
        "nvdimm@lists.linux.dev"
	 <nvdimm@lists.linux.dev>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>,
        "aneesh.kumar@linux.ibm.com" <aneesh.kumar@linux.ibm.com>,
        "sbhat@linux.ibm.com" <sbhat@linux.ibm.com>,
        "vaibhav@linux.ibm.com"
 <vaibhav@linux.ibm.com>
Date: Tue, 13 Sep 2022 15:56:05 +0530
In-Reply-To: <0ac88f93980f0da33939178abb16aab0a9d907cc.camel@intel.com>
References: <20220527103021.452651-1-tsahu@linux.ibm.com>
	 <0ac88f93980f0da33939178abb16aab0a9d907cc.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 0mGplCZ5BgAICtmBExNmgSP9n-jCUPmz
X-Proofpoint-GUID: 0mGplCZ5BgAICtmBExNmgSP9n-jCUPmz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-13_03,2022-09-13_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 mlxscore=0
 lowpriorityscore=0 phishscore=0 priorityscore=1501 spamscore=0
 adultscore=0 impostorscore=0 suspectscore=0 bulkscore=0 mlxlogscore=817
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209130045

Hi,

> Hi Tarun,
> 
> Sorry for the delay in reviewing these. From a quick look, it looks
> like you're adding read-modify-write functionality to the write-
> infoblock command - is that correct?
> 
> I think the original intent of these commands was, purely as a
> debug/test aid, that the user would be responsible for reading the
> namespace if needed, and using that as a basis for writing the
> infoblockl if an RMW operation is desired. However for the most part,
> write-infoblock just creates infoblocks out of thin air, and
> optionally
> writes it to a namepspace. I'm not sure adding a read-modify-write
> here
> is really that useful, unless you have a specific use case for this
> sort of thing?

From the man page, it is not clear that, non-provided args values will
get updated without user concern, and It comes as surprise to user as
user didnt intend to change that. For Example, If user only want to
change the value of uuid of a namespace infoblock, So They perform
write-infoblock with particular uuid but didnt pass align value which
they intended not to change but write-infoblock changes it to default
value.

This patch, read-modify-write takes care of other arguments which are
not passed for the concerned namespace as part of write-infoblock by
retaining the values of them.

Other patch of this series, takes
advantage of the above read-modify-write functionality and implement
write-infoblock for sector/BTT namespaces. Which currently allows only
uuid and parent_uuid updates.



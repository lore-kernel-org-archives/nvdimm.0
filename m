Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E04E62100
	for <nvdimm@lists.linux.dev>; Fri, 13 May 2022 07:32:02 +0000 (UTC)
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24D71b1a019878;
	Fri, 13 May 2022 07:07:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : reply-to : to : cc : date : in-reply-to : references : content-type
 : mime-version : content-transfer-encoding; s=pp1;
 bh=5usIPu5pwRStczuoOQfXqmsS+n4fNI0SeK/d+jMIO+g=;
 b=rRX+WIzPIyHKcXDp5kxqLorzkHZgDQ3r7l+4OfAgGfdHfWxNRjWg5Nj4iAyZ1GjlzfJg
 oSp88wJs3wuksgo414ii8xzLt7/yo1sOXgAyNDPO3vZepr+OKSIXdZtSqrn1T9RNwGCr
 oVP/NYAue0lJxJSw94oPjIoG72n6wWuWgwGHID0W2AupolnFjQjv5fTyvD0TdV7wPs/i
 CKX7aKqEieLAZz+pG+C2bttT/25nJ3RALdcGc8JjgKurQ3t07pY3LN53Qd9oWGN5xzRZ
 NWZI20Ek/qbrWPJyQ4oOgqV73AkAk+1E5z13cW8h1h8qQrWQC3u3yBXVzJqK4fuaMXow FA== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g1jk2g3fk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 13 May 2022 07:07:41 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
	by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24D70s1p015763;
	Fri, 13 May 2022 07:07:39 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
	by ppma03ams.nl.ibm.com with ESMTP id 3fwgd904ys-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 13 May 2022 07:07:38 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
	by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24D77ZMH27787722
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 May 2022 07:07:35 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 99BECA405C;
	Fri, 13 May 2022 07:07:35 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9351FA405B;
	Fri, 13 May 2022 07:07:33 +0000 (GMT)
Received: from li-efb8054c-3504-11b2-a85c-ca10df28279e.ibm.com (unknown [9.43.42.168])
	by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
	Fri, 13 May 2022 07:07:33 +0000 (GMT)
Message-ID: <af7c22c28e0ebe16a74f3bf0e0e136b11ca774fb.camel@linux.ibm.com>
Subject: Re: [PATCH v3 0/2] ndctl/namespace:Fix and improve write-infoblock
From: Tarun Sahu <tsahu@linux.ibm.com>
Reply-To: tsahu@linux.ibm.com
To: nvdimm@lists.linux.dev
Cc: dan.j.williams@intel.com, vishal.l.verma@intel.com,
        aneesh.kumar@linux.ibm.com, sbhat@linux.ibm.com, vaibhav@linux.ibm.com
Date: Fri, 13 May 2022 12:37:32 +0530
In-Reply-To: <20220426172056.122789-1-tsahu@linux.ibm.com>
References: <20220426172056.122789-1-tsahu@linux.ibm.com>
Organization: IBM
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: S8OpIb399sUIsPIM-ETFn1APBxjPZT3z
X-Proofpoint-ORIG-GUID: S8OpIb399sUIsPIM-ETFn1APBxjPZT3z
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-13_02,2022-05-12_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 malwarescore=0 spamscore=0 lowpriorityscore=0 bulkscore=0
 adultscore=0 clxscore=1015 mlxscore=0 phishscore=0 mlxlogscore=557
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205130029

Hi,

Just a gentle reminder, Kindly Let me know if any changes are needed in
this patchset.

Thank you,
Tarun


On Tue, 2022-04-26 at 22:50 +0530, Tarun Sahu wrote:
> This series resolves some issues with write-infoblock 
> command and provide support to write-infoblock for sector 
> mode namespace
> 
> write-infoblock command has issues regarding updating the 
> align, uuid, parent_uuid. In case of no parameter passed 
> for it, this command used to overwrite the existing values 
> with defaults.
> 
> In PATCH 1/2 these parameters will be set to their original 
> values, incase, values hasn't been passed in command 
> arguments
> 
> write-infoblock command doesn't have support for sector/BTT 
> mode namespaces. They can be converted to fsdax, but can 
> not be written being in sector mode.
> 
> In PATCH 2/2, It creates a functionality which write 
> infoblock of Sector/BTT namespace. Currently only uuid, 
> parent_uuid can be updated. In future, Support for other 
> parameters can easily be integrated in the
> functionality.
> 
> ---
> v2:
>   Updated the commit message (rephrasing) in patch 1/2
>   Moved the ns_info struct to namespace.c from namespace.h
>   put the results after --- to avoid long commit message
> 
> v3:
>   reformat the commit message to meet 100 column condition
> 
> Tarun-Sahu (2):
>   ndctl/namespace:Fix multiple issues with write-infoblock
>   ndctl/namespace:Implement write-infoblock for sector mode
> namespaces
> 
>  ndctl/namespace.c | 308 +++++++++++++++++++++++++++++++++-----------
> --
>  1 file changed, 225 insertions(+), 83 deletions(-)
> 


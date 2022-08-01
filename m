Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44C4D7F
	for <nvdimm@lists.linux.dev>; Mon,  1 Aug 2022 07:50:28 +0000 (UTC)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2717J05V024006;
	Mon, 1 Aug 2022 07:50:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : reply-to : to : cc : date : in-reply-to : references : content-type
 : mime-version : content-transfer-encoding; s=pp1;
 bh=MIJ45yiUnbk+1uvNi8T0LctlPDu2oxANjRMFSGOXj/I=;
 b=bRpwRzyUnpxIdc09Q+V2eZk8DdNv4AD97p+v9wRievGTITehb2M+XiApa/XABw3Yy2+z
 ICc3V5X6gmRFibCX1GKAI8vQZwu4GS3pxjmaMgfcu0FXS1GTDledZKZ8eunle1EOIv9V
 1VlR/0+NWtttUHFVqq3C1hithtWLxp3tSTAFg7/Vc/ljUapWXI3YqmYI5lRY+xD540kq
 W9vIRtbS0ROlNjMJIjIqbAnE+kFc7N/400um5GmZHqpSsxOsk4/QDCg9UWKpYuw26FSR
 WuXKBNY26w+SNKC15Gc9RDz5DuMHDt4DtVVsiPyRNm2vjBlvmXZTyfz4n5WXTRgfuTTT ug== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hp847d00q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Aug 2022 07:50:20 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
	by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2717Lh7I020045;
	Mon, 1 Aug 2022 07:50:18 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
	by ppma04ams.nl.ibm.com with ESMTP id 3hmv98hvs2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Aug 2022 07:50:17 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
	by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2717oEGp22610264
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 1 Aug 2022 07:50:14 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B8A4E5204E;
	Mon,  1 Aug 2022 07:50:14 +0000 (GMT)
Received: from li-efb8054c-3504-11b2-a85c-ca10df28279e.ibm.com (unknown [9.43.79.109])
	by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id AD55852051;
	Mon,  1 Aug 2022 07:50:11 +0000 (GMT)
Message-ID: <470ec99b8222dc5676a53cdb7dc5e19913221894.camel@linux.ibm.com>
Subject: Re: [PATCH v4 0/2]ndctl/namespace: Fix and improve write-infoblock
From: Tarun Sahu <tsahu@linux.ibm.com>
Reply-To: tsahu@linux.ibm.com
To: nvdimm@lists.linux.dev
Cc: dan.j.williams@intel.com, vishal.l.verma@intel.com,
        aneesh.kumar@linux.ibm.com, sbhat@linux.ibm.com, vaibhav@linux.ibm.com
Date: Mon, 01 Aug 2022 13:20:09 +0530
In-Reply-To: <20220527103021.452651-1-tsahu@linux.ibm.com>
References: <20220527103021.452651-1-tsahu@linux.ibm.com>
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
X-Proofpoint-GUID: Ed1nEVXAlGMNDHxbZhSCOShq19wYC2Ku
X-Proofpoint-ORIG-GUID: Ed1nEVXAlGMNDHxbZhSCOShq19wYC2Ku
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-01_03,2022-07-28_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 priorityscore=1501 mlxlogscore=847 suspectscore=0 adultscore=0
 spamscore=0 impostorscore=0 clxscore=1011 mlxscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2208010035

Hi, 

Just a gentle reminder. May you please look into these patches.
Please let me know if any changes are required.

Thanks
Tarun


On Fri, 2022-05-27 at 16:00 +0530, Tarun Sahu wrote:
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
> v4:
>   - Moved the struct ns_info definition to the beginning of
>   the block 
>   - Initialized the buf of ns_info structure in ns_info_init
>   - Change the format of comment in code from "//" to "/**/"
>   - reword the commit message of patch 2/2
> 
> Tarun Sahu (2):
>   ndctl/namespace: Fix multiple issues with write-infoblock
>   ndctl/namespace: Implement write-infoblock for sector mode
> namespaces
> 
>  ndctl/namespace.c | 314 ++++++++++++++++++++++++++++++++++----------
> --
>  1 file changed, 231 insertions(+), 83 deletions(-)
> 


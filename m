Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80B6084DE7;
	Mon, 10 Jun 2024 14:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718028230; cv=none; b=rqEVnnptM+WhlsheU/VsQx0e/RZDxVvgQSx3QxH0NvSN+7vwZ9aPbEPxsjjlNR9TLKDHUzJNXNWcDCG7Z69l7+D/HPz/XUTwXF2j23fCcsgPPW4q8+XqGYLP2I7ED48PzyJp/xq5cQsLT8/0bZtWf2Ve5jLF5u4O4lcQN/2WaXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718028230; c=relaxed/simple;
	bh=en/b4B2m0bS4AIKpzZ62en2PDTKoDle7YefUFrHhWK8=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=pBXkyb8J1xidGgbhTy2DiFZnuFw4S6ybta+n79IfLpLP1abPyUeKBP9J3PLn4CisOx5G/Czd5I2RW0HS9/gDrX2YjK+7XgXI5iszI+rkHj2KgWZEaUPuxTQPYJa4Zth+Tq8VY+Xrc4wDCkacOtItgURw6MDy/l/DDCLVf6h4J4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=aseErW4D; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="aseErW4D"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45A007X0005752;
	Mon, 10 Jun 2024 14:03:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	9ui7K6c1TFM4qAOoMEcObMwQOrPa+CdhoIX2EmgCBQI=; b=aseErW4DBwTn4fNg
	g5xen3Qy8XLgTq8pFgVlxa60NnrybQqlYYJ9bGRhDOlVDjxmzt03mLFUhe2vSdqj
	pK/IntOsrz7cowzwjPCD9+9xO1hld8Dz9+OyUvBSMhM5F8PbUaW3YURAaMONo6AP
	W+j6KH88opXr2Ckgrvyz0lol26OFiHrEaQlRHrQieOQk1aQMxNeLHENvvbWpw9+h
	ck9YPPIXqqabzAaUIlaxATaZmnJODehJ1HkYxoXxgxpCO7kyda9BiZHyJSG/Ndrk
	gXVIjYlwlXOaRwsxRzV7uTbfTpBgNgvqVAPIQ9cxkjGhNxh3uxwPMfOVbsJeIr29
	umwDug==
Received: from nalasppmta02.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3ymd0ec8da-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 10 Jun 2024 14:03:39 +0000 (GMT)
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA02.qualcomm.com (8.17.1.19/8.17.1.19) with ESMTPS id 45AE3cZf008592
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 10 Jun 2024 14:03:38 GMT
Received: from [10.48.242.196] (10.49.16.6) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Mon, 10 Jun
 2024 07:03:38 -0700
Message-ID: <0dcef87c-e5e0-4298-bf83-1794bbbc60ed@quicinc.com>
Date: Mon, 10 Jun 2024 07:03:36 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND] nvdimm: add missing MODULE_DESCRIPTION() macros
Content-Language: en-US
To: Ira Weiny <ira.weiny@intel.com>, Vishal Verma <vishal.l.verma@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
        Oliver O'Halloran
	<oohall@gmail.com>
CC: <nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
        <virtualization@lists.linux.dev>, <kernel-janitors@vger.kernel.org>
References: <20240526-md-drivers-nvdimm-v1-1-9e583677e80f@quicinc.com>
 <6667067e7e152_1700b5294ed@iweiny-mobl.notmuch>
From: Jeff Johnson <quic_jjohnson@quicinc.com>
In-Reply-To: <6667067e7e152_1700b5294ed@iweiny-mobl.notmuch>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: nalasex01b.na.qualcomm.com (10.47.209.197) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: 8uMlKcmwmExDFwKQnRukTvNSsFyjlamy
X-Proofpoint-ORIG-GUID: 8uMlKcmwmExDFwKQnRukTvNSsFyjlamy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-10_02,2024-06-10_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=999
 lowpriorityscore=0 priorityscore=1501 malwarescore=0 suspectscore=0
 adultscore=0 spamscore=0 mlxscore=0 clxscore=1015 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2405170001 definitions=main-2406100107

On 6/10/2024 6:58 AM, Ira Weiny wrote:
> Jeff Johnson wrote:
>> Fix the 'make W=1' warnings:
>> WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/nvdimm/libnvdimm.o
>> WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/nvdimm/nd_pmem.o
>> WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/nvdimm/nd_btt.o
>> WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/nvdimm/nd_e820.o
>> WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/nvdimm/of_pmem.o
>> WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/nvdimm/nd_virtio.o
> 
> Just to double check.  This is a resend of this patch?
> 
> https://lore.kernel.org/all/20240526-md-drivers-nvdimm-v1-1-172e682e76bd@quicinc.com/
> 
> Dave Jiang, I'm picking up all these for the nvdimm tree and I think there
> were a couple I was not CC'ed on.  I'll coordinate with you because I'm
> still seeing a couple of these warnings on other modules in the test
> build.
> 
> Also I want to double check all the descriptions before I send for 6.11.
> 
> Jeff is it ok if I alter the text?  I know you mentioned to Jonathan you
> really just wanted to see the errors go away.

Yes, please make the text whatever makes the most sense. In most of these
cases I'm not a domain expert so I construct these descriptions based upon
code comments, Kconfig descriptions, and git descriptions, and in some cases
these are originally wrong due to cut-n-paste or the drivers have evolved so
that information is no longer accurate.

I need to add a version of that to my b4 cover letter!

/jeff

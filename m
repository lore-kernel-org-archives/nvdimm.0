Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA85D23769;
	Wed, 12 Jun 2024 04:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718168177; cv=none; b=L32O1snr5q5vLl2/qsLZAzNrbkv2omHe76vM2m6JkYaD5YwM99ltjhlilg3d2O1R3NncAs3lBuq6G+2KcD69VrgH3JfkPsc7E8sRRi4gYlp8RZsbHUcNutXZBCNfuAwXv9fkN3KW9Ee5+9VqheOR+WWVwRK7E+8G/iG0KmIiG0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718168177; c=relaxed/simple;
	bh=MJ3QtkZdmdztL9XRak9rJ1Pw1Wj0QsCVyqcsa/Y1aSI=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=WYUluU+80vxoMzJudcRarPJdHVMpTzpk7pj3FDhOBM6SbhU89nQ8oNduxVsBRwdQSObls4gg6whJdICcoDgjFWZbnhkDRxCcf+cRzcvHKpr2TeykyIAuN9jZ7Liysf4Aaq+iHU5XDCJD6y+jtlMl1iHQJdFmjW8osdTE0Uf3iEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=b2UJ0Q1W; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="b2UJ0Q1W"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45C3hvOX028937;
	Wed, 12 Jun 2024 04:55:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	FuCPHn06DpJEIDAOSiCZ16q2gYXySz1iDLd3Nch72gg=; b=b2UJ0Q1WRhINTEXA
	iMzoWN3kdNQtfnKiZWby1PJjf2Vykh14P8dqsIzGicMBbWDjcc/1cS7/WXjgchXi
	jLsZIT+/Xxya02gjrPgjOizW8lRL1qv1f99tYL+DqkXOJqLYwBPDZC9jONStYhmh
	1Ca5g55zh2m3YNH30WM4gIGjiYW3DmRGt7Pe7RJTCr3vkjBWJQ2BT/vkLulEZr5N
	T0uug3ZBzfu7if5UbPE+A9GcBhaLFO+AqPHDXX4emDiXrZJMa9TNS5VYAA3AZyFj
	RbrPx2zHoc8WT3zk001RarXWNICVDl4Hk/8SL26Kh3/NGZaJjjuDQGYom+ZSmE9F
	3hdisA==
Received: from nalasppmta03.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3ymfp7fwtk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 12 Jun 2024 04:55:56 +0000 (GMT)
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA03.qualcomm.com (8.17.1.19/8.17.1.19) with ESMTPS id 45C4tsUK030931
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 12 Jun 2024 04:55:54 GMT
Received: from [10.48.243.20] (10.49.16.6) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Tue, 11 Jun
 2024 21:55:54 -0700
Message-ID: <813a0c3b-f923-463d-b502-3897d5213180@quicinc.com>
Date: Tue, 11 Jun 2024 21:55:53 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] testing: nvdimm: Add MODULE_DESCRIPTION() macros
Content-Language: en-US
To: Ira Weiny <ira.weiny@intel.com>, <nvdimm@lists.linux.dev>
CC: Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma
	<vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>, <linux-kernel@vger.kernel.org>
References: <20240611-nvdimm-test-mod-warn-v1-1-4a583be68c17@intel.com>
From: Jeff Johnson <quic_jjohnson@quicinc.com>
In-Reply-To: <20240611-nvdimm-test-mod-warn-v1-1-4a583be68c17@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: nalasex01a.na.qualcomm.com (10.47.209.196) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: JVNi9jXRkgXYI7wQ-qkWtlnMq1m4OYv8
X-Proofpoint-ORIG-GUID: JVNi9jXRkgXYI7wQ-qkWtlnMq1m4OYv8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-12_01,2024-06-11_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 adultscore=0 spamscore=0 phishscore=0
 priorityscore=1501 clxscore=1015 bulkscore=0 impostorscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2405170001 definitions=main-2406120032

On 6/11/2024 9:47 PM, Ira Weiny wrote:
> When building with W=1 the following errors are seen:
> 
> WARNING: modpost: missing MODULE_DESCRIPTION() in tools/testing/nvdimm/test/nfit_test.o
> WARNING: modpost: missing MODULE_DESCRIPTION() in tools/testing/nvdimm/test/ndtest.o
> 
> Add the required MODULE_DESCRIPTION() to the test platform device
> drivers.
> 
> Suggested-by: Jeff Johnson <quic_jjohnson@quicinc.com>
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> ---
> Jeff I'm not seeing a patch to cover these cases for the missing module
> descriptions you have been sending out.  If you have an outstanding
> patch I missed could you point me to it?  Otherwise I believe this
> cleans up the nvdimm tree.
> ---
>  tools/testing/nvdimm/test/ndtest.c | 1 +
>  tools/testing/nvdimm/test/nfit.c   | 1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/tools/testing/nvdimm/test/ndtest.c b/tools/testing/nvdimm/test/ndtest.c
> index b438f3d053ee..892e990c034a 100644
> --- a/tools/testing/nvdimm/test/ndtest.c
> +++ b/tools/testing/nvdimm/test/ndtest.c
> @@ -987,5 +987,6 @@ static __exit void ndtest_exit(void)
>  
>  module_init(ndtest_init);
>  module_exit(ndtest_exit);
> +MODULE_DESCRIPTION("Test non-NFIT devices");
>  MODULE_LICENSE("GPL");
>  MODULE_AUTHOR("IBM Corporation");
> diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
> index a61df347a33d..cfd4378e2129 100644
> --- a/tools/testing/nvdimm/test/nfit.c
> +++ b/tools/testing/nvdimm/test/nfit.c
> @@ -3382,5 +3382,6 @@ static __exit void nfit_test_exit(void)
>  
>  module_init(nfit_test_init);
>  module_exit(nfit_test_exit);
> +MODULE_DESCRIPTION("Test ACPI NFIT devices");
>  MODULE_LICENSE("GPL v2");
>  MODULE_AUTHOR("Intel Corporation");
> 
> ---
> base-commit: 2df0193e62cf887f373995fb8a91068562784adc
> change-id: 20240611-nvdimm-test-mod-warn-8cf773360b37
> 
> Best regards,

Not on my radar, so thanks for fixing!

Reviewed-by: Jeff Johnson <quic_jjohnson@quicinc.com>


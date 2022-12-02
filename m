Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6B8A7B
	for <nvdimm@lists.linux.dev>; Fri,  2 Dec 2022 11:30:57 +0000 (UTC)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
	by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B2A1gqL027540;
	Fri, 2 Dec 2022 11:30:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=bXnrN96716jI50ZykIoGWceX50TUjGnbm+DdSyDwJek=;
 b=S7L4JLPwsD3WpD0B+FxO4jX2sT+Hk+/kWDXCqc5HbcR3KwCIBxk93B4BN5YPkqAFJeh5
 l6TTYw4OQxZSNEdonObTzwT9/1ss0wOeDYYngRpiHlziU5M/Nq6rQB6+3MJaycvca09Z
 9sUsHZ/kVVUo8PgKjtk/sFJlsQucyS8C5fkqFnlp1bdpq7wIhs1MBj+5JgznWaaq/pU0
 Rb6Svd+QfEoBx+nbJfwOv7TPAKBUDCx5LhgvyXgeLGgoWutzmVuKp/2AkZ8xRAESozwX
 olC5RMnxdB6Vz7SY9a339vd10kqvBj6UMJEudA4FUegSFV6Zfcj5x+vJN0CMosezM8uh NQ== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
	by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3m7f8gswqc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 02 Dec 2022 11:30:39 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
	by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2B2BLUuE010055;
	Fri, 2 Dec 2022 11:30:37 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
	by ppma03ams.nl.ibm.com with ESMTP id 3m3ae9h32s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 02 Dec 2022 11:30:37 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
	by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2B2BVIU310486458
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 2 Dec 2022 11:31:18 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1810BA4040;
	Fri,  2 Dec 2022 11:30:35 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 033BDA4051;
	Fri,  2 Dec 2022 11:30:33 +0000 (GMT)
Received: from [9.43.50.154] (unknown [9.43.50.154])
	by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
	Fri,  2 Dec 2022 11:30:32 +0000 (GMT)
Message-ID: <e74d9636-5886-07d6-e333-f447b3587a86@linux.ibm.com>
Date: Fri, 2 Dec 2022 16:59:23 +0530
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH] ndtest: Add checks for devm_kcalloc
Content-Language: en-US
To: Yuan Can <yuancan@huawei.com>, dan.j.williams@intel.com,
        vishal.l.verma@intel.com, dave.jiang@intel.com, ira.weiny@intel.com,
        jane.chu@oracle.com, dave.hansen@linux.intel.com, santosh@fossix.org,
        nvdimm@lists.linux.dev
References: <20221125020825.37125-1-yuancan@huawei.com>
From: Shivaprasad G Bhat <sbhat@linux.ibm.com>
In-Reply-To: <20221125020825.37125-1-yuancan@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Yf6nYqtc0Ca0L61MCwku6mn_PjST3v22
X-Proofpoint-GUID: Yf6nYqtc0Ca0L61MCwku6mn_PjST3v22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-02_04,2022-12-01_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 clxscore=1011
 impostorscore=0 malwarescore=0 bulkscore=0 mlxlogscore=981
 lowpriorityscore=0 spamscore=0 mlxscore=0 phishscore=0 suspectscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212020086

On 11/25/22 07:38, Yuan Can wrote:
> As the devm_kcalloc may return NULL, the return value needs to be checked
> to avoid NULL poineter dereference.

s/poineter/pointer

Patch looks good to me otherwise.

> Fixes: 9399ab61ad82 ("ndtest: Add dimms to the two buses")
> Signed-off-by: Yuan Can <yuancan@huawei.com>
> ---
>   tools/testing/nvdimm/test/ndtest.c | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/tools/testing/nvdimm/test/ndtest.c b/tools/testing/nvdimm/test/ndtest.c
> index 01ceb98c15a0..94fbb9d0fb6a 100644
> --- a/tools/testing/nvdimm/test/ndtest.c
> +++ b/tools/testing/nvdimm/test/ndtest.c
> @@ -849,6 +849,8 @@ static int ndtest_probe(struct platform_device *pdev)
>   				   sizeof(dma_addr_t), GFP_KERNEL);
>   	p->dimm_dma = devm_kcalloc(&p->pdev.dev, NUM_DCR,
>   				  sizeof(dma_addr_t), GFP_KERNEL);
> +	if (!p->dcr_dma || !p->label_dma || !p->dimm_dma)
> +		return -ENOMEM;
>   
>   	rc = ndtest_nvdimm_init(p);
>   	if (rc)

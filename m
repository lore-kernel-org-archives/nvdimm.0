Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99BC92C89
	for <nvdimm@lists.linux.dev>; Wed, 17 Nov 2021 10:15:51 +0000 (UTC)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AH9Gn5F031125;
	Wed, 17 Nov 2021 10:15:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=z4/co3u3OOUAYuzdawTARNhxD3jDcIc4WbqOgldWzhw=;
 b=S+CV3bqcIn/UKoJWUtYiU/U5VxcTN9FlE8MzATY9G8YPugW/yQ67W8A66WnvCQTluNTq
 eCavyyi9r0XuODA1lEmVnwj5U8gKGG655GVOciopPjMdEDGam6WotyN7cB3/I+Nv1G8e
 S9XyKKQrscUIX2BFv30qLRme/3GZKTaCv+qQT4SS0gIl+cny6dOcbmmAdqPwsC0SdCoS
 BUb/Aw8raJvLp6NtUYt0mGx2Zg2f1a1pCcR1Gp3yXao5OiatwRwrfkydiW/0Qj6gi6Xo
 4ehB/u+Isjdkqx3AxmhsrKJsD9xbelY7KFS8avW0gBFcaXJI3sCB3f4kMSI8I80IfdqG sQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3cbhmnymu7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Nov 2021 10:15:45 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AHAB5iw120021;
	Wed, 17 Nov 2021 10:15:44 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42])
	by userp3020.oracle.com with ESMTP id 3caq4u11xw-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Nov 2021 10:15:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NTys6M0+dqwQ7bZhOjp0ZGWyAOvWhxJevyZwrfvsrgrufDbEe74HQ4Vs3c6GBhgICgFXwAfKmkZvzBtlMJosiUA8LxSFhvpe1XujOMbBfgR4vraqpqDwB7RoeWbCWB7WSAlWGX+w7sxc3j3GIquxJvm1v6rybDxitajA2T0nCNJVQ0SkawH1gnNXV8b28xqB447AWP5zUUGtGycD3yBOP26pEIIdfUbefBcHqfRpqQFUjRRMU0xODDAgGYpbY+2wr8/HnP1X9NLInFOKay8Emuy7mU/Op8WdV162ETzK5X63nN5VHysB+fb++sbjfviNUF87VMVLcGZGRnJ3/pwWGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z4/co3u3OOUAYuzdawTARNhxD3jDcIc4WbqOgldWzhw=;
 b=WCSF0bxjQy7/UrdigwSXa2R0B00UNQnsnWhOc2RsrlBXFemnTwrbhoPqgybXOzFMQRLgS2sShW1ko1RHDvSQOd9gn3OgorSD5dNK/wGyWsgJd7PhqCdVVdUCC9ffM5y27I2qCfVGl5aV+0QQSPQi752YBVXIz8/XQFD9xL1MjGZHCWsXibTc5J5thON5KOxggHgilU/NcwBmfEt7Ape8wxhmb2/nuE+7QVVmhn4yK40DPLa3J+A+vCp+M/Nztrn4lT43/7uTg3YRkEIAnBi8wDU98RYv0cguaJma/qBF3kMOzS19m3IgBWJHrp+g784IMfSf90YfxQOxEc31ahdZiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z4/co3u3OOUAYuzdawTARNhxD3jDcIc4WbqOgldWzhw=;
 b=AmNgFPK3Gl5MCYhPWV3gv3MJwkWeWStiXQyBpblo1kPxcfkRvnh7kSm6JyfpB+AzAIRXciKd37a5VSn3Wvz9I1q1EARxH9YXhyVRF7Sa3nL1uujVMXqgDW7V5HPYkzc4h1s+oz3UBC7c58FGFy+xKj4jTJVaWUtVCts+X6oJjGg=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by MN2PR10MB3904.namprd10.prod.outlook.com (2603:10b6:208:1bb::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.27; Wed, 17 Nov
 2021 10:15:43 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d809:9016:4511:2bc6]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d809:9016:4511:2bc6%8]) with mapi id 15.20.4690.027; Wed, 17 Nov 2021
 10:15:43 +0000
Message-ID: <70f49eba-c1d9-817c-057f-501f58fb90a4@oracle.com>
Date: Wed, 17 Nov 2021 11:15:31 +0100
Subject: Re: [PATCH v5 7/8] device-dax: ensure dev_dax->pgmap is valid for
 dynamic devices
Content-Language: en-US
To: Christoph Hellwig <hch@lst.de>
Cc: linux-mm@kvack.org, Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>,
        Matthew Wilcox <willy@infradead.org>, Jason Gunthorpe <jgg@ziepe.ca>,
        John Hubbard <jhubbard@nvidia.com>, Jane Chu <jane.chu@oracle.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>, nvdimm@lists.linux.dev,
        linux-doc@vger.kernel.org
References: <20211112150824.11028-1-joao.m.martins@oracle.com>
 <20211112150824.11028-8-joao.m.martins@oracle.com>
 <20211117093733.GB8429@lst.de>
From: Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20211117093733.GB8429@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR10CA0013.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:17c::23) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Received: from [10.175.34.134] (138.3.203.6) by AM0PR10CA0013.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:17c::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.20 via Frontend Transport; Wed, 17 Nov 2021 10:15:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a2e6bab3-210a-42ad-97a4-08d9a9b336ae
X-MS-TrafficTypeDiagnostic: MN2PR10MB3904:
X-Microsoft-Antispam-PRVS: 
	<MN2PR10MB3904BEBDADAC044D51C22ABFBB9A9@MN2PR10MB3904.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	nUi3PK440HCvK96NhfuqGzDHaY1Wp8IRR2iXjpU4aEd77uwMt9E2/CfCjlZ04xl628jVMzyXLeP6GDKj36hipWLXKc4XCiPHpFlB1y3fF6es7b9mKcPNpqnztj4dm4TRXUoCqJlNrbOQbWbGWanlEOXL/3OoEJZRJjReyJcUp0+A91UQuuhf1SCqZLTNxbllce417kbXQE6wyQvRl2OR9xyQoeisUbRCoTuTfSSHvsIHEuapyhtTBkR2l/Zv5FcNpVJ4eJ0nr+D4Dz31eWgMIOLw0J75VwL3ozTB8uGF+BoYfrLJPCaJWfFoKvX0/FMSeZvUuDp4yjZvFsCcxAMBUZg17ODBqkQQLRBgLadDAK0q7uA7gGeEJ51Rkx7Zd3pNwgxZV1W18s+j+8rC7bPwcFGTtUxQrgfgucB9T93hfYxn4twoELM+N5JYSqMYA2pF7B5SBt22jBKVa+xkWtd3DBIssfVxp4+sVzxhytfKYf6xBeGhDuwfGtIky+KlPCGga0pAFPgEIZJwbxmiwiyYFnz/CzJepXvlcBIAOb7u+/YJBLs8RUcQ7I9cT96vi5bahEqj6pIbM3ClYV3MHB9zlzGAD+dEigsimgbmkAzucujTooUvZfAJH+VXzNsBmtr8qFlM91psLtWgz1Hdy08mxXSk8HhoubEeTtJLZtBwObLHkmuubP5wvf5EwtiA5R3mn+Gx5lgwxC5AER5bLDJu6A==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8936002)(7416002)(956004)(8676002)(66946007)(186003)(26005)(36756003)(86362001)(53546011)(6666004)(66556008)(31686004)(38100700002)(2616005)(4326008)(54906003)(66476007)(6486002)(6916009)(5660300002)(16576012)(508600001)(316002)(2906002)(31696002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?K1dzK2hQYW9ZQU9VMFY1ZlJCU0tyRmtob3I3U3pvS0dlWWZOenhqaWcybndK?=
 =?utf-8?B?ZmFBakRLYVFGVHV6ZWNSbWFFR3JuNHRaaFF3YUlqeSsva08zQTJYeGE0cDNQ?=
 =?utf-8?B?L1R1ZE9MZjB3dklqUGhKaGdzNmZnOFRETE5MMzVCQVhnTXpTeFJUVk1ZK2xz?=
 =?utf-8?B?LzRSZmdRZjJXcEVuaDZUMTB6Q1B4TkRNbW1qVUdLdHh4d3pkTlVzRnpIbTk4?=
 =?utf-8?B?UkZlUWVCOWpiWEFkdjJNVTJRNEFrZGJaWjFPeWdLYUdlTk1DVHFseHZGVkJo?=
 =?utf-8?B?UnZ6ZzNza2UrMGdyL0EvbFBRUUg4V0l3RURMVit1MGdZVElMdzAwb1lFcFN1?=
 =?utf-8?B?eEcySC9Cem55dnJkSnU2ZXBRVzhSQm1TYlNGS2VXb0FuVE1aL3ZaemdFMXJq?=
 =?utf-8?B?WHEvTW52U0dmU2U2QWo3ck9LbnBoZkNzN1g3Z003ZmIzQVhPNDFZV2kwdk1W?=
 =?utf-8?B?U1Q2dy90aTNqSnBYT091VzlwZVJ3enNoVHBicWFWY2tMQ0N5UndReWtMVm1G?=
 =?utf-8?B?aTBKaHhwL1NEdWFZRHZOWU1JaDlxU1llV2QyWkZhVHc1TTRnOXF1RVV5UkNh?=
 =?utf-8?B?eXk1OUx3Mm1nbjhyUlpuM3ZyaW1ESUtpZGJmcnhSUUowZTQvNWJ1TE1uQTB1?=
 =?utf-8?B?VHNsMjJvR2NFVS9TcFJNOTZxVEJTb1VVK3JTUnUvZHlnRHBURDRnazQvTVI3?=
 =?utf-8?B?MUNMVTZjZzUreDBuL2Y0T1V3Sk1jMEV1bVVvQW9tSmVyc1lWa3FnWFhIVkti?=
 =?utf-8?B?QjJhU0ZDNFNQeHI5bHJxZXA5dlJOS1NrOHdQNjg0UzBIQ0haWXZ0RDlPczVZ?=
 =?utf-8?B?a1FFUUNHaEVIR3NqbUJMNU1lZDNJcktYTlpBeGxLa1lPZlVlMkJUcjNtSnlz?=
 =?utf-8?B?ZDdhUTBKU3ZRSWRvRlBWQXVxUlNjeFlmK1Y5YXZKTm5sY1hCS3FTZlF6Y1M1?=
 =?utf-8?B?QTBSZzhTZ1NrUDZNQWhkamxub2FBMzVJQmlWVmFNZ25RaXVWWHVkclRrcmFt?=
 =?utf-8?B?b0poakdWRjN1V1RHSCt2NEpTdHpiL2hvSnJ4L0ovbnVKTVdqSzd3MFUzL096?=
 =?utf-8?B?ZEdXSDN0elFsZDJ3ZFZXalcvK3RnUy9oRFlPeit0REpwZTkxQ21JZ3Q0VUM5?=
 =?utf-8?B?cHdQWWxvTUcxTVhOVVY5ZThSYmZEUStPaXVzd2JHV0lzVFZ1R1pHS3JYMlZq?=
 =?utf-8?B?TDcraG9VRXZZWlRzdnBZVEs0Qlh4em5ZSmZjREJmU016ZFpQZWJWaVI2TVR2?=
 =?utf-8?B?RkIrVTUrcXAvcGZidVUzbS9JR2t2QzdabkdaSXlXWGVpaG1OK3JwNHlpNitj?=
 =?utf-8?B?czZicTZhZjZvN1YzcFNqNVpvM0ViVlk3STB6WXNaazFJZmZweWM3bE1YT2E2?=
 =?utf-8?B?WFF2cVVyVFV4V29wL2lFbEs0M2VhbUEzUHRuOW1qR0RLQXU5cEVaa2FjRWhS?=
 =?utf-8?B?SFhkTHhXMXN6QXp3SU1yR3pyOSt5UmxWVGo3S1NRVDVOclZEUE9oRjdxWlgv?=
 =?utf-8?B?dThJTDFGWWt1TjNibWNYdVlKRkhCQnJoVEtZSUF6Vy9hamFrbWVrUWFEQ3RG?=
 =?utf-8?B?R0pXSDFkN3pNUnU5eDBNSWkwS01pTUR6RTJzSUlqVUE4ZXRQTytGVzcwOUF5?=
 =?utf-8?B?NytQKzJ6ZTE5amZWVm9TZnBmOEhqOWpsV1psbk54QkswRXdPWUpWd3dWZS85?=
 =?utf-8?B?VFpQbWwvVkhnRUFsSUpheW5GelMrSkpGa2NteVZyaXQzM21EUjFjRktZTWxH?=
 =?utf-8?B?dkxYb01EYzNkOWtrbkVWRy9iS2YvQmpjdGQ2aVp6OW15RzZhbDEvTjJjSUUz?=
 =?utf-8?B?eW9TOWVpdHlVNWZzdmtDY0NabWRYTjNtMlltUDJCVVU2UTkzMHFHZ2M3ald0?=
 =?utf-8?B?SzVFSWJ5bEtGQWFkbmtKcE1ReW1uSnhBOG1qV09NdVNTREw5WW9VUUt4OFpq?=
 =?utf-8?B?VHVWVGhWaWJySEJEazYyMUdIN29GdFJYTmJNdjBYcUk1MmlJekVFSEIwek1h?=
 =?utf-8?B?REVYdjhYUm9NSTU1cE0xczZmSWdvcFQvQWRBZGVkUnpMNm1hd2pxQ3p4b0tK?=
 =?utf-8?B?MHZUbTNHcnJ5UjArQ3dBd1dabkgwSURDZDk2RUFDa2RVcFVwMXByN1o2Znk0?=
 =?utf-8?B?UG9GaktCV3BGMU5vRStsVzdGVHVZZDE4U21uSFJ5bzdsbFM2dFMyWG0xcDI0?=
 =?utf-8?B?U29YMWZkaGczMkxjVzhvTSt1VUJLdVFIVVc0QTEzK1c5V1lPN244NWZ5TExq?=
 =?utf-8?B?ODFRM2lOQ2pkampuZ2p0SVlVOHRRPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2e6bab3-210a-42ad-97a4-08d9a9b336ae
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2021 10:15:43.3607
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p305ivLDm1kKEgVCj5VB+9q6pcq1rvTHrevo11mPmuxMOtzGa/0AbB8dKtzPR9hcN3wU2OW/mYPh8DuLzwAqgcC5e9qanGPSbLfcTH5RO/k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3904
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10170 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 mlxscore=0
 phishscore=0 bulkscore=0 mlxlogscore=999 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111170052
X-Proofpoint-ORIG-GUID: EY67UWjpk8AdZQS1JfBAzAE1INKsDF96
X-Proofpoint-GUID: EY67UWjpk8AdZQS1JfBAzAE1INKsDF96



On 11/17/21 10:37, Christoph Hellwig wrote:
>> +bool static_dev_dax(struct dev_dax *dev_dax)
>> +{
>> +	return is_static(dev_dax->region);
>> +}
>> +EXPORT_SYMBOL_GPL(static_dev_dax);
> 
> This function would massively benefit from documentic what a static
> DAX region is and why someone would want to care.  Because even as
> someone occasionally dabbling with the DAX code I have no idea at all
> what that means.
> 
Good idea.

Maybe something like this:

diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index 19dd83d3f3ea..8be6ec1ba193 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -129,6 +129,19 @@ ATTRIBUTE_GROUPS(dax_drv);

 static int dax_bus_match(struct device *dev, struct device_driver *drv);

+/*
+ * Static dax regions (PMEM) are regions partitioned by an external entity like
+ * nvdimm where a single range is assigned and which boundaries are
+ * defined by NVDIMM Namespace boundaries (e.g. need to be contiguous).
+ * Dynamic dax regions (HMEM), the assigned region can be subdivided by dax
+ * core into multiple devices (i.e. "partitions") which are composed with 1 or
+ * more discontiguous ranges.
+ * When allocating a dax region, drivers must set whether it's static.
+ * On static dax devices, the @pgmap is pre-assigned to dax when calling
+ * devm_create_dev_dax(), whereas in dynamic dax devices it is allocated
+ * on device ->probe(). Care is needed to make sure that non static devices
+ * are killed with a cleared @pgmap field (see kill_dev_dax()).
+ */
 static bool is_static(struct dax_region *dax_region)
 {
        return (dax_region->res.flags & IORESOURCE_DAX_STATIC) != 0;

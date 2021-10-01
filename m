Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 565782FAE
	for <nvdimm@lists.linux.dev>; Fri,  1 Oct 2021 00:43:36 +0000 (UTC)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1910WriC014699;
	Fri, 1 Oct 2021 00:43:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=5wBdS9FQyB6zz9mIi54GUaHbEVhQK0wA/wT6taoKBn8=;
 b=BF1an+p2k8qieUecRfb8tuQe0MS255JAIdpEFDHzOrgE+OMvkJnq8U16FDBoOrbv6965
 7wDvM5mRBMRuR+tOewuiVLJnHDA6h6s5zE6gIkM312eMe3nA7BL4B4XFGIFyzScZiNXm
 D4WH0HaoSBf02iTWGFlliGB4y/bRnffipNLLSzF1cDWUzSmnvg8Es/aiLNqZbC1kcBbi
 wG1/uCsMHQEnzV0qOlYHf+2necUWVuluHUVBwOAw7mRGrZmM3samKcjCcIr3sKBWJAoM
 K4Eby5AI8lHU/81DWZy2nGdafV6P783JE6YEx4aycQreC1PYTVpW9gShlms50TtA4Bp6 8Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
	by mx0b-00069f02.pphosted.com with ESMTP id 3bddu8vg8b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 01 Oct 2021 00:43:28 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1910LER6107811;
	Fri, 1 Oct 2021 00:43:27 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2172.outbound.protection.outlook.com [104.47.58.172])
	by aserp3030.oracle.com with ESMTP id 3bd5wbycdx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 01 Oct 2021 00:43:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bTQot7SlwJbZQ/O0f1dUzIhuMZwlfGMxrlOv9Jz3NvI6kGAnLWnHKUeXYYM+8xAWf+NU7HMfMvLVibl1Vfnl2LpFajYG4wbfM6yvkjQzFfr25ga9X2WvYxm9wW1be9LGNPaYJeoW8fcyKKF1bjmQydVmvDk/ockBgDtzKjiO2bLjKou4O0qwcTPdYtSerZojk697M19wRzcRRAiXmKrgS8clhcWAHx18D/L/ABf8GmHHWYQpfKIkcPyanCoO/aISxoNIQBjp3/+I8CS8HWP+MLWN4g5UkgMoXK6OP2m0OsZ0L1xX1p7pPRsVUWufegyho8wxVrD8/DL23E04R+whTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5wBdS9FQyB6zz9mIi54GUaHbEVhQK0wA/wT6taoKBn8=;
 b=LoAVqT5vINOc9OsLFhqnecHmOvlN20cVRtg3Zu3BwmF8Eej7XPYVlO2prLfUTgP6BXmqnWG1RzOcJiC+8W1WHInIQuDWzhUcb44CM+hxFf0Bvh2RjPK2oi/RqtTEWyB12olB+BnIYnl6ZhXpidhzmeKroU2vaXdiAFISvx0JFDFetCWhrqvmxeSIklW2q89nSRVJ0krtgc9Dixzrgn9XkcnRz8IecmS12HjlTIIj3DLBH7fedgauW22UgcYHl3Tdi70FXpVxyG8GiZfGFPRS0Vm3Uy1Dz0OHI2+PJmgEi6U3kEkaPXIAMA6xgQnjEa3j7FqPZIThKxwzQSP3iyQ1rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5wBdS9FQyB6zz9mIi54GUaHbEVhQK0wA/wT6taoKBn8=;
 b=qIvmOApBD9pEcDsLAUDWOYomjUyM7/41skj86uc7XgSieib656X1vIjT3UutlVgzERg4qxHUTUSPUFpadMQ/Kv8ADREkoxt9YF3aDg6Kf9qzQNq1UZAhufTd17+hGRZIo1U/IEoYL1uhy8C8de24hB1LnLdYjqz3xMsjL/qGVFw=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
 by SJ0PR10MB5661.namprd10.prod.outlook.com (2603:10b6:a03:3da::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Fri, 1 Oct
 2021 00:43:25 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::401:1df2:3e9a:66c]) by SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::401:1df2:3e9a:66c%6]) with mapi id 15.20.4566.014; Fri, 1 Oct 2021
 00:43:25 +0000
Subject: Re: [RFT PATCH] x86/pat: Fix set_mce_nospec() for pmem
To: Borislav Petkov <bp@alien8.de>, Dan Williams <dan.j.williams@intel.com>
Cc: "Luck, Tony" <tony.luck@intel.com>, Linux NVDIMM
 <nvdimm@lists.linux.dev>,
        Luis Chamberlain <mcgrof@suse.com>
References: <YVYQPtQrlKFCXPyd@zn.tnic>
 <33502a16719f42aa9664c569de4533df@intel.com> <YVYXjoP0n1VTzCV7@zn.tnic>
 <2c4ccae722024a2fbfb9af4f877f4cbf@intel.com> <YVYe9xrXiwF3IqB2@zn.tnic>
 <CAPcyv4iHmcYV6Dc35Rfp_k9oMsr9qWEdALFs70-bNOvZK00f9A@mail.gmail.com>
 <YVYj8PpzIIo1qu1U@zn.tnic>
 <CAPcyv4jEby_ifqgPyfbSgouLJKseNRCCN=rcLHze_Y4X8BZC7g@mail.gmail.com>
 <YVYqJZhBiTMXezZJ@zn.tnic>
 <CAPcyv4heNPRqA-2SMsMVc4w7xGo=xgu05yD2nsVbCwGELa-0hQ@mail.gmail.com>
 <YVY7wY/mhMiRLATk@zn.tnic>
From: Jane Chu <jane.chu@oracle.com>
Organization: Oracle Corporation
Message-ID: <ba3b12bf-c71e-7422-e205-258e96f29be5@oracle.com>
Date: Thu, 30 Sep 2021 17:43:20 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
In-Reply-To: <YVY7wY/mhMiRLATk@zn.tnic>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0083.namprd04.prod.outlook.com
 (2603:10b6:806:121::28) To SJ0PR10MB4429.namprd10.prod.outlook.com
 (2603:10b6:a03:2d1::14)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Received: from [10.39.229.226] (138.3.201.34) by SN7PR04CA0083.namprd04.prod.outlook.com (2603:10b6:806:121::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Fri, 1 Oct 2021 00:43:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fd16376d-07cd-4269-a2d1-08d984747a54
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5661:
X-Microsoft-Antispam-PRVS: 
	<SJ0PR10MB566164F7B3CBECFC4DCEFA91F3AB9@SJ0PR10MB5661.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	uKu8nzRM5vwQDQydKGWEoY0egLjCkLk7hcfRw3pgPmPkw9cp0ScOUp2HMkuwdijo3JV8H94VSd3mZT9/atkd6nt9tWS/jiHPSv4iGQ4JlKf0KYICoHwtd1BkKBRlr1dbyzUCCHnSW4Rntq5WWTq/DCpoaGozguEbsLqZgq2O2xm3l+iZoJymysSx6wrjfY04uua7XYIAv5QfTczcwg5JXntJHYpOx3JTdbZH9cfPNGK/mFQII6r8W3g6wa6+3ySx5SZ3VAEZ17iPCbejgEPb8uznJahlQdycAZwHHAYKndOAUuO2sdYSlZGTeS+w6s0O4/VwS3Y14jsD6pqjgSHq53go+F182HtEpQqhbxYbtofQ3aTt+gPAaF0B8N6FZO15jFZxG9rkXzt47/jKPB8AKfIQyRDKVPsjmmJKQ0z9F56BxL/AGf4gw9Hvdbz4In72D+Rd9u//+YtX/JBuvsb2tR8lwfM9wh9bxFQHuA1ABswT4zGE9yNg4pvjhd0r/R2ycX6BuxrPCmaGA15T/2q1CHWAcCKqJAbQJWIG4P/qQ2OOvFRK5y9jyQRpTUHNjbrlzhX4b8chHmt62Fo+Q4Zd34EZp6pi0GKgSMbeaJUqdbAqzoTen87iVxwQkTabP//Uowciow5gaBGozA3UCYums616jFg036YlDmwMMi2xa/iJzbKwLZghiKdQguPOQQNox4QFR5kXRFuAEj+YiMe4SWxks8RlmqD7uOYZJRJTmZw=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4429.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66556008)(44832011)(8676002)(956004)(31696002)(6486002)(38100700002)(2616005)(36916002)(36756003)(2906002)(110136005)(66476007)(4326008)(53546011)(31686004)(8936002)(66946007)(6666004)(86362001)(26005)(316002)(186003)(5660300002)(508600001)(83380400001)(54906003)(16576012)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?Z3hVSHl6eStTamlqVzBtdFZjbkd4cjNMUEpFTFJDRllkZ0N2Z0JpcEZDamVW?=
 =?utf-8?B?TWtHdDdRaGlHb2E0VFFGcWd4Znk1SkpCcjM4cG9XaTFveTZVR3hsNXg5RVJi?=
 =?utf-8?B?MEo3S2daYTZOVHk2enRjQmlVbzdIenFNT0M3VzB2cVU4TVFPc2szSDAzc3dV?=
 =?utf-8?B?SXRQaVRMT3VVVVY4WkNmbFdBMXB0Z21WT2czdlJQUmlNNXlSWHQ1U3JlUzNT?=
 =?utf-8?B?VnFuSm5VOWRkUzF0ZWVMTnNkSzYvbjRsU0ttSGVGSWpuMDJ3VG5EZUZCUnBz?=
 =?utf-8?B?UnRNb2JpZzNZZlZiQUhuNittNEtRRUw5VFZTYVI2QVdWc0hSUU1KRjdrZWJa?=
 =?utf-8?B?WVdLREhTNlZSak5nYXFCQmUzU3FNN2NUaEFXU3NaZjgybUFHVFY2U0JCUE9K?=
 =?utf-8?B?cGVSczNudnY3NkdybjExQUd6bWtuZmdDektUelYxZnhCMnNCaEtKK3JCVC9N?=
 =?utf-8?B?UGxSc2tCWUMwYlIvdjAyVTRmY1pTV1RWcFI0Q2xGVzRaNnJrNnBsUUFmdFQv?=
 =?utf-8?B?RXRobzNmamFORnVleStOdVVsZnUxcTBoQ25iY20zNVZGa2NkZ0lGUjM5dFVR?=
 =?utf-8?B?ODZGcERlYStjVnhocFZnWk5WTEJEa1U2SlNEb3Z4NnczMXk5Y0ZqL0lUZE5z?=
 =?utf-8?B?M0ZSeElnaWdvQnhLSmdrdU9KMm5rQjJ3Q3ExQ2xLN1cydDQvMGJHSGRHREU2?=
 =?utf-8?B?MGtYc0d6NlVNTHk3RVhJZkZLTkd1OCs2QXdXL0dtZUxRakhSeWZRNVRaSElR?=
 =?utf-8?B?bWx2MTRMWEJQcjlwOVRreGNHYndyUmVUNmpvRFhjeW1mOVk3a3p6ZGZWU0VS?=
 =?utf-8?B?NW5iZmxRWWRqUXJEbkEwaHJqdkJjYUtrajk5VjhQbGhlNHVNR0xYQ3hBbkZM?=
 =?utf-8?B?eGRGRDVBN0hOZUNKczUvdm9WZS9WTW01YU9iaUs2YWYxNTM3eXhBWTZ0SGY1?=
 =?utf-8?B?QlpRcTVGdUsvVXZMU1MvYlFMM1JleHZqZ0tKMWtuemlJNDNkakxpTW9hZkdK?=
 =?utf-8?B?VmVtaVVoQWxGYkFKNUtIeU1jNVFyQzQ1aHlkQXZPN0tXUXcrcnBHaTg5cGd1?=
 =?utf-8?B?WUZjaWovTHMxQ2JlZnJaS1JQdzVmZ2tIbnAxYklQSW02WVhEVFJ1aGtEeHZk?=
 =?utf-8?B?MWF6Z2Y0YjNSRlV4K2dyT3MvcmRubEd4YVlaeEdCYS9MNko1ajNoVGFTQjBH?=
 =?utf-8?B?dzUydkx1UTNPNk02K0ZRbjRoYis4bEh3YmxWbzNmTDZHWGU5OCtLejRuYjhZ?=
 =?utf-8?B?MmM0cU9jTWRTR3ZiVDRQcVhEVnpQS3Buc2FLVVhIRVIrLzhPTkVvYzl1Wmps?=
 =?utf-8?B?L3ZubVlmWk9CWDFCaGJFclF4VzJOZlVVdG04WDhucXE5UmIzQVkrcllZRDJr?=
 =?utf-8?B?dGwxU3BLOEhKdnYvUmtVS1QzdGwvQTlwT21tNzBPT2h5TXpiaUNtZzRVY2s3?=
 =?utf-8?B?UVczYk1XcWI0VDg4WUJkZkgxRmlmRE9FUmR1eXNpTTBxRDlGQ1lYWU5DTFFj?=
 =?utf-8?B?b0dBTndyWDl6dm9IT0Y1ZEtWeXVFT3VnQ1U1aWEycmZWc2YrNG5VSEZvREFD?=
 =?utf-8?B?OENZRitUaEF1MDVPTDh2Z25GdTVwUkJNZFNLYVBMRHZ3SEdiUGNHRldFK0xr?=
 =?utf-8?B?RDJLS0pMbE12OWtIQUxtT2R6a3U4WW5objNaZC85YnJzRmVhZ2lHMUZtK3c3?=
 =?utf-8?B?YlptYnJLZTcybGNWay83aHNnQ3poQU5uaHIxK2FNVU9HUE1IeWMxOVkxQ3J4?=
 =?utf-8?Q?49UjPu/UvstL5FghCAjodc4NBPBJKSP8miUXBv7?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd16376d-07cd-4269-a2d1-08d984747a54
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2021 00:43:25.6789
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zGUYYKSjF25C+uIfm2TfmcZU0znGNL9oLk8IphSXqYx0qcdMrLmIZQvczegpYyxp94YkxVKjd+UL6BGgyl2zuw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5661
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10123 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 malwarescore=0
 suspectscore=0 spamscore=0 mlxlogscore=999 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110010000
X-Proofpoint-GUID: YsEQTXjGwGUAB09vErwr-mjwMBdPFySe
X-Proofpoint-ORIG-GUID: YsEQTXjGwGUAB09vErwr-mjwMBdPFySe


On 9/30/2021 3:35 PM, Borislav Petkov wrote:
> On Thu, Sep 30, 2021 at 02:41:52PM -0700, Dan Williams wrote:
>> I fail to see the point of that extra plumbing when MSi_MISC
>> indicating "whole_page", or not is sufficient. What am I missing?
> 
> I think you're looking at it from the wrong side... (or it is too late
> here, but we'll see). Forget how a memory type can be mapped but think
> about how the recovery action looks like.
> 
> - DRAM: when a DRAM page is poisoned, it is only poisoned as a whole
> page by memory_failure(). whole_page is always true here, no matter what
> the hardware says because we don't and cannot do any sub-page recovery
> actions. So it doesn't matter how we map it, UC, NP... I suggested NP
> because the page is practically not present if you want to access it
> because mm won't allow it...
> 
> - PMEM: reportedly, we can do sub-page recovery here so PMEM should be
> mapped in the way it is better for the recovery action to work.
> 
> In both cases, the recovery action should control how the memory type is
> mapped.
> 
> Now, you say we cannot know the memory type when the error gets
> reported.
> 
> And I say: for simplicity's sake, we simply go and work with whole
> pages. Always. That is the case anyway for DRAM.

Sorry, please correct me if I misunderstand. The DRAM poison handling
at page frame granularity is a helpless compromise due to lack of
guarantee to decipher the precise error blast radius given all
types of DRAM and architectures, right?  But that's not true for
the PMEM case. So why should PMEM poison handling follow the lead
of DRAM?

Regards,
-jane

> 
> For PMEM, AFAIU, it doesn't matter whether it is a whole page or not -
> the PMEM driver knows how to do those sub-pages accesses.
> 
> IOW, set_mce_nospec() should simply do:
> 
> 	rc = set_memory_np(decoy_addr, 1);
> 
> and that's it.
> 

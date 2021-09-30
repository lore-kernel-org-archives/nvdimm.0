Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C4E429CA
	for <nvdimm@lists.linux.dev>; Thu, 30 Sep 2021 21:23:46 +0000 (UTC)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18UL6bI0032383;
	Thu, 30 Sep 2021 21:23:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=l4y+cHTlIiW5BeXb64ZDIO2F+YQbvUaEdiBVZ6Xn/B0=;
 b=TE6BmgtRwZIZl4nNrBcWxXrKdadB2VC+2xNBHpKQ41w7go3cQevDH0o1NX72hwrGYI7R
 xhJl9N9iHPUm8aN+Va3VzGrGSqfBu5zMRivs3GCVPFLUGVOhfHqOmO6jIjQgCfp6wGdK
 9t5TEGfGvIQP9ohZk2Y0kq+chTwXrgZdffGrBIKI3jxzxMjuYC5XwA94QLCVW417cDD3
 0xCl9ev0QAQ/8Gbz0jKAvwlZiiBK/12Cmwje6RLHZqaPKqj7nQ2LeKcOxydMghvHkGNx
 9jauDjaQWlxIWyymKwkXZi6TpOztAtMwPwdTp0O3rRw1++/YUkPACRbshgrZe2T1LW3G vg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
	by mx0b-00069f02.pphosted.com with ESMTP id 3bde3cbket-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Sep 2021 21:23:37 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18ULFEmr169315;
	Thu, 30 Sep 2021 21:23:36 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2105.outbound.protection.outlook.com [104.47.58.105])
	by aserp3030.oracle.com with ESMTP id 3bd5wbrn70-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Sep 2021 21:23:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lpk3GtQxr/2pFwlx9JlC1y3cmayghcL2273nvXjfPfUsg7XjKurFLVFpDhb9LCrZyTMWPv/vnCghTQIDTwn5wKLeQfbFQGoxeuUmXKQN0ihFCbXnQHGIYCUom2BPkOwyUP1X8H+J98DiGucCq9G19l92B5H5NUjFMkB0IuYOchbGKc9k1us4tCQ8Ak5HPONTvqU/b4oOU0Uy1jNypMG977RGyXkVmE7WV/IczQvkccdoTMTtallFOTI9i61DeUQRwpxLe8EaDsQc0cHcKsiHWaJSp73qZlTWS1r/9J/4qAEZyduf+rnu+khtYuXemUU4/faAIFQcP61KLSEdu4Yzcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l4y+cHTlIiW5BeXb64ZDIO2F+YQbvUaEdiBVZ6Xn/B0=;
 b=d8jtsU/Gtim9MtjFrSb+Ve0uqtK2yBIoZNiqqT5sZwXbTJ69mo7Ogw5q5Okdiij7ZtODuz34GQpyqGC6R98PhFoXUNIJ4o1/XeZGtu0sDdJy3ABb/BDEtsGpKLo70Vd3byQDXr3A/jTeV9uMGy9BFqOdgnPmy5k/l6K+5VkV3VYvru5UdHywOdjrNGm4UtAYIXiR4pGesCQZkbKnsXq2JuWT4SZlKteHWBLNOMvEgOXUidS59Z8GHeQpVoSF3TNM0fp7VoY5ignpfGIt9XTD5GN8c7SmeoFgtGz22qc6d4pDaXieWvelF2sP0al7K3jM4vhfLpFzHHnqYel5JnoEhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l4y+cHTlIiW5BeXb64ZDIO2F+YQbvUaEdiBVZ6Xn/B0=;
 b=Bk/0O7jcnHsWkklE44P9GhES6DLMSMTeYnKC7HrqjPfVVSqiMHLg3mkTdguQ9/nsvSI+eD36/Gl44gNrl2pMvKDTm2jphvtgsdu0PJ6vZo2ZbHD6HADUHxbYs5vyInu53zuNOaDTvghJy2kdKEWXJcZh5geFFsWI8O0oCsPIA9o=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
 by BY5PR10MB4388.namprd10.prod.outlook.com (2603:10b6:a03:212::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.16; Thu, 30 Sep
 2021 21:23:34 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::401:1df2:3e9a:66c]) by SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::401:1df2:3e9a:66c%6]) with mapi id 15.20.4566.014; Thu, 30 Sep 2021
 21:23:34 +0000
Subject: Re: [RFT PATCH] x86/pat: Fix set_mce_nospec() for pmem
To: Dan Williams <dan.j.williams@intel.com>
Cc: Borislav Petkov <bp@alien8.de>, Linux NVDIMM <nvdimm@lists.linux.dev>,
        Luis Chamberlain <mcgrof@suse.com>, Tony Luck <tony.luck@intel.com>
References: <162561960776.1149519.9267511644788011712.stgit@dwillia2-desk3.amr.corp.intel.com>
 <YT8n+ae3lBQjqoDs@zn.tnic>
 <CAPcyv4hNzR8ExvYxguvyu6N6Md1x0QVSnDF_5G1WSruK=gvgEA@mail.gmail.com>
 <YUHN1DqsgApckZ/R@zn.tnic>
 <CAPcyv4hABimEQ3z7HNjaQBWNtq7yhEXe=nbRx-N_xCuTZ1D_-g@mail.gmail.com>
 <7183f058-6ac6-5f81-9b46-46cc4e884bef@oracle.com>
 <CAPcyv4gvnkDNBNnUdX0YeCoQiJ2BNs40wyy3mMkeYuz=GoUakA@mail.gmail.com>
From: Jane Chu <jane.chu@oracle.com>
Organization: Oracle Corporation
Message-ID: <62ea20e1-909e-8fc5-4ba2-381bac0b3dc9@oracle.com>
Date: Thu, 30 Sep 2021 14:23:29 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
In-Reply-To: <CAPcyv4gvnkDNBNnUdX0YeCoQiJ2BNs40wyy3mMkeYuz=GoUakA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR12CA0001.namprd12.prod.outlook.com
 (2603:10b6:806:6f::6) To SJ0PR10MB4429.namprd10.prod.outlook.com
 (2603:10b6:a03:2d1::14)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Received: from [10.39.229.226] (138.3.201.34) by SA0PR12CA0001.namprd12.prod.outlook.com (2603:10b6:806:6f::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.17 via Frontend Transport; Thu, 30 Sep 2021 21:23:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e2a079b6-a88a-4f87-fee9-08d984588f2d
X-MS-TrafficTypeDiagnostic: BY5PR10MB4388:
X-Microsoft-Antispam-PRVS: 
	<BY5PR10MB438841FE9F7D6CE9CD691980F3AA9@BY5PR10MB4388.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	44GNSfy+04eKakLGfq/UmYQZNFWSGrmnbnny59bVCBf6djF6KKsOuWGvmvgq2n6Qug/A3aCIGD0H79zJOmwKTqdBSZxkDay23WzN1DeYEwA2dUkXGYteWzpmqoXZOzqNgR0bAKM9wZFAcarzOE/WpkBRbncErftFwKq7ubFt4YCvXcmEhl1ai7efC1M1BXfi27OZ6cUdmsAPZntHtmDGADl6ZKgRE4XVEYCf4/ir3ZQwO+20E3nIU8/1gNTFOQzUqwCfpdKZ+Jxc1UVT6l1mX+gbQlktdbOe65YDsAwTfsmBW/RbABz20K658MjFB1bm7uuDo1S4IfUHYHDRSzzRpfIk+2Y37kzcvK0K4CnZJl9v5f+0DiO+k6MnSkYVPNDL8G7n2qOW6I4EQcAQdEPovcMySgpmKTY2D3DKcJHjiLB/yXM4ymqGz4H2ZhpJoRiT6vWNVArF4QHO+/0dgJ1YFTmgJE9pkPe8h82GUSTrp5MYXSVEMv0hHV/rmox7RNnu+yICPRDX5tHGbPZynRc3C9+SbKNxFILWjQzhVEQaeHpaToSM8/SKKds0Qznuwe0aFN45c4wN4D05i86bx/DsPFlaoanZmOfPflHYkLJg7xjwADRAxu+uMZ969zf3NNNMUYLXHAXQGEMAKFBJyu7zd4Ac98wvvoibXfwE3X6QL8BQKqGN9OdoD0U0GfAInFzeg5liYcFL9oAvsFSvgzENU4AJ6XFzYT4c05oAZ3p6VM0=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4429.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(26005)(36756003)(31686004)(5660300002)(6916009)(4744005)(16576012)(8676002)(316002)(8936002)(186003)(83380400001)(4326008)(54906003)(6666004)(508600001)(31696002)(38100700002)(2616005)(956004)(66946007)(86362001)(6486002)(53546011)(44832011)(66476007)(66556008)(2906002)(36916002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?c3pTbUx4ZjhYSTlSMWYrLzBTdnZXTUl6M1d5SzZkL3d4UWZNUFE4MUhpcEVI?=
 =?utf-8?B?Mkh2Znk3Z1NQekp0TU15OFJYUG16QW9HNlk5eloyZTE2QkFxSnJGSTl6V3RH?=
 =?utf-8?B?V1hueTlFc282RG5JSWJMS0ZwZ2pUSlpIeVpNUnNmb1BZaHZxQXhLR3MxRFFT?=
 =?utf-8?B?eW1wSWFuTnZOdVV1M2prQndHOEhCdmc0R3dzRHF2cy9NL0ZGZ1FzUUt0YU1p?=
 =?utf-8?B?NjZRSWgrcVh1SjI1QWw3RlRiRm5jbkxSWEIxeWMvMG9HZm9WMDNPMko5cUFv?=
 =?utf-8?B?bW8xMjE2cUNoVmhoVXRRQkduaWVzV045Y1ZvVGxOamhNdkxXd0lHc08wdkVN?=
 =?utf-8?B?bTFGNmRPd3JRN3NMZktSOXk1UHp6VHVKaEdQV2s3UXNpWUxCNnhFR1hyclY2?=
 =?utf-8?B?TWw2dFVDaXliQS91bDNEK1cxVlRKWC9iK05LOHJMNEs2d1ZCYlpZL1ZNSHUr?=
 =?utf-8?B?YnVoQjVJRUZKUVRzNzNMbVgrWFdibHdtK1VmQUI1QjBpRXVGeHBNeHpXdEVx?=
 =?utf-8?B?WlV3NmNSMFJjS0pERzhmNFFvbHRrUCtDOVRxekxTckxodGJnSTk1UXRjTEZH?=
 =?utf-8?B?S1I2ZG5xMk1TWWNCUUdMVWtlazBUUzFUaEgwQi93N3VMT1A3V09qbCsxNjNz?=
 =?utf-8?B?M0ZkazZwVUs5ZkxPNHNLWFBjakNJeFF0eEx5NUhVNWRBRjloRlhYRnV5Yjhv?=
 =?utf-8?B?WmlHb2JwNU94cDBLN0xMQXJpNXljVldZVHJQU2w3WG1abWMxNzNhR1dlQzVv?=
 =?utf-8?B?K0ZhRm1lYlNFeC9QSktMZW9ScDUyT1U3c1RkMmh6OWU1enBjRXlUdThXdXE1?=
 =?utf-8?B?NlNMeW1acmdmSCs1ZGVNcC9MWmRDN081dWdTQ3RZb2trcHdTV3VWbDhESy9K?=
 =?utf-8?B?YUtBZ1l2TVI2Vk05ajIyUUUybkttVzd6WCs5Y2VoeHdSY2tpemp2b28veDBN?=
 =?utf-8?B?TC82czBHckpBckhLUkVHajB6elgycVB0YUdBYlBlbXBVNEQwZXdlRThOQXMv?=
 =?utf-8?B?eDFtSXc5TU1hRFErTUpYVGdEZE1ZQ3ovQWgrSDBqNjFOYnVPb3dJa2RycmJj?=
 =?utf-8?B?MW0rUzRjME8rNi8ra0UrZ1V2NnZ1cFZydVF0STB5UFF5R0RVNDdkME82NTVC?=
 =?utf-8?B?b1NUY2xrUTAzZHdReWlWSWZHSVFEcVd4aDJhbG5Xc25hZ2pYZ21vVXBwNERw?=
 =?utf-8?B?NjRTQnc4Y0JvcnRaeG5SOFNIa0NGaVQ3SFp0bDlLM0kvcHBXWEJGNWZvbVV4?=
 =?utf-8?B?NmprK0VkWkNNTEhjWjhPcUJHQnpFWUJtTytwTVhSTmpBUlJzbk1wVTBleEVq?=
 =?utf-8?B?Y2dsK0s5NEU3b0thdCtCT1lUTm9TcWVjcXpvUUg5S2xrVUFKMlJHTFVrWFdI?=
 =?utf-8?B?QUg3Yi9rSFRpQTZYNEFWQ0VXSzJZK0ZGNnZrVjQxSkVGRmdRbFIvQnBIQThN?=
 =?utf-8?B?bDlNZzk3NnBNVzROaDh1ckUzUkR3dWdQVEdMT2lxRWo2dTVJR0dmczA2STkw?=
 =?utf-8?B?Wm83YjFMYnlEQlV4cWFGQndTM0FER3ZyQkViNVJScUxuL0ZxOEk1UWdTTzJG?=
 =?utf-8?B?cWdoemNsWDJXWWFoZ2JlLzRTWWFML2s2cXFTOFJuZVdqUVc3Y1dQaVZYYU0r?=
 =?utf-8?B?d003R2hxaEw2RTRpTk5XdENJWTIzUjRJangrTmFYV2hKTjdNd1phR2ZXcDht?=
 =?utf-8?B?WVRwbFVEWXdWTnpYQlErWHJsOEt3WDVNRE80RUhBNFkrOXhPT0tZSEFSNXhW?=
 =?utf-8?Q?reca+78RHU9drGkhPG8aMHBPYhMc7N8JXtEkyJ6?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2a079b6-a88a-4f87-fee9-08d984588f2d
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2021 21:23:34.5114
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r4HloAMCzmm8U35XzFWEcAZ1CWfkVQMvhM6ofchWZfh5acKAJ7LsdFwb1nvHFea2BFBTyYQCohtHa9QFlS+Kgg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4388
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10123 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 malwarescore=0
 suspectscore=0 spamscore=0 mlxlogscore=999 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2109300132
X-Proofpoint-GUID: UUY-gj-5EIbFwokPnZFwDcfac-gJK6br
X-Proofpoint-ORIG-GUID: UUY-gj-5EIbFwokPnZFwDcfac-gJK6br


On 9/30/2021 12:11 PM, Dan Williams wrote:
> On Thu, Sep 30, 2021 at 11:15 AM Jane Chu <jane.chu@oracle.com> wrote:
>>
>> Hi, Dan,
>>
>> On 9/16/2021 1:33 PM, Dan Williams wrote:
>>> The new consideration of
>>> whole_page() errors means that the code in nfit_handle_mce() is wrong
>>> to assume that the length of the error is just 1 cacheline. When that
>>> bug is fixed the badblocks range will cover the entire page in
>>> whole_page() notification cases.
>>
>> Does this explain what I saw a while ago: inject two poisons
>> to the same block, and pwrite clears one poison at a time?
> 
> Potentially, yes. If you injected poison over 512 bytes then it could
> take 2 pwrites() of 256-bytes each to clear that poison. In the DAX
> case nothing is enforcing sector aligned I/O for pwrite().
> 

Thanks!

-jane

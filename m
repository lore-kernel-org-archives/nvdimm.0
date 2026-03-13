Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012065.outbound.protection.outlook.com [52.101.43.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC2DC23BD05
	for <nvdimm@lists.linux.dev>; Fri, 13 Mar 2026 12:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773406461; cv=fail; b=iczAHmq48Szz3tLGlfkUDbztAzbHtjiBr79HlcMZyTezb1BeBOE0nlSeVx160ONfMJsLodJUESzM5vK25qivzNoxDbeC71oBnHSfkG6//BTIPf5MhJA4PfGKDxZz1C+wgE/6HNcf/Lhnf+j+JpsBTWhjhTyt7NTmFjxzQSlEVwI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773406461; c=relaxed/simple;
	bh=2o0xdrvjdSR1W/I6SalQfJA1XvJVN6ZOpks10u8UufU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=VaibRk/arbUa2RWD9Thp4u5aybdDQIFi6zBMMoJLDblf3joTpRjthnxPYxJ78DYGF5ufegjusuv83/MHBb9xQBufEpjbONICjotuQki4kpzBwaAZM+jVSRYMg+SoDtd9GsL0tPS9BSO5UQlWJ3GVm2kF2y0ChX8ZBdjOUUmDg0s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=tgTxMbKg; arc=fail smtp.client-ip=52.101.43.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="tgTxMbKg"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sgqSUJ2YOfxwjcqr6w+FTSfqwJATQ+BIjzD1CaFTVi2P0IbMvmEP4IDseVpC17mefTVLJqoymYBEqMxmJoVO+w1tFXelwdbg5YNxnza3kC9KsXNF9p2b+Frc0s/lunVr7WTxCUO60k7Q+QaK93TK8jvvtdyq8mCBp+uaAKPThyXzEa8ro5XFF7XQtNuEqGBo/81OZ5K0Bj1Wv3aMrPYXvQ2maT980bf94kF6jvxk/aifn0jQ24+uebEFgMfrohYM2hfNbW+I4brdt4IDn/DkeimzzlhiijgiaCnqj0qtBK2pYo7Xatc7nlqdDjrVtjfefmLcZk6h1hvRcLjBSSCoMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=stykDgImBnyziJ4nSqKpMElUS+cBZeUVdV12XyzH5PQ=;
 b=gaf/zc+Vj9+kz8zBgsBdzQzg27qpN9/xV+HDcmaUWBKMLEm3+8/SX41AidNxTaUULROik/uP9aHlQUmwKkkhWtEqZlrJRhqXf57/xgmh5l7PJ1j0nCVzyHI+/vk9ZR9JnEB9vgz3jVTC4mudAueew0crxyYq1pkyy4kFMorrcOmnr1krT5eOLKzrMgRtF/4DRQvHJ4bnSw6aqzaYLuSLEqh99ZZ7B/dd7Cd8w1vgbTdzRHy+Datv0kD7pvH6MNV4E8ah7Lu2rEihjpcyn0+fyBTCLMG5t8dtRqMbG2JfndvCh1tmZ1ABD5awomfo4VKbcDJFwq37E6x5oAg1S/Y/1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=stykDgImBnyziJ4nSqKpMElUS+cBZeUVdV12XyzH5PQ=;
 b=tgTxMbKg9LQ0gTgtRZCwn0UFBgzuM8h95T4YPPLnfZxigZFkVJtkldOdbipzAHVtVU/B+FYxhJXbxflTW7KmtWBa+UE0c/YzGcRF0DLLjhJWOoydJTAenLT6xEEytbs6pB1DFmJjfom+rm9KJf33m+QYetzduP2W4H9RYUVYEEk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM6PR12MB4202.namprd12.prod.outlook.com (2603:10b6:5:219::22)
 by CH2PR12MB4231.namprd12.prod.outlook.com (2603:10b6:610:7d::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.8; Fri, 13 Mar
 2026 12:54:16 +0000
Received: from DM6PR12MB4202.namprd12.prod.outlook.com
 ([fe80::9e55:f616:6a93:7a3d]) by DM6PR12MB4202.namprd12.prod.outlook.com
 ([fe80::9e55:f616:6a93:7a3d%6]) with mapi id 15.20.9723.000; Fri, 13 Mar 2026
 12:54:16 +0000
Message-ID: <df9cfac5-7e01-422f-bd29-d1b8b3c55623@amd.com>
Date: Fri, 13 Mar 2026 12:54:08 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 3/9] cxl/region: Skip decoder reset on detach for
 autodiscovered regions
Content-Language: en-US
To: Dan Williams <dan.j.williams@intel.com>,
 Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>,
 linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-fsdevel@vger.kernel.org,
 linux-pm@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
 Alison Schofield <alison.schofield@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>,
 Jonathan Cameron <jonathan.cameron@huawei.com>,
 Yazen Ghannam <yazen.ghannam@amd.com>, Dave Jiang <dave.jiang@intel.com>,
 Davidlohr Bueso <dave@stgolabs.net>, Matthew Wilcox <willy@infradead.org>,
 Jan Kara <jack@suse.cz>, "Rafael J . Wysocki" <rafael@kernel.org>,
 Len Brown <len.brown@intel.com>, Pavel Machek <pavel@kernel.org>,
 Li Ming <ming.li@zohomail.com>, Jeff Johnson
 <jeff.johnson@oss.qualcomm.com>, Ying Huang <huang.ying.caritas@gmail.com>,
 Yao Xingtao <yaoxt.fnst@fujitsu.com>, Peter Zijlstra <peterz@infradead.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Nathan Fontenot <nathan.fontenot@amd.com>,
 Terry Bowman <terry.bowman@amd.com>, Robert Richter <rrichter@amd.com>,
 Benjamin Cheatham <benjamin.cheatham@amd.com>,
 Zhijian Li <lizhijian@fujitsu.com>, Borislav Petkov <bp@alien8.de>,
 Tomasz Wolski <tomasz.wolski@fujitsu.com>
References: <20260210064501.157591-1-Smita.KoralahalliChannabasappa@amd.com>
 <20260210064501.157591-4-Smita.KoralahalliChannabasappa@amd.com>
 <69b1e0aacb9d0_2132100c5@dwillia2-mobl4.notmuch>
 <69b319d7e6adf_213210086@dwillia2-mobl4.notmuch>
From: Alejandro Lucero Palau <alucerop@amd.com>
In-Reply-To: <69b319d7e6adf_213210086@dwillia2-mobl4.notmuch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0026.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:151::13) To DM6PR12MB4202.namprd12.prod.outlook.com
 (2603:10b6:5:219::22)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB4202:EE_|CH2PR12MB4231:EE_
X-MS-Office365-Filtering-Correlation-Id: f0462993-0ef8-422d-81a4-08de80ffa203
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|3122999024|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	vp68FDkazYhrRxG2qQdlMh289dbrSInptwfAzc29HAecKN26Vw7Y3L013h6dEU9tLU313f+Bzuo5UX/0ubg4u32/Phcn//DoqP9RfqlyD5NqID/KQZMCzVrkagD/soXdatExiLUioiBigzLdrO4NzsgNLUkXGvhCjroQkBDl1XqtFDa4vt0eVd45udxgDEwJ2VZ2LbdT/3Yy4sQGO6mCCgFjovTZ4Xu0ravLstNJuaaTjsCVI6Lf80DsT9PSB+257N70dKi/lfaPBA79aecUU2XXg+ADvVzDyTAX8IkEQ3lIeE1yoI7TKVrKyAhiRq6CC0SPq4PJOrdlvrC4Zb3UJMHlbIwizU71yVaxOqEMiDPgpc4UdIh16MhS9UbP6WpdL4ztbJ/8v6LSnGXoyKxBkQoD8nv6ZeDY4QkaBQ5+Um+dvzzrMI4mAV/K7aaoQzK5zdRdDVLPvIKg1A31Gs3p4ave31/aCHlHXY9fJ4xSEFoIwfslJeh8a3EvAlSxXx1nESAO5j4IXddaLwhHxjDPW+EjqdAFfT7K2RXdXIZSRq8CTtG5FJhwevzX0dVT7fDluuAYwXEa59GE1r2/46zDTPaWiLvE/l0jnT8YX4oUxfOBcspTOxTHdDeKezxvqTITflQC7HU+gpfIGJERISQSc4mPGD7YtmHq9fp1O1VBg/lc8iWcbAfVCXUwDXS6YPr96htcU9pukmYAPSpabdTOSrDrt7meKC8U/eWVp7YuxCs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4202.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(3122999024)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?N3Rsc3JIejZMSHgyZVlpTDFFczhwNXVFcWo0WlR0VzFtZkVoRzErTDlNc1ZX?=
 =?utf-8?B?c3AvZkZQdVEveTRJemFPQklKSWVrVFFxR3UxcWNUL3ZXUUtQRkJLYWdnNll3?=
 =?utf-8?B?SnAyMzJaOHFYVnphcFNRTVFGQ250RUExeGhVYWxFWTV4eGpUU2JWOElLOEkw?=
 =?utf-8?B?WlJHNXVDc1p2VlRRZ0Z1TlZ2QXNZS2Q5STRUVjRSL3JiU1RYb3ozbTQxZnIx?=
 =?utf-8?B?eCs1eDgyWHorbVMwc3FKSitFWmFLUGJDVTFWNTZpQllnZ2Z0YnZPMG5SYTlr?=
 =?utf-8?B?ODFzVmk1NkZ1cHhZc1hXR3phT2tJTmw2M081Nm4wZTcrWnFkM3hmNFlQNTYy?=
 =?utf-8?B?dUlpNVZGWDdrTkFUN1Q5c2Q0Z3hjdFIyOEZqV2VycXdxcUJFdkpSY0FOUjlB?=
 =?utf-8?B?Zm1rYUE3SG9Hc3JGcjdLblBOSk1SaWlPeEYxTVFSTm91ZUVZNGc4QSt2N2F2?=
 =?utf-8?B?Q0xNQ3J0V1ZnK2I3VDV6UWducEhqbTU2NGVxKzlSQzYvQ01vMTZxRm40bGJo?=
 =?utf-8?B?T3hJSjVNb1hTdmJQSzkydmxUYThWSnkwZ21SSWN3bEwvKzdIYnlMaWtmZXFD?=
 =?utf-8?B?N1I4ZFVNcGlvYXpvSkpiT1N2bkh0OHRUYll6Vzd1dHROS2dBUnM1dmFnNDhs?=
 =?utf-8?B?Q215eXBVNVZEOEF5ZStYV1BNVDZzYWUvMktZMlg1MmZhNWNWVm1zRUU2TldM?=
 =?utf-8?B?OVFnOUw3YmlFb0FJWXRRQ3pCMmNWYVdubUhHOENzazFsVm9nQWhpYXZYdDd2?=
 =?utf-8?B?UzRVQ05UUnJnYlU1L2dKM0xqSGtURklQbVltaHp0MHBBOTdUM25UeXMzckxK?=
 =?utf-8?B?YmJmL2Y3cGhtaDhKOURIU2xzVXN6OTIrbkhRMkUxOHhxTnFHd1Q5Rm9lbDlL?=
 =?utf-8?B?VkQvLy9aTkZOajhZQW1PaldqcmFUVHVZRWUwWW81RG03SHFtd0Fyd3hydzRq?=
 =?utf-8?B?NmQ0SllGaDVhOVc2bkY4OGZmSmxuSWJPOU82WVdMcXl3ajR0bkltR05EdDBT?=
 =?utf-8?B?aWRTMHcxcWFBdzMvNmROVjZVTm9yQ043SWZJWmxFRnAyUE1PamJSQXQ5eWZ4?=
 =?utf-8?B?OUFYUGxzSTRqNkU1ekF6RFZ2aHkyQkdsR1FMd0w3T2NPT0ZleFQwc2hnWnlu?=
 =?utf-8?B?V0NmWjZnT001cFNjTlFncDJlMjlRQTVRM0JnblduT2JjOXNuZ0hsTGp5d1BE?=
 =?utf-8?B?WFNiQWxRdjhPODUvVnoweW5keE81d1RYYnBac1JIV0R4MCs2NkIvbzdmZnND?=
 =?utf-8?B?QUZuVzhxakhPdTAzdFBsNW1jRTlrcUJhQk9MNWxiKy9lcDhzbEU0ZGIzZVpU?=
 =?utf-8?B?QlJ5bE1pbU5rNXd0TnBHdWRHR1N1OVJYOENURE1uWjJYOHA4aVZKL3pqSUMx?=
 =?utf-8?B?QlZVNTJrc3FrZS9qb01PbENqWmJybWlJeXg3OXN3U1BQZmdSWEp3Q2hpUDBt?=
 =?utf-8?B?ZHFsL29qNlVXbUduNU9PMHNBa1JIcHFFc0RkZmsvWTl3OGtmOHVUZ2NieDJs?=
 =?utf-8?B?ZGlZMWhCT2NaUzJOY3dMa1lUM3RwOXo0eUY0RlBzdlZjQmkwZHg5U1VZVU0w?=
 =?utf-8?B?Y0NTM3pXNVVWTGFRZ1hIcVdkSis5MWFsT09GcndOdkNSUDR0ZEwwZ0tmSDBO?=
 =?utf-8?B?eVlMeUExNTBkdjIwNHgyQXhURk1JSjB1K3FoZGlkb3ltdUwyVHNVbTkvbGdn?=
 =?utf-8?B?aTN6TU8vcmFSc3B5bzZ1WFBPcVl6NGR2V04xWThOSXQycm5vamZYVi9VazZt?=
 =?utf-8?B?NEE3RHNHRXNTaDJSaW1BZkVMRzJPT2JaNVlySXp4blFNb2xrS28wQ2I5bFlF?=
 =?utf-8?B?WmdxRUc5QXNiUXdrL2lnd2lJQStWRVppYUE5bk01MEpGMGJsWTVFK1BPM3BK?=
 =?utf-8?B?UU44ZnhwTXplY3FZcGpRSGhzRkdNdnZiR2s2ZzNidEpqUHBwbHJ5Y2lucFQ0?=
 =?utf-8?B?QmNiYlZWZEVHamRKTUtKRVQrMWpuUFFpdHJaRW44WGZNUFJOaHBla1VTNFAr?=
 =?utf-8?B?ZXlkeWxMZlh4dXZtVmVwdW8zek0xVWFyT252bTFma211cm5jR0haU2tPaTF6?=
 =?utf-8?B?L24zUUMzVDZqaVdqaVUxdG5wQURrT0dQS25yR25JMEk3TXdpcjlKcklSSDNK?=
 =?utf-8?B?dytpUFVyWUNnWW9TaS9qdWRCYzA1Tml0YTRZeTFXcmdWMlZNNUx1bG1RWGhQ?=
 =?utf-8?B?R1RXRENhSFRPKzUrSHl2d0o2eU9rN2NOYXM3bExvTXo5VU5oTHlsdkV6b1Zm?=
 =?utf-8?B?VVduTmY1RklZWWpuanFvN1ZyN1FaSzlobGlOczhZWXJwVytWdlcvRDNWc1gx?=
 =?utf-8?B?QXBrUlRSTTMxajd6cVpKODhudzF1dHJ1b2h5RzN5TzhKVlhYUXUrQT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0462993-0ef8-422d-81a4-08de80ffa203
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4202.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2026 12:54:15.9865
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w4eaJdm4pA2d0ZAJUJFhnniX0ufpednuRmp9dmZsWr0opDZ/2gmuE4+FWSZ9yJXGxiELYhbDaAwkEF5K/tpIhw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4231


On 3/12/26 19:53, Dan Williams wrote:
> Dan Williams wrote:
> [..]
>> All of this wants some documentation to tell users that the rule is
>> "Hey, after any endpoint decoder has been seen by the CXL core, if you
>> remove that endpoint decoder by removing or disabling any of cxl_acpi,
>> cxl_mem, or cxl_port the CXL core *will* violently destroy the decode
>> configuration". Then think about whether this needs a way to specify
>> "skip decoder teardown" to disambiguate "the decoder is disappearing
>> logically, but not physically, keep its configuration". That allows
>> turning any manual configuration into an auto-configuration and has an
>> explicit rule for all regions rather than the current "auto regions are
>> special" policy.
> Do not worry about this paragraph of feedback. I will start a new patch
> set to address this issue. It is the same problem impacting the
> accelerator series where driver reload resets the decode configuration
> by default. Both accelerator drivers and userspace should be able to
> opt-out / opt-in to that behavior.


No, that is not the last accelerator series behavior, and I'm getting 
more than frustrated with all this.


FWIW, Type2 v22 had that behavior, but v23 kept the decoders as BIOS 
configured them ... because you explicitly said that is what it should 
be done.


Now you are saying that should be up to the driver to decide, if I do 
not misunderstand your comment above. And of course, you are going to 
fix that for accelerators! Your patchset will be high priority, just to 
the front of the queue. Understandable, you are the maintainer.


Let me tell you what I think.


You are mentioning the accelerators problem because it suits you. When 
it does not, you usually ignore any type2 support ... until it suits 
you. Of course, I can not tell you when to look at type2 patches, but 
you can not tell me either to not speak up about something seemingly 
arbitrary. I'm defending the kernel upstream process (in general, not 
just inside CXL) internally and it is hard to back that up when I have 
to report what is happening ...


This is my advice (unlikely to be followed): do not write that patchset. 
It is not needed ... now. What is needed is "basic" type2 support in the 
kernel, something as good as possible but not pursuing perfection trying 
to think about all the potential use cases. In other words: usability. 
There will be bugs (hopefully only in corner cases), there will be 
unsupported scenarios, there will likely be misunderstandings of what 
was really needed, but it does not matter the clever you are, you can 
not solve everything now. Guess why: you need people using it with real 
devices and real use cases. If we want CXL to success, what is in our 
hands is to support it as better and as fast as possible for those 
vendors betting on CXL having a chance. Usability, and usability in the 
current scenario where systems with accelerators using CXL will be 
mostly alone regarding other CXL devices. Yes, the future will be 
hopefully more complex and we all working on CXL will be happy then.


Dan, I know you are not only working on CXL, and for avoiding any 
misunderstanding, my rant here is not about your expertise or knowledge. 
It is obvious to anyone reading the mailing list your vision and 
mastering of CXL and kernel CXL support is superb, but I am not happy 
with how you are managing certain aspects of the CXL subsystem/CXL 
community.


This is not the first time I share my frustration, and as when I did so 
in the past, I want to finish with a positive last sentence: I will keep 
trying to get type2 support and hopefully further CXL stuff, and happy 
to discuss the best way to do so with the CXL kernel community.


Thank you


>
> This will want some indication that the root decoder space is designated
> such that it does not get reassigned while the driver is detached.
>

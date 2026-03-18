Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013033.outbound.protection.outlook.com [40.93.201.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B384361DB3
	for <nvdimm@lists.linux.dev>; Wed, 18 Mar 2026 07:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.33
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773819222; cv=fail; b=WB4TiWvBltXpB3HtDYQ4jYMORUI7LVj3OZdcZeFx85nTFC6UE5vY/5PG1tpAJe9/7hcTetBybXUxeUvVbyXDLNYJ0cu7RgbT/uly5+98EGladheJvmxS62dSUJAOXtwRZcPPjpcFvLydpv4gKIHUaZ2jclr8nnhWbtsv4ULrh9E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773819222; c=relaxed/simple;
	bh=xCCrNIQa8gaPoYoiOm3kT0XvRKxXbgCLZAcoiUJCOB8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ddvn3EQV/NCUiLoO3iCOxgRDHDYARswIOT1c7ttC3lYDJNxaRDGH23+DkrGLSROUJgEXokn/aHKFDdyT/xzdNak89RJJbSi6/kz91J18BO3YpbmfVnhzdfIfYOJiOW4VaidjdRRacIccUvi1KhyQPPAwxFnU/01cSMZkU3UCd8Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=cn0NwIi3; arc=fail smtp.client-ip=40.93.201.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="cn0NwIi3"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LNgkbOkoNX/HdWAnSgnSh9zwXBP9q4zLhlJDNTS1Fs7O/wBpPbG0aSoQPdGA9Nqe3qGXezCNlfQ7E5OzIh4OtpHAAvXWeR6CXu0Ka3aAtSCHxdX/nX3Sxt/w9f/CRQHH6Qaje7ShR1eFr37xaWgcMHStAjtacndKyY8ED70UGIfICDIeSVu1eDDHm/1zc2YkwlGu8PbjzOo1jKJONlkzyysh3b6RdWAG7eUHfpuaZCPHroup2SH9HUVCL9fBs4HxcdmJ/Zrx3e+Q3ghHUDTHypdNo9+dS17Z7jgJ5zAqboizD+ZuNltr/UsLzd41Ewfg4y74vTpOXJEbx9oQUSmaIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RydDN5BPkzHnP/d5C4kdjGtpmwbWIwng70V0TVWpjPg=;
 b=AVeleKKFnjeNL3gNYzr4vtsYhCL5N1Ap4zlPj91WWHMLI8ULFxvKgZMitoPLlxzyj8mTsHLVcIKdTD5ynX/8kFL2DGb9obqdqUEu1cr2Gx5EFh42fMaqAObvy8IizydR5Do80WuPv9owx7mw7FefGxNdtesclVcP4e74CeNibiVAvY03R9MEfsZuRZHbcC4E4kmHX0cJ+zIHPqC/xlQf0Lnnpbx0ocrl7q4E0yOPbJGkol48z7neqfeBdHBWfhx3RQDbzoaMeZm5tEyjB2mSPhAPUUFDZ48YVdiZ8gmYtzJ4cuoUAB6HnxYcECtayCgqGXpypnjQBJGzZNjWnWWQog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RydDN5BPkzHnP/d5C4kdjGtpmwbWIwng70V0TVWpjPg=;
 b=cn0NwIi3p7uleLpfInLco773DJ4x8uu8XnaweDXln2CRU0aZ6LNrf+RLv0djr8Fv/evkyY8E9IdC0UTbJkGKw4Ujs33Scuh44E1TWr51F3x6ty07KygFYmusPPLMTDMZlUvkBsBhBRvTQPIAUFgU/aaiS5PI5WXx65XDjUzlE18=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM6PR12MB4202.namprd12.prod.outlook.com (2603:10b6:5:219::22)
 by DM6PR12MB4468.namprd12.prod.outlook.com (2603:10b6:5:2ac::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Wed, 18 Mar
 2026 07:33:38 +0000
Received: from DM6PR12MB4202.namprd12.prod.outlook.com
 ([fe80::9e55:f616:6a93:7a3d]) by DM6PR12MB4202.namprd12.prod.outlook.com
 ([fe80::9e55:f616:6a93:7a3d%6]) with mapi id 15.20.9723.018; Wed, 18 Mar 2026
 07:33:38 +0000
Message-ID: <718c4a39-4526-45ed-86fb-1e5b57f6ca0e@amd.com>
Date: Wed, 18 Mar 2026 07:33:29 +0000
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
 <df9cfac5-7e01-422f-bd29-d1b8b3c55623@amd.com>
 <69b8b9181bafd_452b100cb@dwillia2-mobl4.notmuch>
From: Alejandro Lucero Palau <alucerop@amd.com>
In-Reply-To: <69b8b9181bafd_452b100cb@dwillia2-mobl4.notmuch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0417.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a0::21) To DM6PR12MB4202.namprd12.prod.outlook.com
 (2603:10b6:5:219::22)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB4202:EE_|DM6PR12MB4468:EE_
X-MS-Office365-Filtering-Correlation-Id: ed09e57d-41fc-44b9-4023-08de84c0ab1b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	OWntvHGjHoWxvC/Jsr6wNgq4cybm5UK+qqfXCG4l9vlxERSpkfRGQU5Nf3arcHw35HJUIg82hQAiT22kUDWIoMWHTVHfH0v53wnWiVC0USxzVsuj9+yaD27nlhNQCStCt8Tt6KyVbVRoZ7pC7opfgTINWWuvd/BI9kRp/jXfuXGz5GdY/jWokWytZPXvjHYvOgFZAID6k6BPAyzH1AyZA22lrQGGJTLKkYSTnFBfo1OFQ9fTgoL75SDlw055VlgQzTjvti6zNMVzPYJJw0KwF2XRNvbWuJWsfXDz5d71v5/5o0Q2VsPSH4HHY/a82kFnPqx2/Ta2zn0qgoA3tkSa31Y0QtGg08cRbGvjAZKQjRPqpxB0pPLM9O/fs7D730WjP1Qu56A1XTGZ/mx6rhVfyXUW+XCl89MzrxiSAF43pcmlD+R+PH987zkP7o9txyVba1HDIN86w76zYJ1A+uTF9Qf2ParW0g5Bz/2odfbJ4HY3Ez0wOHMaI/h9niKnwQwONDbxRPvtAnCk4DO0/7zvBqmYtuY7ry4b1leCBM64jJK7w4MQxNp2fWou471MR5aCqj376QbNv5N8BD1+xty2PKNIDGlVIqgK1ZgxTIHaJNPPxsngJRtsnJXafBsoHKlILsFToPzptjNrNteHSd/9jCwHfm0IwemLOR3o1lWFFwCDb7XGaCDYrut8ZRA6aihLB5nezwsk5ghffBF1EJ4dEMkfkUMix97n26cAPB6AuQk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4202.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eTVpanlEOGZmYVJTWG15OGdJNzNNcTd4N2t0aTlxNngvM1REcjFmSnRVNS82?=
 =?utf-8?B?UzAzVHVJY2IzSW5LZkREN2dJUGVscWNIY3g4c0pFczJOTXdMVVBuNGI1aTNQ?=
 =?utf-8?B?cVVxcmpZYUkwMGVQRFZJZC9jRk1scTVtRjQvZ2NjUEo5azhjMS9Hbi8zclF1?=
 =?utf-8?B?R3k3WUwwWHZBekw0UXJpSlZVTndKZWFMc0NFc0hMQnpUU2NmQ0xKQjN6U1NM?=
 =?utf-8?B?OXhtak14QzN2azBPdmcrYy9SbjF1NWhIUFlGa2dONDdZSHRyYSs0NEVCaWNu?=
 =?utf-8?B?YjAreW5DRHc1dnllU2tMR1A4VGlpRzZtQWlVOWd6LzBvU3Nvb0t3ekdmcmZl?=
 =?utf-8?B?SzdUWnl3cGNJOGw2R3Z1VVhoU1pEayttZzRES1pUbjVUbHRrYVhuRUxlV3Rx?=
 =?utf-8?B?ek1DVDRiVXk4NkxZWlJFV2l4bXhEdGg4ZnhwN21hL3JiU09wMHZnQTVwOEVD?=
 =?utf-8?B?UXhyZjJBdHBOWWFZUDBjbE1qL1NPdUJFeUU2aUU3U3kwSklhalVBZUF3dTh6?=
 =?utf-8?B?Q0JpQmZMS2EyVWxjZnM1VDl5ZlNIU1dybEh1SlJ0aHI1ZWZnRG5UYVpoQWps?=
 =?utf-8?B?dklnczhYMUhNYVF5ZE5idEJoMER1TVBQcjdHcFVUT04vNnVKclZGdXM5WjBW?=
 =?utf-8?B?RDNDdjE0ajM3bmdjRGZZTWRTSHlkOHJBd09PVU5PeHhQNHQrdXVPZHRaK3dx?=
 =?utf-8?B?L2JEVTdtK2hSREpkTFNZOVVLaEZPdyt2RU5xUjhUekE1REU0NTF2Y2R5Q1Ay?=
 =?utf-8?B?OHEwb29Nc1hHOE1DdFNKd0dBaG82ajQxVkNncTU3MThtblg1RWlhUkc0S0Nx?=
 =?utf-8?B?SXZ4SEw5M2xmWENJcUFZZkdONGRZWnIyelJ4VUdBVXhGRGcvckZ5elp5Rllv?=
 =?utf-8?B?MzVWQ01jc2lUa1krN2JUeEprYVl4ZGg2RTFmdUZQTnpLQ2Vrb2h1QzU3LzJU?=
 =?utf-8?B?SGNCcXpaem5tT0F1Qm12R1gxS2U4QlJHWVgrb3VhR1pzWmdmaDk5WjdZbVY1?=
 =?utf-8?B?ZnJld2s3S203TkZmWE5EZWZYZEY3YnBML25PZWZXczQ5cGlhcGhMTXM1RU0x?=
 =?utf-8?B?ekZnMytzV2grYmtDK2F3T0hmZjJUMWcrNkYxcU9FRTlpVEpMTnlLcklHMHBn?=
 =?utf-8?B?RDl4WmVBRGI1QmIxbUdsYkFsTmVOYXROejJiRWRndVYyMkZIQWQxM0d1YWYr?=
 =?utf-8?B?ZzlxVVRWNk1tOVhEMXRaVnRzUlpKeElXUWxRR3cvRW5ZNUlJRG9HTms1SVZE?=
 =?utf-8?B?WjRBNjVERW1kd0JhWUV2bUltMFp5TTdkeWZGTUtCa0JLL0RrSTVDOGMxRVcr?=
 =?utf-8?B?NGZkUU9NQmJ4dktPdzJSaXFadmswVmZjU3JsS2hKL3BpQ2xpbzhBQW1rZHNw?=
 =?utf-8?B?ZmZ5U0VacDM3VThmRld3SWdCZkV2MTR4MkhySm85WjJPbzBIQUhaYURQaUZx?=
 =?utf-8?B?czFNS3ByQVBvaE9lUjNYTk9IRkJvNHZXY3lUT241NmtsWTh6NnZMYS9KS3Iw?=
 =?utf-8?B?NkgwekpPYks2bDFxWjRjZHFZb0pBVmJTeXYrQXAyTGZsRXNUYS9WZnplVks2?=
 =?utf-8?B?L1N2Ny9kS3NGTVdmTDluZFM3MGRQd3ZQdVZNOGNVVGprWWs0d1ZqQWluOXhk?=
 =?utf-8?B?Mitpc1BqVnltWHJwYjNGMXlUbW5vZGsyTGRtM1d4QVhrSjc1MHg0Q1JXbm9y?=
 =?utf-8?B?V3c2dk5yV3VnazZoWnRIYjgwaUNLWElzdDh0VkdHZFJ1bGppWW8yVHRsNFAr?=
 =?utf-8?B?TE94VWRJcmtUcXYydXJyZnhKQ2lSME05T29rSmt0dytwSHhqR296anlCd3Z1?=
 =?utf-8?B?VWhGVE9rdCt4dlc2MUdtZjBkVjdlYzlEdFJTUDVwTXoxR2FnRFZqbVB6S1Zu?=
 =?utf-8?B?Ynowa2hxNWwzK3NYQXlXbE1uVEptR0xNTXdZOEN3MFRFNjZ2c1VPRm9oYk1M?=
 =?utf-8?B?OFRJbWQxamxEbWR6RUFJTFJoOXk3SzUwdlhqS2hIQ29YUUpWZlFaMzdyNnl2?=
 =?utf-8?B?NzBleDNsaml5NXpUN3pwZ09pS3BGeis3dDh2b3A4dFBkTEU5M3NyQzE5dFFo?=
 =?utf-8?B?ckQ5N0JoK0JyRUNQNGtiT2hpdnhrYmpNVStlNkRBKzdWamxxdktTbnJjNWs5?=
 =?utf-8?B?YStaQ0g4d3JkWWlock9na0ZYbTEwS0tDaFhmYjBhdlhCZjVnYzY0bmNSZGZk?=
 =?utf-8?B?K0cvT3VMd0N2UnBwd1NjejJmTjM2d1pVWGRzU1NkSmF0SFZXOGF6WFBhb0ph?=
 =?utf-8?B?VitYb2VmZU05aWtsQlZ6TlBncUZyRFhPa3FHZWZMYldjczhoOG1CbkdSNzEx?=
 =?utf-8?B?UlZiMXdlWml5YUFFY0JmdUVLK3M1MzRBL0l0dWFIVEtIWmVMYWYxdz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed09e57d-41fc-44b9-4023-08de84c0ab1b
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4202.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2026 07:33:37.9704
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: broX++ARBtDIAcaUsMzOJ7NH38IXvktz+91S2OdKXld62VJ9HAI6NtdFL5iXxc2jFLwLyqozCAmWHZ8PfcUkPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4468


On 3/17/26 02:14, Dan Williams wrote:
> Alejandro Lucero Palau wrote:
> [..]
>> This is not the first time I share my frustration, and as when I did so
>> in the past, I want to finish with a positive last sentence: I will keep
>> trying to get type2 support and hopefully further CXL stuff, and happy
>> to discuss the best way to do so with the CXL kernel community.
> I did not mean to imply that the type-2 set was stuck behind a new
> dependency. Apologies.


No worries.


>
> It is next in the queue, it needs to go in next cycle with a high
> priority.
>
> In my view this confirmation that Smita's proposed patch addresses PJ's
> test failure cleared one of the last hurdles for this set for me.


Did PJ tell you so? From his report that seemed a likely reason, but he 
did not comment further after I told him about it.


Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2071.outbound.protection.outlook.com [40.107.93.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E03F9253F31
	for <nvdimm@lists.linux.dev>; Wed, 19 Mar 2025 12:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742386240; cv=fail; b=V7uuJCjsvZSlXZXMZpliuXFvFcVqVTjwk+jU7EXrlbXXTwNkzv4m8Qn4E3IhMhkvtgarEjNUsvy9uszWxlbNRHQA5Zz+jFta6/ifxyV7nxNqMhHUR4/Z0BHJzvlgy0ur8Zem81sGEaMTXuQO+kgr1Lpv+8f1nF4FlJaL1rnyMUo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742386240; c=relaxed/simple;
	bh=CDMuIJdrcNz8NIVJj32w27KfHB1/sTWUlKeWmJcRSk4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=qi/o2shAD3vD4abCx1Lj06rF7GMCq6p8xG9ZfFCy7joyuR430ybNJW3kceS9tBB3+NnIBF/0vCcPOOMA/oWf3zHaM6UEGiczecb+UfXk+YM5Nser5IwaDCVy9ciG6zEFHAIxQSA4MEK1ihvIX9RoIiJY1BUgXfdA1pxh8QxAApE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=3I4r32l+; arc=fail smtp.client-ip=40.107.93.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="3I4r32l+"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lL4kKLaUr+EG7FveiSPzGvG1IQlgRXJy7ZOHgNvB7cxYXuUeRnd0uUWYPO6vaxeoW5juMlq8aizheE1KDC2HnFS5iDIOTCm9xkbkHgjYoj6vlSC9/FH+omNKrnGdGURHSMHHbdz2gNeCsySb7g9ECo52PgYLsple/CrKAEF/z160cN+39y3g4veouLfMTWKne/XfCTFgXxjXOmASaes4q4VMUxJa8dT7FDp9ZGuIfQNNoqRG7gv14Ur+GIjyZLXrDNfRtd5E10B6VUz5dt1JOyrKSPga+0B3INtCQ0CVfY2rZp03dSEdDIiKvL8RWVTCX3mUi0gWUZPT4usz9NDi5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eW6PCWaCkiHQ20Q9gL3GItcfyDiCqMLXAf1oFh/YWGU=;
 b=b0xevVX45IApcsXJT0vLPCqFkGrxnn/6Db3Hy4fjt8pObau0nXvQRo0aDIAfI/Cjjnd/MvPpttjAlo8arzzxAIPq4WqnvPSwzVLqLUgTFsgy2cL24ZtX7UqfkCKcjAO/ym51R+VgtJWXdthCErcAX7y73A2JGmEtFnpn1m5jUBYxOTTTMbAsMhf50YEYzrdz3k7s/PtdWtifZGMWBudf7jFax3j8owNEMaXTfQKRGYbYKymztfRBqWYvUT77TdgkKdDYb9pwIGp2BU1cRraLGJc/MLRp46p4/8aFGv0oym0mbLdVtriAAcs3nw1rIYM7RQRXLfSLEopSRrLe1aekoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eW6PCWaCkiHQ20Q9gL3GItcfyDiCqMLXAf1oFh/YWGU=;
 b=3I4r32l+S/ZysZLPbBzq427UXp3hqhQSfAnXSugOSvxTVyIlyfCKYNWnfVzWoqgHj63EnRdzpVP9BgKVksLivDxULUMaD/nXYsCCbRwKTzNE4P6aesZf2wj4Zx7/KotpfPhIkWYDJ/JAwTI/+lx4ANS/fuPvY8SEssoOJbYg3WY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA1PR12MB8189.namprd12.prod.outlook.com (2603:10b6:208:3f0::13)
 by DM4PR12MB6614.namprd12.prod.outlook.com (2603:10b6:8:bb::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.34; Wed, 19 Mar
 2025 12:10:35 +0000
Received: from IA1PR12MB8189.namprd12.prod.outlook.com
 ([fe80::193b:bbfd:9894:dc48]) by IA1PR12MB8189.namprd12.prod.outlook.com
 ([fe80::193b:bbfd:9894:dc48%7]) with mapi id 15.20.8534.034; Wed, 19 Mar 2025
 12:10:35 +0000
Message-ID: <0b4c082b-8f10-4a6c-9998-4c0b456c00d7@amd.com>
Date: Wed, 19 Mar 2025 13:10:30 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] libnvdimm/labels: Fix divide error in
 nd_label_data_init()
To: Robert Richter <rrichter@amd.com>, Vishal Verma
 <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>,
 Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
 Jonathan Cameron <Jonathan.Cameron@huawei.com>, linux-cxl@vger.kernel.org,
 linux-kernel@vger.kernel.org, Davidlohr Bueso <dave@stgolabs.net>,
 Gregory Price <gourry@gourry.net>, Terry Bowman <terry.bowman@amd.com>,
 nvdimm@lists.linux.dev
References: <20250319113215.520902-1-rrichter@amd.com>
Content-Language: en-US
From: "Gupta, Pankaj" <pankaj.gupta@amd.com>
In-Reply-To: <20250319113215.520902-1-rrichter@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0019.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1c::6) To IA1PR12MB8189.namprd12.prod.outlook.com
 (2603:10b6:208:3f0::13)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR12MB8189:EE_|DM4PR12MB6614:EE_
X-MS-Office365-Filtering-Correlation-Id: 3929af9a-d7d0-43a7-726d-08dd66df0db3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TjFGK0E0SHZ3RlVKYXJwc0tOYitoOEtNenZtb3ovRHRWeXFNMSt4T3k3VW1S?=
 =?utf-8?B?S0ZEOG0wUzgvZlBSRW93QUZYZTdxVFhTOWRNQXNsYXFWa2NXSk9nZHZEdFZx?=
 =?utf-8?B?d0lYZWt6Ukw3UnU4dm1ieERqWFB2NUllYXQ2VzExblhPckJEL1ptR0ZpdlRS?=
 =?utf-8?B?ME9MNnJwRk51UmZwdmw1RGVvWjFWcWZ0KzNyaDJFNmZkdm8yYjZSekU2TWR6?=
 =?utf-8?B?RVgyc3pvYUFyVnRvSWxFeE0yOEw4a3grTCtTUjVlMzJrV08vR2FPQ0krUGhC?=
 =?utf-8?B?UFBMcVZRN0tKN1d6V3lNbDlPTlc5RnpQYVp4OHZxN3NUcmlsZCtQajJnWDdH?=
 =?utf-8?B?eGpzWE9QSlZkblFZLzM0aGNsdFNEYUppYU1obERHUGZrVldOUXZydVJkMFJo?=
 =?utf-8?B?dUVsNWhST0xzSUJ5c3FSRzBvOUV6STR0NHRaS0xrb2RJTEF1K0dTQytsQ3RJ?=
 =?utf-8?B?b1YwN2dwejdxZ2Y3UUg1RzZ2elNLS1p3cjJUUkdoRGNYdVVpcUJ5TlV3UkN4?=
 =?utf-8?B?MU53YlIvbUh0RGozcmJ3UWNvbE5wWDMySk9adkpIamR0T2ZTMHBHb2c5dnpa?=
 =?utf-8?B?YU1DUFprTUZ4R284WlpjZ0RKcnVoc3RLSnErNmtqb3o3bWcyV2dmZE8wQWZr?=
 =?utf-8?B?Y0hMZk9XaWFOYTNua0trS0w5YmJIRXl3cmQ4Zm9WdFpmazlVeDR6aVNSM2J3?=
 =?utf-8?B?VWxZTSswLzQ5eFNHc0lyN041RmU0QzU0eStzU0NZUGoyblpHTHJ1bWhjSCto?=
 =?utf-8?B?V2pyOTVlSFEzWmYxUGJINnI1ckNOQkJQNW5vU3FUZjZiaWhIL24wT29jZmsy?=
 =?utf-8?B?Yzgrb2k2MUhQNFRmM01rTFFVQzI3QVRaeCtMd1JGdXFXVkZKYjdHeEFnZ3JT?=
 =?utf-8?B?clRVVWp0UndZNFhwR2o3WE92OTIrN0w5UktGL0lQWHVGZHd3c0dVSG5mRytM?=
 =?utf-8?B?WXhjWE05VjJIcEhwbVB2bjdMcTJINFg1Y01UWlZDK3pBUnJDaFNxVE96M2dq?=
 =?utf-8?B?eUJaZ0syRkNKYUdhaElnQm8wVFlXZk82Q2JnNk5QRllDVkk0ekhQSDVPZ0Y5?=
 =?utf-8?B?dXZOSFFwbzhCaUU5YnVpaWh6MHhaMDVyeG5ybFBsTk91eGtVeDNVZkk3VHFB?=
 =?utf-8?B?bmF6bjFMOEppakt6L0NsZDZsNm12Q252cGNzRTN1cENWTll2Ykw4a2NFK2s5?=
 =?utf-8?B?SVBCVExDUlcyZkZjVkJ3Ym5FSHdCUnpLMllaUGcySFp4dnZyY2Q2Rzkwajh4?=
 =?utf-8?B?M0ZOOUJlanlENWZTU2xmM3htRkNiRUZlQ2R3elBTSDlTMEw5MWVlVGN6ZlJl?=
 =?utf-8?B?Q05XK1VjMkxsc3pSbW9PN2Y2YlRSTFROdGZTQmhRRkxmcm9SRW5nTHVIMGli?=
 =?utf-8?B?ckFLZ1BxVzlvMllvUVBnQ2dyMDJ0U1o1MmF1NjZkaS9HSTEvbkRrOGxOdFRV?=
 =?utf-8?B?OVh3dzEvN3QvV3dYTUdOVGJHdlBnaE9BTkR0c01FMVcyU1BkYUpwUmJMOExH?=
 =?utf-8?B?Uml1L2lxczBvdXM5eDZTUy8wYnc1VVp5UFFwUWhKNnArTThZQjROQjAvNWpz?=
 =?utf-8?B?emxLdnE3VTUrY3JacDJZNkhDZU9sb1g0WlY1c3cyakRkZE1hajA4dUhidlky?=
 =?utf-8?B?ZmZaVWNsRlJlN0J6bi9hbGtudFp1U0U4SXdOMlJSblV3RmZXbTlMbWlodFdn?=
 =?utf-8?B?eENmTHhhbVQwbThhNFJzYStrL25kUjB0WVBnV09CWUNWblpKbkxKeEVnNVlC?=
 =?utf-8?B?aERzTDVZRENUNHN5M3NwM0VZRDZqYktxVzBzVCtOTVRwQkFvYkNuQ2QxTDQ1?=
 =?utf-8?B?TmRBOHgwVmlNaVdISmRYTHNNWk15WDMzRFZreGhnTndTWHpMajd2dmU2SDZu?=
 =?utf-8?Q?iyvlR4tW1oALR?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB8189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RG1MQ3k5UEE1eFVVZDJ2aUdhNEJyeTJRdncrcm5Ocmc2dm9VK0h1cjU5bHFS?=
 =?utf-8?B?Nk5DcUs0eFFyNGlIV2t1Qnk4eGdmM0lhVnRoM2tRaGsza1ZmSUNVZVVpYWQz?=
 =?utf-8?B?ZTZ1YXFQY0hKY3FMMTYrZXFObVJzS0hRUGJ5MHJzdkRLN090UUN6Vk1XQnll?=
 =?utf-8?B?QmY0elZ6THEvK2NMOHgwbGZwUmRhTmxpcjZHWnBoYVhudThkdkg3Nm5BOVVx?=
 =?utf-8?B?blBQcERZbzlod3NXS1hseWo1V0U0cEhCcHYzdnZDZWFwWk5wd1pwYllEaDIx?=
 =?utf-8?B?M01YVVI4OXg0dHM3TlROMVBxaEs2WFdSRjcrSGVPcmt0ZGx4MXpCMm9mNEEw?=
 =?utf-8?B?UGVDT25oRVdVK1BVYUl6blU0L0ZwSDJVK1FiZHhKZERDeEg0MDV5VGthNUJL?=
 =?utf-8?B?R2hDNDd0TzFkU2FrUXJYUkRmMVlFTHF6aWJrVGlxOGE1MXU0UjZjSEZEaFhS?=
 =?utf-8?B?c0JRS1RDRTRycm9QR0tvbVJ5YVIreVQ5M1BvYjhXUkRpaXF0cFFWcGd2RUlO?=
 =?utf-8?B?UktuMWF5VFZjeXlDc3BDMVpjajRQQVNZd0pzck5jMXRQZ0pFS21kck9CaWZN?=
 =?utf-8?B?T0NjRVFYK2dueVZQOW4vSlFaUS9ENUlpTHdESWVyNDgyOWdhZGFGTXlTNmN5?=
 =?utf-8?B?Zi9EQ0tYbVBnUmgyak5ZUE0xMzVWd3NVamhReHpzNHYyaERzVzFwNzJnM0Iy?=
 =?utf-8?B?WkpCL2had3ZNb1VyVHJQR3dJUVB2Y0RKbzlMbHBoRFIvVVh2dkVTSHB1VzBl?=
 =?utf-8?B?aFIzRjQyTkdmRGxJdFZ3RXgzTUdBaitKekpVeWpzbEJrTm5DekcwOVhWNVM3?=
 =?utf-8?B?U0Rzbk8xV2FFVVZCbitjdlNwaEs1djErb015akp5MnVNcGNubnlsM1E4VkJh?=
 =?utf-8?B?eDE0UzRlbFQ3TFJIcFhMMnFuQWs0Rmk2VmlTTmlNZlNWa2lseWRCakt5Vm9O?=
 =?utf-8?B?SldkL0ZSQjhldGVxNkV6STcxcEpaaDVVTEVXV1ZtbU84R0JHNWljV0RtMkdO?=
 =?utf-8?B?L1pvM1k2UFZEM2o4U2MrbUlkdTZqb3UrdHBZcDJsbTlNbG5kWnZlbE9OUk5P?=
 =?utf-8?B?N1RvVnFGZElvcjN4SmFtekF4WmdBMnJEWGxxdm1ablY0dkVFRURUYXJyOW0v?=
 =?utf-8?B?TVFWWDJRUmprWUI2cVowOVhMbkp1eXBHQk95VGJvOTFlUFo2SXZnb25LRWE5?=
 =?utf-8?B?ZUZlMzJrSVBycDgwMWtmT3paM080ajV0MkRmUS9ydVhEaWhSWTB1WStGRTA3?=
 =?utf-8?B?MCtQRGVQVWZCYlNHVmpPTHhGY1NObDhNaUxQNkZDeGFNOENvUXVucmxRY1h0?=
 =?utf-8?B?UnpNV3VSY0ovd0NvZEw0dkp3LzVDU29pRnliempNTmJtdlprcEQ2dTBnbW93?=
 =?utf-8?B?VlRUdUVLaitXTmlUajhKZnlEd2pjVkVMRTUxSkI0cFVGRGhHOUFSb2d4cVll?=
 =?utf-8?B?dThTdzVQc3FDT1Qrb3FwOGlOczdQdldiR1J0SFAybmhObmNyZFhqMGF6OU9I?=
 =?utf-8?B?NFFUZTA0M0lra2kxcHNBS2JXT1pWWElzcTYwcG0xVFozencvRUp2NmhsblJ3?=
 =?utf-8?B?aTRyL2NqTUZlbDQ5Ym9CNk1kNURNRkJBSmZmeE5TNDV6NFVzMjRubitMdWZh?=
 =?utf-8?B?bG9odm9WTExOMnlGcjVEN1V5NkNYejRSbkdMZnBNTjhzOHFkRUgvVGloSXVr?=
 =?utf-8?B?am5FZ0E2NEJzR1pXN0ZqY3c5QXlZaVdKNE52V2tZbWpocUdGZ0RsL2tJSERO?=
 =?utf-8?B?aVluYk43ajNPaDVGK3lmLzRLSHdFeFNNaHFHZ25HWWd3dzZyNjNpdW9Kbks3?=
 =?utf-8?B?N2g2MXlIWExXSS8wM0RVZ0dtWk03OTl6M2Y2YWhKQUZYb1ROWVBFWmdXNUNt?=
 =?utf-8?B?S1NKZVdHU1l4ZGEzU0NGaHNJN3dBVGN6RW91VWtBTDJCcE5NdE50OWtqWGVZ?=
 =?utf-8?B?NkdZSnF3R0JOME1Cc1V0RDM1NDVySEVOMklpRU1SQWRvNG0wU0ltbEVTY25C?=
 =?utf-8?B?MHVtajhUTjlzMkkrbWhRVWhWYkh0TEtnbG1RUTJrdjFVeS9CTnVQN1hNeC9x?=
 =?utf-8?B?TXB6c3B3MnFJNHlQbHI2cVR4WHhocDNtRlc5NmtZdVoxYWJqM0x1RWw0MUdq?=
 =?utf-8?Q?UyLk8cyy9tITymmBmf9jcSEp5?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3929af9a-d7d0-43a7-726d-08dd66df0db3
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB8189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2025 12:10:35.2054
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dBLp2dOBsbAe85pKNu02HC1XqwqMqN8/uAw2mObXgFCXHjtZIrRIOZP9RPFM567Ky6TenTKGcBHzE8+oDrrc5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6614

On 3/19/2025 12:32 PM, Robert Richter wrote:
> If a CXL memory device returns a broken zero LSA size in its memory
> device information (Identify Memory Device (Opcode 4000h), CXL
> spec. 3.1, 8.2.9.9.1.1), a divide error occurs in the libnvdimm
> driver:
> 
>   Oops: divide error: 0000 [#1] PREEMPT SMP NOPTI
>   RIP: 0010:nd_label_data_init+0x10e/0x800 [libnvdimm]
> 
> Code and flow:
> 
> 1) CXL Command 4000h returns LSA size = 0,
> 2) config_size is assigned to zero LSA size (CXL pmem driver):
> 
> drivers/cxl/pmem.c:             .config_size = mds->lsa_size,
> 
> 3) max_xfer is set to zero (nvdimm driver):
> 
> drivers/nvdimm/label.c: max_xfer = min_t(size_t, ndd->nsarea.max_xfer, config_size);
> drivers/nvdimm/label.c: if (read_size < max_xfer) {
> drivers/nvdimm/label.c-         /* trim waste */
> 
> 4) DIV_ROUND_UP() causes division by zero:
> 
> drivers/nvdimm/label.c:         max_xfer -= ((max_xfer - 1) - (config_size - 1) % max_xfer) /
> drivers/nvdimm/label.c:                     DIV_ROUND_UP(config_size, max_xfer);
> drivers/nvdimm/label.c-         /* make certain we read indexes in exactly 1 read */
> drivers/nvdimm/label.c:         if (max_xfer < read_size)
> drivers/nvdimm/label.c:                 max_xfer = read_size;
> drivers/nvdimm/label.c- }
> 
> Fix this by checking the config size parameter by extending an
> existing check.
> 
> Signed-off-by: Robert Richter <rrichter@amd.com>

LGTM

Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>

> ---
>   drivers/nvdimm/label.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
> index 082253a3a956..04f4a049599a 100644
> --- a/drivers/nvdimm/label.c
> +++ b/drivers/nvdimm/label.c
> @@ -442,7 +442,8 @@ int nd_label_data_init(struct nvdimm_drvdata *ndd)
>   	if (ndd->data)
>   		return 0;
>   
> -	if (ndd->nsarea.status || ndd->nsarea.max_xfer == 0) {
> +	if (ndd->nsarea.status || ndd->nsarea.max_xfer == 0 ||
> +	    ndd->nsarea.config_size == 0) {
>   		dev_dbg(ndd->dev, "failed to init config data area: (%u:%u)\n",
>   			ndd->nsarea.max_xfer, ndd->nsarea.config_size);
>   		return -ENXIO;


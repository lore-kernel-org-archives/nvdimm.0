Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013009.outbound.protection.outlook.com [40.107.201.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD376288C08
	for <nvdimm@lists.linux.dev>; Tue, 21 Apr 2026 15:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776783889; cv=fail; b=Wq44MHtIyTpEY2q1SDYOOYz/akuYXn1hMHby3JdqcBHkwTGWKD9YHA2dqMfcj0zD55k957VcpgfyAHwXGb+Tt71oUrfZ36EfV96KXGU/ilNkSamoyrXx0Co0otXZ40U9BQE5gXkeqGK7aRL52y/N+Uun2gXVNIowcDIHEZKTCjQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776783889; c=relaxed/simple;
	bh=cUtH21bwjML4UfARja5rMy4lwyVo7g8+4n6teukMFKM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=RcX0IT/g+9tmx3VB56NjhMxxDLCMDTJ8GcdlsRtbEw2oZEMhvBeV927BJbSHq5FrehIEBY/4T5rnAsNmutbVnmUJ3+NWvKFPhJte+tFAoxc4yls822yT0waKRm5NbApsDtX+3W30+RhSbafIUSrZOdrVtCrnz7R2vPsY6FO6sn0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=zoL8C4me; arc=fail smtp.client-ip=40.107.201.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="zoL8C4me"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sA6lUkR/k2cI75tx296tMKnd0mk1ognZN+TpvN3eVGIqkZq+91zyTiD2Mq+9kFE7UXqSUS04h94QbVIx2jp2pl56hQ8UcBV6Oe67nXcTL9sW+v5csDrkhpspxzx4PKk33812Ev1V7KUlqOOkzSJj3WYDuVsr1DFzKuJKoPWjpdqQZimwjM0bwyqHzlF5/E+MzIlfqFRU0UUjC7lWRfHCr+4rLSezTXpdZ5Hg23Up8o7zyTDT+QynklVRvW4GN74dtrrGe0I+JP0ugv2PqqUhf0mAtGaNBwBccfO9M3bT6wex6qpHwWS1UktYlpJ+j3R/UAzG280SzqxMFK+utJmgFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nrFt5a2yyBcZZMrTFlMEF17msSUdN5+WrA2MtqvUvhQ=;
 b=rsiM8DieFJ0PDcNMamVeT0hwC4Kt5gFqgMBLSAViPh0R9UXSB+pBQf54Hdb2xMdkKQjbSf6N5Ee3jKvfXckqqMAB9rb5OyERXlcnq8qO/e4IkmtZbs5Oa4kdAmARjY6eeFx7Rr6oJRXnBwOOqrw8TebCnB+RuUHxFoQHE0DtGBlmLV2HBCjquh2Q4AyROLwk9k/VKw8tQ8eRK7HlCN4LCB/TJHUEMWoAa6q8T3nm7yqA+UQNXC4f+DeVOt/JzzEQB1YrWshIUNb+4Dlk/tWY3uBxyel9fXEYdkcaXslKZcvBQ8ogtFCEYhCr8V3dcJR0XAEsBFqbS1tr3xQ1mbJdhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nrFt5a2yyBcZZMrTFlMEF17msSUdN5+WrA2MtqvUvhQ=;
 b=zoL8C4meD4wUetwH8XAUVcR2ZBFPdTWrBCoe4oR+KzslAe54MJZh6VLLXact+hTLggm6GM9TnK2d/qo8VUVCtJp7f/zlMEeH7TL0dDHQLHmrWpxgMOJGG97n2eDgJlcuvmTcfOR3fuWx6tiav4TZbd7gwUkPiVg7HbAwA2mC0CY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH8PR12MB9766.namprd12.prod.outlook.com (2603:10b6:610:2b6::10)
 by MN0PR12MB6149.namprd12.prod.outlook.com (2603:10b6:208:3c7::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.16; Tue, 21 Apr
 2026 15:04:42 +0000
Received: from CH8PR12MB9766.namprd12.prod.outlook.com
 ([fe80::be0f:431f:5f27:96d9]) by CH8PR12MB9766.namprd12.prod.outlook.com
 ([fe80::be0f:431f:5f27:96d9%3]) with mapi id 15.20.9846.016; Tue, 21 Apr 2026
 15:04:42 +0000
Message-ID: <ee3eeaa0-7637-4df9-ad3a-dc0712d4f22c@amd.com>
Date: Tue, 21 Apr 2026 10:04:38 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [ndctl PATCH 0/3] Enable CXL protocol testing
To: Alison Schofield <alison.schofield@intel.com>,
 "Cheatham, Benjamin" <benjamin.cheatham@amd.com>
Cc: dave@stgolabs.net, jonathan.cameron@huawei.com, dave.jiang@intel.com,
 dan.j.williams@intel.com, shiju.jose@huawei.com, ming.li@zohomail.com,
 Smita.KoralahalliChannabasappa@amd.com, rrichter@amd.com,
 dan.carpenter@linaro.org, PradeepVineshReddy.Kodamati@amd.com,
 lukas@wunner.de, sathyanarayanan.kuppuswamy@linux.intel.com,
 nvdimm@lists.linux.dev, alucerop@amd.com, ira.weiny@intel.com,
 linux-cxl@vger.kernel.org
References: <20260408203231.962206-1-terry.bowman@amd.com>
 <7fe63454-9df7-47c9-ae7f-4db1fd1a3576@amd.com>
 <aeb3kXkeAkWBm-DW@aschofie-mobl2.lan>
Content-Language: en-US
From: "Bowman, Terry" <terry.bowman@amd.com>
In-Reply-To: <aeb3kXkeAkWBm-DW@aschofie-mobl2.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM6PR04CA0005.namprd04.prod.outlook.com
 (2603:10b6:5:334::10) To CH8PR12MB9766.namprd12.prod.outlook.com
 (2603:10b6:610:2b6::10)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH8PR12MB9766:EE_|MN0PR12MB6149:EE_
X-MS-Office365-Filtering-Correlation-Id: 3c5db46d-aad3-43cf-ee2d-08de9fb7511f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|7416014|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	FivaAnS3cvIfmcYedcXJhlWrss+tYzo99fmE5tXVOoPs5VFGTp8iRig28+r70sZhs7uoDSHjzuEYQaSn8E9W8YSyE544eTiFWavc/BZDCKy6qA4HkgO8SRSWoEH7H6vtWGLpccygECfy7a4Qx8FvXm89DhfN8h63+DiQo/6pAp7XcjF1F9hUxXtF2BCGR2/1Q9Xpk7xa3ygq3cZnZ9c9CXjigejfQeIg8llX1fk9feEV17ylExMGBOf0hkyz9LFH6dz0uZ7z+AIthNprKkx1ChMEeUaR9lp5dHP7ikf/rE8YIwmj+aE7S9xpt67dX4hcXHnGKJ80+Osh3FOishh+DnoOvBC8rQCaUGgM/xRYK81fLSYtPBmR2dAtTo250RZkWZUcKf5QYCb6Y+UiGulKUWl3M1LvWfMnA9+DAqMqH6VdXIkF/HWjNK/v3TeURqeZAbxjLIm2xoTq6/IWWpa702XzkQCuVNp++DZ7InLrBic0dLC9SmStxWlGQjk7BX+sy2hPaYZh4v+0Ree7RTbT9TeJFiCji0FN8IiQ7Kla/w5Qw3zgihyQUw+xIcWGCRtev38LZ/p7taqMY1lcMyfRpFYco76mzcluWoZJ/b66zhuf3UwGn7H6+8c22uBm9FJUU17eDsiM9xZKncK8yUCiwlzYiKA0Pz7jqYd5Ws3xGdFge260dvC+JSxyyEex9P7kAsZaysX72DBeAUH3L4TREu3TKP6wdPdVHj6860vHBvHOiRJ2Te3HIUmwUiSWtida
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH8PR12MB9766.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?U3ZxbkRqdkdyWmlSOGFnci85d2Vwc0RzS3h5MXNqSzQ3TFhjQVdUcmJZMVp2?=
 =?utf-8?B?WmEvVTc3UHBrcVV0cXg4TXBZbVpJZG9sdGxtZkkzcTZYaHRVTGVYeWpKYjh0?=
 =?utf-8?B?dXlxNjZ4UEZ0UVFVR2NLUXgzNSttMHhwREthSjR4UHNhdUYxNDVyS2NraUlN?=
 =?utf-8?B?b1RyKzRjS3l0MkxjY1AzZlhVRUtVeVdNeWppQ2NuaTE0eWllcWJmVU1ySlNJ?=
 =?utf-8?B?NmsybEhGc3dzcWk4S3RJZUN1Zmc3VDJTWER4TmdTTjY3Z2lCbEJyL043d1dB?=
 =?utf-8?B?MDNKdE1ZYlR3TmxseDBIdWJhUGp1enQ4T25lL2lpV0JHQ3VtODI3WWliRjVq?=
 =?utf-8?B?YWdrOEg5eEM5cHZ4ZVJQeDVYbjVXM0I4MVducldGSEllZ0M1d2NLc1kwU1BF?=
 =?utf-8?B?dEh2QWVCcjUxZHhRMzBTYXNJTGJSTjBPMHFGMDBCeHcrY3BHSTgwZkc0WEo4?=
 =?utf-8?B?Skk2NWpYejd1UlR5akJSOXROdUVKSW1pbm9zUHk1bjI1Ny82VVRHTVVsVTRs?=
 =?utf-8?B?ZGNOYW1sRytyUnNwNWVyYng3djBrQVZTeXhORDhuRFBHUzB1NytrUDN2MWVm?=
 =?utf-8?B?d3BZVmJ3NW9OdTJqOG5VNGRiVjZhT0hkTmpaMnp6NWUzSGdjQmNSTnpFYU5M?=
 =?utf-8?B?R3FpNE9WVEF0bE5iN0lwT092RWV2WWFkaHN4UE14RHZ6ZndrZ0w4WFN0YkhO?=
 =?utf-8?B?YXJRckVlK1FMcWlJM3lodjFqM3ZONGpLOWdleG51RnZHUjAyNWxpVEduT1Jj?=
 =?utf-8?B?WVl5aDFlYURGV25oc2t6SDBZZkxUZHhYR0gxT2NpQXYwTWY0UFU4NXpROU9J?=
 =?utf-8?B?NHhzVisxL0pBZ3MvVFdGZDJKN0h3VkpQR3lQMXdaYWdjQm56V1ZWRS9xcTll?=
 =?utf-8?B?c2pOam0xMytBQXVwWnA4MzMrVWc3RUZFVExiZGdGWXV3Y09TRUd1b1d3YmJ1?=
 =?utf-8?B?d2N0blhnSFhRM0cvbHhRQ2w1YjgrN05jZlEzUkpacFhsREZRQ25ZVHA3NU1G?=
 =?utf-8?B?WXJVOG41anNnMXJjYTB6ME9NaWtHME53T3BISlFXeUx5bkI1TWRQZ3FmazNw?=
 =?utf-8?B?bG0rUFAyWnJPM0xDQmpxSmpSMDNrcUt2T0RlSG52NFp3V0IzMWcrNVFlVGZD?=
 =?utf-8?B?blBYajAwcGZ4MXQ5Z2FkQ1RzOUNFYktoSVp5Mzczb1lCSGdEZXNpWFQ2RUdy?=
 =?utf-8?B?MXVwWUI1YzhaTThOaWMzUDhJRnRVNzlFK1EvaWdGQjl2bXdJWnErSUEyNXJj?=
 =?utf-8?B?Y3hxR0F2aHdQS2NDTlJIYTE2eThNU3FFUkhwZStRTjRoay9KaDZXbjIwdHZM?=
 =?utf-8?B?UThnVmdSMGMyRW11RXRIb2lMeDlOVEdWd24xOFREaFJjK08zbVdkUmJmdlUw?=
 =?utf-8?B?Rk9YdWtsVDdPR3lWRUxkTkhTTU9lV1JxZVdhYjR4cHd5QlZ4cUUrWnU2T3hG?=
 =?utf-8?B?cUpIVWpzbnhrZ1JVem5WWHVWelBOek5XSkJHbUcyMncvVHNNTHFFZEU0enZw?=
 =?utf-8?B?cFZ3OHowSXdCa2ZmczVSb2ZwRzBkeUdNeFpoR1JQaUJnWmNlRUIxODhpMmtZ?=
 =?utf-8?B?bHhXN0VaaFhPb0xjWGxhWGFOcXBaQ09vdEJvZVN1TzNsQWFUNko2QlF3RGtl?=
 =?utf-8?B?aDg3Skx2OTF5RDl0MEJDYndnTm5MazJRNitZdzBVdkdGaUgwalcrTlRNaVli?=
 =?utf-8?B?Q2dHMUxZZ3BHU3JNRGlPZDRudmNtd0ZaWlNmMnZmT0xSa0NUMlU3QVZTWnU2?=
 =?utf-8?B?UUQwelFMRkx5LzdFQmdxcm8wUFNSdlIxV1JRd0FZbmhOaG5paHdUWDRFOUR4?=
 =?utf-8?B?ejE1K3BObE9tVWpDWUVNR25NeUdzQVNIcGs0c2pCR0ZiSTFhcUcxT25tbHBl?=
 =?utf-8?B?TGNiR3FwOVdDV1RPQ1dabFA3VERCSTdNVCt1UGZQSllqY3R4bHdIT2NiZGpO?=
 =?utf-8?B?OUd6UHJWLzhsbWFsM21Xa2ZXTEd6TTZWTUt0akMydm80MTFZQkU0K3NBVmps?=
 =?utf-8?B?TFJBOWtyUzg4ZFVubnBJbzNkc1V6Rk0yWGNpc2djeFUvZVYyUVNwck9kQ2hJ?=
 =?utf-8?B?ck10TmZJeURNVmZ2a2JzbXZaZXllR1g4dHBRT1A4SDBTbUJJVExXaHVZOXpi?=
 =?utf-8?B?dEY4SWhISllQclpyaGRYYnhNRnhOVURhSUs1THR5dVFlRFA3S3lMVE1yd0w4?=
 =?utf-8?B?cGJNK0hoRk9JUHArWVhLaG5FVXhIRDJQSCtXWGlYTUNsMDlEK2p2QTJDRUJv?=
 =?utf-8?B?em5uZFFsWC9NTkNhYklOM0NZRHAvaHQwQllIQXMrNTFXV0JKTTlsRjZTQldL?=
 =?utf-8?Q?ZXxKOgXUtlNq2nRKmB?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c5db46d-aad3-43cf-ee2d-08de9fb7511f
X-MS-Exchange-CrossTenant-AuthSource: CH8PR12MB9766.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2026 15:04:42.3335
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L8ULZjl5apKOBOqkw7x4i6/z5GH9HbwM488ByjD8rRZWWSXaCqq7x8u4po0G7bagx8pGROd+U8AkBfJ5GNOoWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6149

On 4/20/2026 11:05 PM, Alison Schofield wrote:
> On Wed, Apr 08, 2026 at 04:39:41PM -0500, Cheatham, Benjamin wrote:
>> On 4/8/2026 3:32 PM, Terry Bowman wrote:
>>> Current CXL error injection (EINJ) only supports Root Port protocol error
>>> injection but a method to test all CXL devices is needed. This series
>>> outlines methods to update both the kernel and the 'aer-inject' tool-without
>>> relying on EINJ-to enable CXL RAS protocol error handling across all CXL
>>> devices.
>>>
>>
>> This functionality should probably be added to the inject-protocol-error subcommand
>> instead of spread out across the directory as a bunch of scripts + patches. The command
>> is only set up for protocol error injection, but I don't think it would be *too* hard
>> to extend.
>>
>> I think the first thing you have to do is expand the accepted device types to include ports and
>> memdevs instead of just dports. That should be simple enough, there are already helpers to find
>> both based on sbdf, name, etc. Then, you'd need to change the interface used to inject the error
>> based on device type (is it a root port? then use EINJ, otherwise use aer-inject). All that's
>> left at that point is to actually call the aer-inject command with the correct options (and
>> update the documentation/help messages).
>>
>> I would be happy to help with any of the above if you agree with the direction, just let me
>> know!
> 
> Terry & Ben,
> 
> Terry thanks for sharing all this!
> 
> Reading patches and Bens comments and trying to understand the pieces
> needed to make this reusable. Help me out here:
> 
> 1) expand our (Bens recently added) cxl-cli inject-protocol-error cmds
>    - to handle new types
>    - to route to aer-inject tool
> 
> 2) make aer-inject tool handle corr/uncor internal errors
>    https://github.com/intel/aer-inject
> 
> 3) make cxl/test capable of do special RAS status
>    - maybe a wrapper
> 
> 4) then we write scripts that run under cxl/test, require aer-inject
> tool AND what else do they require?  Does this require CXL QEMU devices?
> Are they doing something special in this recipe? Is this something our
> CXL Test mock devices can fake?
> 
> Above is my quick attempt to understand. Please advise me.
> 
> --Alison
> 

Hi Allison,

The test patches I sent would not be reusable for a cxl-cli–based solution.

For the cxl-cli approach, item #2 is not required. cxl-cli will handle CXL RAS injection 
directly, which makes aer-inject unnecessary.

Item #3 could be useful for managing or coordinating test pass/fail results, but it is 
not strictly required otherwise.

Item #4 could be implemented using either QEMU or hardware. Updates to QEMU’s CXL RAS 
support may be required to properly emulate CXL RAS messaging from USP and DSP devices 
to the Root Port. This includes QEMU detecting CXL RAS conditions and then
generating an AER message to the Root Port. I’m not certain whether this QEMU support 
already exists.

I believe the CXL Test mock could drive this, as it effectively serves as another 
pass/fail test.

- Terry

> 
>>
>> Thanks,
>> Ben


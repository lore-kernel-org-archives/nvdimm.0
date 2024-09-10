Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2056.outbound.protection.outlook.com [40.107.93.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C210C191F9E
	for <nvdimm@lists.linux.dev>; Tue, 10 Sep 2024 13:08:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725973682; cv=fail; b=RJ/WAitTZutgpmR68reRBbSUDhK3MrEQvn5HfAfAcsMAQigrhQv82CR88LV/JL9vCFbuZF3VVwjIawh1ISzVmFMXGrlvf6rv+z93LMvFMIkNwFzAcFtUGUPgC4lukylC6g6J7j5ITTVdfh1VR4L5XEGAiHeuFjlz6+9jv3wolvA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725973682; c=relaxed/simple;
	bh=JrhxaBBNjCpoohw3H73u8tcg4gt3MBo8VJNYQia9BJU=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Q05pYnRhbPYeRW8UyIq5UAAtr8hQnl28jp7N/dRxbhlogU03vn4YpNabrN2QXZDPvyzxvbHdheycVTair02SQoIJ6f0OFVZ3wcBS8a+Ue5hBzsiuGykMqUg1X4YsC2rRxqb33Un3sK0Efor6ovX0+X6Yd4fOhkffTSyVv/BZKl4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=UAKlKmoX; arc=fail smtp.client-ip=40.107.93.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="UAKlKmoX"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AWCtW5vIiWkvZ0vQg54znEF5WNlPH4A9RJ6Jt90G/S9tp7viE+7FqoCHrmWtmo7W84s6jbRheVqHRQ7XYCR/gEOR8JXgDx7s3Ej5fE8cn9og2Zp+s9GjukyyHcYYAATFcHh/Wl/O8YaSs3MMP6J++rQq+94sC7DIox65oTw44Q4hJFBIKzQ4ubWg48AdYzgkHbZ1fXN1iMyGqdGjAI6NhWCHHar/c6WFD7YQzyv3Viqt5Kogdaria3gvRTaVPBdtBcFz+eBtXQXG3DWo3MIrHImRKDqhtVZuygxaZuRJPnX5MTA3HNdcIWYKdTTAhUguJmKFmOdIFJ4FVn47I54vzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XJNeQKpsFP41S7fKurWpvSjWSjAZCszv8Ki432XgcoY=;
 b=yqSKsPBLneG7GF9USKvwDC0ZI1g48HRS9xN7QTzW75rhRzZLBp1fxLCWZcXEqpwpKQzGyXiEaQQAtm5Jj+hYzpN0HS6PECighDuxL8BN8Bl7ZGCOA5ZfPS9Y74n0jfHRK0La/oIKcoWro5w6OtiyXUrGYs72Sz0081x1B9xPfOikzGGznwTMTUwHTa0rjO00gshG/okd9ZTENd3ZlNbP7lfZiQ4BYt7BStmJtaG+5iDBuEyzYXqX+ucqE15M0gcvQdz6P80QFRDmIO7FfOLF2ZERoHQ+tk0aDgF1t1twoCJVPyL1COQ15bULt/TqPgkfyZkD6SiEZx9gz1WnjV5/Rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XJNeQKpsFP41S7fKurWpvSjWSjAZCszv8Ki432XgcoY=;
 b=UAKlKmoX9Rvk43Ese4XTjADJ13UvTicLexW0EwWKtK1WXyB8SNLP3Bu9OCQ5RfwqKrtZDJXso4TZspC4tpSF1j0r5AzVUDWxP6MbYxg/D/piYMJ+oJI8T183dAmprvWTiaGC4sPOdW3kZBlEg15mIG44X4gnwvX/4kkZQXQvHZ4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA1PR12MB8189.namprd12.prod.outlook.com (2603:10b6:208:3f0::13)
 by SN7PR12MB6815.namprd12.prod.outlook.com (2603:10b6:806:265::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.27; Tue, 10 Sep
 2024 13:07:57 +0000
Received: from IA1PR12MB8189.namprd12.prod.outlook.com
 ([fe80::193b:bbfd:9894:dc48]) by IA1PR12MB8189.namprd12.prod.outlook.com
 ([fe80::193b:bbfd:9894:dc48%6]) with mapi id 15.20.7939.022; Tue, 10 Sep 2024
 13:07:56 +0000
Message-ID: <462965da-a945-7376-825f-f56e233627c9@amd.com>
Date: Tue, 10 Sep 2024 15:07:43 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH] device-dax: map dax memory as decrypted in CoCo guests
Content-Language: en-US
From: "Gupta, Pankaj" <pankaj.gupta@amd.com>
To: Kevin Loughlin <kevinloughlin@google.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
 nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org,
 linux-kernel@vger.kernel.org, changyuanl@google.com, pgonda@google.com,
 sidtelang@google.com, tytso@mit.edu, pasha.tatashin@soleen.com,
 thomas.lendacky@amd.com
References: <20240814205303.2619373-1-kevinloughlin@google.com>
 <0bae453d-b4a8-3132-9fd0-bca0eece6a74@amd.com>
 <CAGdbjmLVFZJq7OJv2OwM3knmwfb-j8nZP7G_ownFA3kd3fYbVA@mail.gmail.com>
 <78cbbaca-5413-c006-6609-ee23e2c757f0@amd.com>
In-Reply-To: <78cbbaca-5413-c006-6609-ee23e2c757f0@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR3P281CA0172.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a0::10) To IA1PR12MB8189.namprd12.prod.outlook.com
 (2603:10b6:208:3f0::13)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR12MB8189:EE_|SN7PR12MB6815:EE_
X-MS-Office365-Filtering-Correlation-Id: 67aab791-5f99-4be8-8d8b-08dcd199969e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NlAvYkZZY0VGeW15ZHUzRngyQU9oaUtJR0ZDbUttZisxMkprRDhqWmJpRU53?=
 =?utf-8?B?UHY3MnYzb2phbXNEaUJjTGh2OTdPT3JNcHB2Z2RrYkVzUGRwdnlJQmx6SmR3?=
 =?utf-8?B?MmN0cVJIZXBBU2Z3a2lvSXpTbURLRExITmlyMkw2UTE3T1ZBdndTb1QxRG1S?=
 =?utf-8?B?UG05ZUxwcVRaam9nb3ZjdzZVTTNwVVdrbmw4TG5kQTdYNVpjdnViU0tDclRl?=
 =?utf-8?B?TmJwR0EvMDZId0FLdjFKQ1FMVGE3eEJjczlNZFZveE9NYTIxTFhXZXZJVWFz?=
 =?utf-8?B?V2doNzY3Z1N4MGQ2QmZ3cDI3SXpGaVhYZ0xoazZNYWFUa1Y3Vy9LanZWdUxy?=
 =?utf-8?B?bFdVRUF4ZUpHQVB5Q2dZd1NhSS9Ed053MFNLb0FvYTU0bEVnd1dDWGF5ZmVn?=
 =?utf-8?B?K0R4SFB0anZDZ1ZIdFFyNUgxcHE3andQV2xqMGJvNU5jcEh5bE9QcUhLT2V4?=
 =?utf-8?B?cDBiUFpSWDE5dlRQeDg3VEU2d3pUc3dYckJpaU9XOTM5N1lZU0t6emt2anda?=
 =?utf-8?B?NUViWWtoWUlrd2pjUGlVQWVoN3hCeVdHQ3EyckdrdWwzYytqMWdWRzcrM0hB?=
 =?utf-8?B?VnZvalFkbVNRbzZHNlBlNW01ZkM1RlBndXJsblBCaXEzTEpNZUk5d2RSVk5I?=
 =?utf-8?B?RjZoU0QrQk81UzFTYU5MMzVmL1NsdmpBeVpFZjIyK29OWGJycHVQQlhLRGZ5?=
 =?utf-8?B?Z0JBaElwOWgwODEvbE9takYwNzNmenFUT2s4a0MrK00vbHIxdDNEOGlvM2c5?=
 =?utf-8?B?Vy9scmt4SGxpQzhDR0hoYnBYLy92Q1IvRjlaNi9PYUJPT0wrOXRDQWZ5WDRU?=
 =?utf-8?B?bTZDUmhHWjJ3a29ZWkJ5M1gwRmYwaVZPUE8vTXdLNGtYbUdnak5oSHRJN25q?=
 =?utf-8?B?RW92cEU2VDFzSU9MVkxEU1AzT04wQUszRmdaMTh4cm9tSWNGd2ZKV1N1S2d2?=
 =?utf-8?B?L0E4UjRiUlF1bEtZempPMzdLdnZmelYrQVdIKzJ1MXBmMndycXZWV1NremE5?=
 =?utf-8?B?MVIwTG1jUlF4VXVabGk2QmNERDRMdDNEVXcyWkQ4T080YzRuS2JCaiswVGpt?=
 =?utf-8?B?QWFGTXU4MGV2UTIwQlVueWl1eU5raWMyZVZBc1JaWmNTUW9EV21LWGNlQmNx?=
 =?utf-8?B?K0JCS0U2U2VETWxIMmlqWGdzS2p4SUlsa0VPUHBhalF1dFJ5eWFFSTBZLzk0?=
 =?utf-8?B?TXRyODJoM1JVQ292Vlk2U3JXQU5yLzdGSFc0aEdEZEJ4VFNaSHZ2c1lJNEtq?=
 =?utf-8?B?YnVGQ2FMQmpRSnN3VTJrdkZMZEh3amt2L0dINlNwN2lYM1QxUGdFWTVodWhR?=
 =?utf-8?B?WDFJZVZNRXk1bTlyRndaN1dYdTh0UUluYnpWcDVIUy9rNDJ6b1I1RUh3Wkgy?=
 =?utf-8?B?VmxmSGYrdUJOU3RPQmM4NTF4ZVlCT01NUWJlZVpjdzB0a3JuZXZPTmpuR3FI?=
 =?utf-8?B?bXJOcG5RMHdMTkhlL3J1RTgzVUpWWDZaajUzK3QzNjRleG9hc2gxZ1A1dGYr?=
 =?utf-8?B?TkppRnNZNUJhRmFBTmZDTlB5VjkrbExoNFd3SU1qTkp0VHI3aEtsUmNtNGhu?=
 =?utf-8?B?YVo3SUd6YXphaVVjWk8wZTVKeDloQXJlU2RpTlliVkFaZWlOQ3VFdGloOXZS?=
 =?utf-8?B?UFI3WThRMUZxRS9nVlJNU2Nhd2xabjRSellJWnlKN3BCbjZCVmVWTDkzRG5h?=
 =?utf-8?B?d1NHWTZHaHpMTE9RWEhWRlQ5U002RlBKTVlrbnZuR251TzlxNkxTQlB2aWY2?=
 =?utf-8?B?dzJ3ZkNXTUc4Q0pHaGQ4TzBsZXJlYU9BVExEQWVsMEc4NjBsb0xIMFRaelJt?=
 =?utf-8?B?aW9LNmt3NlVzMFlsaFpSQT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB8189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RTJKYlUzU0hoa1laaGJhVWozcDNrNno4TXRLZFhLd1NLRExabUpOQkRITlA2?=
 =?utf-8?B?UHR4dWFlM3UyaVhCazJIaHlyeFQxeXFZQnExVEllUkhuWEhYZzJ1V0FaaUF5?=
 =?utf-8?B?WEg5V3lYdjExSlBtMWlPL1QwT2V6R0pLZit4OVVKVGNEWGwwbTk0MEV4eEY1?=
 =?utf-8?B?a2pndWZURUVkaDBVUktOVkVRWXltbnFHNzZyejhzYTl0aHZ0M2pOZWF1U3Yw?=
 =?utf-8?B?Mzk5YWNUR1RKTFpVbzY0UVl3QUh0RVZ1dDhmc2xvMU0yS0ZRNHVZeU9VYUxJ?=
 =?utf-8?B?eCtxZTdWcE9CbVBUamxzSHd3a01wV0haSFFScnVweVlKL21EdDBqVVZpdzFi?=
 =?utf-8?B?dWRPZFlSaER0bHUzRjA0NnhnVjBJUm52MUhGV0FVMFR3Q3U5YmhBektwMEFV?=
 =?utf-8?B?YU9rYW5BSVdQWGFySDVNcjQ0cGYzN1MzbmRhQW9XdlVzLzJLc1ZuQWdETERG?=
 =?utf-8?B?VnB0Uk96NEh0QXZpZERtdW9nTkVZbkFlMW52Q0lQNDFmL3ZEWHJVUjdQMmk3?=
 =?utf-8?B?ZmU5RTdiLzJhUXNJQUFqTlo4aEpGNkk0VkpoVXM0K0diTVloYUJXWmZMR1ZS?=
 =?utf-8?B?MklKWHBOVmRpQUVXVVlzNjZVL0JGdFJHNmJRc05RaWxsdHV0emZKaEZIb1pC?=
 =?utf-8?B?bGMwTGZ5K0h3amZKWFJXcnBzYmZ5aU8rT3JNRW5YZFFGNkhCbThWZ1JMSDRm?=
 =?utf-8?B?c0hUNERjYWZGeUZncEE5R0VQeXZvRzkxZUhRbVZ6ejdMeXF3WlkyWHJ5OExi?=
 =?utf-8?B?c25Pc0I4QWhqQ3ZCc25OMEh4ZXR4VTFoYVFQM0NHYkNrbmozVkpjRk9rcUht?=
 =?utf-8?B?RFBENC9mSjhLR3NuK0o4TmNyYW9xRUZOVEYyMDFGdU5xbTU1Zm1ZZFd0TkpC?=
 =?utf-8?B?SllUN283QWtmU2RkbTRFR1hyMFdwKzZmT3YyMUpCaDN0Ui9pSzdlTm5xcjZE?=
 =?utf-8?B?eG9Mc3djWUY0WEZyRlYrRng3MlY3d0I1aTFEUGxCOG9Ga0V0RS9ZUElya1BV?=
 =?utf-8?B?R21FbXVFZlNwdU1ZMHdPYU1td2lteE8rR3NYRjNnTkhXYmZJMWRua2QrbXRU?=
 =?utf-8?B?NmZnbThEU3haY3BxWEdMai9zOUNXUm9uMGQ4Y0RhK1RDTVF3TGJlaWw0UmhH?=
 =?utf-8?B?bzZPbVhVNmY5bEZjMXdIODZiNXljUW5rWkd3cDZmWW13VWN1NFYyenhvdkto?=
 =?utf-8?B?VGNTYzJYMXpoOVl5dEZZS2hwVWNodkUwUHF0eUpOY0pLdytaclBVdUJYdHRy?=
 =?utf-8?B?MUVIUHNBSmxucHVZMzRqc2lKWnoxQkxFemxlWDdrNk80ejl0NFcwSG1yMGxk?=
 =?utf-8?B?aElXa3pIdXI2RStLbmN3d0l6cDd0Q0F1K2UvRzNtNVJJbzl1Z3FlWGk4SkNN?=
 =?utf-8?B?ZHJBUEFZYlplOEEwTy96VzhMWkI3NVg3TWIrNkl1OFpCaTBJbTduMlowTklI?=
 =?utf-8?B?VytSSGphREJnVm91MW1yVklyaXh5S2hJeitDc09oQ3NKQmdlS0VQVGFUdzFD?=
 =?utf-8?B?b0Y0M2t6VGthSzhjRW04K1ZYR3RrTForK0hTT3F3ZlhCWUNBZHlsWk5lSUxZ?=
 =?utf-8?B?bWFjMlVEOEtlTEpDWStWTE5ST1dtNGdBQXR1WThwdHpFMHYrOTlreUw3Z1g3?=
 =?utf-8?B?eUZNUHl3NmkrWXZvRkJqWG0wNlQrdnJIMXUrVmpnbU05R3N5cDEvTHMvT05M?=
 =?utf-8?B?bDdUK2JHaC9hNjhXM2VRcFR2U0VLT1JDbmFZQVZ3WHY4dGwvbDlnYUdkZEtq?=
 =?utf-8?B?cGk2akxySUZ6citIQWxJNHBRSUI2Tmp4cUhXek8xTWd3M2pHT2svZ2NTSTJC?=
 =?utf-8?B?SzlyTjdCNEw5aW8vWHowNm0wajJZNzB2L2dyOXRNeHp0Vko2aUQxWk9hL2dT?=
 =?utf-8?B?VFI3V0lldHZoc1lETkFYQzF6b1g4aDFiSmRZTHV5cmp3RTU3NENyMnNTQ3J1?=
 =?utf-8?B?YlNRMlFwNlZIT3BKTDZuSWRVeGhSRUFhWnBBa3ZNQk0waUZSa2swTVJzRU9M?=
 =?utf-8?B?dkpyZW9sU2RJVmhYY0N4UXpTMWZUWjNRUFdRN2VoWTVmd2xxNEloaDNBaFhv?=
 =?utf-8?B?Ykp4MFRTSkZNMHJ5ZytRc1ozRmpOcW1rc0NuTXRnOExsR0hNTDV6cG41ZHlJ?=
 =?utf-8?Q?UWFlFxd9oaoZ2ydXJGmzZ/G0B?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67aab791-5f99-4be8-8d8b-08dcd199969e
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB8189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2024 13:07:56.9272
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pzF5thI9QIAzgqTi5g9pQGqzZI/r/f5Dq+woLjGl6ylqzPkcSKjj33WK7kloSWmx0F+cMW0QMJpIt6J8i9tj9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6815

On 9/10/2024 3:00 PM, Gupta, Pankaj wrote:
> On 8/26/2024 11:35 PM, Kevin Loughlin wrote:
>>> How can I test this? Can I test it with virtio-pmem device?
>>
>> Correct. Assuming the CoCo guest accesses some virtio-pmem device in
>> devdax mode, mmapping() this virtio-pmem device's memory region
>> results in the guest and host reading the same (plaintext) values from
>> the region.
> 
> I tried to test the daxdev with virtio-pmem but getting the below error 
> (just tried without this patch)
> 
> root@ubuntu:/home/amd# ndctl list -N
> {
>    "dev":"namespace0.0",
>    "mode":"devdax",
>    "map":"dev",
>    "size":1054867456,
>    "uuid":"c8b15ce6-0c8f-4a1a-ada6-b19a90bdf1bb",
>    "numa_node":0
> }
> 
> root@ubuntu:cat /dev/zero | daxio --output=/dev/namespace0.0
> daxio: neither input or output is device dax
> 
> Could you please share the instructions (to test with virtio-pmem or 
> Qemu). If not, still okay.

Ah by mistake pressed entered early.

Just want to see the behavior on a SEV system with daxdev (maybe above 
virtio-pmem or other emulated device) and see how this patch helps.


Best regards,
Pankaj

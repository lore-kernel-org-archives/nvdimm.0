Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011067.outbound.protection.outlook.com [40.93.194.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3F121E9B3D
	for <nvdimm@lists.linux.dev>; Tue, 24 Feb 2026 18:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771956822; cv=fail; b=lrOtvKjMlcR02LsluklSrcu/UBtQzgqOJNR3ftVjKZuvPqCxpUa3ZTNO0KPippRtOgzwMl6VgIG9wN94LpnrrrgDHLAUSgyWeLrewV6jcupmSyJCBBvJgn0Alag8IdrHKxPxS4s2KTL8n/dUXLJSRhIVhYjsvl9ThtigoEBPry4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771956822; c=relaxed/simple;
	bh=8GfXb6AN8IOi4+objfY00OUPAl2LgdUPVwGUJrrnYPw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=CeyOLhmh07pMa0hCpuS84sUxDfUcbAsR0HBWDiJKm6qdsL/f6zbmS2k3m7JUU+EWp3pd8LwpueVRJkQqp92Agpkk4e87YHJtUHmpIyHQU+LHp9iQmw7A/+omBAdFwp/i9MVaCl2NG9KdmcewhfqjrjIuSB5lsld3FIv+u6gaQOU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=5d9fbHmO; arc=fail smtp.client-ip=40.93.194.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="5d9fbHmO"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cbOmAR97THUL4upUFtBrsvD5AiGqakTwxB1EbiB0MZibI2WFjCr4AHw4vEMS01hTWr6TxRNBlzcVRSt7sTSY73edEJtXSuV0NI/MWIeAaxOulJaKjmus4JabMuP6JEmg7UFsrTQkhNVXg6GhQy23uzHrKBuUe9nDUvmK6EmoWxTFQCRQyPt1h82uT9nftpFA2wAfeQJj0W75T+lA/r+eXyT79cEhIb3b1PiGTNSrhJ8+KHMI2V3MixWkp4jR3x3sdh2PgIbNPZqkwF6ZY9fZ6ymeMDTd2kbenZlq/FAozs3owEmc12j32+N4xuIhmc9lmU+1489LIjejiPTzzKnEhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/dx0FCBdx1di+IosZnEPD7HUVQpId7dtqEQhH6ineJA=;
 b=tkgmNmGked7CG4aZEr1FOijvJCYhAGU7PxcCtq/dcbBbGFCuWc6rShTIRrCH0szUDbeNDUjDmY79DyGBA4RDX8mmqFb6P6RZnrN8GmUkT403qXeqNsSmZFtxl82aL4EUHfzpmsZcxU9O0in6Xb6qB1kWTi7p5g2O27DQhmo+PK3Kx09w+kd67SkE4HXxUNGcXw3NGCNaBrFbiuGiBJ7mxRQtPZ+kEIZrf5u6RMpNueRnbJWC/oxlJM8x9bVIthM/lo+X1C4WBEl1/3BKWa+PIjbrOPsL2mA0uMqnJblkeBJwhhtVEBHHP6Ke68hqg/J7veiOYj/Rf3Ua+dIHuABnMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/dx0FCBdx1di+IosZnEPD7HUVQpId7dtqEQhH6ineJA=;
 b=5d9fbHmOU2Rs9NmlmCZbopmSsU42K4o0yqUN/nbbiXXd1IJ/egaCm0/VHIjZ9JxxU3FCkSBQpyc65xJIq7aU9Gwx6MnVXqe7BhrsO19rXTxsUbhy6jbZjRpZR4Ym5++HmsEwdYr5qYkIsguljn2zOzchBB9F7uZ+CKjkZlysWas=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM6PR12MB4202.namprd12.prod.outlook.com (2603:10b6:5:219::22)
 by DM4PR12MB8475.namprd12.prod.outlook.com (2603:10b6:8:190::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Tue, 24 Feb
 2026 18:13:36 +0000
Received: from DM6PR12MB4202.namprd12.prod.outlook.com
 ([fe80::9e55:f616:6a93:7a3d]) by DM6PR12MB4202.namprd12.prod.outlook.com
 ([fe80::9e55:f616:6a93:7a3d%4]) with mapi id 15.20.9632.017; Tue, 24 Feb 2026
 18:13:36 +0000
Message-ID: <a560c14c-410c-4ea8-9076-deeb9ba28fee@amd.com>
Date: Tue, 24 Feb 2026 18:13:32 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V6 12/18] cxl/region: Add devm_cxl_pmem_add_region() for
 pmem region creation
Content-Language: en-US
To: Neeraj Kumar <s.neeraj@samsung.com>, linux-cxl@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com
References: <20260123113112.3488381-1-s.neeraj@samsung.com>
 <CGME20260123113141epcas5p49a1eebff4401a7fc98381358162fde2b@epcas5p4.samsung.com>
 <20260123113112.3488381-13-s.neeraj@samsung.com>
From: Alejandro Lucero Palau <alucerop@amd.com>
In-Reply-To: <20260123113112.3488381-13-s.neeraj@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO2P265CA0476.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a2::32) To DM6PR12MB4202.namprd12.prod.outlook.com
 (2603:10b6:5:219::22)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB4202:EE_|DM4PR12MB8475:EE_
X-MS-Office365-Filtering-Correlation-Id: 825b929d-30cf-409a-a536-08de73d06d9e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?K0loeS9qd3FlMEx3a1QzdlI5WnUzTDZ0MkdsZzlrdkZ0UFU3OTJNdDNNRWp1?=
 =?utf-8?B?MVQ2RVpsNGlWUFZySlhsWk95SkU5WHY3STlKU3VadmxXTUpVVUZxNXpOVUxR?=
 =?utf-8?B?ZWdXc0VqcUw3SThqU1NsY1ZtbGxaZ040RjBFZ0xrR2pPVlNTNzFxUzFQYTZy?=
 =?utf-8?B?QWFHd1JXK2lOTG5SeklnbTUyNGhkRW9TdWcrTUVGMFlXenRHSGNaeUVIWUJW?=
 =?utf-8?B?K2RqMDFCYzZRSjQ2VmRmalkzalFlSHF1dUl1bUFHR01Wdml3Z2lncnVYSS9p?=
 =?utf-8?B?WU5IVXFOUXZNdEJleU9TUVBGakhXOGFrMHRkZE8wK2llQlB5ZWRiSVEwT3NC?=
 =?utf-8?B?NFlxODFoNGdNc3ViUjlPNzBTcEhUaytncUpjam5PVjJ4Vk5jS01UczJjU3po?=
 =?utf-8?B?b21RUENpL1hzcmQ2WTZRVDNBVjJUdnBiZmgwaTdTZ09jbDdYek1yb0g1TG1x?=
 =?utf-8?B?SVUrUmd5NnJXUUR4RjZsR21wTVdiT0xaOStDNm80K0JxVDZuL2F2eFpidEtB?=
 =?utf-8?B?OFFtZk91WnVjOG5KMXpJcTRKZHZSbUVJQlp5NEt4enJrWGlXMzJscXVzZlB3?=
 =?utf-8?B?T01UbmFZQ1Qwc1JtMnRna2JRanoxSStNdkxtL3FjQzBCbkE4ekNPcGxzTkFF?=
 =?utf-8?B?Q1ZIcjk0alhKZ0VoRXJwM1N4MWlOUm9EWFlud2J0bTI3RzVzMlZrUGdBRzNF?=
 =?utf-8?B?bzk1aCtieGc1eXZtdk85eElHVDZOcjdrSldCK0ZvUmlDY3lTNUZmdFdZanFs?=
 =?utf-8?B?NmNzRmZmc2Y2SzVMWkgvYXpBcGZBWGhvc0FCRWUvaEZnS0x0U2RmYlQxQ1px?=
 =?utf-8?B?em16MmJWV25OYmRsSll1M2o1UEcwcWMvbm0zWXk0V3M2MmwwVERpRkJTSFJ5?=
 =?utf-8?B?b3JGYk52N083d1NwbzdkLzZoaHdLQ0xrUXU2OEpWMzZaZFhHTjNiTm15OXJw?=
 =?utf-8?B?M2FTOWdjTHd2ZExtV2I5QndOVlo1RjNldXYvUU91YjBwQXJOeUJHYUFUN3o0?=
 =?utf-8?B?OExXVzlJMXlWUkpnVUxMSVA2TjJTVEQ2MWpUd3dXSjd3VjkvMG5WM3pNZm9O?=
 =?utf-8?B?czhtMXRCTENacHBmdVRYRUNzaDhOQXU4OXQ1K0NVaHdRUFFMZ2NCSzJSckxi?=
 =?utf-8?B?NDVTSTZwSnhGSkpDMUdEVzZZMUV3MFZaQU1jNy8rWHM4NG5KNG9TbG5ncUpG?=
 =?utf-8?B?Z1AxVEJtTjRDNDdERjJBZUhKUm4xWnZGWnM0Nkc2azF0MXo4UHdxajhFR2FP?=
 =?utf-8?B?VUEzTmtNZk1MT1ZJcXdISjc1RXRTdS9iQ1FwQTlaV1FRd0NiSFE0SjRtQVNU?=
 =?utf-8?B?UmZGb3pwM0lHRmxBNkZ1TWhDWGJaN2Z1NE9qRlhjcmREK1puVGtTY3ZsRTZs?=
 =?utf-8?B?NlF2ZFMvUWdLSTAwem1wVythb3k0bU5JODBXRWQzbjJVRFdGK0FiLzZpREF0?=
 =?utf-8?B?QndVY1BsSjFBQlV6YjNqTk1FUmVOZ0JKdks3THd1TkJHVzRtQnVxejhpM3pM?=
 =?utf-8?B?MDVuMjFYY0w3WS9OTHNzajZtL3RGd291a0szYzRiQmwvWGQ1SjNiWjVja0VJ?=
 =?utf-8?B?VGRQZDN6aHdHa0hHSHFRZWhaUWZaSDB3eUtHWmhidUNjMHFXSHlYV2FjRFB5?=
 =?utf-8?B?SzZHMG5XenFBbGhhczhLbW1EVEF1aGtDbHBTMGZNTVR6TUsrVGZsSlNRcjhK?=
 =?utf-8?B?cktIVGxRVkE0M1dPT0kwTk9qSWU3WGI2Z1pHK29SUzczVG4rY1cvSHVoUFpz?=
 =?utf-8?B?bTlYNmxnQkxFaUFHU0ZNYmlrdnMzRXFvVnNJeFlCSUNPWmZNQkduV2hMTFJn?=
 =?utf-8?B?TldLNEkwM2FaM3FqeENuQ1p1c0ZBRHorTmZDcVBTVXVOQy9YcXpqMzhZRWJy?=
 =?utf-8?B?SDNYaU13dnk0MG5CeXBnMFREbU1nOVZPdUZKdllpT1B0aWtkZ25GZ1A3SEs1?=
 =?utf-8?B?VkJtaVZ5M2RSUkx0OEFBWnprWGdWZ2k1STJuZ1dHNFoydGpjYlk2Nzlxb0Nk?=
 =?utf-8?B?SFMyczEyUkZ4MlZ3a29DRkxHblRNc1JTejdkNFlnVER2SWt2dDc3R0dSMFhB?=
 =?utf-8?B?Y25kNzBkcDdKWFErd2MxNTlDQ1pXSnJlSFBJblF3aVhMQUd4YzJCY3JJampX?=
 =?utf-8?Q?f+ZAPm6nzhMUeRtZIJRzfU18D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4202.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?emZ2cTR5ZWJCVmZmSjdKUFBLL0JHWW5jc29ETU92SUJ5aUtCSEYxMlZJdnFk?=
 =?utf-8?B?cVp0UGhiQ25DOGJJRXdxZHRpYzAwME5FVWxocUhZRVRYYWNWYUthTjJHbFhu?=
 =?utf-8?B?N2lBVHR3cUJRczU3VWZxN2hBZ3U4ckhJbit5UmhudkdWdXkvZncxZWNZdWg2?=
 =?utf-8?B?Zzd1YllWbkhtWXV5MmxpMWxWN25XaVlwVEhqL3cwQVp5OUI1R0t1KzFFSVBi?=
 =?utf-8?B?eWFnOEZ5NExwblg5L2xNd0J2RFErd012QWNNUXlzZStHSWVEZVFJZ01VQU11?=
 =?utf-8?B?VFlzVmlaMnhlVlhLS05nUHM3YUh3WEt6WjdMR09YU3REbllZbnVqdGhiWmgw?=
 =?utf-8?B?UDdVelVIaGgyOC9yMm9ETUwvK3NnRTBZQmtBNmsyU0gzdTJOOWtmdVJlbUE4?=
 =?utf-8?B?ODJBNytUNUZvZzRZWjdPVW1vc3N0V24xL041TXZEZnVGUEx6NHNBRDV3Zi8r?=
 =?utf-8?B?WENPM0RZQmpTU1pZMjVGTCtzUkVRaG53Q2JaTTRuV3V0Nmk1L3NSQ1VncDlY?=
 =?utf-8?B?NmUyRExJQnlIYlBNNUE1OHE3T1huQzB5MHBrSWI0blZMWjBmUjFDNVhGa2Mr?=
 =?utf-8?B?QXNGZ050UFN0clhpZysvWTFialpCUnVuNUVFT05YengzZlNPR2JkdlBiK21G?=
 =?utf-8?B?SkQ4Mmc5c0RYb1p5SHprSkU4ZlE0NkVWc1doR1V5SWlncnAyelNvbSs5UDdO?=
 =?utf-8?B?QllBeEIwVElHMTBaNG5HejR6WHpVeUdhdE1UWXVZWFV1S2VDcTRIMHpqK255?=
 =?utf-8?B?eWpaOGxzNVVwWGZPeDlVOUdTUi9jMjRSZ0xTSCttbzU4L3g5VzdPVUlmZk96?=
 =?utf-8?B?MGg4bUg0amFFaEZFVmRoelBoN1Bac2FVYTRvdEl5QWVDYVVYbUhqTWRKd0RI?=
 =?utf-8?B?V2hwdXlZVmZPS2xGM0Q4VDBDVjlWMFJHL0lUUDBhZ21takxieWk3cDZmQkxy?=
 =?utf-8?B?V2tob2J2TldaWEo5NGgweEpySUFTMXpNU0I4MDgxNGR3eHY4NEVta0tQb1Q1?=
 =?utf-8?B?TTkwUmRkdlNPQi9GTEVTYUUySWZ2WFZJOWRIYUVKY2x2M0luQ1FHY0xyUHdi?=
 =?utf-8?B?MUxkWm1DS1lkSzdoTzNvcDVIVWZ0ZFQ3aUtZMmUrYW1pYzR6TmFCSkNkL3lT?=
 =?utf-8?B?a25RVEphS0tIYjhVd3lGL1pZM2tMM04vNzFyaHFMeExsL1Nkb2pNVkM5Q2lk?=
 =?utf-8?B?WEtIbHpkK3diaWVBbDhqQmVqRzV3WGNMelpldWJvYzJROCtveXJTRVJaMDdR?=
 =?utf-8?B?bU5NZm5WMEN2Z01mWG9UTXBTQXVKcDNpaUpLOGd6bDQ4dHQ4T2FpVkhwS1hV?=
 =?utf-8?B?T2lOL0JMZDlZaDJ2SFBNLzFSZ2N2bnNHYm9pdzA3Q1VSdUhMeTBFcEllTlNF?=
 =?utf-8?B?cjVPaUsvNFFpbWl0RHVxbHRJeVNsT2ZrQXN3b2pmb2FNa3pqNWhhNDJNSTRh?=
 =?utf-8?B?UUhGWjZ0QUZaQkFpSUJzVGc2SlZ4R25SSmFFVXZhQUw2WG8wMGszQW1KRzZs?=
 =?utf-8?B?dm0ySitTZkswU2l4RTF5dHo0V0JRS3AyNVBGMEtQK3lKWnB3ekc3Q28zYTV5?=
 =?utf-8?B?Ym93RXA5MXNvSTkxejhuL1IyV0pYOVNUL2Q2alJhOG9QblN1WHEzNG94Qzhv?=
 =?utf-8?B?bHYvWWk2Z2ZDMEdzNHRMaFFPVHIxY2xzUjFZM1BCb25kb2RKcDhzT3JBdmxa?=
 =?utf-8?B?L3ZMa2txOW9MNVJlVEtpSXdxODhVRnFaUEhkRTFvWFZSc1RtV1ZKS0tOdXFW?=
 =?utf-8?B?TGFRalJKdFc0UUJ4Q3FqZ3cwZmRWeFN6QUZ6ZXA5SUxzdWpmL3dkNEZFUHRw?=
 =?utf-8?B?RU12ZXh4WGRTQ09BK05JcEFwUFlpYlI5T2hnTndCSmFLTFhUcW10aEoxdVg4?=
 =?utf-8?B?TmkvanM1eExEVndZRlljYmdKQVBpbE90YW5YdzRFaTZLZlRGNnJIT2xZMU1R?=
 =?utf-8?B?YkJyc2xEbDJ5UU1Xb0pFM0dhclZVNUZTWlJGSVZPNEFXSkd6S2pSaTFaRVEr?=
 =?utf-8?B?S2NTL1ZFcXNBT2VMeFN1ZzVhc09sclNWSzVtVG5uOWJTZVpPbWJzVW03c0g3?=
 =?utf-8?B?RzZ4UFVBYjhqc0xtMUJRR09jM3ZrOXY4QS82dFJyenkwVTB3cjNDazJmVTNv?=
 =?utf-8?B?alBrRFJVMWkxYXpJY254cHM0dDE3RGMxRmZYelpsN1FkTHA5ZWd0cGdiYkV2?=
 =?utf-8?B?MkdnT2g3ckhITm53eXV0RjVheUthS3c0OVpONUl5ellUWDU1MDR5b3J2OVli?=
 =?utf-8?B?R2tHa2VOcTZZV28xMXJaOFlyVEpIYkZId3pNT3E1MnkwdkZtVUl2aFI0Um5q?=
 =?utf-8?B?dFNhR2ZNZ0NlR3pXYzQxSm44VUdHMGQ4TFFJSE9lTEFqSkZtbUlzdz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 825b929d-30cf-409a-a536-08de73d06d9e
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4202.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2026 18:13:36.4966
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FWAs7R9CcmWgZ+ztaKZeFcpgBDYLFCRu9akXJ5zB8q6AM1adTBWFB8ysTnFVY3CgJFPU58k01Bsa7aozkJ9wIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB8475

Hi Neeraj,


I could get some free time for reviewing this series. Dan pointed out to 
potential conflicts with my Type2 series, so I'm focused on those 
patches modifying the cxl region creation and how it is being used.


I do not know if you are aware of the Type2 work, although I dare to say 
you are not since some of the functionality is duplicated ... and in 
your case skipping some steps.


Below my comments.


On 1/23/26 11:31, Neeraj Kumar wrote:
> devm_cxl_pmem_add_region() is used to create cxl region based on region
> information scanned from LSA.
>
> devm_cxl_add_region() is used to just allocate cxlr and its fields are
> filled later by userspace tool using device attributes (*_store()).
>
> Inspiration for devm_cxl_pmem_add_region() is taken from these device
> attributes (_store*) calls. It allocates cxlr and fills information
> parsed from LSA and calls device_add(&cxlr->dev) to initiate further
> region creation porbes
>
> Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
> ---
>   drivers/cxl/core/region.c | 118 ++++++++++++++++++++++++++++++++++++++
>   1 file changed, 118 insertions(+)
>
> diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
> index 2e60e5e72551..e384eacc46ae 100644
> --- a/drivers/cxl/core/region.c
> +++ b/drivers/cxl/core/region.c
> @@ -2621,6 +2621,121 @@ static struct cxl_region *devm_cxl_add_region(struct cxl_root_decoder *cxlrd,
>   	return ERR_PTR(rc);
>   }
>   
> +static ssize_t alloc_region_hpa(struct cxl_region *cxlr, u64 size)
> +{
> +	int rc;
> +
> +	if (!size)
> +		return -EINVAL;
> +
> +	ACQUIRE(rwsem_write_kill, rwsem)(&cxl_rwsem.region);
> +	if ((rc = ACQUIRE_ERR(rwsem_write_kill, &rwsem)))
> +		return rc;
> +
> +	return alloc_hpa(cxlr, size);
> +}


Type2 has a more elaborated function preceding the final hpa 
allocation.  First of all, the root decoder needs to match the endpoint 
type or to have support for it. Then interleave ways taken into account. 
I know you are only supporting 1 way, what I guess makes the initial 
support easier, but although some check for not supporting > 1 is fine 
(I guess this takes a lot of work for matching at least LSA labels and 
maybe something harder), the core code should support that, mainly 
because there is ongoing work adding it. In my case I did not need 
interleaving and it is unlikely other Type2 devices will need it in the 
near future, but the support is there:

https://lore.kernel.org/linux-cxl/20260201155438.2664640-1-alejandro.lucero-palau@amd.com/T/#m56bf70b58bb995082680bf363fd3f6d6f2b074d2


> +
> +static ssize_t alloc_region_dpa(struct cxl_endpoint_decoder *cxled, u64 size)
> +{
> +	if (!size)
> +		return -EINVAL;
> +
> +	if (!IS_ALIGNED(size, SZ_256M))
> +		return -EINVAL;
> +
> +	return cxl_dpa_alloc(cxled, size);
> +}


I'm not sure if the same applies here as you are passing an endpoint 
decoder already, but FWIW:


https://lore.kernel.org/linux-cxl/20260201155438.2664640-1-alejandro.lucero-palau@amd.com/T/#m38ff266e931fd9c932bc54d000b7ea72186493be


I'm sending type2 individual patches for facilitating the integration, 
and I'll focus next on these two referenced ones so you could use them asap.


Thank you,

Alejandro


> +
> +static struct cxl_region *
> +cxl_pmem_region_prep(struct cxl_root_decoder *cxlrd, int id,
> +		     struct cxl_pmem_region_params *params,
> +		     struct cxl_endpoint_decoder *cxled,
> +		     enum cxl_decoder_type type)
> +{
> +	struct cxl_region_params *p;
> +	struct device *dev;
> +	int rc;
> +
> +	struct cxl_region *cxlr __free(put_cxl_region) =
> +		cxl_region_alloc(cxlrd, id);
> +	if (IS_ERR(cxlr))
> +		return cxlr;
> +
> +	dev = &cxlr->dev;
> +	rc = dev_set_name(dev, "region%d", id);
> +	if (rc)
> +		return ERR_PTR(rc);
> +
> +	cxlr->mode = CXL_PARTMODE_PMEM;
> +	cxlr->type = type;
> +
> +	p = &cxlr->params;
> +	p->uuid = params->uuid;
> +	p->interleave_ways = params->nlabel;
> +	p->interleave_granularity = params->ig;
> +
> +	rc = alloc_region_hpa(cxlr, params->rawsize);
> +	if (rc)
> +		return ERR_PTR(rc);
> +
> +	rc = cxl_dpa_set_part(cxled, CXL_PARTMODE_PMEM);
> +	if (rc)
> +		return ERR_PTR(rc);
> +
> +	rc = alloc_region_dpa(cxled, params->rawsize);
> +	if (rc)
> +		return ERR_PTR(rc);
> +
> +	/*
> +	 * TODO: Currently we have support of interleave_way == 1, where
> +	 * we can only have one region per mem device. It means mem device
> +	 * position (params->position) will always be 0. It is therefore
> +	 * attaching only one target at params->position
> +	 */
> +	if (params->position)
> +		return ERR_PTR(-EOPNOTSUPP);
> +
> +	rc = attach_target(cxlr, cxled, params->position, TASK_INTERRUPTIBLE);
> +	if (rc)
> +		return ERR_PTR(rc);
> +
> +	rc = __commit(cxlr);
> +	if (rc)
> +		return ERR_PTR(rc);
> +
> +	rc = device_add(dev);
> +	if (rc)
> +		return ERR_PTR(rc);
> +
> +	return no_free_ptr(cxlr);
> +}
> +
> +static struct cxl_region *
> +devm_cxl_pmem_add_region(struct cxl_root_decoder *cxlrd, int id,
> +			 struct cxl_pmem_region_params *params,
> +			 struct cxl_endpoint_decoder *cxled,
> +			 enum cxl_decoder_type type)
> +{
> +	struct cxl_port *root_port;
> +	struct cxl_region *cxlr;
> +	int rc;
> +
> +	cxlr = cxl_pmem_region_prep(cxlrd, id, params, cxled, type);
> +	if (IS_ERR(cxlr))
> +		return cxlr;
> +
> +	root_port = to_cxl_port(cxlrd->cxlsd.cxld.dev.parent);
> +	rc = devm_add_action_or_reset(root_port->uport_dev,
> +				      unregister_region, cxlr);
> +	if (rc)
> +		return ERR_PTR(rc);
> +
> +	dev_dbg(root_port->uport_dev, "%s: created %s\n",
> +		dev_name(&cxlrd->cxlsd.cxld.dev), dev_name(&cxlr->dev));
> +
> +	return cxlr;
> +}
> +
>   static ssize_t __create_region_show(struct cxl_root_decoder *cxlrd, char *buf)
>   {
>   	return sysfs_emit(buf, "region%u\n", atomic_read(&cxlrd->region_id));
> @@ -2663,6 +2778,9 @@ struct cxl_region *cxl_create_region(struct cxl_root_decoder *cxlrd,
>   		return ERR_PTR(-EBUSY);
>   	}
>   
> +	if (pmem_params)
> +		return devm_cxl_pmem_add_region(cxlrd, id, pmem_params, cxled,
> +						CXL_DECODER_HOSTONLYMEM);
>   	return devm_cxl_add_region(cxlrd, id, mode, CXL_DECODER_HOSTONLYMEM);
>   }
>   

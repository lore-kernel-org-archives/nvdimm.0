Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13C651386AD
	for <nvdimm@lists.linux.dev>; Thu, 25 Jan 2024 21:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.55.52.115
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706218852; cv=fail; b=ntmE3AEKC3beGb6OTrEAdSYRoC7wYgMbEtbWFpIoqNOdDVzYJJKdsX5omiXCyIhrRJK/U/n5a85xkVhjZurQCjbjx1t4cFjFhIKRrcBgSCi2kOWX6Nf82kSDf1TH1qmSmQsv5CiFwrsvdQbvNkOkSd+DtYMrai0k9KUlrDz8YSw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706218852; c=relaxed/simple;
	bh=r0SvJNJ8poXiFFIdoG3uT9k5f2xC96Xc1IGDBJjHcK8=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=FlXGOESgD3e6RYa81s4QdOp4a9T7pSeJ+l3q9+tRHzXOw2vvy9byqpqfHl5LMhASvQZif0+fubRYqY5c9wsRkjXQX+UtVOFdha137Xc7weYVS1LeMiBRV33JOK0Terg3gc6sq9nFqDmKtSLJi1t8WZXj46RBPnN7D8vBlzydEm8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iRWKXk/F; arc=fail smtp.client-ip=192.55.52.115
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iRWKXk/F"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706218849; x=1737754849;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=r0SvJNJ8poXiFFIdoG3uT9k5f2xC96Xc1IGDBJjHcK8=;
  b=iRWKXk/FD8iiDACrYqGVVatGnTjnyFCKp/UXeHEnyhfW5HN4rDUDiYhk
   nrutPgjY6VrVjl/scY7MgLfRZD/orTin3gVtgMl/QwAr20A9eVUEkjuf6
   +AzWJsAqXU8UzVPRqd8vN06qdFLFcfwuHnsfrl/lJ8Qu9i7ZTewp0dEDy
   XTR/qc/hANeVbCDCtQ8TJruzb4v3SK7qqy9x9Ux0EYcTLRTfEfDpu3N7W
   gA8o7ftY4vHqfjPdCYREXD7b8DS2cHChqybZS+6nQ8SB3O9u6Ur3wkWuk
   EhuXpcopPPThp4rMcjXM6TrbfruoDifyfCYQoCHdNfxNJ6EPqrx2bLbeV
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="401962818"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="401962818"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2024 13:40:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="2390681"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Jan 2024 13:40:48 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 25 Jan 2024 13:40:47 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 25 Jan 2024 13:40:47 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 25 Jan 2024 13:40:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jZYEx/LGRwiIV6fT99MNeTZyLswjkcbYw10fL0r9QNJZ1O4BID4uR/CcixuWdNkV3KljtZzUfeLKi0wIgNDjWQBPvtN79T5h5kO2D8bqW7SILq7UD31OSUWIxagfmXQhIa2NL13vmzc46xL2L5TIWeDWfDf1jNMH/wxR8kVSVEj1nbTmg6rYZ1VkIwV1P5v4p1OksiMta2+2PSO/c3IlyNTitbCRHCo4qU8cE6vS1XxVhMIC/YZ1GPq0C0jn15ELsoPNthl3krId5s8JFVmJvgjOJIy1xPEql0Smk4CpnNnpp1YKWLoH04BpW/B+gy7lPErVWXIlsAGUweiGa1k7xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+k0Z3iDO+ukLIV563c4bclr0c5zC8Y131/d+p+cTb54=;
 b=l0nXLLTRF5DpL1UfEaeHWgTO/w+zETp+96MQudUZ/419fJ4RNos3JveD333RJGdNWZK02LVh0LO1F8DAj1U4Uqv6eUBNTowLns65xpMpGWWqwiyumW+4HSKZP/6MndE2I3hycE0a1fTO3+c/kj4+3sImKxGk65nP4Wu4rRR5Sjer7WN8RJfK1Znly1tZ1q0f6LZKvypkQ8//1bMecXv1N12tib+Ltu6Q+G6kkbK6EJHabLi57lsPhTeQYUReyrkgDOIg5eGXeOWeqK+JOIl7BJgSY9m6QR8r+CPoO5AndCeZpUnxvEVKjyuJoE48fjI2xKaBPyFz3mnudMknEqMN+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH7PR11MB5984.namprd11.prod.outlook.com (2603:10b6:510:1e3::15)
 by SN7PR11MB8111.namprd11.prod.outlook.com (2603:10b6:806:2e9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7202.37; Thu, 25 Jan
 2024 21:40:45 +0000
Received: from PH7PR11MB5984.namprd11.prod.outlook.com
 ([fe80::780:d536:ff24:3e4c]) by PH7PR11MB5984.namprd11.prod.outlook.com
 ([fe80::780:d536:ff24:3e4c%3]) with mapi id 15.20.7202.034; Thu, 25 Jan 2024
 21:40:45 +0000
Message-ID: <b1d5d419-7625-4c88-bf9b-50736662f330@intel.com>
Date: Thu, 25 Jan 2024 14:40:41 -0700
User-Agent: Betterbird (Linux)
Subject: Re: [NDCTL PATCH v3 0/3] ndctl: Add support of qos_class for CXL CLI
To: Dan Williams <dan.j.williams@intel.com>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>
CC: <vishal.l.verma@intel.com>
References: <170612961495.2745924.4942817284170536877.stgit@djiang5-mobl3>
 <65b2cfa5d3541_37ad2947b@dwillia2-xfh.jf.intel.com.notmuch>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <65b2cfa5d3541_37ad2947b@dwillia2-xfh.jf.intel.com.notmuch>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR06CA0038.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::15) To PH7PR11MB5984.namprd11.prod.outlook.com
 (2603:10b6:510:1e3::15)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB5984:EE_|SN7PR11MB8111:EE_
X-MS-Office365-Filtering-Correlation-Id: f85c9e92-eeef-47e0-0d11-08dc1dee4959
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RTjS/yLEMtgQoI4/XPRboEXW9H94PJ1AKSLQp+DW4/6W79XHR8j8HU0FVsvFA9wGz2LgJ+B1vLjuFiKcPgTxNS2AlT9Z1npBKEV0mA/pEJ54+KWXeDBG8jLnS5VCatAI9QpxxiAIYI6tQoHo8KbkvholPGE1pRmYrpYR4RmfZ53nS9LUaSumSbhwAw8P56+VsnZv3bGJDTJ5snulb+RrckaWS68W/rh+19kRPtOlXN1rG4gNrHR/Wnoc3KY60qmoMQ+fCgq3gWwL1d1XWRNGuTxCRaQIhpE8/As4fCvKRdO11kJD+aQQxNolpUMK8PI8mcgbFr1kDXH9nfCkxBUQnVf/tYidJD6AkBRCfSlFYzayveQaJ+4Jj8/AFEXz+HZXoJ/hvKcvoJHQdsHmi/yF/hPkqkmtYaAFIJsQiw7FYPBMZHzeYvXnUefB+1yaFqjUFU+PIZbKawOlBhrVD1d0WOvS0eFzRSYoWk2bK8bl8LGuh7oHanyqdAZBZxEY8KO/YS822rtXWHm4WKp48lj/TUOzpfkf4h560U7ZU2kpNk4b7ztOEbjXlD08jdcEJTkV9Gb1/93rKHa5ZdAIYKTlBE56tJIGvqwi8gn4Dy7Nz8SuuDR44nwxw4u83wOwm+RS3t89UCa0Y+CpMr/LD95JxT9aKGaPCKGSJRuP9NxgWd4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5984.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(366004)(396003)(136003)(39860400002)(230273577357003)(230173577357003)(230922051799003)(1800799012)(451199024)(64100799003)(186009)(2906002)(31696002)(86362001)(6512007)(26005)(8676002)(478600001)(2616005)(4326008)(8936002)(41300700001)(107886003)(38100700002)(36756003)(31686004)(66946007)(83380400001)(82960400001)(316002)(6666004)(66476007)(44832011)(5660300002)(66556008)(6506007)(6486002)(53546011)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NHhZUi9FWVRMSkVZWWlTT2FIeDdUMVBUNlpmaXdYNlhHd1JmVGZNZXFoWWdS?=
 =?utf-8?B?Wi9McTlUUWpmNEFIcGp1LzRKMjNmQkVLV043SG1zVDNqZWFFaW03eVBaNXBB?=
 =?utf-8?B?VHhCS3ZGVWFpODU3RUVJWjZ0V0xNQ2NKdXlVTTBoMHJZM3dCTHl4RUdOdHBH?=
 =?utf-8?B?Sk1xbWM1N2FxUERWVytZWjh4QzJCOG5GZU96QnhZRFBnUERiZXhidktNTVFn?=
 =?utf-8?B?QUN3b0JtVDBENUdqTTl6SDFNSEFZUDNEamRKenJsd05ycElZY2RWUm1QUFB4?=
 =?utf-8?B?ZXhLVnNVUlh0RVVRRFp2SmV3elpmaEVVYmZZdmlad1Z5NFFUeEp0dnRSVW9N?=
 =?utf-8?B?eVNvb0VHSDhVQjNIRFhoOGtUT0dxYlBrbzhxTlBCNzJLUmdXUXU4c2lXRzlP?=
 =?utf-8?B?TFJTSkVuOTQ1dytuWWUwWXY3bXFZeWw5VW5lY3A3dkxyaUdWaEZQOCt4WFpj?=
 =?utf-8?B?d3lhdUVkNzU4UFFsZ0xodXBxTHdMNHBPbWdNUElqU2Zjb1ZtQ2pNVk1YcUVn?=
 =?utf-8?B?cG1iOWRPSzAva0ZTL3hlRUZKRFMraEwrVWRCQ2Rmd0NzdGdqcmFqZG9SUUdl?=
 =?utf-8?B?c3JTSmpiNnB4NnFHcldjM0dYWUxFYXROK2U1MU1UVVBic0lySEhKdUN2ZFYr?=
 =?utf-8?B?b2pnYWQ3eUFBbDdQMTRsWGZQYVJYK04xNDNlL0JVbDhrTGNoaFRSSmhsclhh?=
 =?utf-8?B?cU1tSktaalkwWGFXSVRjSnhTZkFGRXZlSEt2SGZXOW9hbTRqWXFWOWF2dFdi?=
 =?utf-8?B?ZU9mYVpXbkYvTWF3a0gwUERPSlZ5UHpJb1lmTzRlTVpGcFRRNVUzcENFVGtN?=
 =?utf-8?B?NXVmbmtxR08rQjBNbVEyNGN6VC84b0tpNW94aTBDNUg5T3JTa2RydzhLTW9M?=
 =?utf-8?B?bUlWdHJTcUVqVXY4TjRFS3hIUUdJdUh3bFEvdHZMSGpBQ0hrNkFTdE9JSnlH?=
 =?utf-8?B?UkpMRGs4elhCcDJ5YlVFK2tycGdqNEJHTzdwTDJwd0w2WFpXZmp1VzBGd3J3?=
 =?utf-8?B?eUhlYkIzc1pFVGErQWxzTmR6S2RmdkJBZ1lscWxQUzNSZ2Q2VkRJUmY0ZFd1?=
 =?utf-8?B?dFlRcjlYTVhzeU82UnBRbWFJQmJVRWNZcEdkZ3VqUXZRTVh4Y0pIajQzRHlo?=
 =?utf-8?B?R2xGZHlVQW01ZUxWcjE4azBRenI2aWVEVXNsK0tSL2tPRlFTTHBWR3NiUldl?=
 =?utf-8?B?OHJEdzJsVUppNk9zM01zZURoVlhOTWlnTHkydXdNRnk5MmE2WktIY3VSOEFx?=
 =?utf-8?B?bjFWa2ZldDBFbFpVbEVGTXd1VVh2UEpZMzFxNFVwTzE2MEFmaDFBaHc5Tlkv?=
 =?utf-8?B?QVF1UTUrczNoVzREaHJ4OHpIYlhKN2QwREtJcytoWEZyVVNKT2tlWFpCWThI?=
 =?utf-8?B?UjFqQVE1d3RBSjlxeVRXWjc4NzQzR2N3SXh6b3dqQXljWnV4amxWcXl5aFZL?=
 =?utf-8?B?VklTNTE2czIxTkZtc0t0NzdqWS84TTQrd3hmdE5IblhCRjVwdWw2blpCUjRW?=
 =?utf-8?B?dUR3Y2Rsd0NkdE4zeE5ObHZ1KzlJRTJ1cUNIeGU5UkdlLzFxOS9LR3RQazE4?=
 =?utf-8?B?WDFQdy9DaUlreFBQczV2eXQxMXlvMUoweFJkWmF2aHcyRGJPdDNxc1h4U01I?=
 =?utf-8?B?OWxRWkJmVllFc0M4WEU4TVN1d21Tc3B5bEJPSEwxYUlYQVFncWNJb0xFL3Er?=
 =?utf-8?B?LzYrRTRTbWN5c1BWUXZacDFVZmNSek5rWlRPN1NrSSs4WkNiYjNMZklISU5T?=
 =?utf-8?B?NUNPVDV5NUNoMTlUaHhNT3pWaXRkK0p1SzZkTDhZUDlhMm9NenBDampZemZ0?=
 =?utf-8?B?czFCTTFRSG8zdmtwZXZWWjgzZ1BwQzRWZXB0Y0E4UWNHZjB5VG0yZ1l6cnVD?=
 =?utf-8?B?T1JrcWs5SjRhMlBCbXI1M29ONmNpVFhtakNlTVhQTm1Ga1UvWjVCdnB5UG94?=
 =?utf-8?B?Z3dqMzZqT0I1VXR3ZTd5eEVkUmg0VnJtV3BIV1Z0SUZOa29VRk9kT2IyUm5M?=
 =?utf-8?B?cXJqR1NhOXl4MWJxbWVYbFlhOEkrcXJOclV1Qm9WWGMzWGx5alhBbnNsN1dt?=
 =?utf-8?B?NE9GdUg4aHMva3dFakdveTJyNHkyUkR4YlZyRTdPRHlic3BaTFloQWZtM3VS?=
 =?utf-8?Q?LVbK24R+vd0XWmDv6EZHymvin?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f85c9e92-eeef-47e0-0d11-08dc1dee4959
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5984.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2024 21:40:45.2109
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7R78WwO0X0A2qvtoQAIcqu0lKwb+A2Whkrd9Evhh5rWFWTj99xIoa7LqNjIKC3EYcsqCtX96+xPpDy+dsp2WIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB8111
X-OriginatorOrg: intel.com



On 1/25/24 14:16, Dan Williams wrote:
> Dave Jiang wrote:
>> Hi Vishal,
>> With the QoS class series merged to the v6.8 kernel, can you please review and
>> apply this series to ndctl if acceptable?
>>
>> v3:
>> - Rebase against latest ndctl/pending branch.
>>
>> The series adds support for the kernel enabling of QoS class in the v6.8
>> kernel. The kernel exports a qos_class token for the root decoders (CFMWS) and as
>> well as for the CXL memory devices. The qos_class exported for a device is
>> calculated by the driver during device probe. Currently a qos_class is exported
>> for the volatile partition (ram) and another for the persistent partition (pmem).
>> In the future qos_class will be exported for DCD regions. Display of qos_class is
>> through the CXL CLI list command with -vvv for extra verbose.
>>
>> A qos_class check as also been added for region creation. A warning is emitted
>> when the qos_class of a memory range of a CXL memory device being included in
>> the CXL region assembly does not match the qos_class of the root decoder. Options
>> are available to suppress the warning or to fail the region creation. This
>> enabling provides a guidance on flagging memory ranges being used is not
>> optimal for performance for the CXL region to be formed.
>>
>> ---
>>
>> Dave Jiang (3):
>>       ndctl: cxl: Add QoS class retrieval for the root decoder
>>       ndctl: cxl: Add QoS class support for the memory device
>>       ndctl: cxl: add QoS class check for CXL region creation
>>
>>
>>  Documentation/cxl/cxl-create-region.txt |  9 ++++
>>  cxl/filter.h                            |  4 ++
>>  cxl/json.c                              | 46 ++++++++++++++++-
>>  cxl/lib/libcxl.c                        | 62 +++++++++++++++++++++++
>>  cxl/lib/libcxl.sym                      |  3 ++
>>  cxl/lib/private.h                       |  3 ++
>>  cxl/libcxl.h                            | 10 ++++
>>  cxl/list.c                              |  1 +
>>  cxl/region.c                            | 67 ++++++++++++++++++++++++-
>>  util/json.h                             |  1 +
>>  10 files changed, 204 insertions(+), 2 deletions(-)
> 
> This needs changes to test/cxl-topology.sh to validate that the
> qos_class file pops in the right place per and has prepopulated values
> per cxl_test expectation.

Do we need to plumb cxl_test to support qos_class with mock functions? Currently cxl_test does not support qos_class under memdev due it not support CDAT, HMAT/SRAT, and any of the PCIe bandwidth/latency attributes. It only has root decoder qos_class exposed. 

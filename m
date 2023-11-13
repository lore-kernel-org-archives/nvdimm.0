Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96B411F5FC
	for <nvdimm@lists.linux.dev>; Mon, 13 Nov 2023 15:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FStC2ZAL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699888012; x=1731424012;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=3b2XTHGzUZ0gYuMuqysLYT9El6BM4YLtMTJ28SsPxy4=;
  b=FStC2ZALpsm2m6VQD2YPUPfhlvxhlgck9jj1Js+ZlGQ1xG2SRNcBlgUT
   FW6C2Q4/LVXCA/92o4qpe+ISJGVlWtS9F5wc4nMKuuqWUKhxcSatx+dng
   WvE8gXqtKGmvZTqfBqOOtm7axykwfzR0CDcFy4CgtGg4rkgF/sAIz1otC
   Mj8FQ0Fao534Q01PTTMzNa4UqirUoF1Wg+K2t/0s8GkUPYK5trXtJIw5L
   TOY/M7OF57+p83GDCzH3n5Htyp7UiFSEh8BTSNXXRGt0SutOwgwdZMURO
   pcBko47EXwKpxvJ+rF//sANrkPS9qbEisk0po8W9yR0GjWYbeSJcT020a
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10893"; a="12002160"
X-IronPort-AV: E=Sophos;i="6.03,299,1694761200"; 
   d="scan'208";a="12002160"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2023 07:06:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10893"; a="854983425"
X-IronPort-AV: E=Sophos;i="6.03,299,1694761200"; 
   d="scan'208";a="854983425"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by FMSMGA003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 13 Nov 2023 07:06:50 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Mon, 13 Nov 2023 07:06:50 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Mon, 13 Nov 2023 07:06:50 -0800
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Mon, 13 Nov 2023 07:06:49 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oL3C6R3xsYCqxOtWetXPRRVKE7SpLaATx75GM1VutT0W473KBjnYXBsJsruoW3/C8jseHmRSdUKtXi465+yDp/zqkxGBhiFJMIXH1ARhQNv2AKTuDZ4hExDvwpUPz4tm4onj7NIQeiQH057Dhxi5jeIp+XP6zpzlwOOLNrQbKxvpVHm2UvHXfCiRy+vlWvoZifXgFEu0MdNDE1EBpR4CoSWFU8u65udWab3BKdYmqPjlhOtgOqrmeBPWd+ueAGtZl+9NLG4BsSk2fS3PTQlRaIaS1dwmwOdkvt6RBnYRFPlHG1LT7v7UORTvzODP/7Yf4E45ciMjnmAz1Bt6IQIVIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OjMj3NdPm+VqQEF8ocw1slVQKGqcED5hChY3DLPACY0=;
 b=Z+4n6c7oWDvXUoIFbu5QO+KP4iQo3h3mb4FpwTEG1pt5ew0hUKiyVohIfjwCpwrUR3FqAVmJOB2jFUmQMA3RW6EruZRsWjl2vBBfZTfOPIvuUyF/76E5oOlCDgv6A66LDXLPkFsh9R2qDWyErLVFmcXX9jF70xXphyIuDV6GsXEhgoUkc+RVWlFm+GcI8vaCsejOzrQq2sdLP4qEWeuLsjP/LQu3dnRs3S6xr8FdbvSQ0TfkAobpch25EOQsSwRm8uPRbA+SoDX82CjRCjYAwf98LVxU5drSvx8EnAJ6D6jNh4lXW4iCL+u+T+t35bEvgxB1zD6z0ehbwMiQnag/Ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH7PR11MB5984.namprd11.prod.outlook.com (2603:10b6:510:1e3::15)
 by DM6PR11MB4673.namprd11.prod.outlook.com (2603:10b6:5:2a4::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6977.31; Mon, 13 Nov
 2023 15:06:47 +0000
Received: from PH7PR11MB5984.namprd11.prod.outlook.com
 ([fe80::28a6:ecda:4bb7:2f9e]) by PH7PR11MB5984.namprd11.prod.outlook.com
 ([fe80::28a6:ecda:4bb7:2f9e%7]) with mapi id 15.20.6977.029; Mon, 13 Nov 2023
 15:06:47 +0000
Message-ID: <c1770ba4-131b-42c6-8e40-4788bf5e38ab@intel.com>
Date: Mon, 13 Nov 2023 08:06:44 -0700
User-Agent: Betterbird (Linux)
Subject: Re: [patch] ndctl: test/daxctl-devices.sh: increase the namespace
 size
To: Jeff Moyer <jmoyer@redhat.com>, <nvdimm@lists.linux.dev>
References: <x49fs1hwk0b.fsf@segfault.usersys.redhat.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <x49fs1hwk0b.fsf@segfault.usersys.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0001.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::6) To PH7PR11MB5984.namprd11.prod.outlook.com
 (2603:10b6:510:1e3::15)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB5984:EE_|DM6PR11MB4673:EE_
X-MS-Office365-Filtering-Correlation-Id: f9c179fb-2b11-4533-a311-08dbe45a27f0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JCaMW0nh2q2Fc3mJQO1DKD4DgoZm8jWzGXQexKyf9FxlzOEGsZU7dgcAbj+LN5XLnZ5sCcEHx9GhPxkKKIMIv/MeBgvwz2O0LuW/J3FlAJrbm7kJzLCcu9A56DPlPDswzP0hDWxJk/sojQ2fxH6p0zImt1NaUNhU2VEkJI+LYzYYz4UxyEFq6yXbpfRLavnOdgzE/iQ9rn0FFhN/ucxKTRDDx4rW0zXJdjW0D1BTU483jOcJemnrirl7UM9XQ2+5E7I+DarzxMv174bhNTIr7L6zyHimeSpFSDlETgsxVVa8jloIkTBwEETxdzm0mN02UQbE3TSsESmL+sMey7tpYjFny+Tp1iV/aUc8tSKX58mnSpWEi1g/ow2I4zFQG2F6KbpDJepHDJExsIuMu/0crv6sBUOlFSAi3Ju6cZyJZpl3rJyfgTdm3138+p5gknkuWYHv2ElrK3YKROSk7wuaPSqEFlK6eTEhFetzybu/6dBFjO2KdkASYbGxORrK3FNK9YtiVuILLo45sQ2vv5eTMklyUqoM2O+rdgCj8R7tNPGGEkG06o66twHxvow0BniaAUjAvmHzSWel/BnQNFmYSBt46yK3E3oWtUnJhrHAvR8k/XrQeXWfyjG72c1v9ae5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5984.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(346002)(396003)(376002)(366004)(230922051799003)(451199024)(1800799009)(186009)(64100799003)(8676002)(8936002)(44832011)(2906002)(5660300002)(2616005)(6512007)(53546011)(26005)(31696002)(41300700001)(31686004)(36756003)(38100700002)(86362001)(66946007)(66556008)(66476007)(316002)(6666004)(6506007)(83380400001)(478600001)(82960400001)(6486002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NzR0SkwxU3N0Qml3b3dRTDlGOEs1bnVpWnpGZi83N2FOUmVmYWg4YTIvY0V0?=
 =?utf-8?B?RHdLQi95ZjhMSloramx5OWlINUE3VXdFNkhLVFZxaEEwRDV2N3FhcEJPWnho?=
 =?utf-8?B?SUpaMDVneFBmQTRoMGxRVkg3MkpSRUFZdnZWMUFxWmkvMjZydDIxY3BqZHl5?=
 =?utf-8?B?YVdWTWQ3T3QrYTR6QjBmaThPL0t5c2hkUXVZREV3Y2VPMXN4NWZZTE9VZzgr?=
 =?utf-8?B?dkw1U3pYWmhYdkRIelA0T3p1eGh3NWxPd1FCU2dYK3BZajViM3BTL093d29w?=
 =?utf-8?B?WE53SVlsbnEreGZrdXhDMTc0bm9ja29kTGx5bnV4QmpwUlI0VDBqbUhJcWto?=
 =?utf-8?B?TmR3bXJCc2NBQksyaTR3cDVLekt4K0U4b0tJY21tdkRNc3p2WnNNcGFUcW9h?=
 =?utf-8?B?Um1YbWpyeDV3ajdXRGlienNOVXNkYUt5T2lYRDRWanZNRHJmZmZTcXdhT0Mz?=
 =?utf-8?B?OXVOekhIak03SzU0c0I1NGtZdkw2Y2FvZ1B2a0xJUmNMQUxxRmJ2dy9WMTJu?=
 =?utf-8?B?K1RYTkthM08rdkx6K0pZTklSMHZwTlJrZEozREEwcFJaL0ZIVC9LZXR1aEtr?=
 =?utf-8?B?QmpGQ09LTjVmY3JES1dtM2U2a2dUb0pQNWdUV0VsZHpmOGJJdzRZVXdOQnhW?=
 =?utf-8?B?QTdjQ3M1L054Vlp5NVQvTmRQZmRQUll3RFg2YTJiYjFyVmF0eG5Dek9KNnR0?=
 =?utf-8?B?engvY0VoMjM2ck44ZTkzdGdIT01YcjZKWVFRVVJQVHlWcWFhRDJUL0VjczYr?=
 =?utf-8?B?OVIwREtOY2wxR1RXUGR1ZjZrNlJOaTJwNjl0YjJEU2h0cUZYTWhHUFM5SVcr?=
 =?utf-8?B?Qm45TFB1QjNaSTJiaUtUYi9INlkxS29rMlJoUzVPUlFSTkN1SmtZZkVlcXQ1?=
 =?utf-8?B?OTEzaUVlVFd0YkpPQXArbnpiR00ySVFpZTd1TGhvZ1lGV0E0VWVuV05oRzB0?=
 =?utf-8?B?THdDSDQyNnBybUJhVnhzY011MU1HU3l4VEgwbjNsMTlOUUVpdXJmT3J6eTdV?=
 =?utf-8?B?akptM3pNeVg2NC83MWFjUE9WUzRkMEtxOEREeDVtbWVubVY2ZmhvLzZqeUs3?=
 =?utf-8?B?M0lFbG0vL09PbGRobTNXOGxVSForL0htTDFrWE85TVJDVW4rL0VyUGUrMU52?=
 =?utf-8?B?dStPeTNJNFB2MXZISHNDMnQ3VW8rblplWlhkRkd4OEVZREJQenpCb3FNeG5W?=
 =?utf-8?B?K3lveGhvcElnalhrV21zY1FhVTlPSjFQQ3N0WDVyQWtWSUE3bzJFY1hEcFRh?=
 =?utf-8?B?ZGs3aEduRU9lMGE1V2MyQzVmTUhBL3d4UDk4TmJRL0Q5OVYxU1J6RnluT1d0?=
 =?utf-8?B?ZjYweFhyOTBDYkljbElQVHgwQ3Nla0ZWWERINDVSaUtDaE9LekpJOWxhdVlL?=
 =?utf-8?B?Z3BTSUlIcWFCVEU4VjZVY080clQvY0pMQWpDWFhCbWFFK25yN0J1SnZkVXh2?=
 =?utf-8?B?SUdxSjNtWUx4OEk2SzEzUFh3MmFVaXFWdkMwWVV4LzRwWGI0RUJlZXBzYTYr?=
 =?utf-8?B?ZUJhWS9JMXNieUhwdlVVanorK0w3RkpjMzA2bkpReW1sdE1KSU1xckpCTGU0?=
 =?utf-8?B?YWl3dko5R3ptb1MxdHhzVXlKcFI3OUlySXlsamZJbjN1SmorUXBTM1JFYUFu?=
 =?utf-8?B?UUZ1WEZxYkRrV2tGbmRzSFJ3UWhseDhQUlFjVk1zYkIydWYyZkFuYkp4K21t?=
 =?utf-8?B?SFZhTUcwZ09rTElqT3FTQUVwa01LYnNlQVZJTmxKMUF3VnVyUnZnbWpTSEZR?=
 =?utf-8?B?UDAzb0h0NFJsWWFwYkFtalJocG5WcFZlbUQxeGNsUG9HRHZLUlBWSmtzVmNJ?=
 =?utf-8?B?YThybWR6M2tDKzRWd2lxd252MFlFajcvWUcvb3VVMEh3ZHI0aG9tK281N0lS?=
 =?utf-8?B?c2RLSGdFWGNkQmsrR0RwNVMrMHJpQVYwS2lvc2VXMERjeGxjaGx1OTVtNmha?=
 =?utf-8?B?a3hYUmN4dkZ3ZjhLVWlsSWN1akVFeENjSXhaRGd0VG0zZzVpME1vbVIvaWFW?=
 =?utf-8?B?andEU0ltVzFCNW1YMXlrcUhBbHRlRFY3bnN1dTlxdmZtT2VucXVXdGhHMGJH?=
 =?utf-8?B?NWhWSExvSGkwc2dYRnp4RjBNSFlibEludzRMNEpKOWdCalN6eTB0bWcvUUtq?=
 =?utf-8?Q?PUCrBmVbKyAGqMrlowYoJhPXr?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f9c179fb-2b11-4533-a311-08dbe45a27f0
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5984.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2023 15:06:47.3003
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D0pBXhYwiAw4IzOLACWyjal4IESrSFmj9ZQkRHdqziCKLb1+4ig7HlzC/Rj0GN//bVjL928+zcvEiHc2Xjssxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4673
X-OriginatorOrg: intel.com



On 11/7/23 10:28, Jeff Moyer wrote:
> Memory hotplug requires the namespace to be aligned to a boundary that
> depends on several factors.  Upstream kernel commit fe124c95df9e
> ("x86/mm: use max memory block size on bare metal") increased the
> typical size/alignment to 2GiB from 256MiB.  As a result, this test no
> longer passes on our bare metal test systems.
> 
> This patch fixes the test failure by bumping the namespace size to
> 4GiB, which leaves room for aligning the start and end to 2GiB.
> 
> Signed-off-by: Jeff Moyer <jmoyer@redhat.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> 
> diff --git a/test/daxctl-devices.sh b/test/daxctl-devices.sh
> index 56c9691..dfce74b 100755
> --- a/test/daxctl-devices.sh
> +++ b/test/daxctl-devices.sh
> @@ -44,7 +44,10 @@ setup_dev()
>  	test -n "$testdev"
>  
>  	"$NDCTL" destroy-namespace -f -b "$testbus" "$testdev"
> -	testdev=$("$NDCTL" create-namespace -b "$testbus" -m devdax -fe "$testdev" -s 256M | \
> +	# x86_64 memory hotplug can require up to a 2GiB-aligned chunk
> +	# of memory.  Create a 4GiB namespace, so that we will still have
> +	# enough room left after aligning the start and end.
> +	testdev=$("$NDCTL" create-namespace -b "$testbus" -m devdax -fe "$testdev" -s 4G | \
>  		jq -er '.dev')
>  	test -n "$testdev"
>  }
> 
> 

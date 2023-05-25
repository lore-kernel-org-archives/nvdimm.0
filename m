Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E90F3D7C
	for <nvdimm@lists.linux.dev>; Thu, 25 May 2023 15:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685028574; x=1716564574;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Z4p/TaH6rrgIzaJBIWGFAdhgRoryu33qVs8edzytE3o=;
  b=Xg1okHEVZ/oAqFUYvtZs6BxA7bjDha3GB6Opp7IppHzEnzpEXyUFC4Y2
   GZ+uYCVtC7FWk2HRYvfWP84QDrzLj9suHSwjZ1LF39j3E3Hnc5Nj+H8Mk
   bwCo+gQIxah93IGLcObdz1L96/AzG3QNBHnsovOYJ+CFWIgdGbePpVRIM
   VHUwLfcNO9vCJgOQcG8DqKr9ZaVm2nuSc7jNgbGcjNUekoEartYqJe/vo
   VJBqmxepIAlJUepQEUuTLiS41oGLr9GuwfrS6OfH/xVezP7Z3lWgxrbBZ
   bLM0xjPi6XkXzk6k+Gc9La+D0IN7QYk04EJhlySi4NOAjCsIYcd83YvIA
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10721"; a="357167861"
X-IronPort-AV: E=Sophos;i="6.00,191,1681196400"; 
   d="scan'208";a="357167861"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2023 08:29:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10721"; a="655231656"
X-IronPort-AV: E=Sophos;i="6.00,191,1681196400"; 
   d="scan'208";a="655231656"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga003.jf.intel.com with ESMTP; 25 May 2023 08:29:21 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 25 May 2023 08:29:20 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 25 May 2023 08:29:20 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 25 May 2023 08:29:20 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.102)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 25 May 2023 08:29:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=STURT9EKzrAtWlSUrTDCMdYOoTQurnGrmu2EFXJhVk75FtnMrrBJSPvxWcKHoL/bYRtLpKLdv40yzxnSBG3/zDtgAjsjJmXpc1OtkgqDP3ZA7JFcf3MXeqmkXkTkKfS+7nBtBsVHgtkn2IK25uckMgz6ff9ABOapweI4cWtc7r+vSJlZtixvRWeSYWr9pB89Lji9oDbKua0qokYbI28TUG+UZgfimOz0YtHLWiVIpvwNv+jEnKTahsEWtvdvSgcbT/VGthMvIcOle9EhHX5ADmVex3yMcWjDCX3hekP8e+aajVtRp6LHweHHx1zDhrNHwE6lzqPZrlX8YKbTHKKWOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VFIVZC1ZiQBpTMuRkzhV5eLsfFBs8ByQEvBCKMg5yGY=;
 b=PIJo6wWhJsDw5+hlg6wISQwHKYnAnII+rBKbFBRIZuhYicW6JtiBemLeuLDu3wyPyvYob4C7CNaq1fDoI+ARsM9H0bay9oWiiyQMsUXUiCNrpg4xThQAVsESg5FS8z7ecffLZZRL5GNwN7+wXv1hbby1jheiPTLCVaO8e+Q/dBkSbLGJmhKGdZ29O+hkXYcFtliM6WeRWrlASRu7YUPRd2aULx7yC4UEtTBM313v8iGmxdrYI8LOdTuoUuUp/o+bsVvlf89J8py2X/A8WyMfWeYQ04mfI6NeTk3tLPBt62mwlVkwqEdqF9DqOXoMg9+pWnRNBwTF3AmcddUIKnfrdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH7PR11MB5984.namprd11.prod.outlook.com (2603:10b6:510:1e3::15)
 by PH0PR11MB5013.namprd11.prod.outlook.com (2603:10b6:510:30::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.16; Thu, 25 May
 2023 15:29:17 +0000
Received: from PH7PR11MB5984.namprd11.prod.outlook.com
 ([fe80::b315:faf6:e706:ca61]) by PH7PR11MB5984.namprd11.prod.outlook.com
 ([fe80::b315:faf6:e706:ca61%5]) with mapi id 15.20.6411.028; Thu, 25 May 2023
 15:29:17 +0000
Message-ID: <b87e4a68-d58d-03ba-539d-7e2b9e7530be@intel.com>
Date: Thu, 25 May 2023 08:29:14 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Betterbird/102.11.0
Subject: Re: [ndctl PATCH 1/2] CONTRIBUTING.md: document cxl mailing list
To: Li Zhijian <lizhijian@fujitsu.com>, <nvdimm@lists.linux.dev>
CC: <linux-cxl@vger.kernel.org>
References: <20230523035704.826188-1-lizhijian@fujitsu.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20230523035704.826188-1-lizhijian@fujitsu.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0370.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::15) To PH7PR11MB5984.namprd11.prod.outlook.com
 (2603:10b6:510:1e3::15)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB5984:EE_|PH0PR11MB5013:EE_
X-MS-Office365-Filtering-Correlation-Id: 468d5246-0ac1-4656-26f4-08db5d34cdb5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: q9yxSc9HyaHMSfIkRckXIcNGQUrbR8nkwbA5FFw6LXzJUpg+Ghn/zO61XPQDDXtCx3C6p3XqyqNoTiH9Ms81jxAna4QN7wmBDReWpq1GcLzs/VHPakayLhU6yLxUOASGqqPuWW5FhmAeT4WVBt3/mZ4pMQAmVgFoaCMz3aqBvu8VeD2YktCvqnN42OTocu3frD/Y4ray81b/qY7rtUeLJrGfCHurx7vuulyRwgkGl8KvsQxHFQuOX4jYbTA+eT4Xfpk2lBGWx1iohUYKsAVNdyPApXKOUSUSe2KQz64b5yxZJa84WhxexMWC7WfL+QMfMU2STtaIdn4B5JGKkvqafZFs8kaDZ0WPDtOft1SCcZkDJbwKZrbb3WjdPIrUmhNcbCNfG7kGTJw76RRrhNPFdZo9t45SvrmAc0jfCfQ55CqzGjTtHgUPjAe7iTxA9qUgigwSe0oyFRk2TdyfyjFL3RuADNMp+ySSqoi/eMm4GFUdcDN+LgDSTn8n8rWh3OTdAl/myAHuG4VkfrlsW0VfJ2OfRb/Gg145yU9pmr2FdHwiIbOck0S8Rv8pGDLCbHRiQmY+kkVuPBPp1GnVwcaC35LcTDOFLoL8fAg1n44v8gxBJJeheL3i9A8A3fkBEIlo3iQUPymzms+flZpVCLK4PvPv3h4GXSruosN/u2rytWLL23JVoyRoJRyyOtrUcBu8Ofz1t8RuHFSnhwnfaDqCsxC29+o3xdxEeARM1DHG108=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5984.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(136003)(396003)(376002)(366004)(346002)(451199021)(31696002)(86362001)(82960400001)(38100700002)(36756003)(6506007)(26005)(6512007)(44832011)(186003)(53546011)(5660300002)(83380400001)(2906002)(2616005)(478600001)(66946007)(8676002)(8936002)(6486002)(66556008)(66476007)(4326008)(41300700001)(6666004)(31686004)(316002)(223123001)(45980500001)(130980200001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T25sMjJUbFJtZW9wdURTUHE2MENkOWNWTFdxbUovMDVtN09kQVFrYnRTYWxL?=
 =?utf-8?B?ODRsTkd1NlFGTG9EMzRLN0swVk9ZTzVBS0txZ25IWnhSTnNJRitHeldNTDIz?=
 =?utf-8?B?S1JQTlczaklFK281WktFblB2UVdhN256K1pQSHFJMUJuUUVaWjR1OVVlSldO?=
 =?utf-8?B?RVFLWFFuSy9KaXZWU0FBdWhsZzJnbE9FTWxkOTVtNys5ZWVwdXhJQkhPaWFW?=
 =?utf-8?B?dW1nR2xsd2JqeXJZajN1L0kzUUhCOXZpY2djZ3I4aE5qeFErOGhLbmZFSloz?=
 =?utf-8?B?RGVMR0ZSSWdObnhRZTVpckdsVDRBQ2pjYmVsSUtzdWt1SXo2aXFkWjVUKzhF?=
 =?utf-8?B?bmFhWUhxaFJYVXBhNDVKNGRGTGswVEVHbFJNNjJVbmwvUnVPMitINUIvRjBL?=
 =?utf-8?B?WHkydlhlYjlMZXRyZ1hxejdiWk9Tb25TWUtCbFhId3g5eThHQit1MGNMMkxK?=
 =?utf-8?B?UkRrV1hDb1ZwZ3pWMncyQlRnMk82T1JDYWRJQWNuc1JUVnBLZ2lxSnpQTU5X?=
 =?utf-8?B?V3lBMTI5UWRWOFhwTGRxcC9XUW5oVmVRYmhrUURtamIrRTh5b1dyQlpuSFRv?=
 =?utf-8?B?azFxU1hXUkozRzRPZEZqak8rb09XZUlUK21HTzR2NHg2dDRidmtIdWI1M3RH?=
 =?utf-8?B?YWw5b3NSSldjQ01iM1Zma3I5SnQyVnFCNjAvRGdSSGFWcjRoSEhsbmZkV1d1?=
 =?utf-8?B?MWVkbVhNakV5NnRneEZlUXJoS3g5ajltQlVPMUlScUJLUHd3eWpBYUQrQmwr?=
 =?utf-8?B?TFAxUTdGOTY2V0dOU2plRi9Va0pjemlpVnY0eHhROWt4L2dHS1lhRmQyZ0xi?=
 =?utf-8?B?VWtUN2RNK2d0SFdWYmRENCtyOGdVRG9QSCtXdGprTlVjc3VTS2JUOXdKeEVx?=
 =?utf-8?B?S1VyZVp1S1NyYW4weDVXRmdUU0UwdTdwZ3l6YldEUi9nVkpIbnl5bTRuK2p6?=
 =?utf-8?B?K1QwQVJjQzNSd3ZyaFM4VlhKRGc2YTl4aWZTL3VBRmVUZ3lMYjRLOE50K2xR?=
 =?utf-8?B?T2hISXJ1VVRhK0tpTDdiVSs3VkF3QWRkS1BlRDdVbUVBNS9GZTN1V21xMFoy?=
 =?utf-8?B?cG1ncGhSQlFrTmhZaDNTeEllOXREcktCeTJhaTdBdjgyRkJrTXV6TTNxbEdk?=
 =?utf-8?B?c0V6SldBaURySU1EZ3UvN1FDZlQ5aEZnY2R6WEZmSjhmNzg0c1VJWlRrcEd4?=
 =?utf-8?B?bGtYMG1zWklWQnRsUng3cG4rRkxzOTdWNUo4aUQxS3diYWlWUGY4bjd6UVEz?=
 =?utf-8?B?U2NmMDdkTkVBRzlLbGE4QXY5THAxNHl5Zm1XSXU0cjJod0pPNzYyalkzTXJj?=
 =?utf-8?B?RkFzR1RVR2hFQ3dLeStUbkE0NWI1Y0plQi9KWVcxU2JiYS85Njk4SUNsKzRi?=
 =?utf-8?B?aU9FZFJLNG11WG9LcitQd3kvcjJWd3BYK2huOGMrWXhZdXJ1OGQ4TGdtRUxO?=
 =?utf-8?B?aEttckZWNkc2YUNwaXk3RVNxZ1BKYXd6MjdxYXJ3NFBZZ3hWVEhqcFNRTzZj?=
 =?utf-8?B?SUZDd1B5T1VIUXcwYnhoS0dBaVhTckdqZjA2Wm1LTFNYSGZocmxjRm92eDhD?=
 =?utf-8?B?K1V2TlRwMkRLcUFCcnZSQTB1WFN2dzVucXdrOUh5WFlEYmk2MVlQcWRKeWUz?=
 =?utf-8?B?V2Vhdmo2Zk5MbUZmRFVMNHptTGN6OVlSd3BWZTdyOW9ZeC8xM3RMTmlBWkNl?=
 =?utf-8?B?OS8vRFZJKzhKVDZvQ1RENmZzam1rS2o1d3p3S1NjaEcwY3lUVmNIS1lqLzJn?=
 =?utf-8?B?bThqVnZ2VFJJMzJVaU9pWXNKbEZNRGVaYklkVXJ2VzFrYWFTMXdZdXdFUW1G?=
 =?utf-8?B?UDV2U0hqbXdJZ21ZekVMRTkvSUYrRWZST3Q1bFMvNzM5K1JvREtWcEhEdHpy?=
 =?utf-8?B?STF4b2paeGRkMWhKTjFLZVAyTG92SmpORGRCbEpqNWhOSG9iMHdwQ2RnOHRL?=
 =?utf-8?B?R2tXN3BkWGExaWRoaHJrQ0hDYXYwaUxnL1pKdnhHZ1l3ZUdoc0pPcVVKdzd2?=
 =?utf-8?B?NjRtTzhYanpFMVlFek9kSG40MmtRRnBsbXhZSXExQXNrSDVSbFBWYkVZb0hr?=
 =?utf-8?B?bEJGNnpSK3hvaTQzbndIWUk2K0hiS3ArODdDRTU4cnFGMFdzdTF3eWFXWHZT?=
 =?utf-8?Q?L44KUnPXetvIGWG5KWxKReyCA?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 468d5246-0ac1-4656-26f4-08db5d34cdb5
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5984.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2023 15:29:17.6436
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m+3Xqac/r9yaZfoCkbTnWTXEwZ7BllG9s4wX0ShtXlSiEFzBl6/yQIiCd5QltdDB2BvoEEoqizKRDzmynrLZdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5013
X-OriginatorOrg: intel.com


On 5/22/23 20:57, Li Zhijian wrote:
> Any change and question relevant to should also CC to the CXL mailing
> list.
>
> Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

Thank you for sending this Zhijian!


> ---
>   CONTRIBUTING.md | 12 +++++++++---
>   1 file changed, 9 insertions(+), 3 deletions(-)
>
> diff --git a/CONTRIBUTING.md b/CONTRIBUTING.md
> index 4f4865db9da4..c5eb391122d5 100644
> --- a/CONTRIBUTING.md
> +++ b/CONTRIBUTING.md
> @@ -5,15 +5,21 @@ Thank you for taking the time to contribute to ndctl.
>   The following is a set of guidelines that we adhere to, and request that
>   contributors follow.
>   
> +1. **NOTE**: ndctl utils have extended to support CXL CLI, so any change
> +   and question relevant to CXL should also CC to the CXL mailing list
> +   **```linux-cxl@vger.kernel.org```**.
> +
>   1. The libnvdimm (kernel subsystem) and ndctl developers primarily use
>      the [nvdimm](https://subspace.kernel.org/lists.linux.dev.html)
>      mailing list for everything. It is recommended to send patches to
> -   **```nvdimm@lists.linux.dev```**
> -   An archive is available on [lore](https://lore.kernel.org/nvdimm/)
> +   **```nvdimm@lists.linux.dev```** and CC **```linux-cxl@vger.kernel.org```** if needed.
> +   The archives are available on [nvdimm](https://lore.kernel.org/nvdimm/) and
> +   [cxl](https://lore.kernel.org/linux-cxl/)
>   
>   1. Github [issues](https://github.com/pmem/ndctl/issues) are an acceptable
>      way to report a problem, but if you just have a question,
> -   [email](mailto:nvdimm@lists.linux.dev) the above list.
> +   [email](mailto:nvdimm@lists.linux.dev) the above list and CC `linux-cxl@linux-cxl@vger.kernel.org`
> +   if needed.
>   
>   1. We follow the Linux Kernel [Coding Style Guide][cs] as applicable.
>   

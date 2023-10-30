Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 632D71C68C
	for <nvdimm@lists.linux.dev>; Mon, 30 Oct 2023 21:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YS0Gmv3p"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698701418; x=1730237418;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=q4EUT9q87Cl4Q/VldC0zeMb02bwN0V1xpisgX1fwY54=;
  b=YS0Gmv3pRPzoWCqtRzgMlmwIH3Sp7loUqW68QQ2e7u9N1eun7hE0aole
   xOm3N7bev8LaEu4M3H7QQ99y9lXOq6HDLBjL6EFpG6x9c6rT6qo+yd2iG
   UfMNKJj79fv8geWnIDu0Dy7bVBiVuczS7sdb3mPVTL1pDpi6fjEgsk+BM
   x3xJpJfD54ZQF0Rt7w/Fbc8Xs0hSpkfH9kupOVx8wYXaBY2vF1CIV037O
   iO4Ude+5HxaW+klfcf/yY/bLD9wcNlLVVu2YQ9mrnNH/A3jN4JfaAwpAJ
   vOWvBKx0aKrNCpTPlL1C8ZtBa1I/DRfzvGRxNXE9ewVsta5XJWpa1sGK9
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10879"; a="391041774"
X-IronPort-AV: E=Sophos;i="6.03,264,1694761200"; 
   d="scan'208";a="391041774"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2023 14:30:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10879"; a="1091779807"
X-IronPort-AV: E=Sophos;i="6.03,264,1694761200"; 
   d="scan'208";a="1091779807"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 30 Oct 2023 14:30:14 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Mon, 30 Oct 2023 14:30:14 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Mon, 30 Oct 2023 14:30:14 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Mon, 30 Oct 2023 14:30:14 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.40) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Mon, 30 Oct 2023 14:30:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OxOUtkD0PZ97UMzShXQG5BOTJm54gMkHUTjMF/zM34gMhcXo7U6r+K50coevnZcFep565oUSxHPeWh/hj8KERmn2PK/v2yZzmCA4flIGVeZVtmwOd+nA6BUOJLpzQGU+1A8W/n+LmizwAw48hvKQ1ZdZilt2JG1+t+RlGqE7Ys1S5GoCtg1tIKplDGOiP2wLPVqNNsZhN9hXu7XhFiHdSzdxQ6leRmcIOl+J9soKteQ9eOWX+OcJL2sH/IZHWNtRupBZYhvQSGwG/vZcEGd2yztgp4IfaCtYB2eWKVpPUG4mcmozsu7e08MnMNlcGsgm1KRp5RkUb2zyVCfMo5Llxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pf17klINoWeAW0LIH2u3S0rtvAhLYpLtnHR5Tcd28EQ=;
 b=hDdSj402eSE5zx/J9BrukxAEjDaOzX3BvvC0Od0Jmbl3D128cqWJQM6bXDkm6RsayRgq/3AvBR0Z9erRX92Xrh8IY4pFBGjPGJ7O0lQrShc30ElOYZNa+J/79OyTst1jvXIRzCVzi67a2+m9CsBQhiwfM61HwNKk0fSLw9rfMj/aj/fRGgks3ssbQR0msR05PFAJNwJa/DKZkzZDo2RwLqqpApYIfweHplZ2Cd4sUXv4RY9f7Pu67Pdo8wtESfcp6ByEcmWKjoNpWp9l4dL66bBnumxGOnwlHFJxMK+QCrTfe8Bdn0tEyHdGK+GalAZN5u9DzuP1/9BkT8uKC4JHbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH7PR11MB5984.namprd11.prod.outlook.com (2603:10b6:510:1e3::15)
 by MW3PR11MB4635.namprd11.prod.outlook.com (2603:10b6:303:2c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.28; Mon, 30 Oct
 2023 21:30:11 +0000
Received: from PH7PR11MB5984.namprd11.prod.outlook.com
 ([fe80::a353:a16f:7f8a:86aa]) by PH7PR11MB5984.namprd11.prod.outlook.com
 ([fe80::a353:a16f:7f8a:86aa%6]) with mapi id 15.20.6933.024; Mon, 30 Oct 2023
 21:30:11 +0000
Message-ID: <d455eea4-6460-45e8-bcf9-7fab970da163@intel.com>
Date: Mon, 30 Oct 2023 14:30:07 -0700
User-Agent: Betterbird (Linux)
Subject: Re: [NDCTL PATCH v2] cxl/region: Add -f option for disable-region
To: Dan Williams <dan.j.williams@intel.com>, Xiao Yang <yangx.jy@fujitsu.com>,
	<vishal.l.verma@intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	"lizhijian@fujitsu.com" <lizhijian@fujitsu.com>, <caoqq@fujitsu.com>
References: <169525064907.3085225.2583864429793298106.stgit@djiang5-mobl3>
 <59e51baa-cd6f-7045-178f-c327a693f803@fujitsu.com>
 <7a01a5aa-678d-42ff-a877-8aaa8feb3fbd@intel.com>
 <c460ae5c-1685-9e41-5531-8b8016645f70@fujitsu.com>
 <cae3112a-3cd4-4aa8-8b8a-7ca60fa1fa3e@intel.com>
 <653ff6862f08a_244c782945@dwillia2-xfh.jf.intel.com.notmuch>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <653ff6862f08a_244c782945@dwillia2-xfh.jf.intel.com.notmuch>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0186.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::11) To PH7PR11MB5984.namprd11.prod.outlook.com
 (2603:10b6:510:1e3::15)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB5984:EE_|MW3PR11MB4635:EE_
X-MS-Office365-Filtering-Correlation-Id: b0fe155f-ce16-4ce4-d387-08dbd98f6569
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: osnihUjyh8Ib+3qRRyAubavHny8GPKhhqRKkZD4Iln2FMD5G8rJKD1uCgEx7wel9PiTkWjFZ6Y902POa6AuDTtPLqx7n8qMckzRsUfizMn3CFPI7UDx7Mo8HG2RBSRZalH+ieR9YIPRlAGvagBM0UbQGlE3ogUJGiLBbgWPbYQL+R/mIMl+25tKeRMQ9R9HcoM3E9wEdFlr2kPHCaSa8Dh+gAioRuVJw2tmVZlHeGP7/0bRjLaPECUkwD0K4WGI2mHnWxFDa01hTar9JD7I0Ui5pFd1/gQZbkJjrLFO2043Y8P+Bahy99NmtuKhLCWgjA/ZG+B/EJffhyf+q3dCY9JOAYR+EWtejdg3mxZ+DzG3VDyB0XyIoCrCbl6pDsI+mVvVjmXhaNwpqUp5eGU2O7SX0ogTj0Xw3Hd0xj+ac+frNuzK8ndWT7S+VuQ2ZAn4ZOLdg8GZyQzv4CSuTgStGZ0iXXik7pbLbEql3eB0wlRg8ZUAQrQ8cZt8BPNDASdBAh9cdELYLV7zS/vmzaRuWQbQJcrjbmtOnzBXbiw/2bATRDaLN10wyL4NwQkUeM0a5yaob1MK775rZ/JjeemJlQjlQVOW+lRLP5aA35rGfaRISCOFRcWmwXCdIlo3OjA2uvhFg5zkvl6u3NA1pN0xIWJDXLtQLpk3O6oFgxx5D8fI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5984.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(396003)(136003)(39860400002)(376002)(346002)(230922051799003)(230173577357003)(230273577357003)(451199024)(186009)(64100799003)(1800799009)(31686004)(478600001)(6666004)(66946007)(6506007)(110136005)(6486002)(82960400001)(83380400001)(36756003)(38100700002)(66556008)(66476007)(2906002)(41300700001)(2616005)(6512007)(26005)(53546011)(4326008)(44832011)(86362001)(31696002)(4744005)(6636002)(8676002)(5660300002)(8936002)(316002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZVp4cXhCSXNVL2dJSWZ2Z1NOY0dIT1ZMdXc1R3BUVElJRG1LN1psZDFCQXNr?=
 =?utf-8?B?dXJOMkxuVG1MNnBldTVETS9PQW90VHdSTC9pMVY2aDlidlBScUV2U29tVXNG?=
 =?utf-8?B?cDlwem5zL1ZlVGZXWGt5dlVFdGppeXBadDNXenB1dFgxMUIxUk5oWi9FVlI3?=
 =?utf-8?B?QzZ3SDJFRE5sM1FXcVpLWmxMSm11NDI1MVd3OWZBVmpleEMzeUZSazhLQ2xj?=
 =?utf-8?B?UW5uMnNYTHlPY2x3Y2JZU2pGenJqNWN4MGV5SGd3aCs3bmVBYmowUDBaQXR0?=
 =?utf-8?B?WkRNaFFMMVZJcW5tTlRORkVoUGYzZmcwanhJdnF4djBGMnJ2M1FKS0l4YURY?=
 =?utf-8?B?YzZVTHhkYXY4VWM2aHJPRVJpVTRTS3dGRjFWb3FncktvRlEycVBtRTZQSkpT?=
 =?utf-8?B?dklsOTFMOTY1Zm9vTjlDdXlZVTUvWWowNU9taVNsTHVELy94dHVGbHJ0YjhW?=
 =?utf-8?B?NDQzakRSYklZUU9vS09MazY1WXpQRnJPMFZrYVVpcStJdnpZV3hyM0lQa1Fi?=
 =?utf-8?B?c2tLei9qRVJWZXFvdTd1WGxvNjJzNjFHQi9kZXZ5Vk9mcnRRK2pVOGdzQlRK?=
 =?utf-8?B?NHZZa2xmbVVOZktOeTZLd0RYVXB2ZFFWNHkwQTN5TEZncENEdmFhR2J2KzN2?=
 =?utf-8?B?c2JHT1dBTTE5UlRDZnlNK2Z2ZWxBV0N5SENMdUtSU3RPdVB6SWZrSXpKQ2xh?=
 =?utf-8?B?ajRXQkY0bHRKT3JPTjh3VExRbTlWYmdDQ3l2Wk0xMHMwdjBZYlBDZElQdUM2?=
 =?utf-8?B?dmJsNkVoUjcvSExremtBVVRCWSs3SmlNbndONE82Tk5YUGgvWjdsMGhBRDdh?=
 =?utf-8?B?YUJodUxaemZWNjZBdVV5a1RBSEV1R3E1Z003MHZ5aG9JZlN6ZEdyMWNEV2ZG?=
 =?utf-8?B?a1pHRzNNeGRTa3dwa0xoMEw0dlh6a3VLdjhqU1h1akluWFRDQlQwT0plWWpT?=
 =?utf-8?B?U2QzNGY1dVk3aTIxRE00eUpES3VubVhBTmZPUHA0bUJLaWVQZms5VWFpMEE0?=
 =?utf-8?B?NFdZdjQ2V0lzZWkwWHpEUnZ2enN5VTltTHFCNGtBd1lxMTFVSUR5UEgwcGJa?=
 =?utf-8?B?VFRaQ29TaGhxOCtVeklpSE85MUlORUw3TU4yWEVPN0M1Rm93SFNRTEpJeUU3?=
 =?utf-8?B?UDJ5OEJmcDRDT2JRSThBVEZsMm5yYTJwTmhROEZMVE9iazVjSEd4dWV2aGU4?=
 =?utf-8?B?VUhDTzJFanY1SldMdStDaWlkb3dOb2p3clFaL281VGpReFl5OUZPZ3pmZmlH?=
 =?utf-8?B?UVBuVjhKY0NIQVVzdndvd3dZbS9kMllkcUwrSVA0bVlJbzU3VXBEcEZkK0l2?=
 =?utf-8?B?NksxQlZDTnNuVmtPenNQNTZkWC9rbU5QM0JJWnJQdDF6TmJtRU9pbk5GOFhm?=
 =?utf-8?B?U3hxMThMTmozZ29wMXQ5YUVKLzJvV3RPak9hT3p0WEgvUUJ5Q2hFNmRwdXhi?=
 =?utf-8?B?ZlZ0RTdDUEZZTzg2SVFyeHZ2TElpTmdqVHYyREJzNk5MRW9yckc4Qjk0Yytq?=
 =?utf-8?B?VFhROTBCK2R3OW5yY1JDVXp1SHN4UituOEcxWUhWemJkQzNmUEV3T3ZTRFY0?=
 =?utf-8?B?QlB0RCtZbXBEK2ZVdmF4UlIvRkxIRE5qK2FWbGE2UDFUSnBmcEF5OEsrMVow?=
 =?utf-8?B?RzNlc3VEUjRoTTYwb01GUnpydUdYdGJqRDZmMWNteDZWR241bWYzR3JtclRE?=
 =?utf-8?B?SGFUZytlRlBCNTcrR3lMRGtHYkJ0djJSQ085QTIrRlNYanRESGhuYzlXek9L?=
 =?utf-8?B?Y09RdHgzalI4MXhBTkc0SjRFeDczaldndTdYNlZqR0V0RWRTOTNIcEV6ZC8z?=
 =?utf-8?B?ZUZGYng0Q2V1QWREdGpBNkt6S1hkZnA0T2x6K2NsMjBQaERCaG52ekFCbnEx?=
 =?utf-8?B?cU1WdlNvS1BkM2pyVnFlckVZeU9kWm9vTGlMSVZJbXQ3RlZNS2lhUEorQ002?=
 =?utf-8?B?MkJrYTErZHh5WkVFOWhMRExGeVNiQi91ZlcyUkVjTG5KYTFYQzlQQklkVUZr?=
 =?utf-8?B?akhVeTVNa2tEb1hyYkRaV3BaSWR5NENJZU1xd0ozcHllN290YnFtMEdyY2p6?=
 =?utf-8?B?YXJQVmFIZ3hlWDY2dGs5K1VDbTMzbVVwSDVsSk5yRlNjalBteEtCTjBwd00v?=
 =?utf-8?Q?1GwYVvUHgLYo1kL7Hp1n0vlaQ?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b0fe155f-ce16-4ce4-d387-08dbd98f6569
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5984.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2023 21:30:11.1503
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JbFnRwqzYG5TwEZcDIKHrltUX7RC9b94X+Ef8VUNQSc+uYCLQaXPgaEVqpr3pWc9zLiYvQ/nov3J3AEaFMIoXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4635
X-OriginatorOrg: intel.com



On 10/30/23 11:31, Dan Williams wrote:
> Dave Jiang wrote:
> [..]
>> Ah that was a mistake. I meant to call the query function and not the
>> online op function. Do you have any objections to
>>
>> if (!daxctl_memory_is_movable(mem))
> 
> Wait, why check for movable? ZONE_NORMAL can be removed if you are
> lucky, and ZONE_MOVABLE may still not be able to be removed if you are
> unlucky. So I would expect that disable-region attempts to offline
> all-memory blocks, and if that fails then fail the disable-region. That
> would of course need to come with documentation that disable-region may
> leave the memory in a partially offline state. Then the force can just
> rip the device away with the warning message that physical address space
> has now been permanently leaked and can not be recovered until a reboot.


I'll update as you outlined above. 

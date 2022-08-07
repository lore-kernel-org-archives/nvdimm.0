Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D42CE7A
	for <nvdimm@lists.linux.dev>; Sun,  7 Aug 2022 00:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659831649; x=1691367649;
  h=date:from:to:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=xfxBI9b2xdA4njR/RaX5fHks0pbKPV7jKvAafKVGZ9k=;
  b=KPr1SVvE1Ry08WIkxPp4hi0vTUqcQshrUK6opoAlgb3ZiGGynR/1Pd7W
   ELuuHmGCdTjl84da79EPALMMSMy5dLAAi4ek9duWjAAu0+Tm41RDqrry1
   wRptUfVR/jwKJUNjfL83jx9NDLcOz2x81BOhUGDE7pC76pggiZDbCItXQ
   Tld+vHvYzO/Wl8Pyz00bx472EuoD3I+saKXqK4ak/Cmt3u++MObeF4ohK
   ZCYGb+qKZhgXg6abeKCWI8cDlTxRUEOPf/RNxhDephgpYRJcY2jvMAeb/
   Mz98Fq/UgVIp3HON8OyGwslWT7yME/J9oW24shkTZhLgMHTCEkUwu6P4K
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10431"; a="376693537"
X-IronPort-AV: E=Sophos;i="5.93,219,1654585200"; 
   d="scan'208";a="376693537"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2022 17:20:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,219,1654585200"; 
   d="scan'208";a="931626607"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by fmsmga005.fm.intel.com with ESMTP; 06 Aug 2022 17:20:45 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Sat, 6 Aug 2022 17:20:44 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Sat, 6 Aug 2022 17:20:44 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.170)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Sat, 6 Aug 2022 17:20:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eRV9IGdv9knkz5xiLqPIiB1BZAozVDeMeZdgRM4vIN5MMvhs6BQjQVWH3s8p6IDZEJgF0wlg2bVaoz4JcGQdDMyIURXhkfOKsPgiUDeTHpDljUn82TGaLUG3HZMskMOQy+JBu1tETsrZZ7sUH/c0n9IfS1OFKdxafYA4iMbqL8VoxcgmHbEOIXgWI/UVoGvu8PfE4mjPKmo1daDfeGH0XurmAB0NPMo0xQIyTSDDQVSpRX2+0eZs046EmDDl4I7vZGXLohInutCcZbwA4KN0WmiH8IaZAi0+fenvYjEfloY/WPBh6ju9hnuurHX24sWxhKbWrHTqPEKd3CczRVQSsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s9NtkF9i2CRNvWYn/1MO0xuUC0yi8qxuHLVlUvWbvpA=;
 b=WV0pLUWFs37HKexRsT07AOvOif4lVr6u1TUhFlHob+4fO7MNsPd18Fkdm8SoQVJ0l78GsrnHGspfFI97y57M/O1jqBgQtmxqS7jLvyy96wr9gEqvCnllZNNOzCxnCaViaEr2PfN27cQlKdYY7l9DLjgX3LLQCgIQH6Qbv+Lq1FJWMwiboifCdmuHbj4edOn4tV17eY3meMhHQGZc09PbmEd7Ymf53MKn9ZAWbGxkPGprtzXeQxTHGH/xCEDtqIugv4PFuzFLruhREUrv5u4axsc6JZCxhMHMrR0HYDzYEKxO8sz7R36DoaiYpQRyB8EU1HvK0aBb0hoDaKjsHvAccA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by BN7PR11MB2610.namprd11.prod.outlook.com
 (2603:10b6:406:ab::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.17; Sun, 7 Aug
 2022 00:20:42 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::9847:345e:4c5b:ca12]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::9847:345e:4c5b:ca12%6]) with mapi id 15.20.5504.018; Sun, 7 Aug 2022
 00:20:36 +0000
Date: Sat, 6 Aug 2022 17:20:33 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Chloe Alverti <xloi.alverti@gmail.com>, <nvdimm@lists.linux.dev>,
	<linux-cxl@vger.kernel.org>
Subject: RE: The future of DAX in linux kernel
Message-ID: <62ef05515b085_1b3c29434@dwillia2-xfh.jf.intel.com.notmuch>
References: <CANpuKBMD4tWk-s3DRSvzquTVfoDMp+5X_fp90N1HDHkb4u-v7Q@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANpuKBMD4tWk-s3DRSvzquTVfoDMp+5X_fp90N1HDHkb4u-v7Q@mail.gmail.com>
X-ClientProxiedBy: BYAPR04CA0029.namprd04.prod.outlook.com
 (2603:10b6:a03:40::42) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e686ed0f-56e4-4283-6420-08da780aa62a
X-MS-TrafficTypeDiagnostic: BN7PR11MB2610:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8Pm4UlHBZNJ87TtHj6aYFGobMiB5kVwABX0k2wi/5dTPzxyFAMpwQ4zE9pJ2l8QRofd2+7dXVii+nG3qGaJMtFSMX/2sFvbolrAprDS4cq+6+6e6lvcli6pr/K5cS8d3HgOcYQBLQxuuKZ/AUPnvqDpgwa7016U/5zwcVyuRzBnCkFcr48J+T77MNR+n6Izv7QdqUAGFOeT1wdx/XyTds8pjAn+vC9/8eSZcaSdi2ghguGYr0eFMumpOkCxKICiiII+4dkQELdA9MWpgBfDu7aKfXF21ueQJ2KugF6MfssyiXBmp8MJGxdAQkNj8lipTy4pj3jAqjw90pIWptW5yZg7eqLxhSMeGWR6K32LrxtGfSt69ZkMoVb3OiPzyMMC2v+QMeHMqLOFn0zlbuE3CDzOVsrq6cSDI8E9MMJCDxwhYLpB0ryi0/h6+UGvM7XXxK9mXFHykvfeLS1OQsWC7WiwJfjFHYTVa417IdTi2CiMGCoO6Spb1aMQ0c9HmIcVuAfkhez3da4P8hlNsAuXu8vJ1qGqSKNz/BbcFDD09jy9XGv3gfU9L3W06LIsnVRqxfMR6fL9rtK08vOQVlAw2wLPBcP8bPnT0oexwlK5KDTyhUqgMzUJi1WyuTErPF+ALXlMRAfNm8xLzP2MbBgCOYmkYdBWP2yFOIa9KbAODrThFZSBQnu6PLADBKx9nXVNZLjtFtpJQFPtyvrIn8Mpinvu2LOyVg4/JXS4BxOsaQ12rowzxK5jg66d6Ic+DVZbO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(346002)(136003)(396003)(39860400002)(366004)(6506007)(26005)(478600001)(6512007)(6666004)(9686003)(41300700001)(5660300002)(83380400001)(8936002)(186003)(82960400001)(86362001)(2906002)(66476007)(66946007)(316002)(8676002)(66556008)(6486002)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YW9Kd1ROZlRqSnROZGZreGF4MTVZS1hUa2VUcjlXeUlxSVVSV2FmZUlPTWRk?=
 =?utf-8?B?RURtRGw0UXRwSXpwUWdrNUlYdnViN1JUcGFtclVJYjIzSitxSzU3VTJURCtO?=
 =?utf-8?B?REt0Tk9Mdmw2RjZ0bTJFaXZtRVR0RGcwZUt4TThib0pNUDlab3pZRkttK3Zy?=
 =?utf-8?B?SjJVWFE1TytUUnh3Ny82SHZzbFNTMnJtQVlyTTBNUldmNEllRWlSSjRJUzgz?=
 =?utf-8?B?MmVWeklBR2dnczNQd29jelVjR2RiVUplckNSbC9PTGxtR0gwcGVKU080RVhv?=
 =?utf-8?B?RXFXQUpKcmVKYXFtV2pIMmpEVncxb2dHcHFBcnZZVzB6UHJzS2cvVXdneXdV?=
 =?utf-8?B?UExyMDlzb1pLRjJ2S1BuenB0bkVQdkV3eTYxZ3k5eWRyYWlVK2o4T1FLeXVG?=
 =?utf-8?B?aHd3Y2k4UWtSLzF2bHJDbWpINXU0bFdtVE9uVTZiTUJvWUtsdWE4ZmtGeUxq?=
 =?utf-8?B?eDlMVnZyc3dkOGJWUUhTSnBUYUtLV1VCaVhQNjFRQkNIWTJZMXlNMjBDMHBP?=
 =?utf-8?B?aG5CTlhiamdWYUJ6LzZOL25IdVBHOGlPcllpdGtqdjMyS0dMaTROaEhTMkli?=
 =?utf-8?B?c3dTTzdQU1Q5OGdrUlhKVFdSZVZIVWFHSEpSeXlkS2xyVytFYU5DRTdxV1pI?=
 =?utf-8?B?b0lmQXAxUGYrVDAzTzVWYXdRUXlZL1lUOWFLRm5zelZvcDd2T3BMQklablNy?=
 =?utf-8?B?cElUZWdvN2h5eldleHRYQlNqbmZJcHpHcmxEekNPQmRIRCsxL0JxbmptZi9M?=
 =?utf-8?B?STcxcWhYempjeHlhU0VQa05PL1YzVmVrU3R0MzAxYkM1OVNOTVZxL3lJTUJh?=
 =?utf-8?B?ZjBycWdlM3dQNUxncnZwRDBKUXBZRlgwNjEvY3p4di9iVTlWRitFeFJ1b0VI?=
 =?utf-8?B?V0wrTGo4Z05uaTBPZXBGTWdveWNOdzBSY2F2RGtwNENFMytCMFo2Wk85Qnkr?=
 =?utf-8?B?UVhTN1BMK1JLYWNoWm8zbmx2VnhjeU13TzNGeHBkQVZlTUtDajBrdVlZMWxG?=
 =?utf-8?B?UHpmbWhXVXJod1lTNm52a21XN1NmMjhaSjduNk1NdUNyMlEwVmNleDV5QzZj?=
 =?utf-8?B?NWM1Yk9HT0VwbXNMRFlpOEZydUxYenV6cjFTc1liMkQ3YUM2ZjFFZmtmUTR2?=
 =?utf-8?B?UHAxNEVIcytQWjZsM2xrbnVZZlRNck5TU0lsMTRlbXI1YkJ4UDVUY0luMU1z?=
 =?utf-8?B?TldyVFJFdFFueTZ2MTBHeTRwck81eE4zN3RCdkJCQXEwRDYyMHBwdm9ZQm1o?=
 =?utf-8?B?cWpCa0lPVVZMMXRmaGd6emlCVHQrcFRPTnUweDJGblQvL2lhM0RBQU02bWlt?=
 =?utf-8?B?ZFk5WnU5WUVURHMvQWJJN2NBUjFpNFhmT2tPV3IwUnZXOGQzalA3YzZQR21K?=
 =?utf-8?B?RXRoYWU0cEtaRWxlOER6M0pSOEpzdW1VdHJ4Tk9TTktXeE5Fa3BKRU9leTdh?=
 =?utf-8?B?cmNlNjFoMkZkWlN3NzJRblNsTzRsSXMzelpzRmxlMndNQ1JReEFHUjlKNzZK?=
 =?utf-8?B?UjhMQllNVUh2Z2tOU1Y4VXVOaHg0VDY4NUhSUGtGbTBBdG9EaXpXSFdxSmFI?=
 =?utf-8?B?VmhhR0FHbGRDVjRha0U2OG9FMDdrdUl4V3V0VUVtOE5XV1ljdUlPc09oK3hh?=
 =?utf-8?B?MGRib3FvUTRpUXNncW9zSmN1UFBFNlNXcEVjbFVvbi8zUzR3K2dDSWJselVK?=
 =?utf-8?B?dzM5UkIyNitTUlcwVTZCdis5NFFhYytFS2NvbXdWUWlJR09pZVFWdHJYc0sx?=
 =?utf-8?B?Y1NqbThWR1FhTUtqVEJSbmF1UHFseHVFYm5rdjE3UDNxdmIvTEhEbm9jTzlU?=
 =?utf-8?B?U25mYStjaExoWk1KNU95bDdyQkVybVY5WFFFbHdDbE5zQWV5MC9EaVplQnJv?=
 =?utf-8?B?VXEzWU5GaUFiRndEaFd6cGpGb0FVZ1VZd3Z2RlpzM3NZMUNlRzk4Wm91cmJq?=
 =?utf-8?B?RC9aWWNvWHc3L0Y1TEJDYjZpZ0pkR2pGeWc4VmdzUVhlVFVrb3JmelFuaTJW?=
 =?utf-8?B?NUJyaE1zRDcwZU03bWR1Y1V0dzF3dXY4K0pCcm1lVWt6WUF6amhwck4wZ3lK?=
 =?utf-8?B?aWx2VlBQNlhoa1hSc3pqTGJFeXR6VFV3S3BTVDA3cHFnMGVKSnNXQVJHUnJh?=
 =?utf-8?B?NE5IclhWY1o5SGtUWmlRYmRaRjl6aUpsbURNQXVSWlJheGhGRUFOVkNvYUE1?=
 =?utf-8?B?OEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e686ed0f-56e4-4283-6420-08da780aa62a
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2022 00:20:36.1335
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bdVwOvYd3M4RQyOSZtueeYhmtVFYO8+b6Nt8gHuJJuK3OlLxr5ouh43b5BNsfl9Z3+LwrJmUKbwlYLwox0fJXUcytvKS47Z73aO5TVhG62E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR11MB2610
X-OriginatorOrg: intel.com

Chloe Alverti wrote:
> Hi!

Hi Chloe,

> 
> My name is Alverti Chloe and I am a PhD student! I have been
> working/studying the past year on system support for persistent
> memory.
> I wanted to kindly ask you your view about DAX kernel support; will it
> continue to evolve/be supported in the mainline since Optane memory
> has announced to be over?

Short answer, yes, DAX keeps going.

Longer answer, just from my perspsective as a Linux kernel developer,
not the views of my employer, is that DAX concepts have existed in the
kernel since before Intel® Optane™ and will continue to exist after it
is gone.

Recall that the immediate predecessor to DAX was a facilty called XIP
(eXecute In Place), which allowed systems to run binaries direct from
byte addressable media without first needing to transfer them to main
memory.

After DAX arrived, it grew usages outside of persistent memory.  Virtual
machine hosting environments use it to avoid duplicating page cache
inside guests. In those setups a guest accesses a virtual pmem device
that the VMM maps to bare metal page cache.

Lastly, even without those non-PMEM use cases, it is still the case that
all you need is DRAM plus an energy source and flash, and voila you have
persistent memory. In general, the term "Storage Class Memory"
encompasses a wide range of potential media types.

> Is DAX going to be used as an interface for CXL compatible storage devices?

At its simplest CXL is just another mechanism for enumerating platform
physical address ranges. A facility called 'device-dax' was created to
offer dedicated access to "special purpose" / "soft reserved" memory.
That facility originated with PMEM, but found usages for other cases
where a particular memory was either too slow to be used for general
purpose memory allocations (some PMEM technologies), or too precious to
be consumed by general purpose allocations (see high-bandwidth-memory).
For everything in between there is the ongoing memory-tiering work.
However, from my perspective, DAX will continue to play a role in
managing dedicated memory access sans page-cache whether it is PMEM or
not.

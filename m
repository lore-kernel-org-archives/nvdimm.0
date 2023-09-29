Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85C5566DE4
	for <nvdimm@lists.linux.dev>; Fri, 29 Sep 2023 20:16:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696018576; x=1727554576;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=iWgZnWohW/iO8E3ZY4kZSIoDBfXjTSldDzudb0WXYy4=;
  b=GXBtBDS4y99c5kT8pQXAbgrdErt1RfSrgVbB3UHO4t6B2zaWOqtIRb4t
   /oMK5UKnmI9rZpgxKUQUilMsVD3oDW1W1vBWFWA3xQzKMDnYfOiHYvtiH
   c4sMWybebn0cKkXfSh/Umh0JJt/GAIQyvk5Vuy1KjyH9O6Yw/cRHq5L+r
   SsA91/T/G/yVGZPhVQxFnJFieQ1sYKCTVb3mU7uDvWKC33FmXGxncHWy0
   jWXTTK4TAGi/ME7jsVad57D72qMTRFykuTrTm3EEyH8PJjDRxj+0gideH
   MvLWqcu1IMVA67thoQFsBtven3oalX/6qji4mff3Pc7rufPSEKd8mP2+X
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10848"; a="446513126"
X-IronPort-AV: E=Sophos;i="6.03,188,1694761200"; 
   d="scan'208";a="446513126"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2023 11:34:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10848"; a="865780595"
X-IronPort-AV: E=Sophos;i="6.03,188,1694761200"; 
   d="scan'208";a="865780595"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 29 Sep 2023 11:34:20 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Fri, 29 Sep 2023 11:34:20 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Fri, 29 Sep 2023 11:34:20 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Fri, 29 Sep 2023 11:34:20 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Fri, 29 Sep 2023 11:34:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OlnFzhEeRzPW1ZvzsjqlxbtmbGLFEkrTgbp/iZfp9JGL1AMSrd9gkW2Ew99yIKQUo59IcuipRLSXvEHXGYWfII++jYuSZvMXkoJBI1Q4g750iBIJy5tDDGlQxyrQWTfqreGdft4ql7DE0mFi+ERBuyz3RGQAmgvjelXTWggic3oVzT9Kpfw5GFY+nNikEXSQFNqq5Q8+s4TjlXAUcll7/flJ/19qkL9QstklAMFXZJBQ3jg5P7DTm2AYfWkJHqDGBtlaJrA0xPpdEAEnD7i2iB+pVJs3dKrWSKjJoZ1IasNrGyT0w4RZ57dnY+XLQLG/TuGPGnkwtoqffiBlTZDE9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BoR+pHIfv2axIrqoc1JT9E9ONi4C1zC30GLzvoE5mvc=;
 b=KAKI8LFKKBb/1+/OKdIfWz6u6ww45kuz/dzIuAei59L9qQSLnliZDC73Fmon7dPVQTvNGywO9QUS4oV6oEwJUibBz3H+i9YSQvZ62UKj6UzRN+p1ks6cZfeSMrGqcV2mD73sZIVqLfK1hkZD4ayaSoyghfTMeJttgVxeZknnksxaFmhL5upumFwXl3+SAdqbsX71sEkGHHZalQAkzpCmQBAXq/NrV0LFh+vs9NJBY6bIwysX4aPjjjvlxEHdJLSGNbQQG2VBGP8HKr5BvePGlHgqAiwFwM24cWbqydxRCA28+A2r2itW6XVREJfdDpTgQ9N3Lf93SO4eONzVeELJcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by CY5PR11MB6089.namprd11.prod.outlook.com (2603:10b6:930:2f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.20; Fri, 29 Sep
 2023 18:34:17 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::acb0:6bd3:58a:c992]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::acb0:6bd3:58a:c992%5]) with mapi id 15.20.6838.024; Fri, 29 Sep 2023
 18:34:17 +0000
Date: Fri, 29 Sep 2023 11:34:14 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>, "Darrick J. Wong"
	<djwong@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
CC: Chandan Babu R <chandanbabu@kernel.org>, Dave Chinner
	<david@fromorbit.com>, <linux-xfs@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<dan.j.williams@intel.com>
Subject: Re: [PATCH] xfs: drop experimental warning for FSDAX
Message-ID: <651718a6a6e2c_c558e2943e@dwillia2-xfh.jf.intel.com.notmuch>
References: <20230927014632.GE11456@frogsfrogsfrogs>
 <87fs306zs1.fsf@debian-BULLSEYE-live-builder-AMD64>
 <5c064cbd-13a3-4d55-9881-0a079476d865@fujitsu.com>
 <bc29af15-ae63-407d-8ca0-186c976acce7@fujitsu.com>
 <87y1gs83yq.fsf@debian-BULLSEYE-live-builder-AMD64>
 <20230927083034.90bd6336229dd00af601e0ef@linux-foundation.org>
 <9c3cbc0c-7135-4006-ad4a-2abce0a556b0@fujitsu.com>
 <20230928092052.9775e59262c102dc382513ef@linux-foundation.org>
 <20230928171339.GJ11439@frogsfrogsfrogs>
 <99279735-2d17-405f-bade-9501a296d817@fujitsu.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <99279735-2d17-405f-bade-9501a296d817@fujitsu.com>
X-ClientProxiedBy: MW4P221CA0014.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:303:8b::19) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|CY5PR11MB6089:EE_
X-MS-Office365-Filtering-Correlation-Id: 086ebb25-de0b-4e2f-f179-08dbc11ab00f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7U9q74oY/MH4lqy3EtPUymglaCu6NBFGzh/Ycjy2zKVd5cj00ZgQx8kvoQUePLTNOBaUDoxQA9uEvEQoe49mRp9UP3NyuCQYw+bk4hy954FazPnVhKdgsbHAAcDf7jMoJRof6AJXB/EWmnJrFgkzQHv2/Evfr7ViL5x65eFWQqeLnVbx2bTTxqxNyHGGNMgQ9DkV6nS/x2EM1sosKBxGIYREF8ALqOUcA9ByFpEowBgut18GPgVnFvx6arEZmu0aGmTMjaEGJHCZZr4+5P9CFPp4sMFTHKKXVWTXVl9RnWDCVjC7Z1DQ/YUp+RNOQqJKFp38q0u8/Qlqyvrso685wvXOFva1oxmbEfH9wfodDm2WB8tL11t0gltO5XY92iUl0UDbkT9nQe2ibhpYksMmOiRqAfDxi5Nlw/ddyNDfC4WDmoBtIhtlIn0WYBkPXCNtU9V95xbH2isImIgqNCwufi0gKTi1/GKltmEt6hVBjBcoIsdTAm3g4ZDiLyL3wzduAPNs/Q372760XyfNTx3V3YpQFF+zJkbfCFWiYLmm+40=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(366004)(346002)(396003)(136003)(39860400002)(230922051799003)(1800799009)(186009)(451199024)(64100799003)(4326008)(9686003)(6666004)(6512007)(478600001)(86362001)(66946007)(26005)(82960400001)(83380400001)(66476007)(38100700002)(316002)(8676002)(6506007)(110136005)(966005)(66556008)(2906002)(6486002)(8936002)(41300700001)(5660300002)(54906003)(107886003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z2RrUGtXSElpWWs4MlYya0loNVM3S01mWkFxOGd5NzZpYk50cStxT0M4ejll?=
 =?utf-8?B?TS9TMjBQT3JLTG9JUHJ0V0x6ZmUvd0s2TUwxYVV5SytHd2ZCaFpVODNWQzFh?=
 =?utf-8?B?aXRYa0JyNmFyZ3R0ZnNsQjZhUjQ0OFNTWStlL3pCYlQxTjBrOUN3N2d5RlpR?=
 =?utf-8?B?b015RWt5Si9sRU9NbS9pSWx2V2tJRW9nSXFOMjZhdFIxK3VMMTNNNGRiZExQ?=
 =?utf-8?B?aTBOcjBBaTAreHpmclQ4b0F1WDlGaVdMcnJvQWVyNEFzOG9UUzlQWll4NFo3?=
 =?utf-8?B?QlZUSkd6TlZ2dzJHYjBHQnlxOVp6aG1INXAxQVdtVFYwTTdzVDZnbVR1RUFi?=
 =?utf-8?B?d0c0ek5iZUFJbG5VajVwZUM1ZE41V29qeTNiTEE4OTAzQVlpQk5Ibjl6Y2dT?=
 =?utf-8?B?VEhCNVB5WnRtK0t3dFhtQlBhb1hKRXVHZGY0eWVRWFJJYndSYTg1RFltcHlR?=
 =?utf-8?B?V296NDBaWWRHckpwWjFjYUQwa05mMVpEWFA1Y2U5b2VxWjFkNiswYmVlWU5C?=
 =?utf-8?B?SFJPQldzRFRDVEQ0U1NiUzlUL2dZMlhJd1JBY2RFYTg1Y3BRSVkwOWRucnJr?=
 =?utf-8?B?c1BUMnJoSmVOay9LL215M2Q5WXVYVUlwZTQvOVd2WmpiZDNRQ0p0TVhRSjU2?=
 =?utf-8?B?Zyt5NnZDYlpQeVFXOVIzWlUxUkdCYlo4ejRFK1QyR05qYlZlYkhVSkdGd0xQ?=
 =?utf-8?B?czBzWVRjUEtxd0JDUUo2dThFbTl0SlhBRnB0UXpBWHhpVmpBWGVvZGh5NlIw?=
 =?utf-8?B?cVhOVHozbTBZN1FFREFHS1RVSTUzR0UwMXV0TFEyWDRKY2p0T3JIem1nV1Ny?=
 =?utf-8?B?bEk4eXdDRDh2b3NaTEV4V1ZXOVR3SHdKRkhZTUtaamJkUjBNZHBBZXBFWUxN?=
 =?utf-8?B?eUc1UHRNTVBYU1hZNTR6NTVCK3kySEI0QlY0NTBKa0hmZC9LTnErNHJYemNS?=
 =?utf-8?B?RFd0elE0b2NqSnlhaHNMaXpTV0tlQytNVktpRllEVmVzY0hzbmFDSnlNMjh1?=
 =?utf-8?B?ci9nNnozSVlsYXFVK2c5Mk9QSWlkWXJmbzI3VjVKbXJMMVhPNGgxYll5ckJQ?=
 =?utf-8?B?dnZqUnpxblA2UWZKWXl0SjJoOFFkSytyYy9HUktRQitPUllPbHNNaTd0UDRq?=
 =?utf-8?B?ZEg4bmVneE5DRURCNlJ6MXF6TWVkY2hobjMxdFVTdGlyWG41ZGRmaHpKN2F1?=
 =?utf-8?B?QU9DbjZDMVhJNWl1NnJYL080MStsYUVhUHl1MURBeTFjUDZRQWV1QU0vdXMx?=
 =?utf-8?B?V3BFWTRLNjEvOHhWd1QyOFRQVVk0TDFqRzN0YUpnd21mNG85c1kzbTM4aENE?=
 =?utf-8?B?dzYycHc3M3BLNWNQS2RMWWxHYkxudG91ZEpGZjM4cVJCVERYTlNyRjUwSXBh?=
 =?utf-8?B?dnF3REFSVURZdUtvWXY4T3lTbHh5ZVV5aVZWb3RCc1NmMVdtT081bXA1RlUz?=
 =?utf-8?B?RnNZOWQ4K09RZkUvVFViZENXWWI3N3lRdW5xVmh4anpJWnE3ZnVvTXBtdzFU?=
 =?utf-8?B?SldEVDFqOEVrQ1UrcWxBSEhmWGdkWHBzSGMwRGFwczdnS0Nvcm9OY1dUWXN6?=
 =?utf-8?B?WkhYOXIvUkdSazQyNVZMaFp1eXJQem1sWHlnOEMzNXNCN0JpRnBjS2FRclFE?=
 =?utf-8?B?bDRtSTMrQnpjQ3BvSkFXU05UN0lkQ0lCREk0cmJlSUFhSnRoL29FLzhhclU5?=
 =?utf-8?B?TUlHL0FVOUZCOEJ0L2t5ckk3Y284TzNPcERqNWxZWFEzaWRIcEc5ZkZQY3hx?=
 =?utf-8?B?SVdYeGlIakFETHVtWisxUWdHV3ZYQzhRVklwQXJFcWpuQUxCVHhiejFqK3gv?=
 =?utf-8?B?VS9UdGIvTTFabi9UMzI0VTBGbkpqV0J0eUVtMlBkQmdhQmprb1N6d294dE82?=
 =?utf-8?B?dmNkRmxNOW4xbzV4aEw4TThrZXpRZFZSaTRGbTZYNHBmZzI1Y0Zwc3JyOThh?=
 =?utf-8?B?czVxQ0pHTDk3VGxmcnFScU1vWVdvWk9ocGxYVytZWHczdlBrNU1TeHU5c3R1?=
 =?utf-8?B?anJnc05iaW9kVDN2cGVwQk9sMzl1VC9tOGFjVFZzbzQ1VDI5dWlKd29vQVYr?=
 =?utf-8?B?TGhLNDZqTnJJZ2Npelpvbm9Qd2RKMEpXenBkcnA5L2h3R0xseWdLczluS3Jm?=
 =?utf-8?B?U0NTbll4MGJiWWpJb2hLWDRHM2VIclUva0xHeXJ6T1VmbjMwWWFZT2VyeWVz?=
 =?utf-8?B?d3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 086ebb25-de0b-4e2f-f179-08dbc11ab00f
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2023 18:34:17.1435
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YVjue3B5jewAJjTtU4xniFYXJCY5cE93vBwnYC9YKYyodHp7xYmGUiLJV0SFc/D5AQjgd1ChotG3m6///B2+1MlA7oAF5fKZLRHAfoIXDAA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6089
X-OriginatorOrg: intel.com

Shiyang Ruan wrote:
> 
> 
> 在 2023/9/29 1:13, Darrick J. Wong 写道:
> > On Thu, Sep 28, 2023 at 09:20:52AM -0700, Andrew Morton wrote:
> >> On Thu, 28 Sep 2023 16:44:00 +0800 Shiyang Ruan <ruansy.fnst@fujitsu.com> wrote:
> >>
> >>> But please pick the following patch[1] as well, which fixes failures of
> >>> xfs55[0-2] cases.
> >>>
> >>> [1]
> >>> https://lore.kernel.org/linux-xfs/20230913102942.601271-1-ruansy.fnst@fujitsu.com
> >>
> >> I guess I can take that xfs patch, as it fixes a DAX patch.  I hope the xfs team
> >> are watching.
> >>
> >> But
> >>
> >> a) I'm not subscribed to linux-xfs and
> >>
> >> b) the changelog fails to describe the userspace-visible effects of
> >>     the bug, so I (and others) are unable to determine which kernel
> >>     versions should be patched.
> >>
> >> Please update that changelog and resend?
> > 
> > That's a purely xfs patch anyways.  The correct maintainer is Chandan,
> > not Andrew.
> > 
> > /me notes that post-reorg, patch authors need to ask the release manager
> > (Chandan) directly to merge their patches after they've gone through
> > review.  Pull requests of signed tags are encouraged strongly.
> > 
> > Shiyang, could you please send Chandan pull requests with /all/ the
> > relevant pmem patches incorporated?  I think that's one PR for the
> > "xfs: correct calculation for agend and blockcount" for 6.6; and a
> > second PR with all the non-bugfix stuff (PRE_REMOVE and whatnot) for
> > 6.7.
> 
> OK.  Though I don't know how to send the PR by email, I have sent a list 
> of the patches and added description for each one.

If you want I can create a signed pull request from a git.kernel.org
tree.

Where is that list of patches? I see v15 of preremove.

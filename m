Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B7EE66DF9
	for <nvdimm@lists.linux.dev>; Fri, 29 Sep 2023 20:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696018769; x=1727554769;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=xUukmYPyxyfHTHllrHrppvXgRluzAs7D3ed3c1LacdY=;
  b=n4t0d7OMzo+a74upTwOmfa1HzKCzbDJh08V0/ShbE+r5oxhFXneS9JB5
   sqYdNsX4aYRqPXRp6hUIms/e1D3GlowEqShANpah78oWY5eQT7Nlsvl6W
   JZLAAcA9yXRpSiB6VRkTKWHRQw5K6gZWX/PIxmDLoqT7Hks8KUKdMTojP
   CKMOhbvPLD2C8GQqaNJ61/D5jVbZ1RKKPyE4ZUdbyozKAtf0jrHhUylp9
   xJXoznM3k3WTQt7GoACs8UPsX4/9fpbvSvl9Ae599r2ZZxwLaMA1ve0LW
   aaKmlUPg9of4kJbY5Anh2kIXwvtCe8pFXyWleBKTCW/8hyoq9eGmhFmPX
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10848"; a="372711811"
X-IronPort-AV: E=Sophos;i="6.03,188,1694761200"; 
   d="scan'208";a="372711811"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2023 11:28:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10848"; a="1081013454"
X-IronPort-AV: E=Sophos;i="6.03,188,1694761200"; 
   d="scan'208";a="1081013454"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 29 Sep 2023 11:28:10 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Fri, 29 Sep 2023 11:28:10 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Fri, 29 Sep 2023 11:28:09 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Fri, 29 Sep 2023 11:28:09 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.107)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Fri, 29 Sep 2023 11:28:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PL/HjI1Y+ojkjv7AruRUaLor892sSNUDVOrRWpkYAdN21hkbk2SHiOsK5wkYDzFEf4tUQAC65NK46JEyn0ve9NFpnecHM3pbJnurgXCPtin5pZvpygp5x581ZaWyAr0o9tC3UJ/z8i2A28jRQoA7sOiZbnpiaFnNMMVrpelRuyjE6F/i03frs4NCu+DQ9/7W3x0CTdhQKheuFdbLgztwm2cFRk+McPqg8wv4VGM77HDc6KMSBg27o8ohLqBrTsOxNvTsevXFGbKdVTAaA9/9OIb/73cgO0qBEHvpsA5qwkM/1el9SpuVJWHCa263abfC8o0tTXLWDfCeba9MkUmZzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ViExdXOnJdhHs89/m8LQu+1NVEBggmikRAwvrRW7B90=;
 b=AQnB1lkGPSSusBwCuMnRvR2T9/CpjBvjrEX17ac/8fT+9p7ZU1rA289RQYJIFlVP43HPjAzOqN6UPXQ6SzGnLn6Bn08CdkaxBlKDNP+Jf9P3pgnl/13IV9eUgBKt+SBG47kV+VwAH5OkMhAmOnf7rtEvbHeNUyyleWwruto1wPgc9cIsAIlD05j6JpM+lQXkqGZ/CbkLnuMfZH3NzyhQ+n6zVNOPO8QIk/EtAUj6LmphFLib8ATNF7f6gYb8gwniTa/gaYfFFn3MOJ1MmKqA3WSJZBMkXHVk1hpAyywPf5dwSDKlu9KO0my3ONJZMCJydG69wkwg8qOCyso7ROasvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by PH8PR11MB6928.namprd11.prod.outlook.com (2603:10b6:510:224::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.28; Fri, 29 Sep
 2023 18:28:06 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::acb0:6bd3:58a:c992]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::acb0:6bd3:58a:c992%5]) with mapi id 15.20.6838.024; Fri, 29 Sep 2023
 18:28:06 +0000
Date: Fri, 29 Sep 2023 11:28:02 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Eric Sandeen <sandeen@sandeen.net>, Chandan Babu R
	<chandanbabu@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
CC: Shiyang Ruan <ruansy.fnst@fujitsu.com>, "Darrick J. Wong"
	<djwong@kernel.org>, Dave Chinner <david@fromorbit.com>,
	<linux-xfs@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<dan.j.williams@intel.com>
Subject: Re: [PATCH] xfs: drop experimental warning for FSDAX
Message-ID: <65171732329c4_c558e2946a@dwillia2-xfh.jf.intel.com.notmuch>
References: <20230927014632.GE11456@frogsfrogsfrogs>
 <87fs306zs1.fsf@debian-BULLSEYE-live-builder-AMD64>
 <5c064cbd-13a3-4d55-9881-0a079476d865@fujitsu.com>
 <bc29af15-ae63-407d-8ca0-186c976acce7@fujitsu.com>
 <87y1gs83yq.fsf@debian-BULLSEYE-live-builder-AMD64>
 <20230927083034.90bd6336229dd00af601e0ef@linux-foundation.org>
 <9c3cbc0c-7135-4006-ad4a-2abce0a556b0@fujitsu.com>
 <20230928092052.9775e59262c102dc382513ef@linux-foundation.org>
 <87msx5f4a8.fsf@debian-BULLSEYE-live-builder-AMD64>
 <4c985608-39f6-1a6e-ec95-42d7c3581d8d@sandeen.net>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4c985608-39f6-1a6e-ec95-42d7c3581d8d@sandeen.net>
X-ClientProxiedBy: MW3PR05CA0006.namprd05.prod.outlook.com
 (2603:10b6:303:2b::11) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|PH8PR11MB6928:EE_
X-MS-Office365-Filtering-Correlation-Id: 54890e2b-1a4e-4fa8-832c-08dbc119d26c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +/5Dejv5VyVoTDM1nqg7WyaZyE0tCoEZ/F7647gN3WQoNE1NWJzpMMvvat0XQ3P3GSo76N0H0HgQGx+TtIAxHY2hnrKkQjrV9SjTZxRygd94hab2fpRpCuegSXzPRpj2+HZUxV2VYsjDHshIxyadY4DSiTRERf9TQNIjIbSvb2ozfjAKdx/7hdUEYrwUw/ZSKSR8BnAp7AzRyKGSI7BboqsfFbn0bRwZhqsc1BNAdqPRw/8wP+FTYrzOWNOFflqrDfGUFdF083J5hXW8qvVaRT3ldFTJATJEf5j+90+Vzr+OnuYty/l8oLXPUDXzTng68eu5UO0Zoy5sUAcVY1o+UP1zy0bQL+EY6r26FQyYvF1r8vYWtNe6TQYUOjTmT5ZxnuK6bL+MtKPUMCR2f+CyshsO5pYkbaS9SamsmsoZnzL/4hJMA276rJBo4kFAVKCsragh3TwV498jseJgqjj0ZAi1Txwv/Kurn1zunFbF5HZ/cvNRV8dO3SQ0D9h04JbuTqwB/0+0PlbGseJm/MH9cR1Dl3ZhMnPVOwNGiy+1wd6FDgAiLI1f5Es4V6pXR1ms8IOxNWFnuIX77Cbv2HbKSQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(136003)(396003)(39860400002)(366004)(376002)(230922051799003)(451199024)(64100799003)(186009)(1800799009)(41300700001)(66476007)(66556008)(316002)(110136005)(66946007)(54906003)(5660300002)(107886003)(82960400001)(86362001)(38100700002)(83380400001)(8936002)(4326008)(2906002)(8676002)(478600001)(26005)(6512007)(966005)(6486002)(6666004)(6506007)(9686003)(53546011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SEZKT2V1MC8xSGJmOXZ2ZlZFOVI3WGcvNm5PejU0QVlqV2d0dzBEYWFOR2xN?=
 =?utf-8?B?RXp0aWtLUzd2OFBjYkNTZjNoYkV2UzVKQ3FYV3lCZXZFcUhFeUN0VjNkRkFy?=
 =?utf-8?B?RHNXTU01RWRJdEo2R2dybkRlNXI4MjJubFBlM254MURNZkh4NEErV2xrclFL?=
 =?utf-8?B?L0NWQlpxZW1OeWpncWpRRldZZ3V0SmpuVUNrQS9GUHk4bFY2bWdFS1pzYit5?=
 =?utf-8?B?WGdNN2c5eUgrNzNlOUxINnBnK3hycDI4UE5NbmxZUnI1MVVRQjArTllVYVdv?=
 =?utf-8?B?TE1UZFpONkhPWkluOXIrMHNRcHpDYXpleHRCUVp4cWtNR3Y5Z2lhNXlSL3hj?=
 =?utf-8?B?SHJuaEdGTTZka0ZkUkcvcFRrWlQzdGhUSzQwMW1aUHpPMWFMa0dHV3V1LzhT?=
 =?utf-8?B?VDlvM2hqYkEwUFk3L3AwTlBGWEhFOEtzdVJrSXF6ajVMK29UbHduN2tvNXNT?=
 =?utf-8?B?bUxKQ1daMWRuUDFWQStCTDhMVmw3cmtvTmFHUm5Ob2dTZDM4WUk3bkpZa25x?=
 =?utf-8?B?L1RyOVU3cHFtcWZ4SGpTWmRydTNyZ2xGcE44Ry8vSU1iTFVrT2JmTUNsdGRZ?=
 =?utf-8?B?R3ZrQVNTQTN0QlB3TU90ZGYxRmh6NEVqc1BnWWdTaTRWbzBjNklKYmw0UEZm?=
 =?utf-8?B?c2FWQ3V5SWZUazQzRkRpWmhUUkVOQmdHeHU2bFFRZjRTWC9ZTTJqaFhqSUZl?=
 =?utf-8?B?OFhsN0Z2ejVoNFNnNWNOVmpSd3NkTWVsdnhtbWx5K0VHN1ZiZ3ZFcWZ4Z1Vw?=
 =?utf-8?B?WjZBc0ZqNXhqWVMzbFEwR3VLRGRyNTBKNjFVRmRtOUhHb3lZSUpIbjVKY1FS?=
 =?utf-8?B?TFFLRyszczNJQnpQU1NEMXB2Smw3OXlXbU5pOUVhU1YybU1tS2VxUitlMkJr?=
 =?utf-8?B?ZEwzdWd6ZEQyUFdSMUlveVB6SlNqbm5zVGR1TTdlOThWeTFSVHZqeUQ4YlZm?=
 =?utf-8?B?VEwwdVg0YndaZjhQZWtEUnJjN1hiUmgwT2RDYUhSUzd1V29USXcyWFdxa3hh?=
 =?utf-8?B?Q05TdStWUnIybHBMU3VmRmZ3aUFwQzhGQmEvUEdmUkFCTzRCWkZDamRZUEU1?=
 =?utf-8?B?Y05oUm5HcUpxVGRSWS9NNDNwa01YaWZSL1k5ZHljQXA0SlRzamlRaW12Qkpn?=
 =?utf-8?B?QWJxZ0ZNVzRJWktBa0VKbkJwUXJObFF1MGtNMFFJbEk0a2NTcFhhN2lYbkQ5?=
 =?utf-8?B?aEFHMlM3VFVsaURJazlHYWdjTjlKbUNxNzF6d0lBRnZubWVaZzVGSWd2OXl6?=
 =?utf-8?B?WURpMTNPNm41ekZML093TVVwcG81OEowekgxcFd5L3VycEo3elhXajJsWjdM?=
 =?utf-8?B?T1BBOFJ1dG94YTdJcmJrc0pHTFh5aUdHTTJjd0RzRm1CWXVVUEwyVFhoSW1y?=
 =?utf-8?B?SWExYnZoRUZQa2JDU3Fia3JjeWhLajNLV0ZqenRpUDdTRlRQWXVQRWYrNHg0?=
 =?utf-8?B?YnBkOTVvRUJ6Z2lUVC9nQ3JMWXlySWs4Y0M2RHJKUGpza29FTCtPMVN6YzFT?=
 =?utf-8?B?S0F5MnJsRm5DVHNoRktybThZOS9ZbENsckY5RHQ5OTl4aHBseWZiUEFrRnZL?=
 =?utf-8?B?TDd5eVEydTYvYmJsN3p4Z3EzSkRmbmcwMWVEKytqb0dSQUhOUVpraHVTWmgy?=
 =?utf-8?B?ZFJ3azhJSWtONmcwcHJzazlmcXd3ZnZqZFdXY0lBVFR1V1dFakgzRmZacjd0?=
 =?utf-8?B?dGdnbzBXVG9tL3kyaUtWM25RbmxocmhhRng3L1NuaEpFN1pDbmFQbTVRZUsw?=
 =?utf-8?B?d3hWb2tRNlVnbkFteFRyKyt0VnYrMUZiQk96aWQwaXZSQlRSV0NvZHlQdGFX?=
 =?utf-8?B?LzRKR0UyUU5YbjVNTXBYanJoRVgxV1AvQjRBbmt0djlwMGUrMDlNcHZyd25x?=
 =?utf-8?B?SUxvOXFjSkwwZXlDWitoL2g4YzRSR0dZRGNncDBVNnlaRDJ4SG81d0gySDEx?=
 =?utf-8?B?QlQ3QzArSmtrbXFlUCt1L2g1Z3FJTGNZenNXZUk4OXpzK1hITHdyRlV2THdt?=
 =?utf-8?B?MWdNbTZtcVdLZDJYT3ZDL0NaOGJZVXNmNVFueVFhSXVXQUM5SDUwUHRuK0hz?=
 =?utf-8?B?SEE2L3ZSNzVlQm1xaVVmaGZsNGZaWlNJY2laWE5lYnNRQzhScytKd3RDSndz?=
 =?utf-8?B?cmV1WmphMmZZa1ZYL1NYL0V4Umw3ZTg1cmlFS3F3dFhUaU5XVTFQSUxsSHA2?=
 =?utf-8?B?ZlE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 54890e2b-1a4e-4fa8-832c-08dbc119d26c
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2023 18:28:05.9093
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gpGqsaKQuv6+pjasY/K+zj/Fm4TFVwbfRCI8GsKoZYj5YfDeb5moKQAhgKkceO+MC3BPUYMf7koYgFxjJ9SEb535VSupAc4HqVj6JrXAXSg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6928
X-OriginatorOrg: intel.com

Eric Sandeen wrote:
> On 9/29/23 9:17 AM, Chandan Babu R wrote:
> > On Thu, Sep 28, 2023 at 09:20:52 AM -0700, Andrew Morton wrote:
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
> >>    the bug, so I (and others) are unable to determine which kernel
> >>    versions should be patched.
> >>
> >> Please update that changelog and resend?
> > 
> > I will apply "xfs: correct calculation for agend and blockcount" patch to
> > xfs-linux Git tree and include it for the next v6.6 pull request to Linus.
> > 
> > At the outset, It looks like I can pick "mm, pmem, xfs: Introduce
> > MF_MEM_PRE_REMOVE for unbind"
> > (i.e. https://lore.kernel.org/linux-xfs/20230928103227.250550-1-ruansy.fnst@fujitsu.com/T/#u)
> > patch for v6.7 as well. But that will require your Ack. Please let me know
> > your opinion.
> > 
> > Also, I will pick "xfs: drop experimental warning for FSDAX" patch for v6.7.
> 
> While I hate to drag it out even longer, it seems slightly optimistic to
> drop experimental at the same time as the "last" fix, in case it's not
> really the last fix.
> 
> But I don't have super strong feelings about it, and I would be happy to
> finally see experimental go away. So if those who are more tuned into
> the details are comfortable with that 6.7 plan, I'll defer to them on
> the question.

The main blockage of "experimental" was the inability to specify
dax+reflink, and the concern that resolving that conflict would end up
breaking MAP_SYNC semantics or some other regression.

The dax_notify_failure() work has resolved that conflict without
regressing semantics.

Ultimately this is an XFS filesystem maintainer decision, but my
perspective is that v6.7-rc1 starts the clock on experimental going away
and if the bug reports stay quiet that state can persist into
v6.7-final.  If new reports crop up, revert the experimental removal and
try again for v6.8.

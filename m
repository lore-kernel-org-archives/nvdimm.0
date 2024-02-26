Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB07E132C0C
	for <nvdimm@lists.linux.dev>; Mon, 26 Feb 2024 16:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708966712; cv=fail; b=q89rFHpN9e3zAHv3pEHLf3pMvPvwyTEgOeapFaHuUpo+W+rFyQ/6qfT3XDqwujKhi4qxTtdlc6maRGwtc7rRrsVgPQ7TritnIMVshCQ0m/0fJHAoGb3k+cl/fylEuneU6SvsuV2xFWX9Ugx0L0XNQ9YzT276WbOZXEMWHxXTjNE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708966712; c=relaxed/simple;
	bh=J5bwsi6pjMpbXE8JQs3d3YKqX+BOgTKeyUUSNuRNVzw=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=AqKJbVfDzuotUNnmQGaRqKUFjOwTHdyh5s0ij0UwM5j79NOOuGeJP1Bgm/7/GRv6c3gya/qfmjFY8IUL1pYVGTKygsqE1wzFEKtZTC4ODSIlZ2wb09lna8ZIP+03lx/SO7u03tN7FLReuDKS2wUv57dYi5Zqsy5L+G7r/eYx+4I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=V56FQ3Pv; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="V56FQ3Pv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708966710; x=1740502710;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=J5bwsi6pjMpbXE8JQs3d3YKqX+BOgTKeyUUSNuRNVzw=;
  b=V56FQ3PvEwXjlFQ+7PRS8Gz69iiCS1BNNLBu7TCbalyRN869EB9uw4Wr
   iKFg8Xt9atDKKFq0dOrnJAzNKbGNY+CwwNM7RnuBlP7xNLEzMHQBpovkf
   SXzfuE7O7C+h5a+TYfYWIFUj2eysUc69EDzxfLceqbkDmZ3/TTL2PBu84
   FiW1NZhbKjAZw73fqR5Jh4YGb/PK/ujlW7cvkKx3tNBojn5MYYDm9T8Uf
   BaGkI32sorH89nOLJ9S1+JKU7VewSQbjdcmpdBvrMgwrtNYfayAawrAgo
   KOTf96ed3eRaP1TDtY5jRa4K3Guz6rusLG4sahI+DzKQexZrRUnepON4C
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10996"; a="3812247"
X-IronPort-AV: E=Sophos;i="6.06,186,1705392000"; 
   d="scan'208";a="3812247"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 08:58:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,186,1705392000"; 
   d="scan'208";a="37747171"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 26 Feb 2024 08:58:28 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 26 Feb 2024 08:58:27 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 26 Feb 2024 08:58:27 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 26 Feb 2024 08:58:27 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ANpJ9c6ZSLfo6ypyddrFn4nodhtOXtL6e30JtjO8StOUJIxHhwTEQu0FshPWQOkN9zXzj1NAL5OJRoo/FcU+j49zjfu+srv0hGRhSPIpAuUG3tBJRP41R4W2wibeNWLku81Vcsl4FGTB4u2eSUu/jbKsMiX3FjLfOOaQ/FrOwLqhOlreeztFj+RlOIfukycMwWp3Etzh9XMeCJrLoP7evh+3y4eoIywIWoXAqEzdPHCOh7SjFWcq16hspbkOvaRj2+8ZToQdwoSn9GLM2sYsye/NA9HX/BhGNwHSGNXHEZMzNeBZZ3o7kkXOt/Kjw1DJ8x04puUBrl2XpwA089IA6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DAjx51U3FK0NqNX1iiWBV9NsFFF1x6K5/ni11nsPxL8=;
 b=gVHqTnR++vLgKwcheQu+sbQyL/1ihghAC5d6skCDPnvyYRd7KZOPqcsghMePDDPRacZrvizKG/TmD9pFvsSltiCy4K05sMHG8nuO50E6dUZB2feTkAL/KsEti0WfOGm1ammKPUEaY7rZQyt9q2pQfoM1bJzodmdnWuoZva3yQwPM1oADx8oiIkg+Pq5fL5+t4eu55Kc2VGVZAXGcsOrDHQ4XnG/sEeTT5lPc+4YQcBEAZKP6YXpnFy2iF4tdxYGBHSvv+RvYpKrGCN4mSXON/HcN6V9SQ8l8as1JonjAQl2XQ5P2ddDPg/rxhcC4VXTDTKIzPSU3UFaw+fZ1eRBbEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by SA0PR11MB4637.namprd11.prod.outlook.com (2603:10b6:806:97::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7339.10; Mon, 26 Feb
 2024 16:58:25 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::82fd:75df:40d7:ed71]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::82fd:75df:40d7:ed71%4]) with mapi id 15.20.7339.019; Mon, 26 Feb 2024
 16:58:25 +0000
Date: Mon, 26 Feb 2024 08:58:16 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>, "Darrick J. Wong"
	<djwong@kernel.org>, Bill O'Donnell <bodonnel@redhat.com>,
	<chandan.babu@oracle.com>
CC: <linux-xfs@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<dan.j.williams@intel.com>
Subject: Re: [PATCH] xfs: drop experimental warning for FSDAX
Message-ID: <65dcc327f2e61_2bce929418@dwillia2-mobl3.amr.corp.intel.com.notmuch>
References: <20230915063854.1784918-1-ruansy.fnst@fujitsu.com>
 <ZaAeaRJnfERwwaP7@redhat.com>
 <20240112022110.GP722975@frogsfrogsfrogs>
 <d205949b-27ed-4bf3-bfc1-31b13eed3b9f@fujitsu.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d205949b-27ed-4bf3-bfc1-31b13eed3b9f@fujitsu.com>
X-ClientProxiedBy: MW4PR02CA0016.namprd02.prod.outlook.com
 (2603:10b6:303:16d::22) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|SA0PR11MB4637:EE_
X-MS-Office365-Filtering-Correlation-Id: 068e2124-2424-426d-b2cb-08dc36ec2585
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Xt/wsJ33EZ8kBxPgasBdveen3rPr6dYREGCSvL9czUVPI+mMbFgFmb6Y+u/ys0VQPSCRP3z6GHGqrkwCpm2meGVR6Kk7Y7s3ARYht0/H4r82vI5NYS0nrcBFmYvKYdKoUH3w8MQtJSzjxGHAZis0evj+xqJ6yBHuUKA/vnZLVEJ67bMoT4z72CbSj+ESK2hgca/PWZfI2w8mJMY5gm2wSFKhgMY1bWsrOjcogwtRHRbKd9dn2zCubul4MfMG+xAnTt8IYwe28mKENOfbROQcrpBVrzsyVL9iDHkv6ZFIGXGRhp3gkP9vpohU4HbPybCYaO7UuDFizbTUrtylo9vpllf9yjvoj5Y9FzX5Uwx4yhmD41siAeHkL1JWvh9dmkvT7ZCycMtqY8a9SSvOcAd7Dv4IPUoPevty4GJhGD24mrFhCKN0Dvd/rw85bJF/inmlDeuE5xMPvPkjNPvor8VwlLxy+G6KlylwYEO9YKpCa9Y6LkrddcpQskXE9SytXCDeNzrT7OBRD04kq98WZHTGZI9PRhJcUstQ6AMixrUOjzm7OL8rC9hCERa/mWRELYUgBYLkjFPw94Mhd9bAX0YABsr8YyQTe3mePhmRYHdpL4tZCIbZ1jiQG9YcFcLJzM9uiNSUa0wGlpRro8gIoXHdnCtKAfodU7MJ9cwsUywp9Fs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(230273577357003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Tjd3V1d1SDZ0dWlEK1kxQUIwc0s5WnZhek05YS9OQ0NPdmw0b2R3NXdpaWlR?=
 =?utf-8?B?U2wrSFpUdlVmbXRNa1FNNEYxRlh1UXJxVjdKYjVzd3l2NnJqc0NXYmx1cVda?=
 =?utf-8?B?MVFXdUJOUS96b0p5azk5bUtwaHFSU0tCdm9SVmJBaHdGWXhaZE5TanBpckI4?=
 =?utf-8?B?VHluWkxPMVFmVkhMSlRpK3dSdURyNGxYcXc3YUdXc1hqbnc2QXpVa2pCMGlR?=
 =?utf-8?B?TEh6N2NkVDZMMVNvelgzOE4rQUN4ay9lVjliUEtCbHFmTWpPQkhEblJxdzhj?=
 =?utf-8?B?c25JZkdaWS9vUFdZKzJHNDd4WStsNTBQNDRvSE9LUm0zdWtUN0hRQkl3eld2?=
 =?utf-8?B?dlI5UXozTzhiRWJ3OXNpcGw2Vmw4Z2hJVjY3UzhRVzF5UmJ5QUJCekhwc1BI?=
 =?utf-8?B?bTFBVThBcEU5b0V4TmhlS0VuMWNTclRobkk2ZzRNbVpaYVBKNGhIdnF6SWpj?=
 =?utf-8?B?MEp5aGVqeGVBSlhFZytZbUNVeGxMek4vMEQ4eXp3SGx4d3VGSTNRcHpzUHYv?=
 =?utf-8?B?cXdad0RwdFRvYS85T1pMdlAwajRreGsyemJGZHcrUTdQb080REFLOGNrU0xD?=
 =?utf-8?B?bWIwRFNreVI1TjRPNXl2OVp2clZRbUVNN2Jhc1R4U1drOCs0eXJrbjRPd1VJ?=
 =?utf-8?B?RTBtKy9xa2lrTHZtN3NEUHFzeS9tZEtaMCtYeXhKb2g2aUZHRkNDbUNWN0do?=
 =?utf-8?B?cmZtOFhYZEpJYVlBeTBDWThmckJEYTFzL3Q1bkhjWjdtVFFxL09BdUgyekFa?=
 =?utf-8?B?RkhUaVRGeTlISitDZWhqRmN5OXVRdzVtV0JycDdiczhEdFQ1bFpGN1F6LzR4?=
 =?utf-8?B?ZDVMNnhjS0kwYmlscFdXRUh3c01KREozL3BBMDVKODJnVkhreUpvVGFwVEM3?=
 =?utf-8?B?RjdTYmR5ZXdOVGJzWjhrTUsxZ0d3NDV6S01YbnR1ZW5CZUF4MVZYNU9xREQ1?=
 =?utf-8?B?VHhkK0Q2V3k0RzZXOVo1THhjS3cwNDhrZGh3UkxTUEV6TXpXVXNTeERhUjYv?=
 =?utf-8?B?TEZCaUdyWm1Wc0w5R25jUWZrVWhvWHhsM3psNStCOEp0cm9QVEFVZEowdjdm?=
 =?utf-8?B?S1NESnNJL3BrNm11NnBaaGhTb0hmSHVla1NQM0E1U3pwYmVZN1BGdTlROG1h?=
 =?utf-8?B?OFJSb0lyMWdnZERjNWpiNmRHWkd1RXFoVW54ZjRTV2VRbGVSUGk1a1B3UGdV?=
 =?utf-8?B?a1MwVnBYZE9kdVpRMlJ2S2RHRE5ydnJIN0VGUnFYeURtRTNUdzdOQ2FkT3o4?=
 =?utf-8?B?bC9xQTcwWGpsbXpYcXovR3BWb0o4N0VPVG9mRG1Dc1hzcWFXdE84Y0h1WUhp?=
 =?utf-8?B?cXZ6VnUvMHloaUdaYnRiTnA3R2RQM1Z3eXB6K0p6My82S1FVbmlKQWpGRmZo?=
 =?utf-8?B?SUo0bXczNzVOcDBoTU4rVWpkMHd6S1pHcEh6Sm5tMEJGa29BdXJUdXZwVlRK?=
 =?utf-8?B?aS9kWDZTTGZrRjU1c09zU3JKVlk0S2tBcVIwbnNHK2h6OFhET2d4cmY3Skl4?=
 =?utf-8?B?QVZyeVRBRDJtRnIvNmFDNmRhUkgzdnllUHNaQWlodVBzZ0FGYnBVWUJnYXNy?=
 =?utf-8?B?VGczb1JmZks4U2tsdWVEbDZ1MFNkc013RFhoTDlFR3BZUnVlZHFnSGRQVWg3?=
 =?utf-8?B?OWtJdlJjNDNTZ21welpzTEkrNWZCZWtGNDdUbkhKRng0aWtDc0liNmNnM3JG?=
 =?utf-8?B?MnFBY3VZbWxkMExwMnl3cDNkaml0YnU2ZmZsODVTNEhjNVBDdEVzSHd5V3dF?=
 =?utf-8?B?dEZoSFd0aVRyTmhCeTMwN2Z2QytnMWxDdFhRd3pkY1ZDTnJyVHRwUkJ6TmND?=
 =?utf-8?B?bnBabzFnTjVXVVpIWG41OUZqd0ZtZ0l5S09ZZzlPVjRPY0VjcEJqUk9uRnoz?=
 =?utf-8?B?Z3JEa1c4MmRzM0ZBOU1oNER5ait4a0dsZkNkUlhhY0RHS0VuallGR0MrQm0y?=
 =?utf-8?B?V1pQWVJER1hhbnNnS3hxUXRlZUt3MGt2anJOWDY3UllMckpBVldOeTg4UEpR?=
 =?utf-8?B?MVoxUklQOUUya3pLcWRxanVmSnhUblZ4ZEFIekxpODR6b2V2d1RocW16Y1Jn?=
 =?utf-8?B?UFRMZURuV29qclRCUEpIZUEwZ2lJQjhoTkpyYjlacEMrTldZOFZsZ094Tml2?=
 =?utf-8?B?VCtmczhTcmxwN1Q5dHZoc2VCSGo2SktEbzZweDdkMm1BaUpSN0NtK3NPVTNK?=
 =?utf-8?B?M1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 068e2124-2424-426d-b2cb-08dc36ec2585
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2024 16:58:25.1625
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RswHcfzF91d/bquRdZgwYv2aXr8oZvCFXC1ElbiQK9D8H6SVxp+Wfho7b7J8p6fyOG6wzND4YdbmYeayM7I2bHConIRYJuFjiFYN/JweqrM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4637
X-OriginatorOrg: intel.com

Shiyang Ruan wrote:
> 
> 
> 在 2024/1/12 10:21, Darrick J. Wong 写道:
> > On Thu, Jan 11, 2024 at 10:59:21AM -0600, Bill O'Donnell wrote:
> >> On Fri, Sep 15, 2023 at 02:38:54PM +0800, Shiyang Ruan wrote:
> >>> FSDAX and reflink can work together now, let's drop this warning.
> >>>
> >>> Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
> >>
> >> Are there any updates on this?
> >   
> > Remind us to slip this in for 6.8-rc7 if nobody complains about the new
> > dax functionality. :)
> 
> Hi,
> 
> I have been running tests on weekly -rc release, and so far the fsdax 
> functionality looks good.  So, I'd like to send this remind since the 
> -rc7 is not far away.  Please let me know if you have any concerns.

Ruan, thanks for all your effort on this!

[..]

> >>> ---
> >>>   fs/xfs/xfs_super.c | 1 -
> >>>   1 file changed, 1 deletion(-)
> >>>
> >>> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> >>> index 1f77014c6e1a..faee773fa026 100644
> >>> --- a/fs/xfs/xfs_super.c
> >>> +++ b/fs/xfs/xfs_super.c
> >>> @@ -371,7 +371,6 @@ xfs_setup_dax_always(
> >>>   		return -EINVAL;
> >>>   	}
> >>>   
> >>> -	xfs_warn(mp, "DAX enabled. Warning: EXPERIMENTAL, use at your own risk");
> >>>   	return 0;

Acked-by: Dan Williams <dan.j.williams@intel.com>

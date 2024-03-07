Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A50E613A248
	for <nvdimm@lists.linux.dev>; Thu,  7 Mar 2024 20:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709844942; cv=fail; b=WN4CFNBwCTyH2oUgETdKgHQQ1kAS9KpNJNZmBSPMLqoO9ZemADMkKHV8pdkjJgZL1PtRi+bBZ+JPGsjeDT/g9tjFLaMl1pd5hwfTes84/+UG9ZPl/XqJ0Yx2RIoVqaBocTNv9rVAFO7CYHyCUJqiL6mNjFtCfBihPgCYkGwxYLM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709844942; c=relaxed/simple;
	bh=HN8IxZqVS0zbelStA1LZXCIT6ZfMJV2L763azDlSwzU=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=o+EZsIQ8IuCcpcy3Qkme7wunJk53Cnwz8BD0nWJmLsX2rKdTt8N8BdUagbAOYJwdaW06VWiHacsbcyd2+wUCyMO3mhBJgzTVjVHyE3qFV3a8Yqada/xnkQuIQUxtI6O6qIKwrHn8mZIyTCYZ0ZlZFvTO2q7Gc/jRotWI+NSW85Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GzkX0f3H; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GzkX0f3H"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709844940; x=1741380940;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=HN8IxZqVS0zbelStA1LZXCIT6ZfMJV2L763azDlSwzU=;
  b=GzkX0f3HXcL7h3ppMcoSPf6VDW8kUloSKw1ikslxwyteJvCHkrVB3zML
   tQSVjQTs5cYHKheRk+mw+Seu4hNuJhgu6Q29y/LHGFwRu8OZhIJ60uhRO
   7QWq06oucq7c/wCdauJSud+hMUQT3NSFhYbyOsI1w6wfvUvCrqK+SmY+9
   sDXcPIO1SoaFs50BYCEQlv4PbQywzO3CnrR3VXUKdfFZtDnv8erKsW9Tb
   ihu0pUwdQpIufQvPO5s6NNMmukPR/bfI6wX/9CV07Zf3F73cWk47/wU0f
   Lq12qlpmUUtl2bi4WlP2P5jzSJlLKFtLSk8YvsMCDunT8UhKXlUbppJxs
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11006"; a="4665899"
X-IronPort-AV: E=Sophos;i="6.07,107,1708416000"; 
   d="scan'208";a="4665899"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2024 12:55:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,107,1708416000"; 
   d="scan'208";a="10127639"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 Mar 2024 12:55:39 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 7 Mar 2024 12:55:39 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 7 Mar 2024 12:55:38 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 7 Mar 2024 12:55:38 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.41) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 7 Mar 2024 12:55:38 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gG6hVQSdARGeOy1iGqY92ReyxzFFchnHUIws64p8cOnZC31E0tl0FY355Mg/C7DmX0TOOtUUDBUF7Zek3Q9irMmaK/oGA6t+L9UtrJyJKUgsB0qba14pMB3n1DKq1G7dliRpTtViU2/Rjql3jy34hqWTbcEE/t8svKh6nf+NKcFLy3QEZaaDf4bJpGtrRwp+PizpDx1oahgGbKLyD+FneCUVPAl43xoN56X+Gc3PaKL7f0DqisWiM6v6s7rlOfoBJy/nU15/R2EOw9tmCwkhFbME8yjoIpz7/OzJSh1IbplKYBIbwcGi4ZHpYJxtRgh3vNq2UBLAr+sw6nXUUL6osw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wbPkIIgkXeo+u4c14f9mNF2ecBP3pcMoIafSZk0NDA8=;
 b=noluI/VQD8cA/MGh4ri0Jy1LvoBKh/FT6N8MPWs/PEHzQFdXAvSjodlgJPbB9J7CEOLRca5RumXIRhV6SBDwh2B81SBVVZQ7RV/tkj3H1xnDp2W8WNp6zZmmcMO8HqtMEoUQ2w76FgWPqmJqyWtZoTUgMglFwYDvous7a2876zvIjGznlC9gfkX8t2oAHf6gYt6VIZhcH85PW7kZNYparSOl3VTulk4+YsExLWIIo3S6v9EdWuqejPGq5dr2S6nVU0xbyn0qhYsulTC+Jy0S7hipbF4qkN4u09JCea0yLF53pHDlMT4jSdK1zxpN/cp4O+TXvy4JSQt99kur7PboGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by PH8PR11MB6998.namprd11.prod.outlook.com (2603:10b6:510:222::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.22; Thu, 7 Mar
 2024 20:55:36 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::82fd:75df:40d7:ed71]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::82fd:75df:40d7:ed71%4]) with mapi id 15.20.7362.019; Thu, 7 Mar 2024
 20:55:35 +0000
Date: Thu, 7 Mar 2024 12:55:33 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: Jane Chu <jane.chu@oracle.com>, Dave Jiang <dave.jiang@intel.com>,
	=?utf-8?B?Q2FvLCBRdWFucXVhbi/mm7kg5YWo5YWo?= <caoqq@fujitsu.com>,
	<linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>
CC: <vishal.l.verma@intel.com>
Subject: Re: Question about forcing 'disable-memdev'
Message-ID: <65ea29c566197_127132943@dwillia2-mobl3.amr.corp.intel.com.notmuch>
References: <3788c116-50aa-ae97-adca-af6559f5c59a@fujitsu.com>
 <dd61a8f2-ef80-46cc-8033-b3a4b987b3f4@intel.com>
 <ebe3f86f-d3f9-414d-9749-7d41ac7d3404@oracle.com>
 <86f8f0a0-3619-4905-a6e8-9fd871ec0a39@intel.com>
 <353efab5-ee59-4bb7-abc1-b602db3306c6@oracle.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <353efab5-ee59-4bb7-abc1-b602db3306c6@oracle.com>
X-ClientProxiedBy: MW2PR16CA0066.namprd16.prod.outlook.com
 (2603:10b6:907:1::43) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|PH8PR11MB6998:EE_
X-MS-Office365-Filtering-Correlation-Id: 93662a32-1c43-4311-370e-08dc3ee8efb0
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W6bMb8OWYNf0QyIeE8Qlw+oUmMtLoJtEuGxWBocZ4GFD0o7ipJI6V84AyvscKcP2moHlYeuDKAnf70yvtXEq0w1aWEaNq5k/1ON6nRXKNtCK6FDRHd7z29wGQRKs1JAz408CFw4qGHbH4MxSZOwDnD+zYfXN9UTY3NDxTuDx6yEMKGp93lNqPkh1ziRLY21LoECplD5/w2ubqOmRlgRfbhvMC4LxFiFCaE9bYFNkLnVo2+WPM8YUFNCyyHoYXwcrCZb1x7kCJ40Sg/0JeNLyJGHMnmhvR4v/EaSq9dD+1gWG+0dBgjWk8a/aEkzayvRv3gUy64TUqBBUtVhCNl25u+SM13ZkipizqlkR7nUz9cxdpW1ehiu82W6EW2TxqAtJDsh3UmCmC3mgcfGFBw7Z+xMRj/vCNgeRy4cMw98qjTdYc+cWvx1flnPwKryL2x5EFvEmb/5OyQh8qsXt9Ve0hQXcrFMiKxCKi4SyxT61E49JEJC1tfYb1aCRc2lpVaCWbBSbk8dLJx4GYPuOIg20cm3Z9bfa4T71fwtci68WRevs0BrWU3pnnxMbn6xpDYUF4knhqgi7mf6pS4x8jyd8sPGTB8QsKlHKucPsJMyL0jA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RUFYZjZPY0EraGhOOG14ZmNjNC9sMFk5eWJvS3NYMndabUgvU29kQWcxWkJO?=
 =?utf-8?B?ajVvaENlNVJIUDZtSHNzV0hhZmx4dWZGcjJEMmg2c0liQzR3Zm1FQ3VvRWV5?=
 =?utf-8?B?YTRPKzdpWVprZFVYd1BQTVBSSVpvVGM2cUpHV1RjWU81bGNuT2g1RXErTUJt?=
 =?utf-8?B?VEdpZGFiL0RaRTFvYUR3Z05NcXNLdXdYQnliNFFwOWdOQWhzV214aE9hVVhE?=
 =?utf-8?B?WEVtVUd0UFQvQzBKZ3I4WnJGdmFIY1hLY0tDVzBXd1poMStCbDdwU3NVN1JQ?=
 =?utf-8?B?R0lYVTVnTUQrUGRPN3pIeGFwU0duNEhIak5YMm52L0ZyV2h4SDN0WnkvS2JH?=
 =?utf-8?B?T1k2cXpvRGh1UnVtUm5TQnBnMHB4Q2ZrcndZUndVY2RwK1FnbWtwWkxwdi92?=
 =?utf-8?B?YXNockpGdUJyUUFneE5VS3ZMWGo3K01ZZXJLaXpVLzN3TThpdXRDRm9hMU1j?=
 =?utf-8?B?UEtudzB5a0FwMnByOWFuNkYzNFAzVXZNdXYwTnE3eUQ2dVMwYmZxZEN3aGp0?=
 =?utf-8?B?Vkk3dFdvZ2Ryc1g1dkgrb29ZbGFXQm9FSXRRSW5WbmJnVlJqYzYwWmovTk1t?=
 =?utf-8?B?MXJvVDFOejlWQjlqcHplWVdkN2ZMc1poWjNPaFFxTVN6akZZNXhZL3AyMDZa?=
 =?utf-8?B?UitIYjN1UldUTkk3SWNtejlEQXNidTF5SFJqT3N0K2Z2aDhzcDlhcUdJS2ht?=
 =?utf-8?B?VFdPNDV1SXMzMk5RcjZIM05MczRmb2IyeC9wdXp0NXBjRkRDbG5yVjExQW03?=
 =?utf-8?B?Y0JvQWdqbStOVG9uMTcyeit3bUE0TW5lTStzVjlETG96aEYyY3ozV0M0Y2xi?=
 =?utf-8?B?eXBCYmFMY3E2TWVDTlNZUHprVDI5b1lpZHZVS1phNzF3SktFVmFFdWJ3UWtj?=
 =?utf-8?B?QnU4MTkzRCtCMEVZUFFEeVdYek84RkJ2d1hvNytFTTJJNm85c0l4UWxBbmxP?=
 =?utf-8?B?ZGpCSk1PNVJ0YUNZa25BVlliTEdxcTJCV0JyNVdVUFFjK0NWVkJ3SzFqd2ta?=
 =?utf-8?B?YnVxNEtlWldLK3BmbXcveTNSSlpDaVFmd0ZrWEplcmpMWWpmSE9tRk01THRF?=
 =?utf-8?B?NzFLOGJmcDQxV2VPWWtEanFUOE1QWnpXd3ExVmNzU2NOSUh4di81VWtQaDNO?=
 =?utf-8?B?UTRUcGYvdUlxMGc5SXRQeTN1Q1QzdXJzcElZSXYzK3BJZjFjQmdoUkc1VkdK?=
 =?utf-8?B?S2RZdmdhN0xLeWxDRkFhVHZIcTBpWmt3YkYvUTluZTE5bnRzZUdueEI1SkZM?=
 =?utf-8?B?Z1h6YkUyYy9IU3ZHVEdMSU1QdDE4Z3FWZUhTTlVXTUc3OEFubTFZTHJyS1h4?=
 =?utf-8?B?TjlUbGw2NU5wZUtUeXZOMzR5Uk1YSlhUVjNmRlZEbC9OSHRQR1ZVL2Rvd0xG?=
 =?utf-8?B?MFJncXJTaVZiSThlWWF4NGRtTmNtY0dxM0NjdVVHVVZzY2xtN3NTYnp6ak5p?=
 =?utf-8?B?ZVZBZ0FQR0tzNFRoVEJTODFoZFU5REk1emxrUUZvbHh3QWxQOVJNak02SWhJ?=
 =?utf-8?B?dkZmWXl2Wk1TeEhvNCt3WGtOTTdmczVLUFZYVVBES0JKYlpOcXVRbmFkZUVY?=
 =?utf-8?B?djJHOTBpNHhPS0ZNUFp2SGtLS1oveDdtbklHL0Q1VTFGem83MVpIUjl3M2pt?=
 =?utf-8?B?Z1ZreGVlRFBwV29HRXBaalNGVWx6dzdpak5RNVowM1JHYjNnRzVPdVVkcVBI?=
 =?utf-8?B?KzlWb0IxSUhwR2FQOVpjZXN1RlpXejNCUXZ1R2RvZHJ5SS9hN1JZYXNsKyti?=
 =?utf-8?B?TndTWm1pUDFkOHRjSVdTM0xNUHVPRTdCZ0R0bUpsd252a2VPMGlkS3hldFE2?=
 =?utf-8?B?OW16L1F2L1J3Ym5UeVhKS0V6ZlVkeHp5QTJxZlJYS3ptckFYOTkxWUs5VExY?=
 =?utf-8?B?dG4ramxrZnJWemN2ZTIvQm9HRjE5dlVMQXdHbDZVSnZkK0tFMDArYVlsYm5i?=
 =?utf-8?B?UnJYYUlmTmhabmN1THlCdmNHWkdkUWFVbWQzeUJhenlaRUhLWnhocWg3YUpk?=
 =?utf-8?B?RU1YZWQrSzhUTzFKVkRnUXA1ZXBzSGZxS0YvZEtDcmhtNVorNDZJOEtveU5u?=
 =?utf-8?B?Vko3bzNXKzIwOG83SU1SYkY1dFhDOFMyd3VOVFVWNzFOdnZWci85SE10eTBx?=
 =?utf-8?B?L3RtbkFZbUZWbGFKbDl6Zm5TS3lBL0tLVW9sSWpjWXZRUlFsZzR1SnNDTjh5?=
 =?utf-8?B?Tmc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 93662a32-1c43-4311-370e-08dc3ee8efb0
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2024 20:55:35.6758
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MHBeYXLg6tRDXj93YZLPiDDUQsUZZxpP9nhsz+SwPdJRWi+oAxAMrbaa/omhC9FW3eE1O5xCGmhMAzloUcsyb4cbj4xNLrn5Sr9cmXOctQ4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6998
X-OriginatorOrg: intel.com

Jane Chu wrote:
> On 2/27/2024 12:28 PM, Dave Jiang wrote:
> 
> >
> > On 2/27/24 1:24 PM, Jane Chu wrote:
> >> On 2/27/2024 8:40 AM, Dave Jiang wrote:
> >>
> >>> On 2/26/24 10:32 PM, Cao, Quanquan/曹 全全 wrote:
> >>>> Hi, Dave
> >>>>
> >>>> On the basis of this patch, I conducted some tests and encountered unexpected errors. I would like to inquire whether the design here is reasonable? Below are the steps of my testing:
> >>>>
> >>>> Link: https://lore.kernel.org/linux-cxl/170138109724.2882696.123294980050048623.stgit@djiang5-mobl3/
> >>>>
> >>>>
> >>>> Problem description: after creating a region, directly forcing 'disable-memdev' and then consuming memory leads to a kernel panic.
> >>> If you are forcing memory disable when the memory cannot be
> >>> offlined, then this behavior is expected. You are ripping the
> >>> memory away from underneath kernel mm. The reason the check was
> >>> added is to prevent the users from doing exactly that.
> >> Since user is doing the illegal thing, shouldn't that lead to
> >> SIGBUS or SIGKILL ?
> > The behavior is unpredictable once the CXL memory is ripped away. If
> > the memory only backed user memory then you may see SIGBUS. But if
> > the memory backed kernel data then kernel OOPs is not out of
> > question.
> 
> Make sense, thanks for the clarification.

I will just add consider the case of a technician physically removing a
card without shutting down the kernel's usage of it. That event is
indistinguishable from "cxl disable-memdev --force" at the driver level
since the driver just gets the same ->remove() callback with no
opportunity to return an error.

So this is a case of trusting the system administrator to know best, and
is why --force is documented as:

       -f, --force
	   DANGEROUS: Override the safety measure that blocks attempts
	   to disable a device if the tool determines the memdev is in active
	   usage. Recall that CXL memory ranges might have been established by
	   platform firmware and disabling an active device is akin to force
	   removing memory from a running system.

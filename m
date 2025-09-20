Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57677212566
	for <nvdimm@lists.linux.dev>; Sat, 20 Sep 2025 17:42:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758390137; cv=fail; b=GqsADgykXoeHhJJI065ROjKYcA1IVKX04uvI234OjjneGzaJYdNdVBZgk/fFqS6lUQv/qfBvd06IESFkOm9lDCVmlqBbiFJ6Rr+F2qHzQKCwFRHRY2qYWW2USQr7IIiXfSLbOjigwamckWSjTYAy99zGowviE5ZXWSDwpiqzuFQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758390137; c=relaxed/simple;
	bh=rO6Ro58b96rUQO60urQG5ZZhqopMkGQ76GLOzH9ktWs=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=XBY5XwEiXnJRLhMV/V4KbVkVIaSznO6l0XmeG1UZzFv8Y1zBWBRgEbIb96nRMXiK+m3o1mBXzHRlvn0lkEw2Wl6ONwtgbwChuLsSEUVNvpZ64Umf9M5QrJwKslQ/GV4+vAni1WlfN0k/nDcPdXuZJQB/EtLvMPsPBtyK7fJvNtI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZmdfDDjF; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZmdfDDjF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758390134; x=1789926134;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=rO6Ro58b96rUQO60urQG5ZZhqopMkGQ76GLOzH9ktWs=;
  b=ZmdfDDjFJu4a0uZOk2aVNdu4g82VHETegkVp2EWrP+g4gmiUbZPW7ZhX
   KF0wSW076OOVkSTTEV9fXmr5cdnvTL6hDtZyI0arsG1R7b6ZdR4+9qiLp
   czobBOR9Gt+CyNZFGWbdSgpYwkJR3XvrfoC55ibETmt6M5Ybsa0OcG0Hc
   VT8GfU7O5AmnOWyqbqIbT6UxHVMI6nUWe4PKjqOYzRkd0bUvX9BrXR3bR
   PAu+6TXVdvwm+RtFObg4VkzeN+VzKmhNXF0DKI+StWhwLWc801JMs1vKw
   DTnYdPNlMQFeYH3/6JVBvSCc+SkPHTsVh8Asg7HWXp/itJG2JJcVZE+Rt
   w==;
X-CSE-ConnectionGUID: r8CNW8h+RQaZWW8PwXTGxQ==
X-CSE-MsgGUID: j5ewxikoTkq3ZT1aRpEcDA==
X-IronPort-AV: E=McAfee;i="6800,10657,11559"; a="63341987"
X-IronPort-AV: E=Sophos;i="6.18,281,1751266800"; 
   d="scan'208";a="63341987"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Sep 2025 10:42:14 -0700
X-CSE-ConnectionGUID: 7We9weB5RlWUGarIIw8g1w==
X-CSE-MsgGUID: PhoogmvaQo286dcNtyPtmA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,281,1751266800"; 
   d="scan'208";a="175672068"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Sep 2025 10:42:13 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Sat, 20 Sep 2025 10:42:12 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Sat, 20 Sep 2025 10:42:12 -0700
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.26)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Sat, 20 Sep 2025 10:42:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WyjypzWvNdwHNvpE08BS0GklszLm+wx5hhBUeyeC+1iFI8R8Lbfb7AuCvg8eic5xc8BH12nus6cCIP1+FYihsOL9yqsWSEeTBnTcEEFxAOzB0Za4LoEBhJPwQM7nxTu0T/TMyFIxmCtIZrCstc+yOg6Sl+HMukm7I5ZlcO2/aHBZedDFsmDlKccC9xyb+EWzRilGFny7qB4aSFD6Gk1sWsD4zCpTB6Ho+RqrOQ6MzP2bug51Nj72ucA2n8yt9khIk2fik5iidgKLLkE0Vt2jtGOT/neJoh4vGA24T80LJbfr3eYA+jdtieo/u/nRxmki6Cmr8bQHLp2J4S9BawNSDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eqCLlkZ9TsadPs7SoQUuRwSxi6joSTHUjaaup0f5bZo=;
 b=ObpxDC9QTu+4f9U6RIBtgODwqekSxqdT+sRN2yEGiNwmxXykPcMyzdmMeD//ejcudtMGa/t6pOtegTiEXGbUeOrkgW6zwVfdcryZvVPT0KmWNLcPBKUoDJCzYCO64vpgKU63ptVCi1cHI5ZE4gyX+HAyjZA+s3KggCzXWGZodSyK7kptrnzh4KHxM1GkUsQ0yCpiGBkPvx6YBGvHIRZHMBwENQuNGP4HnMABlv4NwuywKbBGmjAl1WLU8J3wHPfFxmTecTkl/X22Unw66YqArXpZyrczIdcbGob72txROhQ27y1vdmnmWDF068dDC7PGIeIeo1lT09WTVYU1Itjn4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from IA4PR11MB9131.namprd11.prod.outlook.com (2603:10b6:208:55c::11)
 by DM4PR11MB7400.namprd11.prod.outlook.com (2603:10b6:8:100::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.18; Sat, 20 Sep
 2025 17:42:09 +0000
Received: from IA4PR11MB9131.namprd11.prod.outlook.com
 ([fe80::7187:92a3:991:56e2]) by IA4PR11MB9131.namprd11.prod.outlook.com
 ([fe80::7187:92a3:991:56e2%5]) with mapi id 15.20.9115.020; Sat, 20 Sep 2025
 17:42:09 +0000
Date: Sat, 20 Sep 2025 12:44:07 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: Dave Jiang <dave.jiang@intel.com>, Neeraj Kumar <s.neeraj@samsung.com>,
	<linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <gost.dev@samsung.com>
CC: <a.manzanares@samsung.com>, <vishak.g@samsung.com>,
	<neeraj.kernel@gmail.com>, <cpgs@samsung.com>
Subject: Re: [PATCH V3 04/20] nvdimm/label: Update mutex_lock() with
 guard(mutex)()
Message-ID: <68cee7e7a00f5_1c391729430@iweiny-mobl.notmuch>
References: <20250917134116.1623730-1-s.neeraj@samsung.com>
 <CGME20250917134136epcas5p118f18ce5139d489d90ac608e3887c1fc@epcas5p1.samsung.com>
 <20250917134116.1623730-5-s.neeraj@samsung.com>
 <b66e4c0b-a82f-4c18-8e8b-ba37b6551964@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <b66e4c0b-a82f-4c18-8e8b-ba37b6551964@intel.com>
X-ClientProxiedBy: MW4PR04CA0199.namprd04.prod.outlook.com
 (2603:10b6:303:86::24) To IA4PR11MB9131.namprd11.prod.outlook.com
 (2603:10b6:208:55c::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA4PR11MB9131:EE_|DM4PR11MB7400:EE_
X-MS-Office365-Filtering-Correlation-Id: f2bb1b9e-02d0-4a9b-8ea0-08ddf86d05fd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?o36j7TTjKnA58fUmwahs6d6dEJh15yF2wqGBzrIJjVab+lr60r+H6wAiWJpn?=
 =?us-ascii?Q?NlcSW+1ZDbfHfJtXNp970mYirGy/SEIZkYQ95ns6ApdvgTD8KzarcuTDgAge?=
 =?us-ascii?Q?xUK4Foz9sc5Qe9rsIV6cSkIY91JKiFMMUqt9MY8+jGtf5nSbz7mNMgOkdXwl?=
 =?us-ascii?Q?q7+FRF4YjQ9XKjroTJkwfcqNtQ7n8mS7DUE1imFh0f1qMKGCKRJfi9QCHfnQ?=
 =?us-ascii?Q?cVYm56Ia1FgfC81ZzEI3nmdUnfTqlAmpuxXxMfqMbAv9Ljp5Z2KWL7ZIiul4?=
 =?us-ascii?Q?VD4z1fdbj+CkX57jW8iqo1kWup1H/TJnxfvPBf/NIRv2yYtF/xwnnZP7qyYw?=
 =?us-ascii?Q?hz6gwZWuVzlFJhLA4E+W7OweDSlXOFMYa8fp7b04HzCCS0Lti0WRMMjMiLmb?=
 =?us-ascii?Q?BTgqMnyvEUzO7brttu7wtJqF/bCg76h17htgIdm7MjMiPNrOw7awze0BwUKT?=
 =?us-ascii?Q?Moba5N7UT9qtBYaFaS1/oYepqjUoWF+iSyqKFAsO92R3B8q1fvPiYOwz6X1b?=
 =?us-ascii?Q?guC1xb6BnuTFmDVwlBCiBvGKwKfWxkrwY4F9EVUTMvarQCWiCdG05BrmwwqZ?=
 =?us-ascii?Q?HjWQG6T7AjsKtRIsHw2F2be7yulWVPt+2m9T5hi4EER4usJtxqfHObmfwutk?=
 =?us-ascii?Q?AGOHOAk/nnDaiRrXIjRQG2Co27Ib0tZZbHJZAX24t+TYEQbhpAI+3i8OKbgu?=
 =?us-ascii?Q?Wb6VLtN3YkS3v+K1y8qkC0Rt4ApIJfJRoV/fFSPxEjaQebeUzuBjWnayDKEQ?=
 =?us-ascii?Q?nz0oXCHLYtxV0PPE9cM3YX12WET0GOu6XpqaUfKds9dzgvFDO1moGKLkWjS2?=
 =?us-ascii?Q?J7dwDOA72i3PVAFs06SzDPdyuygkIBzV6qUoEV1oW6FZcZxTusDh9V3EeDPP?=
 =?us-ascii?Q?r1QSQq+wl0FTawEyv8p9NvObvbmPQepmmuu71AcQ53l18kzTGznSKMUi3Ycw?=
 =?us-ascii?Q?lWxM8Sfqa/3gjMHMBpwCyIt+ynHuSfwBOcCj8hUlN6ZfJz+oTj7aAe2xxOJ5?=
 =?us-ascii?Q?BHoVv1B+hBk+dQ2d6cAYmooKG6ckOt6M1S0Mk/IlyZyeyyLuhppQ25U2mpTu?=
 =?us-ascii?Q?DeunWeUNe4Gn6zVm3eaPdKP/YOLbbwCq6pp8ecPdMHiXr473Efv/SLPQp2WY?=
 =?us-ascii?Q?FfxanNxsJ0nO1u0HrcAk7B7K1udHyBIk4azEueS5BFalqmSaOzI/8VG8pi+e?=
 =?us-ascii?Q?gIHfBZ/tSlQ6TVeL1t3z4UYfT+JNvsvnl5875y4BeLvEOD90CN67EDPsngXr?=
 =?us-ascii?Q?KjIy/QcgVQxjPHs+EkDDPl8iGVbVdRc93U+D24KkZK7fDQ7qWosZZH97B6vr?=
 =?us-ascii?Q?l5sEEANYpb8z8yTN4ZxmWJ3PblJwUDGSfrbuBKMF4DJW+kF7ZprfALT6wmc7?=
 =?us-ascii?Q?Z08aE6AYAHUyP2anhXOdYfOqQeBSASlMiCS4rBNfVPzZIKJIf6hrpAdhiBc0?=
 =?us-ascii?Q?WhRAFxnQ+Sc=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA4PR11MB9131.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NZig7NDNUAjYLkcL//tM//RW4dd00DuUKy5d/0Y6/fFt3WNgd4TSqQxvSODF?=
 =?us-ascii?Q?5FOLLg+fjpAC/kWlCfwzXiouPo/Yx+E9/XOuMq4coIf8Cwk2e5l1dnNyhfen?=
 =?us-ascii?Q?OVXZY8ZkuYPWMcUe9ZTkLETxLmUL52XwDKDcPwqedz9uRnbtf7/DR81nLric?=
 =?us-ascii?Q?TICiM4TRLZd8CoLM65W9MhQyD+9nTpWX1NbZhlGhM52ZHH17lkIf3uwGmEeT?=
 =?us-ascii?Q?dDnAkzQ22mpm08uv4yMGfplItUSSn+5Nw01iAQiOQpq6Ahyy0zs3zuog84h/?=
 =?us-ascii?Q?flZrXRsaeG2Cry0CX4mN+CHRXb6fFFu8scPIlaMu+oN+RDAnU6QNVRdvlngC?=
 =?us-ascii?Q?dCAc4RLiM5PVCllPPG7QGQ0WCDmryPZSMd6jfPB5bV3WZtsQ3KxliOiDHPQL?=
 =?us-ascii?Q?Ow0aZnKlKkA83l5OyupOFr3Bh7Sm6vk8yhkHXNduaBbKGccXRkM+MewYd1Pn?=
 =?us-ascii?Q?WULQ8KczZ8hnVAZwVtj0oik9THywQd/V+KCtFVr1IuPoToQ3NyiohifofN7Q?=
 =?us-ascii?Q?hU9m3hU1FEughNCg0KTxA/YqvTHalz3oYssbi6t6crAwKKubtKXIln/plVe9?=
 =?us-ascii?Q?CnQbsxtvviEE5SzxBVFyV3Cm3F6Vw1ZjHIlGiexXrrvUvI/nSSVFHU0Xh+xB?=
 =?us-ascii?Q?1Cj+LrD5EnRzAgDF1o9ySDdFZc4gXgHsqxYXGrP0kb5iVezcKlfLHTUCfaHy?=
 =?us-ascii?Q?tRoDax07KFAEkGX9icXubFA3utn6m/uWPVo64IQhHAgSIgR4s4mv79NGdv6A?=
 =?us-ascii?Q?SXBTTAaXpSUtIfO+eGfTcbfwyNsQZ5uLck0uT+I7XdO3KcfZEppGm5TvyUH3?=
 =?us-ascii?Q?kCC59zSM7Ye9IBDo7j9D9Jq4IOzG1zri5eIoBZwO4C8SsV/cZ4se7ldoY8ie?=
 =?us-ascii?Q?VTxKeX5bUiN3okRJZmgUwiJou19WjB8ml5Abi6f520yAvPhrYU6V3D3ZLn5+?=
 =?us-ascii?Q?2jBAYkVUJEh0VeIfMNCT5u2lABeTMFe4/yKs3pCh7ZwGQgV5eQP5Fwbw6kSh?=
 =?us-ascii?Q?jiu2rFwLm6fUrILCu0LkZWzW5n9uelntJxjGvCfLUXnCleFqbrO6s4UuO9ak?=
 =?us-ascii?Q?WO2UGBDUy4CNo9qDeNlO+3JrGeGRuPeXfu5zn7a8NTyCpg54VjTWzsDpVsSj?=
 =?us-ascii?Q?mYhXtnaTSsMAvzwI3Xm2VyeRtBcJAC3PGboA1zFZODHur5vF7XtP/m1GEJka?=
 =?us-ascii?Q?eHXu51m6/vQcMAVD5GtqDLAdVb4h5lyOAlDEez6vnU9Z8UMDkl6svBHLRXn8?=
 =?us-ascii?Q?8EcDeO5XqOvrJrTBCx0c89Ji1a8dbR6FzITSNub2rvAL1SIw57/hMt2k9orc?=
 =?us-ascii?Q?DQfvxaa1VwcHPzHYyM4vza5jfyjDefMGH4QycqUDQHQ/lFNn/Otd83pmbosA?=
 =?us-ascii?Q?9YPCkP2l1m6W1ArrMknaC+6tCemQX97ziOtdyCkrpvL9Ct0XaC91wbLH0aPL?=
 =?us-ascii?Q?mHotfmqrHQdVuo10tpKCL2OvQx1srvu13ZwycX2sBwd/4uJyfUnresolr0/u?=
 =?us-ascii?Q?RReZnrEj5vubbH03AZtqtlJ4DgPSMGC8VmbBGTzmFvTn/Re7Q9p0JCIEDGc5?=
 =?us-ascii?Q?G5UM4tPstCe+SOhblpWSDE9h+3UaJ1Gr6iA6t5Hb?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f2bb1b9e-02d0-4a9b-8ea0-08ddf86d05fd
X-MS-Exchange-CrossTenant-AuthSource: IA4PR11MB9131.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2025 17:42:09.4136
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E8doMcRb/y5JEpI12Yf1foLUchnXLQccWz/HPrnDBoZFBdk0o/WnKPtYy+Wa9+Yuz02NDLYZhKaUvFFob5a6pA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB7400
X-OriginatorOrg: intel.com

Dave Jiang wrote:

[snip]

> > @@ -998,9 +998,8 @@ static int init_labels(struct nd_mapping *nd_mapping, int num_labels)
> >  		label_ent = kzalloc(sizeof(*label_ent), GFP_KERNEL);
> >  		if (!label_ent)
> >  			return -ENOMEM;
> > -		mutex_lock(&nd_mapping->lock);
> > +		guard(mutex)(&nd_mapping->lock);
> >  		list_add_tail(&label_ent->list, &nd_mapping->labels);
> > -		mutex_unlock(&nd_mapping->lock);
> 
> I would not mix and match old and new locking flow in a function. If you are going to convert, then do the whole function. I think earlier in this function you may need a scoped_guard() call.
> 

FWIW I would limit the changes to __pmem_label_update() because that is
the function which benefits from these changes.

> >  	}
> >  
> >  	if (ndd->ns_current == -1 || ndd->ns_next == -1)
> > @@ -1039,7 +1038,7 @@ static int del_labels(struct nd_mapping *nd_mapping, uuid_t *uuid)
> >  	if (!preamble_next(ndd, &nsindex, &free, &nslot))
> >  		return 0;
> >  
> > -	mutex_lock(&nd_mapping->lock);
> > +	guard(mutex)(&nd_mapping->lock);
> 
> So this change now includes nd_label_write_index() in the lock context as well compare to the old code. So either you should use a scoped_guard() or create a helper function and move the block of code being locked to the helper function with guard() to avoid changing the original code flow.
> 

Sure you could do this but again I don't think these updates are worth
this amount of work right now.

Ira

> DJ
> 
> >  	list_for_each_entry_safe(label_ent, e, &nd_mapping->labels, list) {
> >  		struct nd_namespace_label *nd_label = label_ent->label;
> >  
> > @@ -1061,7 +1060,6 @@ static int del_labels(struct nd_mapping *nd_mapping, uuid_t *uuid)
> >  		nd_mapping_free_labels(nd_mapping);
> >  		dev_dbg(ndd->dev, "no more active labels\n");
> >  	}
> > -	mutex_unlock(&nd_mapping->lock);
> >  
> >  	return nd_label_write_index(ndd, ndd->ns_next,
> >  			nd_inc_seq(__le32_to_cpu(nsindex->seq)), 0);
> 
> 



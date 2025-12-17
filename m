Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 056622749CB
	for <nvdimm@lists.linux.dev>; Wed, 17 Dec 2025 03:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765941294; cv=fail; b=ok4peWVw0OMM9+h+dsbma/0xWkGjjF7jI3aAXyXI18d0auOQTQNDHq87KmOXxF1tHmrnuWqQgs8JjpDp0c26VtNjcyW9nKf4ZJasDl2u4FQrMAWoFkOVfR8sGZzlg2ZlsNwFIOim0Ik9apSemjXiQ5HdyVYYauFpYTrDQnkwrwc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765941294; c=relaxed/simple;
	bh=NlQZ2YgFZJ4/CG5tIZu6dbTlOvsfQ+okal9hHKCVelE=;
	h=From:Date:To:CC:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=tW7Pii317qNBr0Z8TcyHIuQYdZdzWQvd84pg3NN/lLG7Z26T6mu3F8MLiGu6L95sIQ3sL/nEufUhMKdaRtVQb0aEiXreWmMfHx/gdd+3R+WGFDCgoHYfIwVKUaFVBHCkOX7OVrOnddBZbgzqKATdodKcFpf86tXtPBm0nQRS13o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QT5X/otg; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QT5X/otg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765941294; x=1797477294;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=NlQZ2YgFZJ4/CG5tIZu6dbTlOvsfQ+okal9hHKCVelE=;
  b=QT5X/otgbncycHe/T0x2Fr0Q4AjP1ZFJP1QYEkATm3YuDh04sV07MgIs
   4VBQX/uF5nW+Xo7gq5ii+E/Ka9nvY9Qoqy3nzDWJAxbQAhWjhBChPi+xr
   yuzzmDw0um7xkY/SwwUGdvYfnfsXrSXRhXTnetFT16boqhakCv/UMXhGH
   BZxgNA+yAqdlmq6gvvWy1oxpZQk0nRO3ebTIIZNYGjxEpCy1mV2YISkli
   RAMRBtTGAZPcT+j71IKna/9mVncmdiQxTnczH7aU223XJ0Hkdlr0x0+/+
   EffVqumttAISSTJLDl/fPCtPiwcvhBBnV/PDblKq0R/CtHh3TLTUEZ6Du
   A==;
X-CSE-ConnectionGUID: dvYsEILJSfWqjigXR97ulg==
X-CSE-MsgGUID: ujA3YeIJTTeuRhrVtX1MBg==
X-IronPort-AV: E=McAfee;i="6800,10657,11644"; a="67913460"
X-IronPort-AV: E=Sophos;i="6.21,154,1763452800"; 
   d="scan'208";a="67913460"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2025 19:14:53 -0800
X-CSE-ConnectionGUID: /FKlmCMNScKFPrWYlkJ2yg==
X-CSE-MsgGUID: FQv/+02SRJqPkX/k2Tbytw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,154,1763452800"; 
   d="scan'208";a="198246904"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2025 19:14:46 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 16 Dec 2025 19:14:41 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 16 Dec 2025 19:14:41 -0800
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.56) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 16 Dec 2025 19:14:40 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UiC/nsfync4zav4D4a8v3xoW6A+Se+dfV9zxWO5pHz60WrubXhX+aODkTSTA3wOEjjA79pUEc4WQ/JuqwZvgM91D+jffNLY8g/EUtzbzgImOqVkhOSeBqGc1zer86XHaRoQ7xO3r2oFSTw9AJ+3I7cPAmYgRFc3dyS4A4y0y2L0aqOpwA5lC0N0xW6/xZjy4s6C5JvyohW6B2/Qz37sO+QFcuhGkEKKjV8NXgr+0hZOgvuZZ0dGWcah0kj5CxpWA06Qe0dYeeq2pwR6T5/5SMGnb/20eGOyuFDdw7D3p8oYrw3w1SCUo8VDV9JHbKlUApl7XmOgGOx2RuDyQB1qTBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LCoKve/oHpztjpvmVgnCQVeH64WX0de7kcPdDGPf/1E=;
 b=agIhlKh9ugularQxnwjtLeNCU6ReE4/fzM82aOISpkEkRmBZvCdO5PYY1gEY9SUXUHSgDJPmbbNGQjowqR7r/E7V/IL5BrmuVv7Pg+Bv/7KILwivt2dO8znjyoBbp0Uj23GVvNDfPDk2DqCjrtl5eNrkl96FPhyuqATaYG6ZYSu4wStB46EPPJSTDmjPqAfc6dIl+rXos5Hf/UKjo5+JJnF6s4jDjaFC0iGPBSJo/Rq9JbVcU21npHc5unbHSkHWVt2CkpoDMQRAmzoz7uF5z01VLbWHooW6onKoxtJWB1P3IvKAJDjnSo2yr3BACtdhRvHVC91x4yZHwNZ6xCR3mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by SN7PR11MB7140.namprd11.prod.outlook.com (2603:10b6:806:2a3::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.13; Wed, 17 Dec
 2025 03:14:34 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff%4]) with mapi id 15.20.9412.011; Wed, 17 Dec 2025
 03:14:33 +0000
From: <dan.j.williams@intel.com>
Date: Tue, 16 Dec 2025 19:14:32 -0800
To: =?UTF-8?B?TWljaGHFgiBDxYJhcGnFhHNraQ==?= <mclapinski@google.com>,
	<dan.j.williams@intel.com>
CC: Mike Rapoport <rppt@kernel.org>, Ira Weiny <ira.weiny@intel.com>, "Dave
 Jiang" <dave.jiang@intel.com>, Vishal Verma <vishal.l.verma@intel.com>,
	<jane.chu@oracle.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, "Tyler
 Hicks" <code@tyhicks.com>, <linux-kernel@vger.kernel.org>,
	<nvdimm@lists.linux.dev>
Message-ID: <6942201839852_1cee10044@dwillia2-mobl4.notmuch>
In-Reply-To: <CAAi7L5cpkYrf5KjKdX0tsRS2Q=3B_6NZ4urNG6EfjNYADqhYSA@mail.gmail.com>
References: <20250826080430.1952982-1-rppt@kernel.org>
 <20250826080430.1952982-2-rppt@kernel.org>
 <68b0f8a31a2b8_293b3294ae@iweiny-mobl.notmuch>
 <aLFdVX4eXrDnDD25@kernel.org>
 <CAAi7L5eWB33dKTuNQ26Dtna9fq2ihiVCP_4NoTFjmFFrJzWtGQ@mail.gmail.com>
 <68d3465541f82_105201005@dwillia2-mobl4.notmuch>
 <CAAi7L5esz-vxbbP-4ay-cCfc1osXLkvGDx5thijuBXFBQNwiug@mail.gmail.com>
 <68d6df3f410de_1052010059@dwillia2-mobl4.notmuch>
 <CAAi7L5dWpzfodg3J4QqGP564qDnLmqPCKHJ-1BTmzwMUhz6rLg@mail.gmail.com>
 <68ddab118dcd4_1fa21007f@dwillia2-mobl4.notmuch>
 <CAAi7L5cpkYrf5KjKdX0tsRS2Q=3B_6NZ4urNG6EfjNYADqhYSA@mail.gmail.com>
Subject: Re: [PATCH 1/1] nvdimm: allow exposing RAM carveouts as NVDIMM DIMM
 devices
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: SJ0P220CA0023.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:41b::21) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|SN7PR11MB7140:EE_
X-MS-Office365-Filtering-Correlation-Id: 95bb3f19-8e2f-42e5-23c8-08de3d1a6694
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?NG5PZEpjQVdLdkNkZHJZYnY4SG1BRnJrcEphMzBhKzVRaUdxY2FmUDRYRUsw?=
 =?utf-8?B?Rk13bXJodUVaMjVrenVMQmc4cU5tQ1VxblczNGtIS1JGa1lKYnF5bEZUOGJQ?=
 =?utf-8?B?YmVkYU05dzhJZ0pTZFZndjcrcHl3LzZZb0ljWkZiY29yamgxNGRjZkxsckJM?=
 =?utf-8?B?aEp5ZVF2SFlUMkt6R1hBTVZ4ZlNRcG5kZnE2MXZMYXVwdThDQ05TWFMwV2Jo?=
 =?utf-8?B?WE1MWjhsYUVIbnZWa2lGMkhCakJ2UXdad3NLY1NyZjNXY3ZZM21kL1lnZWNL?=
 =?utf-8?B?SHl5KzlqSytMYUxqUXV5c1ZrV29NTm9SSnkzRjJNdkwrOXhKcU9PTStjSmNq?=
 =?utf-8?B?Um5nR3pjNDZkZDRIMEdUYzVhUGlUd3c4M2JoL2lrSWh1dzlGRmkySnVOM2h3?=
 =?utf-8?B?aFNabm5tWlNvem04c0tIR1NLd2dGT0JUR1hWd21ZZHF2d3dFeml4QWROWHhi?=
 =?utf-8?B?cUNGdU1TcHphVnNjelJvbjYwaWVLbGhnU1BLWEJBMEhIMmpxeWdmUWdsaWRu?=
 =?utf-8?B?c2tla2ZGbW9rM0UvU05sdHQ1bGh5bkdRVER0VjY5VXNSUVU0R2RXVkpjeWZP?=
 =?utf-8?B?aXcwSnBFeTdyMlJDTHFJbU9zK3BzYVh0S05KY2t6YzFSV05pdG1DUjVKaVcv?=
 =?utf-8?B?Q1Zacm16T25EbUJvK20yOWFaczhzcnFMbHU2Q2FISWdJTlpzbk9KNkZjRWVt?=
 =?utf-8?B?Qzl3dytsY2FMcGliOWpUa1J4MFl3KzhvUXRKbXQzYmNPU3ZFa2d1dFhld2x0?=
 =?utf-8?B?czJ3OFF6NWVMbzRsR0Qra1B2THFCUVl6N2d0V0dWS21Hcm13ZytvUUVLb1Y3?=
 =?utf-8?B?YUh0ZHk0aDBpelhqbHpxQUVkRFpPcUF6eFpvaVUwUmlUN0V1MDF5U05ON2Nj?=
 =?utf-8?B?VnhuRlRvWG5RZzMxK2N2YXo3SmdKb2Q0UUlTQmd2NzZOK3pSVjZLL3Y3c3ZL?=
 =?utf-8?B?RDdJaElEd055NDN3T1hoMFFWWGdmdEdFWTBsajVaVE1vSjcrM0tvTEZHYUxk?=
 =?utf-8?B?WFdnMVl2N3ArQi9Zamt2TDlndmxMMDJ1NW1lWUFHNXZyZDlOM2dYQStwK0NM?=
 =?utf-8?B?NE5Xai80djJDS2I1Kzc5c3ZXcE1qd0ZYL05BSEJTTitKYy9pZFFjanJ2S1p5?=
 =?utf-8?B?M0hNcGIvTFBTd28reUNaOWxiUkpJQmdZZ1RMN1Jhc1BVbTVOeFhtQ2pmL2FS?=
 =?utf-8?B?bTJqejNjN1U1eGFSeEc4bjF5ZGdFQzVkWk85aTJIMWdNZkhHSWxMem5BN0hW?=
 =?utf-8?B?eEM1QjYxTHcxRHk5R0Y0cnJvdzZ5di9YZHlOdWcwMFI1MitkTzMwcitHVkVB?=
 =?utf-8?B?UFMzYkNmcUdvQUZBT21WWmhaVFF4S3ZSd1A1MSthQ0pGczFyajN4dUlyV3ow?=
 =?utf-8?B?aFVMbGR6dVVWcHU0dklTem1DdTVGQ2M0Wm9RSHhxbkNkV2pIMjdjNS9FUlQ4?=
 =?utf-8?B?UVRGZDFYZFZjWkxvYkVXT0hNcUwvVmF3d1BBNzZ1MlJZL0tCVlJCZloydW5E?=
 =?utf-8?B?V2N6QVcyMTNHR2doWG1pcGFBeHVKNE9oL2xYeGdDUHhZdURKNTE3MEFHT0FU?=
 =?utf-8?B?MTRRb3VDSnJ6RVA1T0diSkdvdTVMSTdEMWszZkY2R0tKeEdZWmlnUkJ2ZVl1?=
 =?utf-8?B?dlRoNzE5MW0zdkhQbjI3S25NZGpoNmk5YkIyUWdrUjJzUTY4NUVkT3Q4U29W?=
 =?utf-8?B?WEkwTm9uZzdmL1haamhsbWVEZmFWRnY0d3dWdkd6TVZBVTBrL2p3MXFlNUNh?=
 =?utf-8?B?Q3lmUVNQUm5hQStmZkxTTlk5aU51NUUxOVg0YzlSOFZONis3ZGJlRVNSaEcy?=
 =?utf-8?B?WE02eWJPUmZiQU1GUWw2VnQrTTJuQmtPZGFvK282T1NyVjExWGFMVVk1MUEy?=
 =?utf-8?B?MERsNnFQL1h4OGViWkxxQjRXdGduUWZlcGl3SUtpdXc0M1A1T0ZLRjhwYzUv?=
 =?utf-8?Q?AOzEVRAeUqPCzYnKHM8kScITgeUWKAJt?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d2tIQlJEZ0hwemtacGF5c2VmRXVoVUV6WEpGcHBORWpScS9rT0tFTjllRGZJ?=
 =?utf-8?B?YkYyUFVuVjBYZW9YQlJ1YjJjM0RXYmZtZVgxS01saHNqMXArV1dJRjA4alJQ?=
 =?utf-8?B?VW53Ti9GZ0NYT2tyT05LSDZxcm9RSjNpeXYvT2toZnovbVAySnRzbytoc3ky?=
 =?utf-8?B?bXBwZnkxbzNKYlNHREtjcHVlbGpOS1BuMVdVSGRVNjBlc1NHemNjMVJ6MlMz?=
 =?utf-8?B?RW5vZ0pjNmh5cmlKQ0ttMEwvNkFpdzBXdVVNdXkxeTA4OVdxZ0ZIQ2Q0UG1H?=
 =?utf-8?B?SWVycmdncUlQTjVqUHdCRFpqWjVDOVl1dWVpRzJvWmdoeTA2OFROOXk0NU9z?=
 =?utf-8?B?TEswWXVEOVJGMHhkbGhZaitsSzBwWVRBNVZPekVCWnhqcDhOYUpSWDhDcTEx?=
 =?utf-8?B?YnM3Y2pkczJ3Q2RVWEYvUW1iOUQ4akRxMzNOYzhIdW1QTU5aWWFmdG1TVGQx?=
 =?utf-8?B?d3hUenlJNXJWbGFyTExFR216TG81NmoyclZGN0xpcnRJa1d2UjVVTU53Wmkx?=
 =?utf-8?B?bTE1Qk5LR3lXc0xQRU5FSlpWNEJUVXNjU2dkNGhMUHZhajd0TXNwRHRIOG9r?=
 =?utf-8?B?VXIydWNsMXBDOENWc3ppS3lZdUs4b3JpY01YSEM1c09aWU1ZOG9FeXBnTzZ0?=
 =?utf-8?B?b2xWKzR1MzF6bGtEd25lN3dWTmJHODEvSXZlZWl2dzVkbFNYMVg2S2d2U3VP?=
 =?utf-8?B?Uzc1Rml6bENYeHhVdTZJVjRtanM4aTlPbDJaRzQ1S3d4bXJva09xc0dhZTM3?=
 =?utf-8?B?TFQwRDRDeFVzMmJNcDhNYkNZd01oR0ZOTGdqd3ROcUZpY2tMUTc1Z0tJUW9C?=
 =?utf-8?B?WFFPWHd5dlpiZFJSSkw0T1NTSUZ0Sk04b2Y1WDhrU29wOThPbWNkS2lPSkdL?=
 =?utf-8?B?Y1d6VEZLWExoK2swa21EUVVEVzY2VWIwWGR5cmE4dUh1Sng2elQ5SC80cFpH?=
 =?utf-8?B?MkhucWxtTWlJQmZhZnNsTHlxSHlacUZLVVRrTU0zSnhUQTdtQkNDUHd1NG5T?=
 =?utf-8?B?bmFLNWZnVEpSTTJ2MVRyRWNoY3pTMWFCcDFCdG1YSlduQi8vayt5a21wYmQx?=
 =?utf-8?B?eXpBS1JYNFQ3TWFpbERkTHpuekQwL3FWVGZjUFg1YUJpbVk1eTBDdjE3M3Z4?=
 =?utf-8?B?d0RsZkpyRE9haS9BbUhlbXRCbnpGbFA1Wmh2QXlpU05ncU1jTWgwNGxJbFZj?=
 =?utf-8?B?RW9NUlQrMjlXbHRsQmRkV2VuR21PWWp5WTFBWW55N1JXWnQ4TkhkSnJ4R0FF?=
 =?utf-8?B?QUFKZms4SktnVDR6SkJmQzBnckViRnFJeEhQYjhDVXE3U3RKTTJ3RS82OTZE?=
 =?utf-8?B?Y0xlaDFLZXY0T1kremVCc3l6MXBTSCtQaXpGMmIrN1UwV1liVmNocVJHUVlw?=
 =?utf-8?B?SEM4bXhKTnJTMW80bTBoN1dGM1djYU81RjZDUTVVZG5udmhEaEZiV2pCbVpv?=
 =?utf-8?B?dC8vYlduYWRXQjJnYTFVRkRZUjdZZE1VWnhXQUM5S3NjOWFnVzF4dFJuditP?=
 =?utf-8?B?ZlArSDhwVlJpVHpmUzhsa28vYnVVbFJibndITFcyNnBhNFNhMXMrT3BFa3hu?=
 =?utf-8?B?VFMzWkRObEtKY3gyMDc2Mno2VXBEckJGRWFtN2ladkc3OE5BWGU1UGZiR0tU?=
 =?utf-8?B?MFgxSkFDSlkraGpMT0JtRWxPUXRkV3VzMUdRZ3pTZ3ZQU2RBcXRXd3EyUXZj?=
 =?utf-8?B?VFRtb2JadElXc09STVE1d3BaelE5MGltYUp5WkI1aEtCR3RXTDY4Nmp1SENz?=
 =?utf-8?B?TjZIeDlvTDdDNVJtWGNxLzgwYVJJQTAzQ2JWUjNDaDNITkErbzViK3BhNjhB?=
 =?utf-8?B?MUNRV2haVTg2eTRZdDdrRjFIUDMvWUI1dXJKUnRJeXpad3ExL0wyeEw1Vk9t?=
 =?utf-8?B?WTdtVUZSZVVDd0pja0pnSlNTODBKSHVvUVIrc3RaQkVzME1LMzUySGxmbjBC?=
 =?utf-8?B?VXZON2dCSzUwWUpSbWxNT0xldjRvaEtPUEtVcno2TE12RElpY1dMWGt4UUo0?=
 =?utf-8?B?NFFOTmk0WEFFRXREbXFjdUg3VXNWdXZyNTRXMXlmVVd5blY0d3pqYjlQMVB3?=
 =?utf-8?B?R0FRVWhyK3liaE9XRWd3dDl3Sk9yaHNzS3BvVzQ3STU2K2huOXY1S1ZnWHJR?=
 =?utf-8?B?ektXZVk1MEU2cEI4amp0dXkzazlyczEzUitKY0lHR2l0eGZMWENsWEZEcVRm?=
 =?utf-8?B?NEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 95bb3f19-8e2f-42e5-23c8-08de3d1a6694
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2025 03:14:33.5768
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NdOtfXdjFnmkohm/po86WAVn/LSc74v9li4duDru+dThR+1NcbYIdWUw0mVHYWBPHAvNjSJOYjvTHYIBWgQ/ZiL5jKQiLS/vSTgMaK/tu6s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7140
X-OriginatorOrg: intel.com

Micha=C5=82 C=C5=82api=C5=84ski wrote:
[..]
> > Sure, then make it 1280K of label space. There's no practical limit in
> > the implementation.
>=20
> Hi Dan,
> I just had the time to try this out. So I modified the code to
> increase the label space to 2M and I was able to create the
> namespaces. It put the metadata in volatile memory.
>=20
> But the infoblocks are still within the namespaces, right? If I try to
> create a 3G namespace with alignment set to 1G, its actual usable size
> is 2G. So I can't divide the whole pmem into 1G devices with 1G
> alignment.

Ugh, yes, I failed to predict that outcome.

> If I modify the code to remove the infoblocks, the namespace mode
> won't be persistent, right? In my solution I get that information from
> the kernel command line, so I don't need the infoblocks.

So, I dislike the command line option ABI expansion proposal enough to
invest some time to find an alternative. One observation is that the
label is able to indicate the namespace mode independent of an
info-block. The info-block is only really needed when deciding whether
and how much space to reserve to allocate 'struct page' metadata.

-- 8< --
From 4f44cbb6e3bd4cac9481bdd4caf28975a4f1e471 Mon Sep 17 00:00:00 2001
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 15 Dec 2025 17:10:04 -0800
Subject: [PATCH] nvdimm: Allow fsdax and devdax namespace modes without
 info-blocks
MIME-Version: 1.0
Content-Type: text/plain; charset=3DUTF-8
Content-Transfer-Encoding: 8bit

Micha=C5=82 reports that the new ramdax facility does not meet his needs wh=
ich
is to carve large reservations of memory into multiple 1GB aligned
namespaces/volumes. While ramdax solves the problem of in-memory
description of the volume layout, the nvdimm "infoblocks" eat capacity and
destroy alignment properties.

The infoblock serves 2 purposes, it indicates whether the namespace should
operate in fsdax or devdax mode, Micha=C5=82 needs this, and it optionally
reserves namespace capacity for storing 'struct page' metadata, Micha=C5=82=
 does
not need this. It turns out the mode information is already recorded in the
namespace label, and if no reservation is needed for 'struct page' metadata
then infoblock settings can just be hard coded.

Introduce a new ND_REGION_VIRT_INFOBLOCK flag for ramdax to indicate that
all infoblocks be synthesized and not consume any capacity from the
namespace.

With that ramdax can create a full sized namespace:

$ ndctl create-namespace -r region0 -s 1G -a 1G -M mem
{
  "dev":"namespace0.0",
  "mode":"fsdax",
  "map":"mem",
  "size":"1024.00 MiB (1073.74 MB)",
  "uuid":"c48c4991-86af-4de1-8c7c-8919358df1f9",
  "sector_size":512,
  "align":1073741824,
  "blockdev":"pmem0"
}

Note that the uuid is not persisted so the "raw_uuid" in the label will be
the method to identify the namespace:

<after disable/enable region>
$ ndctl list -vu
{
  "dev":"namespace0.0",
  "mode":"fsdax",
  "map":"mem",
  "size":"1024.00 MiB (1073.74 MB)",
  "uuid":"00000000-0000-0000-0000-000000000000",
  "raw_uuid":"1526a1df-d1ec-40e3-91e8-547f1ad9949d",
  "sector_size":512,
  "align":1073741824,
  "blockdev":"pmem0",
  "numa_node":0,
  "target_node":0
}

Also note that the align is hard coded to (PUD) 1G. That is probably fine
for now unless and until someone comes up with a case for making that
setting configurable.

Lastly, the kernel will complain if "-a 1G -M mem" are not specified to
"ndctl create-namespace" as the kernel still enforces that that live
settings specified at configuration time match the "virtual" infoblock.

Cc: Micha=C5=82 C=C5=82api=C5=84ski" <mclapinski@google.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 include/linux/libnvdimm.h |  3 ++
 drivers/nvdimm/pfn_devs.c | 58 +++++++++++++++++++++++++++++++++++++--
 drivers/nvdimm/ramdax.c   |  1 +
 3 files changed, 60 insertions(+), 2 deletions(-)

diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index 28f086c4a187..c79efc49dd24 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -70,6 +70,9 @@ enum {
 	/* Region was created by CXL subsystem */
 	ND_REGION_CXL =3D 4,
=20
+	/* Virtual info-block mode (no writeback / storage reservation) */
+	ND_REGION_VIRT_INFOBLOCK =3D 5,
+
 	/* mark newly adjusted resources as requiring a label update */
 	DPA_RESOURCE_ADJUSTED =3D 1 << 0,
 };
diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
index 42b172fc5576..68a998fe20a7 100644
--- a/drivers/nvdimm/pfn_devs.c
+++ b/drivers/nvdimm/pfn_devs.c
@@ -428,6 +428,50 @@ static bool nd_supported_alignment(unsigned long align=
)
 	return false;
 }
=20
+static int nd_pfn_virt_init(struct nd_pfn *nd_pfn, const char *sig)
+{
+	struct nd_pfn_sb *pfn_sb =3D nd_pfn->pfn_sb;
+	struct nd_namespace_common *ndns =3D nd_pfn->ndns;
+
+	switch (ndns->claim_class) {
+	case NVDIMM_CCLASS_PFN:
+		if (memcmp(sig, PFN_SIG, PFN_SIG_LEN) !=3D 0)
+			return -ENODEV;
+		break;
+	case NVDIMM_CCLASS_DAX:
+		if (memcmp(sig, DAX_SIG, PFN_SIG_LEN) !=3D 0)
+			return -ENODEV;
+		break;
+	default:
+		return -ENODEV;
+	}
+
+	*pfn_sb =3D (struct nd_pfn_sb) {
+		.version_major =3D cpu_to_le16(1),
+		.version_minor =3D cpu_to_le16(4),
+		.mode =3D cpu_to_le32(PFN_MODE_RAM),
+		.align =3D cpu_to_le32(HPAGE_PUD_SIZE),
+		.page_size =3D cpu_to_le32(PAGE_SIZE),
+		.page_struct_size =3D cpu_to_le16(sizeof(struct page)),
+	};
+	memcpy(pfn_sb->signature, sig, PFN_SIG_LEN);
+
+	/*
+	 * Virtual infoblock uuids do not persist, but match the live setting in
+	 * the validation case. The @align and @mode settings are fixed for the
+	 * virtual case, validation will enforce that they match.
+	 */
+	if (nd_pfn->uuid)
+		memcpy(pfn_sb->uuid, nd_pfn->uuid, 16);
+	memcpy(pfn_sb->parent_uuid, nd_dev_to_uuid(&ndns->dev), 16);
+	pfn_sb->checksum =3D cpu_to_le64(nd_sb_checksum((struct nd_gen_sb *) pfn_=
sb));
+
+	dev_dbg(&nd_pfn->dev, "virtual %s infoblock for %s\n", sig,
+		dev_name(&ndns->dev));
+
+	return 0;
+}
+
 /**
  * nd_pfn_validate - read and validate info-block
  * @nd_pfn: fsdax namespace runtime state / properties
@@ -448,6 +492,7 @@ int nd_pfn_validate(struct nd_pfn *nd_pfn, const char *=
sig)
 	struct nd_pfn_sb *pfn_sb =3D nd_pfn->pfn_sb;
 	struct nd_namespace_common *ndns =3D nd_pfn->ndns;
 	const uuid_t *parent_uuid =3D nd_dev_to_uuid(&ndns->dev);
+	struct nd_region *nd_region =3D to_nd_region(ndns->dev.parent);
=20
 	if (!pfn_sb || !ndns)
 		return -ENODEV;
@@ -455,8 +500,14 @@ int nd_pfn_validate(struct nd_pfn *nd_pfn, const char =
*sig)
 	if (!is_memory(nd_pfn->dev.parent))
 		return -ENODEV;
=20
-	if (nvdimm_read_bytes(ndns, SZ_4K, pfn_sb, sizeof(*pfn_sb), 0))
+	if (test_bit(ND_REGION_VIRT_INFOBLOCK, &nd_region->flags)) {
+		int rc =3D nd_pfn_virt_init(nd_pfn, sig);
+
+		if (rc)
+			return rc;
+	} else if (nvdimm_read_bytes(ndns, SZ_4K, pfn_sb, sizeof(*pfn_sb), 0)) {
 		return -ENXIO;
+	}
=20
 	if (memcmp(pfn_sb->signature, sig, PFN_SIG_LEN) !=3D 0)
 		return -ENODEV;
@@ -694,7 +745,10 @@ static int __nvdimm_setup_pfn(struct nd_pfn *nd_pfn, s=
truct dev_pagemap *pgmap)
 	};
 	pgmap->nr_range =3D 1;
 	if (nd_pfn->mode =3D=3D PFN_MODE_RAM) {
-		if (offset < reserve)
+		struct nd_region *nd_region =3D to_nd_region(ndns->dev.parent);
+
+		if (!test_bit(ND_REGION_VIRT_INFOBLOCK, &nd_region->flags) &&
+		    offset < reserve)
 			return -EINVAL;
 		nd_pfn->npfns =3D le64_to_cpu(pfn_sb->npfns);
 	} else if (nd_pfn->mode =3D=3D PFN_MODE_PMEM) {
diff --git a/drivers/nvdimm/ramdax.c b/drivers/nvdimm/ramdax.c
index 954cb7919807..992346390086 100644
--- a/drivers/nvdimm/ramdax.c
+++ b/drivers/nvdimm/ramdax.c
@@ -60,6 +60,7 @@ static int ramdax_register_region(struct resource *res,
 	ndr_desc.num_mappings =3D 1;
 	ndr_desc.mapping =3D &mapping;
 	ndr_desc.nd_set =3D nd_set;
+	set_bit(ND_REGION_VIRT_INFOBLOCK, &ndr_desc.flags);
=20
 	if (!nvdimm_pmem_region_create(nvdimm_bus, &ndr_desc))
 		goto err_free_nd_set;
--=20
2.51.1

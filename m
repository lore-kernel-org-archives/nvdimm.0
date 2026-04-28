Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F5A5149C7B
	for <nvdimm@lists.linux.dev>; Tue, 28 Apr 2026 04:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777351149; cv=fail; b=RIy3DS0sIwZhi/4wS6VVFMncLdtMqNcsyaenVaJIFwrOpKmOsrbgP4J8zZ9t8KyS3zBrVD4F40U3X7sOP6Pifr/RFHyRw6HWmau1hXSzYcJCrjSJKfNKHPglBf/nmlW1NAUYRtc8Lxq+DDwHAZVt/W9CNOw5XfNrmdsdmDaNQVs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777351149; c=relaxed/simple;
	bh=nOP5YnXKU8+NyGl2ENRgj98xjBiSvc+diQNbg//Pz4c=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=no6yqc6QnjkoIlTr7Qr6hHdEx2cHGRePtnrDEuvZu2vv5tTA8+jZfWsZbDFU3OVF1HKNwrHZ/7WG2hWba+BSET/hxuM79zllifeRFEWcDtqnQ020VgagSuRApnkrmHFCtGZyYfSpj5lD0v154s7jB4LKCZL0clboq4e2JSaIUi8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OkaPgz/z; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OkaPgz/z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777351147; x=1808887147;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=nOP5YnXKU8+NyGl2ENRgj98xjBiSvc+diQNbg//Pz4c=;
  b=OkaPgz/zZQ7ZBuvTOI3f44Qw+yiSCaasbNE2OlnnDEY3EZ3qSqUhB9Ft
   1Yje6Ubt+uwMcNUOVjGW+89TSRVk8wnw3lLmK3CBF1EVcqnNTOWV0Xe//
   rYvRU2Ofx4FTSk+Y8hTY/OWBAlNhH+iRVxdzr2Dy+1hwUGAbr2h4a6ECC
   ESiC2jBTWVlfQF0wWQoi39qz3ap88/XX8abY1kNCKzhCK1ugzqXb7HZ+G
   i7lxlHNlCkhvgyKI1R8FLmGw0NJMjgRCCASm89tzj2wn/wPo3pHvQhoVr
   IxiKQmfbsU/2tmdF0WvXpOWRYGh8yCkq8q4Ry6L150rMQUfBWcvz61v67
   Q==;
X-CSE-ConnectionGUID: zxvXhic5Sjy028GLIdB5Zw==
X-CSE-MsgGUID: FEeV0Yd7QDCMb8eHiqsuSA==
X-IronPort-AV: E=McAfee;i="6800,10657,11769"; a="95665146"
X-IronPort-AV: E=Sophos;i="6.23,203,1770624000"; 
   d="scan'208";a="95665146"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2026 21:39:07 -0700
X-CSE-ConnectionGUID: pZDpAjseQKChd6ZSCa8Jrw==
X-CSE-MsgGUID: GFEVpqweQVGVv0/j9Se+8g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,203,1770624000"; 
   d="scan'208";a="234120016"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2026 21:39:06 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 27 Apr 2026 21:39:05 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 27 Apr 2026 21:39:05 -0700
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.63) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 27 Apr 2026 21:39:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PALS493L9R9GN+Vj8kPA9wYQ5WiHth5en6KCTR9Yk5b8t+z5dMTr8i0Gk/YfrbCEtUYqLdn6FFLuXWaCnLnsLUPiWsLTg+CfJgDdcENU2lih/NJNBAtfDoAlDbUM/9EaTqbq3HsAZBXCjaXGx1jnyYODnHMrO1qZtjJvsTssEvS9HAkiysMPbpT0wUY8TXbl8HF9ZXopXDIrYHia64VbCNtDCHS9pY3op3e1jzfmmCiBr0d7/dYcHZyqIWjCVuTqGGmdgexQsWs89zlXUS30peKaX4LBA1NzidI1tE1KX6jiu4JBT+yYDP/lwudRJ0S3UDd4ZSRECZboIcXon1pjFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I9S3V1gyknBnjqINjgXHdXJPEbDqc0rDyyvijgZoQhU=;
 b=Lz/pOBRjFCbrQnFfTSL2xt1LCCeC0EEdCFaHONoQMwA0mSh27OjvtTfwW/+pExjkyiJbgPAQts2xa/JKvz27L1KuxlzWMFc9oKp5Rhf271RTPlae2/NKDk1crIwAkZZsvnXb5YJvdMR+1Ca9CGDXbDgfKgM9JXx4n153BNXbC1iX9ndcDLBdmaGzUCrowu1kt6X6jIIp+e6UFOZgnFoLthR5YrfxXhO06cOjXxklKkuhD3XkVMN9/+J/VKeQ/ZBX1unhSJ3YIIYzIb8YNDtQUpHbTS+0yGa2+x2nUilj2T46LDdZvI+Cm37vLkZf1p3IyUz09z6wKx8+ymU9FI58xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by SJ5PPF2F2B659FE.namprd11.prod.outlook.com (2603:10b6:a0f:fc02::81c) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.21; Tue, 28 Apr
 2026 04:38:57 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891%8]) with mapi id 15.20.9870.013; Tue, 28 Apr 2026
 04:38:57 +0000
Date: Mon, 27 Apr 2026 21:38:45 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: John Groves <John@groves.net>
CC: John Groves <john@jagalactic.com>, Miklos Szeredi <miklos@szeredi.hu>,
	"Dan Williams" <dan.j.williams@intel.com>, Bernd Schubert
	<bschubert@ddn.com>, "John Groves" <jgroves@micron.com>, John Groves
	<jgroves@fastmail.com>, "Jonathan Corbet" <corbet@lwn.net>, Vishal Verma
	<vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, Matthew Wilcox
	<willy@infradead.org>, Jan Kara <jack@suse.cz>, Alexander Viro
	<viro@zeniv.linux.org.uk>, David Hildenbrand <david@kernel.org>, Christian
 Brauner <brauner@kernel.org>, "Darrick J . Wong" <djwong@kernel.org>, Randy
 Dunlap <rdunlap@infradead.org>, Jeff Layton <jlayton@kernel.org>, Amir
 Goldstein <amir73il@gmail.com>, Jonathan Cameron
	<Jonathan.Cameron@huawei.com>, Stefan Hajnoczi <shajnocz@redhat.com>, "Joanne
 Koong" <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, "Bagas
 Sanjaya" <bagasdotme@gmail.com>, James Morse <james.morse@arm.com>, Fuad
 Tabba <tabba@google.com>, Sean Christopherson <seanjc@google.com>, Shivank
 Garg <shivankg@amd.com>, Ackerley Tng <ackerleytng@google.com>, Gregory Price
	<gourry@gourry.net>, Aravind Ramesh <arramesh@micron.com>, Ajay Joshi
	<ajayjoshi@micron.com>, "venkataravis@micron.com" <venkataravis@micron.com>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH V4 1/2] daxctl: Add support for famfs mode
Message-ID: <afA51WpcRyIMVukX@aschofie-mobl2.lan>
References: <0100019bd34040d9-0b6e9e4c-ecd4-464d-ab9d-88a251215442-000000@email.amazonses.com>
 <20260118223629.92852-1-john@jagalactic.com>
 <0100019bd340cdd5-89036a70-3ef5-4c34-abf8-07a3ea4d9f92-000000@email.amazonses.com>
 <aaD6yQLiyZznfAxr@aschofie-mobl2.lan>
 <ae6e9wYqgLkWsS-e@groves.net>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ae6e9wYqgLkWsS-e@groves.net>
X-ClientProxiedBy: SJ0PR05CA0081.namprd05.prod.outlook.com
 (2603:10b6:a03:332::26) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|SJ5PPF2F2B659FE:EE_
X-MS-Office365-Filtering-Correlation-Id: 0888dd05-960b-448a-17f2-08dea4e00f7c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: /rFex38DTk0VnJJJbTZKbt4BuIhPg/8cLeTcawfpqcIsJ5e/VnAt2i1gFP7zSGtoGnuWIg2kGZMB5Uu6lDQ4E+8PwlOvGoT/1nVP/ImReGqZzMKI8q0anyVr7v/iUfE58ZaQ9V16eNPL5ZqBPCikwB0++w1ftoL+zrS5DTbG8idz1F7utT8GknL/rzRcNfnjrk3Otn1FtVdDxcSS5CFTSHWvuhx6mCFmp4+s8l8lp1JnBqu55JcnND2XQQ4nhIlRenn8hpbLOm5QWwLVbwjsD9bdIHcMrEbTvKDtpdq4x9RbOPJkqqBU3KB/MxduISEgM0ByV0jLdYAO2ApQiBHKg0zeeeZwNXHZA4FwsHyqtR/LaTGURwcTz2FPyKaTW9xAa3NleYNX6mFHY4aDTtuvG0jLekbKdNY0dQdFA4wNGf1MNlSXJ/ql65f60BN/t66ZrkIZFMeryCi9ZxBX4uF7n313PtxyNPV79cCmZzRENXpv2sYezAZjjs74ZsK4njfrn8Y5Q3Fj8gxV9aiDJxZd3LVuhRa4etN4ysk7xnd+UhxoQNSNSo+aJ/7Fti+CG3uz289qpEJBPHzAj95ax8oqnfqTN8ZpNi/c2c9j5f+JYfHCh304vxORb5opjpoDVSBHPQlfgJhOagjq70e6X2cGagQfNSL55Vu94x5Qn344YISPXA9qjO7ikbh+rdFek3cF+DnIfc18v2NOV8jeEbbZuMSsRQYDDMxeiz3Dw5uaCs4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dXJwK1pFZS9FYlBRWEliaWdKektaTHpBQ3MreHhaV1hFMHJtVlh6RUxTcmZW?=
 =?utf-8?B?bXRtUWRHeXFNemJCTzNoRVZ4RlhQKy9EV0dIZ3RraFg2ZEhXZXdoQVREcnkz?=
 =?utf-8?B?bFdLNGE0amJOTzQ3bzFvMXI0VGF2RGVtTU84OWh2RHRFajlOeGNoYXUwRUxN?=
 =?utf-8?B?OXdtNUFkY3RWblRVS0JwY2dBWS9OdC93MkE0dWZiZEFQQWRFOHl3VEUzWXEy?=
 =?utf-8?B?UXhKaVVXOEEyUUxKZlcyYmVwd2pDZUtXRTZmeVJQMnVRRlZ5ZUppZExaaHVZ?=
 =?utf-8?B?M1Z6aGdyMmZxT3IvRmt4LzN6eHRkcXZ0Sm5oL1NLN2hGVm90dno4d3FnUFc5?=
 =?utf-8?B?WVIzVEczTVpoZDF4MUtHUi9tZVJ3bWhWbFMxRUpQQTZHNW0yVis2aFVEbFVw?=
 =?utf-8?B?ckJ2elJYczVZdkx5SHRNaHp2Skh5cUhyeGJWSzQ5K0VQQjluNFBGOHQzTXBy?=
 =?utf-8?B?cmJlYnM4QzRaVitiNEhIUEVSdHMxQmlEaWptalBGYk8wTjE4Ymt2UmxKVVdl?=
 =?utf-8?B?SU1kS0pHSlVoUkxzb2RDcXd6ZHRpc3ZOZFppeElCaHJiUjdWYnNKMm1iTjFR?=
 =?utf-8?B?bW1UMmUxWnJnenBOTDgydzEyK3ovclJ6WGgrN0pReVdQcWNPcnFEZGxQM0tO?=
 =?utf-8?B?WklNdDZTc1FDL0xVU2JoaGY4SFh1NFoyeGR3TFVQVmlKWVpSSjVKK1UwVmQr?=
 =?utf-8?B?WFY5cVhkdnNNVWhaQVlwQk1iZ2VNcUd1eWFpNnc5L3V5L1BmQUxKbFgwTy9p?=
 =?utf-8?B?QU45RjNQemdxd256TkY2cWgvT2FKU1ZiUXJySUZvVHdBQmg4eFNCNUtJTzNJ?=
 =?utf-8?B?QU5xU0RxV3ZieGM0UXZsMUhWeG9zRDJiK0pEaGVabytDQ3lIcnhEaVY0Um1u?=
 =?utf-8?B?a3VZL2wrQjJkNUpvcE1kNnU3eE9lVmp0TUFlY3J3cmZiQ3RNVDJNa2RIdGZm?=
 =?utf-8?B?Y0xaY0FBenhha0ZQQndMbGZINzVmZkRpdTRINzJFejZ1dU1WNXVUNW9wVEx0?=
 =?utf-8?B?Q1ZjbW43cDBpb2dhaFlZcHpKOFZyM0FJR3JHK3VSZjdOc0Fxa1dmNGhZWm1X?=
 =?utf-8?B?QzU2MjBBcUx6dGxSWnMrcGczbjNoRVZVVDdUV1BYM2hQSXd3b0tJNVhvZXlJ?=
 =?utf-8?B?QWxoRGFPMGxXdmZlZjBYcEo5T1ZMc1ltQ0huRm5FS1VLUzBjUnBzUEVsUGZI?=
 =?utf-8?B?bk81VEpFNVpYQUgrNWhxWWZoN1lnRVBRUXRFTnBhbWl6bjJ6eUV5MHA1ZTFJ?=
 =?utf-8?B?MnNaSTVjeXo5WWo0STRRQWo5UWw3NDlNTFNpaUVxTEJ2WjROVkJDSDR0Sm1M?=
 =?utf-8?B?by9yRGRVVEpZK2M4N0JYem9JdHpLZ3haRnk3VHZkazN3RDdEajl5NjVEZHRo?=
 =?utf-8?B?ZkxoRTJIbFlub0JDWHk3TThacjd5WnBNUWNTSEpQOEVVaHdJMk5QUkdZZ0lU?=
 =?utf-8?B?cTF4a3d3NWl5dmUvUnc2MzNYc3ljRml4K3F3MEFvTG9ySGptQnVMaENLajVx?=
 =?utf-8?B?Z0hNMTBUbFRsU1J0SDRycnBBYVpMOExkY2l5Y0FLS0xiNEU0aEEzQnFWV2J2?=
 =?utf-8?B?MDhiS1ZaYmdETUZrZVRaaDJYQWtNTFRkOVJsdWRyVUxrRlIzekN1MTR6bTMz?=
 =?utf-8?B?NnFabzFiYlNSSWRnNm91Ulo3YzhWb21nOHo5eGZHalowUlVPekJyMmY1WG56?=
 =?utf-8?B?dnNvYVFuclpXUUNhR3ZtTzc1dWNwckt2L2FPeGsxUjhKakxnbWMxaytWYmd6?=
 =?utf-8?B?cmxLQ0NsVnpHckx2VW9zdjRJR1d4YTdhMTB3NW9sMkhPd0s4djZ2TEdrRGdE?=
 =?utf-8?B?dXZuMC9TcUNmREMyVm44SDVJUGRqSHEzYjVTekZyeDhuY01wODlhTWFRM1hR?=
 =?utf-8?B?T0xvSlRoUXNqQUR1OTRua21HVU9PeVNseEt1TlBqcWdadTVEeHhwU3FZTUFU?=
 =?utf-8?B?UVdhUUR0VmF4V1R2MTNCRWQ1M2Vpclg4MXE4VFRjRzZOdzlkd2t6VjVLVkVM?=
 =?utf-8?B?MFBUSWRuZjdWU3NQamVIeFdLd2p1a2FGckhLL2NLU3ROSWFORTVhYkthbUFW?=
 =?utf-8?B?M1M0OE1Rb2ZseER4OWdwZTU1MlJpYUhYZUpuLy9RNDdHRVdWaENQQUxnc01O?=
 =?utf-8?B?V3VvNm83eWgvNExJdWZrU0k4TVNpY3R4ZDBNaDhaWUZ5TEJVQUhUQm9PdEIx?=
 =?utf-8?B?QU9MWG1HbE9WL3lJVHB2dVlJLzIxaEhiZzQrZTNweENCeldKWXRaQmE4WjhJ?=
 =?utf-8?B?b2t6czRmRFZ6OS9yRkNmdHpOMGNvQkN2YlNYUUJISzVWY2FKR1o1RFdwSkp6?=
 =?utf-8?B?MlYyWkpEY1VoU1kyQlk0UDVrVmZFN2ZWdjQ1eEVUdmFlNmRlY29EY0kvRFRw?=
 =?utf-8?Q?lO+2pSgztthgqXFM=3D?=
X-Exchange-RoutingPolicyChecked: k23z49IqJl4mamwgmDeYxng5YvLncHI/relaKReOkamukiBIqETwtup83gm1O4LNhsfwGlDH1o7/ABVmFhOZmdoq4TDj4kVePJhzT3/lBVgMQx34txD4HhCABZ+qb87fCyr17aayUkCvFKUEYUGuc+DQ5VaZjL9k8iitz1dLKXxB4tVD0PzPSTX5Hrqzw09OJlKm4NChrw0KPhUeSxau3ZGCMqlt8o+3DGb9K79jINaK5QJJj0Av+sS+Ho1jGFWWvq7QYpxnVimO9XQpV3nFu9RMbbKpwkBWHUYecRqqGmXQwwztqXBwghhsMRsMY+AEofrIn+G78cKa4ZkZlbbTqA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 0888dd05-960b-448a-17f2-08dea4e00f7c
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2026 04:38:57.4406
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: boZhFu/KFujsxkXOH/djUR+fZtgC1VZxBp2CNcwGvlTBvdZe7sD6Ci9FBE0mJR0ETzWrQE4HM9gZ4C/SuGDJbKXocbGjmkpaIpZAg43/hHw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF2F2B659FE
X-OriginatorOrg: intel.com

On Sun, Apr 26, 2026 at 06:56:46PM -0500, John Groves wrote:
> Maybe I'm overcomplicating things (it's one of the things I do), 
> but I'm still struggling through how to address all these issues. 
> Some comments inline.


Jumping to the part you commented on, which I think was the biggie:

> 
> On 26/02/26 06:00PM, Alison Schofield wrote:
> > On Sun, Jan 18, 2026 at 10:36:38PM +0000, John Groves wrote:
> > > From: John Groves <John@Groves.net>
> > > 
> > > Putting a daxdev in famfs mode means binding it to fsdev_dax.ko
> > > (drivers/dax/fsdev.c). Finding a daxdev bound to fsdev_dax means
> > > it is in famfs mode.
> > > 
> > > The test is added to the destructive test suite since it
> > > modifies device modes.
> > 
> > Make it clear that it is added in a separate patch. (and assume you
> > can drop the destructive part too.)
> > 
> > > 
> > > With devdax, famfs, and system-ram modes, the previous logic that assumed
> > > 'not in mode X means in mode Y' needed to get slightly more complicated
> > > 
> > > Add explicit mode detection functions:
> > > - daxctl_dev_is_famfs_mode(): check if bound to fsdev_dax driver
> > > - daxctl_dev_is_devdax_mode(): check if bound to device_dax driver
> > 
> > 
> > The precedence check (ram->famfs->devdax->unknown) now happens in multiple
> > places. How about adding a daxctl_dev_get_mode() helper to centralize that.
> > It could be private for now, unless you expect external users to need it.
> > 
> > daxctl_dev_is_famfs_mode() and _is_devdax_mode() are nearly identical aside
> > from the module name. Refactoring the shared part into a single helper will
> > also make it easier to add a daxctl_dev_get_mode() without duplicating the
> > precedence logic.
> > 
> > > 
> > > Fix mode transition logic in device.c:
> > > - disable_devdax_device(): verify device is actually in devdax mode
> > > - disable_famfs_device(): verify device is actually in famfs mode
> > > - All reconfig_mode_*() functions now explicitly check each mode
> > > - Handle unknown mode with error instead of wrong assumption
> > 
> > Wondering about 'Fix' mode transition logic. Was prior logic broken and
> > should any of these changes be in a precursor patch that is a 'fix'.
> > 
> > 
> > > 
> > > Modify json.c to show 'unknown' if device is not in a recognized mode.
> > 
> > I think this means disabled devices will always look unknown even when
> > the intended mode is devdax or famfs, but disabled. This seems to
> > change the meaning of mode from 'configured' to 'active' personality.
> > Can you detect the configured mode even when disabled?
> > Perhaps a man page change about this new behavior?
> 
> Good point; before famfs mode there were just 2 modes, and 
> not-system-ram == devdax mode is the current standard, even if no driver 
> is bound. At some level that's a conflation, but I'll revise and stick 
> with that unless you have a better idea.
> 
> Is that how you want it? No driver == devdax mode?
> 
> Any thoughts?
> 

I do think we need to introduce "unknown" rather than keep reporting
devdax for all non-system-ram devices. With famfs added, that old
"not system-ram == devdax" shortcut just isn’t true anymore, and in the
unbound case we really don’t know if it’s devdax or famfs. I’d rather say
"unknown" than guess wrong.

That said, I don’t think we should drop to "unknown" when we actually do
know the mode. In particular, disable shouldn’t cause us to lose it. We
already report state separately, so I’d expect something like this:
	mode=devdax,  state=disabled
and not like this:
	mode=unknown, state=disabled
for a device that we knew was devdax (same idea for famfs).

Also wondering about behavior here: if a device ends up in mode="unknown",
what does enable-device do? It doesn’t take a mode, so if we’ve lost that
info across disable it’s not obvious how we pick which driver to bind.
Before famfs we kind of got away with defaulting to devdax, but that
doesn’t really work anymore.

So I think the rule should be: report a real mode when we can, and only
use "unknown" when it’s actually ambiguous. That keeps disable/enable
workflows predictable.

And if we do introduce "unknown", we need to document when it shows up,
since this is a change from the old behavior.

-- Alison

snipping here, I didn't see any questions or comments below here
expect for the done on the PATH_MAX usage.


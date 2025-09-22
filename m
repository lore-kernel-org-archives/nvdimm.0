Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DB7A3EA8D
	for <nvdimm@lists.linux.dev>; Mon, 22 Sep 2025 22:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758581451; cv=fail; b=ouJQfL/CkkUJIE+5a/H8/xHN4ATrqC68+RnpTQuDBtVWxDu9+bB2CVMTV4ksQlrsmSNFyudW3x41nTn7BUbalLH6hadSH6L/3GDZTdOkehOWWSCSK1Qswfhh/VY64NMrhjnyVpAOXt4wfBnvbJxY2SmZPKYrWa3W2oJzhkXA3DM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758581451; c=relaxed/simple;
	bh=5Olh9aV5bvanR/WU9TE2KnPmvIMWgEcdj3YFpx8QPbA=;
	h=From:Date:To:CC:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=oRL/dIEdbgk0vFOcGpEE3udhoBnFGLNTxaQhU6ivb+S60VVq4RrJQnfrG1JGvj2KnVSTN1AtXw7jHZw7PLNYuVcexuAFZuLHYlDgaUj3dS2zvjlnlHGkPY35Cv+kXppF4PZXW6Dgg8U9X90XFX/VChrsOpL/rdugly2EOoXxXz0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lHhsPmk1; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lHhsPmk1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758581450; x=1790117450;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=5Olh9aV5bvanR/WU9TE2KnPmvIMWgEcdj3YFpx8QPbA=;
  b=lHhsPmk1Ex4ZCW3TDhyDie6z+leSnx82+tp6aT+Sf0zRiL96JZUH7ZPZ
   IOSW0VeLgf/+C1wvdIXIsPWz9j/blC6wANZMl7jhWgdGftDGicU6i/F+2
   f9gNIsT9MgyD65rFXj/Yi5jfYiRXH7y2ip7wQb3NNQTUsXVwo2JKyZwCj
   0VP9EB+nvBPoVCLmGhy1LMrBvkGeqstnFrAzziaEPTZCMe1PpAKFiQRud
   P7Bjr3ohl/WFK1z4cT7ifreCYUMokNccL9zGhuw17Bbqnk1LofAKWAMhQ
   J+uXcxa5UryNIiIJfgYB6jlj90/hP293WJgGf+9DZS6r6aGK877dU1GFD
   Q==;
X-CSE-ConnectionGUID: pECa5MQiS3COqQj5spc6kw==
X-CSE-MsgGUID: oSpWiOauRHOXFLq9C/zUQQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11561"; a="60552513"
X-IronPort-AV: E=Sophos;i="6.18,286,1751266800"; 
   d="scan'208";a="60552513"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 15:50:49 -0700
X-CSE-ConnectionGUID: 1oxBM36/TG2cBcjNzexB1A==
X-CSE-MsgGUID: XMxfgHiDQUG5Rn5/sxW31g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,286,1751266800"; 
   d="scan'208";a="176972027"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 15:50:47 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 22 Sep 2025 15:50:42 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Mon, 22 Sep 2025 15:50:42 -0700
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.10) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 22 Sep 2025 15:50:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=W0Dh9B42v8cHQ7g9E/h6PJTzjXQQSiylg2jddxOLOYDexSv1RWJaOM4QYmYq9pIbIoM+q1Q/zILGDWMYXU2gw+k2Jf459B0hmN865ay3Dyg1vA2R9mam8hzlYAwFoxQaDh9kBoLyVJj2OP+jwpJstBxO3whO/88oGohbBaGbTKSst1MyTHToVBVJfo0plBvcQ8Jv2VuM+PUlZMEACERIcrtJu5qOIeol6ZpX4KyKqL2ROisUbev5IkQwgwKd27uqfF0O4yTsxcIkkQptFMEH1dvVcgnKP1mbsRuE628U3U8Omg65AY3/0TDur9KZ0vIMKKiyy1ceEEZyyiVjyRO5lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D0HejYQeyXTeDQyU/sslq5JUAiIbbX5kGiERqfhLWQQ=;
 b=DkitnqujgeWMp+cEI1EveIT9pQH6/tZupAo3rn2WmUhhIOwZ1iZOVnMZEu02m+a5J18Q90NHCWUd/c0+DhVUPha7jOolx5JO3CDJMSo5IBqVE0oREWEOhPg4Ng9K/N93V+3LCIF+CYGsldVWXVVlLT23u33rQnCe8Xqey4TOK47AhAFSjqreWc8CbwLpNqr3UxyoL0yXGjikjnd9keewI3lozvfnoZ74gysMenW2fMN3abrldNpGlvDCyDc62PG3EYeaIHB/4F5rxCpiwsYybggMNC3Xg4CysR6YvfL7uZyGjwcOdFrR+91ldZtFfNqtVJZbkD5e5oc7fRuX8R5Kbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by CH3PR11MB8703.namprd11.prod.outlook.com (2603:10b6:610:1cd::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.19; Mon, 22 Sep
 2025 22:50:39 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%2]) with mapi id 15.20.9137.018; Mon, 22 Sep 2025
 22:50:39 +0000
From: <dan.j.williams@intel.com>
Date: Mon, 22 Sep 2025 15:50:37 -0700
To: Dave Jiang <dave.jiang@intel.com>, <nvdimm@lists.linux.dev>
CC: <ira.weiny@intel.com>, <vishal.l.verma@intel.com>,
	<dan.j.williams@intel.com>, <jonathan.cameron@huawei.com>,
	<s.neeraj@samsung.com>
Message-ID: <68d1d2bdc0181_1c79100ae@dwillia2-mobl4.notmuch>
In-Reply-To: <20250922211330.1433044-1-dave.jiang@intel.com>
References: <20250922211330.1433044-1-dave.jiang@intel.com>
Subject: Re: [PATCH] nvdimm: Introduce guard() for nvdimm_bus_lock
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0027.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::32) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|CH3PR11MB8703:EE_
X-MS-Office365-Filtering-Correlation-Id: efb08b2a-a8b5-4ef9-dec0-08ddfa2a73c4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?MmdENG1zaTUzeHJMcjhLS1lyMHFaUU1VY25ORmNqdlRBR2pEeEhTZjd1d282?=
 =?utf-8?B?K1lGU0d6NlhDZE93Q3BtSUUyMHNBMVdyVmxvWmtBb0hDUTUxNDZ4dkhBNTc4?=
 =?utf-8?B?dnhmMXhLa3ZGMC8rN2hMMjZxZkZ5S095WGhxbXhscCtheitXbmNQTHVjK1hj?=
 =?utf-8?B?cGN1TTFLRVFQaVRXbTNtYXMrVU16Tm9TbS9ualN3SjJqekZwaVo1S29PajNr?=
 =?utf-8?B?V2ZkbTBBWHlrWmxNSUQ0MGRWa1k0QTRqSW42elRsT1MyNGZiMGFPRjJta2dh?=
 =?utf-8?B?dDVmMXIvYUpDSFJYdVVtcFUzamQ1Z2dPV2lES0grTDZvYzQ2bXh0TzR0Wktt?=
 =?utf-8?B?U0ZuNlJIR0RNblkrNGxpUjlpVU9EMWJaWWoweXlLcEQwU0UvcDluRkpwNWFt?=
 =?utf-8?B?aVo4b04xb1FBellpaVV3Vmd1blpMVUlvUTRXcEVkWWp3QzY2dVA5bWJuSHRu?=
 =?utf-8?B?ZHAvdkJqdXRqMnpsRFcyRUh4OW5yblU3bWZPL05wMTNFenVBaU9VQjVWb3kx?=
 =?utf-8?B?S3o4RHNHZ3lJNURUVERrdXR4cnZJcFhYMUFVY25qekM2QXY3Y0hpeGVLcmJC?=
 =?utf-8?B?YjFnbTlLWUNvdTlCNkZvM3ZlNnF6OHAvK1ZqZXB5N0ZONnNrVzV6dmRkVnMx?=
 =?utf-8?B?cEo0SXJ3RFNVUy9OZWZQOGFEOGVwbWtrS291QW16bm9iYWdhUGliT0QwUzg0?=
 =?utf-8?B?V3R6Zi9ERmhVMWJlV2NWbVIxM1BhbmNLSnJkb0RJUVA2SDc3dmdEZ1NWeUJ2?=
 =?utf-8?B?eHRDU2tQMS9EM05lZGdrTzg1K0JwMDB6ZWp6NmUwRCtFUTh5ZzNCWVBxYnpT?=
 =?utf-8?B?M1VGckMzb1c4QXR4UlRxL2xCZ2hGZGZ2eVA1ZjdlT1hMTkZFZzduRXFvazkr?=
 =?utf-8?B?MjNkTDdzRklBMmlHcXhBVTg3aTRLdS9HTUdPaWxJbjY0RmQzY2JkeWZxSFRs?=
 =?utf-8?B?azRTRGdqUTZKNjUxT25kNEJQZmV3NWY2TUxuelVyWGwzZy9YUUNXTit4UTFm?=
 =?utf-8?B?b0VFTWV0ZG9JdXdYek9wY1BqUnNJQW1LckdqcEx2WGxvMXROeERxV1kzV1Q1?=
 =?utf-8?B?V2F6ZnJNdXoxV2ZNU0IvRk5RNFNPWDl3c2RYL3lDTDVGV0VLMmVPRVdpNTZ2?=
 =?utf-8?B?RkQ0NDVtMU5jWUE5NTZqTlM1SWV2YWErK3AxL3R2YWdMdWxnQzRzVHc4QkI4?=
 =?utf-8?B?T05nM2dIVWpnbFBEUDBLWFJpZjhjQzZSYjkvTlpTMFFodGVpcWNjZW41dW1K?=
 =?utf-8?B?NnF6NDBZMlJmUUlBcWJwWUNYZzRGWmJ6SDdWL1pnQnR3WEU2bTJabHBzUFJ1?=
 =?utf-8?B?aEQyZXA0MmhYcTVkcDFNTExxOFdKOEJPSEVOMFQvaldsVzYwdHp5OEZiVkNM?=
 =?utf-8?B?NE8vL1Z3Q1hyMkNSb3hqVXU2UGp1cjJ0NEowVGNUemIwWmtwVUd1Y3ZhZ05j?=
 =?utf-8?B?V3pmQStkcUxzbFJHS2d2ZDdMTEZ3QzJ4YlVheG1wUGxmdkxjZ09ZdTBsTGwv?=
 =?utf-8?B?S2pid3lYVjFzd0p4U05Uc08zZ3FtRXFOeC9lYXBpR0VtS1hQdjVhZ0pQUmZz?=
 =?utf-8?B?bG1OeUxxcmcrMHppNGw0Nm4rbzYrUnI1VkM3blI4Ulpjd28xdENjRW5sWkFS?=
 =?utf-8?B?ZG94M0tIN2c5TVQ5TXpJbWs3TlROR28zK0Z4eUZuTVhJYVorVGp6WDY4dldn?=
 =?utf-8?B?ayt5ZjdTSUdUMTBpTEJxU0E4VTFaK1dVY1NDY3FJY1Z0bjl5YXBjeGphMGFK?=
 =?utf-8?B?dXF5OVNaVnZvUmswSjFNMitkbGE0Rmt4NmFvWThNclhTM0VjTm9rVU5xUXVT?=
 =?utf-8?B?bnlxamgrTzFNVmNNSFdLOGhCdDVnTDliTkJyWGZxeTE3ME9OMldiWk8rRTVO?=
 =?utf-8?B?eXhrd2lKS3FZLzNFWnlPQzdHTmVhWHplT0hxMmFRS2sxM3l6ZWo5dUZnUE1l?=
 =?utf-8?Q?bpB9XmhVfuc=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ajV5NmU3dE9vUFJ4aWNzUGFnOHZNWjVKbHNxNUdOSlc3eG1YclIwS0VmK0Ix?=
 =?utf-8?B?R3M4bWI2SEE1Z2tROWFFWnk3K0ZzNENxZmdHUmhzUzR2WlM4ckFValVKbER0?=
 =?utf-8?B?Z0pKVVBIUWVCaDd1M0JxclJuQTBwOC9JeDU2Tkd4RUNaK0taN1hibmNsU1ZK?=
 =?utf-8?B?NnozS1dDL2pCQlgyTm80cFc4L1VYakJoSWF3MkpkbnBDRENsL1NxTThNN25r?=
 =?utf-8?B?cWdOYUxVWVF6UHFzSDNtMS9IU2pJYXRYSEhQM0duTE5XdHJMcDREaGxXdGNj?=
 =?utf-8?B?M2xVQWMrNVg0ZVlLQXNhTzBRMzlkVmVZc21leFFXdFlnUjVKQkxHZ1pjc3dj?=
 =?utf-8?B?YWF5SUpXWmVGL3BwSENJZGxBN2JBbFRmYWNNWUduUTh4OUhpMS82N0g0SEhB?=
 =?utf-8?B?MDA1OFc4QUNTelJadlRRY2NocytGSG1uWUZ2N2pyN0pmdnlRSHBCNWtldVBQ?=
 =?utf-8?B?T0hoYllaU2ErdEh0L2I3dVR2dDJMa2s0MEZoams0N2IydHJIUEFMMTRsYldC?=
 =?utf-8?B?ZHB1d1orRGRHYXdTQXhTWmdUN3IycXZGWTBqNFN5MS84SjZCTllyL20zZEJS?=
 =?utf-8?B?MjVsbHdKMDY5NVFFS0pJS2pkQ3k3UEtQMzVXc1FQRkQxbUJJREJjbmNHSTFD?=
 =?utf-8?B?V0JNcUhjZTFKUGRzVm5uc2F0MkQ4R3FKaHNCOEJXemFkZGNudjh2QXVYcmY3?=
 =?utf-8?B?N3hHazlIUkhsZm9KZ3dxSmx4LzBtUkxxeGp2S3UxY3ZNU1dLbDBZclJpUk1i?=
 =?utf-8?B?Ymd0Vlp5OHB6U1oyUlN5dmNENC9XOThzd2d3c2h5djY5Y3FEUDd2aUNSRTRN?=
 =?utf-8?B?QVlTMXg4aFJhMUM2cWFmNVdyYzJnMzhWalNMdHl5OTJPRUdDZisxd3ZLWXo5?=
 =?utf-8?B?QVNTdVdnQm5PelUwVno2SndwNzFNQWFFc2ZvVkJHMVFZM0JVdmNWeERSbTla?=
 =?utf-8?B?blJBYmdHLzgxTk1OeHF6K05LV0dMK3VTZlp0cDBDZW00TUdGb0Nla05zeDh5?=
 =?utf-8?B?OFNDSWVOdmhSUjRkTzFnR2hOVGZxNXRHOFF0WnJmMFdKQnpCclhuOWl6RHBN?=
 =?utf-8?B?QjdTUDFuaXlwaUFUN1FMN2tpK2NZNG96VlE0eGR6dTB4ZUliVmJqVDBlaENk?=
 =?utf-8?B?dTBteG5wNVhtTU51T21UeGpSYVB0L1IzelpsR1E0NWo5ZU5oRVdwWlFGZ3U2?=
 =?utf-8?B?SEo1RUl3a0dENWR5TlVFTnlFL2FaMmlwNVNOamZJOFA2bE5VT1ArbitUZHpY?=
 =?utf-8?B?ZDRJSlJ5bTQ4d1FaVDMxVXZJK2h6eFFnUlZVMFczZU1BbHNhZG1lVkRWdHpm?=
 =?utf-8?B?aXBMQldIdmFjY1dPZC9LeHRMTnRXWjNPTEhodFBBd3BocTVWTmhJVHdNZGcz?=
 =?utf-8?B?Q1ZHOC9kMllackdBTXB4SFJSdEwyZ1F3WUhnQkhIdWxXc2V6K3lmdXFFRnlS?=
 =?utf-8?B?b0FxNm5MK3VOZHBEWnk2VGNiMTFDVGQyUmdIeXY1NzQ2WGU0RFY0T3BzVkhM?=
 =?utf-8?B?dVUzRHR6aHRzQlI1bUY5YTFNQ1pIYWxkMjNnc2huVEYrSVFEUW1BdklHejdE?=
 =?utf-8?B?Q1dMakNRbERwWCtBcno2aitHVE1yd3ltVFpZWmE4N3p1OFVjVXpQZDRkT0Fy?=
 =?utf-8?B?OGkvdHNoK3M5dUhTbFdTL0ZnQVNnUjhVZ3R1RUVWU1VnVHJpOUFjeTVTeUxW?=
 =?utf-8?B?NUZMTUFQRDRpd25PRkdwOFdsam41ekRSOUpiTHZaMHNMNjgwdmlydzJjSjUz?=
 =?utf-8?B?ckU0SjNSQXVqNWd5cC9WeTIzNFJmTmRGUUlKOFFmZHMxZFpUVmcvQllCL1Zv?=
 =?utf-8?B?emsxWWxZOVZqZTJhNG5xM3QxbVJIbUN6Qjk0UHVleUN4am1BNzVseTlNMmRW?=
 =?utf-8?B?dXJyQlE4SGFEdEdHS3VOL0p1eTBFSnlqZ3l4dDJSczFqTy9ybHIreldNRStX?=
 =?utf-8?B?bU1oYnJVWTBKQmNMemNZVzkyNExGbWgrVmRwenI4cTdtWEdhOWtqSG9jTnlh?=
 =?utf-8?B?K2tnSXZwcXZab200cXVGWkRVUDFqT3g0a3JHMzZsd0pBSE1FK1AvQzBBTmVm?=
 =?utf-8?B?Um9qbC9OZ01tK2tPZG15dDhpbmhsajkwSVo4d05MVjF2K1hHY3FNMGh5Wktq?=
 =?utf-8?B?Z3VSMWNPUDFLMDlJdUNvbUNkSHNkNHBleGh2dDVmMEtYN0ptbmJlb0Z2TTJi?=
 =?utf-8?B?Nnc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: efb08b2a-a8b5-4ef9-dec0-08ddfa2a73c4
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2025 22:50:39.6995
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AHdUwfJwTVrasK68fkH5YbtArsOI4q+lEdiqPWOZ/b52VAmwUeaw8C9rWUZNNpFt+AKZMQiXvanm5BxvQRx3US+6fmg6wIteVidI9oZNUxA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8703
X-OriginatorOrg: intel.com

Dave Jiang wrote:
> Converting nvdimm_bus_lock/unlock to guard() to clean up usage
> of gotos for error handling and avoid future mistakes of missed
> unlock on error paths.
> 
> Link: https://lore.kernel.org/linux-cxl/20250917163623.00004a3c@huawei.com/
> Suggested-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
> Ira, up to you if you want to take this cleanup.
> ---
[..]
> diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
> index 0ccf4a9e523a..d2c2d71e7fe0 100644
> --- a/drivers/nvdimm/bus.c
> +++ b/drivers/nvdimm/bus.c
> @@ -1177,15 +1175,15 @@ static int __nd_ioctl(struct nvdimm_bus *nvdimm_bus, struct nvdimm *nvdimm,
>  		goto out;
>  	}
>  
> -	device_lock(dev);
> -	nvdimm_bus_lock(dev);
> +	guard(device)(dev);
> +	guard(nvdimm_bus)(dev);
>  	rc = nd_cmd_clear_to_send(nvdimm_bus, nvdimm, func, buf);
>  	if (rc)
> -		goto out_unlock;
> +		goto out;
>  
>  	rc = nd_desc->ndctl(nd_desc, nvdimm, cmd, buf, buf_len, &cmd_rc);
>  	if (rc < 0)
> -		goto out_unlock;
> +		goto out;
>  
>  	if (!nvdimm && cmd == ND_CMD_CLEAR_ERROR && cmd_rc >= 0) {
>  		struct nd_cmd_clear_error *clear_err = buf;
[..]
> diff --git a/drivers/nvdimm/dimm.c b/drivers/nvdimm/dimm.c
> index 91d9163ee303..2018458a3dba 100644
> --- a/drivers/nvdimm/dimm.c
> +++ b/drivers/nvdimm/dimm.c
> @@ -95,13 +95,13 @@ static int nvdimm_probe(struct device *dev)
>  
>  	dev_dbg(dev, "config data size: %d\n", ndd->nsarea.config_size);
>  
> -	nvdimm_bus_lock(dev);
> -	if (ndd->ns_current >= 0) {
> -		rc = nd_label_reserve_dpa(ndd);
> -		if (rc == 0)
> -			nvdimm_set_labeling(dev);
> +	scoped_guard(nvdimm_bus, dev) {
> +		if (ndd->ns_current >= 0) {
> +			rc = nd_label_reserve_dpa(ndd);
> +			if (rc == 0)
> +				nvdimm_set_labeling(dev);
> +		}
>  	}
> -	nvdimm_bus_unlock(dev);
>  
>  	if (rc)
>  		goto err;
[.. trim the hunks that successfully eliminated goto ..]

My litmus test for scoped-based-cleanup conversions is whether *all* of
the gotos are removed in a converted function. So either fully convert
all error unwind in a function to scope-based, or none of it. Do not
leave people to reason about potentially jumping through scopes with
goto.

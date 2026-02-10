Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C125D32ABFD
	for <nvdimm@lists.linux.dev>; Tue, 10 Feb 2026 17:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770745985; cv=fail; b=J8sYvEEmTBgBICQTKTpGKaQ++Q9OcTlldBrYj0Wn9CVG48x7YfiNiztgDTbvOmAgPMmVuDLV2oepSpvqHOkpSmt2TSN/cjZ+Gx6zaII2lMUnjc9mS4QPp+SF4GRg4e/KnHZ5nR+7rnH9009yn7g2TLoLJnyiyNAyjybXGx28vD8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770745985; c=relaxed/simple;
	bh=EF37536QuOSR+eghOFM5CmXgwplxb8DclsAag1kUNNc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=NU+doeisskgMg0rfnA3kEa4u3qm0CEHIvNBwlN3hHlNh1j/hdWftW9mLgbMNAQpTVRtmmafVeKxnUT+vRarjrvfw0waIfPWurYkGu2t76/VTQZ4ligino0q07asSFt/NDJHsBShACtbxcu88dr/lkq1IhNp2wATr91JoIkZGkPw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JEE3Kere; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JEE3Kere"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770745984; x=1802281984;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=EF37536QuOSR+eghOFM5CmXgwplxb8DclsAag1kUNNc=;
  b=JEE3Kere3fuhvRLhzanROTasuxqiAfRgdKMM2/zAhbYG2ER4aNmPAmUq
   LgWCl/AlGKRK+dbGQsK0mlmKHu3eyeMiXrI2kOm7Jc2TXT3s2378MesHZ
   AY+jh0c9MfrJscEIu+V6Rtx1i2xX8eUx0zUq5V1eEjsLp+PMWtTrIp7lk
   VUSZIzThUvEB8o2VpCsOABfj/Z5XONHtlhP6hY3OjZd/IuVYOoeQFJcoy
   OLNLIcuSatzMQsN31/etOhnXxAeGpdq74BDWBVtuzBAWOxo3GJ6m5Mv9S
   0OLWBxekZXOng3N0W4yC6mdFppWzBlERLKoN+DyuKU2akWAfiA0rGaE+i
   g==;
X-CSE-ConnectionGUID: oSXL6aylS7+twHywPhaPLQ==
X-CSE-MsgGUID: RvbTTX1HSluH3gtm1gGQdw==
X-IronPort-AV: E=McAfee;i="6800,10657,11697"; a="71091633"
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="71091633"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2026 09:53:03 -0800
X-CSE-ConnectionGUID: IVV9VbCYTbmK0E0LuOkvig==
X-CSE-MsgGUID: p8s/nuaVRDO86TBShZ0w1A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="212019624"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2026 09:53:03 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 10 Feb 2026 09:53:02 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Tue, 10 Feb 2026 09:53:02 -0800
Received: from CH5PR02CU005.outbound.protection.outlook.com (40.107.200.35) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 10 Feb 2026 09:53:02 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zBykfavg/90sCMYWO3ms4Gg+f+Nojf34vmAn9EFA7bOa/cuQmCEwZVJyDZ+9jTQU2GvTQJwXEV45R9gIYdh8AQ/vcWwWmPzIcfeASnwZ6fjFnG9qBDnz1PgCCXJzp+ioIkAh2V/tCeQ4+CE7OkhXPKEMjvzfjCWVKRsexSKHbZz15VBD6oaGRdtgXiLS0XHVmnes2akXePo+NekVMuK7DW9LZJMtrCQrvJK30Srd+xh5H8EYFZomz6j+Wh0XG7Ve7hFHDahydRddT7hTSQpY+aM0H60e9BZ3GZuSljJTp6XOgo7tfSZPRVH7H5CH1k5RZDlNv4ysM+Fa1hNGZlO1+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EF37536QuOSR+eghOFM5CmXgwplxb8DclsAag1kUNNc=;
 b=C+MfIVE3mVFybrGqAxzVHCGS2PRN82uTFCgLisd0zzzHB0bifd7wSi39S1Y0zhJsFFSZhO9FPPZ89bNfEFNteV0mfAL/UIGil1cFHVQy623SNa/3ytK6wA3mDUgrk7wwQm5L1KVMwqlRd5H7mQPyE2aGSgETHPMe9gIU/09ApKMGqaBNYloQoUhXOy6w2pH0rRaHaSnVlbfHhHXlqtsv9CB0r3seKQiTPSIHKp8RWq+58464sIG+3NnshHkMnRL8ry6DKGsUBd7rKBe3CTyTdpS6Xj0WV/4rmKYu2L9xUP9THRctqsLiVkzKAA2nzThXFFNtE/XUlyTLQzuGDHEq+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB7125.namprd11.prod.outlook.com (2603:10b6:303:219::12)
 by MW3PR11MB4587.namprd11.prod.outlook.com (2603:10b6:303:58::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.19; Tue, 10 Feb
 2026 17:52:59 +0000
Received: from MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::690e:5fd2:b08b:52af]) by MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::690e:5fd2:b08b:52af%6]) with mapi id 15.20.9587.017; Tue, 10 Feb 2026
 17:52:58 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Schofield, Alison" <alison.schofield@intel.com>,
	"Benjamin.Cheatham@amd.com" <Benjamin.Cheatham@amd.com>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, "Jiang, Dave"
	<dave.jiang@intel.com>
CC: "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>
Subject: Re: [ndctl PATCH v8 0/7] Add error injection support
Thread-Topic: [ndctl PATCH v8 0/7] Add error injection support
Thread-Index: AQHcl7KmbyBfeLlatU6zK/745oWW3LV8PLEA
Date: Tue, 10 Feb 2026 17:52:58 +0000
Message-ID: <4b37820522cd852b321705f59e763acbe78ec799.camel@intel.com>
References: <20260206215008.8810-1-Benjamin.Cheatham@amd.com>
In-Reply-To: <20260206215008.8810-1-Benjamin.Cheatham@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB7125:EE_|MW3PR11MB4587:EE_
x-ms-office365-filtering-correlation-id: a26dbf63-a965-4bf2-5122-08de68cd3a1a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?Y25GUWxGejBKN2JvODJUa3VVdUdkblhjU2xMcUUzNDZYZ1YrdmllYU4vUmty?=
 =?utf-8?B?MUcyTWdBOU1CZVhuYTQyaElVMC9CWDgrM3hVcHdrd0h5VDA4b2FPbVh4VG1q?=
 =?utf-8?B?a1pZMjZkbll2Y3lIQ2NHRGtycCtBNnVBQXIvSVpBQ2Z1TnB1TWhEZ0pjc3hJ?=
 =?utf-8?B?UGJ4TEJ6NE5GT1cwU0UzVFdYQ0lhRzZ3SHVzcDhkWkVBd2J1UEFnZU4yZDAw?=
 =?utf-8?B?cVpjWlFmSmkrQ0drUW9ad082VDk4dVlLcFprMGFoemF0RElyOFhsSkc0UWV4?=
 =?utf-8?B?WWhhbmxYK3VDdldJZmJzYmRCUTB3R2VHWXZjakdqMmE5QXdjUk5kSzZoNXFW?=
 =?utf-8?B?SThxbDhQdktydnhRRlFyVzBRSHNkcTZJQnB1UXhZa3ZhcEt4L1JhWGo2bkFv?=
 =?utf-8?B?WHhvYTIvVjlnY2wxbVVCbU9rMjQvWGJ0am9Bc3NEMk9ZYURxUGtkdjdTT281?=
 =?utf-8?B?WS90WHIycmtiNnBtOXpHcjdrRktFQWdCUFdWeEZZVHhvWThFK0k5NGxHTDU4?=
 =?utf-8?B?NVhTM01qVUVuTDBRaXNvVm9rbVdVdk9ITWFiSFlNZ1VuaFdQUEp5UGdoazZp?=
 =?utf-8?B?WjhNM3NDWDI0cHJybVN6dGZCeU80cmhxRVFpSHRyd3VReUJrd2w5VjU1T0tz?=
 =?utf-8?B?Tm1XTWRjMGVsdUhGRjNEeGc2aURCckJmSWZmQkd4UENQRTJ4QjJyMXp4cnl6?=
 =?utf-8?B?cnVGUlZoeVk3S01ySjV2dkZsM0g5NWJEb1d5SkxtUXBnck0vUTB3Y3I5Zmk1?=
 =?utf-8?B?Sm5hdjZvdlprRFpCMnNQNjlCRng0bVNvT2RXeS9VbUpKUWdDNjRKL2N2VVY3?=
 =?utf-8?B?NUU2Z012K3VUYmxvbGF5Sm95MGtGazkraExEeVNxdUowRVgvZUlLSHRaQzNu?=
 =?utf-8?B?VGpXMXExR20xb3hkaDlkMmRtSzZqczhXNG16TEhKQlNLc3pOcGtBZ21YOS9n?=
 =?utf-8?B?ZGYzOWdjaC9SaHdoc0RqYU9MUGFlanRFZFJvK0VOOHJkZWMxc0V2cWYyT3Y5?=
 =?utf-8?B?V2l2S28rZWF0UmVMZjRwK2pWR05QUlhDcTlBODhTUjRkdDJhNXVsWWp1bllO?=
 =?utf-8?B?VkxraVpkcUk4MW5OdEF2MG4vWWxBK0ZreHJpdkRvTGVqMmNrU0tYSklnenB3?=
 =?utf-8?B?bWZZMTloMGxPWjNDN0lxbll1bHVGOFBGaGxZSk53RmVoMzdhdCtOSjdOc2Ex?=
 =?utf-8?B?TkQ5UE9ETTVieEF4TzM4ajU4VFdBdEZJVWRaNEhHRzI5VVVwRmRHZEtNT1Nj?=
 =?utf-8?B?UjkzdElwOG9pQlVnVmZiMGxDZlRyU3VaM080ZEgzNGF2bUZDZkdSOVZDY3dK?=
 =?utf-8?B?NXlvQWJwTzl3TklzUmxRZ1Q5QXNweDhMdmtscFpwWVF5aENUTHpneE85UTZL?=
 =?utf-8?B?TUkxOUZtL2NwemVacWp6RHdMUDY2ZUo5Rm8wcXFUZ3hudU51cEMzbGlhOGM0?=
 =?utf-8?B?VktmZzhKUmJSd2xhbHhHME5VZkNsUW1EeDBGOVhYaFUwMW5KNnhKRWNtTnky?=
 =?utf-8?B?bytUNXdTcitQR1FtVzhweFNFdkxvZG1UWkN1SmhyUTVpWnRWa2dkRWcwTHBj?=
 =?utf-8?B?Y0dTZEtJMUlWTHBxNDFjRnA4VHJWbjNKb2lYMHZUSDA4djBqYmVVaGxQSDF5?=
 =?utf-8?B?RUpvOTAzY1RLZlJzMnU3NmhmelZNREdvcU8zSzV0MWVGZUhENXFiZEQ0ZnNv?=
 =?utf-8?B?UjJ2YVM2M2NZNUJod3VJc3ZBQnpWVFFDVUF1eFNNNEdLYncwNmgzSmdENkJs?=
 =?utf-8?B?NTRZUTJxNkFFMTRLUTYwZUZGd25IcmpqNkNaS1E3SDJBWWcvdlEvSHFGTkJP?=
 =?utf-8?B?MjdPQk1vd1RkaERvY1k0NEtOYXdYZGsyNm0rQkhYcnRTSGxQa0JRVDQ5dTZD?=
 =?utf-8?B?anBnSTVaQmFWelR4bWExUlo3QnJYT2RsM3lzdnRaYlROY2puSmlVUVhyRzhl?=
 =?utf-8?B?RW9yTjNoZzQvWFJyK2E5V3NJVEtrOS90ajFFdWxkQVRkUTl2L3FaaFlOSGEx?=
 =?utf-8?B?a0xYVzFrWTZJSUViWWJPQUM1cm5pZDR1Q0NvY0dBeTgxWEpmbXFZdFgwZG9D?=
 =?utf-8?B?cVordWNvR0lYYWxFVXRaaUNoTjdUVGtjcXFoQVR5RlVkK0RlcHdxNm0zSy9W?=
 =?utf-8?B?UmpsZmxXeXJyTGZ1S3JUK3NOSi83bncrdzVnWTR4R0pwNDdMZWhZcXFTd3Q5?=
 =?utf-8?Q?Gf9AO3YnNc1JTFLp2fDUzok=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB7125.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NVNzNFF2Z09yWUNydG5NVjlOQ1B2Z0dValQyZkxBTDFOR2VwcXVOUUdSaU95?=
 =?utf-8?B?UGVSd3o0SDZNejkreFhHeXRYQ05JaVRldUFqMUx5YzhsT1pGRDdvekZpSGNF?=
 =?utf-8?B?bk1pL1RMQUU1VFdlU1JQSTdMaCtORm91cWhEQTJGaWsxWFlOdFVMNXVnNUtQ?=
 =?utf-8?B?MTlMUU9Gck9XTDdoYXNMazA2NENubUdIMmJqMU5yYUR4eDZQZ3VkR0NnTzZK?=
 =?utf-8?B?UUIxcEgvUTM5VEhpS29neVFQL0EzeUFHL2MyNjZReEFFN0NuODV2ekhGbzBm?=
 =?utf-8?B?T2EwS0UzamRFc1RnYlhMT3BTeGpORytseWpWUXJNKzQzZy9IclJGZWs2NlpU?=
 =?utf-8?B?bjFYUkZrdk5wNlJkWndoTmkvV2w4SU1MaUM1dE43ZG83YVorNXhmYWF4MnV3?=
 =?utf-8?B?NGJIRGhjUmM4d3BuNktWem5yWkh5YzVmbmxEY0FIb2U5b0hBS3AyeHRTN0RO?=
 =?utf-8?B?d2hFUDFxT0hmdkR4TjhvWnYyN2dJYjFOM2VCbSt1aFBsQ0RON05VN2t2Mnhj?=
 =?utf-8?B?dlZ0Rnl4ODgrcHRSeHQ1aXlGbk5waFNMUFFWQTk0UVo2MmNpY1g0ajVLRG10?=
 =?utf-8?B?aFJIWUMwa2lBaGZVU0tnUzhsS0VoenB1aEFCYm5adWpGRWo3RVUvOFhmeWkr?=
 =?utf-8?B?QWh0cHkyMXJPd1Q0MENBSWFNS1VQOUVLcGtxSUk1dkNFVnhHRXZYZDhuL3oz?=
 =?utf-8?B?YVFsaGFDaHBILzV2a1FBWlFCWDh0NUd4aUlQT1dOZjJ1MU4xb0sxMXNVLy93?=
 =?utf-8?B?d3hTK2dMdWYrVS9yZllBUGM5SVI1VjY5Z3B0eHR6WEliVzlPZno3aUFhT2Vm?=
 =?utf-8?B?MTlVYUdRaG5QYi9XRXJaK2RsRzc3MmU0aXBHdGYxOWU3WVRWQi85VTQ2QzVZ?=
 =?utf-8?B?aGdkVUx2emtKQVd3OUFCVHdISWRGcVJWVU5xb3UwK3Nwc0VObk9mWWluS2hZ?=
 =?utf-8?B?UnRDSStaWW4rbjFzTG9ubnVpV0hBWDdUa3BoMDIwSkFiN0FhY1orME9CbHZX?=
 =?utf-8?B?Zjd2T3J6azh3VmRMVU04VEIvL0YrMnFKdGJaeDd3NlcvV25QV2JJUmErM3Nh?=
 =?utf-8?B?YUJiOGlkT2l4blFNNTRJYlhiVXkxOFlyajZPQ1VWa0pVVFhvaVJZbXUyNWhG?=
 =?utf-8?B?akdNdXJTaE0yVk1MRUZyS1B1U0pDalFCRFYyeEhrd0o4OXdVOGJnQVlBbXFV?=
 =?utf-8?B?RlZYeWdGdHpxZ0VaYWd0UWltaTBCSVduYjJ1ZGVZZWZhMHRZVEZMakdhVEJq?=
 =?utf-8?B?aGV4Q1RzN01rRHI3Y3ZEKzRwazVZUEdnQVFLR2tQR3RWbVUyc0o3azRUUGpK?=
 =?utf-8?B?cWk0dWZJUklnMHVQTSt3TEdoNmdVZnp5Q2t5cXV0clZaYk1yOGxMazExRFZC?=
 =?utf-8?B?NTk5ZWVGWDZGWWFiWjlIbjNmQjRTQXFwSlpOZnFPUk5nSTU1L2xzTUdDTi8x?=
 =?utf-8?B?UFhBNjZGWnZSbDJQV3E5K2NuTlJMWjJjcXpPeTgvaW5JZFVPck9LVnNPNklB?=
 =?utf-8?B?SGlNeTV3SkUrWHBCMDR6T2pQcUx2REp2bWk4cWVYY0I0TWMwUDRIaDNydDF2?=
 =?utf-8?B?elU2SUw5M25lTmFXcmJ2VlIyZy93MFlScFNWVlRzTmNTWlFiL094OGt4Yjgv?=
 =?utf-8?B?eGs1Sm1vcGZlMy9YT25QU2ExcnRRV0RmSXIrYXN6RDVKUWp4NmtvUFAzQ2ls?=
 =?utf-8?B?R2s3TytSOWhBdktrQ21OVXVJdGdackQrMTlaSEpCUHdhS3JMUXRPTXdzeGRB?=
 =?utf-8?B?eVFwYXcxUXFCcTZ1RjFGWXNBaTF1QW9lZzJpNmlJMHZRSDV3R3BtUm16QXhS?=
 =?utf-8?B?WUIxTHhZOHRxL3dIbWR5TjZBUy9NS0p3UzM0RUM2VEtodDAxNnh0TzYxK3pq?=
 =?utf-8?B?RGs1RDM0Rm9RTEZxZGVtZ0dDaitlQ0F6OC9OcEFKQVlkaDVoMkd5ZlZ2OXNW?=
 =?utf-8?B?MHIrSWNzeU94bzZTRFg4aW9RVzB6OFFxUzlmSTN0RXA5cHNWaGhISDVjRy90?=
 =?utf-8?B?UEgxUU5NWUMvTEJFcU0zZXFncGJXYjF1Tm41OCs2elhsWEFIOXBWU2pnRVVE?=
 =?utf-8?B?Z0tTeVAwaTBPQlFNWGNudUFwdXlzZEpZVm4vcUQ2SVl5aE52TWFxelVDZ3Vw?=
 =?utf-8?B?WkoxQlQ3S3VTMWExU3h0THV3MjVvRjR0NlViSE50Y01NaUplS0RHdkpPeSsv?=
 =?utf-8?B?N0VNMDNFeWZ2Z0NzVnRGWWdNTUlyNHlscVMyMkpPcElIdmc4Y0F3bU9iSUtq?=
 =?utf-8?B?ZGI0NWVSN1pJZWNQcU5naVBJdlk1SndienI5eE8rc1FUeWxhdzBqU2ZwMGVm?=
 =?utf-8?B?K1orYTFlMHZCWUw1UksveDNZd1N4NGNwaENINDA1MWFjMzJWUUw1blYwTmxI?=
 =?utf-8?Q?UK1kN6c40xJy1iOI=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B141239FFEF1C941BFDC8E9B6179DD42@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB7125.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a26dbf63-a965-4bf2-5122-08de68cd3a1a
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Feb 2026 17:52:58.4539
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1DIzu0fyWnorUn9qzPY7gDz1IqxjkyKwKPUm990hACMaxgmoRU5AY9jypv12YsY3xxyVxYjFDoUNh3HakvsvJLR791NHZGEGYM1sbkzGXl4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4587
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI2LTAyLTA2IGF0IDE1OjUwIC0wNjAwLCBCZW4gQ2hlYXRoYW0gd3JvdGU6DQo+
IHY4IENoYW5nZXM6DQo+IAktIFNwbGl0IGluamVjdC1lcnJvciBjb21tYW5kIGludG8gJ2luamVj
dC1wcm90b2NvbC1lcnJvcicsICdpbmplY3QtbWVkaWEtcG9pc29uJyAoVmlzaGFsLCBBbGlzb24p
DQo+IAktIFJlbmFtZSAnY3hsLWNsZWFyLWVycm9yJyBjb21tYW5kIHRvICdjeGwtY2xlYXItbWVk
aWEtcG9pc29uJyAoQWxpc29uKQ0KPiAJLSBEb2N1bWVudGF0aW9uIHJld29yayB0byByZWZsZWN0
IG5ldyBjb21tYW5kcw0KPiAJLSBDbGVhbmVkIHVwIGEgZmV3IGVycm9yIHByaW50cw0KPiAJLSBV
cGRhdGVkIGhlbHAgbWVzc2FnZXMNCj4gCS0gQ2hhbmdlICJjbGVhciIgcGFyYW0gb2YgcG9pc29u
X2FjdGlvbigpIHRvICJpbmoiIGFuZCByZXZlcnNlIHVzYWdlIGFjY29yZGluZ2x5DQo+IAktIENo
YW5nZSBjeGxfbWVtZGV2X2hhc19wb2lzb25faW5qZWN0aW9uKCkgdG8gY3hsX21lbWRldl9oYXNf
cG9pc29uX3N1cHBvcnQoKQ0KPiAJCS0gVXNlZCBpbiBwb2lzb25fYWN0aW9uKCkgKGN4bC9pbmpl
Y3QtZXJyb3IuYykgdG8gcmVwb3J0IG1pc3NpbmcgZnVuY3Rpb25hbGl0eQ0KPiAJCW1vcmUgYWNj
dXJhdGVseQ0KPiAJLSBQcmludCB1c2FnZSB3aGVuICctYScgb3B0aW9uIGlzIG1pc3NpbmcgZm9y
IG1lZGlhLXBvaXNvbiBjb21tYW5kcw0KPiAJLSBSZW1vdmUgY2hlY2tpbmcgaWYgJy1hJyBvcHRp
b24gaXMgZW1wdHkgaW4gcG9pc29uX2FjdGlvbigpIChubyBsb25nZXIgbmVlZGVkKQ0KPiAJLSBB
bGxvdyBjbGVhcmluZyBwb2lzb24gd2hlbiAnaW5qZWN0X3BvaXNvbicgZmlsZSBpcyBtaXNzaW5n
IGluIGRlYnVnZnMgKGFuZCB2aWNlIHZlcnNhKQ0KPiAJLSBVcGRhdGVkIGNvdmVyIGxldHRlciBh
bmQgY29tbWl0IG1lc3NhZ2VzDQoNClRoYW5rcyBmb3IgdGhlIHJld29ya3MgLSB0aGlzIGxvb2tz
IGdvb2QgdG8gbWUuDQpGb3IgdGhlIHNlcmllcywNCg0KUmV2aWV3ZWQtYnk6IFZpc2hhbCBWZXJt
YSA8dmlzaGFsLmwudmVybWFAaW50ZWwuY29tPg0K

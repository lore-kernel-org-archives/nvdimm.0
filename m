Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFEB615572C
	for <nvdimm@lists.linux.dev>; Mon,  6 May 2024 19:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715022714; cv=fail; b=SwdsQHtagKXKHzDMhjsPg/cPQ4Ws1/OXSnIPNZJuaV8jhMJyZiKkitxOyVdCFiROJPctpbpMzeNl/fRhwEbniMS8KSt//V8NTK1/RXXGTuYLTWiPUILuyW5jdad15ba/e+mUmfObPahOMhWoeAsC0dLXNzu42/vbYkKLj3Y2i8Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715022714; c=relaxed/simple;
	bh=pgeCfMb4uvqLVd85PQqoVAEQ1nVq36Gjunsbn7Ltr7c=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=f4a0mwq7eg7MTD04ont8CNozZorqkKXEEfvegXZw9e0ddWszLB4ZKSMPtAzbBHYxfXh6ZrPJL189sEXnLqHfnVMydYOQ5NRTfE6Kagqd4LMEjhtZpf2YLlh4ofgBFuFdf3T9DcGT1We14P4Vfl+SCqXMQavk7W4NgZhTpoQN3MU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WZj698mt; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WZj698mt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715022712; x=1746558712;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=pgeCfMb4uvqLVd85PQqoVAEQ1nVq36Gjunsbn7Ltr7c=;
  b=WZj698mt2f4NKs6/hE7Y2MFAYhS6qRoBSahFXEX/hjFozcJZUQXPd4hg
   PUJdVSwfj70OWyWip0Tm6UxiT6Lus1kvlMfD/Cb9MOBRzsf3q7Y2SxWVb
   ebzYiZSJGsfjr7IaRWYN5mgXKWHnioqNSOhcvkEjbj6MHY6rrj1T1/MCj
   079TNdrmaK5Laf2GDgxE6WPGkOCPM51C/zbQ05RSRYnxYNmRFPX14HXgH
   cjX0RpD/8ihRH7G26WhiMz6Q6akL2xuQRxDsrQO9NgODKDJZwo+9NLfvo
   KSmTXMIHxJctG3aXKH6en+Ta1TwdPpJyglhIw7rDFmipCo6m0p4WuDQOc
   g==;
X-CSE-ConnectionGUID: kFM/KCP6SmG35VfjdLevTw==
X-CSE-MsgGUID: 2UdkyeV0TDaBcllbnD4irg==
X-IronPort-AV: E=McAfee;i="6600,9927,11065"; a="10716152"
X-IronPort-AV: E=Sophos;i="6.07,259,1708416000"; 
   d="scan'208";a="10716152"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2024 12:11:52 -0700
X-CSE-ConnectionGUID: 7M162Yd0Q42UftLnOUzjFA==
X-CSE-MsgGUID: H2X7jjIaTAyPuew0/VprZg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,259,1708416000"; 
   d="scan'208";a="33053857"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 May 2024 12:11:51 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 6 May 2024 12:11:51 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 6 May 2024 12:11:50 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 6 May 2024 12:11:50 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 6 May 2024 12:11:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m1gqvIvsPKQkMaFpQVX52xNGdOkK0Zy3dKza39bGbXaWWS6R+pbHTBmDSZn8coAHu5wCC1Grpv+gKRv95b52TzbZMfgMf4zUXQ22W/VhmjYUxI8Sak4+wiDGsK8BvZQtyv4LEACe0DednyLw/Pox6q0FoySvvXLzZ2OHJxJrAowolp37qNZvCsRQEjqHmXroMutzUM4aQ72XROomifcyDoWJX97ln/Ut92/Cs9Tmb41kJzLMlLWzHVbojImVolx8En2ih8T4rqje+RIa+MRNnm4C2nvnQn3ERlNF4RiSM1y/tJHlq7o8MpOgsqow40xj5V/W3HjFw2L7DfeJyKAQcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pgeCfMb4uvqLVd85PQqoVAEQ1nVq36Gjunsbn7Ltr7c=;
 b=iwVirhLYVkwvQqZWd1vTu++LZwfCpEpYTf6jnIW4Y4eSjnO54CPy8RKqtL3X1BxiqzAfKCU2QmbR+22tyZ9sN0dydjueml4mQuu1oXFjXxmCLNXv6n+9v8JapFlAa34njFvKWnSF53z8dRBItlRwbWnuMs4KJV/ve5eyZqWArZZNhQ4bpS1Ly0/IMTsuKVUUXt5vk9Mc/mJ36ZWU+fmpGtfazi8kLs/J+7q9+VVpCsnhwasmdq9iVFSfnhw6V4g66VqLjOByBG4qdQVx4PaXGYlHMTjZQTxExItTu0h7oddffWOAqpGg+yM/unoQq3cGSHTeaQRuls/Wlk+aiWZ04w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB7125.namprd11.prod.outlook.com (2603:10b6:303:219::12)
 by DM4PR11MB6525.namprd11.prod.outlook.com (2603:10b6:8:8c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.41; Mon, 6 May
 2024 19:11:48 +0000
Received: from MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::ed72:f69c:be80:b034]) by MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::ed72:f69c:be80:b034%4]) with mapi id 15.20.7544.041; Mon, 6 May 2024
 19:11:47 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "jmoyer@redhat.com" <jmoyer@redhat.com>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
Subject: Re: [PATCH ndctl 2/2] libndctl.c: major and minor numbers are
 unsigned
Thread-Topic: [PATCH ndctl 2/2] libndctl.c: major and minor numbers are
 unsigned
Thread-Index: AQHanZw8syD58lWdn0mBORybihgY9bGKl0CA
Date: Mon, 6 May 2024 19:11:47 +0000
Message-ID: <068777268a0239282b02ed0bc7985f10dd9d4f28.camel@intel.com>
References: <20240503205456.80004-1-jmoyer@redhat.com>
	 <20240503205456.80004-3-jmoyer@redhat.com>
In-Reply-To: <20240503205456.80004-3-jmoyer@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.4 (3.50.4-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB7125:EE_|DM4PR11MB6525:EE_
x-ms-office365-filtering-correlation-id: 616e6233-ec8e-4041-770c-08dc6e00606b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|376005|366007|1800799015|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?em9IU2JUWllTNi9TaUxGRW9tem5tODJoc2d2YUZmOENMekVTZDFoUkRQVUVF?=
 =?utf-8?B?d1dTZW5WeXc5Q1AzeWpiZ0I3dTlUSGpQTzVmZzZZQUYwdkwvcFgreDZXV1Jk?=
 =?utf-8?B?QXpQemZ4Qy9UWjJKSWRFRk9lV0F3T2FlZnhJcTV0ZnI3dUU1RjQ5YnRrN3U2?=
 =?utf-8?B?SlJDOTVzc3F2ajlybU5OR2J2N1EwdVVMMWQzYkdiOVJxd05LWWNqZERPc01S?=
 =?utf-8?B?UnQrWHRxRlFVWWFCNVVGcjdaOEVyeERJajhPeFhyVll1QnVUMGRtUFJCYXRi?=
 =?utf-8?B?aTZEN3pDZSt6cnZPeHFsSk8yRjEwWXd0bXhxb0VHVGFiUEIxaHlPZFArK1d1?=
 =?utf-8?B?SXphUi9rbTBCaWFBYlpXc0NDdGtDV3VQS2pvSkF5Z3hPUjlFTnJyQW0wUWdI?=
 =?utf-8?B?YWJvV2lPV2JKdVptTVJEbzBzams1bDlnQW91bk9PS214d24veGZxVWM1U1d0?=
 =?utf-8?B?Q1lTak5RalpUSlBxdzRqNGpLRXFWZFp0L0Z3WE4rTkcvK0lndnJ3TmZibTFr?=
 =?utf-8?B?cDE1eXBTSi9oM3ljRXRCQkFmREFmSkw3a201cmppWEs2SjVOUlA5SkhSME1J?=
 =?utf-8?B?OFBKYzV5ZUViand0RWdJSFprL0o5ZGdOMS9IK3gzZFRZZEtnejhEeWtyQTRT?=
 =?utf-8?B?b3l5QnFpN0NkbC9kS0hOWk9BQlM1YVBCb3kvWDYzVUVuU2FNYnoxOThrMzhN?=
 =?utf-8?B?QjRmRExUakp4bjZKb2VXV0JHaEthZHNLc2syMklpSEtuL2orOTlrNE8xR2ta?=
 =?utf-8?B?Wk1PY0wzU29Wd1ZsWi80YjRmNTBteGtSdHltS2xaUkthYjJUeUUwSjVNYi94?=
 =?utf-8?B?RGJ6VVBhVXBJUUxuSktpK1hucU56OUJidE9LOFNuN2tHcGNROWYwMnFDUXda?=
 =?utf-8?B?RjB1V1FZY0NBUXpyeXVUdml1d1MyR3Q5UGt0MUduR1V5cWJ1QzdmbnZjMjJ6?=
 =?utf-8?B?SS95UWNLUmorTmtISTAzNkw4dXh1NHVncklOME8rWUlteFh5bFhiaG53TDZ2?=
 =?utf-8?B?U2oxb05PSjByMTBlTHhxUDlQd1lXQWpsWWRwK1dSZ0FlOGhvc3BTWTF2eUtY?=
 =?utf-8?B?RnlCL2pDQ080d0tsdENmS2lwUkFURzFMSWdlMTNrTXNwVDVGQmE2eUNaRlc5?=
 =?utf-8?B?eDEvTE85Q1UzUmJTZmNVZlNzaE1XYVg2VmdvWjA0Tkk1S3hRRmJCa2hLRFRm?=
 =?utf-8?B?QzVjdjFBZ29EM1Z2QVhBR0syZTJENjVVdTBtTWVtWjh6aUlXbWt6REwwMTVy?=
 =?utf-8?B?a0dOek5KdUE1Y3N2VEU3Z1JVYkNmSitVeVMxN00vdGhNZTRzTjVwNTE1R2di?=
 =?utf-8?B?b2JzaUdZc3BFSGJCYXo2bStsOFpRQlFPZlhVRkF6L3R6R1Ayb2ZxNGk1QTlV?=
 =?utf-8?B?Z0syUGl6UVNBQXJVWGMrUCt6UHBPNU90OFRTKzBMck5YcW94YVBCUnI0SzZJ?=
 =?utf-8?B?d0hEelNYa08xT1EyN3hKWjZucnBEZlV0T2FVaVBHTXpxNlBDcWpQMHdhd0lk?=
 =?utf-8?B?OHZheEk0RFBobUVCUkNTT0Q4ZmgwbzFOUG5Dd2NqM3Mrb2QyTUkxV0FueG5n?=
 =?utf-8?B?bWdDRVYvT3YxcTl0alBldS80dE5tRkZZT3QyakJYR2s2NyttTFpMWGY0NXBC?=
 =?utf-8?B?UllQaUMwM3BRTU9GYkFrOTQrNUZwd1ZkMTRueHkzSjRqN1BFQ1ZYSmwzZ1B0?=
 =?utf-8?B?dW13b0MyWk9EZE9LS2tkK21LTUNpbmxPWVVMdHU4dkQ4a3hENkNTdzZnZlFx?=
 =?utf-8?Q?3YfTCwjxF5vCaIoh+tv6eB8sOWuCbdOg/+vCBZz?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB7125.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cFhNV3cwRWp1Lzl4Q0VpS0VlNkNocE16dVV3cUtUcGE1aXpuQVdJOWtXV1d5?=
 =?utf-8?B?ZUV1SzVablJuOEFZUnAzQUltektKZ25MUGVGY2ZXM1lNSkI3bjJPMmFrd3FY?=
 =?utf-8?B?WmVVaXlZWHNiUkEvZmJkVUxsNFZpdk1ZcEZuWURyWFBqNzdkY3FSSmovdlUw?=
 =?utf-8?B?Q3gyZHpsK1N1MGcwN3pXL1RpZklYbFpkZk5VNmR5Q1hBK0I2d2srSUxZSzZY?=
 =?utf-8?B?cjJoNlo2UTdOMEI0L0NFN0gwOU0yRTF0TUQ2VHY5MERYbHpQNFh6cFZiaXJK?=
 =?utf-8?B?VEVYc01Pc0grQzdwcUNtWndXK3J3YW5QVmpWZEExemJwcGNQUVd5ZHhqMVJ0?=
 =?utf-8?B?VzJvWWh6OExrUlJCZnVNQ29XNURRR1pOYkdBY0I0NVc0UWc5WmRLWWNoYXlT?=
 =?utf-8?B?d2RyVVVBRWc1SVRrVHBQMmVLY29YQ1JpbTQ3QVhCSVNDYVN3VHpaTCs0OTIz?=
 =?utf-8?B?cXlxQUlodDdUay9Xa0w0UVVnVjJ4dDFMVTA3d3NNNUZzak5NeWVMejZWN0hw?=
 =?utf-8?B?TmNmL3UvdG9EUE50QkNHMzRqRldWMWtrS0VlQVNmV0RSYjRrSzBqWTlVQ2Qx?=
 =?utf-8?B?bnZZK2duZHZiRTZlTlhROFdxUkwzN0U4Vng4UllzK0NCYk1WYWVUR0VkSVJL?=
 =?utf-8?B?aUZKTVNpNjJHbmZRdVJhcGgvOFIvTFpBKzVGNXhBNnZ2R3RJZWtSL2pQcGRr?=
 =?utf-8?B?T2pqcE11cE4yMzZTVmlmVWNTSkp2cXRUYWRldnhCSEJQRjdNVUN0RVVtWGJ0?=
 =?utf-8?B?N3lQWE45eVozSlZZWXdtbnpUM0NocTJOYVNRMnBJRitUZCt4REJ4YW9kZmZB?=
 =?utf-8?B?K0dETEZVQzNKUzJjT1lEOGVzOXV1Um9oaGhUTDJyWVdycmU2d3hMZGV2cjB3?=
 =?utf-8?B?Tm43ZWZ0Rkh6dFMreUFQdGd4a2xRRU4vcy9kWW5Nbnk4cW5qVzV4czhXczgv?=
 =?utf-8?B?N2l1VGFWRnRrUDkxT0xKdW80ei90TTZScUFNWXhrbGowYVhJdzdtQUN1NUxM?=
 =?utf-8?B?U0NsNXVwb0FSSWJ0M3YzU1ZEb2o2MGJYejROR3o5ZFlMMXd2VjhCOXJoV2Q0?=
 =?utf-8?B?ZW5JeTF6WGJOeFJkMXQ5VkJxN0ozZWFhWkp3dlNQQ0hiUlVJdnRNOEdsOHlI?=
 =?utf-8?B?bzQ1WnMxekhkdk40cDFLdEY4UXdQM3B6WnorQXFaKzlTdHhjeXJ2b1NpRnh5?=
 =?utf-8?B?VjAyTHhRaTVsUG5nRHUxWE1FYkhpMDBWWDBvbGdneVBsUEduQUlMLzN1K3dD?=
 =?utf-8?B?UjgvZzZFdWdDN1lVVnllZzk1YmYwNGRQVU95dEZvbzlJUmllRmpMeWhuVnJX?=
 =?utf-8?B?OUkwR1d4K2ozSGpiUm5sOURONXlCbzk2OVJwQVYwd1hxNjZwT05oM0FqK2h3?=
 =?utf-8?B?clVmaForNVA2YWhjWGgrOUJHbzVueG9Sa01OZlRpL2VZTHpHMUVKTlZmNFRF?=
 =?utf-8?B?UWI4RnhubDcydjBzM213QTd1WEFSZklVeEtsd0hEbStzVENMRElUeWxZYnRq?=
 =?utf-8?B?R2pJY085NWJEOW11K042eTZKL2ZVa3F2MUEwOTdYbE9DZXp0eFlXNk90WWU1?=
 =?utf-8?B?Wk13YndCYkRySzRPK3p3MkpUcUpHMDlxWFg4Vyt4NUo1RHd1UE5TelJ1cmQv?=
 =?utf-8?B?QmtlK3U5SFFxVnQ0Unl0M3FaZkpnQmVqNk9uOURCMUtTN2krZU1FUzE0eXlJ?=
 =?utf-8?B?YWlhRzNZa0FLMDlBWHRkNk1rVmZVb2E5OURwVXdHN1N1ajI5VzNUbStzWmV3?=
 =?utf-8?B?ZHRkWXJlZHR0ZnU5VDcwWEo0ckc5NC96V0U2Rk5OVExObGtUd1h3cjk1cCtu?=
 =?utf-8?B?OTFORU1BaWtFQU84Z3VFOVhPaEJhY0Nsb0RGQ0tXNmp6cmgrYzlQaHA3L3pQ?=
 =?utf-8?B?ODhTOEVFN0ZnSlJ1amxmRXVSZlNlR0RXWlFjNGpqUEl4a1RtQ0lFcEo1Tkwv?=
 =?utf-8?B?VzI2Yno4ajhCaFV5WGliSDdiK1B5NGZYS2FFNXFPWGJKNnhFd0FrQnBhMzZQ?=
 =?utf-8?B?R3Uybk9TaUd6UVA2eEs3STFZczhRZE1yUC9BU2RjZVBlVXd0K21mL0luQ1d4?=
 =?utf-8?B?akxVVGVEandVU29Pdi8wd1FLQ3BaeGlqWXZqM2djYS9wMEdUTkE3Y1RONmZ1?=
 =?utf-8?B?US9uazM5dFRja1hMUkR1cVgweXhXRVBUTTVMVllVK2pCbllrdXZKQk5VL0Qy?=
 =?utf-8?B?Vnc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9EB0294ECBBF2C4996AA331A065C935E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB7125.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 616e6233-ec8e-4041-770c-08dc6e00606b
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 May 2024 19:11:47.6198
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CAwMI2YT2PoSpc/zXGTqxzih+B5lqBHxRsgfCWnSPSxfTRmPu3aYpbJve/eJUBNv3KaZONOyOS3OQ5ldWeIn09Jt7jnbfqOI0BU+5fkohwM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6525
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTA1LTAzIGF0IDE2OjU0IC0wNDAwLCBqbW95ZXJAcmVkaGF0LmNvbSB3cm90
ZToNCj4gRnJvbTogSmVmZiBNb3llciA8am1veWVyQHJlZGhhdC5jb20+DQo+IA0KPiBTdGF0aWMg
YW5hbHlzaXMgcG9pbnRzIG91dCB0aGF0IHRoZSBjYXN0IG9mIGJ1cy0+bWFqb3IgYW5kIGJ1cy0+
bWlub3INCj4gdG8gYSBzaWduZWQgdHlwZSBpbiB0aGUgY2FsbCB0byBwYXJlbnRfZGV2X3BhdGgg
Y291bGQgcmVzdWx0IGluIGENCj4gbmVnYXRpdmUgbnVtYmVyLsKgIEkgc2luY2VyZWx5IGRvdWJ0
IHdlJ2xsIHNlZSBtYWpvciBhbmQgbWlub3IgbnVtYmVycw0KPiB0aGF0IGxhcmdlLCBidXQgbGV0
J3MgZml4IGl0Lg0KPiANCj4gU2lnbmVkLW9mZi1ieTogSmVmZiBNb3llciA8am1veWVyQHJlZGhh
dC5jb20+DQoNCkxvb2tzIGdvb2QsDQpSZXZpZXdlZC1ieTogVmlzaGFsIFZlcm1hIDx2aXNoYWwu
bC52ZXJtYUBpbnRlbC5jb20+DQoNCj4gLS0tDQo+IMKgbmRjdGwvbGliL2xpYm5kY3RsLmMgfCA3
ICsrKystLS0NCj4gwqAxIGZpbGUgY2hhbmdlZCwgNCBpbnNlcnRpb25zKCspLCAzIGRlbGV0aW9u
cygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL25kY3RsL2xpYi9saWJuZGN0bC5jIGIvbmRjdGwvbGli
L2xpYm5kY3RsLmMNCj4gaW5kZXggZGRiZGQ5YS4uZjc1ZGJkNCAxMDA2NDQNCj4gLS0tIGEvbmRj
dGwvbGliL2xpYm5kY3RsLmMNCj4gKysrIGIvbmRjdGwvbGliL2xpYm5kY3RsLmMNCj4gQEAgLTcx
MCwxMSArNzEwLDEyIEBAIE5EQ1RMX0VYUE9SVCB2b2lkIG5kY3RsX3NldF9sb2dfcHJpb3JpdHko
c3RydWN0DQo+IG5kY3RsX2N0eCAqY3R4LCBpbnQgcHJpb3JpdHkpDQo+IMKgCWRheGN0bF9zZXRf
bG9nX3ByaW9yaXR5KGN0eC0+ZGF4Y3RsX2N0eCwgcHJpb3JpdHkpOw0KPiDCoH0NCj4gwqANCj4g
LXN0YXRpYyBjaGFyICpfX2Rldl9wYXRoKGNoYXIgKnR5cGUsIGludCBtYWpvciwgaW50IG1pbm9y
LCBpbnQNCj4gcGFyZW50KQ0KPiArc3RhdGljIGNoYXIgKl9fZGV2X3BhdGgoY2hhciAqdHlwZSwg
dW5zaWduZWQgaW50IG1ham9yLCB1bnNpZ25lZCBpbnQNCj4gbWlub3IsDQo+ICsJCQlpbnQgcGFy
ZW50KQ0KPiDCoHsNCj4gwqAJY2hhciAqcGF0aCwgKmRldl9wYXRoOw0KPiDCoA0KPiAtCWlmIChh
c3ByaW50ZigmcGF0aCwgIi9zeXMvZGV2LyVzLyVkOiVkJXMiLCB0eXBlLCBtYWpvciwNCj4gbWlu
b3IsDQo+ICsJaWYgKGFzcHJpbnRmKCZwYXRoLCAiL3N5cy9kZXYvJXMvJXU6JXUlcyIsIHR5cGUs
IG1ham9yLA0KPiBtaW5vciwNCj4gwqAJCQkJcGFyZW50ID8gIi9kZXZpY2UiIDogIiIpIDwgMCkN
Cj4gwqAJCXJldHVybiBOVUxMOw0KPiDCoA0KPiBAQCAtNzIzLDcgKzcyNCw3IEBAIHN0YXRpYyBj
aGFyICpfX2Rldl9wYXRoKGNoYXIgKnR5cGUsIGludCBtYWpvciwNCj4gaW50IG1pbm9yLCBpbnQg
cGFyZW50KQ0KPiDCoAlyZXR1cm4gZGV2X3BhdGg7DQo+IMKgfQ0KPiDCoA0KPiAtc3RhdGljIGNo
YXIgKnBhcmVudF9kZXZfcGF0aChjaGFyICp0eXBlLCBpbnQgbWFqb3IsIGludCBtaW5vcikNCj4g
K3N0YXRpYyBjaGFyICpwYXJlbnRfZGV2X3BhdGgoY2hhciAqdHlwZSwgdW5zaWduZWQgaW50IG1h
am9yLA0KPiB1bnNpZ25lZCBpbnQgbWlub3IpDQo+IMKgew0KPiDCoMKgwqDCoMKgwqDCoMKgIHJl
dHVybiBfX2Rldl9wYXRoKHR5cGUsIG1ham9yLCBtaW5vciwgMSk7DQo+IMKgfQ0KDQo=

Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57FED156243
	for <nvdimm@lists.linux.dev>; Fri, 15 Nov 2024 17:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731693533; cv=fail; b=Tsfh0GBtTtIw+qb89bcIN79f/TCkpPBmTIaCSeoRRY7sifF4l+CixRWIUsvytmOeixTz4iMiqjBwc8+gc+ot7TeT7aqe36hPJlFUWLHCBWn+yCNCtbcNVpV3LB65I1mry/wkkcBbnYi7X7WYqskjJkNVLlI80qsMTwx6EElXkYw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731693533; c=relaxed/simple;
	bh=QUQbtu7drnNXERsIVv88JBw/fbvHgA85FaHnv0QeFGI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=JtId4TTxK6ogziUv1WRMv9XmNS39RwLcY/lMF9zEABn/RS/7rySN32NvOUizW2fzwrNck+XKjZGqZTdoH4KQzK1+lv0X7hXuu02OYTB7KQ0t+/sBCcRTLqUNxDuU8Hn9SwA2iFQfBJaTCPAKxTENJcm+1mw/jI1PcctmPAOR5Do=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VFLzBl/C; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VFLzBl/C"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731693531; x=1763229531;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=QUQbtu7drnNXERsIVv88JBw/fbvHgA85FaHnv0QeFGI=;
  b=VFLzBl/Cbem/VZZNqud+lmwNS0jBpaxxzk3vxtaq7Wv0KUfH/TYMoIIP
   1ssrHzVN1pGMVDaehgiJH8Pd+4afSPfD8OQqgf3RePNe/w5bvMVPOszVY
   KkUILJCBFyY9brC5+kx6Z7pIU+SstVjWhJ2r+Gf1cVRdBsgcHhXf+h/mE
   9BFxzAkbmwuoci6RQFTK6NFbjTEOOOnXYktxTTUmNttYltafwtn6BJkRV
   Nb9O9zR2e6tZjETiLpNHHbpIcNZD4h/b0q18TnQyHBGvPqH9GT6jejSQu
   hwT/RoXga1Z6GU+l6OzIS4inIo/WTmYWEoQifSPeKxBA5DpFRrocDS00c
   w==;
X-CSE-ConnectionGUID: YOpXchQNTVSZznMtbLM8eg==
X-CSE-MsgGUID: HTGS/lI+Se+Iag1+OAiPsg==
X-IronPort-AV: E=McAfee;i="6700,10204,11257"; a="34579631"
X-IronPort-AV: E=Sophos;i="6.12,157,1728975600"; 
   d="scan'208";a="34579631"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2024 09:58:49 -0800
X-CSE-ConnectionGUID: KNVvn4bPS7+ydqxaqz5lQg==
X-CSE-MsgGUID: Oz3/HMAoQMeMr4IbF+FJqA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,157,1728975600"; 
   d="scan'208";a="126169169"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 Nov 2024 09:58:49 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 15 Nov 2024 09:58:48 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 15 Nov 2024 09:58:48 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.175)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 15 Nov 2024 09:58:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KK+TJZ8ddrSkVopzKVo9+Q7cRJiMthRVg+0LXj1e4h0BEdqKa70ijxRMeqmAJ/1pe1PnaR3V5BEHx74xzLx1rnZLAvl9EoM+R6eEwquNdoCCtc23daDM/eup23Se4mt2EsjgNgORx0ZN8vc1GHYHeHSdCvbeaAFzIXQ/mbcBUSK0qro+yBScAZkzNgkDIZwpj/u9u0jN/PPyr3Q58BmPvgagWR4sZlGDx5Nj9x2H0NHzab3LmQLQcCREwf5kXor0RJ0nrTnPV7q0lWXak8aPoYWXkG1cNM3q66rfpdcvbm9b5Wfh/Bo8DYlo5mlLR8t0YFTENpbRkJPwssprRKQxLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QUQbtu7drnNXERsIVv88JBw/fbvHgA85FaHnv0QeFGI=;
 b=r0b4hJU46/bfLc5PbsxFOtTDPLdPnU1lAek9fVcTzPMEGcAkxRXwfs7g3iVDoNQYxS5tINAfA+y7Wi6v0rW1k9V7ohZmFrrsWpcznuMHr2+iJYkXshJP5FM3qRmgdLZgJ87t2DpsbYEiZhVb7hJ2d2AH3kX+Xocf53Sa5QPUjmFcU3z9Tr1h8Oxm7rCsNCC/lWhFYFEji3TIarFhuVrjvLjWyehQwpLcK7c4ou/mXVM6trPb6gNhvSqP6aLRMMcA7bDZ573S/QX8K4oc4W6BLacBFRtD7peT/MKAXECDarg/481N8a+0yML9xRHHB0KgDUgwk6cYJFo3gU6Xw4JGiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB7125.namprd11.prod.outlook.com (2603:10b6:303:219::12)
 by SJ2PR11MB7669.namprd11.prod.outlook.com (2603:10b6:a03:4c3::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.17; Fri, 15 Nov
 2024 17:58:44 +0000
Received: from MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::eff6:f7ef:65cd:8684]) by MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::eff6:f7ef:65cd:8684%3]) with mapi id 15.20.8158.013; Fri, 15 Nov 2024
 17:58:44 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "kbusch@kernel.org" <kbusch@kernel.org>
CC: "Williams, Dan J" <dan.j.williams@intel.com>, "Jiang, Dave"
	<dave.jiang@intel.com>, "kbusch@meta.com" <kbusch@meta.com>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Subject: Re: [PATCH] btt: fix block integrity
Thread-Topic: [PATCH] btt: fix block integrity
Thread-Index: AQHa+x09ayIj4MsumkmxDSK9K/nMO7K3w1YAgAEp14CAACycgA==
Date: Fri, 15 Nov 2024 17:58:44 +0000
Message-ID: <c92b13460cdd6e7cc8b408116c4194ce1dc61ecc.camel@intel.com>
References: <20240830204255.4130362-1-kbusch@meta.com>
	 <eb557451f28668a7c8877322a5d5cb954fb6ac32.camel@intel.com>
	 <ZzdmZ6U3x8S2HLxX@kbusch-mbp>
In-Reply-To: <ZzdmZ6U3x8S2HLxX@kbusch-mbp>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.4 (3.52.4-1.fc40) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB7125:EE_|SJ2PR11MB7669:EE_
x-ms-office365-filtering-correlation-id: 6e3a52fc-5adc-4ad1-328a-08dd059f25b9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?dlpBL3lWMkNBTk54L1B5cjBmQk15V2ZDWmdPZWlTem9YVjd1LzFObjd1U3Vu?=
 =?utf-8?B?Q1V1NHVsSlVrNU5ZN1FEWmJjamFrWllBVU9vZUlJdzZIU041YU1wcVpCL3Bl?=
 =?utf-8?B?VmRZSjdRZkl3alVzdmY3Nk5QNW5WamJhWlU1cHpJemF3ZS95UGd4N2p3RFc5?=
 =?utf-8?B?Q0hqb1V1WjhKMGwwNnVJbkJSbXpNNG9CdEtqanNmdHVlZXpNUUw0T21lWVk0?=
 =?utf-8?B?QW1OQkJwZGJWN2FValRZbXhDbnc1dFhpbEF6YmNEZmU3ZGtGZldsUXpDMmpH?=
 =?utf-8?B?eGx2eUlKOSt5Ulp3Q2NsMzQ5Ylo3QTNHNzA0eHNTUG1ZTHBRb0VPbGxUdWRl?=
 =?utf-8?B?d0lGQVJUTUQrclB0OGdaVlg5UFhxamdON2YyL0dwWVd2eWJoRVhMWEQ4TkJD?=
 =?utf-8?B?VlliL3FEVjIwOXJYU2JlOWFQUHB3Y2hyQmJKb25EL2lxcTZIM3phUS9zcWx6?=
 =?utf-8?B?dGxkaEhQSGNsQkwzenRESjNrUjd2UG9keFY5aWoxcWxyL2tIK3hibW80bVB2?=
 =?utf-8?B?MDZIcVBENGVXUEQ5SlM4QnpwZ29qR0E4Wnk4dVhvL2ZrWEtRbHllWmVGQVpj?=
 =?utf-8?B?STFTZVVMak1XUW9mcStxMmRMMmRmNmFxYVlBMkJBZU9aWndSK1k2WXdBenFR?=
 =?utf-8?B?VUxZcUlWODFyN2wxTVRNbU1BMi9GNnZMMkQ3LzJ0Zkh6M0UyWk5qbm1udVdU?=
 =?utf-8?B?b2JNa29BVkF3R1d4eWRwcDBYYUhpVGQvUk1TMTFYVXY2UzBSaUlhRHg3UGNs?=
 =?utf-8?B?TE5aWllKWEVoSU5lZEVZRnFZUUQ1M1JpRThCZGFKSS9kdWRpbk1JdmZyZ2xz?=
 =?utf-8?B?ZSt3WHp2UmVreWkvRENMeU5CWThhcU94WjRtcFljcHhIbjJEbXduamQzZmVq?=
 =?utf-8?B?K21tcVBrejBPWWdFUXQwUmNRMEJkbFlxZXVjZmNMRGkwbkZNbHk4Z1lVM1ZH?=
 =?utf-8?B?TFVGSmZtS3UyNS9acVE3UUc3RlJqcWhJZWU4SDhFRi9sK0JlNm1WME5DRkZk?=
 =?utf-8?B?QVQ4L0IwRnRQUU0xTkx4em56ZHlPVXA1STFoNm1kMzNkczlQVm5KWE10TmN0?=
 =?utf-8?B?em9WLzNWbEozUHJtcjlpY3pHTjNkZ1crbkt6N21kb1RIT1FoV0V5VkhJRGRj?=
 =?utf-8?B?YUVaUXVnQnZRQjEvaUFWQzdyR0ZoY2I1Rk5zdG9mZUtEMkNSZnkvbzc5Zk5Y?=
 =?utf-8?B?NlFBVmk1ZXgweHVRN0xCaWdqdktjeVhzbDFVWmxIRDZWZmZSZkgyUXpBR0Vv?=
 =?utf-8?B?YlBFUnFjLzZlK0R3b0xmaTRsWUNVbnU4ejNwTlY1QktjK2ZiSTdtTmxCYmNx?=
 =?utf-8?B?N3RZa1Z0SUNzRkJ1ZmVMeXRBTE1XYlZHNG9uT24rMmhEckFQUkJwQUNjSmM3?=
 =?utf-8?B?SzV4ZzdZMmR3Rzl3eVVGbHlVOXlaSmRTQjVlajJLWlNzMXhzNE43TWVnRGV5?=
 =?utf-8?B?UlE3TTh2TDVsYTZXQ09HMXVTR2tCejNrenRsS1hKVGVSSjBZQ3E2azhXZkxM?=
 =?utf-8?B?aGNvYVViajd4Vm1yVk9mZnFrVHJwdWxZeW00WmFnNnNwczdEZCtHR2o4cWd0?=
 =?utf-8?B?MFRDUzE5cnduUmFHL0R1Y3V6d2M2d1laWnZlQUtZYW1raUJnRGxQZ3NrWWFh?=
 =?utf-8?B?K0Z3ZHZqUTJqNTZaTEV5ODU3NzQ3ZmxlamtFKytDRFBURTlOb25OZHArZjhh?=
 =?utf-8?B?dy9TUS85NmZsbG5zL0JJbzd2NmcvYk94SWJpNUVuckJWSDEwTEt3QTBYTTlo?=
 =?utf-8?B?ZDVDM1IrZUVMR0EwWUNwdWd1ejR4T3RuR09nN0ZEMGZQMUxWYk02NlVwZUhK?=
 =?utf-8?Q?GCTNA42ZajOt/DzZ7Qs3EAKpq+FzgNwX+qQzY=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB7125.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?V2dZVVNSamdVSU5VdUdNblRPU3VUMzY2RjNWMGoySTQ5c3djTExHTGV3Mk95?=
 =?utf-8?B?MjQzZytCSEJrWlJmS1BSY00vS0lMdHhzYlYrbmQvL3ZhUW1tWXppWFZxbnpa?=
 =?utf-8?B?eXZCRU4wcllOcWNSQ3N6SFNjdlA5ZGpYaFJKRlRaZmk3UE0vQ0V6Y3pQSG5I?=
 =?utf-8?B?c2EzUXlqN0FGQUlGd2l4ZHN4OUVIREtoZ1Z1NUt0c2k2WkpkTTB1UThaTEVV?=
 =?utf-8?B?SnR0dlQwa2VzVzAyekxGd3hHN05mNldwaXpDb1d4OHpNNUU4M1p4ZUZFVzRm?=
 =?utf-8?B?YzZKWXNYQmF6WWdoRXB1ZHlzSWRNVjlGSTRiNmFjV2Q2Ukx1dUtvLzZ6ajdG?=
 =?utf-8?B?NDRReUtBQmRHWFVGRkhJOGZ4N1lsbXRwbm43SFh3S2dZRlhualJlNFJoaTBT?=
 =?utf-8?B?N1RzUkQrRkZaYi9RTDhlSkd4NjRnMkNHTjhCcHJtamNSbU5VakxoMm1Lc0po?=
 =?utf-8?B?Uktlak5YcGdYRVJxMzBFUTRqdHk0OVBycUc5QTROOTZ4K3JaM1pMRWFtN3lK?=
 =?utf-8?B?UVp2ZzhwTGhjS0ZtdkpyTmJ5cWZ1cU9JbkxTcGdMZFNDWWZON2dmQkhEeDNL?=
 =?utf-8?B?ZWFtSWMvREZyS0pUTXZTUXBxR2p3c2FPRFdhaE1GRVBOQ0hQbjlyU0hIRmp0?=
 =?utf-8?B?d1FTRGxUMkh3ZWlXcnBDYjRDOTdMSWxSN3l5MDBjalo3M3k1ei82L0pLN1Fn?=
 =?utf-8?B?LzdDc1RBUEJTdVdCNm93RFlnd01RbFlWUmplNG82M2s0VzJMSEorTkRBUjBX?=
 =?utf-8?B?WCt5UWdjOGM3RGk3NTdOY3BRQlQ2RGE2YVdaSkRmWTVocE1IcmQ5bVpGdy8v?=
 =?utf-8?B?TURwTHJtdTFLSzFieWpBZXJQNFdaNU9vK0xBc3A3bkNiL1ROeTZEV1plV0to?=
 =?utf-8?B?Wm5OaExlejlVOTV5bGNzSURWbEZrTFRha2R4SGp1QmdqV293OHl5WVN4eVFq?=
 =?utf-8?B?bFBITkxNUkZudFZWdEhMdTU3a0E0NndiZ0o2WnZsbmIvTy94OGs0SVM4emRi?=
 =?utf-8?B?NXNoMGNBZUcxNjFVQ0hsaXF4T3FlUWs4YS9UQkRRaGxxeE9xcTE4UXk4ODNN?=
 =?utf-8?B?cWd4aEp0SEVMMzl0L0hjdmJYMVRCbUJ1UlZQdGVVamJnMS8wbk4rKzBhbmNX?=
 =?utf-8?B?Mk5SRW44YjBaVGVLTWpSOExwNEhjbWVJOFc0eTVkUGQ0TlJVbEZENXhSSlM0?=
 =?utf-8?B?cFhrR0JGTFozdk5ESXBDUks5eUwzSUt6eWpqaUNzK1FIMnVLU3FEVllCVzJV?=
 =?utf-8?B?eUt0RGRITkorRElXTmxIRTdjYWlXMmdkdTYvZXJGNUZaKzMwcm50WEsxQzA4?=
 =?utf-8?B?ZlByZE5IaXNBSFB2ZmFpZSthQVdwcnhXMmlWMEtGc3M2N0NYem1ESXhOb2xh?=
 =?utf-8?B?aGE1bU1WenZ0cUF0T0hSQlNLclpZR1A3UGlWMnI4cjR6d0R3V3MyRUZFMWtN?=
 =?utf-8?B?bXBoVkdoU2NZTzM3YlFMeU9KS2JCNFNrSWxCNmttWHo4M1pzUUV1VmtBeTF4?=
 =?utf-8?B?a0p5dnZSN2w3SG0yT0dNalZaTkt2S3BZaUxuaURSQk9EYkdkdWZpckFraWJ4?=
 =?utf-8?B?NXhvTklNT014cWdLM2lkb3JpRTA4STNsK1hoZzZGTzN0RTBVandOa3ZBTEdx?=
 =?utf-8?B?S21PUTRERkd2TWFjWEJLTDVINnpPNTdXRHVKWjJ0MG9nb1RmVGRPWGxvcmVl?=
 =?utf-8?B?cnN6Wkl3TDgyY0VvalBNNmdDMk5pdGRqOEJsMXhxTWpublZCRUhpV2ZDMzVO?=
 =?utf-8?B?K01PVklhbUJ4K1FpdHRLaEQydGRZVzFCeHgvRVB0ZStEZXdjYWMxa3lKek1Y?=
 =?utf-8?B?NERTd1lkUWJKdEx1alh0V2Q0dGhaSjFLUnVlSlprRVFERTlQUklzRjRNVm1X?=
 =?utf-8?B?Ly9LWExiNllMc0YrajlUOStDbG9tVk1DWFcxQU5Id2ZPQnhTNWtDVFd5NlQv?=
 =?utf-8?B?L0x1TkRBNTY4NVVUMGpVRnhqeHlBYWYwY1pLa3NkVjZrRnlVSW5BNzQ3K29X?=
 =?utf-8?B?cU9PVWhhemNFbExhYWVZRXBIWUdCSkF0MllHaldWK09TN3hISlJPcnUvQkRB?=
 =?utf-8?B?Ykp2M01aSU9IaFh5dUdONi9SeE1RRDBSV2hqTHBCbURuVHI4QUs1K0VmS2RN?=
 =?utf-8?B?b01ocHhpT0cxREFLdFE5VGIzaWczVVJ6RUpzZ0JtOTA3K2JPOWlLU3hIbVQ5?=
 =?utf-8?B?NHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0DD103B2E34CB54E8654DE630B8A13BB@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB7125.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e3a52fc-5adc-4ad1-328a-08dd059f25b9
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Nov 2024 17:58:44.6876
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BbCX+b3MgIaed5DPBjKM0ZgZnZWbFyYmTnQHGZOPSiUH4SsQv9kXzLJjRq85uaFBwKgxR9vaR1Rs4vWG6i3vgZWELL60vJQtzdkQ8fU7H/A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7669
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTExLTE1IGF0IDA4OjE5IC0wNzAwLCBLZWl0aCBCdXNjaCB3cm90ZToNCj4g
T24gVGh1LCBOb3YgMTQsIDIwMjQgYXQgMDk6MzM6MDVQTSArMDAwMCwgVmVybWEsIFZpc2hhbCBM
IHdyb3RlOg0KPiA+IEkgc3VzcGVjdCB0aGlzIGlzbid0IGFjdHVhbGx5IG5lZWRlZCwgc2luY2Ug
dGhlIGJ0dCBuZXZlciBnZW5lcmF0ZWQgaXRzDQo+ID4gb3duIHByb3RlY3Rpb24gcGF5bG9hZC4g
U2VlIHRoZSAvKiBBbHJlYWR5IHByb3RlY3RlZD8gKi8gY2FzZSBpbg0KPiA+IGJpb19pbnRlZ3Jp
dHlfcHJlcCgpIC0gSSB0aGluayB0aGF0J3MgdGhlIG9ubHkgY2FzZSB3ZSB3ZXJlIHRyeWluZyB0
bw0KPiA+IGFjY291bnQgZm9yIC0gaS5lLiAnc29tZSBvdGhlciBsYXllcicgc2V0IHRoZSBpbnRl
Z3JpdHkgcGF5bG9hZCwgYW5kDQo+ID4gd2UncmUganVzdCBwYXNzaW5nIGl0IG9uIHRvIGl0J3Mg
cmlnaHQgc3BvdCBpbiBwbWVtLCBhbmQgcmVhZGluZyBpdA0KPiA+IGJhY2suIFRoZSBidHQgaXRz
ZWxmIGRvZXNuJ3QgZXZlciB0cnkgdG8gZ2VuZXJhdGUgYW5kIHNldCBhIHByb3RlY3Rpb24NCj4g
PiBwYXlsb2FkIG9mIGl0cyBvd24uDQo+ID4gDQo+ID4gSWYgeW91IGxvb2sgYXQgdGhlIG9yaWdp
bmFsIGZsb3cgaW4NCj4gPiA0MWNkOGI3MGMzN2FjZTQwMDc3YzhkNmVjMGI3NGI5ODMxNzhjMTky
LCBidHQgbmV2ZXIgYWN0dWFsbHkgd2FudHMgdG8NCj4gPiBjYWxsIGJpb19pbnRlZ3JpdHlfcHJl
cCBhbmQgYWxsb2NhdGUgdGhlIGJpcCAtIGlmIGl0IGhhcyB0byBkbyB0aGF0LA0KPiA+IHRoYXQn
cyB0cmVhdGVkIGFzIGFuIGVycm9yLg0KPiA+IA0KPiA+IFNpbmNlIHNvbWUgb2YgdGhlIHJld29y
a3MgdGhlbiB0byBlbGltaW5hdGUgYmlvX2ludGVncml0eV9lbmFibGVkLCBhbmQNCj4gPiBvdGhl
ciBibG9jayBsZXZlbCBjaGFuZ2VzLCB0aGlzIGhhcyBjaGFuZ2VkIHRvIGFjdHVhbGx5IGFsbG9j
YXRpbmcgYmlwDQo+ID4gYW5kIGNvbnRpbnVpbmcgaW5zdGVhZCBvZiBlcnJvcmluZywgYnV0IGNv
aW5jaWRlbnRpYWxseSBzaW5jZSB3ZSBhc3NpZ24NCj4gPiBiaXAgYmVmb3JlIHRoZSBhbGxvY2F0
aW9uIChpLmUuIE5VTEwgYXMgeW91IHBvaW50IG91dCksIGFueSBmdXR1cmUNCj4gPiBzdGVwcyBu
aWNlbHkgaWdub3JlIGl0LCBidXQgaWYgaXQgd2FzIHNldCBieSBhbm90aGVyIHN1YnN5c3RlbSwg
dGhpbmdzDQo+ID4gc2hvdWxkIHN0aWxsICd3b3JrJyAtIGFzIGluIGJpb19pbnRlZ3JpdHlfcHJl
cCgpIHdvdWxkIHJldHVybiB0cnVlLCBhbmQNCj4gPiBiaXAgd291bGQgYmUgbm9uLU5VTEwsIGFu
ZCB3b3VsZCBnZXQgd3JpdHRlbi9yZWFkIGFzIG5lZWRlZCwgYW5kIHRoaXMNCj4gPiBpcyB0aGUg
aGFwcHkgcGF0aC4NCj4gPiANCj4gPiBEb2VzIHRoaXMgbWFrZXMgc2Vuc2Ugb3IgYW0gSSBtaXNz
aW5nIHNvbWV0aGluZz8NCj4gDQo+IE9uZSBvZiB1cyBtaWdodCBiZSBtaXNzaW5nIHNvbWV0aGlu
Zy4gOikNCj4gDQo+IFRoZSBvbmx5IHVwcGVyIGxheWVycyBJIGZpbmQgdGhhdCBwYXNzIGFuIGlu
dGVncml0eSBwYXlsb2FkIHRvIHRoZSBsb3dlcg0KPiBsZXZlbCBkcml2ZXIgYXJlIHRoZSBzY3Np
IGFuZCBudm1lIHRhcmdldHMuIEl0IG1heSBtYWtlIHNlbnNlIHRvIHVzZSBidHQNCj4gYXMgdGhl
IGJhY2tlbmQgZm9yIHRob3NlLCBidXQgaXMgdGhhdCB0aGUgb25seSB1c2UgY2FzZSB0aGlzIHdh
cyB0cnlpbmcNCj4gdG8gZW5hYmxlPyBPciBpcyB0aGVyZSBzb21lIG90aGVyIHBhdGggSSBkaWRu
J3QgZmluZD8NCg0KUmlnaHQsIHRoYXQgd2FzIHRoZSBvbmx5IHVzZSBjYXNlIHRoaXMgd2FzIHRy
eWluZyB0byBlbmFibGUuIEknbSBub3QNCnN1cmUgYnR0IGNhbiBldmVuIGJlIGEgYmFja2VuZCB0
byBzY3NpIG9yIG52bWUsIEkgdGhpbmsgb25lIHBvc3NpYmlseXR5DQpjb3VsZCd2ZSBiZWVuIHNv
bWV0aGluZyBsaWtlIG1kLCBvciBzb21ldGhpbmcgbW9yZSBjdXN0b20uIFRoZSBnb2FsDQp3aXRo
IGJ0dCB3YXMgdG8gcGFzcyB0aHJvdWdoIGFueSBpbnRlZ3JpdHkgcGF5bG9hZHMgaWYgaXQgZW5j
b3VudGVycw0KdGhlbSwgYnV0IG90aGVyd2lzZSBub3QgZ2VuZXJhdGUgb25lIGJ5IGl0c2VsZi4N
Cg==

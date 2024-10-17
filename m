Received: from esa6.fujitsucc.c3s2.iphmx.com (esa6.fujitsucc.c3s2.iphmx.com [68.232.159.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EA4C17580
	for <nvdimm@lists.linux.dev>; Thu, 17 Oct 2024 03:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.159.83
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729135893; cv=fail; b=rdEU2+1os7TFhpFgWf+urkpSmzsSnJKJh2d3M6ScCsMkMTZbkemp7iQMMbA++dhmDr6QwMsr9KMVyfRtKDX9E57YoN0eg0NkLrfpfFzBgYkqUlPeIYFYRKQxkg+fSr5kU2YdTvWWogy+9AtBj6AlNfr1pdkWdyj8AQnnQwWsPqE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729135893; c=relaxed/simple;
	bh=SPL4B7BMsoJBZe/glCgoKjsMTEaigbCJbj28Dhm79eA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=c8gpw9IHpeDPOE8fSZ4/EtiAujT3co+ZQFLRhFCLu5B/ViPYU4WkMwI4p73yMhrTgB5F643n5NMSRB8CNnI2/3iaANVLe9SpcmIXjbD5EQLTA9cCBLiGOZx8U2dwxD3hKLLQAfUrqzAi63G/6Ki4GDi5MWdnXicZ5hjZaNB1iFk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=KzHzzzdu; arc=fail smtp.client-ip=68.232.159.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="KzHzzzdu"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1729135889; x=1760671889;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=SPL4B7BMsoJBZe/glCgoKjsMTEaigbCJbj28Dhm79eA=;
  b=KzHzzzdup7+OyQRDkhm3YCPqQx+bchkPxJ4j57tI3SBhpz85jonz+6+R
   TH/TGefdLrUrAAOYS0In9pJi0MivQ/ZgVCsltYTfA+nrbLdY0sdzBzuq7
   +NE0VCKNAD5kAzwWxva0v2JzI7vH8fZRqWPJKjNdeVDGM9OOnqhwMoraJ
   K7+RfPTzwXtyWQFtY3QAkD8/0wmNUI+GPfUbKJq0cExrn+IflBZEwpovl
   kg4FuT5nD/neNI0L3YHd/PQnglanQpPMFGzpJhd24Q+TDS+F5AMocVIDB
   0612JIAEoqTTVPjPQdviyLxfLgwHQuEmvwUWRPAD5Sw+roJS7rm82wAFi
   w==;
X-CSE-ConnectionGUID: hazbCtseRFiYlI+4sqSwPw==
X-CSE-MsgGUID: QQ2wqJZ4SeKt12jO5chlfg==
X-IronPort-AV: E=McAfee;i="6700,10204,11226"; a="133920477"
X-IronPort-AV: E=Sophos;i="6.11,210,1725289200"; 
   d="scan'208";a="133920477"
Received: from mail-japanwestazlp17010005.outbound.protection.outlook.com (HELO OS0P286CU011.outbound.protection.outlook.com) ([40.93.130.5])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2024 12:30:17 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v5Lt5fQMI9rPuDkY+eFWQgMaCdaIX/3p5zQ0keIKCyoGE633Et7SriVKocQl5OTFFYcxU14/AT/yKHYx4WRvqcfMTC5pPlHPeirAURMcmNgRholwnIFLE1xv2hrA/h78G3IJou3ntHj5vzTH/D+hWAvGmwmWt2Ks3sOIagZiSFpeAIwWtU5l2gio5EPUq4ppU15kIcFpUNZtSo+a9mlwRGmZHP4bJbZMeqSwwv2I80LXw4e+wZ7aSlIIjymGc1gsxWmRo+zIZ7EYuNv5LAuFG273cg3ppbK2TioHwsUea+x90TVPVbs/sqfRbn2nngJRnWtdHx0cj1KJe9BPkBIplA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SPL4B7BMsoJBZe/glCgoKjsMTEaigbCJbj28Dhm79eA=;
 b=DTyMVsKaDs1sdYS1ip1U6X7EnDDNAi/i9XsxF59Q9Kp8u0GvWyJ6udTUZ+hIISa8DdRTMKwUxJ6wbxI8XQxvf8MD1lXJln+TYAzF19DgwKNHFJi+XzopUwuQYlurGM1fybcKrAOemEnYyagYzl7eTuUnrv321j/1IVhfCy9i429jBJA7KQVWGj0fhaXdX/oYvHdU14nQSRJUFnErf5HUO3uiBjVSnEbMMu5zb7bMMcJO9QwnG4qmPMuwZy5FETM80yT7yg/wvwHGGnd5sBLJPnNsUw2Q75a47mKkEIyMhJ0JoCMx1IxibBLsO9MJi+UmF1lhUuR5W90PW6zuESEs5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
Received: from TY1PR01MB1562.jpnprd01.prod.outlook.com (2603:1096:403:6::12)
 by OS3PR01MB6626.jpnprd01.prod.outlook.com (2603:1096:604:10c::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.18; Thu, 17 Oct
 2024 03:30:13 +0000
Received: from TY1PR01MB1562.jpnprd01.prod.outlook.com
 ([fe80::d9ba:425a:7044:6377]) by TY1PR01MB1562.jpnprd01.prod.outlook.com
 ([fe80::d9ba:425a:7044:6377%4]) with mapi id 15.20.8069.018; Thu, 17 Oct 2024
 03:30:13 +0000
From: "Zhijian Li (Fujitsu)" <lizhijian@fujitsu.com>
To: Alison Schofield <alison.schofield@intel.com>
CC: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>
Subject: Re: [ndctl PATCH v2] test/monitor.sh: Fix 2 bash syntax errors
Thread-Topic: [ndctl PATCH v2] test/monitor.sh: Fix 2 bash syntax errors
Thread-Index: AQHbH4sQWHCzI/m/OkmDEAzANZAKhLKKIMkAgAAp3QA=
Date: Thu, 17 Oct 2024 03:30:13 +0000
Message-ID: <daaa02b8-a9c7-4644-a47e-476641a7dd8a@fujitsu.com>
References: <20241016052042.1138320-1-lizhijian@fujitsu.com>
 <ZxBhpCc-HrzbeILd@aschofie-mobl2.lan>
In-Reply-To: <ZxBhpCc-HrzbeILd@aschofie-mobl2.lan>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TY1PR01MB1562:EE_|OS3PR01MB6626:EE_
x-ms-office365-filtering-correlation-id: 2e31d366-3430-4f67-b750-08dcee5c030d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|376014|1800799024|1580799027|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?YmtuS3llaFJKVloyOVhBY0ozOHhaS3RyZjd3aytCS1F6d3hST2ErSkMraVZO?=
 =?utf-8?B?MDFYV2FSTis1WXhzWm90aGdMSkVNaGxSNkFHZE1neENiamVZUkl3YkJLTVJa?=
 =?utf-8?B?bEF1T094UEZaZ0NZazFqaTBMQ0dTUTZoMmtCTUlVTXFoRlRBM2pHTzg5MVJU?=
 =?utf-8?B?WU50bEQ1OWtwU3VMeW52LzkyQWY4ZVNleWNidUowSjNCOFMyaU1Lei9jaU9a?=
 =?utf-8?B?eUMzSEFlTTdkMzR2MGxmbGVoc1p0V3M1S1N1NERTc0FnSWlGdnVzOU1laE4z?=
 =?utf-8?B?SlNwU3NHRDRyaENxUzNGRVFKWU5IL29SajNiaTRxQnBRaVlQNFdSWlRGazZz?=
 =?utf-8?B?eG4remdVU2NMOFRYNEw2a2p4TTBNdFl6UXRkU0dLMmxCWXQxUWtVbGRXR3k3?=
 =?utf-8?B?SkVXaFlIa3B3UkZwd0p5ZDV3aEE1bFBVbGpZNS9USEUrUFcxRjNIblZCcEto?=
 =?utf-8?B?anN1QnhDdjNCTzE1NTdSLzY4WmQwdGNqV3I1MXcxbXBrTzltNWlnWU0rMEVt?=
 =?utf-8?B?YlR2SGJLMmVHRVR2aTd1cmpFQWlZVTQzSlUybU9zbUc2L0txckd3aTlLdW1J?=
 =?utf-8?B?dkgvaU5PUHRza3N3ZndNd0kycW85S1k3b1lsc0NmTlVQVGRWR3JKRFN3TnpN?=
 =?utf-8?B?cHRnQUdkc29DYVFLamdEUTlNc2JxWEIxWFZJcThqYjhuTS8ySWgvODZ5SjFs?=
 =?utf-8?B?RTliY3Z0SXRXYjErdTJtZFU5cnN1UCtFYjZxSjJvVFZheWQzeE5lcER1Tksr?=
 =?utf-8?B?RWxKRHhRNWdSUU9nN0tTUmliWGRUZ2pmOEtESjFqQlY1VCtpeVNlY2g2eWRP?=
 =?utf-8?B?MDU4RFhaZHo1Q1RxdG02R1lBaFp6dDIyQWJBQ0tLV1Q0aHpJU3ZwRXlnOGxB?=
 =?utf-8?B?UTZqVW9MdlVIdVJFTTl0M3doT0d1ZkVndUhxTXlDSzkvUm5BK0xramYyNUQy?=
 =?utf-8?B?aGRCM2FNNWdsMFNSNFI1QjV1RnBrUzcrVUZYMFpJaGI4cUZPNStmMmV6a1E2?=
 =?utf-8?B?ZlhxejZIK1JnZDQvK2tKM1U4dU54N0ZHVnhDN3NJTEhjMUZKSklNUDlKT01J?=
 =?utf-8?B?U0UyLzZlb3pQMkVtMmt2TXlzOEhMRTVUVjdzaU5DQ2NjSGVNUFRoL3g0Ly9X?=
 =?utf-8?B?Q29rZlNhaXZIR1hRQ3E3MEptVEU2RHBsOWI0Qi9DWXA0Wk13bFhjMmFVRlZN?=
 =?utf-8?B?S0tzS3F3UXBmd2pLRXBNd0pIdzhhOVZGeVJQWHpMU29yYmd2b0pUTmo1Lzcz?=
 =?utf-8?B?OW1ocDk2ZlQvZTExaFFhbm93eXdrbzZScklCcEc0bzJmS0RiM2gxejAyb1Jm?=
 =?utf-8?B?ZUUyRm4zR2h1N0xlR2NEalNSQTYvd0c0aFlubDA3VG9BVk53Zm1PZGlOM2RJ?=
 =?utf-8?B?V0lhVEl6UnN6U25CbWtZcFVQWGxwcVJ1VitTUnZVQ3BQWGJyTUhOY0Q5alNi?=
 =?utf-8?B?b3FxRFJGTmgxY25sMHl6MnBhUjV4WHJOdCtFalM0Znp2LzRoVCtiSjlmN0xG?=
 =?utf-8?B?S1FSVHhUa0hnNnRWRHNxcWVhTHJtT3d2d3Y5RFVIK3N5dzFIRXpESGU5UUZo?=
 =?utf-8?B?UzljNDZLRnIySVFqYmN2MEZNWEE1UU5kamhmV0c2SWczM21BeWtlWDlsa3Bk?=
 =?utf-8?B?M2tUSmVpWjJZQURyQUVVejdqb3lCM0E0NmJ6TUN0TkE1aVJYS0FCRmN5VVF3?=
 =?utf-8?B?OGtiakE4dHFWMzdTak5pZWtFWXcyS04xTUdHRnV2Y09jRDZzSXBqc2dLZ2cv?=
 =?utf-8?B?eGprMGNUckNESGlVZTRrdDBOQ2VtK25ES2xGaC9hU3lFaEJaWWxsdVd3Wjk1?=
 =?utf-8?B?NExXVGg0SzFFU002LzloR0VOenRVcWxwcjkxaUt5aVovNUlvcERwNEVTYUJw?=
 =?utf-8?B?REU5NnQ4ZVQ1bTRNOVV0eEFJclJ2R3k2RWUzMGNGSmxjdGc9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY1PR01MB1562.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(1580799027)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?VmZmYm9SMTVWNGdqamhTSUZyNlJqdklxMHRBT2VUS3VBVXZZbElLYkhySmcv?=
 =?utf-8?B?TVdLanU5QU9CRER2azdWUTZTdHlVUStmZHlzdFVRY1dwbXhPZk8rQjd0Q2JY?=
 =?utf-8?B?NkI3UXJKTnV2R0xxOUFHWjhZUGpZenRoc2IrTXNYd1Y2SGJ2ZytsY01BKzRT?=
 =?utf-8?B?VVNuTXhIdHBYRy9RYngxbkpnUXBISTlGRFN6Q0xvQXlmL29jR1BMN0FIWkpP?=
 =?utf-8?B?WENtM1VaTVJJVDNxTFpSaHJYYTRzSndKc2xQRHp6V2QzZkg3dXU0L0t6cHVW?=
 =?utf-8?B?c3o3SjBoNU9UeEovUGxibWpjb2V1ZG03OHVISm1MTDFaU1FHR0NCMHlFTnVI?=
 =?utf-8?B?MnBjb1R6b0RiZlhpaDlTT0EvZkcrY2hSU0VqcTlVYUlzR1N0YmNrNEYyMnh0?=
 =?utf-8?B?SThVWE5wZUZrMTViVFNmR1Y1djBHYkYzd0tyQzNrN3JTcGVNbldER0FINHg1?=
 =?utf-8?B?R2xLTDJYZFZKVU1tRis2MHB0czI5MWxPdUFQd1Z3VzRtK3o2U0Npand0Ulgv?=
 =?utf-8?B?WmN0Q0VVblhKemdpRkt0SjZGS3U0SUpNaVYzMzhaeHdnMFZvanR1WjNjZHNz?=
 =?utf-8?B?bytWZjJiSWl3b25BZE5JZ1BTdDk0VEJDa1ZmZXFCN3ZxbWMvcnB4MnFsYjNm?=
 =?utf-8?B?N2IyOWlzRHIwM09UYnpjVXJudmI1VWp0V0VlYWtDcHhDQjNLcW9YbnNjTXdV?=
 =?utf-8?B?SkhJQWtlQWthcS9DU3BESXRsOHM1aEVTZ1RDV05xdUx5WjFXelp1cjAxdlRz?=
 =?utf-8?B?RXFEaDFOK2RTYjlEcnBxMXJWTlovTzFGdlIydjVYd0Y5cTAvUlJXRGd6VDRp?=
 =?utf-8?B?M0NnRDJmSlFROTkwZjJ2RXBxQ1VrUi9PT1lCRFB6N01qek9lMkJSd092M0xB?=
 =?utf-8?B?M20ycmlpVS9acG9RR0dDMWdPc1IxUXMrQks2YkJyOURROHIxWEJXTFVTeXRw?=
 =?utf-8?B?K1h1QlJoT3Y5UlpkMkc4WnNYTVhzRDBpdVNmUFl6czlsYUpTcnMrTENpYlhG?=
 =?utf-8?B?YkN0MFZMTStCYzd6akRWK01oVlQ5MFBNRkh2Q1l6MmFCdW1JWWZ6NVlOeXBM?=
 =?utf-8?B?WEE3STFsNEdBeFh6M0RSQnk5ME1xNmZONWFMaTZLbHpNUGF6TUhhZ1NEUGd1?=
 =?utf-8?B?cHBDTHJ6ZUtYMTRKOHRDaXRacVltV09YUldLeWNMZVNsQlpkWFFtNHcwb2VQ?=
 =?utf-8?B?azByeldMV1RPVVh1NmpTMzJORDFkN3hZWXYrOXZuQlpML25FTDR4M0dLa0lp?=
 =?utf-8?B?cjFNSGRNaEFscHN3a1BNYXk4VWxzZ1p2d0dDc1A2UXVNeXhOUVFOdStSOENN?=
 =?utf-8?B?VVlwOENrYy8rWkZGZWROSkZCVTJaU09TMFlUblRmNFFlMlBrSmpUV1pkRTBh?=
 =?utf-8?B?UlBpWUxJTlpxS01wSWhkM3lrS09QcllJQ0RmdS9qWmNmMUJVa3lwQTE3eUpk?=
 =?utf-8?B?Z3JsdlFOMEdkclFPUGZSRnZXSTJVbTRmdjhqcjdEcENqVVM4S0tqVzRJQlNp?=
 =?utf-8?B?dllvTzBEVHJlb3ZJSStrQXZhTnBOMW8xRHhNbFFWZUNiczJCQVdzd013SU1G?=
 =?utf-8?B?ejgydmZFVndtZGphR2U0bzB4VGcyaUZibnVrMzkwbnQ5UFJEdTVFam1MdGt4?=
 =?utf-8?B?SkVFQlFMYXlEZUFyRHZyeWhvbElpTy82dVRkMVMwSzRQK1RPOW01bzZ4NitO?=
 =?utf-8?B?NFkzVnF5Vk55eFdBUEZXaDJLcFBodkpHZFAxMUVsbEFEMHJjcktoNzNCRE12?=
 =?utf-8?B?eTJMUk44d2NwTm9nTE5vQllBS04za3puazdVNmtEcEdvamE0N3krSERPK0t4?=
 =?utf-8?B?RElkTElGT0liMU9MOXRPbDZGYlZuVlc5cFROblhwdUFLd0tBRmZlUzRxd1JB?=
 =?utf-8?B?b1ZYWk41WTI3M0o0QzdvMzY5VzNmZDJEU1grekJJQ1dIUmZaeVF0ZEhlSmlR?=
 =?utf-8?B?dFpxdU5UakZmWDhkZTdQc3BYYytOZGRFQmloR1BjbWk3cUpiNWoxSXFXeWRO?=
 =?utf-8?B?RDVJOWJEY3dzeHdrWkFHS21wSnpJN2E2bnJRUEs4R0hpQjRaNWVldXFUamtI?=
 =?utf-8?B?N2J5Qk53WUxQMzgxT3lwYzdTcklKNFF1T1JMNytDVVcyWWFsQ0VaVnlsTFEx?=
 =?utf-8?B?Ym1iNHFrY1Z6WnNjZjE3dVZJWHpoY2xDNXQ1S0VLdXpQVWZvbDQvL2JuZ1hq?=
 =?utf-8?B?VGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FDAE72E9D0310B4FB9032A5DB16D3308@jpnprd01.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	lHXY/jbeRXKeIhiwpTTuNO/Kk89Lbg9mK1Gt3ZIHvPNsW3Mx5ccPLjumbQ+7Go1R+3gcnQPBpJgImuaAxlqqOEdYusTGdMV76UiugFNZj4pkSaE5nhBYwuNME3C8Yvbx5sYJzVeHnLZwAU4CIqdIjYggT+CNBPpOujx6x4oSlAUw1rK72Pkc24MB/hmNt0r0KWf+o51mWAfpg+8FGtelveJNqZlD8RDmJQhw1JQiyZI7p2qCV8T6URmGketEQEGRDj3du0jZ9A5NzMOeh1e2slnfnBNFhUB1GhJ45JemQ99EojJk3izXInwBg9iXZ1m32IWBoHQuR6TlRyxspWpnXTxO4GYaRsO/SMAlVmgyhKmHPkoGPXMYPxLFzZrePZsWV36ecCq9l7XP2UxxIfXz6zBhKCHhu9ed3Sm/iXuZOJJrCfHHdUVySZIJNSy4TKgjPvpWKGdT76825XE0iDtT8acAjCAYf4AMbH0SOq6kLj3fyaCZC9azv6gJJbGqL9v4ZQvW+8erESvESf11v+7+ivTfqyZ+JkLr8KAXy6t7NL2xrOT7GxJZHLqioDkiRvP8OQyxuR2Ref2JFWiVsq9tk/veI9pTANNcN4M+bbjFQMO0lhNhIuwDyNeXRbjW4hD5
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY1PR01MB1562.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e31d366-3430-4f67-b750-08dcee5c030d
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Oct 2024 03:30:13.5290
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ipamZZg4pz9INhe9vD/gOh1RwdZ1P6LaxgXZEqrvMY+nOr4hRzzxNoMoCdvHVYHSXTFzFiKQa0RnCQUP0dvfRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3PR01MB6626

DQoNCk9uIDE3LzEwLzIwMjQgMDk6MDAsIEFsaXNvbiBTY2hvZmllbGQgd3JvdGU6DQo+IE9uIFdl
ZCwgT2N0IDE2LCAyMDI0IGF0IDAxOjIwOjQyUE0gKzA4MDAsIExpIFpoaWppYW4gd3JvdGU6DQo+
PiAkIGdyZXAgLXcgbGluZSBidWlsZC9tZXNvbi1sb2dzL3Rlc3Rsb2cudHh0DQo+PiB0ZXN0L21v
bml0b3Iuc2g6IGxpbmUgOTk6IFs6IHRvbyBtYW55IGFyZ3VtZW50cw0KPj4gdGVzdC9tb25pdG9y
LnNoOiBsaW5lIDk5OiBbOiBubWVtMDogYmluYXJ5IG9wZXJhdG9yIGV4cGVjdGVkDQo+PiB0ZXN0
L21vbml0b3Iuc2g6IGxpbmUgMTQ5OiA0MC4wOiBzeW50YXggZXJyb3I6IGludmFsaWQgYXJpdGht
ZXRpYyBvcGVyYXRvciAoZXJyb3IgdG9rZW4gaXMgIi4wIikNCj4+DQo+PiAtIG1vbml0b3JfZGlt
bXMgY291bGQgYmUgYSBzdHJpbmcgd2l0aCBtdWx0aXBsZSAqc3BhY2VzKiwgbGlrZTogIm5tZW0w
IG5tZW0xIG5tZW0yIg0KPj4gLSBpbmplY3RfdmFsdWUgaXMgYSBmbG9hdCB2YWx1ZSwgbGlrZSA0
MC4wLCB3aGljaCBuZWVkIHRvIGJlIGNvbnZlcnRlZCB0bw0KPj4gICAgaW50ZWdlciBiZWZvcmUg
b3BlcmF0aW9uOiAkKChpbmplY3RfdmFsdWUgKyAxKSkNCj4+DQo+PiBTb21lIGZlYXR1cmVzIGhh
dmUgbm90IGJlZW4gcmVhbGx5IHZlcmlmaWVkIGR1ZSB0byB0aGVzZSBlcnJvcnMNCj4+DQo+IA0K
PiBHb29kIGV5ZSBmaW5kaW5nIHRoZSBjb21wbGFpbnRzIG9mIGEgcGFzc2luZyB1bml0IHRlc3Qh
DQo+IEknbSBjb25mdXNlZCBvbiB3aHkgdGhlIHRyYXAgb24gZXJyIHNwZXdlZCB0aGUgbGluZSBu
dW1iZXIgYnV0DQo+IGRpZG4ndCBmYWlsIHRoZSB0ZXN0Lg0KPiANCj4gV2hpbGUgSSwgbWF5YmUg
b3RoZXJzIGNoZXcgb24gdGhhdCwgdGhhbmtzIGZvciB0aGUgcGF0Y2ggYW5kDQo+IGNhbiB5b3Ug
ZG8gbW9yZSA6KSAgPw0KDQpTdXJlLCBJIHdpbGwgZG8gdGhhdCBsYXRlci4NCg0KDQo+IA0KPiBC
eSBxdW90aW5nICRtb25pdG9yX2RpbW1zIGluIHRoZSAteiBjaGVjayAoWyAhIC16ICIkbW9uaXRv
cl9kaW1tcyIgXSksDQo+IHRoZSBzY3JpcHQgYnJlYWtzIG91dCBvZiB0aGUgbG9vcCBjb3JyZWN0
bHkgYW5kIG1vbml0b3JzIHRoZSBmaXJzdCByZWdpb24NCj4gdGhhdCBoYXMgRElNTXMuIEkgZG9u
J3Qga25vdyBpZiB0aGUgdGVzdCBjYXJlZCBpZiBpdCBnb3QgdGhlIGZpcnN0IG9yDQo+IHNlY29u
ZCByZWdpb24gb2YgbmZpdF90ZXN0LCBidXQgdGhlIHN5bnRheCBpcyBkZWZpbmF0ZWx5IHdyb25n
LCBhbmQgaXQncw0KPiBlcnJvciBwcm9uZSBpbiBtdWxpdHBsZSBwbGFjZXMgaW4gdGhhdCBzaGVs
bCBzY3JpcHQuDQo+IA0KPiAnJCBzaGVsbGNoZWNrIG1vbml0b3Iuc2gnIHNob3dzIHRoZSBpbnN0
YW5jZSB5b3UgZm91bmQ6DQo+IA0KPj4+IEluIG1vbml0b3Iuc2ggbGluZSA5OToNCj4+PiAJCVsg
ISAteiAkbW9uaXRvcl9kaW1tcyBdICYmIGJyZWFrDQo+Pj4gICAgICAgICAgICAgICAgICAgIF4t
LSBTQzIyMzY6IFVzZSAtbiBpbnN0ZWFkIG9mICEgLXouDQo+Pj4gICAgICAgICAgICAgICAgICAg
ICAgICAgXi0tLS0tLS0tLS0tLV4gU0MyMDg2OiBEb3VibGUgcXVvdGUgdG8gcHJldmVudCBnbG9i
YmluZyBhbmQgd29yZCBzcGxpdHRpbmcuDQo+Pj4NCj4+PiBEaWQgeW91IG1lYW46DQo+Pj4gCQlb
ICEgLXogIiRtb25pdG9yX2RpbW1zIiBdICYmIGJyZWFrDQo+Pj4NCj4gDQo+IFRoZXJlIGFyZSBh
IGJ1bmNoIG1vcmUgaW5zdGFuY2VzIGluIG5lZWQgb2YgZG91YmxlIHF1b3Rlcy4gQ2FuIHlvdSB0
dXJuDQo+IHRoaXMgYXJvdW5kIGFzIGEgbmV3IHBhdGNoIHRoYXQgY2xlYW5zIGl0IGFsbC4gTm90
ZSB0aGF0IHlvdSBtaWdodCBub3QNCj4gYmUgYWJsZSB0byBnZXQgcmlkIG9mIGFsbCBzaGVsbGNo
ZWNrIGNvbXBsYWludHMgaW4gdGhlIGJvaWxlcnBsYXRlIG9mDQo+IHRoZSBzY3JpcHQsIGJ1dCBz
aG91bGQgYmUgYWJsZSB0byBjbGVhbiB1cCB0aGUgbWFpbiBib2R5IG9mIHRoZSBzY3JpcHQNCj4g
YW5kIHByZXZlbnQgbW9yZSBwcm9ibGVtcyBsaWtlIHlvdSBmb3VuZCBoZXJlLg0KPiANCj4gSSds
bCBzdWdnZXN0IHR1cm5pbmcgdGhpcyBwYXRjaCBpbnRvIGEgMiBwYXRjaGVzOg0KPiANCj4gMS8x
OiB0ZXN0L21vbml0b3Iuc2ggYWRkcmVzcyBzaGVsbGNoZWNrIGJhc2ggc3ludGF4IGlzc3Vlcw0K
PiAyLzI6IHRlc3QvbW9uaXRvci5zaCBjb252ZXJ0IGZsb2F0IHRvIGludGVnZXIgYmVmb3JlIGlu
Y3JlbWVudA0KDQpTb3VuZCBnb29kIHRvIG1lDQoNCg0KPiANCj4gRm9yIDIvMiBpdCBkb2VzIHN0
b3AgdGhlIHRlc3QgcHJlbWF0dXJlbHkuIFdlIG5ldmVyIHJ1biB0aGUgdGVtcGVyYXR1cmUNCj4g
aW5qZWN0IHRlc3QgY2FzZSBvZiB0ZXN0X2ZpbHRlcl9kaW1tZXZlbnQoKSBiZWNhdXNlIG9mIHRo
ZSBpbmFiaWxpdHkNCj4gdG8gaW5jcmVtZW50IHRoZSBmbG9hdC4gUGxlYXNlIGluY2x1ZGUgdGhh
dCBpbXBhY3Qgc3RhdGVtZW50IGluIHRoZQ0KPiBjb21taXQgbG9nLg0KDQpTdXJlDQoNCg0KVGhh
bmtzDQpaaGlqaWFuDQoNCj4gDQo+IC0tIEFsaXNvbg0KPiANCj4+IFNpZ25lZC1vZmYtYnk6IExp
IFpoaWppYW4gPGxpemhpamlhbkBmdWppdHN1LmNvbT4NCj4+IC0tLQ0KPj4gVjE6DQo+PiAgIFYx
IGhhcyBhIG1pc3Rha2Ugd2hpY2ggb3ZlcnRzIHRvIGludGVnZXIgdG9vIGxhdGUuDQo+PiAgIE1v
dmUgdGhlIGNvbnZlcnNpb24gZm9yd2FyZCBiZWZvcmUgdGhlIG9wZXJhdGlvbg0KPj4gLS0tDQo+
PiAgIHRlc3QvbW9uaXRvci5zaCB8IDMgKystDQo+PiAgIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2Vy
dGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCj4+DQo+PiBkaWZmIC0tZ2l0IGEvdGVzdC9tb25pdG9y
LnNoIGIvdGVzdC9tb25pdG9yLnNoDQo+PiBpbmRleCBjNWJlYjJjLi43ODA5YTdjIDEwMDc1NQ0K
Pj4gLS0tIGEvdGVzdC9tb25pdG9yLnNoDQo+PiArKysgYi90ZXN0L21vbml0b3Iuc2gNCj4+IEBA
IC05Niw3ICs5Niw3IEBAIHRlc3RfZmlsdGVyX3JlZ2lvbigpDQo+PiAgIAl3aGlsZSBbICRpIC1s
dCAkY291bnQgXTsgZG8NCj4+ICAgCQltb25pdG9yX3JlZ2lvbj0kKCRORENUTCBsaXN0IC1SIC1i
ICRzbWFydF9zdXBwb3J0ZWRfYnVzIHwganEgLXIgLlskaV0uZGV2KQ0KPj4gICAJCW1vbml0b3Jf
ZGltbXM9JChnZXRfbW9uaXRvcl9kaW1tICItciAkbW9uaXRvcl9yZWdpb24iKQ0KPj4gLQkJWyAh
IC16ICRtb25pdG9yX2RpbW1zIF0gJiYgYnJlYWsNCj4+ICsJCVsgISAteiAiJG1vbml0b3JfZGlt
bXMiIF0gJiYgYnJlYWsNCj4+ICAgCQlpPSQoKGkgKyAxKSkNCj4+ICAgCWRvbmUNCj4+ICAgCXN0
YXJ0X21vbml0b3IgIi1yICRtb25pdG9yX3JlZ2lvbiINCj4+IEBAIC0xNDYsNiArMTQ2LDcgQEAg
dGVzdF9maWx0ZXJfZGltbWV2ZW50KCkNCj4+ICAgCXN0b3BfbW9uaXRvcg0KPj4gICANCj4+ICAg
CWluamVjdF92YWx1ZT0kKCRORENUTCBsaXN0IC1IIC1kICRtb25pdG9yX2RpbW1zIHwganEgLXIg
LltdLiJoZWFsdGgiLiJ0ZW1wZXJhdHVyZV90aHJlc2hvbGQiKQ0KPj4gKwlpbmplY3RfdmFsdWU9
JHtpbmplY3RfdmFsdWUlLip9DQo+PiAgIAlpbmplY3RfdmFsdWU9JCgoaW5qZWN0X3ZhbHVlICsg
MSkpDQo+PiAgIAlzdGFydF9tb25pdG9yICItZCAkbW9uaXRvcl9kaW1tcyAtRCBkaW1tLW1lZGlh
LXRlbXBlcmF0dXJlIg0KPj4gICAJaW5qZWN0X3NtYXJ0ICItbSAkaW5qZWN0X3ZhbHVlIg0KPj4g
LS0gDQo+PiAyLjQ0LjANCj4+DQo+Pg==

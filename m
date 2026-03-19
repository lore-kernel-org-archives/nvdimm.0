Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A518D2D6401
	for <nvdimm@lists.linux.dev>; Thu, 19 Mar 2026 23:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773961679; cv=fail; b=gUJ4Ma5TKpaqWJXXBko1y0um6Lk1bShNaoyyDClMWEJccnGAwFDYnH8gtwtmaBnEwJsqRm8tcPndNAIuE6TRuisNXLno2+upFi2yYCIc7AJhupbwSBhradCJ9fHB+C6xLrLqSMixkObLBju3VT8FfFAGXLukQAmumo6W86/X9HU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773961679; c=relaxed/simple;
	bh=9tCH6JFiTKkPiTL4M2EIWQRyK2r/RRujVdJC4A52WF8=;
	h=From:Date:To:CC:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=srxCYXVv6IdwZZSHjER68/G7rTEHIbw0JFeUg+BXHNPaugIRjB6tR+7hz5kb7q8RCx2S4xCtJMaTpsdT5l2nAfNkekHEd2CugzuVW4TPOTc15X9YQiHDIV62zMkhD8q54VbQP3Aw3u/Q7hA6MBmM+cAZ3hUJsOhTLFUF4CKn0fU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PbYwEXcd; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PbYwEXcd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773961678; x=1805497678;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=9tCH6JFiTKkPiTL4M2EIWQRyK2r/RRujVdJC4A52WF8=;
  b=PbYwEXcdbUbqgaO4TrVYxjtDtnyt1yGw0K0Z5CnrgIoaRvLQCA9ROLYf
   puNNfnN6jRzUgisrND6rCLt8/NUvRYyG2nIOfyNxdGjSOlkWS1getAwzW
   XD2uUXB/09pj4/ZndnQz2Qq2BekQR5Z0u0wSnGL+VJHU3KQgcJQ2Crc+m
   mAcSOOlBGE4IXnShFNMlF1eTHfiMy2bh9IP91TwtDjKREL3ta4pt61OVd
   vkrk0K7j4fyA4265yc9cC3sZM7OrWOE5rcvaZzDkVh+TzWvxJPH2OxzOA
   oViqTZs9KRGk00ZvwYiUwq5RSbT8MJanvC4GM+BlUqbMRQ1dW9TqmdWgx
   w==;
X-CSE-ConnectionGUID: NcxKcyy4TmunUxiFBXxRAA==
X-CSE-MsgGUID: 4AD+nB+RTriPcBoAopZuwQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11734"; a="75232469"
X-IronPort-AV: E=Sophos;i="6.23,130,1770624000"; 
   d="scan'208";a="75232469"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2026 16:07:57 -0700
X-CSE-ConnectionGUID: KlNhcoWUSr6P0Y+Z1liu8Q==
X-CSE-MsgGUID: 4HKum3hIRkaZQkghTatO/Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,130,1770624000"; 
   d="scan'208";a="227590487"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2026 16:07:57 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 19 Mar 2026 16:07:56 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Thu, 19 Mar 2026 16:07:56 -0700
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.52)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 19 Mar 2026 16:07:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EF5vE/wVuOvCFXxIdiLKM6d0tSiPEAFLF1rBK6FmmSV132JbCnkwVlpUv7IwhPh20KNtmSVznNqRn+q7vZXZCOuYMk/FggTqkBscYV1GK3MObpwYu/NaUB2pk491/Uq9jCP78Frm3eKhI+tTkI7U0R1wYrvEOUPDcNFb1xzqchVKZO+FHaI2dcVCVInlrQz9smBB3eFwBet6utDibtnjv6VFb/L7ZYcFRHr1DqQ/znE0NPjO/MtSMhZ1sLKCC0pp4tyWE2gJlA5pKEDjBhXuse05S8dal1SrGvyEfGhJaAqPK3ZLd1Uf2kkWkvVJQzLf2AzjIlAKy7vnKhqYXIOQ6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1nBEn31EMyP2x5Wr0rov6fp1IHDdATa0RhCyO69uTbM=;
 b=n+Br3CwGZT+ClXKL+bH1+RfhY74O6+DouKC8dNA7RdBrwOwr1Rn4cDuWDG1avVBcfpBDwbAUYjEK8Yh19r69+5NmyVF/bp75eeQC8s4N5YO3oew83YWLkIBYT+kFx5YKYXj1ry246AomQKUrvpdHQSUn0ckZq1UF3TWktmTxyANQ44+C983DXzGv9+nH43GRIs5h+3a2syB+T0l1oGpVTTYRyLbIi1wB6YHhSl1dpI7kRcKNmL10WHZE90JDfATcjI8ubNMYpDXOhU6f3XEcK6MAH6+58kU780fIjlrYJaVqYE6IqIImQJgRCoDVINItqIn8MAvfjCyF6GStQPXHfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by IA1PR11MB6268.namprd11.prod.outlook.com (2603:10b6:208:3e4::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.9; Thu, 19 Mar
 2026 23:07:46 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff%3]) with mapi id 15.20.9723.018; Thu, 19 Mar 2026
 23:07:46 +0000
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 19 Mar 2026 16:07:43 -0700
To: "Koralahalli Channabasappa, Smita" <skoralah@amd.com>, Alison Schofield
	<alison.schofield@intel.com>, Smita Koralahalli
	<Smita.KoralahalliChannabasappa@amd.com>, Jonathan Cameron
	<jonathan.cameron@huawei.com>
CC: <linux-cxl@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-fsdevel@vger.kernel.org>,
	<linux-pm@vger.kernel.org>, Ard Biesheuvel <ardb@kernel.org>, Vishal Verma
	<vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>, Dan Williams
	<dan.j.williams@intel.com>, Yazen Ghannam <yazen.ghannam@amd.com>, Dave Jiang
	<dave.jiang@intel.com>, Davidlohr Bueso <dave@stgolabs.net>, Matthew Wilcox
	<willy@infradead.org>, Jan Kara <jack@suse.cz>, "Rafael J . Wysocki"
	<rafael@kernel.org>, Len Brown <len.brown@intel.com>, Pavel Machek
	<pavel@kernel.org>, Li Ming <ming.li@zohomail.com>, Jeff Johnson
	<jeff.johnson@oss.qualcomm.com>, Ying Huang <huang.ying.caritas@gmail.com>,
	Yao Xingtao <yaoxt.fnst@fujitsu.com>, Peter Zijlstra <peterz@infradead.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Nathan Fontenot
	<nathan.fontenot@amd.com>, Terry Bowman <terry.bowman@amd.com>, "Robert
 Richter" <rrichter@amd.com>, Benjamin Cheatham <benjamin.cheatham@amd.com>,
	Zhijian Li <lizhijian@fujitsu.com>, Borislav Petkov <bp@alien8.de>, "Tomasz
 Wolski" <tomasz.wolski@fujitsu.com>
Message-ID: <69bc81bfa9baa_7ee310093@dwillia2-mobl4.notmuch>
In-Reply-To: <b56f55b1-4281-4edf-8aa4-27d0500ebd60@amd.com>
References: <20260319011500.241426-1-Smita.KoralahalliChannabasappa@amd.com>
 <20260319011500.241426-4-Smita.KoralahalliChannabasappa@amd.com>
 <abuOLq6bMPa0nNAL@aschofie-mobl2.lan>
 <3590e2d5-e768-4180-82a0-c972101f3440@amd.com>
 <b56f55b1-4281-4edf-8aa4-27d0500ebd60@amd.com>
Subject: Re: [PATCH v7 3/7] dax/cxl, hmem: Initialize hmem early and defer
 dax_cxl binding
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MW4PR03CA0178.namprd03.prod.outlook.com
 (2603:10b6:303:8d::33) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|IA1PR11MB6268:EE_
X-MS-Office365-Filtering-Correlation-Id: 7517a3ed-7c86-4d33-5dff-08de860c553e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info: gcYxCovS/60fpuTr7lvkAM2O4W5RL8s5lxhHrT50H4pqIh5RlJ/LDMfgW3EdVDIWtrP4RM0DqhruNKo1cl6O5q8oNNLLfgem65ixquhbEKcPGEPfkkTlJ91QnU/3W+hwPXz6NEqf8KG/DJVBgW6sfl5m/VjpY9UJMuEbQO6+KY4Nzy6obl7la3ELyr1JbLUSnIEcF8PYEpEAHBRK3lG0LCIMXHd3K+Qse0R3zbGmCkZHWUytzNmjLogGC05wvB/5b2NTjGr/dtkkyzt19bS+itLtq8Poyl/chxq4CehmJaV/4JWU65uetKNrMwsOct3u1svA34yjH9XolEyJRz3lIQASVLKVLuw8eQUJMBq92snYXngTJ8fSpevvhFC8Fi4l+aDoTQn6FRsjYBV7ZD98O0g4+dDGZH/tANrNt+qqNA+FwSDZRjOIRI6+Gbg7jrqoprb6L9P0eR7p8Ak6rEN+SyA2U7tjFQZ7wKnGV+dogLNFSWk9RbKlgqu+8cn5ump5U5MtxIfNhaYONsmJcVhQxIQ2/j6a+uxAsCITroyba2oFsP/fZ2Rq0etYbCh0MHvV8a4eyP5Qk68nU3njLUJKFCCzQPLLafi0zafsETy13QT5VaqH6UWCol2Xe5Cys+P8+la0mzZcN+epg1y6F3gamjosutSikx+6Yat0unAZCPatUl6HWJeKlP/ny4jvKCeZpF/yBB3GTU5lWrdQQ0K7bEijKbejDcWlcRKGzQXA918=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?REJzaTcreWdhTnNaRndqMTZVWjIvUXF1ZW4wN2l1QWtqVlNrWk1vMGROZzFy?=
 =?utf-8?B?cEdDVFRkNXFvdmRmNnNlNW96SGpmbjlpZnFKd2VKeFMwRjByc3V3Yk9uenhC?=
 =?utf-8?B?dU10a1pnQTBJNk55MDNrT3Q0ZlFLUFZLUStXTzNWSUNadTkzNm84Vi9yS0ZZ?=
 =?utf-8?B?OTgvNkxUOVNOOEVUNTNnelRlNUF2c0RDTUxTVEVES1Mza1JNZUM2VEp3V3lr?=
 =?utf-8?B?alRqaThKYVM4NmptOGlIYzNsZUliSHcyNGxraXovbDZjUWZqdzl4OWsxckdu?=
 =?utf-8?B?Umx3d0w5MkZ4c1hESGlVWElQdDlZWW9tWmNNM0VIS24zL1l2WHBLYXNwNldz?=
 =?utf-8?B?Y2FhZkpTaUVJS211S3dPUE1yM1hmNUFwMGNON2piK0tLL2dZTEdpUEpKZlV2?=
 =?utf-8?B?ajVJemcwYVFXeFRwWGp2M0VJYi9za0pYMVB1Z3d4WkJDbUxmRUxjUkZxbmJT?=
 =?utf-8?B?eG9QNmkwQXhOS1hoejNBUmN2d0locFpieGgxUWpmemdpV0Y1ZlV2cFJ4bDNw?=
 =?utf-8?B?Q2pwR1hDZHlTaW1lM3RsTkd4aXhxMHhHQXhLRGp6Zm9GMlVNSlNXZ2ZjWTNH?=
 =?utf-8?B?THI3RGFqSVJDZWNodEQ1d0pmcnFUTTV4QmQxWmkvSXc4VnVvYkN6ZEo0RUta?=
 =?utf-8?B?QUhkVm9ocVZDQ1ljTENaYjEzT3ZmUmk2Z1BQQmIxN2RQR0trWnRCenIwWVl0?=
 =?utf-8?B?RTJ1RVFQcTE1cGVrc3RqQlF4OUJBUitqbEliMHc0cmtZYnJGc3dzaElmRzZQ?=
 =?utf-8?B?ZTdyeXhmT3o5Q0tpRXhBS1Nyc094UVFxWjA1VUYrUnJCaUZtbGVpcERmWVQ1?=
 =?utf-8?B?VE85N1hnM04yZlR2NXpjdDEyODYyK21wVGxIbnpjREh4MjdSR0Zsb1dhSEZE?=
 =?utf-8?B?VkJuTU9YK1lwdDJmbmdkaTlidUdlc0xZSFN3Y2ZPQW1zaHhqOHRYYVVmZ1JG?=
 =?utf-8?B?MGRRVDdTQ1o5Ullub2Nia09SMDVaUWlSVUx4L3A4ZTVpTVVGU2xNdkMxWG5C?=
 =?utf-8?B?TjkxeDZJdWJDcGIzZ3BSanppOVVoc1NUYXdlMHNqWkIybXhHSmFFSWlmbjB5?=
 =?utf-8?B?MDI4L2tBQ25NS3Z1aDZDQVZ0dWVWMHlYQnBjVFFOYjJ1aUYvQy9Kd2NWSWR1?=
 =?utf-8?B?NEVTZDJpNW4vUG1ESW1YQjNtT1VZMC8xRmpadms2U0UxWUkvRklnRVByTTgx?=
 =?utf-8?B?UzFvb3FvTmt1c1grNmFBZFNkSEtaUUhmNkJ2bHFJNGxuTzA3ZW1LY2x4a2VE?=
 =?utf-8?B?VC9weEI3VFlDWGw3VE9nSnQ0UlFzTHFpOCtNZFNOSHpCd2c2T3FoVXZmSi90?=
 =?utf-8?B?QVkyVWM4eUp0NVFiSllwbWdnT1VvVCtsMFRrYkFGNFFoOGloRGQzd0pJMlEy?=
 =?utf-8?B?OExlZUYrSjg3S0VudXM2TFpsMVNGY1NMTWhWY0ZnRlhmV0dTelJhQis5NkQw?=
 =?utf-8?B?RmZ3Wjh1U3JvS1VmalJsaWZBVHhJUDRTS1hRdmgvV3BxMCtwNFE0MlhuUU1w?=
 =?utf-8?B?QUNFa2ZKdE02eXpvNDdPTVFxalZ3ekRZOVZOSDBVcTc3SThEL1dzdHJRVXIx?=
 =?utf-8?B?cjRCcVNXNCtzZnJDSXo1KzRGV1I2SlpUM2R2Z3VRWkd5QXRDc2ZqYW5DOW1p?=
 =?utf-8?B?M3VUUlNnRjA2cHRLTlRlb25xZ2lGT1FqTjZZTFVTdW04NGZkUGp4QWx1enNB?=
 =?utf-8?B?RytlRUNmVHNsajdnMi9aU2ZhNEtlQm1QRVJVTjJoMWJIclJSSERoRU56SjYy?=
 =?utf-8?B?b0p3Smw2dHBNVW51QmNyemYyNEo4RTNXNTZQZmluRitMdFlwbWZvUlo5Vlhw?=
 =?utf-8?B?aDNnQzNKQkZoK0J3VU1OZlZTN0tuaFUybTUwcmNKYnhHcWtld2JyazVGd0E0?=
 =?utf-8?B?QjB2dGNZYVFIT2VWVTl2aHpQc1VsMnlhLzlWWlVTNXo3dmduWTMrWG1CMjJ3?=
 =?utf-8?B?UHdTV0pFVWJaeEUyeG00eUpvRkF0bGM3a1Ezc1U5ZXpyenlWam1WS2lhOFRE?=
 =?utf-8?B?WkN0eW81NHV3UkF1VEJrOUcxZi9DR0h1OWNOYkQ3VTUxdzBMdmsrek9xQS9x?=
 =?utf-8?B?TUw3MkFBT3VjZzJKaVRzUVAzVWFYQTVkZ012bmdZcUR5YzdGdXV6SEFONlpW?=
 =?utf-8?B?N0srWmZrZHpCYlV4LzV4dFJSOHplYm5YQ0lBemtMTTFHVGhZR3Awb1prM0xS?=
 =?utf-8?B?YzFzK0xqOEpFWGVvbEc2WDh1K2NJSWp0d29LMURBU21UeDdDazZtejFtdTdI?=
 =?utf-8?B?U2dDMUc4clM5Mzh0cElWN3UzSUYwOU5Mc3d5R2dkNktweitnU1lnaHY0aTdp?=
 =?utf-8?B?bDRpS3pMSmFDOC96RHM5TGFXMXQ3YURSMUpiOC9oK0pBcUtsTWw5TE0yUTdu?=
 =?utf-8?Q?X9mHqBAzxoinnomU=3D?=
X-Exchange-RoutingPolicyChecked: oMBFq0Gzmb79I5AAYv7Q7iGmQhl+AxukU2kjw9IoMCE1hjHlBpLyu3pcczKbB6B2ywAt3a3TlvqQZx37b6aBNvWRTwLoaAuv3CDAJEJB71n0pt3aUyNCcKur7Hf+iG7E1zcpoy4hPVOkjPqhQbhrsKC86hnTEkXg3oBpOclDNxbTaVk6gnW3yytHqYTIZ5EHmuw/loi6TWpD7zUOkEnNpFWXVRI/uUhJ7K1VKPH8i4GEHFZHRriD9bjrpvzOpL/jQjcdKxqclA1izGOEEbn8wYze7kc9HnyzOGq8Idfz+u+truCd98pt9Ml5JGAV9OtmUb8gkE9nopUqVVedZaLr9g==
X-MS-Exchange-CrossTenant-Network-Message-Id: 7517a3ed-7c86-4d33-5dff-08de860c553e
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2026 23:07:46.2417
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: owCkip1faHplL9Squ9C7YqASiZgwKcbMgIMIvbZtxs9eIHibPG0KjIUTPATr/dCRw/GGSWHANELTayL/m+zjw2Q27iFSkAuY+q95uuea/fI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6268
X-OriginatorOrg: intel.com

Koralahalli Channabasappa, Smita wrote:
[..]
> > I agree with Jonathan's comments in Patch 6, using __WORK_INITIALIZER o=
r=20
> > initializing work in dax_hmem_init() and gating flush on pdev will fix=
=20
> > the WARN =E2=80=94 I will add both for v8. But I think the WARN is like=
ly=20
> > indicating an ordering issue here..

Yes, Jonathan is right, static initialization is also my expecation.

> > On initial boot, the Makefile ordering ensures dax_hmem_init() runs
> > before cxl_dax_region_init(), so both work items land on system_long_wq
> > in the right order and dax_hmem's deferred work is queued before=20
> > dax_cxl's driver registration work.

There is nothing that guarantees that 2 work items in system_long_wq run
in submission order. Unlikely that matters given the explicit flushing.

> > On module reload which Alison is trying here I dont think, modules are=
=20
> > loaded by Makefile order. I think dax_cxl's workqueue is calling=20
> > dax_hmem_flush_work() before dax_hmem probe has had a chance to queue=20
> > its work, so flush_work() flushes nothing and dax_cxl registers its=20
> > driver without waiting.

Module load order does not matter after initial probe completion.

...and dax_hmem is guaranteed to always load before dax_cxl due to the
symbol dependency of dax_hmem_flush_work().

> > __WORK_INITIALIZER fixes the WARN, but doesn't fix the race I guess if=
=20
> > we are hitting that here..
> >=20
> > [=C2=A0=C2=A0 34.673051] initcall dax_hmem_init+0x0/0xff0 [dax_hmem] re=
turned 0=20
> > after 2225 usecs
> > [=C2=A0=C2=A0 34.676011] calling=C2=A0 cxl_dax_region_init+0x0/0xff0 [d=
ax_cxl] @ 1059
> >=20
> > These two lines indicate cxl_dax started after dax_hmem_init() returns=
=20
> > but I dont think that guarantees dax_hmem_platform_probe() has actually=
=20
> > run..
> >=20
> > I dont know if wait_for_device_probe() in cxl_dax_region_driver_registe=
r
> > might help..
> >=20
> > Thanks
> > Smita
>=20
> Actually, thinking about this more..
>=20
> dax_hmem_initial_probe lives in device.c (built-in) so it survives=20
> module reload. On reload it's still true from the first boot. This means=
=20
> hmem_register_device() skips the deferral path entirely..

Yes, that is the expectation.

> The problem is this bypasses the cxl_region_contains_resource() check=20
> that the deferred work normally does. On first boot,=20
> process_defer_work() walks each range and decides per-range: if CXL=20
> covers it, skip. If not, register with HMEM. On reload, that check never=
=20
> happens =E2=80=94 whoever registers first via alloc_dax_region() wins,=20
> regardless of whether CXL actually covers the range.

Yes, I think you have hit on a real issue. There is no point in having
dax_hmem auto-attach on driver reload. If userspace unloads the driver
it gets to keep the pieces. So that means something like this:

diff --git a/drivers/dax/hmem/hmem.c b/drivers/dax/hmem/hmem.c
index 15e462589b92..7478bc78a698 100644
--- a/drivers/dax/hmem/hmem.c
+++ b/drivers/dax/hmem/hmem.c
@@ -112,10 +112,12 @@ static int hmem_register_device(struct device *host, =
int target_nid,
 	    region_intersects(res->start, resource_size(res), IORESOURCE_MEM,
 			      IORES_DESC_CXL) !=3D REGION_DISJOINT) {
 		if (!dax_hmem_initial_probe) {
-			dev_dbg(host, "deferring range to CXL: %pr\n", res);
+			dev_dbg(host, "await CXL initial probe: %pr\n", res);
 			queue_work(system_long_wq, &dax_hmem_work.work);
 			return 0;
 		}
+		dev_dbg(host, "deferring range to CXL: %pr\n", res);
+		return 0;
 	}
=20
 	rc =3D region_intersects_soft_reserve(res->start, resource_size(res));

---

...because if userspace wants to reload the dax_hmem driver, then it
needs to pick what happens with the CXL intersection. Userspace can
always unload cxl_acpi to force everything back to dax_hmem.

Now, you might say, "but this means that if the initial probe results in
a partial result of some regions in dax_hmem and others in dax_cxl, that
state can not be recovered outside of a reboot". I think that is ok.
This mechanism is automatic best-effort workaround for bugs / missing
capabilities in the CXL driver. Module reload fidelity is out of scope.

> So if dax_cxl registers first on reload, it could claim a range that CXL=
=20
> doesn't actually cover, and dax_hmem would lose a range it should own..

With the above change, dax_cxl always wins in the "reload" scenario iff
cxl_acpi is loaded. Otherwise dax_hmem owns all the Soft Reserved.

> I dont know if Im thinking through this right..

You definitely identified the need for that fixup above.=

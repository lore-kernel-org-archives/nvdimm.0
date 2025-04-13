Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C4B21F4281
	for <nvdimm@lists.linux.dev>; Sun, 13 Apr 2025 22:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744584729; cv=fail; b=fUIzG/tqjN1OatryX538bI1919NmEbr3Icpi6emFXWE6l5n0atA7mSwFG4xYRSgRCEcb0FAv3gq5ON130NEnS1FEhPsGIfDxKfmPmsbLQ7+Uv19IItyuJod8qQRAQTptVTajZNDlx14KgjGclb+8ltZbrnmHKIKDY1ixLDGHNjU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744584729; c=relaxed/simple;
	bh=DweLy/iFYuJN2tVNOKyxcg0lNjkjC4dzRFmq2hss15o=;
	h=From:Date:Subject:Content-Type:Message-ID:References:In-Reply-To:
	 To:CC:MIME-Version; b=QArz6fcMcLDDlR2Cb4XfTEf/CzP/3Qu5kQm7GeADwoWeLlTRKNurTHg4hyprp/jZYzbR6c2Ju8z70ylLMnH1u8D+nkzKVLGsxDbzu9eIU9CrsThIThcuS6/aF9eAEtd07jIBi+2WjquYw9mB7VjR11BpK2vymARbh/8Z08i7WT4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aFDLrK6p; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aFDLrK6p"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744584727; x=1776120727;
  h=from:date:subject:content-transfer-encoding:message-id:
   references:in-reply-to:to:cc:mime-version;
  bh=DweLy/iFYuJN2tVNOKyxcg0lNjkjC4dzRFmq2hss15o=;
  b=aFDLrK6pLK9II205XHRUswU9+5Vpo8qeZdjTzqmFs6ot2AB8UWQZWSQC
   lbJmY5vB1CO+VM/eGgb/Ew6Rj0YGUmVnXrvYg/iKiYpp44gXACaKrIobl
   eEQGTLdFNj+seIb3swsgmWCOWhdxg6tueODF38ui4+M3x7Fzjka6ti8it
   v84ErjYXlXULDD4pDxDRX7F0+4fP4RdfnXJChkt2QFhyjGuKFXAb/58xq
   U+/UCpcHgWEqtRsGKdrZ1y3es79ApKB1AoEj2ovhSk/cPownBWeGqAj9Z
   bhRL7NhnX0LJ33hUGqzLEAHT8GlZZJipzJ6n22bgO5SrVWEm7JYkNxkBU
   Q==;
X-CSE-ConnectionGUID: BmPQZXxjRAmoOrNfFkfMAw==
X-CSE-MsgGUID: ScFYeDswQi6k5NHOyORECw==
X-IronPort-AV: E=McAfee;i="6700,10204,11402"; a="45280927"
X-IronPort-AV: E=Sophos;i="6.15,211,1739865600"; 
   d="scan'208";a="45280927"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2025 15:52:05 -0700
X-CSE-ConnectionGUID: sMRIQHZZTXKTL3F5Xbl3rg==
X-CSE-MsgGUID: cSUTNWydTj28tZzYQJ0V+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,211,1739865600"; 
   d="scan'208";a="129657488"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2025 15:52:04 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Sun, 13 Apr 2025 15:52:03 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Sun, 13 Apr 2025 15:52:03 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Sun, 13 Apr 2025 15:52:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vl+/f8aHDGJ8kSTMrOJRG9ZdTPZgSNxgZZF/PLW7M8vMFxfQQNqhu6SCd7TGbw8KCO6X/2ajTbu5fNobyvUpJtk5vdfornqFAE0nWCrEkM/T+8wz3ybLntqV4d4qLaaKODuml0OgH92QEg3wCiZwdOBIyWba9aBK5dVjmooAt1U6bLmtX5QBCwjxyAbQkQrpWKeIuzVik2U8oBXZW5p1fdNKPL/shwH8uGWvdIBlbX6LG/g4d/8rkjuLVyJqSpICDWpO0HignBYH6maplyCT1caMfI1CWSAxiBHysLJNdwotqsmRP+fjBoNjxPnuXkjQBIQepZZGXKmt3B6HwZTVfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YdhHm7MPN9whPt26xmtzjGZbBz7yKJXcWBNKSmyB8kQ=;
 b=s9vMVIzuTYVeZkk/2dr77MO6EmMcltVEFuO4EViqcxj04kLJzRN7q+L3jACOIlZekMyk4TTBifCu52o0u43guvi8FQpEw47GfSOemV2z4TYEs2kftN6rkpuEWsRadrG2rCPeq/qIZ+RRZ9uHnXyVbkYsTHfBRh5X1DDNQX6xfNR6jgG5uE7fh9hAvXhhf6gRSojGWOcberqo54RSS4gdCjfG/KJ4OGMorPAKO/Vga5ULMKh4G+21MtZDvJukfqX1w5M1oV+0H1gU99fN3uKPFJ0fLgfmzOYiA0llJweKAsCjtc15x6SyvlYu9Dw3a0W6rhV4WrUNkWZwKHNO5rG4IA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MW4PR11MB6739.namprd11.prod.outlook.com (2603:10b6:303:20b::19)
 by DM4PR11MB6042.namprd11.prod.outlook.com (2603:10b6:8:61::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.28; Sun, 13 Apr
 2025 22:51:59 +0000
Received: from MW4PR11MB6739.namprd11.prod.outlook.com
 ([fe80::a7ad:a6e8:fced:3f24]) by MW4PR11MB6739.namprd11.prod.outlook.com
 ([fe80::a7ad:a6e8:fced:3f24%4]) with mapi id 15.20.8606.033; Sun, 13 Apr 2025
 22:51:59 +0000
From: Ira Weiny <ira.weiny@intel.com>
Date: Sun, 13 Apr 2025 17:52:18 -0500
Subject: [PATCH v9 10/19] cxl/mem: Configure dynamic capacity interrupts
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20250413-dcd-type2-upstream-v9-10-1d4911a0b365@intel.com>
References: <20250413-dcd-type2-upstream-v9-0-1d4911a0b365@intel.com>
In-Reply-To: <20250413-dcd-type2-upstream-v9-0-1d4911a0b365@intel.com>
To: Dave Jiang <dave.jiang@intel.com>, Fan Ni <fan.ni@samsung.com>, "Jonathan
 Cameron" <Jonathan.Cameron@huawei.com>
CC: Dan Williams <dan.j.williams@intel.com>, Davidlohr Bueso
	<dave@stgolabs.net>, Alison Schofield <alison.schofield@intel.com>, "Vishal
 Verma" <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	<linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, Li Ming <ming.li@zohomail.com>
X-Mailer: b4 0.15-dev-c25d1
X-Developer-Signature: v=1; a=ed25519-sha256; t=1744584735; l=5555;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=DweLy/iFYuJN2tVNOKyxcg0lNjkjC4dzRFmq2hss15o=;
 b=n+ag5TvRrreHjgrTSvROpgnVQw5WZXYglhSyUnemZTrMXYOBep823DwswAWmBMAaGW2gN1TlB
 jAUlP8JegpWCY/kVn8N+3y0jvmKaEyO9KUoPBBoLvApcLf4oE0zcwGh
X-Developer-Key: i=ira.weiny@intel.com; a=ed25519;
 pk=noldbkG+Wp1qXRrrkfY1QJpDf7QsOEthbOT7vm0PqsE=
X-ClientProxiedBy: MW4PR03CA0227.namprd03.prod.outlook.com
 (2603:10b6:303:b9::22) To MW4PR11MB6739.namprd11.prod.outlook.com
 (2603:10b6:303:20b::19)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR11MB6739:EE_|DM4PR11MB6042:EE_
X-MS-Office365-Filtering-Correlation-Id: 3436bfc4-62a0-4485-5e4d-08dd7addcc1d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?ZW1iaktESEdobW9FNnhDMjFJVG5HZzVnQkhlalBwenZOYnZtSU93RWFyaitM?=
 =?utf-8?B?a1ZUZjg5eU1Cc2huS2ZIUjZJSHJyLzd3Y1BCcWxJVytqTmNkME1JcUJGSnZE?=
 =?utf-8?B?WHBxMjY2bnBnYzFpMi9zTWNWQ0E1cm0vRWNQQ256QVFDRjBlWmFpUDJWMVNP?=
 =?utf-8?B?WnVnWWY4WjJPejkwN3lOVmNPWmwyR0RvZlJPMWFpQWtMY0ZYM2dlMUExNnkr?=
 =?utf-8?B?ZnlianhiT2F5WnZCTW9uckFxcTk4dU56RHQ0WTFBMTNLTnBuc1ZibVFOYzl6?=
 =?utf-8?B?Q2tkU05OaEhwRis2V0NrMnRaeXBadFNRNm5aZEdLaXBCRTQ4d09CNURiTDlI?=
 =?utf-8?B?NldUN1hMUk9lS0pyUjRwTmZJWjZVTldGWm1JVWlZQ0wwVHNvaktVSk1KVXhB?=
 =?utf-8?B?dm5hVkx4R3hJTnRuc3ZoNktxVWxzVllnUGx6cUpaNkdWWllkS0xCbWpmREI4?=
 =?utf-8?B?Y0ZmdWNmQTRJRDJMb0hnVWRsckNGdDFndndJVGVnTTNOdDF6aUx5c0ZjNi82?=
 =?utf-8?B?a2VsbGZaM25nRGJ5S2ZpTEdhNFFSSDRtcjZ3Z0ZXL0dSbG5WbzBLV1Z4cEl3?=
 =?utf-8?B?SDM5ekhQYnQ2TGZXb0xWMW9ORkVTcjNoL0VmTnpzRllINEpKaDV5TlMzNVdn?=
 =?utf-8?B?RmFxWXpFSlFiU0VhTkF2KzZtKzJrNXd2QThpZndJNkI3ZXdNYWs3alQzOXg3?=
 =?utf-8?B?TXp1WUZYajRBQjhLVm0zSm16dnRVZFdYQWFmUUp3VDJaNGxsdDdidHptTGJy?=
 =?utf-8?B?SUtORmVCRjRUa3lyZEYzQUJ3Y3ZoR3pva1FtYzBuKzAxNWFBdmlyVkU2YTNQ?=
 =?utf-8?B?QkZtanB2VFlGOUVESndUUWlneXVXWGVUUWg5bmxFMmVzU29qSHhNVW93eHA3?=
 =?utf-8?B?WFBVa2NYcXBQdElUanhjYklHQWlXSis4VzlHZlJlcHR1M1dLYkZuai82UTU3?=
 =?utf-8?B?NXlwYnFDbXRoVkg4bG1PNy9qUjhucnlyVnR2Q1dkekltaHQvYzM0SGRJdzgr?=
 =?utf-8?B?Q3V3UnZobHdpRkt0WlpoaUZuMnd6bmExcldTejVyZlV0VDdiNWdiZEk0Z2Zw?=
 =?utf-8?B?S2tnenVYTEl0U1FLRENpbU1kclBSNmhuaThoRzArY3FzTEEyNFI0SW9QeXFB?=
 =?utf-8?B?K0t4b0E2SEN0T2xYMWV4RTMwOEl6QzJLTTBIbDAyTjlJb09ZWWZVcHdsMklu?=
 =?utf-8?B?Vk9ERXVnRHZFU2xkY3k0WXFzb0NZc1BweDZ4QUxWQW5DeC9hcnh4N3h0ZGpS?=
 =?utf-8?B?SzdCWWRheDB6MWZlTnd2MUlpaVM2TG1NYmxXM0dYRnJTWjRXRjNlNkxRa0pq?=
 =?utf-8?B?OXFtYnBLNW9NSnBoWGxOOCtzaHhXWUkwbS96alBpOHlLVFMwU296RFk2K0I1?=
 =?utf-8?B?bnRVbEFrTmQ4THpTNjFkZ3JSOWtaME55aXVldmNsRnBUTFhkTXJraGRTbkt5?=
 =?utf-8?B?SDMxN2RnYmlaTk9iaWZ2TG1jWnBIVk5VSlRJdkpaSmhRQzBWTUZ6eVZueXlh?=
 =?utf-8?B?Q1hOalFUYkI3N0R5ejIxVGM3K21jMmZlR0EwRWpXRGxvRDNkdHZWVlRXVk5X?=
 =?utf-8?B?enRzcTZaZk51Z2NvbGsyOEZNbmFuNjRCNjVQeGdHWDl2bGpIcjdXL203L2l1?=
 =?utf-8?B?MUZaSm5jUzd4ZUlTTUNLMUZ6YnlnRVYva1NUVUI1S2V2WGd6d25nc0RFUW9H?=
 =?utf-8?B?TStCei9nUTk3eGc1NjA4VFpYVmczRHhweDhDYVdhZnFCV0g2WDJMS3MvT1Zm?=
 =?utf-8?B?alpjdXJmYlRRa0tnaUI2cjNnTzlRYkNOdHBINWlCRGFNT3FtazcxRVVvYjhJ?=
 =?utf-8?B?NnIxR01uQWVQNmttVEJRZncwbWJSMlJrWXJNU21PaGF2REpnaE1FSlBVclVo?=
 =?utf-8?B?L3Y2a3IyZ3FNazRaNUxvbnBkdHFVWm43RXRpL2JiSFpxZ2s3d0ZSbHlzRmhS?=
 =?utf-8?Q?vbg40KKoqPc=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB6739.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K1Z1K2VrY0I3TzVkVy8zcHpJaW1qdzUxanNuYkQweDR0TVVmZFRhSkxoTEhV?=
 =?utf-8?B?dFBkVG1aeTBwNFhGRWRVR1A4YVBZUUpFaGNSZGMrN0R4OXhFc2Yya1I3U21Y?=
 =?utf-8?B?VGU1elF0RWhYVjNsU0xsZjJiUThUY3I5by9DVHl1U3V5QktKZnZLWTdZMjBU?=
 =?utf-8?B?NWJoQlc1b1Fyem9VUkxMcDBDZnVYc0xZeU9nUm82eHprZEZreCs0dVdaVGdV?=
 =?utf-8?B?Ynl3WEx3TVc5TzNkZW5sT0hTZnBvVTBMNXlhbE1NZzZsbkdWUXVMWFYrbDNW?=
 =?utf-8?B?YThCWDF5N0NmZitoaFYzbCszR2JhRk0vUHdqNk5jRXNHOUlkdFFWcGdsRU1q?=
 =?utf-8?B?VmNBdC9qOEZpdkhrdk5VeW5FMmN1ajhSOWVSc3pMN2lvN0tpMHlOeHAyaE0z?=
 =?utf-8?B?M2o5YkZjQmlZUXNRQkVpdHJtVElUWWI0TlBiODlKODdvWTNKVXdTeDJxME5Q?=
 =?utf-8?B?enZsdlBxU3pDSWxQWG5OWkQ1RGJaUmRNZ1NZMUZ0MnN3S1VkU0ozejQ2ODNR?=
 =?utf-8?B?enhIK21IV3JINGJXRmFaZG05MXJhUHl0OHpvSFhEV3ByNVBQanVWbFlJa2NS?=
 =?utf-8?B?bkFEb1NBZ1lJMHlPeHllWnhSZmorUVFJRXR2ZlBRdTZiZnptdk5Sc1Z6QmEx?=
 =?utf-8?B?VTk0ZExpdlNvN1ZOWUgzU2d4dnE1U0NZRjJqb1gzZ3BNVFh5TVFjTG95aWhP?=
 =?utf-8?B?Tlc0TUtUVno5V1JvaGFKU1pHbFQwVTAvazZXWnBhc1dNd0NHZmd6ekpwSDE4?=
 =?utf-8?B?TjZYRytXKzJ2VHVXTzcvYUVyckdFakttUWwvLzdnN2ZYV29xVjB2L09MOXBZ?=
 =?utf-8?B?UHNHN1RDZnNYS0NJWVFyM1RFNVhXM2FPTENydDZEYml5Rk9EcTdPYkN5NEsy?=
 =?utf-8?B?djRtQjEzdlVvdmx6UFVVaElTcDZlMi9BaEVUaXlFVldQMXQ0Q3g0VFcwUXB1?=
 =?utf-8?B?WmVVb2xiT2RsQUc4dDFoYUVIcWl5bUZWZzRxZkYrQXZITzR5SklNdm1pMlJw?=
 =?utf-8?B?VjZ2UEYrVVIxTnJNVjhCcVhJdGNhNjY1MnlaM0NPdDhZUlZGRVcvZ3BWTmk2?=
 =?utf-8?B?UnNMT3BiKzlqNFhuTVhQZ3lWOExPNWtYeFJPVzU1cDlBMHNUMkxOMzlmcXQx?=
 =?utf-8?B?eE0raVd4cXBqTlZqTFI4NVF1TmU2T2Z5L0ZzL3YraEZqVlcwWCtGMXZ2aDdN?=
 =?utf-8?B?amZidjUrK2RBVGZCL3FiUWgwdGxWUGszbmxVZDB2ak9PQTZzWmFKTWQrdVVN?=
 =?utf-8?B?U0pqL3RpZ0tlTENPY2grMW14L05HTUJIY1lvZThnVHJnWnBMUTNWQ1dSdzRP?=
 =?utf-8?B?Q2JGL1JKeFBzOWFacUlSRHpmYUE5L3NDS3ZTWXZ6dmlncDBPaEU4VHFqaTd5?=
 =?utf-8?B?MjVua3pucURNRDdKdXVYNHJLd0wrN2dYbHpENzhEdFZsMmxMa3dUQVdKamJE?=
 =?utf-8?B?a3N1Zzl3QW5lVlBUSmNGV1pvbDU3cWZjU3lDNkJQKytONVBUc3JUemRURVkz?=
 =?utf-8?B?VWVTNnRtdEJqUEUzUTFqV1B4enQ2SEVBaGw0UEN5TzhRaWF3dU5xdFVTSWI4?=
 =?utf-8?B?Y1B2N1ZBaXRwYk0wUDIwanN0T0U0WEN1M1NoN0Z0Qnl3N2gxaVMxWkpPcFdr?=
 =?utf-8?B?NUVsaGtLZVNkdmtKdDhMT2ZXVXFiQVVaVnk0R2lGa1EvaFNlcE9hVXVGQm5M?=
 =?utf-8?B?TDY3VCtPWmthdldicDBNeWNTeGVrbmFoOXN3OU1ZQVJIaC9ZUDNpZ21Ub1Ra?=
 =?utf-8?B?L0VTYUZRdlNERVJDMkRsdHJkeTlzMGZlb0p6NEFyV2ZNaUxMaTBqMEpleVhP?=
 =?utf-8?B?WjAyUXFpYkdIbUxTenRYSnlYSDQxb2pzaUF5eHpSTDFpRzEwdWNrcUxsZ0sw?=
 =?utf-8?B?K1pmNUo3VVZHNEdyTjRDSXhRUHRDdXdON0s1OFE4Qk0vVEorMncxdzFmOFRh?=
 =?utf-8?B?ZitDRmtYNlM4aXg3TzFaVjlXcjMyRkEzVUc4RWkyMVk2VjV5T3ZWWDZCRGZD?=
 =?utf-8?B?RkYzSzJQeUNSemU0a25xOFdCL0t3aEdqTkEzSWppRk0vQUdWeUFOL0EyQXlJ?=
 =?utf-8?B?TlhwS200S2xuOEs1dGtRNDlpcnJhTVFrTDVVN0VGaUROTHZ6dTdtVDZuSDdV?=
 =?utf-8?Q?I79MmYnT569/FC3DfaCnTh9Lq?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3436bfc4-62a0-4485-5e4d-08dd7addcc1d
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB6739.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2025 22:51:58.9221
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2s0j6NgTAbayS5kR4XNUkK6taXnc5s7WyXlq16B+cltOy1hIiEb0dk1ht9UuZRfuXpFuWa8DkdwNymXdou06wA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6042
X-OriginatorOrg: intel.com

Dynamic Capacity Devices (DCD) support extent change notifications
through the event log mechanism.  The interrupt mailbox commands were
extended in CXL 3.1 to support these notifications.  Firmware can't
configure DCD events to be FW controlled but can retain control of
memory events.

Configure DCD event log interrupts on devices supporting dynamic
capacity.  Disable DCD if interrupts are not supported.

Care is taken to preserve the interrupt policy set by the FW if FW first
has been selected by the BIOS.

Based on an original patch by Navneet Singh.

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Li Ming <ming.li@zohomail.com>
Reviewed-by: Fan Ni <fan.ni@samsung.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 drivers/cxl/cxlmem.h |  2 ++
 drivers/cxl/pci.c    | 73 ++++++++++++++++++++++++++++++++++++++++++----------
 2 files changed, 62 insertions(+), 13 deletions(-)

diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
index a74ac2d70d8d..34a606c5ead0 100644
--- a/drivers/cxl/cxlmem.h
+++ b/drivers/cxl/cxlmem.h
@@ -204,7 +204,9 @@ struct cxl_event_interrupt_policy {
 	u8 warn_settings;
 	u8 failure_settings;
 	u8 fatal_settings;
+	u8 dcd_settings;
 } __packed;
+#define CXL_EVENT_INT_POLICY_BASE_SIZE 4 /* info, warn, failure, fatal */
 
 /**
  * struct cxl_event_state - Event log driver state
diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
index 36d031d66dec..c8a315bbf012 100644
--- a/drivers/cxl/pci.c
+++ b/drivers/cxl/pci.c
@@ -685,23 +685,34 @@ static int cxl_event_get_int_policy(struct cxl_memdev_state *mds,
 }
 
 static int cxl_event_config_msgnums(struct cxl_memdev_state *mds,
-				    struct cxl_event_interrupt_policy *policy)
+				    struct cxl_event_interrupt_policy *policy,
+				    bool native_cxl)
 {
 	struct cxl_mailbox *cxl_mbox = &mds->cxlds.cxl_mbox;
+	size_t size_in = CXL_EVENT_INT_POLICY_BASE_SIZE;
 	struct cxl_mbox_cmd mbox_cmd;
 	int rc;
 
-	*policy = (struct cxl_event_interrupt_policy) {
-		.info_settings = CXL_INT_MSI_MSIX,
-		.warn_settings = CXL_INT_MSI_MSIX,
-		.failure_settings = CXL_INT_MSI_MSIX,
-		.fatal_settings = CXL_INT_MSI_MSIX,
-	};
+	/* memory event policy is left if FW has control */
+	if (native_cxl) {
+		*policy = (struct cxl_event_interrupt_policy) {
+			.info_settings = CXL_INT_MSI_MSIX,
+			.warn_settings = CXL_INT_MSI_MSIX,
+			.failure_settings = CXL_INT_MSI_MSIX,
+			.fatal_settings = CXL_INT_MSI_MSIX,
+			.dcd_settings = 0,
+		};
+	}
+
+	if (cxl_dcd_supported(mds)) {
+		policy->dcd_settings = CXL_INT_MSI_MSIX;
+		size_in += sizeof(policy->dcd_settings);
+	}
 
 	mbox_cmd = (struct cxl_mbox_cmd) {
 		.opcode = CXL_MBOX_OP_SET_EVT_INT_POLICY,
 		.payload_in = policy,
-		.size_in = sizeof(*policy),
+		.size_in = size_in,
 	};
 
 	rc = cxl_internal_send_cmd(cxl_mbox, &mbox_cmd);
@@ -748,6 +759,30 @@ static int cxl_event_irqsetup(struct cxl_memdev_state *mds,
 	return 0;
 }
 
+static int cxl_irqsetup(struct cxl_memdev_state *mds,
+			struct cxl_event_interrupt_policy *policy,
+			bool native_cxl)
+{
+	struct cxl_dev_state *cxlds = &mds->cxlds;
+	int rc;
+
+	if (native_cxl) {
+		rc = cxl_event_irqsetup(mds, policy);
+		if (rc)
+			return rc;
+	}
+
+	if (cxl_dcd_supported(mds)) {
+		rc = cxl_event_req_irq(cxlds, policy->dcd_settings);
+		if (rc) {
+			dev_err(cxlds->dev, "Failed to get interrupt for DCD event log\n");
+			cxl_disable_dcd(mds);
+		}
+	}
+
+	return 0;
+}
+
 static bool cxl_event_int_is_fw(u8 setting)
 {
 	u8 mode = FIELD_GET(CXLDEV_EVENT_INT_MODE_MASK, setting);
@@ -773,18 +808,26 @@ static bool cxl_event_validate_mem_policy(struct cxl_memdev_state *mds,
 static int cxl_event_config(struct pci_host_bridge *host_bridge,
 			    struct cxl_memdev_state *mds, bool irq_avail)
 {
-	struct cxl_event_interrupt_policy policy;
+	struct cxl_event_interrupt_policy policy = { 0 };
+	bool native_cxl = host_bridge->native_cxl_error;
 	int rc;
 
 	/*
 	 * When BIOS maintains CXL error reporting control, it will process
 	 * event records.  Only one agent can do so.
+	 *
+	 * If BIOS has control of events and DCD is not supported skip event
+	 * configuration.
 	 */
-	if (!host_bridge->native_cxl_error)
+	if (!native_cxl && !cxl_dcd_supported(mds))
 		return 0;
 
 	if (!irq_avail) {
 		dev_info(mds->cxlds.dev, "No interrupt support, disable event processing.\n");
+		if (cxl_dcd_supported(mds)) {
+			dev_info(mds->cxlds.dev, "DCD requires interrupts, disable DCD\n");
+			cxl_disable_dcd(mds);
+		}
 		return 0;
 	}
 
@@ -792,10 +835,10 @@ static int cxl_event_config(struct pci_host_bridge *host_bridge,
 	if (rc)
 		return rc;
 
-	if (!cxl_event_validate_mem_policy(mds, &policy))
+	if (native_cxl && !cxl_event_validate_mem_policy(mds, &policy))
 		return -EBUSY;
 
-	rc = cxl_event_config_msgnums(mds, &policy);
+	rc = cxl_event_config_msgnums(mds, &policy, native_cxl);
 	if (rc)
 		return rc;
 
@@ -803,12 +846,16 @@ static int cxl_event_config(struct pci_host_bridge *host_bridge,
 	if (rc)
 		return rc;
 
-	rc = cxl_event_irqsetup(mds, &policy);
+	rc = cxl_irqsetup(mds, &policy, native_cxl);
 	if (rc)
 		return rc;
 
 	cxl_mem_get_event_records(mds, CXLDEV_EVENT_STATUS_ALL);
 
+	dev_dbg(mds->cxlds.dev, "Event config : %s DCD %s\n",
+		native_cxl ? "OS" : "BIOS",
+		cxl_dcd_supported(mds) ? "supported" : "not supported");
+
 	return 0;
 }
 

-- 
2.49.0


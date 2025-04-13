Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABB79213240
	for <nvdimm@lists.linux.dev>; Sun, 13 Apr 2025 22:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744584761; cv=fail; b=OQg3YaFIJDczZuAcg/B2FgnzQa6LzSidd0zBNHxBn2VzdAQJJDoF07xAn+XoEsmNG1VzUevimwlojHhQd+hGMN3tG/11pZEtA4//st8mB4WvhNTZFp1xC+g7exv7by76rNHzaR6WLVylmjvnk54pCzNq3UTRHSH8+x1LTGwhTuA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744584761; c=relaxed/simple;
	bh=4NU5QcBmTRIniatpivsMmlMW2JwnAaCVv53nVVFrE/0=;
	h=From:Date:Subject:Content-Type:Message-ID:References:In-Reply-To:
	 To:CC:MIME-Version; b=Oe/AY7fvUl+7D1lkPL3nfAyk5I3Lc4s2CSAodg1/BOia3liOEBAYbpBymXuqJwQEZ+RjaswB5MtIkzRjnHa3ODAViCAOixScrQzHWNZn3QxhXephB7C8GuSwI7p0hE2jGNrv07oD8wqbEoxZtRQAM5a45nay0yobZUKa5V6l1PU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IiZhwLqb; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IiZhwLqb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744584760; x=1776120760;
  h=from:date:subject:content-transfer-encoding:message-id:
   references:in-reply-to:to:cc:mime-version;
  bh=4NU5QcBmTRIniatpivsMmlMW2JwnAaCVv53nVVFrE/0=;
  b=IiZhwLqbUVnVR16J6v+/7YfD7OtEAjk1PpKBFn01Uv1m7Qv6e+ChJD9i
   favFw3KPHU0jcxmSmW+wqDtawU3OVwky6cTVcLo+78c0QbSpsjteR4ARU
   3wD7nwm0UEOxXXLjKxXeUK9uakOik0ZMtPD4VwMcVqVUGshSIkYTX4GvU
   g3Oc4duX7IctV1tbu8A+aySrpBN/medPJraLJlhYFL1nku5gikIISWnwT
   1WKkDhKwJ9afM4tf0WM+uTvlGmuZ+k7Ypd3yQCHPu9dga+LM+TuY3uWcc
   NGOVdKo9kDuISehvih/Oe5GlFZjkPdIl8vj0I/7skWBqaszjg4idnD63K
   g==;
X-CSE-ConnectionGUID: 9KIcnzS1Rb+IgP5Zs3IWxw==
X-CSE-MsgGUID: Aj2C73j6TN+XmaoIp2Ju5A==
X-IronPort-AV: E=McAfee;i="6700,10204,11402"; a="45280982"
X-IronPort-AV: E=Sophos;i="6.15,211,1739865600"; 
   d="scan'208";a="45280982"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2025 15:52:40 -0700
X-CSE-ConnectionGUID: 32XDdKAFQvuM1lnJQayexQ==
X-CSE-MsgGUID: c0mUkfPnSQmwX7QgxODi4Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,211,1739865600"; 
   d="scan'208";a="129657641"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2025 15:52:39 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Sun, 13 Apr 2025 15:52:38 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Sun, 13 Apr 2025 15:52:38 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.44) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Sun, 13 Apr 2025 15:52:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SYRlR3kt9aXRQuoT/vDOoJ6sse6D3chaSag/q7nmINhj8lBHsBT4skC7a6rNotm6d+WbM7HNdKxqgCdNtPZnhm3qotFP7jGMksTQv/6xIZCXpcJNBijNpKnxX15ERczjfWQirL2NAvNkD8drG0oQt33n+6vrnuHntAKHHYg318lhJxm/tzDm+xHplbhnCOgTR+wBl7E4rg5W41pViArYSK8DV+xfzdIxj26BMtu1tP1o9uj9HWDjYW9VP+lQsFuzRblwhQgXgiv6EyN9vh3Ce2IfhSf+E1xPbzK9VGotgDPxId63p26FCNNIEd5dnBcA95thMZKgez5Ghsi7gpVhAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mejpt3VvtggB127/vNXJ8EHLdh//zxOIBl0maqDyL+Q=;
 b=r3dWON2GFrFFd5bvQgGXrGU7Q0oipb2W7FviaX1gSuWyE/HsfwKpXkAEzmkI4+CnPbFzGY47QEp2IhGok53Po4EoF2qwOCSEndQf0tN7gDNiMieGMCtu1uCDyfEaVtFZRQYdrbgsZ4pUBoouYo0zGRKgSq0OOX6xLOljxq1wWYS+CIMjrSQzYUiVVv4nYACCU4va0vE8kGMTsKPhGofDozpDC9WZK+Qn0bwhsA3b88kwFDd8egdZEsxA834RkDUnQg9FVci2muRpJMYQnTaOaBCsrrv8GxtCOlIkBNsn7fRsRH4lvFabl5cWNT/SbW0pcXnp8ebPGjABE1tPIJv10A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MW4PR11MB6739.namprd11.prod.outlook.com (2603:10b6:303:20b::19)
 by PH7PR11MB7003.namprd11.prod.outlook.com (2603:10b6:510:20a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.33; Sun, 13 Apr
 2025 22:52:35 +0000
Received: from MW4PR11MB6739.namprd11.prod.outlook.com
 ([fe80::a7ad:a6e8:fced:3f24]) by MW4PR11MB6739.namprd11.prod.outlook.com
 ([fe80::a7ad:a6e8:fced:3f24%4]) with mapi id 15.20.8606.033; Sun, 13 Apr 2025
 22:52:35 +0000
From: Ira Weiny <ira.weiny@intel.com>
Date: Sun, 13 Apr 2025 17:52:58 -0500
Subject: [ndctl PATCH v5 1/5] libcxl: Add Dynamic RAM A partition mode
 support
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20250413-dcd-region2-v5-1-fbd753a2e0e8@intel.com>
References: <20250413-dcd-region2-v5-0-fbd753a2e0e8@intel.com>
In-Reply-To: <20250413-dcd-region2-v5-0-fbd753a2e0e8@intel.com>
To: Alison Schofield <alison.schofield@intel.com>
CC: Vishal Verma <vishal.l.verma@intel.com>, Jonathan Cameron
	<jonathan.cameron@Huawei.com>, Fan Ni <fan.ni@samsung.com>, Sushant1 Kumar
	<sushant1.kumar@intel.com>, Dan Williams <dan.j.williams@intel.com>, "Dave
 Jiang" <dave.jiang@intel.com>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, Ira Weiny <ira.weiny@intel.com>
X-Mailer: b4 0.15-dev-c25d1
X-Developer-Signature: v=1; a=ed25519-sha256; t=1744584788; l=11469;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=4NU5QcBmTRIniatpivsMmlMW2JwnAaCVv53nVVFrE/0=;
 b=/HT0WjM/CSzx4Yx6awBokqg7cBehBof5dEOSybODPs7uyzM36+zecJ1CshE0ufxect/vzMOrO
 vIwPJ45DW7YD75WjtxM52AlFjsCnqVAA6yyD1U0naXTflk/PDpmk10R
X-Developer-Key: i=ira.weiny@intel.com; a=ed25519;
 pk=noldbkG+Wp1qXRrrkfY1QJpDf7QsOEthbOT7vm0PqsE=
X-ClientProxiedBy: MW2PR2101CA0016.namprd21.prod.outlook.com
 (2603:10b6:302:1::29) To MW4PR11MB6739.namprd11.prod.outlook.com
 (2603:10b6:303:20b::19)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR11MB6739:EE_|PH7PR11MB7003:EE_
X-MS-Office365-Filtering-Correlation-Id: 2d5f9696-c32c-435f-7566-08dd7adde209
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?dktSdEV0U3A1c0F0YUl0c2EzaXdVbk1makxvR0RYallkcmxXSzNjcitZcVZS?=
 =?utf-8?B?Q25MN0N6ZFRvZVBHZVl4bWg4TDkrSzdtRk91TlExR0xwQUdkTHUzOGg2S1J4?=
 =?utf-8?B?Rnp4bGM5dGY2RzNOT1dRaThkbTAyc0VxZk0yeFF2aVRCTm1aTnhPUHNWUlpY?=
 =?utf-8?B?OVJWWElqV2wrZUJXc05VbXVYdFZUV1FwRzVkTkVzTTNOc1hXSlM3WExzMXZy?=
 =?utf-8?B?NE1Lc3FzR25kZ0VPcmh6UTIxRFNSWFRQVjBTK0JkTzJFcmk0UHVtTDFUS1Fv?=
 =?utf-8?B?b3NNMnNtTTVucVlOTmxjMkRXa2tpYnQ4cHdlMitBTjhkd2ZsdUJ6YUs3Z2or?=
 =?utf-8?B?eFdvWHZGamRXTHF4Y0I3NVZFeiswMkxCQnNOMEZLQkt6MG5BQmVRUE1YN3Bi?=
 =?utf-8?B?ZzVleWJ0dDJCU2J5LzNJRXFycktvM1IwbUUzUW1QTmxVS0NTeHBTNk5VRE90?=
 =?utf-8?B?NGlNNFhBc0NER3FDTk1oT25EZ3ZIVnE0R3pnSS9JSVllcm5OQlhKL2JVRlRZ?=
 =?utf-8?B?WHlTM0FOTjVUV0dtbnk1ZVV3SENyMXRTMzBlU0NNcnY5Ym9JV1RKdWRuK01i?=
 =?utf-8?B?TmVKbTI0SjlJaVpuREdmUEhyU1lXVm5vbVhBbkpYN1NVQTE5cHlUZUJmU2Fr?=
 =?utf-8?B?ZmF1bmo3SmhpOWtMR2JGUzlWZGEzQnN3a0FDSVhiNUFYVVBNSXJmOElmU1Fw?=
 =?utf-8?B?L2ZvQUFLVExiYlZMalVuMUNBdnVmbUxKaUljaXF2UFhidVhMRmw4Nm9DTXhT?=
 =?utf-8?B?R0pLZUFtcEhaWWVVNmNKbEFWRGRXdGRLVUV6YisvQWNaNFp2M2FTVjhQTHA3?=
 =?utf-8?B?OHVSR0dIeHRYN05DYWdWazZDZTRLbWNOUGdlUXFPeWJZbEpnK3BzdllBaktW?=
 =?utf-8?B?WHJ1aEVyelp0M1dlZGNOUURFMStvRVFXSWRFVjBjQkZYRU04SjllbDlMYWlB?=
 =?utf-8?B?NWFSeTJLRDI5UEVMVHEvWDZLWG13YThJR2E1ME1ZYmwzY0huVi8zaGZYek8y?=
 =?utf-8?B?eTJvR2ZxOXAyVFoybENZQ3k0TlFxWFRPUktGbTFad0RSa1NPdUxDZzZUaEEz?=
 =?utf-8?B?V3JrUkxTeU5tOEQvY0FoSWxKa2dlTkQ0SjlSMWE0K0kvakRXcEhMdFJGeGxH?=
 =?utf-8?B?OXdwSy9DaVRWQmJ2WlRMS29zYjUrc1JFWENieU5zRlJXdVhxem9sT3pncmFG?=
 =?utf-8?B?YnhTcWhVWmN4ZVFFQzVQM0pUTDdwNnZ1NDhTY1hINnRPK2dhVzlSR3UzUmhM?=
 =?utf-8?B?d0VOcm5QQ3Rxb1h0enVxUEwxS3lqUTcrZlBMWUJHamRkMFlnMGRjZ2JHUGpG?=
 =?utf-8?B?bFBlNE1QdldQRUhxSGFVb2JXUkJpRVZ4RDZjRU4rd0tIL1hXY0NTWkpIcHRE?=
 =?utf-8?B?Q1RVbXg0dktXaXA3SWQ1VnhCMEZza093bDBpRVpaQ3dNYmhsRHNJblpXNjZE?=
 =?utf-8?B?TlRFbGNIVEFPL2E5MGloc0UvUzBqc2xFUWVHZTRUdWROMk03ekdDNjJERmlD?=
 =?utf-8?B?YWYrUkZkOVp5Skhmc2hxQ1N6UDRiZTRyVStHVHFuemQzZFlSRlRHYlVpRWc2?=
 =?utf-8?B?RkpRTGVnSmhBOTVBaTRsNnNmdS9DZmROMUVUYXlhalluV1JWUHFRU09WZmsw?=
 =?utf-8?B?RkNEY1ovK09RSzRlLy8xOXprZWJybS9EUjV0d2tSSlRrR1d5VUZLekpYdCtT?=
 =?utf-8?B?d01Ib1VLYzdidFJ3YnozaUtmTFkyc044VjkrbzRsMFlXQS9sRU5tbjhmVklr?=
 =?utf-8?B?WmR2RVREUDV0eVVsZUwwa2VlR3RqbWRZb1ZTKzJJTHYwM05lYUtmbGwxMlFz?=
 =?utf-8?B?YitGYmxhWDU2NVVPMnFrbjNlTW05cVJISk1NaDZid3N5RTN6OTR4WFhFbkZZ?=
 =?utf-8?B?TU9wTUNPc1Y3TzJHSHl3cktWaUxqUkJFN2Y0bWgvMHVDWUxqTjNCTFNkTjN4?=
 =?utf-8?Q?Pl9ho6LjvRw=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB6739.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OUQzNnY2Z3pSY2lOUE9oRW00ODh3QTE1VWNYZ1BUZ2o5MHFCVXk1Zm5ETE5n?=
 =?utf-8?B?M3dXUVdwZWZBbG9iVWpqNEZQYkt2NUwrL3VQYVEzZStUNlVQaG9uNnpEOG04?=
 =?utf-8?B?aU56YWtNMFZFclpRNEZQZ2FVMVErWHNTRDlrb1VqemZROGhod2FpSFVPajlj?=
 =?utf-8?B?bmVKR2Y1cU14UDk0ck9FNEpOc0F6bmtQTzdmayt3cWt0dzY0VFpBU0xhNzVX?=
 =?utf-8?B?T2I1eFpaKzU4ZDU3MjFPd2taajhaZVdIdzlpRTQ5dzhvcHJUZVFvSHZpZ0Vy?=
 =?utf-8?B?VU5TUmVxam9HR0dnUzZzZVF4d0FHcFNpbFRFQXBXQmw3Wjh1ZjBoQ25hbHA4?=
 =?utf-8?B?UE9Ka052Sm50ZHlwUmVON1haclcrckp5QkFqdVFSNjZqUzRhUmxaVVZYZm02?=
 =?utf-8?B?S0pId2dIdTkxWDRUV1djdHdYa1dzSzRhN3hZWGVEQ3VhTlNhSXA0QjE1MlhL?=
 =?utf-8?B?c0ZWaGVTck5uMmxKQmw1WDlmZUIxbTBXQWVseG42UGU3bXpEMUtuUTArRlBi?=
 =?utf-8?B?R0liTGRhNy9FM3ZtTFVjdjF4WEFrV25HdWowNHlXbncxbVRwSEx2QlMxZGo5?=
 =?utf-8?B?WldqcTJuWlpMaEI3N3p6WllGVjQwb2hsNURLN2pHSjVoeklkOVkrQitwMEJs?=
 =?utf-8?B?ZHpaZnhFdTJDd3JTZ3YvSEYwdWg1b1hyUllJVGgvSXpxSnh3VS8zVXlsWTg5?=
 =?utf-8?B?ckF4TXRZZk1rM0dLV3hhbTNKeXZmTkh3K0hwVU5tZXVYS2JvS0I4UlE5QjVS?=
 =?utf-8?B?eTVLeWlWSEpnMWNWenZwcWc3NndRWUN2a0kwWkF4YWMvdjdZU0RJY3haOXQ4?=
 =?utf-8?B?VEo3RlUwMW1tb0hSWXJXMXdYamZTQ2luRUpKdnRIaEhDRHppNTIxWkpRVVhX?=
 =?utf-8?B?K01tMVIyckVDdUZjNXlBemZMa2QzTlJIbVlWQ1R1T2I3QVNUUzJiaGJQd2RP?=
 =?utf-8?B?OEVEdEJFd0o2SFdxdk1WU1RjWHIrWmtMRW9YNHNueHlYNURWT2hPb3VqLzFr?=
 =?utf-8?B?UEZsM0tUSmFHRi9rUU54MjVyRUlEbDlnclQ4L0hNekZyMFVlMHkwenQzN1Fm?=
 =?utf-8?B?RU9USDZ3d2lyakMzaUkwWWpDTVRGK0xqVHJBQmw3aTJCSHBzbVlkYWlqV0xn?=
 =?utf-8?B?RkRVR3hUQWJaMnpCYVNSeHBVOERiazFXN0l5MloyS1hOQ3RxWFlFZFN3amds?=
 =?utf-8?B?NnlQVHFtNzJyeU1SQzFHaHZIZGJZcGFLNXBNYmpJS1RVdjdCc0FvSmtTNTFw?=
 =?utf-8?B?bDZKa2pqZlJvcE9SSmlzQzc5dXF2ZlVFWGlFakd6YlcvWDQzM1JyN1hnM1RR?=
 =?utf-8?B?WXcvRGt0alg5SitVNmhScFhTQ2sxNFhyUWNzUStxS2t1QzNTNW1jVHB2cm5O?=
 =?utf-8?B?cm9keVZ3RFNZT0lwOUZpc3BEUktZaEVvbFA4UzhjMEUxN0thYnFPeGJ6bmxz?=
 =?utf-8?B?RGtmYmFjNEwwYkU0Qmx1SStEL3B0bEt3NUEyeDYzOEEyV0VHWVpReGxhVFM2?=
 =?utf-8?B?VjdmTUxvR0ZWenJWKzZoVmo5S2dYL0dtZ01xcUxSRi9KVm1wNzFYaE1BSlkz?=
 =?utf-8?B?Unpza1RlY0JoK3NCNkR6WGtUNFp6eXVMZ1BIc0FTMmdrRkJkWlp0NEU5NjZR?=
 =?utf-8?B?WnVtaTNXVG5USS9nWS9YNk4wUkZma3hLdXVJZHBHY3UyK1RWTzlDb05lYUVR?=
 =?utf-8?B?bmJ3NlFicWRPcFhSMUlmV3JnSHRTSFozU2x5OWxSUEFhU0J5cW9PZUhmQTIx?=
 =?utf-8?B?MzAvckpMZWI1RjV0WDFlTEN3RkxPamp4ZnlvbEhmRTZLVFYvL253eFlrRFQv?=
 =?utf-8?B?OXdIamJobm4rVFpUSWE5RnVTRERWQWhUTHptUUhZd2xTMmxTazI0VWZUS25a?=
 =?utf-8?B?WW5TOVlCSzRxNEVQOUFGczZjeGdncVlDUTBTcFNXV3RSSzlKSEhIQ0R3WGVq?=
 =?utf-8?B?T0h0M0IvZkVSb25OQ1cvdEIwZHNzVWhZcE51YVFCU0pmUFdZL3d5ekNFdDdo?=
 =?utf-8?B?TmgxMEdIYWhLOW0yRm9BWWhtdnBXUHc2MEJtWkEveHhkZzZVUndCTzhla0do?=
 =?utf-8?B?WDhaQjJkbjB1MTZjbzc0ZWtkTnBkY1FpQVhBTUVJVkRBRzNFcU1DcE9Ddmsx?=
 =?utf-8?Q?wO2NeVWuyUZv8YKA1nMvL0dVq?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d5f9696-c32c-435f-7566-08dd7adde209
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB6739.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2025 22:52:35.6819
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G0pj7VSANnkmd4Q8r0A+KoxOhLHFUusRW0o4CjErJqZEPUNyxtnkrh5RaHYcVta9ZTW6if4Cql72/9Mj9RAI1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7003
X-OriginatorOrg: intel.com

Dynamic capacity partitions are exposed as a singular dynamic ram
partition.

Add CXL library support to read this partition information.

Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 Documentation/cxl/lib/libcxl.txt |  6 ++++--
 cxl/lib/libcxl.c                 | 43 ++++++++++++++++++++++++++++++++++++++++
 cxl/lib/libcxl.sym               |  4 ++++
 cxl/lib/private.h                |  3 +++
 cxl/libcxl.h                     | 10 +++++++++-
 5 files changed, 63 insertions(+), 3 deletions(-)

diff --git a/Documentation/cxl/lib/libcxl.txt b/Documentation/cxl/lib/libcxl.txt
index 40598a08b9f4..7e2136519229 100644
--- a/Documentation/cxl/lib/libcxl.txt
+++ b/Documentation/cxl/lib/libcxl.txt
@@ -68,6 +68,7 @@ int cxl_memdev_get_major(struct cxl_memdev *memdev);
 int cxl_memdev_get_minor(struct cxl_memdev *memdev);
 unsigned long long cxl_memdev_get_pmem_size(struct cxl_memdev *memdev);
 unsigned long long cxl_memdev_get_ram_size(struct cxl_memdev *memdev);
+unsigned long long cxl_memdev_get_dynamic_ram_a_size(struct cxl_memdev *memdev);
 const char *cxl_memdev_get_firmware_version(struct cxl_memdev *memdev);
 size_t cxl_memdev_get_label_size(struct cxl_memdev *memdev);
 int cxl_memdev_nvdimm_bridge_active(struct cxl_memdev *memdev);
@@ -87,8 +88,8 @@ The character device node for command submission can be found by default
 at /dev/cxl/mem%d, or created with a major / minor returned from
 cxl_memdev_get_{major,minor}().
 
-The 'pmem_size' and 'ram_size' attributes return the current
-provisioning of DPA (Device Physical Address / local capacity) in the
+The 'pmem_size', 'ram_size', and 'dynamic_ram_a_size' attributes return the
+current provisioning of DPA (Device Physical Address / local capacity) in the
 device.
 
 cxl_memdev_get_numa_node() returns the affinitized CPU node number if
@@ -422,6 +423,7 @@ enum cxl_decoder_mode {
 	CXL_DECODER_MODE_MIXED,
 	CXL_DECODER_MODE_PMEM,
 	CXL_DECODER_MODE_RAM,
+	CXL_DECODER_MODE_DYNAMIC_RAM_A,
 };
 enum cxl_decoder_mode cxl_decoder_get_mode(struct cxl_decoder *decoder);
 int cxl_decoder_set_mode(struct cxl_decoder *decoder, enum cxl_decoder_mode mode);
diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index 566870acb30a..81810a4ae862 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -437,6 +437,9 @@ CXL_EXPORT bool cxl_region_qos_class_mismatch(struct cxl_region *region)
 		} else if (region->mode == CXL_DECODER_MODE_PMEM) {
 			if (root_decoder->qos_class != memdev->pmem_qos_class)
 				return true;
+		} else if (region->mode == CXL_DECODER_MODE_DYNAMIC_RAM_A) {
+			if (root_decoder->qos_class != memdev->dynamic_ram_a_qos_class)
+				return true;
 		}
 	}
 
@@ -1351,6 +1354,10 @@ static void *add_cxl_memdev(void *parent, int id, const char *cxlmem_base)
 	if (sysfs_read_attr(ctx, path, buf) == 0)
 		memdev->ram_size = strtoull(buf, NULL, 0);
 
+	sprintf(path, "%s/dynamic_ram_a/size", cxlmem_base);
+	if (sysfs_read_attr(ctx, path, buf) == 0)
+		memdev->dynamic_ram_a_size = strtoull(buf, NULL, 0);
+
 	sprintf(path, "%s/pmem/qos_class", cxlmem_base);
 	if (sysfs_read_attr(ctx, path, buf) < 0)
 		memdev->pmem_qos_class = CXL_QOS_CLASS_NONE;
@@ -1363,6 +1370,12 @@ static void *add_cxl_memdev(void *parent, int id, const char *cxlmem_base)
 	else
 		memdev->ram_qos_class = atoi(buf);
 
+	sprintf(path, "%s/dynamic_ram_a/qos_class", cxlmem_base);
+	if (sysfs_read_attr(ctx, path, buf) < 0)
+		memdev->dynamic_ram_a_qos_class = CXL_QOS_CLASS_NONE;
+	else
+		memdev->dynamic_ram_a_qos_class = atoi(buf);
+
 	sprintf(path, "%s/payload_max", cxlmem_base);
 	if (sysfs_read_attr(ctx, path, buf) == 0) {
 		memdev->payload_max = strtoull(buf, NULL, 0);
@@ -1599,6 +1612,11 @@ CXL_EXPORT unsigned long long cxl_memdev_get_ram_size(struct cxl_memdev *memdev)
 	return memdev->ram_size;
 }
 
+CXL_EXPORT unsigned long long cxl_memdev_get_dynamic_ram_a_size(struct cxl_memdev *memdev)
+{
+	return memdev->dynamic_ram_a_size;
+}
+
 CXL_EXPORT int cxl_memdev_get_pmem_qos_class(struct cxl_memdev *memdev)
 {
 	return memdev->pmem_qos_class;
@@ -1609,6 +1627,11 @@ CXL_EXPORT int cxl_memdev_get_ram_qos_class(struct cxl_memdev *memdev)
 	return memdev->ram_qos_class;
 }
 
+CXL_EXPORT int cxl_memdev_get_dynamic_ram_a_qos_class(struct cxl_memdev *memdev)
+{
+	return memdev->dynamic_ram_a_qos_class;
+}
+
 CXL_EXPORT const char *cxl_memdev_get_firmware_verison(struct cxl_memdev *memdev)
 {
 	return memdev->firmware_version;
@@ -2348,6 +2371,8 @@ static void *add_cxl_decoder(void *parent, int id, const char *cxldecoder_base)
 			decoder->mode = CXL_DECODER_MODE_MIXED;
 		else if (strcmp(buf, "none") == 0)
 			decoder->mode = CXL_DECODER_MODE_NONE;
+		else if (strcmp(buf, "dynamic_ram_a") == 0)
+			decoder->mode = CXL_DECODER_MODE_DYNAMIC_RAM_A;
 		else
 			decoder->mode = CXL_DECODER_MODE_MIXED;
 	} else
@@ -2387,6 +2412,7 @@ static void *add_cxl_decoder(void *parent, int id, const char *cxldecoder_base)
 	case CXL_PORT_SWITCH:
 		decoder->pmem_capable = true;
 		decoder->volatile_capable = true;
+		decoder->dynamic_ram_a_capable = true;
 		decoder->mem_capable = true;
 		decoder->accelmem_capable = true;
 		sprintf(path, "%s/locked", cxldecoder_base);
@@ -2411,6 +2437,7 @@ static void *add_cxl_decoder(void *parent, int id, const char *cxldecoder_base)
 			{ "cap_type3", &decoder->mem_capable },
 			{ "cap_ram", &decoder->volatile_capable },
 			{ "cap_pmem", &decoder->pmem_capable },
+			{ "cap_dynamic_ram_a", &decoder->dynamic_ram_a_capable },
 			{ "locked", &decoder->locked },
 		};
 
@@ -2661,6 +2688,9 @@ CXL_EXPORT int cxl_decoder_set_mode(struct cxl_decoder *decoder,
 	case CXL_DECODER_MODE_RAM:
 		sprintf(buf, "ram");
 		break;
+	case CXL_DECODER_MODE_DYNAMIC_RAM_A:
+		sprintf(buf, "dynamic_ram_a");
+		break;
 	default:
 		err(ctx, "%s: unsupported mode: %d\n",
 		    cxl_decoder_get_devname(decoder), mode);
@@ -2712,6 +2742,11 @@ CXL_EXPORT bool cxl_decoder_is_volatile_capable(struct cxl_decoder *decoder)
 	return decoder->volatile_capable;
 }
 
+CXL_EXPORT bool cxl_decoder_is_dynamic_ram_a_capable(struct cxl_decoder *decoder)
+{
+	return decoder->dynamic_ram_a_capable;
+}
+
 CXL_EXPORT bool cxl_decoder_is_mem_capable(struct cxl_decoder *decoder)
 {
 	return decoder->mem_capable;
@@ -2786,6 +2821,8 @@ static struct cxl_region *cxl_decoder_create_region(struct cxl_decoder *decoder,
 		sprintf(path, "%s/create_pmem_region", decoder->dev_path);
 	else if (mode == CXL_DECODER_MODE_RAM)
 		sprintf(path, "%s/create_ram_region", decoder->dev_path);
+	else if (mode == CXL_DECODER_MODE_DYNAMIC_RAM_A)
+		sprintf(path, "%s/create_dynamic_ram_a_region", decoder->dev_path);
 
 	rc = sysfs_read_attr(ctx, path, buf);
 	if (rc < 0) {
@@ -2837,6 +2874,12 @@ cxl_decoder_create_ram_region(struct cxl_decoder *decoder)
 	return cxl_decoder_create_region(decoder, CXL_DECODER_MODE_RAM);
 }
 
+CXL_EXPORT struct cxl_region *
+cxl_decoder_create_dynamic_ram_a_region(struct cxl_decoder *decoder)
+{
+	return cxl_decoder_create_region(decoder, CXL_DECODER_MODE_DYNAMIC_RAM_A);
+}
+
 CXL_EXPORT int cxl_decoder_get_nr_targets(struct cxl_decoder *decoder)
 {
 	return decoder->nr_targets;
diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
index ba82bc3da589..06f7d40344ab 100644
--- a/cxl/lib/libcxl.sym
+++ b/cxl/lib/libcxl.sym
@@ -293,4 +293,8 @@ global:
 	cxl_bus_get_by_provider;
 	cxl_memdev_get_fwctl_major;
 	cxl_memdev_get_fwctl_minor;
+	cxl_memdev_get_dynamic_ram_a_size;
+	cxl_memdev_get_dynamic_ram_a_qos_class;
+	cxl_decoder_is_dynamic_ram_a_capable;
+	cxl_decoder_create_dynamic_ram_a_region;
 } LIBECXL_8;
diff --git a/cxl/lib/private.h b/cxl/lib/private.h
index 676bf1573487..57c9fa0b8f52 100644
--- a/cxl/lib/private.h
+++ b/cxl/lib/private.h
@@ -48,8 +48,10 @@ struct cxl_memdev {
 	struct list_node list;
 	unsigned long long pmem_size;
 	unsigned long long ram_size;
+	unsigned long long dynamic_ram_a_size;
 	int ram_qos_class;
 	int pmem_qos_class;
+	int dynamic_ram_a_qos_class;
 	int payload_max;
 	size_t lsa_size;
 	struct kmod_module *module;
@@ -140,6 +142,7 @@ struct cxl_decoder {
 	unsigned int interleave_granularity;
 	bool pmem_capable;
 	bool volatile_capable;
+	bool dynamic_ram_a_capable;
 	bool mem_capable;
 	bool accelmem_capable;
 	bool locked;
diff --git a/cxl/libcxl.h b/cxl/libcxl.h
index 010ac0b78039..de66f2462311 100644
--- a/cxl/libcxl.h
+++ b/cxl/libcxl.h
@@ -74,8 +74,10 @@ int cxl_memdev_get_fwctl_minor(struct cxl_memdev *memdev);
 struct cxl_ctx *cxl_memdev_get_ctx(struct cxl_memdev *memdev);
 unsigned long long cxl_memdev_get_pmem_size(struct cxl_memdev *memdev);
 unsigned long long cxl_memdev_get_ram_size(struct cxl_memdev *memdev);
+unsigned long long cxl_memdev_get_dynamic_ram_a_size(struct cxl_memdev *memdev);
 int cxl_memdev_get_pmem_qos_class(struct cxl_memdev *memdev);
 int cxl_memdev_get_ram_qos_class(struct cxl_memdev *memdev);
+int cxl_memdev_get_dynamic_ram_a_qos_class(struct cxl_memdev *memdev);
 const char *cxl_memdev_get_firmware_verison(struct cxl_memdev *memdev);
 bool cxl_memdev_fw_update_in_progress(struct cxl_memdev *memdev);
 size_t cxl_memdev_fw_update_get_remaining(struct cxl_memdev *memdev);
@@ -200,6 +202,7 @@ enum cxl_decoder_mode {
 	CXL_DECODER_MODE_MIXED,
 	CXL_DECODER_MODE_PMEM,
 	CXL_DECODER_MODE_RAM,
+	CXL_DECODER_MODE_DYNAMIC_RAM_A,
 };
 
 static inline const char *cxl_decoder_mode_name(enum cxl_decoder_mode mode)
@@ -209,9 +212,10 @@ static inline const char *cxl_decoder_mode_name(enum cxl_decoder_mode mode)
 		[CXL_DECODER_MODE_MIXED] = "mixed",
 		[CXL_DECODER_MODE_PMEM] = "pmem",
 		[CXL_DECODER_MODE_RAM] = "ram",
+		[CXL_DECODER_MODE_DYNAMIC_RAM_A] = "dynamic_ram_a",
 	};
 
-	if (mode < CXL_DECODER_MODE_NONE || mode > CXL_DECODER_MODE_RAM)
+	if (mode < CXL_DECODER_MODE_NONE || mode > CXL_DECODER_MODE_DYNAMIC_RAM_A)
 		mode = CXL_DECODER_MODE_NONE;
 	return names[mode];
 }
@@ -225,6 +229,8 @@ cxl_decoder_mode_from_ident(const char *ident)
 		return CXL_DECODER_MODE_RAM;
 	else if (strcmp(ident, "pmem") == 0)
 		return CXL_DECODER_MODE_PMEM;
+	else if (strcmp(ident, "dynamic_ram_a") == 0)
+		return CXL_DECODER_MODE_DYNAMIC_RAM_A;
 	return CXL_DECODER_MODE_NONE;
 }
 
@@ -254,6 +260,7 @@ cxl_decoder_get_target_type(struct cxl_decoder *decoder);
 bool cxl_decoder_is_pmem_capable(struct cxl_decoder *decoder);
 bool cxl_decoder_is_volatile_capable(struct cxl_decoder *decoder);
 bool cxl_decoder_is_mem_capable(struct cxl_decoder *decoder);
+bool cxl_decoder_is_dynamic_ram_a_capable(struct cxl_decoder *decoder);
 bool cxl_decoder_is_accelmem_capable(struct cxl_decoder *decoder);
 bool cxl_decoder_is_locked(struct cxl_decoder *decoder);
 unsigned int
@@ -262,6 +269,7 @@ unsigned int cxl_decoder_get_interleave_ways(struct cxl_decoder *decoder);
 struct cxl_region *cxl_decoder_get_region(struct cxl_decoder *decoder);
 struct cxl_region *cxl_decoder_create_pmem_region(struct cxl_decoder *decoder);
 struct cxl_region *cxl_decoder_create_ram_region(struct cxl_decoder *decoder);
+struct cxl_region *cxl_decoder_create_dynamic_ram_a_region(struct cxl_decoder *decoder);
 struct cxl_decoder *cxl_decoder_get_by_name(struct cxl_ctx *ctx,
 					    const char *ident);
 struct cxl_memdev *cxl_decoder_get_memdev(struct cxl_decoder *decoder);

-- 
2.49.0


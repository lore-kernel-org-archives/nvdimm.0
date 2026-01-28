Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFC3E2110
	for <nvdimm@lists.linux.dev>; Wed, 28 Jan 2026 00:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769558581; cv=fail; b=fdAJ0parnXMgL0L7On4kC3zWIoVachpZY6R05Q6dRaP9WPT5fYat++FNgjkiZ5fhFGPfnvlj3OIyvy0IcLVoNVdlMTkqplO5tLTCpmY1CY4EySa3v8MDPtnyd+rq84yYVGtHVk2c7IintKoMcjh7+33MuJAkaY4FDMkr2a4SNdI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769558581; c=relaxed/simple;
	bh=zfHrTkSqp2N0WllG+0gyQIEJgNB9t6zr6ZtMPcC1S8E=;
	h=From:Date:To:CC:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=TeDOrReG1NJodKbWnMtnYhPnRJsdP1lWHAgl8MMThUQemV0mprr4uC4xshuAjtq5/b70aWnY+XQb9SXp1tHMQl2F+1uENMOOcGnJSDQEuhMnSxW+zxzxSefwIUWexLJq5cjQSwh7/+wkXi/BpW+M9cgIeJQDR5t/9vz/4Aat+ds=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iUL90xn6; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iUL90xn6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769558579; x=1801094579;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=zfHrTkSqp2N0WllG+0gyQIEJgNB9t6zr6ZtMPcC1S8E=;
  b=iUL90xn6LdWZpr9kv5v0ORVU6umsgFAC6mEqGYY1g1F5+IgNqCdSv2jS
   mlB5GO7uOjQ3g2DOV40GF61aF1roXyh+ISkEQ1P0jGCraeptnPZ3+vRjy
   Ty7b5hjuGy4ecuMCuYRUzAwf7f6NR2zceP1vGf0qIA6Nk2QYiAMt9jfEM
   gWwdvfzYqolbaHFN6T5QMA5wAbad7g6R7S/a34RsL3fFlSz+AJBsDOlTP
   8opxu8bOEwMc05rpEENG8g74hp0Y8kZNFtLTh3bClGoL3GqB52DxHnHo2
   1OA/IptiWjhtZYg3sIEk43/tQEQwzDLDovkley5X99b1EbCZvb+hBkqdT
   g==;
X-CSE-ConnectionGUID: 07Q3j9A8QQW4Y9WCP19roQ==
X-CSE-MsgGUID: teOrR2OYTr2+ms6sV6vLIQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11684"; a="70932176"
X-IronPort-AV: E=Sophos;i="6.21,257,1763452800"; 
   d="scan'208";a="70932176"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2026 16:02:59 -0800
X-CSE-ConnectionGUID: IZNDiCh8QwOt/LlG4pu4RQ==
X-CSE-MsgGUID: P0cBGBU4RxKxbSNrsixXlg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,257,1763452800"; 
   d="scan'208";a="212580998"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2026 16:02:58 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 27 Jan 2026 16:02:58 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Tue, 27 Jan 2026 16:02:58 -0800
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.45) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 27 Jan 2026 16:02:57 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nGGJimCqWGsiNvIo4QFFEJMsQtqTI+pAQQO7Qt+2dwAvqW9OwMHyYbewJ1Et9Zn/u9JhGPjFx8fKubRky8boz7O85ZIHUE/2fNU42GbHLfTd9LM1vzu5hKIPNeD+8WdbviKF3JVGnfJR0oQDQQebmDlAvOhxFIgbwAmJFKB3cnYFTxk514v1zXbXHAH1jrn1vm/15CfPI/9qCYYM/z1Y47VxbO1Z10xYEy1gH2yhQtrnLeQKXms55a7X/i70yzbG2LTZH0mEAs4h66otehkRo+LDd4xheVrRKOsomnCMc9fmd8DjFuivwU9E0XX3mEO7OsNi5AxMJTwYdFViB0+wHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yfh3f51Dp0uYtUFWMO43QxDMHEmG/wk0Nzp4DB9v9Yk=;
 b=v3QcOI2emP4Dm2x7iKGzG62oYYEPvg4NZI+SqBNb3r9I+Y6Rk7BMcuDoo5zAPUspgRqEMYlnPa0K+BW9MqnqJkV3BObZCkfBNfV4whJ1vEW217uigVCkpO/ZKpY0ZVHxLdQIfV1zly8ID/NO9nFpBFfFQ4Q/V+ZlSfOUC8bRZZIIkJvkQDp2goAaitn0sMSh7qzHJQom2mUd/z3cOO1Aj3J8YFTzQTqI5BI6Dyn0O9IaGZ9JEdR5OrgzS+SZRMmiYKrL2jtX83+RCQx/tWAW/+/gIshb/nXk9Dg3ryFmERsqSSMT4Xs589Oq1GfxnXEUmEiSnyUXqRN8juN1sTWXPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by MW6PR11MB8412.namprd11.prod.outlook.com (2603:10b6:303:23a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.16; Wed, 28 Jan
 2026 00:02:55 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff%6]) with mapi id 15.20.9564.006; Wed, 28 Jan 2026
 00:02:55 +0000
From: <dan.j.williams@intel.com>
Date: Tue, 27 Jan 2026 16:02:53 -0800
To: Neeraj Kumar <s.neeraj@samsung.com>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<gost.dev@samsung.com>
CC: <a.manzanares@samsung.com>, <vishak.g@samsung.com>,
	<neeraj.kernel@gmail.com>, Neeraj Kumar <s.neeraj@samsung.com>
Message-ID: <6979522dc1916_1d331009@dwillia2-mobl4.notmuch>
In-Reply-To: <20260123113112.3488381-11-s.neeraj@samsung.com>
References: <20260123113112.3488381-1-s.neeraj@samsung.com>
 <CGME20260123113138epcas5p4bc54ae41192dbc9c958c43ad8a80b5c6@epcas5p4.samsung.com>
 <20260123113112.3488381-11-s.neeraj@samsung.com>
Subject: Re: [PATCH V6 10/18] cxl/mem: Refactor cxl pmem region
 auto-assembling
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY1P220CA0001.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:59d::14) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|MW6PR11MB8412:EE_
X-MS-Office365-Filtering-Correlation-Id: fb2169d2-2e90-4f1f-3ced-08de5e009658
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?RGdFdGs2RFZTd2R2a3ZTUWthVjBVOWVWMERvcjl5QWlnMk5RM1hwdWZYQzd1?=
 =?utf-8?B?ODdzOGhQL01TUCtxTEpQM2tPT3lDN1JrU1E5bVp2Wm1HK2JxR294TXdwWVpn?=
 =?utf-8?B?QzAyOHNGZkVjeTdCQnZCU0Vzd2h3dEtyL3F5YUoyZUVrbkJSZWhVdlRrRHUy?=
 =?utf-8?B?QlB3VTlhNG82ZGkxdGNiWE5aQkxBbzdxcHBrM0lJU21hQU8ydW9LZDJ2V2s3?=
 =?utf-8?B?L3RxSnhwTzRsbmNFNU1FUGp6Tk5JellJMzdka1I4cUNyTlh5Qk1LOExaUlRS?=
 =?utf-8?B?ZjhzeTFmMWlLOWw4Y0s4ZmJvZWNwU05VekFkZ3JCZ2RzUXpmNEhVSkdnMk5I?=
 =?utf-8?B?bkpRQjZxRXFOSExEcTdWRWE5QXJZMHlSVmhPU0oxZENGRmZUN0ZPTSttV0tr?=
 =?utf-8?B?S29yYlBEVUt5bEpuc01qTUU0czhHZ3pzNHdqc0dtNjUybUlnSVR2TVNWOWVo?=
 =?utf-8?B?b1VCVXdWZi95OG4xNW5CRlZmelUrcjc0eDlRcFFGdUdpbWxyMHhPUlE5bHE4?=
 =?utf-8?B?cG4yeVcvaFAzNWpneEFaN0srV09SN1NWYituU0pLbXVCS20rYUt3R2kvbU5o?=
 =?utf-8?B?WVkrbjBaNUJ3TW82WTMzd2gzcDdUenlvUlE5WGhTNThaSDY5YWhQcDJ2SjR2?=
 =?utf-8?B?RlV5aUcvTmh6YXNyVzBQb0ZYcExPYmplckx4YzdaNzR5K1Y5YXErRndWcUtx?=
 =?utf-8?B?V0gxQmFYV1ZUTkNISGdBNnJQUzNCSm4zalBuY21zejlUekRhWG10a1VPVjZn?=
 =?utf-8?B?dDhlbWhoY3ZLc1M3a3owVlI5TE4rMDZTcmwxZ294bCtRejlIbXd3eGd3SEFN?=
 =?utf-8?B?azJFN1p6b2lxenhoaFdHSGdHeE5tcWxpdlRleVVRRm13NmFGRmtGUnVsNFls?=
 =?utf-8?B?TVRQc21XYlFXRXFBQ0YwNDF4bThYR2l0OUhCa2VzekNOcEdhT0QrQWYrTjlq?=
 =?utf-8?B?VUJ0cVI0U2FmdjE4azRVNktaY2RZVVZsWG1LTUswdEJyZS9QOHdjNHE2Wm05?=
 =?utf-8?B?N1RLMWJEWVpJUms0RlBXNFFGYTlzUTc1RmNYTDVxc2hOZmd4WkIyUVE5eExL?=
 =?utf-8?B?QU5CRlJvS2JRRDlHK3dIbUhQY0JMd2J1a3AxU1VKWWFweGdGc21pdkJzaTVR?=
 =?utf-8?B?RnRqcTJab1NsUmFMenJSaEdCTnBqMDEyVk1zazZsWVRxNng3NjdSSEltV3o3?=
 =?utf-8?B?eURXVTltYnNYT294bEM1QklEejl1aGh5Wklzc0g1aE5rdG1wVmowaXI1Kzgy?=
 =?utf-8?B?Y2cxbWxDdXVqMUZNbzRvck5aaDhyMFRtaUkvaFJPdHZDeGRNN2xIcSs3clNk?=
 =?utf-8?B?NmV1NG90bWpSazhzOUN3RHpFMEZWTmY3eHVraDNsZlI2MWlicEJCQWxzczB2?=
 =?utf-8?B?VWdVYTAwM1ROalJKb2RlY2h4V1lBTUJEazU1VlVqUFFJT2NaSnJOQnI1MTJH?=
 =?utf-8?B?SHVUd2Y4ek5FRnJJb2lJOC9JNTlsSHZDMUhWcTRDNm92aGFMS0pFZVdTSmN4?=
 =?utf-8?B?N3BHVEZDZDN3S2N0UzJqbWx5Q20zcUN2ZHVEc1d5N093RzdvOEkrSm1ZRXlO?=
 =?utf-8?B?SkpDYXYxS1kydjFIUkFMczBBVjRhWnU0eGV6Vk9aMVpIUGlMWjVmeTVPWVM0?=
 =?utf-8?B?MEZkdy9Vc0FNLzVNMzRPeWJUMkxwdnQxOVVSZVFaa01WNnFjVXRwYkUrNU9R?=
 =?utf-8?B?UzFISFljY3N4clQ0QStHTm0wUThjZm5ZcDl0MmlrN2EwOFdlUENOa2QwT0Ry?=
 =?utf-8?B?M1g3U0JwQlgzaW9GSGJTNGJqYTdrZ3lFcStPM0tyMXNZSXVJOWR3eXZWU1gy?=
 =?utf-8?B?dGpmUjBGdDY0SzY1ZmRwRUN2YzFwdUxDd1ZXeWtZdEhCMzEyNnhEVnNFdmZ2?=
 =?utf-8?B?NnJPaUVhMFRXcjJmc095N1VhMmZmS0lmUlNEaGRVcGNqMzRua0Y0K1BtSWZo?=
 =?utf-8?B?eTdXREpmcjJudUdHa1QvMkJwK0FRZW55MkhBME1DSVlITm4zQ0hiZVVNZnMr?=
 =?utf-8?B?SEFGMFFjVWFGU2FJUGg3K0hIdWg4QzF1bm53R1lPUHFqdjltWDd2WDZmcFVl?=
 =?utf-8?B?YldZWGFzQlBtZ1M0VkJTUzQveVFaV2MwRDlrNk1PNm1POG02ZlErREYvbUFZ?=
 =?utf-8?Q?k5Gg=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z1B3d2lGTldCVFNrTFRkM3gvYW5NTnl6M2g2SGVQQmExOURHQXhLK0ZoVWh5?=
 =?utf-8?B?bDV1SE90UFhrSGh1RWc3SlBFKzcvYldXMnJ3c1FhWWJqZ3IycXYyM3hOWHhp?=
 =?utf-8?B?ZTQ0ZVhzTGUwK3hQS29JdDdYbWFUbk5FL1FPN3JaZFZDWC96RCtWeGNZYTRD?=
 =?utf-8?B?K1RSMWdNb3NDY2ZnVXRNV2tzSDNwUlBGdWpXRWRkZXZiUi9ScFBxczJqblJp?=
 =?utf-8?B?bDR3VmdIZVNBcC9WTy9MU3M5Yk9sNmM5K0kzRU1LaDFZcjVLQjdGSzNTa3FJ?=
 =?utf-8?B?eTBMZDllRFpJVnhjbDBDV3g3eWVyUFY0VW9WTzRDVkpYM2hqRVU2M1ZGbm5W?=
 =?utf-8?B?UzhGTWttQlpNRGxiVElrZjVkd2hTU1EwRWdjQ21JZmRCRThmbFIvWDZ6RlBG?=
 =?utf-8?B?NGovSTBGM2oyblBRa1d0NFNTbWdVWXpUbnVGd2tUSTkyNnR4a3hNUDlHM1U1?=
 =?utf-8?B?WlNQbE1VcXdCSU5yd0hVM0dQYkFIbkFzT0ZJRTZPVFA1S1hKekZRTUVxS1VR?=
 =?utf-8?B?bjdINFJ2WXUzRUhEcEhWZ0Y5czcwZTNWeUtDQTVaaWFvOHNyWnJORVZmcWJh?=
 =?utf-8?B?OXllaWpLR1doUWdGVTJNOWVnMEhyRS9Nd2oySTBSRm0wY1NvMXB2VlpJakxn?=
 =?utf-8?B?bE5Rek85QWVDVnFGUm43MFdiUGNxRWlUNyt5RjdtMjBidE9IWGxpRVFRbUEv?=
 =?utf-8?B?UzlOMXNiZE9sRUlxckx0NzRXQWxFamZINjlqeERqaGV4ckk5cGpFL002Mlht?=
 =?utf-8?B?UlptbWszRGxXN2pmbGNMN0N6N0czNGxjNUxITFBBUXQrL2I1d2RTTWJyNk00?=
 =?utf-8?B?VFN3aVdQOXJjSVpMU0dxekthT3kveTZMbUtrTDNoVVFqR2NOYlFDekh4Wisy?=
 =?utf-8?B?YUg1QndWUFRydHAreDdSbFJnalVEd0VlVzArWEQyN3I2Tmp2OTd6c3FCYUxm?=
 =?utf-8?B?M05ZMmVnV0Q2UmFXYVZRRXVmUDZjWS9zVGlxbkRTZjZrSFl1S3BQZW9mMlJH?=
 =?utf-8?B?RmhSb1d0U0ExVHFhK2FsVjNYSWUrbEVsVkhTTHNpcm5OdjRyNER4dHBIekVx?=
 =?utf-8?B?OC82aS9uZHRGR1BmMVVOdzFhQUF0Zy9TQnp6emlzWUxsRWtBOVpXNnVySW1x?=
 =?utf-8?B?cGQrZWZQdWYwem9tcEl1MUo0bHcyUkFHRm0vaHBSUGpoWlRNdEJ6SFdZeEhw?=
 =?utf-8?B?TTVnSGVleStwbUJzOCtoNXdvMExJTTk1VlZRWVVzcVhEWVRZazU1cmtWSVUy?=
 =?utf-8?B?bGF0Q2ZyOGVlSGtHNEMwcHU4VmFtVHU3WnhxdFlSZDJYZStJK1JGRDRtUkJQ?=
 =?utf-8?B?TmdNaVAwelUzWDg0UGJybThHR0gyb0t5YjI0bGpGYkd1cUpZYzBQV1VTMzZa?=
 =?utf-8?B?OWZSZVNlK0JsSWozb3JlOEhXVkpsdkZhSEk4c1JQdlZTTEdaOGVjc2JrQ1dE?=
 =?utf-8?B?UWdpdG1yL1lYaTVZdVNDRkR5clcrdXY5Y01NTGhVdUZhSjRWM2dzVUZ0OG9I?=
 =?utf-8?B?WWJEZ000U0JKckcvdzhUenBGeUJmUmdCaGZybFRnVmNUZUVmYWFUQ3k1NEN3?=
 =?utf-8?B?ZExGcGsxZHBucW0xVlo4azRCeCtBN3BDZUEvV2l6WVFscE5qTUY0bzlmMXJZ?=
 =?utf-8?B?WllNdFJGU0EwVGZVeVpacWl2MjBMSUcvQlBDMUhzbnFzZjE3UW0wVnZsVWNq?=
 =?utf-8?B?QWFCeFFoYy94MkxiV0wvUGc0dXNxc0kzQmJYaDAxMkd3WXAzTjBUN3QwUXVO?=
 =?utf-8?B?TjFrdlN6TG01NFpjU0NnMS9RMjQvRVA2M0lnSEN3S09NNUlkaVFMYTlzZG9i?=
 =?utf-8?B?SjNOam84QlVoUzFackRwOUg0ekdJWndJT0FwSkJqdkxlL1dvenVva3k2Umhl?=
 =?utf-8?B?S01DT0U5bkhsWGxyYUlJWTl2NXpRUGR3YjZ1cng2UUkxVm1FaG8vbmlPVjZM?=
 =?utf-8?B?N0kyM2tNMUZ3TERSdlFoWWU0cnp6WlBHb0t2bUFvVGtIckF0OEUxNTNLSE5B?=
 =?utf-8?B?b3FXUS9GQ1puMFhuMEdzcEV5cFgzTFg0MXFMV0RoeE9GRlp2UlBxK1B0M2M1?=
 =?utf-8?B?S1ozcEVFSEhGcG1WeHRRVnBPbjdueVhnWXNqYzZVMkhQM25qQzdXaFZZekVP?=
 =?utf-8?B?N1dsZzZxdVFEUEVUYllXNHoxcWJ3VHp1Z3pYSjFGR0dLdTB0UStvRllBK2Ux?=
 =?utf-8?B?cU42YldZK2VrdmZMTFJrVXdNb3BhY2ZTeEtrWW1pS2xXYU5qZUJUWVNFZW03?=
 =?utf-8?B?OTU2MjBRM0hEbHh3NjVtbHRreUt5K3Z2WWEvOGxWd040UmlKVDN3Ymx6akdT?=
 =?utf-8?B?MWJGM2Zpb01SYlZHZ1V5d3o3QkhLTGZkb2xJLzVYcXMzQk9Fd0VGVG9yNmI0?=
 =?utf-8?Q?wdYKdFZHlPf7dCPE=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fb2169d2-2e90-4f1f-3ced-08de5e009658
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2026 00:02:54.9626
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QrqP1/h+QNmEvyZ7HAgiCIElsdTVOB13P85oRZjY+X+T3qHi+JofEB62ih3f6fRwq8TnAKoIsy1qZYx7IDiFBMRT+8NHgQPyaaObDZuYjHQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR11MB8412
X-OriginatorOrg: intel.com

Neeraj Kumar wrote:
> In 84ec985944ef3, devm_cxl_add_nvdimm() sequence was changed and called
> before devm_cxl_add_endpoint(). It's because cxl pmem region auto-assembly
> used to get called at last in cxl_endpoint_port_probe(), which requires
> cxl_nvd presence.

What?

> For cxl region persistency, region creation happens during nvdimm_probe
> which need the completion of endpoint probe.
> 
> In order to accommodate both cxl pmem region auto-assembly and cxl region
> persistency, refactored following
> 
> 1. Re-Sequence devm_cxl_add_nvdimm() after devm_cxl_add_endpoint(). This
>    will be called only after successful completion of endpoint probe.
> 
> 2. Create cxl_region_discovery() which performs pmem region
>    auto-assembly and remove cxl pmem region auto-assembly from
>    cxl_endpoint_port_probe()
> 
> 3. Register cxl_region_discovery() with devm_cxl_add_memdev() which gets
>    called during cxl_pci_probe() in context of cxl_mem_probe()
> 
> 4. As cxlmd->attach->probe() calls registered cxl_region_discovery(), so
>    move devm_cxl_add_nvdimm() before cxlmd->attach->probe(). It guarantees
>    both the completion of endpoint probe and cxl_nvd presence before
>    calling cxlmd->attach->probe().

This does not make sense. The whole point of having
devm_cxl_add_nvdimm() before devm_cxl_add_endpoint() is so that the
typical region discovery path can consider pre-existing decoder settings
*or* nvdimm labels in its assembly decisions.

I would be surprised if this passes existing region assembly and
ordering tests.

This reads like "do not understand current ordering, change it for thin
reasons".

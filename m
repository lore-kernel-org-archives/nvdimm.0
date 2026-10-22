Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=192.198.163.17
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1792634527;
	b=JWx2CF4giU1OSeoGJoPxyXM05LJu07i+rTagxOwEWJOLbAqExdMXBug42HCIXZZCJYQX
	 iHXaHkZTEPzRuNEiASjX7WHbdXvSLlTfcgAExVt414pRjv+8RkKT2Koo/mousGMxWL7Kb
	 KupbJ2s2uPE/p067OoVQyjDSP/UQTDGdqW5adTqNtHfxo1er1zJWRmJyiAvJPdPryvym6
	 fJ/gIJ3o2SGqC0qZUfnLZXtYg8pkt2GslQ/Vef2q1YDPyFehMmjFA2zRcHEYTBwdik7In
	 AclGyWOAiX6FzaC3sXPKb/TLJdPoX2gUKojlRPnQ9DJnIEw0p4JWkQvPWQVoPvzzkKQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792634527;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Received:
	 Received:Received:Received:Date:From:To:CC:Subject:Message-ID:
	 References:Content-Type:Content-Disposition:In-Reply-To:
	 X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
	bh=1jOPAwsnZc4B39f8tXVCMqjgBUJmUOfhoXo+RBkjrPg=;
	b=U+U+tSBmmcPSgxGI6pOTI3Hcv2Vb9DKAwhDjmwu1fg2WsoiVWtDCctMB6tQ0kyW+xtP9
	 BOnjB79yeqY2sAwCGSHlgsaaLEtbpcQ4iFo0kD7qYkg+kmKAksAuh1HC94t88O7thyXoP
	 CrKGyvQW9l2Q0ZYeJINYFPw9d2dIjLFgP42qBao59LeD8xKpdz1CxyZQljYG+iaxbSxU5
	 aju82P6moMJT6AVvZsM0Gj+1bw8aFwscJkh3qPcW4ZAZ65Txi6MuQc1RPbp9YzkLcxFDB
	 +MdHphixvz6R+Ze2AzUoqkXsx1l0DAnFYXfrZJ4ogKXwlulRDL7RjL8b7aQveP5DwDw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=dW0nczbW;
	arc=fail smtp.remote-ip=192.198.163.17
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C93E606A334
	for <nvdimm@lists.linux.dev>; Thu, 22 Oct 2026 02:02:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3C93E606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=dW0nczbW
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792634527; x=1824170527;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=H0ecCsp2kbGfScqolUl6te6Xa3TlmebD0hdWVDMXmjI=;
  b=dW0nczbWXebOTW2BkjxWQGbWiLI0cnOzTCSNa892TiIwM/2vAgJgCC8b
   cKzt4+rJFs+ymlM+mORvfPWYkDi8xMko4u048bM9UkuntB6G6vNuggLFP
   f8zii8Dh8g10gmVvOtUVRRByn1H65dq2aq2hpBIZY6Dh+jXAbQV4UqQX0
   wDnT3H2O8E/6Hfq9x2Ky/cSyN5AhMKcrQENHY/B/aKxpNImuVRSoEwDXS
   AE6AW6oz2N9d7C2Q2gEL/32w1ELuwcKPn/fZ+IhilfjZveNIelWlPNaZQ
   hM+txrKa6vSyx465Wh+8FLhFmu/fEPqrO9XR47iPEX9FnO+6fgi3bgA8n
   g==;
X-CSE-ConnectionGUID: oO9RWS7mQbyZJ6uGLDNKKw==
X-CSE-MsgGUID: NEFAOE95RzWdwkyUa/hpNQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11942"; a="1379133"
X-IronPort-AV: E=Sophos;i="6.27,171,1787036400"; 
   d="scan'208";a="1379133"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2026 19:02:06 -0700
X-CSE-ConnectionGUID: p0tD6ueNTKWc1MdQJFhr8A==
X-CSE-MsgGUID: X2Icj3eeR/ubOoA7hC/1+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,171,1787036400"; 
   d="scan'208";a="3186059"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2026 19:02:06 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 21 Oct 2026 19:02:05 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Wed, 21 Oct 2026 19:02:05 -0700
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.23) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 21 Oct 2026 19:02:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LjYCIYJQQD+N7Ix+X/GwkQySYB9Re+zWK9ealzG1OAKVWfjYpoR6AvVkxi1OfgMSBDc4RzP+ewQchDToMfLX/5Mz/mjY2Y0hfTqRlZaMXP3600nmYU/noIwa6TFHlzJh+pCopcbz8lFH9nZ6D/m9KaI2ZQhyBiFZGU4WjPyPTdaqJrRQjS/Y84vfySYRlgJ9alV8UMwtF6Eqo6E8MJ8QSHsW1WW0luKx0kXU4T+s0L9iwhCFOyCm24X1iSkGE2cCsLYSDybQ/JkEKgV6D0G41HDnYyLN2pDfgFcK7iZ+nrlTMGdcZ2GCzb9z+5Z3LyLkPcd4YeNUP+6CZCZtwJ373A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1jOPAwsnZc4B39f8tXVCMqjgBUJmUOfhoXo+RBkjrPg=;
 b=RQ0ATlWYXru8FJvoFOVSqJoTaEwSz45sMwI3zc3/Urxlv6h/oNbDha00UxGJAbjfCHp1I0zb4xmIfvfzMgWbQ7PThAycT6pK7nUNKG7qT8u7OhjtoO0f7djm0cFVpxIlAJI09MqhA7hnX3Pv6+X6YkysJDEEfUZDk7w58JVzV4RscDGg/kCiTyL8USAhOC07g08UVE66T7coeiKOphcB9EHL6+tcTbCEBkngmnSztDc4LZqRcULDSL7/mkEOwqaZhtawOc6pntK5im5Vg7D58fsrDEa/gGtpEPtmKCorp1YxTvzPbt+jtkTdW6oXXLIHO5Fu3mfd4e4MenciXFceKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by MW5PR11MB5812.namprd11.prod.outlook.com (2603:10b6:303:193::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.19; Thu, 22 Oct
 2026 02:01:56 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::6fbf:c112:d0a8:f1a8%5]) with mapi id 15.21.0546.012; Thu, 22 Oct 2026
 02:01:56 +0000
Date: Wed, 21 Oct 2026 19:01:53 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: "Gregory Price (Meta)" <gourry@gourry.net>
CC: <nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>
Subject: Re: [PATCH 1/6] libdaxctl: add dax kmem atomic hotplug state
 accessors
Message-ID: <atlukTi26FqZO7Ni@aschofie-mobl2.lan>
References: <20261016214248.443247-1-gourry@gourry.net>
 <20261016214248.443247-2-gourry@gourry.net>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20261016214248.443247-2-gourry@gourry.net>
X-ClientProxiedBy: MW4PR04CA0165.namprd04.prod.outlook.com
 (2603:10b6:303:85::20) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|MW5PR11MB5812:EE_
X-MS-Office365-Filtering-Correlation-Id: 185004ba-7b71-4459-49cf-08df2fe07337
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|1800799024|366016|376014|11063799006|4143699003|56012099006|10067099003|261009223027099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: qw2Su/10mYai0ZA4XpWYL9EOHaCjuZ2NeG8iiz+o6cPIYa/OkBUi0Wnu1JpgAL4YTN1hPJWW4h0b3hjxNv50UfX1jlUD2lJW/5T8+u3n+uGeBBbp6DUqhWvjrypDCl0lPREqOuVjI9j2Cd10df2Knadi/9Pfw6OZyb32xPwY2AyVScyw172WjBWmWAOcEMed9YI3CnxnDpYaIRqsUKll04k9MMHMQZ1g3rF36nPv8sVBqDEUxhHasq2kk8jL+GMxqBC9ysY3oeH+8dO7mXJ7h1m/bFvzdZGwpoPKt7qQxTjXu0zRi/piIolTVRiyjHgmCnlnoCFEbpkmzQXtX5+j3V8Q+jBaR93yxR6cVJjleaBye3nuVuwKUwsz0vDh6pq4LWkIPm1BVga4FzVUCLaud4x06pGxiAdbqKtGa7zY5Ff/M2eiBTT6OHWjDmVluQb1KC3eixgjNBXF2NhO8I04OGB9vnspTBjWmTymLc7kBcsLNHhsTQOg6VBp8i5QdJUGNNsZbYolJJVRRGG6T/9m5vTgCPiz0usKnGIM1E8oDzR1M/kDWqjV72SeIugq3KbkPhNuXfPCXRiy6ghNI+lTzUVvTM7t5Z5rNRaCSe2jLy0Cj08rfJMwlCcnRs0A/vzmTrDRTuLqgab1fj0r2EQgKk6j4hVB2iRYioSsuU9miOg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(376014)(11063799006)(4143699003)(56012099006)(10067099003)(261009223027099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YbU9aP8PGnFkxQxyGZi7EB0MpW/61YmRmRszckbKeQi8QlgcwYeCMTZkUiaT?=
 =?us-ascii?Q?LSV7cQSyqbHS86Rs4vIx2IWJEoQVMl7qOend4eC0UJggry8/eZAFr/y+uZ5+?=
 =?us-ascii?Q?qiGfyWJPx4HeKE/A44LQ7IxfddPFCYgsrVFSUgnx1PGBU0kb4XnbIPts+RJd?=
 =?us-ascii?Q?JzmNQ0VKucZUsvR0zAZn28J0SfTiRBN9IHWUC1DRaDYlP8xoqh6xsRQ97iIC?=
 =?us-ascii?Q?Y2iDVKfud/gb/kemfZW8CXtzrEKxfxL27BseWfzQsEjqnboZHUpLBZeOOrOB?=
 =?us-ascii?Q?FZH3sZLH95qGJrfmTNb2Qhme+KvNUA1kKhh38SY/QMGgcBKl9LwUpJZyeoXz?=
 =?us-ascii?Q?Vr20OwsHseN7c8682IaKqgfkXae0oogwb5k6aOddqCnItHmDgHoKz6HC4WPj?=
 =?us-ascii?Q?lDaYvpT692Pl90oUqo324cNswUHJWACD9Ysf7sipveGZdUJeTwI8yFZvdksY?=
 =?us-ascii?Q?lZeCQI65XiaEabll2g+N3JUBA2Lp5jKodvfOJYCBN1MS1quhOrE2btApap1r?=
 =?us-ascii?Q?P6WVuFJcuSWeCdnQ30VSYdMWcWQzWgRxyG4W2PPv7o0r04rR5XOb+/XeFo5/?=
 =?us-ascii?Q?u4UtyrG7uuutmJqdtml0PJt1jBaXnFt9xAEtvNkvjqq+cuP/ZZvYa/+HXqrQ?=
 =?us-ascii?Q?XFUa+FYXYyoQ6Nr3zpzWb+9jBdC+3zlfDpr2GfIQ43B74NDgYw4daFWXPbH1?=
 =?us-ascii?Q?1QssAVTtpNA/BnNETZhc+kiNbXo3R8SyaDJ41vdvIqlbzFOYbSxRbxaB+NnA?=
 =?us-ascii?Q?B4mSDZaUDKCbsb/MQn5cwUeivzYMeZ09impundCqw75JUXJIyhiATzA8sYDq?=
 =?us-ascii?Q?0+hPHafGm9fWLIXLd28I5gMHH8YLZGMycOIeF7IvyAE1SXbppd6zGBcUOKxy?=
 =?us-ascii?Q?3EUecIVgPn2aYuBNP/+Zu3FoMpK7+ACHuhYkZIcFkxBo/mNyuw52wcrPyStC?=
 =?us-ascii?Q?mcqiqsmUzUdLuwE6/c/OQGYlLfF5bt0aA/Bo3AgbnSzfR18HxNw4yTN5fupR?=
 =?us-ascii?Q?tLj2BZUbyKITga2gPCC8VxhOsAfWIA5cuelsl9md5KT65G6XCY0evTdXtq59?=
 =?us-ascii?Q?9rZzi00GybPFL6ZcUtUqD4J1NE9+kg9okfOVJXs+1svz63kKBbDXjTXFjUB3?=
 =?us-ascii?Q?YjKosF3l/7Dunx31JpBwWD39DCiMfqsOsHg9A4Vvn54fkk5Waa2eAOcK1LHG?=
 =?us-ascii?Q?Jq5A6SoOIIuekWtsWhgdHAMBVzwOR26OXbyI8Iwv5R5PQqhl7eDKpNInMP+O?=
 =?us-ascii?Q?MbsUT8sWihgxQhCVG37suc7PcPGQpuX07TNhXexPTKulkukl1iBT4yJ2SA6W?=
 =?us-ascii?Q?6VpLKPnwA/XQyjxEQQDSZFVCsQSnrQbBO60aBgjIPJj7jaPhL4Sjde9YSxjs?=
 =?us-ascii?Q?sMfyyrh7uesOwPrEnlsW2CTZGT9i+6uspM0XPSGUVxI4HYJkWH4vPHJ7qTuX?=
 =?us-ascii?Q?HhnOEzHGVMm3w8eaDRjtIdbYsIYHVIMz/vcaFmYFCfqdjmJVO9nxS2WOOADu?=
 =?us-ascii?Q?4koxBklJwvpDy8XXRf6bwGr57M7a6Sos4ThwiNMfk6Gpl3Za5vFWPY5sH15E?=
 =?us-ascii?Q?yrx2ws/QVBjCUf2/4bD3Z1dLg09jSD+MNoWTehHlthE+8tg4F0RuUTfayuOS?=
 =?us-ascii?Q?wgvr+bTsYbTU2NvzF/lDVlfcByUkMti0mPWnUH543H5D/ISdqvU0LW4OB5Qq?=
 =?us-ascii?Q?I2AGyd7uEpCvKyHxloq5sG2H67AtAcWm7kDLuy40RP61fjdCY6RnzWI26wDJ?=
 =?us-ascii?Q?FmWg9a7ImLvTcQF3mmeHInCkWXy7G9k=3D?=
X-Exchange-RoutingPolicyChecked: c2YywnbgNDMBAuGH6vWgS+Q8HPCB2THAdyAuVRDLta3fOHfxML3toisdgkLcF/FPX9Q/uzVto/k9dTmZxMukNsNTs/vq8SKsbpCgu1F4Za0M5aIAypgrisBWLMLiYt/P2fqlemyMLhQ47bulQpSkDBAFw6x9QX+pD//hd7yLj0lPNylcvLQsel3kY3iAYn+Q8kAW+7OMAp61ZeVHPCZ9kZCNmFI7l9oIXINuf+k9Uux9kffdoP1pdwM9x6ROOzryWABk72hKVhmGZiQm451ZsNo7hD5dDFgC30idZ4rg1SSpVtnzlWWLaKOyG+gMEF5RRiCMygxG+hrHtYVLB0s+Kw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 185004ba-7b71-4459-49cf-08df2fe07337
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2026 02:01:56.4114
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2fwsJy1BA4c04dzWSVHvXKptrfn3wdp6L6Kv7s4HI39XQ2sIjN/G8V+w43ZFYa1DcI75FV+9MiYlcC12+kIbKTRVSkZh3f6B67cRG+uNFI8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR11MB5812
X-OriginatorOrg: intel.com

On Fri, Oct 16, 2026 at 05:42:43PM -0400, Gregory Price (Meta) wrote:
> From: Gregory Price <gourry@gourry.net>
> 
> Recent kernels add /sys/bus/dax/devices/daxX.Y/state to dax_kmem
> devices for atomic whole-device hotplug. It reads 'unplugged',
> 'offline', 'online', 'online_kernel' or 'online_movable', and accepts
> all but 'offline'.
> 
> Add an enum and get/set accessors for it. The getter returns
> DAXCTL_KMEM_UNKNOWN when the attribute is absent, so callers can fall
> back to per-block operations.


Reviewed-by: Alison Schofield <alison.schofield@intel.com>

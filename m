Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 864CD1E3761
	for <nvdimm@lists.linux.dev>; Sun, 13 Apr 2025 22:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744584745; cv=fail; b=nUT3sI2zIQ5w0aTqB+4zFloFsZATGtzNKdkw+0kVp+itpfX5WgBtkYDIQI+/VjrZoMIAo9PktoklP8tU4Ggx53YVHIzoXMO9qtfE2un3KM+ldJ47gA6IdHM+8mzpPajtd/lZp+WJ0TdUg/g8llVJRXH5X6Y00Fq8A09AGedPrEA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744584745; c=relaxed/simple;
	bh=aPQ2lOD5FZgte//V4Fn7ZiP0+wnZl/4oLYzAK/mFmrY=;
	h=From:Date:Subject:Content-Type:Message-ID:References:In-Reply-To:
	 To:CC:MIME-Version; b=KxEi5AoIWmhvWfB8KM8x/MdqJ6P2uBRdtE3Er3l9gf+S7tfgGqqbRj55o8ZZ6Tiqas5n2/mLWJW9f56Ud4IKYOSYHr1r7CuDlGsmpoXFxzOmE412GWUjp+eeDxfQ1+/t/OUT/KlZsIe4syOrugdOBOQSR0ZZeApAh814g7kHV1A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OGPcYGN1; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OGPcYGN1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744584743; x=1776120743;
  h=from:date:subject:content-transfer-encoding:message-id:
   references:in-reply-to:to:cc:mime-version;
  bh=aPQ2lOD5FZgte//V4Fn7ZiP0+wnZl/4oLYzAK/mFmrY=;
  b=OGPcYGN1ZfX43HBqsj0kV4l5G8fvY8MrQ3fDWrFJcPIDQqjJjj4vcA6n
   VkUkn+4flZaYS54fdytrKVwDrt9LgQWk2iRYN9/WnaZsFJJUjGYgrs13T
   Xo53VsWEI1ak38U74NHs8QikeVg0BEK0c3UpQl/wRuOJBU+HZ+62SFcaE
   ayv7eTeZhhr0v5BYYCTyKp+bMxjAKvRQ0kqo91no1OqDffoPRbg0NpPOb
   GsU//aEsfhhb1v+8MzU+9KgZlZCpNuSsU5DTMXmDjTw2zCuBXtUdJFdVt
   5HeuPaQNP5yiFh8tjIWfJdXsY2EXPmxqMzx2FnDNcl9Df62eZEmNTdqbS
   Q==;
X-CSE-ConnectionGUID: WqJPtTuaSTi4NISi8TF3bQ==
X-CSE-MsgGUID: X22zmqQeSXSYwPOYtOO/Sw==
X-IronPort-AV: E=McAfee;i="6700,10204,11402"; a="71431143"
X-IronPort-AV: E=Sophos;i="6.15,211,1739865600"; 
   d="scan'208";a="71431143"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2025 15:52:21 -0700
X-CSE-ConnectionGUID: c9bybS/FR/+oSZj1Jn00Cg==
X-CSE-MsgGUID: blq2GIj7Tvu9Lxji5nAteQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,211,1739865600"; 
   d="scan'208";a="134405572"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2025 15:52:21 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Sun, 13 Apr 2025 15:52:20 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Sun, 13 Apr 2025 15:52:20 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.43) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Sun, 13 Apr 2025 15:52:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nwMAU3Zff3b9XMbFxV9gmsB/9QZqvSLb6+/cVEVEHXNY48TLL4FPq7Vl7kHW/MqnTJ9VIaAjAqPcN+54++FxwdudZrOuhsGNF4xiq4hUXC8N1ENJ7FtpJ8df7rbZQGeJaXWmxDYiuwqjUXdo+bqSpcG34hZHoXqZWROMDmOk1PthNb0XfLwGDok7vS3nM6K3G6TazD4drkfyfKf2GdPwhWO2oSBWD+E6fE7PwvSlGqgtk34Mbl6WyuRkaJ8uczdDay1lAqo6V0/cPzg6weFIJ+IwnEUgVSi5LWFSkCfkhYZSZO2J7QwN0N5irkuguG5HgUT7DzYMH4mmFgg03RWx2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KFSfKXdaijHdUR2EX8XUxITwaBLjdOOX4vtm8g6BPfA=;
 b=mI3Z47dOseu8TcHkGqt/6zxoMq4AlhCfMKtva4VMXc4VuPkplkwYeXOXwiMYY9+AleGNkz0dXIY6KJBBfDEOWBbt/PEhqrnXy2DepwhnXvt/UvotvFN764jLBVOCM/YbC8uuy4nK2o+RaPw6EGawLZQPICQmO1JHtwhMYExDqKvEADWSkXPTNxJKUc8BJ6vYxzbrL6y+Zorj9kPGuasJ2H7q3k+k4AuRiNkpgCqTt9R5yjpaKFfIHaRLW9G3OoS015NWWFzv6FBZq8kkyc2Xkr/GCa/bHaUnRlvVlJniNRZA5kfRWUDnTGYy1xD5NnKZeVxdzZ1m1r6v/ZAB0u4ZRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MW4PR11MB6739.namprd11.prod.outlook.com (2603:10b6:303:20b::19)
 by PH7PR11MB7003.namprd11.prod.outlook.com (2603:10b6:510:20a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.33; Sun, 13 Apr
 2025 22:52:10 +0000
Received: from MW4PR11MB6739.namprd11.prod.outlook.com
 ([fe80::a7ad:a6e8:fced:3f24]) by MW4PR11MB6739.namprd11.prod.outlook.com
 ([fe80::a7ad:a6e8:fced:3f24%4]) with mapi id 15.20.8606.033; Sun, 13 Apr 2025
 22:52:10 +0000
From: Ira Weiny <ira.weiny@intel.com>
Date: Sun, 13 Apr 2025 17:52:25 -0500
Subject: [PATCH v9 17/19] cxl/mem: Trace Dynamic capacity Event Record
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20250413-dcd-type2-upstream-v9-17-1d4911a0b365@intel.com>
References: <20250413-dcd-type2-upstream-v9-0-1d4911a0b365@intel.com>
In-Reply-To: <20250413-dcd-type2-upstream-v9-0-1d4911a0b365@intel.com>
To: Dave Jiang <dave.jiang@intel.com>, Fan Ni <fan.ni@samsung.com>, "Jonathan
 Cameron" <Jonathan.Cameron@huawei.com>
CC: Dan Williams <dan.j.williams@intel.com>, Davidlohr Bueso
	<dave@stgolabs.net>, Alison Schofield <alison.schofield@intel.com>, "Vishal
 Verma" <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	<linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>
X-Mailer: b4 0.15-dev-c25d1
X-Developer-Signature: v=1; a=ed25519-sha256; t=1744584735; l=3493;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=aPQ2lOD5FZgte//V4Fn7ZiP0+wnZl/4oLYzAK/mFmrY=;
 b=k8Fdmu2rZNvNMh7qXVZD4E1W4tdqS8wxeoYskhYO5Th92GdtLTQFn2XPde1mfzC8hCpOtvPp2
 dQ//+GOxzbPDtNEqeP1qRDNxewxFwkDEJKt5QDpqPhDWSYOs9UnQhM/
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
X-MS-TrafficTypeDiagnostic: MW4PR11MB6739:EE_|PH7PR11MB7003:EE_
X-MS-Office365-Filtering-Correlation-Id: a4449e40-e3a4-4dbb-a319-08dd7addd321
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?M0FDZmF4cHk3STdEaXpPSkxsVGxyaUZlczRBOFQvUThhSjRrd2Izcko5YWln?=
 =?utf-8?B?R0UxZm1pNExEWVBaMjRmemg1RUZCbnp4M1l3dUxMdlJZUFVZUFJBSGtjVTJS?=
 =?utf-8?B?Yk9XMW9qU3EySUxhaDhFeDcrTTNMWjd6dEJKczdmTmUvM1gvSVdwOFBpU1NQ?=
 =?utf-8?B?cWxCOXRHekphSElSSkxiOW1vSS8rbGk3dmxhY2VnZzZHb0NlcnhrTlZHZXVV?=
 =?utf-8?B?YXZOWVBMSHNkTUN4akZoOWpybVEzSlZhQkc3QkE1VDIySDUrOUNRWHlScHFj?=
 =?utf-8?B?andva2szZkFwN0NZcm1vdTFjblNXMElLLzAxbUtBcUN2cyt5aEs5R0JlM1dl?=
 =?utf-8?B?L0FvWlVIOTE3YkZpUDgwTkFSaGF6aWp3dHNTanJNTHloWVhEK3dWVG55b3J2?=
 =?utf-8?B?YVd1UDlWcEg2dXc0blFJR1VaOUs4dVBNSzFxNUxIdno1SHNpaURNRUNnUWdD?=
 =?utf-8?B?SjM3ckdMWWl5NkZDUmdnN0ErdStNNUVmQXgwWnd1Znh6WUx3dHNCK2JkM0ty?=
 =?utf-8?B?NVZqMXZUd25LTzQ5ZHVFSVVwQUVoNXRoU3cyRHJJVXJsRk1EbEplbVBUK2Iz?=
 =?utf-8?B?dWRMM2NLVE9QaFQxRG1zeTRYZEgrRndTN1JZcHhCaXBldEptRWhiak12eUd0?=
 =?utf-8?B?M3BOWWtDQW1QbmlJTkIwdEhKU01wdTZhK2ZCblN0cVAxZGpqUDdhd053SXBQ?=
 =?utf-8?B?TEYxM0pOVWhubXJtQnNZQXVTSG9HcnhFSXFzMWtuOEdpMU1rYnF0R1oyNDJo?=
 =?utf-8?B?NW96dk56cENSNHVYYkNBNThiKytXWmdNeW9jaTNnb0w4ZG1VUTQwd0FPZWt5?=
 =?utf-8?B?Rjd4ZEY1NkFsL3FlcjVYdzFIRk1MSVUwWVhBc2V3Q0ppazVTNVlnUHJaOU01?=
 =?utf-8?B?ZHliSjJKMExZekhJbW5YK0V4dUFhNlByVkNIOVJZM3J5cnhhR3JWcDdmTWRr?=
 =?utf-8?B?QlJFZDFrZ0xtZUZpYldvaUNsaVBaTDc3OWFvdi9iMGlXejU5SGVpL0JFaEZB?=
 =?utf-8?B?U2MwSk96dkZENFlzY1FyekV2UnM3OW1VSW0rYWk3S3NVOUtVK3JLVFB1YjJn?=
 =?utf-8?B?MGhGamdxRmFJWTJjVXJaa1MvanR3eFVVelBnUjNzKzRMdVl4RXRmRnFXcFEw?=
 =?utf-8?B?VVBaY054bG9scHJoeW1SUGhia1ZrdEphVDVLUENQejNIRm5BaUJwMklJQmJS?=
 =?utf-8?B?WjFIVlU5bkROQWlaTlh1alRZQ1JEWUphNWNIb1JaTG1kalZqQ3BYdDBBa0th?=
 =?utf-8?B?RmVWSURrcnFIbSsrcXQvWWYzeG1GRXVhcjQ3QWljdVh6eW5wWmh3c0tvQklz?=
 =?utf-8?B?UEo4clN6b21QMkVvVGhJS0pqcTFNS0dOeU9id1NhVjJ0aCtpY1U4eG4vSEhh?=
 =?utf-8?B?R3p1VmQ0eWhCTmRQLzdpU3pwNGZJa1Y4RStKalBEMDZEc0UwMUUvYkxJOUdi?=
 =?utf-8?B?TGF1NlB4MG9tdjJieXZtTUF1Q2xRUk84N1JoUE1MS1I1em9laXlRZHRwYjUw?=
 =?utf-8?B?LzF0WHkvVE1CRnB0MHNaZUdKb29BY1pYMzUyMVpZUElQM1BZbEVuVDUrRHEr?=
 =?utf-8?B?Z2pQb0dSSW8zcGxqVTZwNXdYaWVJTFNNREJPdERKdUVpUm5NSGx2T2lzSlE0?=
 =?utf-8?B?dTJWd1RvVjJ4cUkwUTBWL2tNSFN1K3dVQ2wvMW8ydFB2ZEpXM3FGZUtueEZO?=
 =?utf-8?B?ck4wbTlrMkxiOEdvNEU3VU5zSWdVQXhaOTgvS2laVlZhc2N2VzR4Vnh2M1VZ?=
 =?utf-8?B?M1VUUUpGNlVxWjQ3aDU2YmRuYmI5em9pQ2xVNElJVGsvNC9JcEozK3JYZ0xZ?=
 =?utf-8?B?K3RDVzMzWEhDdDhSZ3NPY1lkRXhWcm45YlVnbUs0QzlROFJsTHdpRGMxZGpx?=
 =?utf-8?B?SGxkakxpVmxPZDN3Skh1aDAyQTczOGt4NEoyUXU5eFpHdG96RkJGUnJRdHcr?=
 =?utf-8?Q?tPJjRp4DXhk=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB6739.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d1NNTmdFcVphZWhYN3ZXNDB6clZsOC9PeWpEZ3F4Zm9QSUZlZDFqaGFuSGVT?=
 =?utf-8?B?RGM4Y3NDVHZ0TEY4dFEzeDQ0TUs4ZUR2SW5sT1F6MVcrTFY5RUp4UEU4dFRt?=
 =?utf-8?B?YlRXTkI4QzJTb3BpdDVXVDcvR2FBYlhtVUF3ZEQ5c0tYdlJCMytQZ1dkaVps?=
 =?utf-8?B?MnlhMDV5bmJJNDBUdTl0eW1xZzV2K1RFNG50VHVUZVhZWFBubE1yWm9hUEMz?=
 =?utf-8?B?QXp1MUFUVUdjbzA2Zm1OT1FjeFVTZ0ZycStRMUExWnp1dGZEakhmNktjSXFw?=
 =?utf-8?B?bTBUTElQcnFhUTNhc1VGbFlPVk5nYW14blU3M3U3dFEvTGd6SVovRFZjclM1?=
 =?utf-8?B?VXFTYXlGK1NGb1JOL2VLQm0rZnBqZlNJb0wvOU5nNC9ZM0FsL3ZiaUVyUk1Z?=
 =?utf-8?B?cFhRcXhvVnVXN3BXWkVmUGdPVFA5VldPT3V2N2h0clZjczBpdlJIbHJiNVNv?=
 =?utf-8?B?Q2R2VTdGZk5ObG5kRU1WYkJ0NTk5Tm5HZHh3dkJvOUN4UEhldTNWZ2ovU3Zy?=
 =?utf-8?B?Z2o1Ti9BNDRlT0RIV2pEZUNDcW4zcjg4dHJTQjFXTHVwdmplN2hrSVBvYWpN?=
 =?utf-8?B?VEw4cDdmUzhGc1ZNcHlnMkRtZXU2VjRraXZCSndQK0praHFyc1ZubUJpNkhR?=
 =?utf-8?B?ZW8wakJGWjBiZ0hpMnlCdG4rR3JEQ0xBTUZnWUR2V28xUDNrUTE0QUR5WkpD?=
 =?utf-8?B?bEJvc3dHQTNaNC9CRTZwZ3c0ZDIxNlgzTk9FdGV3R0F6aUgvTWpvWFRRQkJ4?=
 =?utf-8?B?VXMzMkhYTXFFbko0M2lDclRGSENUZDN0cjhiR1FVWFl2T0NzaiswWUxoZFdG?=
 =?utf-8?B?SFpCR28zbk1uTnB2c0xJWkxza2hWdEFBTldLOUVkZ1RReHd4V1diSW0rZmZ1?=
 =?utf-8?B?Z1FPTUFkNXJtZDJpYkV6a0haM1BDOVFOOUEyL3dMeWl2cGpUVTgwcnpXTGlH?=
 =?utf-8?B?d1hFZU8wWlhFaUFLL2p3MTJKZG5wKzg4LzVIanJRbzBtbTVEVllJdldpSGQ0?=
 =?utf-8?B?ZEJWM3Fjdk5kdmhlR2M1eU9rYkF6OXYyTHB5bUtkc2QyN3UzcXRJeTlIZDlT?=
 =?utf-8?B?Rko3akhPNEpmQlRuVzlVeWN6WVlPMlVOdVdnTmdyTnBpUTRHZzdBWG9oK3Fs?=
 =?utf-8?B?bWUvLzhSVi9LMGlQSmdwcjVUQXZGeW5WWU1OYit3eUFCZHRpMHZyUnNKM01z?=
 =?utf-8?B?MVZRU0dvczVVVlBDVnRIR2NiUzZuVWN1VXVSNDNQR3VxSEh3SHByMDUwcy9q?=
 =?utf-8?B?ZWg0dllWRGVwajIxbng5aGp1akVUaWp6ZTVsVjNYNkJXY2tGdE8yYTBYSEtY?=
 =?utf-8?B?dk50TVJLLzBxU2JTTUpraGZrdXl1bjVvZ0JFaC9PRlI2T0VVVk4yZStOWkNz?=
 =?utf-8?B?NHNQdWgyTGF4NnVmRDZvN3ZieWZUUUI1WFlpSUxPd1lab1FNZzdhNmNHaXJU?=
 =?utf-8?B?dW90MmlXdGtSdXRjNW1KeUU5MlY5b1IzYkJKeGZBRXZkS0h1bzB4N1pXa0ti?=
 =?utf-8?B?eHREUERXNWJQSlo4ZHpmaHE5UnZmTjlOU2tOSTY2REE0L0Rmc1dLNjcrMWpl?=
 =?utf-8?B?U1pjcEJ2SHJNYlhVM0p3azZ1eklmQmVRd2txOG5yWmpXU0NLalNlcTBOVGNQ?=
 =?utf-8?B?V0NqTmtnd3VKNVlCak52anNzZUc0Z1ZjZWVNb0VLZ2xPc3o5dU4wZUtyblRl?=
 =?utf-8?B?ODMrUjZ1QTF5OFU1UDR4SGpEM2VBY0hrQlZLVHY5bzJHbkZoWVl3YWNhaTVN?=
 =?utf-8?B?NmVqcWNmZ294Nm1XSm9xMWdJcThDUzJXQU9COE5mUmVPR0xLQ25vOENwV0dx?=
 =?utf-8?B?UlNKaTQzOGpPcTBLV2YwU1hWbnh2Q1JMK3pxVHRoME00NU8rNllUSllheGlm?=
 =?utf-8?B?TjQvM29HYUkyUzVHVDc2WlNQYmVDaEVYdkVSbDlkV29ST1lBb1JTS2JrZlBa?=
 =?utf-8?B?OVBXVFE3bVY5Q2RoM3hwM1Zud29veTVqQzRKSjY0V2xGRTNqd3ZsOFRSamhK?=
 =?utf-8?B?TkFWSXpmZHZPeVp5YVRaVlhMZXhIL1JwL1ZxL2FMZ0dVdEQ1YWN2ZEl1QmE3?=
 =?utf-8?B?ZGFVY2F5bkJBZUVKblRkTmtRd1FqQjVPbjhwT2pDSVRFREpZeEZHSUtJdGQy?=
 =?utf-8?Q?ypu8Nv3yRas5gTdb0F2e5HE9E?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a4449e40-e3a4-4dbb-a319-08dd7addd321
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB6739.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2025 22:52:10.7614
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qYTw3yC1BBPZV9xkSDLOy1gc62cTbg0L5P/i9KJA+gQn7KVhGaW6Au9Cud8zJQSwsqkRKl0m61LU+um7OauvJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7003
X-OriginatorOrg: intel.com

CXL rev 3.1 section 8.2.9.2.1 adds the Dynamic Capacity Event Records.
User space can use trace events for debugging of DC capacity changes.

Add DC trace points to the trace log.

Based on an original patch by Navneet Singh.

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Fan Ni <fan.ni@samsung.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>

---
Changes:
[djbw: s/region/partition/]
[iweiny: s/tag/uuid/]
---
 drivers/cxl/core/mbox.c  |  4 +++
 drivers/cxl/core/trace.h | 65 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 69 insertions(+)

diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
index 8af3a4173b99..891a213ce7be 100644
--- a/drivers/cxl/core/mbox.c
+++ b/drivers/cxl/core/mbox.c
@@ -1043,6 +1043,10 @@ static void __cxl_event_trace_record(const struct cxl_memdev *cxlmd,
 		ev_type = CXL_CPER_EVENT_DRAM;
 	else if (uuid_equal(uuid, &CXL_EVENT_MEM_MODULE_UUID))
 		ev_type = CXL_CPER_EVENT_MEM_MODULE;
+	else if (uuid_equal(uuid, &CXL_EVENT_DC_EVENT_UUID)) {
+		trace_cxl_dynamic_capacity(cxlmd, type, &record->event.dcd);
+		return;
+	}
 
 	cxl_event_trace_record(cxlmd, type, ev_type, uuid, &record->event);
 }
diff --git a/drivers/cxl/core/trace.h b/drivers/cxl/core/trace.h
index 25ebfbc1616c..384017259970 100644
--- a/drivers/cxl/core/trace.h
+++ b/drivers/cxl/core/trace.h
@@ -978,6 +978,71 @@ TRACE_EVENT(cxl_poison,
 	)
 );
 
+/*
+ * Dynamic Capacity Event Record - DER
+ *
+ * CXL rev 3.1 section 8.2.9.2.1.6 Table 8-50
+ */
+
+#define CXL_DC_ADD_CAPACITY			0x00
+#define CXL_DC_REL_CAPACITY			0x01
+#define CXL_DC_FORCED_REL_CAPACITY		0x02
+#define CXL_DC_REG_CONF_UPDATED			0x03
+#define show_dc_evt_type(type)	__print_symbolic(type,		\
+	{ CXL_DC_ADD_CAPACITY,	"Add capacity"},		\
+	{ CXL_DC_REL_CAPACITY,	"Release capacity"},		\
+	{ CXL_DC_FORCED_REL_CAPACITY,	"Forced capacity release"},	\
+	{ CXL_DC_REG_CONF_UPDATED,	"Region Configuration Updated"	} \
+)
+
+TRACE_EVENT(cxl_dynamic_capacity,
+
+	TP_PROTO(const struct cxl_memdev *cxlmd, enum cxl_event_log_type log,
+		 struct cxl_event_dcd *rec),
+
+	TP_ARGS(cxlmd, log, rec),
+
+	TP_STRUCT__entry(
+		CXL_EVT_TP_entry
+
+		/* Dynamic capacity Event */
+		__field(u8, event_type)
+		__field(u16, hostid)
+		__field(u8, partition_id)
+		__field(u64, dpa_start)
+		__field(u64, length)
+		__array(u8, uuid, UUID_SIZE)
+		__field(u16, sh_extent_seq)
+	),
+
+	TP_fast_assign(
+		CXL_EVT_TP_fast_assign(cxlmd, log, rec->hdr);
+
+		/* Dynamic_capacity Event */
+		__entry->event_type = rec->event_type;
+
+		/* DCD event record data */
+		__entry->hostid = le16_to_cpu(rec->host_id);
+		__entry->partition_id = rec->partition_index;
+		__entry->dpa_start = le64_to_cpu(rec->extent.start_dpa);
+		__entry->length = le64_to_cpu(rec->extent.length);
+		memcpy(__entry->uuid, &rec->extent.uuid, UUID_SIZE);
+		__entry->sh_extent_seq = le16_to_cpu(rec->extent.shared_extn_seq);
+	),
+
+	CXL_EVT_TP_printk("event_type='%s' host_id='%d' partition_id='%d' " \
+		"starting_dpa=%llx length=%llx tag=%pU " \
+		"shared_extent_sequence=%d",
+		show_dc_evt_type(__entry->event_type),
+		__entry->hostid,
+		__entry->partition_id,
+		__entry->dpa_start,
+		__entry->length,
+		__entry->uuid,
+		__entry->sh_extent_seq
+	)
+);
+
 #endif /* _CXL_EVENTS_H */
 
 #define TRACE_INCLUDE_FILE trace

-- 
2.49.0


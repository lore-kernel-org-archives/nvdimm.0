Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 705692135AD
	for <nvdimm@lists.linux.dev>; Wed,  9 Apr 2025 23:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744242229; cv=fail; b=ZRhI0lZhBWK8W3RJ0vH/7a5H65OCfJg+yKWp7rQ7FzyCD8Fa5o4bRO9Y8/QfwD486fued75wYoJ6yc/bX33aDDtptOWlSrinibYYzARAQvYx4VFOSvLyTm4pEvJZdgGw+XMReo5BqwMIgBDgsVbCs+Sgxd1YKnrXSdQj1eHwyjk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744242229; c=relaxed/simple;
	bh=H7i5aAimX7kqnteNx/jr+HDYdOG2RrQIrQFgYkIPv6Y=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=kEo3xT2FAr929RPKYwWTP33OuunAiIm+Fltwm4GM1QrxiI8Lzc3g9FDD90dcFWQiqitW6/fpcwZVBVE8vBS+zQyYHURyQOK99nraGhfgRnTyrg+1wogDGFWqOTVHybT7qSSRHatJ5pqs4ZxS4AoH3JsIz/VB4EEa97WNIM2ACHU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IydYlaj+; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IydYlaj+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744242227; x=1775778227;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=H7i5aAimX7kqnteNx/jr+HDYdOG2RrQIrQFgYkIPv6Y=;
  b=IydYlaj+9pYzeQxJKWa4s1rrVYRxPDS6c7o0xMs23JUtrGxCqJGlAhTT
   2tSxMDgkN6QKGr+PUsZwtS+pqIivfgbzyCbq0UWmWjKgp/WsabjNgCqHJ
   nPx+wSgilyIQDZGj3XffL7HBqUZUlY1ovtqdebn2Ttw6j6fP0XmU3pMhZ
   0ATX2IxS1s3Diyb4s58S/AbCcZOA0hCYPGw39vsWm6JU+XUALIlpB6u4o
   Tbc2LmCimMQyQ/JPsOssEEPRRJSeimzXn/KDMpjlHVcEl3BlBIHA/yAzi
   V+FWKUhAleDql74Zc7AWdNq7H9vKjzPjQzwLpOYiSc8aHMIq638gJgyCZ
   g==;
X-CSE-ConnectionGUID: MhTpgw0+SUqOchLFsvDXrQ==
X-CSE-MsgGUID: jqcHrdTPTpupyAFAcDzvSw==
X-IronPort-AV: E=McAfee;i="6700,10204,11399"; a="56408249"
X-IronPort-AV: E=Sophos;i="6.15,201,1739865600"; 
   d="scan'208";a="56408249"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2025 16:43:38 -0700
X-CSE-ConnectionGUID: qvI7LYZIRdmCUlO4FwhvUg==
X-CSE-MsgGUID: PEpk7/hPTCWJNMn15Vgg6Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,201,1739865600"; 
   d="scan'208";a="159714448"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2025 16:43:38 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 9 Apr 2025 16:43:37 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Wed, 9 Apr 2025 16:43:37 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.41) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 9 Apr 2025 16:43:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nu/F4tZ72TEFX3QGx9FWU+JlJJVJ8IWpZZ2ICbGl2s/Bd7vMKOZx1N3p5Pi3P+7PihK+GekomqYbXJSVIDGadiGMTr2n2hZgM/x1MOlGWGwMhrKjeisW41njb9V+pp8BuDVu7ZD9SH1Q5G86YFDpg6aRLbxi0fGWs6DQHmSzGHWRjFWumfJiBzdvCrXiLay49aia/O2hWmIK8N/0Mn8xSCyihHLVOGQcmTzuuqANUcmqzIYGPk7aKihudsJYyyzqrcoThWSYpRsov5Eu4+c2YC7D6Z180uWAyRYdMUiUURF/qMEteySerLr3MB4yn5TU2QcOoWd2ZyZ4qFh8tyBb4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V4wzjgPbiUgV5bMpPBslWwI7ITUiX7I+CRFFIs9w4rU=;
 b=tyi1+GdHxAwmPaxE+lZ/SA2Pcs2KIiYKzkfdM3w31Py2/n36CVm7ahB2P66SQI2gotmT0TQXuhldBC50oTvt3rUK2gQr3CcX+/Pp2M5SPpvyCGm/lRODqp4/vnerHdxjr77mWKIjcrW9sEqq/zAkBqc2JWfpoMAMhEOscJkR8SLyAd7uD2OEIoYjmuQbDp97B0mVsVNaQs0TZG8e4SBB8A/U4xMP0TH3NzKyfGquBLE5Xt2yD7gQkud0hhKAGSQEJZUx5e54jOdX5ju2p9YOYHPsttOTk0/2r63lyp3SPOY+bxdBy+0ptJDNbm5VaOiCEel3CqH5r2akCN4QLtARwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by DM4PR11MB7254.namprd11.prod.outlook.com (2603:10b6:8:10e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.21; Wed, 9 Apr
 2025 23:43:20 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%3]) with mapi id 15.20.8606.033; Wed, 9 Apr 2025
 23:43:20 +0000
Date: Wed, 9 Apr 2025 16:43:18 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Gregory Price <gourry@gourry.net>, <linux-cxl@vger.kernel.org>
CC: <nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<kernel-team@meta.com>, <dan.j.williams@intel.com>,
	<vishal.l.verma@intel.com>, <dave.jiang@intel.com>, David Hildenbrand
	<david@redhat.com>
Subject: Re: [PATCH v2] DAX: warn when kmem regions are truncated for memory
 block alignment.
Message-ID: <67f7061681282_71fe294b2@dwillia2-xfh.jf.intel.com.notmuch>
References: <20250402015920.819077-1-gourry@gourry.net>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250402015920.819077-1-gourry@gourry.net>
X-ClientProxiedBy: MW4P220CA0002.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:303:115::7) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|DM4PR11MB7254:EE_
X-MS-Office365-Filtering-Correlation-Id: 68c7eb04-8351-4215-1493-08dd77c04f68
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?Ynsh4MsetHELvZJSbE7e+6+RT23k/0MtGD2M9otQjk+HsBRFZ7ZmMJMuEvUx?=
 =?us-ascii?Q?dTGFh8bxOcsiFjZBo0RKmgIHFUVvZJg1N4JX6Iy/etmeFfIUlxikIQfIJLeP?=
 =?us-ascii?Q?PO8YbgYw4bzaFVCMQQIWxMH1ihmJPcJxN27BbQ8mbI6NzsWAgihKLA8r/nfd?=
 =?us-ascii?Q?Q5ec3Kav6787hcImdo3FZnynj0QauEluON10TkDsgCdaAX8EmKRVNa2/T83R?=
 =?us-ascii?Q?Ib9CNum5MGkcOEpNSZq5eQ/QTEROYN66JXQoKdrHGTamMkGGnuT1xxx7NZnJ?=
 =?us-ascii?Q?oqUegvTnixqGB1SF2BUwot6ZGmNxbEG8wvx2Hie6Je4x7eOjf/Q83NQKKPdi?=
 =?us-ascii?Q?iwS2eGe1xSLcNW2sG3HvpyoHWAcC2BHcwa0Qp7CIXaR2rrfJt/RC+zCguXTV?=
 =?us-ascii?Q?RwogAufzLKyj8llA7VligvZlm3cvyzcqGjh8mVMH8u8kSS32IrhOZKm+fLjE?=
 =?us-ascii?Q?uocTZYSIjWqoyt/IEta8DDBjCtCEKGwLN6mgDQtilrxTVrh5litTS9qmfegh?=
 =?us-ascii?Q?9+okuWwz1nVIv2E3w2lTbAXaNyaAhk+Z7gAnsKVp8SyT0LvgVi3wGoqrwHK5?=
 =?us-ascii?Q?txCS7AKbv+DLCIfW7eH9gJrewc1ciyPyypznVjUimp3Ytk6j86IDoTHSOMFV?=
 =?us-ascii?Q?FV2iTOjJ96jqUy5kGocpvGP1u2DDE8J2XWqGbgfOYqAifA9+G/Gr8zH8uCrq?=
 =?us-ascii?Q?tMKoY+M2FW6OFEFjudbK+4DxjOgJwlzxMrRtBPRpbSEQO2gB9yJyL9dEqJ18?=
 =?us-ascii?Q?IbBX9TOr5qhToPH9LABg9EYNOEhwbMNogPDqiCtRy0NDrsYMH1/gfl7QcO3h?=
 =?us-ascii?Q?2E8nd9wNe93kHUtJWzJSjoVtXMCsMEYNOskYMUlSHbduQ3IGASojHCHiKEDG?=
 =?us-ascii?Q?NUf0fD3nWOS6xpfO54v3XqpX+zvPKZFtMFUgRIOfC5sGLXOfulmXAQrAw3/T?=
 =?us-ascii?Q?XjhITCaaO4DUxbwuUaXSVZKdRBmfkL83hzelqElRgmcoen6F/CWIlef44dys?=
 =?us-ascii?Q?K9+FS6tX/22Zc2qbiTmVkcszyyMxyCnk4wa6MWxV9V7QeTASNMzO9LAnYm8R?=
 =?us-ascii?Q?rztPmJF4x7LkCp5Lxi549cixE9pwf68hyCVnn0voMnkQpcbbE93qGV4yG+0N?=
 =?us-ascii?Q?IjN60p4oqlsEW7LR2/6ER7XS+UQFFMheYCr4meFTyQWJU65B8j+nQTArIbDk?=
 =?us-ascii?Q?SIcDr/UaDIeJoBtaI7STafUcXJkk9HWozaKwpCr2tthljVl+Jmc5vxYlO55C?=
 =?us-ascii?Q?1DganwcyDiI7xXW/kmKvUszh0NqFfNQYm1vxWrhlp7YlIyWCnilzKA0Qa9fj?=
 =?us-ascii?Q?SExhuBJRp1HXuol/b/ltt003VNXiikPdQEyc+yPNHDCtgIENFJ7MH4Mx+7xB?=
 =?us-ascii?Q?yLhCcVIYLwohAAUsyRvxruVVud4T?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AcJbsrfUTsbO/4OPeYCEalcPbJr1m+pTLWR+KdWEbkgTU96/sG3Q+KINx6JP?=
 =?us-ascii?Q?WgWUKWhgRy4X3yVYyI8xLoJRswoCyKWBQUSkekkwnsk1f0QLc2V4uP2cXi41?=
 =?us-ascii?Q?/SGY1Is73twxfobNYkyzKW5kllgMjMjUOhzB7bJFa9ofVAaH9VadenhQFmIN?=
 =?us-ascii?Q?W3QvtieeqYZ36FahCEunkLBsiBe4wGc9G7ynMtXiJ4wXDttSgtq5lTmjBCPZ?=
 =?us-ascii?Q?EnF+rcjtGBXlHldVAjluHlKFpMlP4g3ptq8PrILiGBFqdwY8ybVRJgeDkEz9?=
 =?us-ascii?Q?I5IOvCeyKlyQieqPa2FJTSn0hpvrr6BUAuiSZC27z5IeHSYVm7nDqqIDnEzo?=
 =?us-ascii?Q?cWnOkf+qYW2ZAeQqXWfDm9LdAbWGfl1vSL275BKljENKF4Mro5Xp0InE7CfS?=
 =?us-ascii?Q?FICiNXq8yVBld33fX/hLQdF53GyzuNI4qy2kypbIQVJ+bS2AwVPLwFqLir0X?=
 =?us-ascii?Q?VO3G2Li0tcKyzwdACSRBKuWu80TVL+gAcsvj0pcVcML3gYZQR6oU6oTZ2m+7?=
 =?us-ascii?Q?4wfXDXZxxVM1+mCpDIyjpfi46LsfDaRaJ40nSrCYCv9Kp0Xb7PFUecmPH9le?=
 =?us-ascii?Q?f3CWnAhmwFJiqwxh6IBJN9SVlFAAEQb5HRhWOuBrW0Er8cQ8mWop//hLkasg?=
 =?us-ascii?Q?UWZnYrZuAjNvxId/FDfhRe/2lvfr1W8GMXfcJhKNdFSm9Yq+7uJdY82XDIMc?=
 =?us-ascii?Q?qIR8wVtn+hG8W9am2Q1SdYQ6YLB8nyluwfHFouethVhuU9tnxi/i/iZfH6QP?=
 =?us-ascii?Q?AkQUVlXAYEUwYcZ6BsxiKQ/GyjoiaQc+A8GKKKJGiFQ9i4Q1eNkSFx3VGbH2?=
 =?us-ascii?Q?MOxScMLS4J/PWKhBcWH9KMeQDiIU4hGdEJoLTEOD9esCHb8kfx2AEhQYCOKp?=
 =?us-ascii?Q?syDzxxoE+vYOTQWxV2PFJ9gkVbEIuehoppFiUfm5pZeunfTwT0MI37/c1E9Z?=
 =?us-ascii?Q?cdhyDpOjkjKvFgSnapCVYr3s7gE4uwVvuabad04/1oepKFVyJMKMSLZnCu1l?=
 =?us-ascii?Q?RoVhh3EGqWap6Fm/jiesAz9kO1+VaiHVNQEcJqhpME/9qKk2C7/NOIjY2uXE?=
 =?us-ascii?Q?KvaBytX6nD450KxJHXVcAtKVUPLkpUB3l+EYcJXI4XhweQ0ToLhwjS0mCgkw?=
 =?us-ascii?Q?cmW88wjxmyWILarDYHhUZQzcNlj3J5R1aViZ3GbwmpIV8vxDKKo8eUzUW5YC?=
 =?us-ascii?Q?pY3mtyi5HB4N6wQK/049K3jduMYTt9V9nQTrPofDM4VfTRZXuu+JA+us4nLk?=
 =?us-ascii?Q?hJTlHUXwlh+o9ZzLxUzQF0K9bjWH7dne6ukzPzFvSQSsMX3swdkE+/vpABhZ?=
 =?us-ascii?Q?xHPnHPz5wtgNFOhvz3MtBcQxlS8hQOd0SXdFea12OSTmLZm65cFhBuyMYbud?=
 =?us-ascii?Q?f1ncrpuNwPY7CGwBf7kSUGKcjTzk+L+DORju0BgJKpFFecbhjQTIotduDzKu?=
 =?us-ascii?Q?JRl7qdT3t7e8afVV3aVIQl/7PMJbqZqzaMbbxRXsQOQXB+/hpk2naIqMA5HT?=
 =?us-ascii?Q?XgFarhBgkjvwfOO5nYKGfeiOyV5Kj16SiezjxD5kc23bj+onXmYQWnKPFB+M?=
 =?us-ascii?Q?avohPC9bYpDE7YHGHitT3OboQdGSYZiVYpE+RG9zCdsEMOGe51tMOrJzmPXg?=
 =?us-ascii?Q?jQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 68c7eb04-8351-4215-1493-08dd77c04f68
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2025 23:43:20.7642
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IZRBNGuFZ/QMnpmCjEziiUewgSueFLiJcPEJtaCIoOAxNfy/6ALux9f9ftXEC3XwVy6kfIHdwpLVgG2xVChSxid6qytwZ13mrBPuYS0+HP4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB7254
X-OriginatorOrg: intel.com

Gregory Price wrote:
> Device capacity intended for use as system ram should be aligned to the
> archite-defined memory block size or that capacity will be silently
> truncated and capacity stranded.
> 
> As hotplug dax memory becomes more prevelant, the memory block size
> alignment becomes more important for platform and device vendors to
> pay attention to - so this truncation should not be silent.
> 
> This issue is particularly relevant for CXL Dynamic Capacity devices,
> whose capacity may arrive in spec-aligned but block-misaligned chunks.
> 
> Suggested-by: David Hildenbrand <david@redhat.com>
> Suggested-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Gregory Price <gourry@gourry.net>

The typo in the changelog was already noted, and this addresses all my
feedback so feel free to add:

Reviewed-by: Dan Williams <dan.j.williams@intel.com>

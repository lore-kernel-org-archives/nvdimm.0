Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8F431E5718
	for <nvdimm@lists.linux.dev>; Tue, 22 Apr 2025 19:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745348466; cv=fail; b=qP7KAMnJn0Hth4rc80m309d/el6EuQ8f/dk72n6VQ0Yt3GjrhO8RtcT7Hz+zA/EcYD+SUY7D4AOtq40GAjtIC9QsS4PQR+ARnNf/Fc0AROox6wtXSF2USVRKLeHw3pqgaVuNdMwL8KLfiQuO1MQ6xN6Lhr4D3ASdG5nmUs91T/M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745348466; c=relaxed/simple;
	bh=3g8LNrDhdnCLjVtXCnehL0L4/PnSUlXMqrteB9qcr/4=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Z/F5b63A5rs4X3DOO1garmEG3048weD6MrPMNM0G6EnUFaAeZ1+v/6ix13fN9YaGcOlSW7wr727cfbC413gAhcwRwUHzRRaOz22jhpO4ijN04jnfPk0qSEry0Oboicn3vwMSUD7/ANIVY6UDFuIIVv9WmeXxyQLeOwDdaZZgAYI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mgZchXfP; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mgZchXfP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745348464; x=1776884464;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=3g8LNrDhdnCLjVtXCnehL0L4/PnSUlXMqrteB9qcr/4=;
  b=mgZchXfPEjoJoT4fPnEcACuhoUXg7zMGXViV+wj2jUQDMH1KnMkC3Pmj
   vpoGE/IVUcRvVbBJMZsfFmWuC4tPGMHwNGiYkmxldddkFKjpwJQZI1qMM
   asLBI8wnbkmeLO0qby7JsB6xMpLdSwaBaoknBTgPanjb6zWu2sucDnzcV
   Nqe1zXErbCX5WD1yrn77Lnyd+8vqIrTmp0uvrEz/uxDfIr1CKgxLCJkdV
   SlONH4OS2Lr19fXw8jkJDDm6iGpGV6sLKWnzNatHgpKbc0OM/o6rKkrEh
   3SSru74Ge09v42MESX/w7N8kmjOTNbGqnp3NRrXAGqAP0QQY1b7/1n1rC
   Q==;
X-CSE-ConnectionGUID: cPFvtd4URrSkQxS4XZO0UA==
X-CSE-MsgGUID: F/17+XzkTVWbrt7Q7dzzhw==
X-IronPort-AV: E=McAfee;i="6700,10204,11411"; a="47101034"
X-IronPort-AV: E=Sophos;i="6.15,231,1739865600"; 
   d="scan'208";a="47101034"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2025 12:01:02 -0700
X-CSE-ConnectionGUID: m906MdInS2a17Gzo3JhjWw==
X-CSE-MsgGUID: ycuBYyKJS+6XUAErF4aCUA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,231,1739865600"; 
   d="scan'208";a="137254975"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2025 12:01:02 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 22 Apr 2025 12:01:01 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 22 Apr 2025 12:01:01 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.175)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 22 Apr 2025 12:01:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yXTHQXvf1TjU7EK+O/2t3vkVR8CIdrD4IKXe3W7HaKRg7ch8CLxGel2mJVPKZVRDboNuDQ125GVyaB4yUjy7arNZfVtqDe1L1/LihhHgbW4f3Z9w7q/ZRFw0H1RjqW/FuecCBRstP7fVRYBk6mvJ4yQp85XVX6hwQDW2Uh4JFs9s8mnOH1Uxru6aCfTO9R1DVV2EiuKvhYgwBWC4ZIEjIVZBPLqFYjW5bGxc2i9nWQP1XELhtRTDdMudVwpN87dPgQYAfGJz5STqBA6Rw/wxO5XehDLxQlY4GjCCEKCDP5JkUPj83IhQ2MzHxX7ju9gZBi3hgMOhaMU4WlWDN+KaQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0zlAiGGev6S/1PhHZolXEhrCvmWD8+7WFNiOtj4btIc=;
 b=Sjvj7arlbqTknSzg9oprPd0pbBhPCIqX+cfnLrvBUd2MPsxP1UhlQbE5E+E4uvzePKLbUeJSJCJ68zDejsRA+50ULAZYtG77cmQrYkQBoiVE8t3UBT5lNTGIkxLkES93mHTSIsRJ2YS2H6niuab201vp1ojzM77X+j7NXScN0/W8s3J4dCbvOjRRkP4081LNnyX2klmR+Mtpy9zau5FrlSGJ5NszpTaTufhglqB7NavBa3sEsR/xu3r0TnlZ/c9ZTzWV/Q0XJLzkwSELqyGYilzsZjh/ILJJoH9DCvMppjghZFwAzdpOYZGFNpbk2mIhOfI9+UKRjthPUEBOPWZE8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by DS0PR11MB6397.namprd11.prod.outlook.com (2603:10b6:8:ca::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.37; Tue, 22 Apr
 2025 19:00:56 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%4]) with mapi id 15.20.8655.031; Tue, 22 Apr 2025
 19:00:56 +0000
Date: Tue, 22 Apr 2025 12:00:52 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>, Dan Williams
	<dan.j.williams@intel.com>
CC: Michal Clapinski <mclapinski@google.com>, Vishal Verma
	<vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, Ira Weiny
	<ira.weiny@intel.com>, Jonathan Corbet <corbet@lwn.net>,
	<nvdimm@lists.linux.dev>, <linux-doc@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/1] libnvdimm/e820: Add a new parameter to configure
 many regions per e820 entry
Message-ID: <6807e7647d39e_71fe294be@dwillia2-xfh.jf.intel.com.notmuch>
References: <20250417142525.78088-1-mclapinski@google.com>
 <6806d2d6f2aed_71fe294ed@dwillia2-xfh.jf.intel.com.notmuch>
 <CA+CK2bD9QF-8dxd92UBoyvO0rBJ3uTN27pXzO2bALw4v_2D_8g@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+CK2bD9QF-8dxd92UBoyvO0rBJ3uTN27pXzO2bALw4v_2D_8g@mail.gmail.com>
X-ClientProxiedBy: MW4PR03CA0105.namprd03.prod.outlook.com
 (2603:10b6:303:b7::20) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|DS0PR11MB6397:EE_
X-MS-Office365-Filtering-Correlation-Id: 878f6288-b209-4e04-378a-08dd81d002d9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?aGMwMFlNUEM5SldZdXY1a0dOeElwckxQOUl5Rm1tWnpaOEh1MjgxUmJlWERp?=
 =?utf-8?B?b1VqU2Jsbm9TUTJOaWswU24rVitlTVNyTkpGM2xQZU1yL1NEVjkrSmV3dkth?=
 =?utf-8?B?M0NQaG5KOTZmNlFFS1FOeDM1ZE9ZNm04bU9JSzYyemtNaEpXTmRiKzBLeWFv?=
 =?utf-8?B?RW9uY0ZYVE84R28xaW5FZFQ5U0cxR1BoSXI2dXptYkpPMGlKMEQ3MFlRWUtr?=
 =?utf-8?B?RUxJSDFBK0FObElUd1F1OGtFSU9xbzFjOVJOY2tXUU9DcVhneE5NNkNmVkVG?=
 =?utf-8?B?eFdCbW44MjYzVHRFNGtkZS9MaWZLZHZhOGZMNnlSQ0lNaXEydlZvYWNDOU40?=
 =?utf-8?B?ZUYveFBMZkdUYjhuRjZoenkrK24zUkhBZFNkZVhiQW80b0FBcktjaEdZSVFo?=
 =?utf-8?B?K3hDYXNmUG93Qmpab3FVZ2h5cXhKWHNFWS9Edlk5c3RPSGtEZVQ4RVlJMHRy?=
 =?utf-8?B?cXRuVUNrVXBvRzhtSW1VYncyTmpSZk1wY3lOUlI1UE1OU1phRUdkYlBXVjNj?=
 =?utf-8?B?bXhPc0VzQis3UkJycTVXbXcySjF4R0JlV2NqcWsycFV0Y29hcEQzZjYzT21h?=
 =?utf-8?B?Z0NDeENFYVdVVG14alBtRmtpb2xWamsrQXlZNnppcDNTT25adVlMRU5hM2FK?=
 =?utf-8?B?N0xoVW5jSE92dXpqblJSUXpLQXdibythLzNoSlBMZXhXSjlxN3puOXlQdXdy?=
 =?utf-8?B?WnE2cUttTkNGZGZHSURZeUlpTnBZaXp6d242T0phdHFZR0pDVFBxU0MwZDhw?=
 =?utf-8?B?Rm43ekdTckxBOEY4VVQ0QzBWNG1vTkhZVG92a3hnU3VoTXhzMEpMY1o1MzBN?=
 =?utf-8?B?dS9TU1pueDB6NE1ZL2FCL2swRTJOM0w0QlIwOERoL1kyK092SXdVbDRFdjZX?=
 =?utf-8?B?NDEyL2tQajZZZ3BZVGg4MDJtcDVKWEZqaXovT2V4cS9SZGdrRHdGa0VMamE3?=
 =?utf-8?B?ZS9RUmQwUW1LcFg3VlNmbkQ1Q2hPU3BjclZPWThPUnlTMlQvUEZVbUFOK0Np?=
 =?utf-8?B?djlSVFJKektzTlh1TnlHZkw2RlpOaU9yZGZueWtFYTNIREpQWWp2NWNSdmM4?=
 =?utf-8?B?VUhEZFJtaWpsK2RQR2V3Qm9US2J0cWlFb2FEdWdwQnFSZVQwckk1QUpZdUhR?=
 =?utf-8?B?S3ZwYkM0Z1BzazFFc0NLazZqUllUV1VkbTRvYlp3NlpyaXFqTlNRSHk4ZW1o?=
 =?utf-8?B?RmYvNnZsM1JpMVdsZHcxQmJ3Wm1FQzFxbmFVc1cxRGtoQ3FldmVuWDNJejcr?=
 =?utf-8?B?K2V0ZExNMDZ6aVAybXd6WmlleWVnMVlkQ2ZNTnd3V09uTmYzb2VCQmREcm13?=
 =?utf-8?B?QlZmc0VPTEQ1elVNZmFxUVorNHorMWVWTzBoN1QzZkxzK3FqQ1VFcSswRFkz?=
 =?utf-8?B?ZFZ6ZUxHUmJFUkhlTXVsSGlTSHNPZUxlZ2FsYWtyNDI2ajcrbFg4VTZUR1Vs?=
 =?utf-8?B?azdFbkt5M1FrM2thUzBOMit5UlQ5UGpjdWFKRUVDdUNKUkJvYnFJN2dWRzZu?=
 =?utf-8?B?L3VIQW9TK24wQXVZcmsvek1VZ0R4STJ0cmtxVmRQUUhFcUZBVzVIL3paSmJl?=
 =?utf-8?B?OUZkNkNHUzJTWGtlUXhHOEh3dHBEQ1JlNkpDMXp2dVlTaS9WbVZFRjZvVUlw?=
 =?utf-8?B?QXRSQUhTR2lFZmxYbjlXS3ZyZ3JyRWVUbExSMjBxbFQzNkFoV2IzU2tubUxu?=
 =?utf-8?B?UmxCdTM1MVZEbEpNU2hWRmRpV0JYY3o2NUVFcVVCc2YxTy9MaU50dUZCSUlx?=
 =?utf-8?B?aHo2cDVxbUoxQmVueUdCalpBa3NPNG9VRkFFRFFyWTBWSE9aUEQ1bnNqaGEw?=
 =?utf-8?B?UzI1d2xRSE1qWHM5TFNHbW1ZNUJMalk5ZjFHL21mWkUxSldQcWwzaGZuNDhZ?=
 =?utf-8?B?cVU5MXVuQzdkaWozajNKeXIvUDVzL25BL2xyRVlHK2JXNUxGSXliMW9HSDU4?=
 =?utf-8?Q?7nBoJbmO3kc=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NFl3T1FPanowaWRSekp2YWhOUjMvMFNGN0ZNUEdFNnJ0eTRMcXhlTWUzQUl0?=
 =?utf-8?B?T00ydC94djA5bzJvUmlWQW16MXBOVjE1a01DeVBiVll0bWs0S1M2aEg3cHdh?=
 =?utf-8?B?ejdVekVLUVQvUWhMek9ORkN2cDROUFpCV052bUhWalpoU0NkVDNIUk5zZ2FN?=
 =?utf-8?B?OUdLZFA4a2lHNWh3eHlLZUZldEltcURQRWRVOG55TjdqVVpMVDVNZmJrRGNj?=
 =?utf-8?B?Rm92VWNrYnNFZ0YvT2lhM0UzdmhWTlJET3daMzJaVkFZQjJVSHkvUjNQK2lD?=
 =?utf-8?B?NnNaRW8vQmVRbWZTc3d0ZFpEanNiWmNRbVBlTFk2Q2pUS3RJSHFGVFpab3N6?=
 =?utf-8?B?Wkg1S3VEMzNJZ3V1UWFEdjUzN3djTzJhOE5pQUxxK21aQ3AyaW92b0Y2eVI5?=
 =?utf-8?B?U1RHUFNrbm05cUttZkxqYXM1eG5ieTJYN1Y4L0p5c1hYdXo1YVp0YjR2R3ZW?=
 =?utf-8?B?YWFEeVM1WmVLVHVaOWtLRnNHdDNWV2FYYllUSS8yQmpJTlpZb0FzMk42S3lD?=
 =?utf-8?B?UHJvWDFyYnBMZS83cUduc0E4MWRsb1QyMzkrSzBUOVpFU01SR2ZJNFJVaVdC?=
 =?utf-8?B?eUhvMmN2d01aaVYzeDNqcXBEUHpodnFrd3BCSTg1RWdLYWpZYmpib2d1Z0tt?=
 =?utf-8?B?M1pSK0liRkhEOXBhc3FHdkJZYmUyTm80MmNmSlBzaU1aNlpCS1R6MmtoWmFR?=
 =?utf-8?B?aERYY211MStpa21HUzFCVFhEMTBSQmcxU2UwWVh2UUtxcURTdWFQWHJqUnZR?=
 =?utf-8?B?bHFjSGlmU3Q4U3ovLzliNnp2ditVaXM3V1pkMWd1UksrZGdsTDA4MFd4eTV5?=
 =?utf-8?B?bjZhTlMwVGhFbmllc056TGxPSHJ0RXllMUpuZTRYeFJEd0YrR2tWMnAwb2xy?=
 =?utf-8?B?V1NSb0IzM3k4QXl5YVNiS0Ivd2NCM2p3WFJZQ2RYbkJ3SUR2aTNtUkFXamVK?=
 =?utf-8?B?Vmltc0lsRWFDVFM4OWU0eVRlM0EzaFVvZk4xYzJkTjB5YnVJcjBBNW4veldv?=
 =?utf-8?B?RXpkWGpUVXptKytIeXBwK00xaGtwWUcrN1ZQYkYwYTQ3aWZIdFFuRGc5WGls?=
 =?utf-8?B?cnhmZDlxNjNhNDJTOUFWZkd5Ym4rTitZNmErTWpJalZjMng3d1ZsUWxSZ2Fa?=
 =?utf-8?B?Kys2MTlmNjFqaWpTWnpsSERIRHN2ZWdpODk4Vzdya3k5blFRckUzd2d6dWpH?=
 =?utf-8?B?TEpYTlBodmVnR3ZsQlVMV1l2UVIvaUhsREhrM21SdlFob0xmN3FvMnJ0eTZL?=
 =?utf-8?B?dFNYNllPN3hTcnlYWW9iMUpnOGJMVmlSdE9xdTdYZGxwSnRVSXN3YzAvYUM2?=
 =?utf-8?B?Y2JBZWkxa2FUNzhmdGs5a0NxaEgyMXZKQm8vQ1JOeVBOa3VoL0VpWUthczI0?=
 =?utf-8?B?ckRwYUhnSjAzeDNYT2VremVwQUd1cGcydWZGeHZnaGttVG91cWpZeWJPSnQ2?=
 =?utf-8?B?Q1MxV01KM1FlaS84SFpCYk5DM2greHh1S3I4K3ZXd3FrcjNpVDJNbkhuYkZS?=
 =?utf-8?B?My9hVGZsYVJDNDZ6Ymgwa1RUYmZFaWFFREw2SnYxNUgrK2ZqWm9DYU9HZHcy?=
 =?utf-8?B?Q002S21RV3BEdHZldzFIZDhVSUFTc2svNzJwTDNvbzdFSkNYOGsrMGtGenNo?=
 =?utf-8?B?TEdJcmhZU3RkSG9pMmN1WUtWc0dLZFlycjNUU0hKQWEwdE9laWprcVZ4eUxj?=
 =?utf-8?B?S20rQXlOUmtJWmpXVmQ0SDJNdytBZG52aCtSWHlCUnJpbGRiL2NsQjl3dUI1?=
 =?utf-8?B?Szh0UURrWnFnRnQ1NmV3QS9PSHpwN1VQeWlBazU0akYza0llbXNkdGlMMVd1?=
 =?utf-8?B?ZnM2aU1wSFFHQXdWUDNPdFNqN2FHR1VlUWExZy9hS1l0ZXZRQThpUUU3enZk?=
 =?utf-8?B?YlpqTDR2SWNpNi9OUWVlU3RuTlRqTlBUd2NPRlN5L2N6b3dOcmZERTZ3ZXlO?=
 =?utf-8?B?dmwwaFpjWFFid1ZVdTVqMHNpZWdQdGVZaDJvSTlwQTJFNWl6YzBzMUhIMGF4?=
 =?utf-8?B?cTVnWnpLaCtDaDJDeXRmN0hqVDZUcitzbHRXN3RBeHF0a3BRTVozdEZIMzRG?=
 =?utf-8?B?SlVoWkFlb2xlb2RUQXFEQ21Ga1l1QnA3bjE1aHhURkhRNitPMjUvMTROVysw?=
 =?utf-8?B?WEFpYUNFYVlVQzc0Qno5M1BiZXNHblFNWUJiOUJ1dXoySm9sdG1WREhUdS9N?=
 =?utf-8?B?eFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 878f6288-b209-4e04-378a-08dd81d002d9
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2025 19:00:56.0072
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iyJADGZUsmk/VaaWMwEfy+zx0qajJ2pBe/ZQtp7zAkrY/0+9K+O+jkEyMpAevtpqhtaoDBt2kw3Xvdn/jr4L0GeHXbsmeFwLEuyHNDvHTXA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6397
X-OriginatorOrg: intel.com

Pasha Tatashin wrote:
> On Mon, Apr 21, 2025 at 7:21 PM Dan Williams <dan.j.williams@intel.com> wrote:
> >
> > Michal Clapinski wrote:
> > > Currently, the user has to specify each memory region to be used with
> > > nvdimm via the memmap parameter. Due to the character limit of the
> > > command line, this makes it impossible to have a lot of pmem devices.
> > > This new parameter solves this issue by allowing users to divide
> > > one e820 entry into many nvdimm regions.
> > >
> > > This change is needed for the hypervisor live update. VMs' memory will
> > > be backed by those emulated pmem devices. To support various VM shapes
> > > I want to create devdax devices at 1GB granularity similar to hugetlb.
> >
> > This looks fairly straightforward, but if this moves forward I would
> > explicitly call the parameter something like "split" instead of "pmem"
> > to align it better with its usage.
> >
> > However, while this is expedient I wonder if you would be better
> > served with ACPI table injection to get more control and configuration
> > options...
> >
> > > It's also possible to expand this parameter in the future,
> > > e.g. to specify the type of the device (fsdax/devdax).
> >
> > ...for example, if you injected or customized your BIOS to supply an
> > ACPI NFIT table you could get to deeper degrees of customization without
> > wrestling with command lines. Supply an ACPI NFIT that carves up a large
> > memory-type range into an aribtrary number of regions. In the NFIT there
> > is a natural place to specify whether the range gets sent to PMEM. See
> > call to nvdimm_pmem_region_create() near NFIT_SPA_PM in
> > acpi_nfit_register_region()", and "simply" pick a new guid to signify
> > direct routing to device-dax. I say simply, but that implies new ACPI
> > NFIT driver plumbing for the new mode.
> >
> > Another overlooked detail about NFIT is that there is an opportunity to
> > determine cases where the platform might have changed the physical
> > address map from one boot to the next. In other words, I cringe at the
> > fragility of memmap=, but I understand that it has the benefit of being
> > simple. See the "nd_set cookie" concept in
> > acpi_nfit_init_interleave_set().
> 
> I also dislike the potential fragility of the memmap= parameter;
> however, in our environment, kernel parameters are specifically
> crafted for target machine configurations and supplied separately from
> the kernel binary, giving us good control.
> 
> Regarding the ACPI NFIT suggestion: Our use case involves reusing the
> same physical machines (with unchanged firmware) for various
> configurations (similar to loaning them out). An advantage for us is
> that switching the machine's role only requires changing the kernel
> parameters. The ACPI approach, potentially requiring firmware changes,
> would break this dynamic reconfiguration.
> 
> As I understand, using ACPI injection instead of firmware change
> doesn't eliminate fragility concerns either. We would still need to
> carefully reserve the specific physical range for a particular machine
> configuration, and it also adds a dependency on managing and packaging
> an external NFIT injection file and process. We have a process for
> kernel parameters but doing this externally would complicate things
> for us.

Lets unpack a few things. My assumption is that ACPI table injection
deployment is similar in complexity to kernel parameters because it is
data appended to an initrd. So if a deployment flow can:

    echo $parameters >> $boot_config

...it can instead:

    cat $base_initrd $nfit > $amended_initrd

As for the fragility I do agree that without platform firmware changes
(base system NFIT) then it would be difficult to detect that the
platform is booting in an unexpected physical memory layout.

So memmap= would be used to mark the memory as Reserved and then the
injected NFIT carves it up and optionally routes it to pmem or devdax.

The aspect I have not tried though is injecting an ACPI0012 device if
the platform does not already have one...

I think it is solvable and avoids continuing to stress the kernel
command line interface where ACPI can takeover. At a minimum confirm
whether amending initrds is a non-starter in your environment.

> Also, I might be missing something, but I haven't found a standard way
> to automatically create devdax devices using NFIT injection. Our

Yes, this is not there today, but would fit cleanly as a new Linux
specific "Address Range Type GUID".

> current plan is to expand the proposed kernel parameter. We are
> working on making it default to creating either fsdax or devdax type
> regions, without requiring explicit labels, and ensuring these regions
> remain stable across kexec as long as the kernel parameter itself
> doesn't change (in a way kernel parameters take the role of the
> labels).

Yes, this should all work without labels.

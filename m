Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A757213120
	for <nvdimm@lists.linux.dev>; Wed, 30 Oct 2024 16:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730305729; cv=fail; b=SNAlMzjKEllZ5LP3QUcABQw3160VNugsP6YV9bvE8614iv+cuBe0H9q5U8bKKO4WaFjZVD2HJ5epiBC+WVXkLSIzoUcBijamsyTb01IO7aGkz0wOLW59PFkhpiJlB1NzdevLKNjBGr60htwIl9bvaHKSyxXA2qNV1YrZrhtS+FY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730305729; c=relaxed/simple;
	bh=eKpOnTfFC/CwX81Fiz5eCNHHX4dgXp9YzP46ZynK+fw=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=KGgyAnGyZKj2D60svHrIWCkQqlMDC4BiM209Q84QcWfdSIZhe0NBH8x9FkC0NOXK5xxXVmWCIVSInqnbcv7ulPRLz7jTTdRcW14Y+0f4yqfZ5p5OHb5SWYdK4gRcwqOCFaruNPWN/3HYRy7TW8b8EiSAOKgIXgVp2egSRjcFVss=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KnCrZbOi; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KnCrZbOi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730305728; x=1761841728;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=eKpOnTfFC/CwX81Fiz5eCNHHX4dgXp9YzP46ZynK+fw=;
  b=KnCrZbOisDDT+277hR3ooPP9Z2EAboaumfc0vXNUEyE+Czu+JrpOYlf6
   lZWQpJaC+PM2D1No+oESBbCOEvyBzZUjKT15j4HjqjhPO9M6SpNacNAL3
   ZRpNyifR7vMv9RovbmQKsdR8JwFyqI2MztlExTnY3awiw9q7b0x5RLaqc
   n9dvuJq5lLu5sp3fc6QCTjsESZ9zDPIc7HDDxBNZbb3LsbHWjVvcrY4l8
   qjyF0rEEH1fvIk+bhxUK6WQqxY9Y4qyNJhvWNz/VieMMbRH2dMM6rOo/G
   3QlRKINUpOBNK4J0tjDZzCDEzkQqBXWgAY6oTDnyvPD4OnBm5055i2v0I
   Q==;
X-CSE-ConnectionGUID: FFG8NfXnS3mbqkXP/Ij9Ww==
X-CSE-MsgGUID: ajkXaducRf2UUUH2JDRwxA==
X-IronPort-AV: E=McAfee;i="6700,10204,11241"; a="29464432"
X-IronPort-AV: E=Sophos;i="6.11,245,1725346800"; 
   d="scan'208";a="29464432"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2024 09:28:47 -0700
X-CSE-ConnectionGUID: RdoFuejBTmWhh3HcgavAsw==
X-CSE-MsgGUID: 4pT6jwOnQ2u0b4OfGSPTRA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,245,1725346800"; 
   d="scan'208";a="82475650"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 30 Oct 2024 09:28:46 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 30 Oct 2024 09:28:45 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 30 Oct 2024 09:28:45 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.175)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 30 Oct 2024 09:28:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ghbnjLF6oyRFKc3pARphk7+Y7oXQSGa+B8Ac/mSYI+4769+lDGsa61D+F1bS/kW3CeQHiF/+7Fsc7/q3eAep6vbDj97B98GhwwlgjOKNzGNoy6r0aDaq1E0xIWipdXXIsZGjldHdFmMQMFiK8KG5bipEmFuGrID4xZLvdS+5zs5nKsHj6KyKKPc2LfyTEKeM/Aqn7xSHRT/LYHY+iCAVwRY2IF1c7moryBolaSgVUMENRZJvozoBukqp6944a4MvrK4RCYW+WJlY6oqdg3GFsdQAFfLlCrLakDuY6T0ia2xMiG2RkhDxkAuxc1ONp1ZWT4RT7tzs3uqAkvZvTLGljA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rnP+sMoaHUTQYv6ddAuw94JGjVixBKbl/gORy/zYxu8=;
 b=e1STjcSeo6YBojqWv/LwymKP6y9ovfI2Pc+IiFSlm2SyNFHrqCsb06DJSvoYP1vbVlX1ML01UzhdXmXZsiAl4ARRJV2YVzaKYAtOCqvu0CftHJgZnka80vbosXHdAGIL2bOW78VKlOdxe+/fgvocEOnjzdKZpfNfBJvsvyB32NGERDSaTbmfZzcr4RDWVBgMaj5y74coLqMOKOwSRxgjFLM7xGv6SKrtU31K/yfInABuzODtH63pmLnkdZY47uYP9qPRyouKsVvpcBIanyD0+4qGXMZUydoI1ueIpH7AsHZAYdmnqRj5U5RMGDqdykQGFy6uiTSnwm+M59KmX+KOUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17)
 by CO1PR11MB5090.namprd11.prod.outlook.com (2603:10b6:303:96::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.32; Wed, 30 Oct
 2024 16:28:43 +0000
Received: from SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57]) by SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57%3]) with mapi id 15.20.8093.027; Wed, 30 Oct 2024
 16:28:43 +0000
Date: Wed, 30 Oct 2024 11:28:37 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>, <ira.weiny@intel.com>
CC: Dave Jiang <dave.jiang@intel.com>, Fan Ni <fan.ni@samsung.com>, "Navneet
 Singh" <navneet.singh@intel.com>, Jonathan Corbet <corbet@lwn.net>, "Andrew
 Morton" <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>, Alison Schofield
	<alison.schofield@intel.com>, Vishal Verma <vishal.l.verma@intel.com>,
	<linux-cxl@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>, Kees Cook
	<kees@kernel.org>, "Gustavo A. R. Silva" <gustavoars@kernel.org>,
	<linux-hardening@vger.kernel.org>
Subject: Re: [PATCH v5 08/27] cxl/mem: Read dynamic capacity configuration
 from the device
Message-ID: <67225eb59d0ac_483142946d@iweiny-mobl.notmuch>
References: <20241029-dcd-type2-upstream-v5-0-8739cb67c374@intel.com>
 <20241029-dcd-type2-upstream-v5-8-8739cb67c374@intel.com>
 <20241030140535.000009ca@Huawei.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20241030140535.000009ca@Huawei.com>
X-ClientProxiedBy: MW4PR03CA0110.namprd03.prod.outlook.com
 (2603:10b6:303:b7::25) To SA1PR11MB6733.namprd11.prod.outlook.com
 (2603:10b6:806:25c::17)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6733:EE_|CO1PR11MB5090:EE_
X-MS-Office365-Filtering-Correlation-Id: 3aa9094e-f75c-422d-d7f4-08dcf8ffeb48
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?SlUJc31AQUvP+l4BPdvKPTnkY5cTMlk9vHlArhSRYRt+rqZkdoJh9pSZH0C8?=
 =?us-ascii?Q?YZMkCB3Gn93wj0ymrpOUZbedD9m3Rg1hgU+LwF/HhhKZjA5UXkQ//Hlqqv3S?=
 =?us-ascii?Q?aj9YuBSgMJEedk5y6fx4GVxPPsSmeL5370SHqabJRWAYcSEDTbLGm7dOEbIe?=
 =?us-ascii?Q?CBg4y1XDdK4l3bSWugCo2X8m9gxrbLjr3ktvOtyelggWZDAVlVKY3yJ3Um2W?=
 =?us-ascii?Q?2kNlSEe+BvG8jkDLKgLw5Tkm6ZRF9Y9toFAKGXuGEI6RwLPC3hjAmUTA0jkO?=
 =?us-ascii?Q?E7gRwaFOIBN/VW8YfTagYtEwy9DQOdHrXxdXJFC/Yt8fR4gti3+nE2S7GnOH?=
 =?us-ascii?Q?t4HhjMtnf31GPSn9sALnDM8r2NUcbfe6ycUs1wkIMjjlMkhV4ox6lHdE0g+E?=
 =?us-ascii?Q?utHPg/C2lEnESA/zbOWkfk6MjI0U+irDQGkD2mi0Y6lJxAb1MRR78VF9GdQ/?=
 =?us-ascii?Q?qjJt0ikfoHxzU3AFrFfdwSeff1nmiGXBJKeRX0EkcXuSYLmao5UKxVNwb0pd?=
 =?us-ascii?Q?DePSO0n9SH2nRD0dfbJjUwIdzFm0ZeYRJ1hmBwM3kidVAENyXDjhn9K4jpx9?=
 =?us-ascii?Q?c250nu9tOW2+R/hxDj0QD73B/FVDXPGPersIthCuQfeNXK8zZB84Uuz3Q7RD?=
 =?us-ascii?Q?2kW3ckFRkW3fWtT92vdCCw/pZvapjWMeuI60nf0tPyNpquRl+0EL6M44YvMD?=
 =?us-ascii?Q?Xd9wkZtEyAcRUQPZnRRPCg0SdHIxGiJDnvrKh9Tcg8jPk0yCq1ehVMfyURVY?=
 =?us-ascii?Q?hFMOGqewqp4SXamAy2ZiG/1BDbr0ANe/njEBzPF4l2zjvW7xepP0pua90PK/?=
 =?us-ascii?Q?9cJNSVkAAUr5S/mrGrX2afxP4C/1JY/HnsbzyaZmUBnosUEUPGJYQjXgzlrk?=
 =?us-ascii?Q?NCaX37OdLc341pfdaYfNLVTxUpfgNFnMpBv0wpQlVdcXfCcOsK9mDeCS+Cim?=
 =?us-ascii?Q?jWikBPTaE7LOitD7OhPlOzsFBMs45phiOErdKoDIEpnmAxHv/eurh84ISo1d?=
 =?us-ascii?Q?HyTvmZSTHKzbZboDrdIHIVrwM+i+uszhqEh0HUGgm4JEWLAE2ZKa/2W+Wqwu?=
 =?us-ascii?Q?4oLj91EUXpLSH7fyvMI15vh12UXMXx4+/J1lrS6OdP37MAvxS53V5RYCp0BJ?=
 =?us-ascii?Q?GKa7be9d8tYwyf7Yux8l9bSebHj67a6uBzt75LR1mtEtA+biQFXrbyZ3lCQy?=
 =?us-ascii?Q?0qJ3xt0kkUX0SyIXPwb2faYlVDZFa+ly9bIcLCfnrwiaewX44lqpDz8dASy5?=
 =?us-ascii?Q?/sEAszahAT4EG4Shl6PBaodN1zyr6oJoId38ER19CiJWChS4PWhiCbTZ2uLA?=
 =?us-ascii?Q?qyeb3sPJgggg29tTz1mu0LsD?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XtpWuqJuhC9TfPB8T0ftq4LdhZkAgk1GOCyGIgsv0vwFZC0KtV4ixxQCsXeF?=
 =?us-ascii?Q?u1p1ZMG10At1PHYegIZ+dWAlBEh2cLUdaOljornMRKwcktF0/JXAoJi+3v6R?=
 =?us-ascii?Q?Luzv5ZHCdajdpJOtxhYR3bNt3H9ROVnoQcgN1Na4B6i1Pgb0yaOZ81e6q9CR?=
 =?us-ascii?Q?i6Vh/dn+pRPCd3ivMSK4Q7FzcrQ3+8sVbJYZcHndloSkAO5eHBVyi3SM9Zb+?=
 =?us-ascii?Q?G7xRgr56bh5Q55eHM7SiBCvYW+3FAnf/NPMN72cRK6QQHNZmrrFxuNyU61SI?=
 =?us-ascii?Q?JAwuV6omWtBsTOewLAEruo8veS7bU9kWSX1P8OwBcTig7yWqJLdRXOASOLWe?=
 =?us-ascii?Q?dHW6Tabk5H/DiQt63q0pnITc2ZU8OhWsnxWSGJPsWiTaL0dDkrUXiLwl4BkF?=
 =?us-ascii?Q?QeiaaEBSpSYV34p0aB4+wXdXKDbemjLIr5tI5RnnqlTK0GSlNLgk4PvI644H?=
 =?us-ascii?Q?ORnJv/ejmzqFbFwSx5diHirPUo9xSJJRRNO2P8U8l3b2vaRPI+vDMPK/morf?=
 =?us-ascii?Q?XJcUNiFPBpLBh+JL+I9+nEDsGBFpq55FXA+CRrYxWsa694g89HF/5j2jOPOf?=
 =?us-ascii?Q?sxikMdVqo6gN2SqquJSXwgg4h8IgAwp99nK+aZ4UTEC9WEIfE0XmRMt5A9aJ?=
 =?us-ascii?Q?71yEQy3knL8irOifB+iUU0iErrIH5bExaKQt/9TucMPLfP6uYE9rLy21mKQ3?=
 =?us-ascii?Q?73sTk0jW5rZU+9KPh8JghUkbiDlxfj1J70lUUUBcriM9cknRJVSLqrRDWuuT?=
 =?us-ascii?Q?UUjcj1w5AWojKRKdfmivylInd3EOn+b4QX7TWrzrDI4ggciozh1MJp7gJhpX?=
 =?us-ascii?Q?/1DkOir8DEQpyAoVIZzB8L6XUVGDLnTho2Rx28um8Ynv+hRsmyIomAIiGoAZ?=
 =?us-ascii?Q?xz7NkOBugxxCKQ8/xBHMBz6bYdXCN8K1wXpFN6Wkf3TZCWtK1rqGVm5h89Rc?=
 =?us-ascii?Q?Bl2aclzo5V5TyqvE1ZIwhYPob+POXdrhh5k9WRpsHXz5DPM2dbdOo6gwWuBM?=
 =?us-ascii?Q?RP9XTpUjA/4h+izKjY+ZHj6kvzCj7VNtutdhQULwZsYMCT1gzgkJ+0AjpbFQ?=
 =?us-ascii?Q?YDtiEl/byvbvwlXh/tapFaEb+1bNzRjyK4YgeknyPsSkXD98UUoqScNs9pWs?=
 =?us-ascii?Q?HlOOmUPE1NKcYVOjWQ0kxiYWdtalWqdguR1QplVxhMRreI00TV73MFpoYPvH?=
 =?us-ascii?Q?eQsjN631G0rF85mBMFVBIcZF25tQBjWZl3c0vN4g9MZtIBq/BwSOJqTqqdi0?=
 =?us-ascii?Q?hdTr7dc4dhncMmCWwHkOhMTnlOeX2TqSDUFwRuSt2QX677JTvGVtGogt3cza?=
 =?us-ascii?Q?O/6T+1EJ3JwPO3cUfGsCXbkMUzO4dTdSQxYMuOUNtUvlb8u6SWEDz/lDlIJm?=
 =?us-ascii?Q?Wg2mo3cKAM08g3CbKFb6CIxwComiDX/tzV/swJv9P0l9d8ppCNSh4ON+PD02?=
 =?us-ascii?Q?THKx8+MGBTEEPR0RkzR+bDCkw20IbgK5qpHD+cX84FD00Z/1/oCfU1oPsou9?=
 =?us-ascii?Q?eJkhasUK4qKmYNabvJ9gbzF3TrJJC85nLoflsy3C8AA9S9r23L5xAOBMR/eR?=
 =?us-ascii?Q?yUr0WNMFuNka0Vihn6wq/v70PGyp44GdHLa0GqiE?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3aa9094e-f75c-422d-d7f4-08dcf8ffeb48
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2024 16:28:42.9971
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5MmCpRqeRvvVCQ80ntfMPmqpRtYmj2UzHnfrbZsW/g64mpnG/KoiaSA+np+BZ0OmWwG+WgXuZcjFO9NzTdI/tQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5090
X-OriginatorOrg: intel.com

Jonathan Cameron wrote:
> On Tue, 29 Oct 2024 15:34:43 -0500
> ira.weiny@intel.com wrote:
> 
> > From: Navneet Singh <navneet.singh@intel.com>
> > 
> > Devices which optionally support Dynamic Capacity (DC) are configured
> > via mailbox commands.  CXL 3.1 requires the host to issue the Get DC
> > Configuration command in order to properly configure DCDs.  Without the
> > Get DC Configuration command DCD can't be supported.
> > 
> > Implement the DC mailbox commands as specified in CXL 3.1 section
> > 8.2.9.9.9 (opcodes 48XXh) to read and store the DCD configuration
> > information.  Disable DCD if DCD is not supported.  Leverage the Get DC
> > Configuration command supported bit to indicate if DCD is supported.
> > 
> > Linux has no use for the trailing fields of the Get Dynamic Capacity
> > Configuration Output Payload (Total number of supported extents, number
> > of available extents, total number of supported tags, and number of
> > available tags).  Avoid defining those fields to use the more useful
> > dynamic C array.
> > 
> > Cc: Li, Ming <ming4.li@intel.com>
> > Cc: Kees Cook <kees@kernel.org>
> > Cc: Gustavo A. R. Silva <gustavoars@kernel.org>
> > Cc: linux-hardening@vger.kernel.org
> > Signed-off-by: Navneet Singh <navneet.singh@intel.com>
> > Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> > Co-developed-by: Ira Weiny <ira.weiny@intel.com>
> > Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> I'll assume you'll fix the typo the bot found.

Already done...  I did not realize my compiler was too old for this
feature.

FWIW:

/*
 * Optional: only supported since gcc >= 15
...

FC40 is still at 14.2.1...  :-/

Ira

> 
> > +
> > +/* See CXL 3.1 Table 8-164 get dynamic capacity config Output Payload */
> > +struct cxl_mbox_get_dc_config_out {
> > +	u8 avail_region_count;
> > +	u8 regions_returned;
> > +	u8 rsvd[6];
> > +	/* See CXL 3.1 Table 8-165 */
> > +	struct cxl_dc_region_config {
> > +		__le64 region_base;
> > +		__le64 region_decode_length;
> > +		__le64 region_length;
> > +		__le64 region_block_size;
> > +		__le32 region_dsmad_handle;
> > +		u8 flags;
> > +		u8 rsvd[3];
> > +	} __packed region[] __counted_by(regions_retunred);
> returned
> 
> > +	/* Trailing fields unused */
> > +} __packed;


Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 978733BB136
	for <nvdimm@lists.linux.dev>; Fri,  5 Jun 2026 05:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780638199; cv=fail; b=RGhPFnLcuFWKrKIMN3KOPlO3ZEBUMCB1jUuaumau8eYdC1lF/OXROQ3EI0eYNv3EYKLJYgvOotGDudIKID6QpqJ/vsnXJ3zToSOIT5N+VR7Yb/ZlLQXHmRGYgVEkJaocMGuhmNxlIjVr0m3DqmPhIxVcLuRgx7gLr5vcL0Jm3Tc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780638199; c=relaxed/simple;
	bh=yctatVCh2diNrGAUYfYBypN0nu8HKgL81iK68qkuE4k=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Jn7Fl0ASL3LypMVEtP6dGrE781aA2e4trnh9QvM1I8MUUGZgvBsJDw0KlIUhE9iEBHoH1MLcdxFO8JmCDCbrPl50p5A77CN1wQYm0xWNVAmKL8U3nywLEjQGxt7TVPkcl1KjB5GCffso2VgSUtEmRp0Y0LZlCCLEmb15vzgN0L0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iylJG4Lx; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iylJG4Lx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780638198; x=1812174198;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=yctatVCh2diNrGAUYfYBypN0nu8HKgL81iK68qkuE4k=;
  b=iylJG4Lx57eBIHkhEI3mDCTg+hkXcb3PT1b9AdXEJSbKVxrMwTNigZ45
   Bo8L6a3s5KY7x3M4ekRPRF++JWCGtV+zuNvOYsf0/YLsBz3okk9AqBUEN
   GBiTGluazF+wWmbuaSY9l/NTt/skSHgl0EwY14SynBkaO9lXmv5OZ1IjH
   9/lD9ayxb6IFzLdl6ZRVikz1uQw/Fgu4Binq2W6HWkCJFYyKquqFLo8Py
   JUiP0kSO7DkRg1TNon3d7Z/t11dmBU2YsakXS3/O0Mme5yArpAC4dfuof
   DPTG0iiRGXjiUOnt51nlKJjeFMg28o3aGbzKbLjCUq6CMIRxy11e+87J2
   Q==;
X-CSE-ConnectionGUID: z0k6x/dbS22a8mcY1Gkysg==
X-CSE-MsgGUID: 2uyzYkUuRgOiGMZFbCW5wg==
X-IronPort-AV: E=McAfee;i="6800,10657,11807"; a="92580157"
X-IronPort-AV: E=Sophos;i="6.24,188,1774335600"; 
   d="scan'208";a="92580157"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2026 22:43:17 -0700
X-CSE-ConnectionGUID: 7aDIh7elQ1yzu2ML3n8D/A==
X-CSE-MsgGUID: j7r5VTzXS7OLhCZCdEdheA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,188,1774335600"; 
   d="scan'208";a="249857591"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2026 22:43:17 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 4 Jun 2026 22:43:16 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Thu, 4 Jun 2026 22:43:16 -0700
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.1) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 4 Jun 2026 22:43:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rVaEr0Dp+hX6/KitncdfIAyUc/bJQY+/B1BhNYfKNiNLUgEhsTQmveJaJ+6F9Ip6HAkovr3TPPy9/R3UY1+/+qGkNxCx63bnEQnapWSqTgvfpbns3EVpCic8TDQ653QGp5vMYzKYRS3N+7m7eFhGI9HRCfeazWcIiV0Ae6ML068ASvG7zoqBjEaxFnIvts+wdjdVyhX8xt1eYjh7gKa6WAQtk2gCZNl6RinkAV2M3q+FSQIfnQ4WtCMqGdip+IvmEPiu5JPGnd3AOLBjHIXkFB1eWA8g+GChgfysClU8api2ggsWt5mfTg9oVAcftz6wogweFJvOb4nR9jCJ2HvLzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v2ndsCBOc3o04LbTNOEaxAv5oei/KGlkpgzBQAe9FCc=;
 b=ghjh2ple9OEvu7GYyEV+Z/nWj6lnuAx6mZqqRSYoZcaknOQENdCRd3xAl5fe+O7y/Fzs3in2PndyK3Ez2kWsAtM5/XFtulF3IQgYpb80t2wcwjJqHKqj/XHm5hB9jNfa9cjWFGhX5xnQq2ESsjDtSjgcJytfzbgo8oZLugWpG7v9pU9IWDt8ajGr91eYdCo22WaLFITF+lzhXBn395GjgYUR5BzB4w6pr25XNjdLuUn7HHYNhTrc65jE+6Z9kuTce7jFg8hlqP48jEQp16kMuRpGJ6CcviUdiOlZmZF272BxjbyiYKfxzBREcQpgJBcBjI2Q1GHdNE62XHv4puAuDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by DS0PR11MB7802.namprd11.prod.outlook.com (2603:10b6:8:de::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.7; Fri, 5 Jun 2026
 05:43:14 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891%4]) with mapi id 15.21.0092.007; Fri, 5 Jun 2026
 05:43:14 +0000
Date: Thu, 4 Jun 2026 22:43:10 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Anisa Su <anisa.su887@gmail.com>
CC: <linux-cxl@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, Dan Williams <djbw@kernel.org>, Jonathan Cameron
	<jic23@kernel.org>, Davidlohr Bueso <dave@stgolabs.net>, Dave Jiang
	<dave.jiang@intel.com>, Ira Weiny <iweiny@kernel.org>, John Groves
	<John@groves.net>, Gregory Price <gourry@gourry.net>, Anisa Su
	<anisa.su@samsung.com>
Subject: Re: [PATCH v6 0/7] ndctl: Dynamic Capacity additions for cxl-cli
Message-ID: <aiJh7vcs2u1fMDX4@aschofie-mobl2.lan>
References: <20260523095043.471098-1-anisa.su@samsung.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260523095043.471098-1-anisa.su@samsung.com>
X-ClientProxiedBy: SJ0PR03CA0103.namprd03.prod.outlook.com
 (2603:10b6:a03:333::18) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|DS0PR11MB7802:EE_
X-MS-Office365-Filtering-Correlation-Id: 32c3ecd2-8eb2-4971-5ff8-08dec2c55600
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|13003099007|6133799003|3023799007|22082099003|11063799006|56012099006|18002099003;
X-Microsoft-Antispam-Message-Info: TgIldoqPCQN3XPHpmsRes+EBnVv+LNfMLHmdrApLIey0jexSiqG3CcQFRfEUERBjusvq5wX4ChB0PEVyp6nb2oqRTreUx72+8i9D/csX8oQezBbiqMTk94G1v6i4t3wptlUI0nOA3HM+91LiLaX0LyJp1/OKzelz9iTiiDN11RFULuH+xO72ZdQi0FUyHt+o/OUqkrK8c0VTDXGja8phVCD7lc+hAcV9ISMotMxEnVo5ygflOHClqD/r9sJTTaFeP6Ji0P/RLyO4O3W9oxdLeCcVSXdVe8ZUaf1TzqRPXNOEQKOKUkJGQ/gG8O1ip1OkZ69KScERKUPEwPgrcB2SSyxNvN/spmJAcEmNpKjaC2VetwzZgyBFr/Ph+MstPRvFLZxIdqGhaat86GRLmhNA4BhtUo3o07ltkiihXP+xsjaWLVCvUzvrLoz4Ghzj8kH6vmobjmXAByWGAXOxOn/baE+9PlpHgTij0Qv+KKp2pqD+xXlptSX6uA1eVlIZGcGEBYgT9DPZKhdNoIdMwOukVLfzIEyvTcFdxLnIJGhte02/AaV5NY82tZ4SJd4tqH3B+dF98sUJBKEVTM5JMh6GWyn9TEGk46KD+nEqKM2b35NFFoO0AAVw0RO9ayoOwDEsUqzztv58Nk5BnXbCRCCxUw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(13003099007)(6133799003)(3023799007)(22082099003)(11063799006)(56012099006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TG9QZ3IwM0R6ankvb2FqUzVJYU9jNktVajFoa3lZZGk5cmJNRkp0UXdYc3h3?=
 =?utf-8?B?Q0s5bmZjcDlpc2lGMmdVM2MrNGJuS0p0SGRBR1hhNzFaTzhaVTF3eUFFcjcx?=
 =?utf-8?B?OG9YOU45QnJ1M1k0eU9PMUtkZEtRNGdzZHpEN3VSbFh5T3BKT214UzJhajJV?=
 =?utf-8?B?NENCdERicVltSW94Mmo3MHh6QXdUU001SE1nczVvREhoUkVnKzZNQk52cWtU?=
 =?utf-8?B?c04zcjV6TU9DU2tnU09oL2U1ZUJRRGxScmZtSnZOenFoMFBrUVYyNWJDWUhB?=
 =?utf-8?B?VkFUUzB0WEw3a2EwZmdzdHZtUm93UlYxWldNSzY5eXhjNlZFbFJrNFMxd3Jj?=
 =?utf-8?B?R3BLQjM4TnJpZUkwNGh3a2VhVHR5TGo5VytnTXQ3SHUwOEVFOWdEbVh6WGZk?=
 =?utf-8?B?ZEZaa3NjNHZ1MlRTZFI2UkJIT2VMaHkvdm1ZNTIySGVtTThOTEFLcllBN205?=
 =?utf-8?B?WGtNNE5Oazc0RlZhck0xeUZzYW05US9mYnRlc082SUdwa1VDck5yV0N5Yjk4?=
 =?utf-8?B?ajJRN1NIMldpaTFSaURDUFV0c2FXUE1rUkFSZkdOYmw3RDBIRTNXd012SW1k?=
 =?utf-8?B?Ty9PRzZLdzVPbkFWdERIQUhJd2RVSm0xNU5zanpSNmR0WENuMG4rTTRmRWl0?=
 =?utf-8?B?MHJtL2ZjNUczNEZJaUZjaXhHQlhxMnFWMlY3bC9kNjlhZTVmYkVnWllvcldX?=
 =?utf-8?B?UXpoL0x1ZTZNL01vQmh0b3gycGFXL2lZa00zQkxON0NVR1Z6ck54TlZQcCsx?=
 =?utf-8?B?dDUzQkFoKzBDV0RUQ2VmcitIRkZwK2RUNmVkcXhiVGVaY1FIbTZtZlFiSytY?=
 =?utf-8?B?THhrN1lwTFIxSjBuUG42SzJCR0xYbUk1UUhxV0tRaERhajR4ZEl5Y3pPdE1p?=
 =?utf-8?B?c2l4MnR3OUMzcDN1SU5kbG1kOGViSklMblJyQVpac1MvdDlST2pYTGhRcFdM?=
 =?utf-8?B?djJZTTdEaGIzUUkwZFVuazVMMEM4L2dwSTFBTTY4QUdPc1ZEZFhsS2JvN3Jw?=
 =?utf-8?B?TzNUbXhGTFJZS0E4cDd4K0NCeEV2b0dwSE0rRlErZlBDUUdxVmxreC8xemhL?=
 =?utf-8?B?eUh4WmFpWk1XWmNzZHVCdHRCcmhHNHpoM3F3REttVDg2RzhKY3ZOS0I2b081?=
 =?utf-8?B?cHo4Szd5TG5qWEtUQk5jUnhxMjArM3p2eVRBb3FyUHp4SWdvc3RXR0pUeFNv?=
 =?utf-8?B?U29lczJWWDA3aHcwRFRFbkxxUE5YNmVjZjZJZWYrWmZKNWJzMnFzd01HalZN?=
 =?utf-8?B?M0libktZajRyaUJjUnVma1VWcjIvMEtqNVlGQmNCSlAwNWk5WVZueXhNcXFJ?=
 =?utf-8?B?dWZHYjRZcGNIaWpqR2hja3ZFTWN6bUtxTXJjcjBzRFZNSjVIQ1psN2VmQ1Q3?=
 =?utf-8?B?clN4TnBpUjFsRFN0ei9kU1R4TkV3TDFnOHBBUWoxRngwSk9ITTg2bVNKMHpk?=
 =?utf-8?B?d0w4WUFxOVBvaUVhU0xFeEtyazFFbnNXSVZGTzQ4S0xrMTFXL1VvQ3ZqTDhT?=
 =?utf-8?B?WVRsSDEwOW1RZlVKUUMzUkFRV3hqTld4MklTaU9ZOW5GbUVNZmJBakhxbzh1?=
 =?utf-8?B?SE9iQTVvZDRHQ1RFM3J6aFN1dFRnbGdBZCs2OWNLTndVdE5nWkpxNEZvQTVr?=
 =?utf-8?B?ZWc2Qnp5NTZZc1BoN3pqMTYrUWlqVmsrUVRTdEV4UkJYeHpyOWt0QW01K2tE?=
 =?utf-8?B?R29VOXIxSjZhODhYaW9nVTkzWktSbVlMRFY0aFJIOHJiT2JvYmFxUDhwV3lY?=
 =?utf-8?B?KzVEN01qNEk4eTM2TXVXYnZjSFZEWTRMeUF6WStyMkJiS0NQOHpQRldoTzZq?=
 =?utf-8?B?c0xESG5PTU4yUWZzVUVWVDIvazcwN0JaNVRhc1VKTWtCUnVydWZLR2Q0R1RL?=
 =?utf-8?B?STlLbDZRbXJidUFTOE9kckh0WGRXTWJzSitGYXpXaGd2YlhYTU1abTRTbmp4?=
 =?utf-8?B?aUFsODExQ29mckg5Q2pIWFlYTEZkbWxOaFNyNStKZEkvWE9HeFFsdDczbE5W?=
 =?utf-8?B?dGwwOGJKS1NLZHlPQ0dJb2FRWFYrZ1czSThtd283L3l5aWZKeG9rL3JPcVpz?=
 =?utf-8?B?QXp0RjExZUdmcHRxeU5wTTEwdEdieEw0dzNtZ3NOMnY2UEh4ZkR1VFovdkxB?=
 =?utf-8?B?MlhEODYzN3pIWXlBN3FWNFptckNTQ2doU2tLaml3QWQyUmxQNWtyc1Fjekta?=
 =?utf-8?B?ZVc0SkQvSlAwWERaMGJkanVoSlZPQTVwaGRNazRycmdMTytPSjJoU1k3V3VE?=
 =?utf-8?B?L1BndFJSV05UY2QvM3U2U1BDSlAxSjZQRTIxV0hWcE03ZDEyekQ2d25sYlBw?=
 =?utf-8?B?NXBlU3lvQ3B3aEtLOE55WUp3amtaMHRxSitya2s4WHpEUlljU1g4NzVyWGZs?=
 =?utf-8?Q?FYS+WW7Ul/uxMSMQ=3D?=
X-Exchange-RoutingPolicyChecked: PV6ygLXWutvG0IO5Z//kywuZdJc8DJzg4eCneGbCz71vSNBZBZRbDgOBJ3nP09A85t2trVn8RKglrc2c1dWCYZ/PZNNM1Fan6pIgzFXBrvFoajCc+4IXdMFdWULJtyTLBaZVKspkSAQ1IVGM0Ng2L2E47lDiToooSiz93Q7yp2+dtjWuyV52y4SI3OaYxPGGY3G1fMCZc7onwHuJ78QqKNVusem/EsN3EelsvJ16OiLkQKNpvwenXtqhLSHVvRK7652n4z1kB4PUadwtdpVckQiUtmZhFFCoDNfrHJajMZamD4MuwMWVa5rINT57uoWNS9i651Dv0G0Jv8+gntX43A==
X-MS-Exchange-CrossTenant-Network-Message-Id: 32c3ecd2-8eb2-4971-5ff8-08dec2c55600
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2026 05:43:14.2519
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BAheqOmypcWlefdVrhJhLu4LkG1K/oueDz4r7lPenST6YMXi7l5+Bt2zuWyzDh/FKa/YO+zTlGwIXj1moE319KiRacaEsQcj6JyM+3wnJQk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7802
X-OriginatorOrg: intel.com

On Sat, May 23, 2026 at 02:50:35AM -0700, Anisa Su wrote:
> CXL Dynamic Capacity Device (DCD) support has continued to evolve in the
> upstream kernel since Ira's v5 posting [1].  The kernel side has settled
> on a uuid-driven claim model for sparse DAX devices: dax_resources carry
> the tag delivered with each extent, and userspace selects which ones to
> claim by writing a UUID to the dax device's sysfs 'uuid' attribute (or
> "0" to claim a single untagged resource).  Size on a sparse region is
> determined by the claim, not requested up-front.
> 
> This series brings cxl-cli and daxctl in line with that model and
> extends cxl_test to exercise the new paths end-to-end.

Hi Anisa,

I just now picked this up with the kernel side and took it for a quick
test drive. Based on what's been touched, first meaningful finding is
all the DAX unit tests pass, and then for CXL unit tests, all but these
2 pass: cxl-security.sh and cxl-dcd.sh

Please let me know if there are known problems with either of those
before I explore further.

Question below about dependency....

> 
> The corresponding kernel patchset is here:
> https://lore.kernel.org/linux-cxl/cover.1779528761.git.anisa.su@samsung.com/T/#t
> 
> Picked up unchanged from v5 (Ira):
> 
>   libcxl: Add Dynamic RAM A partition mode support
>   cxl/region: Add cxl-cli support for dynamic RAM A
>   libcxl: Add extent functionality to DC regions
>   cxl/region: Add extent output to region query
> 
> New in v6:
> 
>   daxctl: Add --uuid option to create-device for DC DAX regions
>     - Plumbs writes to the new dax 'uuid' sysfs attribute through a new
>       daxctl_dev_set_uuid() helper (LIBDAXCTL_11).
>     - --uuid is mutually exclusive with --size; pass "0" to claim a
>       single untagged dax_resource.  An unmatched UUID surfaces ENOENT
>       from the kernel and leaves the device at size 0.
>     - Documents the option in the man page.
> 
>   cxl/test: Add Dynamic Capacity tests (rewritten on top of Ira's
>   original patch to track the post-redesign kernel)
>     - Routes untagged claims via --uuid "0" so daxctl exercises the
>       kernel uuid_store path; tagged claims use real UUID strings.
>     - Asserts that for DC regions, size-grow returns -EOPNOTSUPP (real grow is
>       --uuid only) and that tag reuse across More-chains is rejected
>       by the cross-More uniqueness gate.
>     - Adds coverage for the new validators: test_uuid_no_match,
>       test_uuid_no_match_seed_intact, test_uuid_show,
>       test_cross_more_uniqueness, test_alignment_rejection.
>     - Sharable-partition coverage (test_shared_extent_inject,
>       test_seq_integrity_gap) is routed at runtime to a dedicated mock
>       memdev that tools/testing/cxl stamps with serial 0xDCDC, so a
>       single cxl_test module load exercises both regimes.
>     - Localizes positional-arg assignments in every helper so functions
>       no longer clobber caller globals (the previous behavior leaked
>       the sharable memdev into later tests).
>     - test_reject_overlapping arithmetic now lands an actual overlap
>       inside the DC region (the prior math landed past the end).
> 
> Depends on the kernel DCD/sparse-DAX series; without it the new tests
> will skip and 'cxl list -r N -Nu' will simply report no extents.

What is this dependency- DCD/sparse-DAX series ?

> 
> The branch is also available at:
> 
>   https://github.com/anisa-su993/anisa-ndctl/tree/dcd-2026-05-21
> 
> Based on pmem/pending commit:
> 
>   bbd403a test/cxl-sanitize: avoid sanitize submit/wait race
> 
> [1] https://lore.kernel.org/nvdimm/20250413-dcd-region2-v5-0-fbd753a2e0e8@intel.com/
> 
> ---
> Changes in v6:
> - anisa: New patch — daxctl --uuid option + daxctl_dev_set_uuid() helper
> - anisa: Rewrite cxl/test DCD tests against the post-redesign kernel
>          (uuid sysfs claim, tag-group atomic release, cross-More
>          uniqueness, alignment rejection, DC size-grow refusal)
> - anisa: Rebase onto bbd403a (pmem/pending)
> - Link to v5: https://lore.kernel.org/nvdimm/20250413-dcd-region2-v5-0-fbd753a2e0e8@intel.com/
> 
> Changes in v5:
> - iweiny: Adjust all code to view only the dynamic RAM A partition
> - Alison: s/tag/uuid/ in region query extent output
> - Link to v4: https://patch.msgid.link/20241214-dcd-region2-v4-0-36550a97f8e2@intel.com
> 
> Anisa Su (1):
>   daxctl: Add --uuid option to create-device for DC regions
> 
> Ira Weiny (6):
>   ndctl: Dynamic Capacity additions for cxl-cli
>   libcxl: Add Dynamic RAM A partition mode support
>   cxl/region: Add cxl-cli support for dynamic RAM A
>   libcxl: Add extent functionality to DC regions
>   cxl/region: Add extent output to region query
>   cxl/test: Add Dynamic Capacity tests
> 
>  Documentation/cxl/cxl-list.txt                |   29 +
>  Documentation/cxl/lib/libcxl.txt              |   33 +-
>  Documentation/daxctl/daxctl-create-device.txt |   12 +
>  cxl/filter.h                                  |    3 +
>  cxl/json.c                                    |   67 +
>  cxl/json.h                                    |    3 +
>  cxl/lib/libcxl.c                              |  181 +++
>  cxl/lib/libcxl.sym                            |    9 +
>  cxl/lib/private.h                             |   14 +
>  cxl/libcxl.h                                  |   21 +-
>  cxl/list.c                                    |    3 +
>  cxl/memdev.c                                  |    4 +-
>  cxl/region.c                                  |   27 +-
>  daxctl/device.c                               |   72 +-
>  daxctl/lib/libdaxctl.c                        |   44 +
>  daxctl/lib/libdaxctl.sym                      |    5 +
>  daxctl/libdaxctl.h                            |    1 +
>  test/cxl-dcd.sh                               | 1267 +++++++++++++++++
>  test/meson.build                              |    2 +
>  util/json.h                                   |    1 +
>  20 files changed, 1771 insertions(+), 27 deletions(-)
>  create mode 100644 test/cxl-dcd.sh
> 
> 
> base-commit: bbd403a03fa2a1551c1a10bbf78f32027c718758
> -- 
> 2.43.0
> 

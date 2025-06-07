Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77F95226170
	for <nvdimm@lists.linux.dev>; Sat,  7 Jun 2025 02:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749263402; cv=fail; b=mP9+P3sfy6wfVShTCRZ67YHgGU0G4/EPhSb1Q483vdu85P8pufkQ2JBs7CYnm1Fd11yFMCphFI8snSBnx4T/OhsfMEpr3fVnMMSAFabxhMkABIxoXpiVC/5iX86b0dP2R+mGrM0bSVbSKrl5rpZBrZDOUlcZOkcvH05osd1kS+4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749263402; c=relaxed/simple;
	bh=NCsvL60x+v3J/S5tZr3MVO//FUTWXAuDFFrTUeT/nHk=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=mAHaDwip7Nq0NwR18ssJBpvyj43xhnxsgRSKdLqJ0wUcduRCXt+SCAgtSyTCDlVyO6WNYqLMoehJRh2pkwk2Q7nU3TxNKtSZhNG2rl7weXOMjdlPCbcn+qb79eMJkwLoW5uMiaOFiXiew1NKoCO7bJS32jDrK/QlM/kXdZf17BU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Rq788+Hl; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Rq788+Hl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749263401; x=1780799401;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=NCsvL60x+v3J/S5tZr3MVO//FUTWXAuDFFrTUeT/nHk=;
  b=Rq788+HlT/aGhPIZ/xvzFNjZ9wT1X2IsiY+JtZQ3FihooqlC3H0mP4Cy
   FpJ+NfhhN3u67yQ3Zttba6k9rMo8JaC067bsVm7yHEYEXHoVSQW//X4+i
   bdyQgLpO+TtpgxZ3jQzjrvmQoWa3uimSvIfp1VN/BodUBs1MSNzTdLtg9
   ymLGfdcsf0eRlD75xEj2Ss/DWrw4KadIIpFdZ23ulMVw9d1oBQmbyyINn
   zgYSpg7h5YuU5WoJvdX+tJP6msvmY6f8x1l9nuFw0GL638ZxWxhuevUqM
   vvJH6lz5qFe+cdRzAxDGKmTPWLo1O7E8b+GUZ0s5y7lxm25HN4D7d7mz3
   A==;
X-CSE-ConnectionGUID: aq3fe+wNSsW3rNYkKm8bAw==
X-CSE-MsgGUID: Gc4Qg1OFTVCAuWpHCK3A9w==
X-IronPort-AV: E=McAfee;i="6800,10657,11456"; a="51298633"
X-IronPort-AV: E=Sophos;i="6.16,216,1744095600"; 
   d="scan'208";a="51298633"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2025 19:30:00 -0700
X-CSE-ConnectionGUID: yVNtOaYjQYaLPWLNAji1Vw==
X-CSE-MsgGUID: DmiXOHwSQwKCVI1Ujvb1MA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,216,1744095600"; 
   d="scan'208";a="150818703"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2025 19:29:59 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 6 Jun 2025 19:29:59 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Fri, 6 Jun 2025 19:29:59 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (40.107.93.45) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Fri, 6 Jun 2025 19:29:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eOHqtAAypTZR5p9Q8DgkswZC9nCFY8xWMJ/q6AoLY6gIKbCNXr5m3qmI1Vy592QyjxSmtokemofA79EaTpmFnA/OvR5HFKPpcHJl+EkAzYJkUleetKYaxvopyJmiedXaln4l6jfii3q3Mb0kWyWJNJgizfKzclKG538ORD93qKoHELUMytQQj3IlYZ5HqZxz64LVOQuhGKTrH7G5R6fqoULcHvZPeeYYeV96WcGxJ/NaR9Mrk7iYuk/DvCFBSUIy3OTPEjvvX4jJop/sSdBiCgOMotOra0sebw/4jYGWlfj70qguOU2YGTQj4jqaftXI5XrRb8jjNkbpj2bPTZhv1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uKZqsfZYBOScbGcVp4esMwl6cJoTPxKwMe/aQpVh/5g=;
 b=H2IDgXGYBuqWprYvVUiClNeWdSEqzNcPkgQ/DLkrgBRIDJWgn0GxrRcCJUGQe3sES/oidzXUDTXLa6jVkWYXavgOfqziJGULyDepHEz24E+s8OhaXjhoOiBSo6sfHDcm7voHrHGFno/63jQbMhjmubCklEkwGhQAzQgDEFATds8zykgFO24PbJTID91zwBPuc95EDayFigu8lktdD1rr1C7IHi/s7iD+BrHTuaK3xcDdlW5psEpuatcurYoq9JGHIUZRmtfsLGuyxzQRODf3ql/Ztbd/m8D/hfi7zDfoSwgou7Z18emj8Um2crnOoNtCXXJ9SbV2A6fHkMsDRUMrOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by SA1PR11MB8796.namprd11.prod.outlook.com (2603:10b6:806:467::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8813.22; Sat, 7 Jun
 2025 02:29:52 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%6]) with mapi id 15.20.8813.021; Sat, 7 Jun 2025
 02:29:44 +0000
Date: Fri, 6 Jun 2025 19:29:41 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Drew Fustini <drew@pdp7.com>, Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
	<nvdimm@lists.linux.dev>, <ira.weiny@intel.com>
CC: Oliver O'Halloran <oohall@gmail.com>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>,
	<devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Drew Fustini
	<drew@pdp7.com>, Conor Dooley <conor.dooley@microchip.com>
Subject: Re: [PATCH v3] dt-bindings: pmem: Convert binding to YAML
Message-ID: <6843a4159242e_249110032@dwillia2-xfh.jf.intel.com.notmuch>
References: <20250606184405.359812-4-drew@pdp7.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250606184405.359812-4-drew@pdp7.com>
X-ClientProxiedBy: SJ2PR07CA0006.namprd07.prod.outlook.com
 (2603:10b6:a03:505::18) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|SA1PR11MB8796:EE_
X-MS-Office365-Filtering-Correlation-Id: b711c4d9-ba2d-4f28-050b-08dda56b2a44
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?e6c3ZSr7fkb+aJ1hc5pOujdABLVxziR1DDhsMuEKakEy4R+YLS+MKtF+bCfH?=
 =?us-ascii?Q?y0NTsrv8cpZieveHGTloleW9Hyy/ZwsyQvUi01zTsMmWXRD1ET/K993PllWR?=
 =?us-ascii?Q?IlAk5t56lh0IZtQunUJJJOjJ62QJ7TATszxJME1Av4epEcUyH0/mfFygUt5i?=
 =?us-ascii?Q?CXBzsd+D+96a3MaiVht3PGOBAGUQD+FDVVlV+V89/hOsR8lDl8j2vPGQmpmz?=
 =?us-ascii?Q?m9p9yUhpcJYe2mv6OL/NYOUvGzBd4j6HPbebc0lYvIaa6KKsCXT0TJ4GO45s?=
 =?us-ascii?Q?qOK4Mtjc8vaSDqSMnEvLJ/z9dudnCxazYGwqZs7Rzcklk8P6+5d6IZvrkCwP?=
 =?us-ascii?Q?SGL4VOvAHuG04KZfCmKxyY8kwI96s/dmenYJblIvf3HamSY3DZkDJjJB3bUq?=
 =?us-ascii?Q?DwQyVDx6IgknRN14EQ7pl61fQIVmGQLHZtq3Nuu6Ls2uVWRjk1MhkAdnndEY?=
 =?us-ascii?Q?iui9cbSi2pTHj68AxWYY2Ct9qeFOUjqTsC2g9/kJWTRjn73fJ5HidU51b395?=
 =?us-ascii?Q?qPyG0rT6LnpVdeN5GyAbv4kg/bIi4iFVYsxi7+dp0r45EaQ4hSeuB6LCnqsI?=
 =?us-ascii?Q?Mb2JPUkDFIlxmA8fsaGTUdFuqLlYViFUlquE+L35qKgRmWTL9wS38fh+/tpQ?=
 =?us-ascii?Q?GemB1jCmmFthGcN8ISKL2aF29WJnrxA+kSwn8pOUp1xV6UhDvCyAOaiWbIfU?=
 =?us-ascii?Q?7lnuw1agaExlr2EBr9fg7o2OXpqd3dWHQtpyZeR8weQqe+Z5+slaPFYOvySQ?=
 =?us-ascii?Q?7cJEFiHoQqZkUyPV3qoKO6LUxLoosey3DPDFDkA0gyu/k0wbvC6t1+EeDxfF?=
 =?us-ascii?Q?uUoJ8Oz3hU+8lIZmi4onXZ3Gccku0Iq1BWdtRGO0T7aCJeKYOEQUatG1c+eE?=
 =?us-ascii?Q?Ci0Uc6PmJ13hqRYAv3AyiFzH0DlIlvpp/lfVfSf04rQKAdZWh8F9AXKNhRxy?=
 =?us-ascii?Q?Dz2XKExGkCwFCsTfQLQ8g6I8u2jjAGKgX1MCiplsSg1WO1hv1X2e1tLmsdjh?=
 =?us-ascii?Q?s1nKrOFLXjlkDzw8zT5HSuuZkT+gKEjn2H0ebm38GC8wKD1HmSh5jnEKjlfP?=
 =?us-ascii?Q?ilM+6IMWVFVT/5eYtVpmpQSgqo4p1bC6D/XfQmXCEsOIYbU8T3Dy7odZxLpu?=
 =?us-ascii?Q?xlAqDBA/F/QgEQRSdCuwfVAsTL9g37AGvmR4eRDy7EqdKU836zXSB3mEQ+bB?=
 =?us-ascii?Q?VAf8piV5gf/2OFk2f/l7P0Z6euycxbhUklVQw+kd6hK2Kiab2wzqsdxa52kc?=
 =?us-ascii?Q?2NfSs2Zo7iax9DoaDHDV1FMkGjELUXQXAsCpYj7i4mRsBhM7TVnaVUDGKZnV?=
 =?us-ascii?Q?+7R+0CjygxoSoOfoWR+o5G80D2+jcxhtkoEGRjuwF8rsEGFbH0C2kktuV6+K?=
 =?us-ascii?Q?UYpYdXg/J3qPRaTfCRsEPkOi0JooDzMH6mRcClNgp/xHc0NShXcVK6tM1Jij?=
 =?us-ascii?Q?g/3u+TYcJDc=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IO9xsc8oL0NG6g7DWhjNQmLY/AqgaCTFJgai50HLrX8JzdxW5iIVyYuKnlDc?=
 =?us-ascii?Q?yk2HM2Fpo9jkCaqW0uTTjt16X4NFD55++TmpyqmbqRK6cw0M/kJMoVqA8CsV?=
 =?us-ascii?Q?a4tiaeRwn9BrGy/eAvQSJFzMldCqJqzUWSGEADLzwR/4iooji4JAa8HA/Hr/?=
 =?us-ascii?Q?gyMUPxPWsg8JuR7NxDQbaym9wZJLTx5lOj36kMQILCjWM/Ob2B7mERp0Fvfz?=
 =?us-ascii?Q?USMejDip2o1pPNywcSc4RVhA1LfnuyRhwPtN7Cqj+fbWUF7N0XaWzzvSkUBr?=
 =?us-ascii?Q?JmIR5sxcg4ZEfcqDAlqcTDgtSb/N6xHS+LcckPpEqa/GGovvhWaniXigRmfi?=
 =?us-ascii?Q?PyRwszzy4CzavCdAIM5u7hw21I2VdwOKfupCZ68fQWJha9pnxxJHUyzhwX+p?=
 =?us-ascii?Q?FfEaOq6gip7vQCShFK4DSAEq73//a+24GLvptPkS8D/hYEc7/4n9zFyT+QDu?=
 =?us-ascii?Q?ldVFo5iU5591eoxO3XB5FF3ferZbK2d9pdHe3V7V87B616znRyJ1RHI0jPoh?=
 =?us-ascii?Q?cn1isfSKxT1TKf8JqbldjGIV8cHihiMXTncy9sWyVablG6X8lncOze6gzaba?=
 =?us-ascii?Q?OkWYgEKlOnMFpI1QhLpv+rkXxLJMwR+Y+6KEPn46R6uYpxaOW2b7U/E0/sos?=
 =?us-ascii?Q?hRxPHPAi9ufZnY+BumU9aj8LRp0SU/eRahkhM2mwpKFzGlAqTm2QmTf+pDFO?=
 =?us-ascii?Q?rxNbaH0c+SXFqlVu9uEXf0Rw8OVrUbvD4UVNLjXyqg1pW8AkgtKK7zdVNQcN?=
 =?us-ascii?Q?B+JFDnS7+ISoVzD5r4BOuvVhwGfvv3pJegnmXEQAm5/6/FLoWgJGe5lTm/P9?=
 =?us-ascii?Q?HRNdZMoxU0yA8eyxAlJYbkxeBVH/NwlnPYw2wBPnxBxZICqt0PAh4P/nVcTA?=
 =?us-ascii?Q?RIh3mkO6n9NsSj7DG1cN4KGm8UzeF6emnHAxUJbXbOt3ljnnNCGEwBu+w3Wl?=
 =?us-ascii?Q?vQnqV39Y100qWTA8Jb9LJ6FWJvQnMFQAfXE3BaM6FiHhaFpopfZCaaYSLjM7?=
 =?us-ascii?Q?DrIr3tF9FFnHeYzZf12P5cARxY3mOoeOdaLfSVm+QjjYFw6DKwKjR26Zvfrx?=
 =?us-ascii?Q?wB2Ykr7OrDniAKbMxguXy9gzRb3WDwuCWT066bIXoVA5vx3s3x2Gojx9tC43?=
 =?us-ascii?Q?OpNpSdbCVfxmJx9bCrPFgjD92pW2xO2R6oL1AnplfWcjqckKvNb2/uNVHuDj?=
 =?us-ascii?Q?1b+yqUsqmVUiwK7UTah1t/m+3hv9wIizzlBfG42FKWGl0bU+AbgjH160vuBT?=
 =?us-ascii?Q?ndM2AjBWmEdzWCPQwWmnD+yvTvni5U9o3Bz6mJHAq4G3uUPluLB5ZbH5UhTg?=
 =?us-ascii?Q?qNS8JjKALIHLfbMoKwLNvr0PQTo1RFpQQ3M1Sp6YFzQy3NUaGKg8zlE46LxR?=
 =?us-ascii?Q?P39DW7WRPGmw3CV+8sQR+bhdTj3lYIGKIr7rXr5YSCbHizBKayeSp8rxtI/U?=
 =?us-ascii?Q?wbnxzrEKK2+qZ8vsCoKZ+unAvFjWuaD9+NtiCSjJ//dFgAzZLSSU0QQF6QtW?=
 =?us-ascii?Q?g3MsB0oYd6bsGnhJpsLwqCrNN/o0u8zpgHNZpeEfbw9CF6q6q89/knTtzYtP?=
 =?us-ascii?Q?sQZTgpvRFH9qgEg1bphtmTWa+audt5IFevZ1m/inPSXzyOUOALVmx+Qn/kQC?=
 =?us-ascii?Q?BQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b711c4d9-ba2d-4f28-050b-08dda56b2a44
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2025 02:29:44.7860
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X1uwshEfKBLumJ27kOo71aOge/tO3X86ooD53Qy/mJETLls9Kf0y8RXLRTF1bSaZ/KM+ZHLaJ6kCmu5c6As5Ff1NtYFrwqGc/5WmeLf38YE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8796
X-OriginatorOrg: intel.com

[ add Ira ]

Drew Fustini wrote:
> Convert the PMEM device tree binding from text to YAML. This will allow
> device trees with pmem-region nodes to pass dtbs_check.
> 
> Acked-by: Conor Dooley <conor.dooley@microchip.com>
> Acked-by: Oliver O'Halloran <oohall@gmail.com>
> Signed-off-by: Drew Fustini <drew@pdp7.com>
> ---
> Dan/Dave/Vishal: does it make sense for this pmem binding patch to go
> through the nvdimm tree?

Ira has been handling nvdimm pull requests as of late. Oliver's ack is
sufficient for me.

Acked-by: Dan Williams <dan.j.williams@intel.com>

@Ira do you have anything else pending?


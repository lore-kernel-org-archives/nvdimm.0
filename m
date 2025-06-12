Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08B42EADC
	for <nvdimm@lists.linux.dev>; Thu, 12 Jun 2025 03:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749699022; cv=fail; b=D18tZWZHlsk+D7xxnKWKlphir7pbaoLetKUNWeawckJRevw1xvy4Z+J6MfHUG9Gm61c0Vbrbl59Sz/BlZLb2ffc8yqr6+hNvLoWPeKcdlJbWI05My8pDYGUe6+Yv+aEX3dAnX2dGRwc87IRtzEhKeEBMdfYjZmMapoGldCS5nyU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749699022; c=relaxed/simple;
	bh=H3H2vt5SHlj7zX1IKhCVQ+SAmRpSrRZN72hLCavgz94=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=r0xDHLIpos9HgcR9RDsZhUu75ZQy9XCyQNBTRIF0giEyPR56Vr0XOC573uNGRojiOmzcSUEP6qgCNd18PY4RqZjf/M7CBQJ4o2kr1jpZpnc3V0mxN3tDItrQPaJe/weoonOu56cB+3KVVx1x3Xsn0M04V/b0lFTv0hWbmDHVIQs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aZak24XK; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aZak24XK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749699019; x=1781235019;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=H3H2vt5SHlj7zX1IKhCVQ+SAmRpSrRZN72hLCavgz94=;
  b=aZak24XK3Nj7TsNRd+3OonWmWbb4tn4ttSXm+iEXaHcgxQI5bIUqTVm8
   VhZrhkJs/VQElPJ7kEVly3P/9Iy8kpq+POkTB0D/nkYTb72/SMNe1Xj3y
   dpbXxHbEk96s2q59Xm/AotS3QqTtd7MNiRGWTaeyP3/oW4Jb6MOGlScJD
   Du5F9VyE5YPu10MhIv9ZY8+P2k8mrjlHZy64iTWt9+BIgk0cUm2LaG5jp
   5Ejns9rY6ROhX1MxA1knsYCm+2Xqyib293ij9VaBMkvZBNENdBx6LJ/LH
   8hLPSnXrTi3eDEHO5KCqrHvBuvHY0JOd/+OZcDzo/MRRd4PylfuDCgLNK
   w==;
X-CSE-ConnectionGUID: ZloY+jtOSbSZlbsf4BzD9Q==
X-CSE-MsgGUID: JI0ZqTmOQb++8RGyRge13w==
X-IronPort-AV: E=McAfee;i="6800,10657,11461"; a="52006117"
X-IronPort-AV: E=Sophos;i="6.16,229,1744095600"; 
   d="scan'208";a="52006117"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2025 20:30:19 -0700
X-CSE-ConnectionGUID: 84xjCrJJSqCYT8z0C5shzA==
X-CSE-MsgGUID: HSHF7u9mT8OyN60JVoXR9g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,229,1744095600"; 
   d="scan'208";a="152533207"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2025 20:30:18 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 11 Jun 2025 20:30:17 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 11 Jun 2025 20:30:17 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (40.107.101.86)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 11 Jun 2025 20:30:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TUasr55K8Z9Hus/AspmmKjyPGx4ycbQRPOFD5XC3RAAOOx5ZgpTcb9uTGw2Dfh+ZynJpvcHyqMQuGyUKJpHv7lMlVPB2xvl16LTiO2Ej8B/pkwMcFVXzaVy84X7KmZllAvxdd25BAJR56iQJeP+EDabBfu4qJsinZIeHldRXtp2nu5Kcmu1r7plKIPEYGfHdZf2NgBs1XbfWOqNcoSAA03Mqd7icItKTj/6iez6L41h3bfskAJodh1+mSHEAk1y9PSs4RtkteFaKZMIQWMsW2Q92td1yc7TYondnLbLxAy+F8ix05UQl4j1JLm40st+hhf5vM+R1/NprfVGKu9MExA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KmphjMdRUAwCG/jRtnlViqcqE+Lc7Lecl/hgexfeuHY=;
 b=o+dBedJ5ZZT+MJemDCad8r0VGmCASXUX176+RC8Q31z2egSouATUP29b+C/oOoxVoq3X0K1gjaE21poRWYMIuf5nGyXcyAYjd5Cw66gsrJ9UPao5xof9x5pIcU+xxGeYqhQWi7tTKMFzZmO3bQAKnyld6hsHlmLwUZVBKskZ2VHEL9j44M/3SYb19M8EAR39wREaFMTD7pdnOouD1Qstxdvt5titoSq4+bmSSoTyEPLvTuKH+w8ETUaIUfSFnMoadDFffGlrcu2fOkYt64iAeAZ0QEbIGq3t1oev96z04ndlo0sKlIR2a7UKMbtbNF46rgjWAj1MzWEoQIu5g4goCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB8794.namprd11.prod.outlook.com (2603:10b6:806:46a::5)
 by SJ5PPF09F392AFF.namprd11.prod.outlook.com (2603:10b6:a0f:fc02::808) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.29; Thu, 12 Jun
 2025 03:29:48 +0000
Received: from SA1PR11MB8794.namprd11.prod.outlook.com
 ([fe80::a3d4:9d67:2f5d:6720]) by SA1PR11MB8794.namprd11.prod.outlook.com
 ([fe80::a3d4:9d67:2f5d:6720%5]) with mapi id 15.20.8835.023; Thu, 12 Jun 2025
 03:29:48 +0000
Date: Wed, 11 Jun 2025 20:29:38 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Ben Cheatham <Benjamin.Cheatham@amd.com>
CC: <nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>,
	<junhyeok.im@samsung.com>
Subject: Re: [ndctl PATCH v2 0/7] Add error injection support
Message-ID: <aEpJon2W2m1IpgGx@aschofie-mobl2.lan>
References: <20250602205633.212-1-Benjamin.Cheatham@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250602205633.212-1-Benjamin.Cheatham@amd.com>
X-ClientProxiedBy: SJ0PR03CA0022.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::27) To SA1PR11MB8794.namprd11.prod.outlook.com
 (2603:10b6:806:46a::5)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB8794:EE_|SJ5PPF09F392AFF:EE_
X-MS-Office365-Filtering-Correlation-Id: d006bb83-bb21-4229-6454-08dda9616182
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?ITwzidyOTGXYYL1L2mS1r1V4XV5iEtSMoFXMTsCdlKbeQ/Ri6XnHIsR4buJn?=
 =?us-ascii?Q?Y+E2KHkf4z7Cgt3ZEEM4wlMWf9Rv+kJjfkZ5CT1Wt3p3lnIYZCQYMq4ByKRi?=
 =?us-ascii?Q?6nJcHZJXQhENrWwPvnKAyn2bZo8dMp1S6uJTq7I/dMTWdH33pfU9nhoYR72a?=
 =?us-ascii?Q?rUnOtN0Tbh3FoYI+RaLOFOpPtuJwV5rGo8dvMGxdbJnnIt9Ao4NreCqvMJN5?=
 =?us-ascii?Q?UfChYeSteahvAeWcVJl/V5tvaOw5GA1zp3yJ/5Pk9MciEHs/TcMS6XFDIQ7f?=
 =?us-ascii?Q?UtzF7x3BoW3c2wTFnLz3N+Cpu8DacjeXtE9FHf2OIYQX7OIwX+lrSMYKTxgn?=
 =?us-ascii?Q?Oipk3vmc77wB8H+JmqNwdZ9VTnLQ/h9Q8xjolxEFQqqIFqB4lB009bgPLxDf?=
 =?us-ascii?Q?/fTuiWG30Xe2nUKyUtlE0omMDXq8G7pBDtti0OjQJxzjRKDL9naZkGudQVvx?=
 =?us-ascii?Q?J0sKnHoDRk6ZHUmYbrnN//iRBHDugGgfGb9YcOlJ/QrzTPHzELAZKEJJ0WY1?=
 =?us-ascii?Q?XCb+dCXyWdBcSlz8It+7NnW00JkBhqW3/Se9coA8+jrJqyQVlOIR0JSw9+82?=
 =?us-ascii?Q?KI8uXsbCFuiWdHPyQbnLzJVVNg9MpO7Z552w1u7ahQWeEvGgZw9VAvCugoUS?=
 =?us-ascii?Q?8w6a4PP+8BKDcduuLxDX2XSToOvsSAoCcflcIpEgwLmrJ+i5EBY0vT4Jq8I+?=
 =?us-ascii?Q?C8SQ5M7v/Q18qhr9qlgwIacAlcAxtVx7kEDNj52+tOGn1cI081ZyhYj0rem5?=
 =?us-ascii?Q?n/8Jabv8KAFif03oarmDLkpfcwhd8eGsiTEdkYCGQ/4Oau69u+QVQ1cAjmH9?=
 =?us-ascii?Q?msiow4KG1l78kW2BoFUIoP+unEt6D+PqnCbHe/AgvpvNXCqnpBEE7XVrzzIh?=
 =?us-ascii?Q?+VYLjN4wgYhh1XrnqYEv55gj+wUzdAOgmMUb4btNBpOxiNSlJwx3eVL4YeiH?=
 =?us-ascii?Q?LPAMgHBsVUsWgT8FU3caRHRecow17VWJ8flXHLqQula1D6o8s/ZgntyX0fP4?=
 =?us-ascii?Q?gDa7Mr+z7kX4jlf5XoA8s3zeIUkmKBxuGzo1r/CSzNQ6WypW0Sxre3v3L+c4?=
 =?us-ascii?Q?3v+39GqcbcuZGcPtOFMQfZHp/DdEuiwIHKxoFF64VcMLsZW6EisOjSE2SDt6?=
 =?us-ascii?Q?jOF2mNNkIzdunziWAgw2Vf5W/0inP42h95cMcl/NzMNBvRzH16WTdNqi7LRn?=
 =?us-ascii?Q?tJh8LfsM3yBigDZhG6NvPqW8J7jqQDa+o5NBCE2vhqtr7wKkHAcfLUQhAp75?=
 =?us-ascii?Q?bxulWKk6qpsjzkzii7grVBeniisuyZ9K+978iXyUC8y0g+5TFc17lqtupBRU?=
 =?us-ascii?Q?9yuu1jKROEMzw8eGZCAdSWCOOPi8r65cFrRGTHhYKsh+4d1KmMh60IQCNhzR?=
 =?us-ascii?Q?nAzV4MU=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB8794.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Nhfm2PIMjsm2GVK643Vq/uiY9orLBTdEfYHEI6Lw+XPgCzB2LJaGQbBmAOK9?=
 =?us-ascii?Q?JBuKMSgCkZnrLfNHuck7m5PfsjNzeTSbC9JkOEcCKmOglk3S2ZWUrF1FKEvg?=
 =?us-ascii?Q?VDEpFzJPbDg30tKYa2wg4k6QY3vAUeFpuHja9rhDaO1hnBLjQPKRR2lVg3gg?=
 =?us-ascii?Q?SvIKviHMHHAZPhM0A6X03RSb4fRd4CeajbyQeXAFZaZ14VadZrbMGxLMrM36?=
 =?us-ascii?Q?CemgBO82eglVU/h2lacY6IDs5Xx/l1LG1BAmRu7Zez9peBLeSJHH6p1yvuHk?=
 =?us-ascii?Q?3HMQsRqcZJyajKnMT9z+ts9UcaVSKNbhBZThdOWaYmYhvOHyMpHnrWMHLynR?=
 =?us-ascii?Q?23xr+MGi4YjKEehA3ek5YBYjS0U2biyG4dZBrWV7uOeKjiZ0Qrgdmf50xh3v?=
 =?us-ascii?Q?0eQ0VWhvM41gxAiZXq3icJerC3jJ/JiJ5gEY7/nhoh9O/VokKQGYUfeC4XlQ?=
 =?us-ascii?Q?VeG68d+3qrV9kbeBMnnGlNSZON5zsQ6D7yeQSFG/Btw3TJsUD474yGqo6iiF?=
 =?us-ascii?Q?Wdn5sVE9inXj2UB6ELl5bOqJNepYZo34Rc9LuwpdR+sF9H0tj89hrzk166Eh?=
 =?us-ascii?Q?G81wjqJL8rj/Wq6QxbyP9VK7fokHJrgLdVyH5kTsksgf1JGq96o+T1isZDP0?=
 =?us-ascii?Q?IdlRWhgBuGSa1p8DbEB2Ifb9z9xY5nNxMAFj0N26zuSfcK5vuoF3Ov2Ft6TL?=
 =?us-ascii?Q?w0cMjs8lApOyRVsLdbUa8dP8TZnS9FQYU6easeXow6BbzfH9LEL0qE4zc5uk?=
 =?us-ascii?Q?C+7IV4dSgmD6ipJFAglStR27caziuU5UoZ8gtU/Rp0a7SIJOBg857hfvaDsL?=
 =?us-ascii?Q?BYAadHT3it80tlFiU0pnHRzela+dcu41hePoiuo9C/uYTtOaxFiwFoRfvtfP?=
 =?us-ascii?Q?gHe1T6zwzONHiMMZ5R4BiWQu/14pjjcIQON/yQe2/H9GlecE3WbzjQ8pGPvJ?=
 =?us-ascii?Q?rL5asCIQ1O1whyM2EE/k8jFJ12Kga20K0UErbgNbwrJMf0x2B6FAgmtZVD70?=
 =?us-ascii?Q?4fkxNMLn58lm9od5NkHebPlBKmz6bmxuE/jG/VCi3yxoDVr2tVa2NdCC+DZd?=
 =?us-ascii?Q?Ma21v3VcVVYO8DBQCkGlppvcVsgS0gRNiaVStJ0ic3dxAakPKwC1e1qWwAwU?=
 =?us-ascii?Q?iEMQ9PGc6eXYRCn1Z3RDwCpC3OyMvmUssWkYIUGvSbWfOdQqIolvS+vQ9MMO?=
 =?us-ascii?Q?N9wmbU37sAfUmzc5AJQsdEPIBns/lC6vlzasP1+T5einbIPJAR3VEvLPHPyz?=
 =?us-ascii?Q?JXuJut97bb8q51fTfnXdm3cjjRttfxlVWu3foSF+PAEWbhUCicCTt2DU/6Vw?=
 =?us-ascii?Q?zia/t4jz36mFK/Qj1gZpWa60oCzKl0hYcoqlbYdPN5+htqKqN6kqvC0g6ium?=
 =?us-ascii?Q?oSoLQmUBV+t/sajjekship9oFBrYhjIGggRGW79IwaOECVN7dy0rYseQq/yE?=
 =?us-ascii?Q?/v1NZSoIzNy9mtHW3pRjbIHsbLSNhic+vICvhl+8kGLtEyqIlwNNOMKCJ6eH?=
 =?us-ascii?Q?s7WMo7kKKL2UeY031+e90y95yZMTgaRzB80SwIGFvYfIv1HML1YDFjlDVUSD?=
 =?us-ascii?Q?wo98mYOQqrBGyq/z+w3Tto+jKhrOWV8HN+2zepOdIlgVROECLea3lwLs2Jkt?=
 =?us-ascii?Q?Ag=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d006bb83-bb21-4229-6454-08dda9616182
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB8794.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2025 03:29:48.2517
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7n6vXfGbvIRtOaM8N+kqqGqhkVHVXw42DV09uTQItaZXO+XKsfqflsogPLokxykb9BK2wOmIrCZ9mqnn18wpkeqUz1EjIkJg/Zgth1JRq2w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF09F392AFF
X-OriginatorOrg: intel.com

On Mon, Jun 02, 2025 at 03:56:26PM -0500, Ben Cheatham wrote:
> v2 Changes:
> 	- Make the --clear option of 'inject-error' its own command (Alison)
> 	- Debugfs is now found using the /proc/mount entry instead of
> 	providing the path using a --debugfs option
> 	- Man page added for 'clear-error'
> 	- Reword commit descriptions for clarity
> 
> This series adds support for injecting CXL protocol (CXL.cache/mem)
> errors[1] into CXL RCH Downstream ports and VH root ports[2] and
> poison into CXL memory devices through the CXL debugfs. Errors are
> injected using a new 'inject-error' command, while errors are reported
> using a new cxl-list "-N"/"--injectable-errors" option. Device poison
> can be cleared using the 'clear-error' command.
> 
> The 'inject-error'/'clear-error' commands and "-N" option of cxl-list all
> require access to the CXL driver's debugfs.
> 
> The documentation for the new cxl-inject-error command shows both usage
> and the possible device/error types, as well as how to retrieve them
> using cxl-list. The documentation for cxl-list has also been updated to
> show the usage of the new injectable errors option.
> 
> [1]: ACPI v6.5 spec, section 18.6.4
> [2]: ACPI v6.5 spec, table 18.31
> 
> --
> 
> Alison, I reached out to Junhyeok about his poison injection series but
> never heard back, so I've just continued with my original plans for a
> v2.
> 
> Quick note: My testing setup is screwed up at the moment, so this
> revision is untested. I'll try to get it fixed for the next revision.

I applied this to v82 (needs a sync up in libcxl.sym) and ran cxl-poison unit
test using your new cxl-cli cmds instead of writing to debugfs directly.[1]
Works for me. Just thought I'd share that as proof of life until I review it
completely.

Adding more test cases to cxl-poison.sh makes sense for the device poison.
Wondering about the protocol errors. How do we test those?

[1] diff --git a/test/cxl-poison.sh b/test/cxl-poison.sh
index 6ed890bc666c..41ab670b1094 100644
--- a/test/cxl-poison.sh
+++ b/test/cxl-poison.sh
@@ -68,7 +68,8 @@ inject_poison_sysfs()
        memdev="$1"
        addr="$2"
 
-       echo "$addr" > /sys/kernel/debug/cxl/"$memdev"/inject_poison
+#      echo "$addr" > /sys/kernel/debug/cxl/"$memdev"/inject_poison
+       $CXL inject-error "$memdev" -t poison -a "$addr"
 }
 
 clear_poison_sysfs()
@@ -76,7 +77,8 @@ clear_poison_sysfs()
        memdev="$1"
        addr="$2"
 
-       echo "$addr" > /sys/kernel/debug/cxl/"$memdev"/clear_poison
+#      echo "$addr" > /sys/kernel/debug/cxl/"$memdev"/clear_poison
+       $CXL clear-error "$memdev" -a "$addr"
 }


While applying this: Documentation: Add docs for inject/clear-error commands
Got these whitespace complaints:
234: new blank line at EOF
158: space before tab in indent.
        "offset":"0x1000",
159: space before tab in indent.
        "length":64,
160: space before tab in indent.
        "source":"Injected"


-- snip


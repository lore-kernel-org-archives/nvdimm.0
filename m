Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 836413815D8
	for <nvdimm@lists.linux.dev>; Mon,  9 Feb 2026 19:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770667153; cv=fail; b=YjQlygTKPklY2i/da1nKHQDH6yzSwqlacZDcy1oJ2HNk0L75YJo8Xg/yi3aQUDX2Gbp5YQQVV169/Asqwo1YwUj9aDYdKuavVXi6PGE2bFDyeMrzZPekzt1u54h/27gpkOykfkHXsRdBQYBulIW10DmexUWolm925sJVcLnV5r4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770667153; c=relaxed/simple;
	bh=d86dok+6tGABgUKfmE9WOLPPRLMylftMQ2IsfPLpSdY=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=T+xUVWrSOpJwxVaHHBCFNfBNE7+76DGQhU/i6maxe9ztwdKmWcz61b4iBxxOzaFuFFt+7/f8Q49fM4syH+EWaJjobp26w12ZyJ7Ew8ESnXOTh8u8FmfU+U29/vhXP7yvdrvG4ufCYt91M8jdQOqQqQAGwnsMSaFwubcX67jBzJg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=I5TJ7riP; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="I5TJ7riP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770667153; x=1802203153;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=d86dok+6tGABgUKfmE9WOLPPRLMylftMQ2IsfPLpSdY=;
  b=I5TJ7riPvWB4/bpD50uy9h9Hkda/KpO2ta/sEjdsnE/svULT/WGcK89m
   NMbgEw2rXbxzkgE5aEbxbeG+maFfDBsvKTrVKCUhcXadiNJhpOlPre4Xd
   7ixfAhSA2nlxcKsiarrSGFFWWMPYTKstmHD5l/mcSOKy9LoR480CvFL2C
   ohcbtMZXwloxM7I9I3slBhhPRPcuU8T+QfVxnQ6x/mjus6yDLXAqEkzhp
   HyYjo9dKgsFCuq1X7hsILYGjvdmQwYL29cTikPSnC/w7Jn5h4MxthLc/w
   j5E2KUYY87MnCMU8Jz+8n+vhhH0exwEsG9Jyi6rt/2M45S0DlFthkQ7KZ
   Q==;
X-CSE-ConnectionGUID: jcEnGMLaRdCL0E2OR0AxJQ==
X-CSE-MsgGUID: vUi0xjXmQ6KjimDfNCiOtA==
X-IronPort-AV: E=McAfee;i="6800,10657,11696"; a="83229123"
X-IronPort-AV: E=Sophos;i="6.21,282,1763452800"; 
   d="scan'208";a="83229123"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2026 11:59:12 -0800
X-CSE-ConnectionGUID: OJU7SRjzT66xh5Sj1z3afA==
X-CSE-MsgGUID: p+48PabcSU6c6Uu21jQsSg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,282,1763452800"; 
   d="scan'208";a="211695380"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2026 11:59:12 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 9 Feb 2026 11:59:11 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Mon, 9 Feb 2026 11:59:11 -0800
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.3) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 9 Feb 2026 11:59:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VpU6IVwCYEI/wPlJ0nwANf//2Wwl8MnPnTXxXJ3Jj6LDgkwv79akVKeK97ZFfkvgTKrx4QcXfQJvzOsmMQ0VcgkgeEjswPisiNx2xRnx+cEdM133+Is23VuFb2KoUN0Ct21fEoRQCfb+wgJZ8yxSIiN7hQtStTVIORhcNoZPuvM5gcsaflOLti93UfSAlkmhKbMRVA76scC7CJDZQ65H+HpHf95DgmmDkFA62+FokrxGligo5U8R4sbb3eM2ZF/tWLAo8LGh+U1owBLWHBD+obgYEMj+jNzwqLwyhwK5YoaoVZpNl1x3WAq00zuPemRDXAqHbKF8y8btOtn6awVx0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4m2gtRhdx0035tiIH1DHXKEuP1K9WlNFRSwql/WvLAM=;
 b=wq7BcNgprhVNfDjbNl51kWsVJ4xBphfbx3pbS55pvrOcN7rpueNHK+aDUNZo6L6r3nRXvEmrDgfIIR7qgZA7DdXYpJiiCfYyS6aPr7AhmHulbXlpSasRg+ZflvgVkARBZFv0wKXn2cwKygE0VGgHtqHZNL8272rThmxIs0pVXMJ171/VQV7g6fgkXjsaf1TkzjPJ/4aREHM9OJVWSToAjivRwEm8EzRAPKpmKlawk0ldSk/LYGFiOpgHr8wA9RARsLmu3zMlE7xiHG/y02SzLcvoTefoHvtOAO/1N4Eny+8LhaIZ9RNJDSnyFWrPqRv5yrOsRThOo+KRJns9aRDp6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by IA1PR11MB8098.namprd11.prod.outlook.com (2603:10b6:208:44b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.18; Mon, 9 Feb
 2026 19:59:08 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::b437:3b5f:e6c1:3d13]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::b437:3b5f:e6c1:3d13%6]) with mapi id 15.20.9587.017; Mon, 9 Feb 2026
 19:59:08 +0000
Date: Mon, 9 Feb 2026 11:58:50 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Ira Weiny <ira.weiny@intel.com>
CC: <nvdimm@lists.linux.dev>, "Joel C. Chang" <joelcchangg@gmail.com>
Subject: Re: [ndctl PATCH 2/2] util/sysfs: add hint for missing root
 privileges on sysfs access
Message-ID: <aYo8eqw73RNN5i9r@aschofie-mobl2.lan>
References: <b74bfd8623fcfc4cf1078991b22b8c899147f5fb.1768530600.git.alison.schofield@intel.com>
 <4e4ba50b1130c2a76bd2f903aa00644e43faf047.1768530600.git.alison.schofield@intel.com>
 <698a389e5411c_c11ee100d7@iweiny-mobl.notmuch>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <698a389e5411c_c11ee100d7@iweiny-mobl.notmuch>
X-ClientProxiedBy: BYAPR04CA0014.namprd04.prod.outlook.com
 (2603:10b6:a03:40::27) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|IA1PR11MB8098:EE_
X-MS-Office365-Filtering-Correlation-Id: 353599b4-bc51-4334-02a9-08de6815af96
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?X2s2zgDdto6JUYcIv/LCInqsOlWMcAiGt88TEnM+uTD078GokqMJ6k04ls8n?=
 =?us-ascii?Q?XmODc/iwebpo8+JkSXoP6HM/h61at/59HEGEvsV5j9YYYKd2N/wyF7Z7vidF?=
 =?us-ascii?Q?C/8DMNk6fu3l59c1iGk3t1GZom7qVuBzjF6GRN9RjOFRykYmQgIPUFMaI98U?=
 =?us-ascii?Q?DHOcEYj9UAhY8aTY/RFB7uzoWUHOkXUbW3DBaG9kBiCj1tTA9m3Y8uHVd4Ch?=
 =?us-ascii?Q?jvsKQ4xQTas3HTWDDOzG7iyXTv/2PcgVisyiYcCGnPranVhL3tu0JySa1lpe?=
 =?us-ascii?Q?kG9Lmfboaaxb34JYmwtYGPrx19ROIrxzUre0JhCHERWC0HMo5ZR2CixTZ4Tg?=
 =?us-ascii?Q?s3GAXV4gDgp97Cm+bCZf2S2ooP9rJB5BR+P0GVyyxVnCynyUFo5NfvvC5fhN?=
 =?us-ascii?Q?gpDLwgGWWqwjWFdreFDpKQOrCAo1C4fS51XQdwlvCiqVbk+qrLVA0+HSMMGK?=
 =?us-ascii?Q?VcU3M3SARL0nNrJGBODd5fW+JRYGTes4n07Gv37FEk3WQa5KlrFbqHLnGS/z?=
 =?us-ascii?Q?3coaRl9alOYxotK888S5Wp2wGgPHVG5oX1t9HR3N9qy1+UHm0U0yapdKVZRI?=
 =?us-ascii?Q?8HjnU7auQokr5x0QzgcGVaUcKmfLpazhtYTZp2CULtA8G02JPN7MLtqVlSVe?=
 =?us-ascii?Q?/tVgZbF5T7A/EzBXtUHw8jd7Y7DKS/hMJZRt+7j2AZwVXNoeqkBnbADreUw/?=
 =?us-ascii?Q?78WIbHLiUXERIUEAMzyh6MLbZ9kxxbODGdgTbFeAbGUsX9rZrjuo0FO2uyym?=
 =?us-ascii?Q?Bo0kblPGdrUwrwokPT/4ay7hgeQKa+SllhRJ8UlTltiMKQNhL1M9YqqyTvOL?=
 =?us-ascii?Q?hb8tITnUntDRdxYAZVhHWVhnJ27OBPCMXuYbfhpMu4CQm+LeyYTQ/lkMHlVx?=
 =?us-ascii?Q?BIcOcSqrKqQ3AYgXy+ajOx9uMVFa5NM4CDciUPVygt+5dCNy4jISdzF0UACw?=
 =?us-ascii?Q?HCk1yvF88h0+r8ViCmKkEB6JdpF5MJAUd+aLAcyAGiRTtmdR42ZGWNTzMEd0?=
 =?us-ascii?Q?W92ftyzs4LZ28qMCKqEm1HK8+imGU2iYAj7MSRYJqdThe9fGbuI3JzenMpyZ?=
 =?us-ascii?Q?0kbfkiUCeMsLmyi16PNtLyLWz4AuaQPtY/lqxvrKAAce5aPxRxKUybg2ZAww?=
 =?us-ascii?Q?8+Calzv6GcFvspdqL8mV95ndqf8t2X+u08HimsBNR61cgoZ2mFB97Tj1WrL1?=
 =?us-ascii?Q?l07yInoejQGI+RMbmZElK7Q5vzmNYnOslLbrpUDO3WGuCJvZZmBzy2aYfsIn?=
 =?us-ascii?Q?qMODrpJ46xnC3XmhAE7wIK9BIY0gsL+JppUg63Y7hrRRDi9dz3nhdrbM4VfL?=
 =?us-ascii?Q?igV9UMUq/uxK2HZfEzdS6DP0QLaImHeU731Hzr3GTiBMMoVr/by/cIr5e6wt?=
 =?us-ascii?Q?HWnJCTLvT3vBk8J+5zOg97jm9AGx4yWJohivQFo015mxQ8ONbbxR8dFePFme?=
 =?us-ascii?Q?dlUOsaaX1tHfkrOlxFYUBCFu4Jn2T8kh6PWGkbbjX99mahR6MffUZQhirLhR?=
 =?us-ascii?Q?aTWeKjoWfAJflcILOubI1roGsmgg5qEM6ZSdtv3luQ396tx+Y5xmLevJPcP8?=
 =?us-ascii?Q?VaMyGpAh1HagDVPoVOSfb99zUP3PNqwgnKMzgqNo?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?A5YGTbtey6ZXNtDEI7cPtOBG6WJTSbMIt0q31CoX4+FT2982gWSuYte+QOeP?=
 =?us-ascii?Q?9EFf1lWrWVqO48AnpXfzUc9XDiQay3tnZkGykrUDJrwzPVp8TFQVDR/3XUx0?=
 =?us-ascii?Q?LBa5fvMjAfMv8Pt6+sj88c1Cb9DZZSqPB0VYLcL3rIPN94yYOhGYtTtDtRbI?=
 =?us-ascii?Q?Od+w5+sMMlXjwglHXKgzoVOuCyQMqDte35Rc3mMWLp7dr4QhjjxXeB9PcKJt?=
 =?us-ascii?Q?2QfmI7Ijf5i8fRUzJuEAcAL2w+n/n1X0HtPxr/jzykfTozUW4zFVxbhz3Obv?=
 =?us-ascii?Q?KH8dMQ8ARO1CdL8QZ2+n68qz+SQE6x5ZCSWJVNmnB/L53IRtwCXqvVySB15q?=
 =?us-ascii?Q?qskmQEMsmErFKyy7zJE82Dw0G6Bm95rsnWQdtOPHlOvs3S0yXCXMphFumXPB?=
 =?us-ascii?Q?OzVK5uscVCG7ZVUl8MdFvozX4CNEVo8BMnNgRdFEdv745OylctCLLNDeEuip?=
 =?us-ascii?Q?bYFTCCtiX2ChFfMkEWf38gAxoDAWenJgQISWJzRXDTXkzbkxNY4UnT1JbgFe?=
 =?us-ascii?Q?3+kuZ2D1F7nC0no9Vr9GaQmo3HknGgxH8SJkQAMxuez48SLqHYTPDCnYqVK7?=
 =?us-ascii?Q?X5T5KbNmv5L4ZjB96G9b+7cKw57NFVfETOmsBnrUvZVaiR4bsG6/nhksRdCU?=
 =?us-ascii?Q?GNU6Q7vhcYfk7Nq9oFNrvPKwHHs4+U+y3r6xV2CHoayaRqnCUXTVfgDYe0OS?=
 =?us-ascii?Q?q6We4daDsnb3eNKtr1hRQz7hBBzCVVgpA1RX3dYKt4ijORwLTeYm/kbKsmVS?=
 =?us-ascii?Q?W/gGmYw9BDMqtSCkpYDOREHq2AteFtMGKOv0RhkU5xP8rtFOOEbnOMbvrtHA?=
 =?us-ascii?Q?QFwYxBHICPXJBl8jdYJTAOzmiG0V9hvhqnzNUVPOfTdiTq1fcexFSU9r9VGg?=
 =?us-ascii?Q?IHV/IOUz3yp2s1431100EvGrIUxxuMZFOY/XN4plc/dLdPdd2U3658CykLYR?=
 =?us-ascii?Q?zI+yyYNl95GMLjfq+qzGtSn+3qcLu9k/ZCFlFxhLHgYZd4TI+HsoicCQaJp8?=
 =?us-ascii?Q?gcht4+Cd6nz3sUdMmzFPMCH+v6LHwcASsTD3vjD+YwOfSm+buVsiu9j/uOB7?=
 =?us-ascii?Q?4ZTR3GWHya5WnAhwhKu5RyFbRDs9rm6Av8OvrJKiZI6Ym11NLTzQDIn29YxN?=
 =?us-ascii?Q?n0nItv+X+0AgdX050SoYJZuei7dSXmo9IUUfhhW75zuZLfqhyB9tlEYL3oaf?=
 =?us-ascii?Q?h2OH73IkfwvIoZEDRotgjVaoq6QCKCjMna6L+pkdcv+T2mflJgivhjQF0Ox/?=
 =?us-ascii?Q?zvGTb3B0XLCBEhOIb/Z2LkGPGrY8j8+DWCwwbhdUNYXF3FG4mZ3dzpM2T3Os?=
 =?us-ascii?Q?5zqN2Eiwwi/DaYxmSK4zTGpEB9njM0GdK1uGJyF11iNhZ5IvkiLe+uaVqEK6?=
 =?us-ascii?Q?tq3GpqiMVt/WVxiRE4NSayvp0YJ6OHLp37HxoPVOJSZO+jUps1lY2MTV1/uD?=
 =?us-ascii?Q?HSqbCKn3aHJ3K0rxTXnehF2/A52AU6ak+ow5QdtkiyeWYao+og1i7KEmZQWk?=
 =?us-ascii?Q?dKnLSaFhoXHcyVjT7N5iwzi2vYRlX0uKY4uhGvFbVwsMmsCHhvJ7GHaT8OGm?=
 =?us-ascii?Q?qkbrdQHsvT3/YVoRWZzeSl+/ckfcmBNHvoqSVRL++YyylenM0IekDABhenTx?=
 =?us-ascii?Q?g7vd8yiiJ7kWWjoDcYMuhFrvDHNqxTGpBAslMNkFfhMyU7Mc0OvhJNjtU8+/?=
 =?us-ascii?Q?ciGZqAp/MWhiCB1oWjwWBuBi5UWBdG+8gsGtzyBinEnIyDL3XZaRLUDeya8b?=
 =?us-ascii?Q?p7nG4lRoXbqUTLVh01FA8woKnH2bUBY=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 353599b4-bc51-4334-02a9-08de6815af96
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2026 19:59:08.4591
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ojaqy3hsNZfSDF5xlgfdtzBSGzccLcESBRliH+cw9gLsD2NNSgHfEbMXT1T9n7CV+svLfSVUtw6ptJw9nwU469TYkotJOdkbTU/JKI81CLw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB8098
X-OriginatorOrg: intel.com

On Mon, Feb 09, 2026 at 01:42:22PM -0600, Ira Weiny wrote:
> Alison Schofield wrote:
> > A user reports that when running daxctl they do not get a hint to
> > use sudo or root when an action fails. They provided this example:
> > 
> > 	libdaxctl: daxctl_dev_disable: dax0.0: failed to disable
> > 	dax0.0: disable failed: Device or resource busy
> > 	error reconfiguring devices: Device or resource busy
> 
> If the error returned is EACCES or EPERM why is strerror() printing the
> string for EBUSY?
> 
> This does not make sense.

That's what patch 1/2 is fixing.

Before patch 1/2, errno was used after close() which could modify errno.
The EACCES/EPERM was overwritten and the return error appears as EBUSY.  

Now, patch 1/2 preserves the errno so the real failure is reported, and
patch 2/2 adds a helpful hint when that preserved errno is a privilege
issue.

Better?

> 
> Ira
> 
> > 	reconfigured 0 devices
> > 
> > and noted that the message is misleading as the problem was a lack
> > of privileges, not a busy device.
> > 
> > Add a helpful hint when a sysfs open or write fails with EACCES or
> > EPERM, advising the user to run with root privileges or use sudo.
> > 
> > Only the log messages are affected and no functional behavior is
> > changed. To make the new hints visible without debug enabled, make
> > them error level instead of debug.
> > 
> > Reported-by: Joel C. Chang <joelcchangg@gmail.com>
> > Closes: https://lore.kernel.org/all/ZEJkI2i0GBmhtkI8@joel-gram-ubuntu/
> > Closes: https://github.com/pmem/ndctl/issues/237
> > Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> > ---
> >  util/sysfs.c | 31 ++++++++++++++++++++++++++-----
> >  1 file changed, 26 insertions(+), 5 deletions(-)
> > 
> > diff --git a/util/sysfs.c b/util/sysfs.c
> > index 5a12c639fe4d..e027e387c997 100644
> > --- a/util/sysfs.c
> > +++ b/util/sysfs.c
> > @@ -24,7 +24,14 @@ int __sysfs_read_attr(struct log_ctx *ctx, const char *path, char *buf)
> >  	int n, rc;
> >  
> >  	if (fd < 0) {
> > -		log_dbg(ctx, "failed to open %s: %s\n", path, strerror(errno));
> > +		if (errno == EACCES || errno == EPERM)
> > +			log_err(ctx, "failed to open %s: %s "
> > +				"hint: try running as root or using sudo\n",
> > +				path, strerror(errno));
> > +		else
> > +			log_dbg(ctx, "failed to open %s: %s\n",
> > +				path, strerror(errno));
> > +
> >  		return -errno;
> >  	}
> >  	n = read(fd, buf, SYSFS_ATTR_SIZE);
> > @@ -49,16 +56,30 @@ static int write_attr(struct log_ctx *ctx, const char *path,
> >  
> >  	if (fd < 0) {
> >  		rc = -errno;
> > -		log_dbg(ctx, "failed to open %s: %s\n", path, strerror(errno));
> > +		if (errno == EACCES || errno == EPERM)
> > +			log_err(ctx, "failed to open %s: %s "
> > +				"hint: try running as root or using sudo\n",
> > +				path, strerror(errno));
> > +		else
> > +			log_dbg(ctx, "failed to open %s: %s\n",
> > +				path, strerror(errno));
> >  		return rc;
> >  	}
> >  	n = write(fd, buf, len);
> >  	rc = -errno;
> >  	close(fd);
> >  	if (n < len) {
> > -		if (!quiet)
> > -			log_dbg(ctx, "failed to write %s to %s: %s\n", buf, path,
> > -					strerror(-rc));
> > +		if (quiet)
> > +			return rc;
> > +
> > +		if (rc == -EACCES || rc == -EPERM)
> > +			log_err(ctx, "failed to write %s to %s: %s "
> > +				"hint: try running as root or using sudo\n",
> > +				buf, path, strerror(-rc));
> > +		else
> > +			log_dbg(ctx, "failed to write %s to %s: %s\n",
> > +				buf, path, strerror(-rc));
> > +
> >  		return rc;
> >  	}
> >  	return 0;
> > -- 
> > 2.37.3
> > 
> > 
> 
> 

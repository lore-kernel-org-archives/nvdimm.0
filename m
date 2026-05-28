Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010052.outbound.protection.outlook.com [52.101.56.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A820830E851;
	Thu, 28 May 2026 19:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779996768; cv=fail; b=T1vfG2NELGpFfTJ71rN6AfPsUdJK5dhcVSaCHvfIfBRaqj6uuSpgU3NUyLh73UdLWMtVe9lcTJpa+L92hDgavI/WjCG0Gb2V/gJwbEksh91Vj5/CP/a5WnWnHbRo+H4EIwJFxx9NlK5TgxmlckktUEfaIHyqGktus8CVWO2fdks=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779996768; c=relaxed/simple;
	bh=NxvwHSGJ3aH5iwVeMfm3pThzlYb+TyQJCvRNPQVxOEo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=cfO5mx3+FaVdTKEB1Yg5pwlv+JGU5Ad0GkeWZ/CA9cnMNUzEtSTdf+16Mv5A39wxCfFSXV15T7rqMfW89uFagNFA/y4SnWcKAXsQOeKu28NrH59oPVM/L2raXTSCSwcG5VvkPuaBF/EJG68RoPgozb+sbGKkaQk6k2ngOacj/DY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=QXaqpxhi; arc=fail smtp.client-ip=52.101.56.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="QXaqpxhi"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MRnAQ5y07z0hha/Dkm7lND/g8/XYnY2uhQt/64pevGLtZKLNjHcHGLXZbPblbkvUAJd57vFs4QTtFneke7GX3ZoyY3yESDwF9bDorkswsupQapCxb5ZGX92UI7KDtGrt/kSwuqga3MHW5y7fGo1WNLVuJZxFS2GvxF4xeMjy/9f4Rl+p6jPwhevbPv1E65AhHQbHbnwWIFsdf+RXHJbaXFaAp4AHDm5RPI56Jammh7cMpJ/NDJOe+7RzRzoR7GlpUuSGI25WhNBfvuENIpe4FsttbHVd2Qxmylj9nS5NuwunOGVfBnaSy/eP+fSx6XOG/4zZlkreF7Qo9jSDieAOMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ygVZfTJNVdEC8o52zgtE1EZHxl1chXuWYMM2hW1iLkM=;
 b=EDEpKL1fZit4u7tGVg37EY/CK9atvGm8mG3JFumHdZslNroe9cDWg9zHcF3JAv4MnjnrfbE1sm/5GLixTzF1hXqVz8sD0joDo4dMdGnFjXJlRcjSPlbDtN7QY/UA9irArnjmuDpWWZpdNDM4sMN9zh16vCCS8yylWWjaY9jVHFYSbNBkldMrYEumuuVPwYrhoQPSTp6ymgHyFzSSuLu1pCu/RmCoDnpxKY/DuJvLISAIpZAM+OfIefN+akchs/WvvN2egMTCVwTGaJJoLz2SBpHkwqFeUcgg19tPFXTKJ+ioEndYt+LtkqLBlI6kTQq1ARjr5N+DknEFJrijVWOW4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ygVZfTJNVdEC8o52zgtE1EZHxl1chXuWYMM2hW1iLkM=;
 b=QXaqpxhi88gITiyll36MhPNqsFD+H+G9xL23t46cWaaV4lOr34nBcOqC2JHRSNlFoB9m/Z+i9qOlq9d1d4Q+M6Hgdo3dZBcY8FuBCgso0UvLXZTWFc1hYZNap1NzGHJXgfdxWMfrkwE6QGUEVFUyGgTXu6yTZr/QlfSrqZ5R1MdbE94Oxgih4+/8PWw/AvP+m7zqv0qUtfAai5SNVzsSVFhqaD06s7Yq8MFPIgb08Hk5zUhv21PFXhbF1dX0L0lTI6iQUC/ucci/mrVZWECffwkhf+whOw7rsYUioPz1pIaOY0YBmHNgSZgt5oF1cA3Vy6a5thLioVnRwDl+d45BNA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV3PR12MB9356.namprd12.prod.outlook.com (2603:10b6:408:20c::21)
 by SJ5PPF0529573EF.namprd12.prod.outlook.com (2603:10b6:a0f:fc02::987) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.11; Thu, 28 May
 2026 19:32:37 +0000
Received: from LV3PR12MB9356.namprd12.prod.outlook.com
 ([fe80::1c36:31b4:c420:6286]) by LV3PR12MB9356.namprd12.prod.outlook.com
 ([fe80::1c36:31b4:c420:6286%5]) with mapi id 15.21.0071.011; Thu, 28 May 2026
 19:32:37 +0000
Date: Thu, 28 May 2026 15:32:34 -0400
From: Yury Norov <ynorov@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Russell King <linux@armlinux.org.uk>, Frank Li <Frank.Li@nxp.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Pengutronix Kernel Team <kernel@pengutronix.de>,
	Fabio Estevam <festevam@gmail.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	James Clark <james.clark@linaro.org>,
	Thomas Gleixner <tglx@kernel.org>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Len Brown <lenb@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Chanwoo Choi <cw00.choi@samsung.com>,
	MyungJoo Ham <myungjoo.ham@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Xu Yilun <yilun.xu@intel.com>, Tom Rix <trix@redhat.com>,
	Moritz Fischer <mdf@kernel.org>,
	Yicong Yang <yangyicong@hisilicon.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
	Dan Williams <djbw@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Will Deacon <will@kernel.org>,
	Jiucheng Xu <jiucheng.xu@amlogic.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Kevin Hilman <khilman@baylibre.com>,
	Jerome Brunet <jbrunet@baylibre.com>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Jing Zhang <renyu.zj@linux.alibaba.com>,
	Xu Yang <xu.yang_2@nxp.com>, Linu Cherian <lcherian@marvell.com>,
	Gowthami Thiagarajan <gthiagarajan@marvell.com>,
	Ji Sheng Teoh <jisheng.teoh@starfivetech.com>,
	Khuong Dinh <khuong@os.amperecomputing.com>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Zhang Rui <rui.zhang@intel.com>, Lukasz Luba <lukasz.luba@arm.com>,
	Yury Norov <yury.norov@gmail.com>, Kees Cook <kees@kernel.org>,
	Thomas =?iso-8859-1?Q?Wei=DFschuh?= <thomas.weissschuh@linutronix.de>,
	Aboorva Devarajan <aboorvad@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Ilkka Koskinen <ilkka@os.amperecomputing.com>,
	Besar Wicaksono <bwicaksono@nvidia.com>, Ma Ke <make24@iscas.ac.cn>,
	Chengwen Feng <fengchengwen@huawei.com>,
	linux-arm-kernel@lists.infradead.org, imx@lists.linux.dev,
	linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-perf-users@vger.kernel.org, linux-acpi@vger.kernel.org,
	driver-core@lists.linux.dev, linux-pm@vger.kernel.org,
	linux-rockchip@lists.infradead.org, linux-fpga@vger.kernel.org,
	linux-rdma@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-pci@vger.kernel.org, linux-amlogic@lists.infradead.org,
	linux-cxl@vger.kernel.org, linux-arm-msm@vger.kernel.org,
	Roman Gushchin <roman.gushchin@linux.dev>
Subject: Re: [PATCH 00/16] lib/cpumask: get rid of cpumap_print_to_pagebuf()
Message-ID: <ahiYUr0dO_dhOHTU@yury>
References: <20260528183625.870813-1-ynorov@nvidia.com>
 <20260528121806.2b54606ba6e42f7f371d95c3@linux-foundation.org>
 <ahiW5LKLiPMC6il_@yury>
 <20260528122903.cf74cf905418ab2d144607c3@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260528122903.cf74cf905418ab2d144607c3@linux-foundation.org>
X-ClientProxiedBy: SJ0PR03CA0370.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::15) To LV3PR12MB9356.namprd12.prod.outlook.com
 (2603:10b6:408:20c::21)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR12MB9356:EE_|SJ5PPF0529573EF:EE_
X-MS-Office365-Filtering-Correlation-Id: 61bb2793-716a-4f96-69dd-08debcefdfba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|10070799003|1800799024|376014|7416014|6133799003|4143699003|11063799006|22082099003|18002099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	aB3fOsvsIOSdJuS55RwzVjLS+Sxb/afgy/4K3quzyli3uPOKErvP28rvvrehNjVB4vwUsuXu8wwjJM+7seKMzQ8xLx0rFxDI82Bkx9C75LT6rh+GzvK1K4KRmoSzGtSon+bOzWzGm0q+M5r8CWcp7NrWINGyT7PHI05zIRXlcWXkhbYZ+d83+sbGIL1Ym00Af7GybCXmQe0DoqYe6wTgptWjwAfznGW+GX4DGw6lv9QKge70dagt9jbfs04SG/BoxvC5dAdn3UBNu5j62v+3DUXJRqCvRriiLGwd/PWUBHiMorlcDFb+7/7RhdV8HUMYIpqSGNzodu9WLVgGwz7k1LvE1/K0pY+mdwoo1r3VNO9ohdmG3Ywqdaj0+uNQh7DXPT8hcr8zl/qb7ZJxQW50DWsmyiuA81X5gV8ks90Ke1qnEOC9MOwTsvRpjpikg2yYaEZ/xR+cPis6k+un9aEWaQXKfZwHv6AkP/hfx/1e4MS8qaJYmnT+L5FpSmCIiS7OrlsJ2pbtnEVbUznokIbaqtJPGlkUcLVu2Z/TKL/VoD7E1iLvHK/o3bkXLGGFS52yUjtr0nmwJ4dXm3i5o4a/bgiSaOmg42638vxM/AN2rI15ttCz7f8IWBeB+pFaZBB813lpJxHaro71jZNUZSlMFSL4cw9vc46ST5lcfFNCSnYxutdChdjaJEuOLpKKQIsO
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9356.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(10070799003)(1800799024)(376014)(7416014)(6133799003)(4143699003)(11063799006)(22082099003)(18002099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?sGTXoPgB3t7R/QPdcIbrUbj1p/tfA4NDaXY4OsjD9DcemzivTRST54VZkiqQ?=
 =?us-ascii?Q?9sWADhPBftVHw0jqcOTFlVejiir7vXsZJNVFBUAvD4gWKLC0E9bsD7tC7ynH?=
 =?us-ascii?Q?xLgjcqO9pIe7NHO+ekh1QxV97a1m0AYP0XT3Hyf4xleJNN2Hzw56+e5qCkQh?=
 =?us-ascii?Q?kmTz4IOhT4uwtuRMRPIIJFE6dH9RWhdaM5fTP+rgPuy3Z601mtsi+0unIZKB?=
 =?us-ascii?Q?ae8/gKXlTP/c3Y2xSp2GYq2cL9e/MVfyKpCvjH2FM8GuwN4Q/IoaaMor4pGz?=
 =?us-ascii?Q?Rr4ruAPq6Gi10H0r8b//Csgqk9tM+SQEFnSlqf//Q8YnwyR3FTHK4YVMFjX3?=
 =?us-ascii?Q?bbLFw8Z/lDla2WTM4ojhI9jczjRTBbs90+/DoYI/YZldO4ofrYAvDZJE/4ac?=
 =?us-ascii?Q?/ooiWD9MVyHvBVbSusI4U5UBGvlaQVp27KH6amFd336QXD2eqNoeVRvF/lr0?=
 =?us-ascii?Q?2PoKQrvUp4Uoj8206JIc+WsK7FppUAGm52/2sTmU+XjfntRnrJRug14vT5cW?=
 =?us-ascii?Q?SgXVWb6gMb3he2RkLMdkkShdLUlrsyS+0eBBXa66G9paacjGZ7V6r3HeEjAz?=
 =?us-ascii?Q?0Sy2r1iia/1gR+9lToJuO69dswXLDxbVj+dxgvmBD+GbAtZ2AJfQRarE2rNy?=
 =?us-ascii?Q?3U5PX3AE5yOUbYHG0cXyeW3jv4X+6OJHzxbqYk6tAnhGCWX7XHIEmO/1Exe9?=
 =?us-ascii?Q?PKh/BL+kdeyR8skJDo0jPt6NX21Lm60e+4TxE0xK1rB54CO64avKao5GEddD?=
 =?us-ascii?Q?/YvMi612wfjWMpEDJaWYyqDcE3Gx0ISLYPhvXDevUEW42pSBZDeg3hEneXzj?=
 =?us-ascii?Q?ZwM+B5UVeIoXmVse6eKUvY+ISsAP/rcVONduhre13B4j2bZmU3ZH/6KJ0PFn?=
 =?us-ascii?Q?I+fXvMU7l/qVjPoKf6Bo5IwMP4T5rxlQrjOtc8R8NmsGSK8Oy7KFgc6JDbj1?=
 =?us-ascii?Q?gA72Ix2lpbEnLIEYO3nQVbnHE6fUrrPiMeliWJtIPWfrcu64oUbD10cYIsUm?=
 =?us-ascii?Q?TV3fu+d+92vNEHSYGsjbT98HvORsSEu2QkX1XeFiADMJZ8sk8xVjMHPMA2g2?=
 =?us-ascii?Q?gejQTA3BQKs5RExypHc8LT1MPOXg02UoqxD0lHKTExUOxy9t7g8f96yEJUtB?=
 =?us-ascii?Q?O39jm+KAqdfWzEhhm6l3tdxMwuc8V5ueSTt0EVD1m5Fbl8EGCADDk01QVFTR?=
 =?us-ascii?Q?788prhoBr4f5HnfO2LQxg/z2Z2stRdlKyW7RimDTebQQh1HkcPD+rLK+LN6p?=
 =?us-ascii?Q?+ohb5vSLuoO6pw+/P6vT22+3BfsRTdPfsOAvtdB7x3vp4UeVKwwpHD62yBzy?=
 =?us-ascii?Q?WBTv/gdoWF6Q+QLOPA13gVK+o/teP3pkHlSnCLLrpacsxN69xEBjAH7ZuJE/?=
 =?us-ascii?Q?KNQ8HS6pudSoJwFhJRO8MyjcsH2n93LniNne3XG0+5oUQTQrAYVU4VswhCOk?=
 =?us-ascii?Q?dvlgfe062gzIyxgBYkwMuXGnyPD/iNZyfg0M6F/g1t0dRMXoqInvdPmUd6Bj?=
 =?us-ascii?Q?rfIx5KVHG+7anDsajQbmB6OYhefLHO4t6hE1SeEyaAG6u/CIVKnVljSYnVpE?=
 =?us-ascii?Q?5FssblD90uCHTfbc7E/Xk99nC9RpYbz3YEwkHDjjdt3AudaFvbjhUnY2/T1z?=
 =?us-ascii?Q?Ok18XwA9/T5FBDpfTBaZpbY+IXjDpPDRRBokhPbsu4kQzsFaWDJd89g+zq6k?=
 =?us-ascii?Q?6sTKM6F1BHgBiyBF0PUv77MIgDTU3DJ3o3l44vPV9snG2ZNsDxjyLEk0+a62?=
 =?us-ascii?Q?WYHO3G3xXUETyAvDJsuEd/qICRwSAN5c/5GjFSdZshZ9uzYZHNga?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61bb2793-716a-4f96-69dd-08debcefdfba
X-MS-Exchange-CrossTenant-AuthSource: LV3PR12MB9356.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2026 19:32:37.1638
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fiqOx4P4xWlP+tiIWAzEIU4V49r8LPe9cm9Mf1JpLnll3IA2orGq9cBapV+AQ/pPSwfjqGH10ULWhNuUsHIRVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF0529573EF

On Thu, May 28, 2026 at 12:29:03PM -0700, Andrew Morton wrote:
> On Thu, 28 May 2026 15:26:28 -0400 Yury Norov <ynorov@nvidia.com> wrote:
> 
> > On Thu, May 28, 2026 at 12:18:06PM -0700, Andrew Morton wrote:
> > > On Thu, 28 May 2026 14:36:07 -0400 Yury Norov <ynorov@nvidia.com> wrote:
> > > 
> > > > cpumap_print_to_pagebuf() is the equivalent for the "&*pb[l]" notation
> > > > in printk-like functions. In some cases, it makes people to create
> > > > temporary buffers for the printed cpumasks, where it can be avoided.
> > > > 
> > > > Get rid of it in a favor of more standard printing API.
> > > > 
> > > > Each patch, except for the last one, is independent and may be moved with
> > > > the corresponding subsystem. Or I can take it in bitmap-for-next, at
> > > > maintainers' discretion.
> > > > 
> > > > On top of bitmap-for-next.
> > > 
> > > Sashiko doesn't attempt bitmap-for-next, so it couldn't apply this series.
> > > 	https://sashiko.dev/#/patchset/20260528183625.870813-1-ynorov@nvidia.com
> > 
> > OK... What should I do about that?
> 
> Rebase onto something which Sashiko *does* attempt.  Mainline, a few
> mm.git branches.  Maybe linux-next.

Is Sashiko a new mandatory requirement now? Documentation doesn't even
mention the bot.
 
> Roman, is there a list of trees/branches which Sashiko tries to apply
> series to?

Hi Roman,

Can you add bitmap-for-next in the list?

Thanks,
Yury

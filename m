Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011040.outbound.protection.outlook.com [52.101.57.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E743F423A63;
	Thu, 28 May 2026 18:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.57.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779993422; cv=fail; b=tL0uDS4jcqwrGSTqqVscCSaN8RPxeW1f/bg0HbQ3prSLMo8dMz6XmsPy6G/Jh49vBmF8W6n9itncve8/SQPObW3qpoSobnMA+HMb3fuOQlEm3b/0EfkhyEma4Zals72eLEjAq1x5kOB8jP78G5VO78BU0TZn++IRe4qVjy9N0Gw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779993422; c=relaxed/simple;
	bh=vsHtoNGSdaqnET2ha0Qu7Qk8LtvS2ad4wNcjijxTZnk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=nRmCPGQqhaL3X3Sugkr5XML0Ka5J4sLtMPPsHWEGzriqpcGSNJm170DF7YHikRW4rk14uRcRUHDcnpThnWdHTvzxLukTHOcs6vWyCxUK3Vf4h5ksVAfvJHbQ6pJvGVT+9nfv+yKLWbMZN8B6UIfYJRYMceYQSERPLOm1vuKMoMo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Pghm0NVa; arc=fail smtp.client-ip=52.101.57.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Pghm0NVa"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=a+cRXEV7aWMQeFdLfTpZzJqfY7/NIJrqYIQ0YfPO5s9IStOgtlC00IiZwkRxTqQQRjWlHRuBqxfGdGZUd0p0UJ3Z1KuY8aqLqHCrz6tWgC6GuurRYeu6hGbhpmoz/cQdX4k+arWjw6h1ancCQYeZ0aS/qHeUz/NWdM3bsoBk7GFavMrNtCPBH0F4fq3XvbUlfShDjVyBSMEuRcw+bVynC3j7XMOx/jJEVWpIRu58wOCVb2l5wXwjCIpxQStzjFrngntYCyIa1KaY6jm276EKiAUnrgS0Azkc3OqpxCt6pN0CHXRHvLXeQLyF1XvNp94GnQjuIHfKbfLYLrQUQlgX6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WGe7IKfwp9W5qSVzj7vwb3ArcHnydyL4ARfcjc6CFx8=;
 b=Ek8ucuXGOLYZtl8W6AihhemlFOe0aExbbLzCcKhhAwC+Ez0hdIMjyo2d6OUvn7jwGUKgNTUR6ILVXnfxDAEb06rUJ5gresFT+tevFTa56TjANcWSZclVBeavfD+yIgZPBA7kgIN/1AD/5lcqxZ2g3hAgx66oR+PT1hU5htrgf10MCRA5SSNWT/YGFeIZB7N/kem9tbXnS/PylCvk+MF95vOqT4P+8LQnRR/TyoFVNOewBR9XIo7qhedFVdpHbSrL3/4PzJDTkcfDUXWyh9XgcPXY6gyYWYgFyNXKFJp5FkYlJHq6GmGWg4yUMcb5iSLY4MljNlV+PIyV+Gd272xkJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WGe7IKfwp9W5qSVzj7vwb3ArcHnydyL4ARfcjc6CFx8=;
 b=Pghm0NVa4wut97XHEchZx8XLKl2mSw9mNRtqRhtXxRGbdxuVhD2ZuoKaEaN2Z54qdwWyDkJAx4nqvDuzizVrji2etAUyOw36mb2Vre0HOZtVERZ7N3PnsUngzdRe5CknMObP8Qq6r0u7qKvfd/QJR135ofJYhEJU+iEoUGKaoRRvbtTV0A5if/4uPGc3lgAH4+5XeCUA/TAjX54nJFiRYpixcT+G8cA5eotdi+YkDuX7ZeTvqh4DYtGjvANpMgAN4PoIDXq/azGKOQy8pyiM2ycbYMmupB+XncospowjmhtIx3YChkxwx7j6T1eV9uzDhiZ7TgDI1iNggpO3+0K+5w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV3PR12MB9356.namprd12.prod.outlook.com (2603:10b6:408:20c::21)
 by SA3PR12MB9228.namprd12.prod.outlook.com (2603:10b6:806:39c::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.13; Thu, 28 May
 2026 18:36:50 +0000
Received: from LV3PR12MB9356.namprd12.prod.outlook.com
 ([fe80::1c36:31b4:c420:6286]) by LV3PR12MB9356.namprd12.prod.outlook.com
 ([fe80::1c36:31b4:c420:6286%5]) with mapi id 15.21.0071.011; Thu, 28 May 2026
 18:36:50 +0000
From: Yury Norov <ynorov@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Yury Norov <ynorov@nvidia.com>
Cc: Russell King <linux@armlinux.org.uk>,
	Frank Li <Frank.Li@nxp.com>,
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
	Jiri Olsa <jolsa@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	James Clark <james.clark@linaro.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
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
	Xu Yilun <yilun.xu@intel.com>,
	Tom Rix <trix@redhat.com>,
	Moritz Fischer <mdf@kernel.org>,
	Yicong Yang <yangyicong@hisilicon.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Dan Williams <djbw@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
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
	Xu Yang <xu.yang_2@nxp.com>,
	Linu Cherian <lcherian@marvell.com>,
	Gowthami Thiagarajan <gthiagarajan@marvell.com>,
	Ji Sheng Teoh <jisheng.teoh@starfivetech.com>,
	Khuong Dinh <khuong@os.amperecomputing.com>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Zhang Rui <rui.zhang@intel.com>,
	Lukasz Luba <lukasz.luba@arm.com>,
	Yury Norov <yury.norov@gmail.com>,
	Kees Cook <kees@kernel.org>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Aboorva Devarajan <aboorvad@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Ilkka Koskinen <ilkka@os.amperecomputing.com>,
	Besar Wicaksono <bwicaksono@nvidia.com>,
	Ma Ke <make24@iscas.ac.cn>,
	Chengwen Feng <fengchengwen@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	imx@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-perf-users@vger.kernel.org,
	linux-acpi@vger.kernel.org,
	driver-core@lists.linux.dev,
	linux-pm@vger.kernel.org,
	linux-rockchip@lists.infradead.org,
	linux-fpga@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-pci@vger.kernel.org,
	linux-amlogic@lists.infradead.org,
	linux-cxl@vger.kernel.org,
	linux-arm-msm@vger.kernel.org
Subject: [PATCH 06/16] cpu: Use sysfs_emit() for cpumask show callback
Date: Thu, 28 May 2026 14:36:13 -0400
Message-ID: <20260528183625.870813-7-ynorov@nvidia.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260528183625.870813-1-ynorov@nvidia.com>
References: <20260528183625.870813-1-ynorov@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0194.namprd13.prod.outlook.com
 (2603:10b6:a03:2c3::19) To LV3PR12MB9356.namprd12.prod.outlook.com
 (2603:10b6:408:20c::21)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR12MB9356:EE_|SA3PR12MB9228:EE_
X-MS-Office365-Filtering-Correlation-Id: df6c0244-3be1-47d3-090f-08debce814b2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|10070799003|366016|18002099003|11063799006|6133799003|56012099006|22082099003;
X-Microsoft-Antispam-Message-Info:
	wKFtLv/sGYeQd6JdtFR1qmGz2KNFcFwBX79Ztyk4rKQOEknG5gZOs9sqlZhpc7ZwI5Li5FEoqVOqPQhOCPCDNunhwwecjkD1hHqzOb15vhKBZOYT9ZNox3lZUC5o3/Cy4nWW4GUjTqVSukBBIVe2ZZ3PR4w9UH1JQa0RyxPVgtAF+3oFg99JZ4Ub+4GzOL7kPDTivbuoAhsDfeb6+4UtXmqdYMYUlzJghAtQ1FgJQ8eihQ5hiGDhR4OQReSgrNo1kPwB8I85dAtAJYEpyI1IIwGFuchzcqjjmtoOW1f3c+kmXAscrKMDZiCQ2NOYXsKCft+1/DAlZ3kOADNuwppoQ2leghDezJusWfCJKiXL9GXl6RQH/E+pAzTgArwwfTQne83GcT/dODGuEVKu3aXASKy+XgA5MbsAlTZY7Wim9mepRJtSXRb+GDovfAfBIbKqDykGD8G1KFoPFGn2RkCameRl4MmRWjr0JRWLW5oIzcHGZTm/M0pH0RJjRMw9/OytsgwhuW01cBpxxougsdjT80S0/2d+uQygjH09TsmMTl/jRzfv264KgcR/73GJC3fevNX/CG5gXp9ByTrsw1YIxS/gY57wlD2pSqzliJaACxyfh7FEObkcBE8jc3NKMEP8hHyJDGEgk3+ep7zbIkNdoDU8noexYWHdIaVXN5IgzSBZMCRdErNeEKunLxHRJI4P
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9356.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(10070799003)(366016)(18002099003)(11063799006)(6133799003)(56012099006)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?dNuYm+nB0SWM+RihakdZlKWtI+i0/VTSkpiqKtMTNTdRTEPKwb64HdqLfb2q?=
 =?us-ascii?Q?vHnKgE7v9GRs7PivcPA6p8ZZ2bCM5fefbAG39ZnlQphr2iUI6DO8NsRdWfR3?=
 =?us-ascii?Q?o5JXb9Syx4HyA02gRBSREqW5OiVIc8Hd55eIOvX+0vZY+YmFLGD+obSP6ZqR?=
 =?us-ascii?Q?dPem9WV0Ve61bTpywFFvRCkrFVy12EzBxTNx1z0MhSjXHBkSOf/jHXGb9Fz0?=
 =?us-ascii?Q?eClMhzuP5v7FzR3CQ+YTDPFu2cZMGow4FCPkL+ATZ1vAnN0CixomtwfziDx0?=
 =?us-ascii?Q?74R2KMdmPk8X5UMTjFZymR9ricx8N5rnJBFSZERUwxS2hPY/hPP5HFqmYroA?=
 =?us-ascii?Q?tfBMpAsGiwAEwVtepte7FDwcFC+dpQCEq5DWLH79SrxlHryImC0PPIOOPwne?=
 =?us-ascii?Q?5Di6TkmVYqZnBU0xZM4ao6uNOPRlrP5J0wmSvFD9aqshC2Fcpj7eHuZX8THl?=
 =?us-ascii?Q?/m/Ys8LRb8dHFBqNddZGqwkn9jm8mwaf31HZPs3AoaMhPnrFvwXUserpG4W9?=
 =?us-ascii?Q?2YwMHE92GIcM6Ss+hbwoQ5Jz7hzcVUJEdIgPtGnVsX3E3tYM1bDMmts3rTw4?=
 =?us-ascii?Q?CUemj9ODE5jy77jDmhp/wBSsqyv7PwwFeaeojz7qn09LuOl/DeQgvztVlFQe?=
 =?us-ascii?Q?KzrAJXvPgdDWzR7ibOzfPWFYrh9gN8UWFssDCwrFaaBWYW0w3KwVCG+1NpU/?=
 =?us-ascii?Q?Ainw2t0u/KsIBuRr8Wc+S590s/Sbv/oAsWNvKe7937wjLsvmUraVPuqoM/eH?=
 =?us-ascii?Q?uNbFWO3SN10yPXDDOL7jr7xPN+AnvRxtQAjpq8WFyUfQODPt0011nyvzvDLG?=
 =?us-ascii?Q?nMF+W1RcSZOcMED5rBZTg90pX1VxAeSERaHWxw3AFv4A50Noe7YPlRXvbMzn?=
 =?us-ascii?Q?bWXLBGIiY1VNEHdK1aOg4ZRGqeDj+RfvBZr6QkSx9KTAQDM92BRvXKQGEVWs?=
 =?us-ascii?Q?Cjfvmn3J5b3dwMuIkCAgIj6WOJPE9Xm3zTdUVevUJhqiE10BNG+ZU8eK/USh?=
 =?us-ascii?Q?ES3mHRqzc1maClQFidVPDMi0hTRgj0M64+hDOA05ykt9BGnC+trXtKNAghtC?=
 =?us-ascii?Q?UOPKheM0C3h1i+heHN8yDwunBOiSDXxsA8tB8gWrQluQqnBrBvrk6beYnssN?=
 =?us-ascii?Q?M5hUgNw/zPP3fKWxqZV0f31/8GhQpIefwpBHClau7+YFiUU8haqe2H5BbHIm?=
 =?us-ascii?Q?OqlO3HQ39Ua8/yuIE2Go3o2EJFWPojh9XqLuUpywEwT8ZbKqyyA6OsnYR/r5?=
 =?us-ascii?Q?XOiJJoNeQaa74fx91j7Y0kTKaerqqiStXtr8UuX/PbvYOWXoI3t97pSkCHLa?=
 =?us-ascii?Q?Mh6KY5zCzP9bt7sNLFlB/cGTDu+m9yxQzd04bNe9/SSAGl1FYiPXQobQAxmo?=
 =?us-ascii?Q?uQEYkbhq8Z36okPR8J4J8EHL7VUeQ+sWb+18ncLvnaT+UFoV+z1fgD+v70Oe?=
 =?us-ascii?Q?n5Eko6jNjYd9hMpPez6vt4LR3O1EjG6K6bU0zHi4VXGE4hc50gd4th/dMi9P?=
 =?us-ascii?Q?sT/FoBlAAgSC+UCL5HJcP0/3QFlw/wWtBRui/E+b7D34zXdUQ6vMN5q6sfy7?=
 =?us-ascii?Q?9kfjwn5OLjUDFGCtIn8exCdW7fD6xuU9aL2ChKZJNrtS4hZqTKwxnitbPrF8?=
 =?us-ascii?Q?fQklP+Qg0I0Ak21+GPMR9kN6BijzA3lQaJ1inSVU2eF0fgxsgL7K9AkpTzn9?=
 =?us-ascii?Q?KpwalI/qc4N31wft7PhOoqRTqSzBS7Eccsma/U/DnG3KhiihVGpssfgPAJo2?=
 =?us-ascii?Q?npH9y0d0Hc8V3xKS5iABmyxaQrwD/i3WlhwRF2vb7VCjQYozNDsk?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df6c0244-3be1-47d3-090f-08debce814b2
X-MS-Exchange-CrossTenant-AuthSource: LV3PR12MB9356.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2026 18:36:50.0228
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UxuuRUdalv9GA5iOVOT848zK7Bkg/7ieFVBAi6epSBChdHpoOuYMfdoFoZiCrTor0Z7XL5r6d/8M+9cTVoOEuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB9228

show_cpus_attr() is a sysfs show callback. Use sysfs_emit() and
cpumask_pr_args() to emit the mask.

This prepares for removing cpumap_print_to_pagebuf().

Signed-off-by: Yury Norov <ynorov@nvidia.com>
---
 drivers/base/cpu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index 875abdc9942e..2ebc4e87ed9f 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -218,7 +218,7 @@ static ssize_t show_cpus_attr(struct device *dev,
 {
 	struct cpu_attr *ca = container_of(attr, struct cpu_attr, attr);
 
-	return cpumap_print_to_pagebuf(true, buf, ca->map);
+	return sysfs_emit(buf, "%*pbl\n", cpumask_pr_args(ca->map));
 }
 
 #define _CPU_ATTR(name, map) \
-- 
2.51.0


Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010001.outbound.protection.outlook.com [52.101.201.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16CBC19CD1D
	for <nvdimm@lists.linux.dev>; Fri, 12 Jun 2026 02:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781233011; cv=fail; b=EODH9zT1k3IFG/C1bci3kNKPLoM5CW1wN5tXxo52ClE4AwzKt+1pLDgTKz5QZ6C92B6UXsFUP9081gmFaTcisVho6XWRnGrfoNr4Go0cFyEwKGgdWL68rGMAoHirFU0XK8LZj/L1j4g08CjsHsspRH0JM93un2obV/TcWKTyGl8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781233011; c=relaxed/simple;
	bh=7hD/lUkhzNuW/altscwOX6p5/Zt4vAenCK8a27lBcKk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=b9xHhj7zlUHZN0qjqDcel5eVaCopT5pjUqjkhjeQij5DPQ8sP63I/lBUDElFMzt0LzzSebkdel5G4dfSGg3qgxoXVHSipxLOhkOQo/d3eJ0lE2npqgf0KtjKWpYDwa9KEKmi64r4OCYfoMRZvxx4URddB3plgLmZ02uCXLOhuO0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=MKFVCaL9; arc=fail smtp.client-ip=52.101.201.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="MKFVCaL9"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KLFcX4hyeV/kyCPRshQ7TyU7a6MZsFyDvCw+4Rd9XHOzVzHmGRLD4EfKJ7mv4JxHSgZ/rU8Wstj0fokQsNciN9OHjrQEMKh3tPewkpYBhfXZzU7hHmcnJzE8W+kDWmyaqzHszBDyxEQ4mclU6F8Bo/q2EB068OKnOQrtXsT0gRHooZKnx3cpPJww0gz27wJcre3b68sgmrl101O9EpVfhh5GEt0VX6SOp/YEgBD0Q+AvleBjZQ6JSUqPnsK431nXrf9sQcbm2X4V24dhdj0myfyqVnaCHE7FJ6HhpikUunlbb8J9yfuGA+SzaIThT3ogbMuQ1ef7BVIZ+FOJfKMENg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vAyM1sYLCWfhxvWTgopkYK//1g9VAjFJ1ms1+56x4hU=;
 b=CARCBEOBkE9GewDLwz2t1ZMPB+N+MZfvmQRQwj2lB8x5JEu2/6NjxuhkdlLu0IRcWAhI0UXmY8JvLF14O1iYf9oTJgmAawv1TecHAgWOCfkb7BJTvXKrecNk9tQluiOSE00/yyh0f6ybI4Oc6E3E9m/ki15f7FnlHclhdO/aB0k5R2koz71Rs2jcsqq0Wa7nCF8W0pPXLTc+CKnug4EMCDsB1Agily1yVl+eHJj6Y2o+dgh+SwLMpNsm16D6Me0T+fUF8MsRRqdC00yKfYzmAwDzYOOtrfR2yOKCh1MvFf5uDkvf1cLz5eR8GA9Nf7m/eH1Gdxime/lq/adaengc2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vAyM1sYLCWfhxvWTgopkYK//1g9VAjFJ1ms1+56x4hU=;
 b=MKFVCaL9F7/Q2oauB3Z86Q95AZjX5IF++YIQvpWX9LpjHgg8kGBzSt4GK2ZnueVOHTpsPxTT4njiWaAJt90sobQvALzEL9jXQGOLz3ruS2Zgw4W+rPuTM4v8A/IlQzSLW51A/TZyLEbTLy5Hq2ujJP3armPAtZrju8NScFxdgHX9focNBJrGWqKuhzHn+AKyzxshOULsPq+JHZPD4qFJ+ozDurfalqFrQXt/NLlYMuSdxXqQ6UFqs+zqCw8ScQYBL90FGlc0k6AxGDFG4v5ZRljxiQ32LgwJq/yl/cbID8t8u5KFQs2278AfvBdRmQpsCz7j1Buwa63ubFyfD25Rkg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB2370.namprd12.prod.outlook.com (2603:10b6:207:47::27)
 by SJ1PR12MB6315.namprd12.prod.outlook.com (2603:10b6:a03:456::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.17; Fri, 12 Jun
 2026 02:56:44 +0000
Received: from BL0PR12MB2370.namprd12.prod.outlook.com
 ([fe80::86cf:c3ec:2cf5:74c8]) by BL0PR12MB2370.namprd12.prod.outlook.com
 ([fe80::86cf:c3ec:2cf5:74c8%5]) with mapi id 15.21.0113.013; Fri, 12 Jun 2026
 02:56:44 +0000
Date: Fri, 12 Jun 2026 10:56:37 +0800
From: Richard Cheng <icheng@nvidia.com>
To: John Groves <john@jagalactic.com>
Cc: John Groves <John@groves.net>, Dan Williams <djbw@kernel.org>, 
	John Groves <jgroves@micron.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Miklos Szeredi <miklos@szeredi.hu>, Alison Schofield <alison.schofield@intel.com>, 
	Ira Weiny <iweiny@kernel.org>, Jonathan Cameron <jic23@kernel.org>, 
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH V5 3/9] dax/fsdev: clear vmemmap_shift when binding
 static pgmap
Message-ID: <ait0jiPmYrpwdEBW@MWDK4CY14F>
References: <0100019eb7bcda4b-3f8edae9-d7a4-4bfa-aaea-fcef77fdbbc3-000000@email.amazonses.com>
 <20260611173202.65935-1-john@jagalactic.com>
 <0100019eb7bdc5a7-f15b011c-0aee-411f-8d7c-2996345048e4-000000@email.amazonses.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0100019eb7bdc5a7-f15b011c-0aee-411f-8d7c-2996345048e4-000000@email.amazonses.com>
X-ClientProxiedBy: SI2PR01CA0030.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::15) To BL0PR12MB2370.namprd12.prod.outlook.com
 (2603:10b6:207:47::27)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR12MB2370:EE_|SJ1PR12MB6315:EE_
X-MS-Office365-Filtering-Correlation-Id: 2384406c-926b-4439-bc04-08dec82e3c3e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|366016|376014|23010399003|18002099003|22082099003|4143699003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	kv9c4uKb6TZqhBpvZXtsO4tsVVecdfos6432pPKScpYmjtr5bzE0U9B+vJmYcVDDDiVcbXz62QUGOv26YbfkjB3bC9PdgG/AmV5NjKM1Wgn2mjIRJGIsV0s2bmQO+cH7SItYDk89iTfdeKwAiQX5bfGl3CroMgdLdgQY5ZArFz0++hc9T+EeGig5W5AaJYTUGRHKPrpjKAOzwEtAm3Pq40RW86WRqpLTF5pPXTfm6+XapptzbDeipp3dIEGrmA2G1qztF4xbL4pZbY/Rbt5L+o9e6tGeXdsZbIJ5dGF/GZAwLfEeq33KBeftdMPG+6HY2W6CQZZyoSKwFkeWt3qPMb27ZAzIiM08KJ/USuT2NiNwDWQW1NzxCmMjBZnrhUxRvUT0Uzdx6R4SMkQo7l63d91MtuuP2D2gdpDWFsOm9OoIvD6QV6+N5PAiiV9S+Ka5iXXCgivOb769BsHETJB4ezTLYN/gNWzseRYaeDzn/6DpgyyX1Y8Fpm3yNEbrxj0f/ZW0fQ+GBipmLzLFSVY/jaL3yM+331cfO09T25BlZzuVDrrY+DYbxfq5LsHWkAoaL+EKANHrao/QG13rx32JZDgdFZMHaZAjqa8AK2pUozBO9iCOkfQ+7z+4P43lylY2Sx9MrkUmk/DMzeFfA//r8stRb50sXll/v6WZx2iRe8Bb4dqiRV80ylV+t2wks67x
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB2370.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014)(23010399003)(18002099003)(22082099003)(4143699003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?SjNUA/I2SgkxL/rlEYHczChxQMyIwJ8whjH4MzqdTrmc2PnhdymFsLQLdIxE?=
 =?us-ascii?Q?E7hT4d99Zc8xcCsNEApPNKXig060uDNN2Utr1p3CpT90q3x6vYIFFtclZHcn?=
 =?us-ascii?Q?TC4A9MJVXioQVCoL13KY6JVsiltISin0on09O2rGspiN17fGQcyW+k+NFah5?=
 =?us-ascii?Q?SKEpyVkCEFTq1IcPUolcFT3Y2wRh9VfdC8ieCbqYSDA7PG11gQPcATYY5US0?=
 =?us-ascii?Q?LDxmztZvcFVLAO/fH/AKAdSb38RT5pax72a/b6fbyeymOLvjBH7EEeBvw8tv?=
 =?us-ascii?Q?zfeglxeI1pEs5ySaJJa0rb87loAuQ5hkvGhzFrkuBHuwI3sPeldwzBndbfCC?=
 =?us-ascii?Q?8ldbGK4jMdCuhzmvR9DSsAyPFWqf+6gotQir3dnKpLrqWEEj5QjjFxJTW2ir?=
 =?us-ascii?Q?+QpJBXN8zJO/OmSf8xT7PL8YsbK1V8lXrFi/PmUosnB5Nitt6IIeT1M8fulg?=
 =?us-ascii?Q?mK81/anJfCz+neE2nKP0Zy8/3oEFluHD25MY1EehUP78uNF8rdjQaV2Jso9B?=
 =?us-ascii?Q?L62MfKejfwjWSyPgyYcKVf5KaELWj2CaFDPJvZ8XF3k0MN4/OU8lc1q2X574?=
 =?us-ascii?Q?k4LDCnwS2L2/5D+7kR7rewFTOY5r2O0W95jXfEoxIfDmOKSyZ3XtDm0eWi1w?=
 =?us-ascii?Q?sM1Lcrf4JNi3S1E1d3ZGI4fKksM3QHjEdtDun7f2OQtcofjw9zskmUjrMqPu?=
 =?us-ascii?Q?5iqHIqhjJ974YHIWqZGcesrMtFaLi/2P7GV4JNLy26WKDER/ISmWXbUmin+W?=
 =?us-ascii?Q?QxgMSVHCZnOmHwys9apAkMvTw1gEbNfpELG1yw1qz+bt5Vuylk5hzK/f37AY?=
 =?us-ascii?Q?vpvFG5EbPoRiOfOBOeGddpYcrDCXL7pPkp41jBWQDNYuGSpd+QKa1jTAGmPR?=
 =?us-ascii?Q?bLrv6ybuaJeezXAmjs1FyMm80SxbPABC+KxvlVx/yhRAMvuEQHl2vrwk+Qfe?=
 =?us-ascii?Q?dxkXBzeF9odEIr1i5Kf+jtdgf1vpQxUaElXQTNQYQlz/fo5KCDrexOAKm6N9?=
 =?us-ascii?Q?Cu8SEqIQa6uFQ5jPQY3+YAwRPxBA4QjK0Mc5SSPeWOzV+sCaCATSoJrqDKhE?=
 =?us-ascii?Q?gB/DVJfXfuiDRHELWk0cilWcOmQ7LC/bBl2j2Qg73zQfVHsJoFw+ppHCbP2M?=
 =?us-ascii?Q?qzy3z+ziCCn7/0XxwSWm2I+RS+nNLnG6oZJ8gQVx4zfTzesbJaFUAMqlnyvU?=
 =?us-ascii?Q?b9/de7JDgkgKutRN18f4Eg8+y1YIJYrTNFZOTRzAPPiaPJPixrPghAF7pWCa?=
 =?us-ascii?Q?WgoiMXMOyUvsDZIJLypD3I2zEket22pULkbId94jBpLjdUHEzU2QSNcF/+mU?=
 =?us-ascii?Q?M9H5SL+1pTvqKAnBD1W3SamE17RQawNvAfJiP/VSYtC4R7vH71SefNJd3mFN?=
 =?us-ascii?Q?mXBVlIm859uUKMIsOhrKHMfDDiMPmAoSttUHeih57T4aA90sLP9hW92pYgSy?=
 =?us-ascii?Q?ngxi9dgcYptI+6sja8MsVfSCbdWmd4kjMbU0T82ogsDXL7QXWDU3Caq8DfQO?=
 =?us-ascii?Q?fCD/p7zJ5Ak4M5SHE3fAHd6W6n1uldlg7mApCXiuEJ2Ys0kdcgdVBnmwvJat?=
 =?us-ascii?Q?cdx0xxy6Da8JV6h3srz2oudN5EDy7GXUVSIqr1m4dlVDwrPe0Mu+5gbb50SX?=
 =?us-ascii?Q?bK02nKjz8dKaJ55P1jA5pQ0u70z68ZOqp8IcLlITvr0Xi80AYw4xlGwon7ZM?=
 =?us-ascii?Q?nGqpgtgjFSY3Gowq8CUKued8fspns3AucXjwOq/3Om60DYbGifb2t/F5/lEi?=
 =?us-ascii?Q?dbsl5FqE8Q=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2384406c-926b-4439-bc04-08dec82e3c3e
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB2370.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2026 02:56:44.3526
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fPKXlZ4ClrXxKgngAMFM8hu+/mSuWZcsRQQdbM1ERwVWtsqhepQCUWKW6yEXS6tirn8xDXdUS8z3tvolystZbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6315

On Thu, Jun 11, 2026 at 05:32:07PM +0800, John Groves wrote:
> From: John Groves <John@Groves.net>
> 
> Clear pgmap->vmemmap_shift for static DAX devices. When rebinding a static
> device from device_dax (which may set vmemmap_shift based on alignment) to
> fsdev_dax, the stale vmemmap_shift persists on the shared pgmap. Explicitly
> zero it before devm_memremap_pages() so the vmemmap is built for order-0
> folios as fsdev requires.
> 
> Fixes: d5406bd458b0a ("dax: add fsdev.c driver for fs-dax on character dax")
> 
> Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> Reviewed-by: Alison Schofield <alison.schofield@intel.com>
> Signed-off-by: John Groves <john@groves.net>
> ---
>  drivers/dax/fsdev.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/dax/fsdev.c b/drivers/dax/fsdev.c
> index 2c5de3d80a618..52f46b3e245ea 100644
> --- a/drivers/dax/fsdev.c
> +++ b/drivers/dax/fsdev.c
> @@ -237,6 +237,7 @@ static int fsdev_dax_probe(struct dev_dax *dev_dax)
>  		}
>  
>  		pgmap = dev_dax->pgmap;
> +		pgmap->vmemmap_shift = 0;


Hello John,

I would suggest also clearing pgmap->ops and pgmap->owner on teardown.
fsdev also writes them but never clears them. memuunmap_pages() leaves the
descriptor intact and kill_dev_dax() only NULLs dev_dax->pgmap for !static case.
After fsdev unbind the stale ops survive.
If we do rmmod later a HW failure dispatch pgmap->ops->memory_failure.

--Richard

>  	} else {
>  		size_t pgmap_size;
>  
> -- 
> 2.53.0
> 
> 

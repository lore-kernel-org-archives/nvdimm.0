Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010034.outbound.protection.outlook.com [52.101.46.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DA8836606B
	for <nvdimm@lists.linux.dev>; Mon, 22 Jun 2026 10:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.34
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782124326; cv=fail; b=Y2dbWfTfa7MJ1HBOJPuat6Pueu+t8XJKNrs/CZkSDa4hlhxnXWH0uxtfyziuLRWObj//jQgii8rITXjZn+dN63GmuTLJm4I5hVMZ3F6yP3Rd/vsOyj0oUNgC9DQOIaYj2QYMwWI+yW15Y0hx154lT8BMPaMNrmBQYrxS2INCmAI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782124326; c=relaxed/simple;
	bh=cFOQESlkJybCAv9Sm3WoZjRl3p0lpYFq/TABcS/LUlQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=F/TdxEEf5ZNQ2ejYwi5mb6FVu3SMO+7DbfS9N0tt5NuVCCGcjb1Y/tDFHQnIvgsET2s2DNx8CptxBJ7LlcPcjb2DPEsm1CCiexPTSatANyL2L0nUhtibQiNJxftfPuYcO7QUJzjRGlVIPADBFn9EVz8U38Ohg5Plsf0gqr6rC6M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=CnJ6UalX; arc=fail smtp.client-ip=52.101.46.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="CnJ6UalX"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jp69bRJygVJYZLCVEUXXxWY2vjQ63bt6Rdif4WMNd5Uyg4ZEiNQq1n8wtI6UI8IsJ2FI0p9eN8c2pGK/Lh1yaLbf12SVvW1Jyil/88fxgJ7MenIzW7nIEHltsxBwG3eYsM4ck+rAuUTnZJIbammQMFs0HOQz7oX6PdfetkARPS/pTj8iQvm71n88ZC2JzLoqWHvgdgIpaR6DG9xH+52O0I9dHd+tnGbPct15lA4XgDH+j9SbcE8nt5hpX8MpIRWeBieeeTvUrBx30bgHX1yak/emHpsxj/jhBQvNIskfh/MecLG8rKZAGuRa1CxQUOh0kbgQL2KG62aSkzBEUgFMmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qaLrhuwORYYKj6gR6cr/EccW/4d4b2YGoO9+UmtO+9M=;
 b=vwbUlODeXUeuLmjbQI77lIQxWHfDkxEsRO3uJ26iSGymWggtwkbDqjwfeGO7wUTIdlX48A/KXw2XUkUaeL7JQYnJAkE1GKK5Pp67YpVuhL85MSPUvyzP+CgI4Sq/FI+sGT0QqXUbuQw85WhYHkHLUzyMfzktK8DqweLhXmgj6sOpbdQl/nQzxR4Y9bFm2E7l1DSMHo8b7ha5keiwXLUgPrbBNQksV9dnCk3+PDIXcduRObpyRKY4ysQJUBiaqbnlKsvnUF2pHwnhkqJV5sryF8ZDUmhgQMsYMc7NBB9Wl5H2jd3KCarOdy6739Tpuhdbg6FKAo7udvBaFJo3pbaiVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qaLrhuwORYYKj6gR6cr/EccW/4d4b2YGoO9+UmtO+9M=;
 b=CnJ6UalXkUqUql9mCSHG+JIXIBk68LH6uTXlReW7jbuPaARyTscKdZVcg3wWeeSYd5/1d5QKEMf0vL8n5C/x6YdZMu3nQOmcYkqMumQZOBhBMay0ZON3v2YD1MP6v6HpSIvf6AH8DQKb5a33DrtbgXQC5tyzWUnDubfQ092fINo2FfhMg/Z+6rih7iYupPu+yl5ozIJ/q1KRtFx5dzfrToJMscsNqHth0cnyly+4hcJ9w1d9Iq4wKMfVq57n/Y0+bkioHHbMiO7k+gAjCvLpVxawdkjx7dl8S8V9YdqYOPEgSKm59fyjLq9ygCYDgZ3N1i8cMOgeuFWEormHgh0N3Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB2370.namprd12.prod.outlook.com (2603:10b6:207:47::27)
 by PH7PR12MB6492.namprd12.prod.outlook.com (2603:10b6:510:1f3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.20; Mon, 22 Jun
 2026 10:31:59 +0000
Received: from BL0PR12MB2370.namprd12.prod.outlook.com
 ([fe80::86cf:c3ec:2cf5:74c8]) by BL0PR12MB2370.namprd12.prod.outlook.com
 ([fe80::86cf:c3ec:2cf5:74c8%5]) with mapi id 15.21.0139.009; Mon, 22 Jun 2026
 10:31:59 +0000
Date: Mon, 22 Jun 2026 18:31:52 +0800
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
Subject: Re: [PATCH V6 05/10] dax/fsdev: clear pgmap ops and owner on unbind
Message-ID: <ajkO7yiGplFl4MIa@MWDK4CY14F>
References: <0100019ecc080a68-8dc0c99f-ab17-4aa9-83d9-490e9c97ac2e-000000@email.amazonses.com>
 <20260615160656.17533-1-john@jagalactic.com>
 <0100019ecc094b6e-fc163bde-0396-4a33-909f-fb88e740be27-000000@email.amazonses.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0100019ecc094b6e-fc163bde-0396-4a33-909f-fb88e740be27-000000@email.amazonses.com>
X-ClientProxiedBy: SI1PR02CA0002.apcprd02.prod.outlook.com
 (2603:1096:4:1f7::16) To BL0PR12MB2370.namprd12.prod.outlook.com
 (2603:10b6:207:47::27)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR12MB2370:EE_|PH7PR12MB6492:EE_
X-MS-Office365-Filtering-Correlation-Id: 6ab1408c-39f1-4af5-ffef-08ded0497d9c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|376014|7416014|18002099003|22082099003|4143699003|5023799004|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	qH5WH/7G0HjPl6KBo++DOUReHF9fBGV8Yy/wWKQfIF4ZMuTpMvmcWuNdlOMfIHFDLOtD2nebD4kAt/DlDTQoUrSTl0QMdR6yIPptIwXjRwJlzb2DUMzVp+WXs14X/FuGYYNVFcDa6sNq97+ahujDELeo5Zd28AXWsRXV3gUrhldjTvWSL1wS+An4xNiegvZHUjuXLh/dps/6gG86cu7GDpmmh1MhDiRsZpSUP4TDpJx/mxxCavebeGyiBTIxtBzrQI6HvjAcQYNVcRCGf+2w4IGVEJTXlToqs1zarhHzyN3ywZBQsZwv6Ozt37P74JOdXcADC08y3GUK5tA5nv4wvB0pEpejZ79caWkOL0cAzzxg9yVCjPr1Yc/7OLTA0UfeaeOUpskC4OMKB2dPLu0bKz71Ipke2XfN7QbBsEm7mUvajW2xGXLgDLCze2ArLT1NIXZMcdN4tQ70n9vdBC15lft5Az9svaWHYHbA34zSVoPuZgsxOdEVSmdEXAKFjfMxokXovi6OUiwB9EY/RMAHSea8L1QAM36kd/FRjV4a3Hj6XWt/5X/4wpwRsxnVIVf1WSP53IIKH4jPfxaKj5tDZV1qDU+OFzlCrsmxE0x/2qfi+gdNjusIUvfIHt0lxLedK1f9Ss+HPR73OH7w3C0RVwoMfJQGKQ6iFmQmuU5uGJc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB2370.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(376014)(7416014)(18002099003)(22082099003)(4143699003)(5023799004)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?cgrOybEU07Wo2KFYsCdLFWTwrlsU4DhDeDRwryYS9/L+SuZLCAdBuPs4y+sV?=
 =?us-ascii?Q?U8zlMEPL1OKh+XMJeM9m2hNCSw/x10TUMXSk1OS7fBOIZgaFUX8HmMbEkdZ2?=
 =?us-ascii?Q?5nmZJmSXSwq8Y4TfZ9TZbPrUrpGdwgUP38bdMnet3su5hOO/WtUZOnMKT6io?=
 =?us-ascii?Q?BZ/kzqG0r+cIhIap/syMkpcxcTjZCmJpcVvDhiaO/a8ARmtZ0yVJqXs7fIjM?=
 =?us-ascii?Q?WjY5QAM61RIOo0ohKCsxLOawpO5SUFXioD9DZ9DibFTc6HEQwpkRilRWlZT5?=
 =?us-ascii?Q?Y3dvClx7w5+xFxkPL4jy4kny9DGN6ivLoeiWJU2UTPsFfPhioyBaBoso1OY3?=
 =?us-ascii?Q?7G3qD7o9+3pMkUMUGfiNXchRJZxgazVeZ9RfJIlLrJoRMG1UYtLHCwREA7/i?=
 =?us-ascii?Q?KfYROXqFt/7KtR5IQmya1YscGSLo/Q9qbgdJ7s6bi65mx4dYlpanijjeTp5G?=
 =?us-ascii?Q?DCPiDhcrMziOfb+ynrfnx9heh6KHWQzgw+M0/BBAdWCifo30HDSctUYozuW9?=
 =?us-ascii?Q?0l/UVtHv7LN01Tf2ozDOoF4bD3RtcI6atggmnfORRnHuUrA4fdUTW6IheuWQ?=
 =?us-ascii?Q?1clG5C7kc8dyZOhbiaLZRQrp62eVBSGhPlNWMls/R9nKlgDlwrrsCSkb5zuL?=
 =?us-ascii?Q?KHh9yV1aEtqIl0UgrRGUdhMRosTEztLRXdIwIuKnXP9PvaDsZkEGbMSY3T9X?=
 =?us-ascii?Q?4JVQOM3bcfzwNIe7vQl/8LLxT2+DucDlJxXk5UO8E6w9xrCXCwGCd6235DvE?=
 =?us-ascii?Q?J30QSdU9uFMqwz4rz0AJaGeaPmXWpi45vHMzXd1cap7sJtyZWFqOFw1BTYBC?=
 =?us-ascii?Q?u5iIfRbezUVGgR17iCeSo4G+cHu+T5+Vw+T9LnBWj0GzXU4/ow4WEyJM1zFV?=
 =?us-ascii?Q?TxZ0qQOJZV73dODCjEE8wcOYXy4FUsJcexQ1O1NTBkfDcQX9AXJ3XTNBKHAW?=
 =?us-ascii?Q?Jm7OpqHgOA9lyv1BBf3/I2jx/pF42f9SBg8kvsEZS/n6utbRW/gZ3+0teF+p?=
 =?us-ascii?Q?5YWIwBxPhLOyVgeATTwHBfRuV9m3O8s8GgmlleAIttZ+O72Fw/D8d51vlSmI?=
 =?us-ascii?Q?cwdBBylI5VvjsAbGh0ZjCqMN3gBd2qkdjsVHnahtzskC2v6sPpC9sTvfhxJB?=
 =?us-ascii?Q?R8ng4u6fW8+bHfvMS0qwqXMzuPhW7oKpQ4J9ZicKA3jIve49rkCaL0uDKoz/?=
 =?us-ascii?Q?t97QezYZCZdKufEMxxyG23WTLRUF/xXF3xNLHLY07l6PQBGROU5L2CUNptwa?=
 =?us-ascii?Q?aIKrX4EtnzaKbmAG3W++wW0SUemwDTbFgnSj5RHR7mL2qBTd5AMBu/PuVWL+?=
 =?us-ascii?Q?Y61ofcq7KXNggyp4QkWmZo35DZ+kpuFnltWnaNgRJB0g9sDo4S7YerL9rVfM?=
 =?us-ascii?Q?BEJbvVnA+yWJN9b5YSL2W0U1CtdxwY9ypzHrg0INh4d9tesvWVcEsL/1MY6F?=
 =?us-ascii?Q?zgp+wPRyRIIzf2r0bGC40r7d0GFpcg9DlHZOsECEHsF/OXzLzbO8zsVKeJ1C?=
 =?us-ascii?Q?xSK3I3X/71uOq2FbvO3s1+j8wvqfBt0MOyUdlamqVQ3BwpZlC+JoghfMD1zD?=
 =?us-ascii?Q?HPoA3db3DHBmZ4MVDDBLDfoGDZgraQ4luhEMw2KRMmi4zy1w1rKk5sYBupGm?=
 =?us-ascii?Q?wEFM7ttxl4ztVTKChweE9EKuUXDyR0j3NFqP8ekypgA1n2pZGaTFUKWQ7o2E?=
 =?us-ascii?Q?taswb0C8uzTN+y4xsT3nJ6mE4m1XNuoE27QOfr76iAWOjCwMniuuDiyEP6KW?=
 =?us-ascii?Q?gMBjocWb3w=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ab1408c-39f1-4af5-ffef-08ded0497d9c
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB2370.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2026 10:31:59.5598
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xzwEVEvj37haS5sjdxWBzDGIUh+sKF7Ja1+lhFo5D+t2fyjiOpt27JgOZgFSEvzVmpF8Qd2N8yQEs+yyUpUqPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6492

On Mon, Jun 15, 2026 at 04:07:01PM +0800, John Groves wrote:
> From: John Groves <John@Groves.net>
> 
> fsdev_dax_probe() sets pgmap->ops = &fsdev_pagemap_ops and
> pgmap->owner = dev_dax, but nothing ever clears them. For a dynamic
> device the pgmap is devm-allocated and freed on unbind, so this is
> harmless. For a static device the pgmap is the shared, long-lived one
> owned by the dax bus (kill_dev_dax() only NULLs dev_dax->pgmap for the
> non-static case), and device.c's probe sets only pgmap->type, never
> clearing ops/owner.
> 
> So after fsdev unbinds a static device the stale fsdev_pagemap_ops
> survives on the shared pgmap. If the device is then rebound to
> device_dax (MEMORY_DEVICE_GENERIC, which installs no ->memory_failure),
> or the fsdev_dax module is unloaded, a subsequent memory_failure on that
> pgmap dispatches through the stale -- and possibly freed -- handler.
> 
> Register a devm action that clears pgmap->ops and pgmap->owner on unbind,
> symmetric with setting them at probe, so the pgmap carries no fsdev state
> once fsdev is detached.
> 
> Suggested-by: Richard Cheng <icheng@nvidia.com>
> Fixes: d5406bd458b0a ("dax: add fsdev.c driver for fs-dax on character dax")
> Signed-off-by: John Groves <john@groves.net>
> ---
>  drivers/dax/fsdev.c | 22 ++++++++++++++++++++++
>  1 file changed, 22 insertions(+)
> 
> diff --git a/drivers/dax/fsdev.c b/drivers/dax/fsdev.c
> index 0fd5e1293d725..68a4369562f70 100644
> --- a/drivers/dax/fsdev.c
> +++ b/drivers/dax/fsdev.c
> @@ -127,6 +127,23 @@ static void fsdev_clear_ops(void *data)
>  	dax_set_ops(dev_dax->dax_dev, NULL);
>  }
>  
> +static void fsdev_clear_pgmap_ops(void *data)
> +{
> +	struct dev_pagemap *pgmap = data;
> +
> +	/*
> +	 * fsdev installs pgmap->ops and ->owner at probe. For a static device
> +	 * the pgmap is shared and long-lived (owned by the dax bus), so
> +	 * leaving fsdev's ops behind on unbind would let a later
> +	 * memory_failure -- after rebind to another driver, or after this
> +	 * module is unloaded -- dispatch through a stale or freed
> +	 * ->memory_failure handler. Clear them so the pgmap carries no fsdev
> +	 * state once we are unbound.
> +	 */
> +	pgmap->ops = NULL;
> +	pgmap->owner = NULL;
> +}
> +
>  /*
>   * Page map operations for FS-DAX mode
>   * Similar to fsdax_pagemap_ops in drivers/nvdimm/pmem.c
> @@ -306,6 +323,11 @@ static int fsdev_dax_probe(struct dev_dax *dev_dax)
>  	if (IS_ERR(addr))
>  		return PTR_ERR(addr);
>  
> +	/* Drop fsdev's pgmap->ops/owner on unbind so no stale ops survive. */
> +	rc = devm_add_action_or_reset(dev, fsdev_clear_pgmap_ops, pgmap);
> +	if (rc)
> +		return rc;
> +
>  	/*
>  	 * Clear any stale compound folio state left over from a previous
>  	 * driver (e.g., device_dax with vmemmap_shift). Also register this
> -- 
> 2.53.0
>

Thanks for this, LGTM.

Reviewed-by: Richard Cheng <icheng@nvidia.com>

Best regards,
Richard Cheng. 

Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011031.outbound.protection.outlook.com [40.93.194.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D22C1D61B7
	for <nvdimm@lists.linux.dev>; Fri, 12 Jun 2026 03:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.31
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781233371; cv=fail; b=ROyzHZqn2qAewvIZK92X2y1KUeEwuWF8dHyGDEl3eVwAOXUifkksJabPZZnShR+le/oKFGVHasKrLGa1oYFLGOAQhYRmh8HjFobvAlhcMG32GrFOT3eErgImRYda2pdH4pz1f/BG/STvDic0+l8C2xn1PFNy/YUzxtXg2eS9WnM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781233371; c=relaxed/simple;
	bh=YMsdjyhyeXTvDmQGejFYrl1mB9DpmzMALvyTBkt7WkU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=DKPvfqv2esd9F6JvoZudpKVSQU1JNW3wo9nHeu9IAwlWckONVF/4+k+r68bDi6TdidVrBuIEQmoBpq/Vnbf+7qzrTNwD5IwVNXogqjwDGT+A/q6XQl3iOJXq3EwdPK1QdesNYiG6QiUMhViZY8r8EhdapQF8Ffx78FKCN+SI5aI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Vs+1QDIz; arc=fail smtp.client-ip=40.93.194.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Vs+1QDIz"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q7fCrMIlbB7MfhRNnVR9M4S92N+7THnxRVmb4pNgRzaaP7gQzcQjlaW2yBgYkx1zYkUUiJGMm6TMynjF9gb8ypbwiZSK+WzThGWohZYUABxvDQZq0QsiXYF5RetAJpw6HwfUkoVnYaOYF+H0tUm3fBJjC4yaJgNHbZss/kl7anCUUetwyu29+WpOBPShUSFEHlIOqgv8iVdOPy7L3pf5ad40KjMn2YF0wMzftK0U+0V/fGPI939ZF48AotGQPmYcOYxO4F+umko7yrBtMhjdvjpRnGZ859KyZTdtG9rck4mW6GQAY93xlWmCgXyfLKokDTQMU/vwzVLh+p8Fyy19yQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LcLVk6BryZYAboE4vynI4tNy3B/Nv0CEbqX+Wb8kfGs=;
 b=sTe4lQGGqn/PR55gzHK2Eyw4up3ruZt89tPUNmxTwlsSfVlunUjxR9rfadUnEujURL7YBRR6uIwTHwt/Ls2mk80dlmqepJpn1b+g8K46lnEOm8AyK7w6cP0ZxVHLhiLh3kqpx/GWMuw2Df6JT+Ad45z0EIvX2ef+bOmz8An3GvdxWrkOOfprV7iPumHgtb5K0hirokUSWsMhir3Ojb0eewQ1IciN2UyGiek87MKY+tvu2WUujDD+G+hFFNBrmCuyLa2Z9KSGjJfM9zQ54iT/1/e+5RKkErY0fQg2fgeLDGKL7z3q8l+zR4AL4xCcjJyGy9QL0uvlOiZ/vhb/3pIxlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LcLVk6BryZYAboE4vynI4tNy3B/Nv0CEbqX+Wb8kfGs=;
 b=Vs+1QDIzypq/ZZWk2OBzZzXIv8x+4eMGTBkNeIZqi8xsUk7OUXly3DhuRiiBNm/LgoT2DQjKw7+bu83+iOTIKWox5EdOfN1w/34PPvtJJXdM3UP0fmVLX+3qlXx+KCZPSWfUuOrBCpLel2uXumqDMnNpzoEAWB7EYijXweIQnfQ7fvONKDCuPsdTMSngjkkAWeFsuGwBsjFU2uPyLGnr3kYSanlJCbT34CdiShSfLRgjxiRpQQnN7ApH7+5Q7dkTiz2H+SziRXbAKD4sJ4FpsOF/8ZsegK4C1ZlrXt/n9A3u23zmZOVeQHDeg1Tdpk9bXewS5phMGiZMZigjF7UJVg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB2370.namprd12.prod.outlook.com (2603:10b6:207:47::27)
 by SJ1PR12MB6315.namprd12.prod.outlook.com (2603:10b6:a03:456::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.17; Fri, 12 Jun
 2026 03:02:46 +0000
Received: from BL0PR12MB2370.namprd12.prod.outlook.com
 ([fe80::86cf:c3ec:2cf5:74c8]) by BL0PR12MB2370.namprd12.prod.outlook.com
 ([fe80::86cf:c3ec:2cf5:74c8%5]) with mapi id 15.21.0113.013; Fri, 12 Jun 2026
 03:02:45 +0000
Date: Fri, 12 Jun 2026 11:02:39 +0800
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
Subject: Re: [PATCH V5 7/9] dax: read holder_ops once in
 dax_holder_notify_failure()
Message-ID: <ait2Lymb4y-Wb2ie@MWDK4CY14F>
References: <0100019eb7bcda4b-3f8edae9-d7a4-4bfa-aaea-fcef77fdbbc3-000000@email.amazonses.com>
 <20260611173240.66020-1-john@jagalactic.com>
 <0100019eb7be595f-5045353d-86b9-49fd-b1ca-fbb40c22d06c-000000@email.amazonses.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0100019eb7be595f-5045353d-86b9-49fd-b1ca-fbb40c22d06c-000000@email.amazonses.com>
X-ClientProxiedBy: SI2PR01CA0011.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::6) To BL0PR12MB2370.namprd12.prod.outlook.com
 (2603:10b6:207:47::27)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR12MB2370:EE_|SJ1PR12MB6315:EE_
X-MS-Office365-Filtering-Correlation-Id: 044cd32a-c1e2-4c87-72da-08dec82f13d6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|366016|376014|23010399003|18002099003|22082099003|4143699003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	XKS5zhyruaWFi8fp23Pza8zdbiaY7prlGTMI3aWBprYBL4sTbbWB1AotpgMReTG7MInEILz7nUBM69xVk3cCSZDBDSq65Fqzoca/TzLzgsKRc6gV8FJW3aUDeSTAoy4tE+yY+gbkkPwXxRtBs99WJN9Z+arbp8mh9R1RJ5WjbjIJdwk9U+uXo8B3+D7d/dvT/OY63FkUPLBnUhUWyna2Ry+D0o1KcQ2xPkxsn9jWb+4ko/U3fg21UdGkikNtfuX2wC8kRWVjlaMq3JY24qa3Pr2LNsf9hz4p4EHHm7iotiOlQ3BXizgzQri1/hFKIZARAK1IqsllJlXoczsRRb/L164iHGaEV4QPpGA2kCiuwsU5ZljqJzIjypdOTK+VPc6DcwS81OJ8s6zG813iOCQghEf35jg7zsrBkD8fW+Ft6r59jSaA+a26FD4CfkAj6BHBl0owj3y5joccLB2AQnICcQCO+1THGH+TkxRqvmotuF2fZ+A/H10ffYDLfIT6LCybbZQMQS6MyiKEnEQgJa/2rB1qzeUU00J7NDmWeG51wJq8CI7p2VwpHvdWEJ4aNN9IEd61D3DvqNi1h7BSisCVHGHanWCq7QNgFKBDI6586znd3bn7bISzKScL7aY6FSmDDhQXacCPg9at8ciw+LKQrc7hLrNvRIriCvqy5VnqAd3LztDFkrAxa5mwZTtXw0FU
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB2370.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014)(23010399003)(18002099003)(22082099003)(4143699003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?CCM8zaPXGbXvSOMSFvpIv5N60wQRNrBGRI2CGao5OeAPXTTU0ebmzSXXCz7t?=
 =?us-ascii?Q?K/9aacQNjWG06m4+Yc73n4QT8aUgrM+kiQYR8OwQrBH2gYRYnxcYP84a0OkL?=
 =?us-ascii?Q?ESKH1aj62i4oQREHa+/wNoOQOZ1Kjnm2+cZ19MbcHrEQqEET1l6fn6d4mG+0?=
 =?us-ascii?Q?n4bQt+hZllNRLX2oQZPQWM+tl/Wg1UGbPiXFRXQ9EA0GlwL9OaTZiZItEHo4?=
 =?us-ascii?Q?vkLAfFRXI50Eu1HhA0EgXr2fL0bvhwsntIDdtOTV4YOBto0JvnDyGyZgEdM+?=
 =?us-ascii?Q?RFPdscusMFP01ak1EraVL/9jAGf3xK35Ln41ARqVLw6PLy/DPXDr23Guypw2?=
 =?us-ascii?Q?kdO9pgz9Ys0yb3TM8s66UH3Kj8luTtgoSSt58WjpMn6BmiJIvYkWxIWhXkEY?=
 =?us-ascii?Q?DYCvkPDHWpjxr893ZCTPIC0TVcScXXemiEBVVjLB6C8Yo3Rn7voAu0670aXj?=
 =?us-ascii?Q?hLcTn0ZsFOr/QmnkTXaOt7bJsOkOYDuEQNtNqmpZSNoH1df02GsjvgN+BziV?=
 =?us-ascii?Q?nqsc8hM+KBgGgiy8jNK8niahYP0U0diWs8C4dUM57ILqkO74ZkKXpFKVumJ6?=
 =?us-ascii?Q?GbWJeABptrh2h8AaibeDV/bQkpm2Yar/tdMbL6uH63aXvjCpxFEzyZnXPsUd?=
 =?us-ascii?Q?gwUwWCNPyB5QA1QSdQ8Za57KKAzmdnAoI6lX8+YTx6NEM4IgvHG+YP+4FWDQ?=
 =?us-ascii?Q?HdUFslz5F57rCblZ3wPctKY5bTYfFipMiS8ZGx5419Hp3q2pFngOAI/jak6A?=
 =?us-ascii?Q?h55tuiFvS9iAP7kE82cVpklTQWlDGwuSWZYxxPcNwxC8LDkXdZoi4VwBr0fv?=
 =?us-ascii?Q?H6XDM3GFEAuU7R4OwGepB4E0/h7H9wSDCo6Pp2gQEKEgPilNHgCi3RsU99sA?=
 =?us-ascii?Q?mvJOmE7TUonIx44PsiBkSeZmHmxWkwy/rrz7UpCZiOP6T+ZkFT3h/Zo7OpcQ?=
 =?us-ascii?Q?8GjXxCA7KxwnD/Rlmg9Q7XoWb888y+00pkUTB3ITnAn7ZJLVNrlgyvMfmVA5?=
 =?us-ascii?Q?2XRI55AckAaypsj24tUj0iS6Ti40Du8BSulBBfjnzxpVG7VCtL1Hx6V5awrp?=
 =?us-ascii?Q?cndIWNIgqtFwFJ3v91EMlm5XhdsUy7V6zdxuI7Pmvc50fFIo2t4odbWTNSqr?=
 =?us-ascii?Q?GMgaRxhLmTs9RoHT56+GFDrtoUgt2crtadj4+TLciTl7tHefIlzz1bHIUZbM?=
 =?us-ascii?Q?6gO5JKsf/j9BStOK5E9dCXxSqhy/1BOkmiqw7xbLKR7bmlxpK4Oz4qIRzjiw?=
 =?us-ascii?Q?q37jFLm10NQ7N4aVa2YlvqKH+HfF5rspKTXVGvqTtl96zq9+q9RUP85XoVoV?=
 =?us-ascii?Q?W0nvQfBmGxv1obZe2ROrKQlhkhypfQUCPzeGXDHGpNEH87YbzmOEdSUW9KC/?=
 =?us-ascii?Q?A6BNNsn5SdOA7YAyjdhma304Zu6P3Hca2Pdw9B/VDil67B4NzJnzXOHvlScr?=
 =?us-ascii?Q?R2GgS4f0ASfvG9pZN3dNXwmW4p99W0N5TtgzM7oAvMuqrYyyPpzr7D8M2L2k?=
 =?us-ascii?Q?lwWRwopnCQsqJeLhu3GznH6QEEDfORcgA9bBkpVCWjzckUYrioRnE4+nnnDu?=
 =?us-ascii?Q?6KYM0F2vIhjFb/f92Qs4QiQpUjg+yPAP1kniNVHWBBuwXv/hd3SQGyLexNny?=
 =?us-ascii?Q?VGz4E0tEP6xpkwwU44UdTus80mDmPFUtWEn9jdJJAOcddCzksLKOszF/2PZW?=
 =?us-ascii?Q?6nulv0Fb00ZZ9J04WGYDaSyY+inXYg8BuBFptvZKfCvPLr3DYE5QDmd/yxTQ?=
 =?us-ascii?Q?UU2UeCIB0A=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 044cd32a-c1e2-4c87-72da-08dec82f13d6
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB2370.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2026 03:02:45.9371
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bFm10xsDUA9WVSpMDbvLXHkA14tJR7AQKUha5SxAdCG8bpIl771vKHm7xURdBpjZusSBdgaPnZTYyiylDIn8nA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6315

On Thu, Jun 11, 2026 at 05:32:45PM +0800, John Groves wrote:
> From: John Groves <John@Groves.net>
> 
> dax_holder_notify_failure() reads dax_dev->holder_ops twice without
> READ_ONCE() -- once for the NULL check and once for the indirect
> notify_failure() call. A concurrent fs_put_dax() or kill_dax() can clear
> holder_ops between the two reads, so the check can observe a non-NULL
> pointer while the call dereferences NULL.
> 

Hello John,

Thanks for this.

Reviewed-by: Richard Cheng <icheng@nvidia.com>

Small message nit, kill_dax() isn't a racing clearer.
Plus I think this only fix holder_ops double-fetch, the fs_put_dax()
race issue is separate and pre-existing.

Best regards,
Richard Cheng.

> Fetch holder_ops once into a local with READ_ONCE() so the NULL check and
> the indirect call observe the same value.
> 
> Fixes: 8012b86608552 ("dax: introduce holder for dax_device")
> Suggested-by: Richard Cheng <icheng@nvidia.com>
> Signed-off-by: John Groves <john@groves.net>
> ---
>  drivers/dax/super.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> index 25cf99dd9360b..6b5ee6589e39b 100644
> --- a/drivers/dax/super.c
> +++ b/drivers/dax/super.c
> @@ -303,6 +303,7 @@ EXPORT_SYMBOL_GPL(dax_recovery_write);
>  int dax_holder_notify_failure(struct dax_device *dax_dev, u64 off,
>  			      u64 len, int mf_flags)
>  {
> +	const struct dax_holder_operations *ops;
>  	int rc, id;
>  
>  	id = dax_read_lock();
> @@ -311,12 +312,18 @@ int dax_holder_notify_failure(struct dax_device *dax_dev, u64 off,
>  		goto out;
>  	}
>  
> -	if (!dax_dev->holder_ops) {
> +	/*
> +	 * Read holder_ops once: a concurrent fs_put_dax() or kill_dax() can
> +	 * clear it. Without the single fetch the compiler could reload
> +	 * between the NULL check and the call and dereference a NULL ops.
> +	 */
> +	ops = READ_ONCE(dax_dev->holder_ops);
> +	if (!ops) {
>  		rc = -EOPNOTSUPP;
>  		goto out;
>  	}
>  
> -	rc = dax_dev->holder_ops->notify_failure(dax_dev, off, len, mf_flags);
> +	rc = ops->notify_failure(dax_dev, off, len, mf_flags);
>  out:
>  	dax_read_unlock(id);
>  	return rc;
> -- 
> 2.53.0
> 
> 

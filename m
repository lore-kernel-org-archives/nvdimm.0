Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012020.outbound.protection.outlook.com [40.107.209.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C08992E7F20
	for <nvdimm@lists.linux.dev>; Mon,  8 Jun 2026 10:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780915948; cv=fail; b=i4QgPP8Aeb3dji+RkuUIXoe6FKUg8V5lWynotQg8vmPm2r+R8tJJJyjN7LeBckPEZG+bQQ9Y7QyBUeHqst+Hw2wmRGLAAGDMKLmDi98EuCc7l4tZ5B2xMCPDjQQFfU9Fh1U3n1KXjugEpaWmQ1etx5gzhnSPpjfytMJnpnwXVVI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780915948; c=relaxed/simple;
	bh=ui1J7UJOGHnASeZ93McvTD+nIKBjj1rdM9zfER7yI1s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=CgWGUArlybrPAA1B7wD7DG9+S2L9OeV6IJBurjOjfW5GH40D9YUM+4NvjkPXmbhbci9qFo63DLFYdAAy5nE6ycFStqUtlO5vBYWGOpaRTlxvefDR+4OmHdoBG96cQgvcy4yNl3YjdAIug5rOBxZxDZe2LYdTIBGzwZa4wclELFs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=O+rkMGVi; arc=fail smtp.client-ip=40.107.209.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="O+rkMGVi"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nB8ujQnjI8gACDBC5oXmYrq3JwpyZtXTYwYyQWw0HmborUPUf2B6BIb0OfAiClGlp7/8SgAf800pKPsy/LhysO9biRyVYTR4jUK1Cd0qpR8N20Cs3gozKAsQ7PjnxY8DvtEvoKiF9oVruyiK2vIPGmBGQawr8rhQ5jz1OOnHObSyjyuwtB44RqmGstJ0Tttnnh7P/IDA8sfGMC+DffcVbEtsnk6VfuOJIaJhbm5azkmKv9y6LzSNnRzXfDzshFXCVhYf9mGZwaa0t8+dVNvGzYtb/PsJx75KWryv4zfuSDyDRJvCIJbUONsH9t22D48IgJXdcIa1QoPa8WP1WYx5Jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zu9nH2cEKrr2g8oZG5DSO1u/i/J1lck3WcdhWcu34Pw=;
 b=o63oGj5+c12ntJ3rxb2rwFC2tZ3e6y4FqsWwC0rW4NY8IPBvKiaFRfXQIDk1qjLBzVrKQqBVyFIvRsscTBBTYaucwDEdEmFn5iLsrwgmo5cRr7xO2Fae7C8owV3MwvnhDw2ggLjctDiVchSz7o7GFpYkuhwtdUSbFqECKfhopw4vXZTHNHZHzsbcd3DOw7qAvLNnlE33TpexMNeLsOqrwuEMlIivQR35sJjIO7IAxzrU3fYVAwQeOG5n+6QWjGrLx0mEZu6Na5HBK+3mmg+TDtMVGklD5aPV1WzSUBTaPCixyBFwISH7rSoJU5zoLtYfw8Cgz1sxGx3ynqNhUSelzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zu9nH2cEKrr2g8oZG5DSO1u/i/J1lck3WcdhWcu34Pw=;
 b=O+rkMGVio5xCnjOq65y+aHnm6p6MHKqJ25gowedU/oqzB35ls2kKgEpCzkvMLmJsv0Z+H5+tQHF56tUk7zOIwf/QQOHuHw/fJAEz1GL47DxiZlnDZPPJFjEwu+axm7i8EfsiU6pCfzVP7jmtVUvfvqgixh2yV4NKGfTICyR2SMG8zUpEnmdjFKbpxeJZ6V3FAN7V1Dq3bmGkhZVZRFqm7+oDMutatF3J/Q35h+RzMWrMzuWdJYJrIE2jpU11ePHZyx4Tvov3sec1XWMll7S66XMcWjfE25czjJfSiqwcAwou0tLxr7OaywVy9zUSrwtUQf0ws3H/TQhDmSzUWx978g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB2370.namprd12.prod.outlook.com (2603:10b6:207:47::27)
 by IA0PR12MB9010.namprd12.prod.outlook.com (2603:10b6:208:48e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.13; Mon, 8 Jun 2026
 10:52:21 +0000
Received: from BL0PR12MB2370.namprd12.prod.outlook.com
 ([fe80::86cf:c3ec:2cf5:74c8]) by BL0PR12MB2370.namprd12.prod.outlook.com
 ([fe80::86cf:c3ec:2cf5:74c8%5]) with mapi id 15.21.0092.011; Mon, 8 Jun 2026
 10:52:21 +0000
Date: Mon, 8 Jun 2026 18:52:14 +0800
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
Subject: Re: [PATCH V4 7/9] dax: fix holder_ops race in fs_put_dax()
Message-ID: <aiaeCdwZEP7o1Q5M@MWDK4CY14F>
References: <0100019ea3929225-a0f8e6f7-30ae-4f8e-ae6f-19129666c4c3-000000@email.amazonses.com>
 <20260607193405.94390-1-john@jagalactic.com>
 <0100019ea3941018-519230fa-2897-41b8-9677-dabc8d1124ca-000000@email.amazonses.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0100019ea3941018-519230fa-2897-41b8-9677-dabc8d1124ca-000000@email.amazonses.com>
X-ClientProxiedBy: KUZPR03CA0011.apcprd03.prod.outlook.com
 (2603:1096:d10:2a::8) To BL0PR12MB2370.namprd12.prod.outlook.com
 (2603:10b6:207:47::27)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR12MB2370:EE_|IA0PR12MB9010:EE_
X-MS-Office365-Filtering-Correlation-Id: b4653214-2ddd-437c-89d5-08dec54c0464
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|18002099003|22082099003|4143699003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	7s5buVpj9yuHh+qWwTzR0f1eFp42QWdWdO7QPz1y5hxGqdNzlZw3BVTISnMBpe5ipj0TT7iaSOOASWyV79QOmwDCneEZ/QPvPsstrTc85G+KSsVzj9tqe5AjBRqtgqW7TahoAYWgk9Ip8T2FqzePmcmZCtOLneAauCrJO9z7oZPPZY8PO9jHxre4pI33fcFAqPejs6sWnmVcXnfOtQkxaxFoKUSuF2BisKUa7JOwA7VI6vz7tKzBXApRATUX6Ju3dcaS/PU7LXYLpyOtMzPphm8I/60B+ODQRrPq5LRYzRFfJqPDOk/LB1Z8i5F7G7YAO5S4bVbZPNcDg7gMzJsC3lwaC7DqOP8VANIAFou1c6qIhXtOvyM5V1Qyn/9Eat1zq69ne22X+4WlmIJZC5UZl2RwO7mVRqqIwA4ZcnpZ2LsIpRGuUUo9B+D2LCuhkt/N5+oPEwbR8QgI4tHxQXV9UfRu6EStHRJUYypiAbde0uXQG76h1ynTDKDGMxvB78k36frrYExV6hcvI7EoA7jk2iLsxfct68uh207V3wcGlU0jQSYqODJtcFmCKjQz+Cau971AUMN2W7FHJFxIKS6U4SrHg0uSVXv1O9TIYRWPbivuM7KgGE1CKvcEcI7+gGtrNQl36bH26dYTQovnZuSjG6OPhyKpomanrOrWwNTrFDa3mqGrkoeivWVAh76PZiC6
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB2370.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(18002099003)(22082099003)(4143699003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?QqnZmcF6NnojCEYAECYQPJAvn+9DOoRNwwJ/be87Tr9z5Sk+TFPqvlLVJI1E?=
 =?us-ascii?Q?s3eRr5IeGowsMma1+ootvnbZW+5kjIvRFO51Va+MDpVt7QGW4CNH9h+AlQXj?=
 =?us-ascii?Q?3xzXl7RWPLhYdkFGJWe4f9eSp9OBI9uiYQ92sAwkN8has8CKmlvMZVsAsVev?=
 =?us-ascii?Q?/+imsqXur7Jr5dMhoJX3smyOVpPRNz4kCXxzF1+khukQ1tvmrR2unIeMjJov?=
 =?us-ascii?Q?56e5NXLlWm17R9MwhSx4pfXMuIywfC/CxwUqE7AnNwxCzt7OkO0avJEts4ps?=
 =?us-ascii?Q?9lguOdEb8an6cm6BQTpGE2DRPKz5RaGjQckqdNvIrrwLgpHtWOWPj+rSyKqE?=
 =?us-ascii?Q?FCD6V+MJAeHsDguydC43WHRMCjLmlwhePO2CdcNj4svg0U3+Hkm1yUmfbE/8?=
 =?us-ascii?Q?RSU+MXv5FFCut9iCFMWHzjaywOYO2LI/T361X2u/2IH2hziCdvjuF9zYGp81?=
 =?us-ascii?Q?kicmXF2W7CClB7y3nChW9qQZw5OebcDyuB/ERB/pfTw/ET2a6oIG3Ji70n4y?=
 =?us-ascii?Q?ybg0G9Vs0VHPRJ5zmtz+PvOe1K4tW/A5Uav8Dx5wpsyE5b3X2JY789Kgqn2h?=
 =?us-ascii?Q?5rJViQYcTX762tvkeTZGOtl0pkGEBUyspvX/K3q8AIL71xlvyGjyeWuKXUsK?=
 =?us-ascii?Q?uSlsuhhys+CIbYBM0bLjs/nMZMQflocl0HxasCKqQ11a76XBAaYtBuLqKWwC?=
 =?us-ascii?Q?sW2EGoRV6lgeZo11RIqZtnuCWbOqXvcXWDYMjq+CgIdM3mNlHga5NuP5EsgQ?=
 =?us-ascii?Q?ksOZNxlK7oFcU3E8lqRGOPJoT6UbY0lcNgL8Dt6AQmEoESgUuWGnxkHVEN3n?=
 =?us-ascii?Q?F6jQeR36GfAH3q+Hxwe1PjMCmUJxyNs7NPGwpYoEvFW64v1bIOcitR+3AGc2?=
 =?us-ascii?Q?qdz3CHO4hvNavuWK3QJWwiysToalk8loXSR5nwP2k3G2rZKXSL1+8B1mdlIb?=
 =?us-ascii?Q?Q0UaLF1gXgtARZRM+XhaT5IRM9/L3y7W7mVNhrPQjNP57r+5KcSmKC1zZZyX?=
 =?us-ascii?Q?S8ccBtHbPtLSqRyc5RBXBlfz4XUpf1brcn2IjPfJZAWUnSodQViyrhzY/Uui?=
 =?us-ascii?Q?dLCLR7L3IALRrpTJuxtZw4+1EzuebjPbSDA+w24Xi8b5MAIp/BIHbOwSTcSw?=
 =?us-ascii?Q?/Ce595H5J8gbBhzESq6B/gPDpvk2t7pXqAPXNUNMZ3k1dZsJ0UuszgJ+rKCz?=
 =?us-ascii?Q?+RJ838uNJb7grnGWq0buRiJ9/y6s9J8Y6EB8KmStgB+jJaQR4QmW1+++7BNC?=
 =?us-ascii?Q?GmjN92nbDq56h7xx5jbjyVtAgYteThEQCcGMCbNWy8wRpPr3ZwQjaeMm2Qd/?=
 =?us-ascii?Q?hP8pvD1BSCW0vRybUD7QGNqvcufPqDPPGMTjQ578SCGlli2rfQmXkzzfJQZ3?=
 =?us-ascii?Q?5kMkmC4JckkdqcvfpkFq6dkMnlK2BoTHt6XcCOU19Ll/jHbsSm+PLIkXWy3A?=
 =?us-ascii?Q?BvKjmuweFEgrNKxCNkjurf3opkkXc9jf3Q7V20hiGelZ439ihvEAsCRs1bk9?=
 =?us-ascii?Q?5z3N+4JQSMJ8hA2R5sAr4ljaTetnWi9mEP9GJqHwAQRKuVdnHR4kUXq0AEpo?=
 =?us-ascii?Q?4X9OtFUCXexw1s2AZTK5VrlEIfK8vwt/FjUBGQq0ZkR66xle7RVo87Yw2NsT?=
 =?us-ascii?Q?oefRWPBhEPWPL8Vp/00rjjPCxmPmEk9VU5+M8VpR3NdWsVN4yudLmxsMPsMQ?=
 =?us-ascii?Q?OuHJfAOozJU8HEIxPQHQ3S6QVnFa7dXNKd6ZV2D2f4mKHX9K65Z2ijwsQW2c?=
 =?us-ascii?Q?Hd5+JyokCQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4653214-2ddd-437c-89d5-08dec54c0464
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB2370.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2026 10:52:21.8362
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nQtSAJMiMerwwEx7BPzan9yCMDgX41Wdn/u5uh3GeuDEPCPi5dG/Qr7ykltCtKN23OBz+/NkQG8ZQtyMHKlOnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB9010

On Sun, Jun 07, 2026 at 07:34:10PM +0800, John Groves wrote:
> From: John Groves <John@Groves.net>
> 
> Clear holder_ops before holder_data so that a concurrent fs_dax_get()
> cannot have its newly installed holder_ops overwritten. cmpxchg()
> provides release ordering on weakly-ordered architectures, ensuring the
> WRITE_ONCE(holder_ops, NULL) store is visible to any CPU that observes
> the holder_data release.
> 
> Add a WARN_ON() that fires only when the cmpxchg observes a non-NULL
> value that is not @holder, i.e. fs_put_dax() called by something that
> is not the current holder. That is an API contract violation; the
> WARN_ON() does not prevent the damage but makes the bug visible.
> 
> A NULL cmpxchg result is deliberately tolerated: kill_dax() clears
> holder_data while a holder is still attached when a device is removed
> out from under a mounted filesystem (after delivering MF_MEM_PRE_REMOVE).
> The holder's subsequent fs_put_dax() - e.g. xfs_free_buftarg() after a
> forced shutdown - then legitimately finds holder_data already NULL, so
> warning on that case would turn supported device removal into a splat
> (or a panic with panic_on_warn).
> 
> Also add a kerneldoc comment documenting that fs_put_dax() must only
> be called by the current holder.
> 
> Fixes: eec38f5d86d27 ("dax: Add fs_dax_get() func to prepare dax for fs-dax usage")
> Signed-off-by: John Groves <john@groves.net>
> ---
>  drivers/dax/super.c | 42 +++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 39 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> index 25cf99dd9360b..96f778dcde50b 100644
> --- a/drivers/dax/super.c
> +++ b/drivers/dax/super.c
> @@ -116,11 +116,47 @@ EXPORT_SYMBOL_GPL(fs_dax_get_by_bdev);
>  
>  #if IS_ENABLED(CONFIG_FS_DAX)
>  
> +/**
> + * fs_put_dax() - release holder ownership of a dax_device
> + * @dax_dev: dax device to release (may be NULL)
> + * @holder: the holder pointer previously passed to fs_dax_get() or
> + *          fs_dax_get_by_bdev(); must match exactly, as it is used
> + *          in a cmpxchg to atomically release ownership
> + *
> + * Must only be called by the current holder. Clears holder_ops before
> + * holder_data to avoid a race where a concurrent fs_dax_get() could have
> + * its newly installed holder_ops overwritten.
> + */
>  void fs_put_dax(struct dax_device *dax_dev, void *holder)
>  {
> -	if (dax_dev && holder &&
> -	    cmpxchg(&dax_dev->holder_data, holder, NULL) == holder)
> -		dax_dev->holder_ops = NULL;
> +	if (dax_dev && holder) {
> +		void *prev;
> +
> +		/*
> +		 * Clear holder_ops before releasing holder_data. A concurrent
> +		 * dax_holder_notify_failure() that sees NULL ops returns
> +		 * -EOPNOTSUPP cleanly. A concurrent fs_dax_get() that acquires
> +		 * holder_data after the cmpxchg below is guaranteed to observe
> +		 * holder_ops=NULL first (cmpxchg provides release ordering), so
> +		 * its subsequent store of new ops will not be overwritten.
> +		 */

This isn't guaranteed today. dax-holder_notify_failure() reads
dax_dev->holder_ops twice without READ_ONCE(). With your WRITE_ONCE()
racing in between, the second read "dax_dev->holder_ops->notify_failure()" can
return NULL and result in NULL deref, so the "see NULL cleanly" property the comment relies
on doesn't hold.

Or reading it once into a local would make it tru
"""
const struct dax_holder_operations *ops = READ_ONCE(dax_dev->holder_ops);

if (!ops)
	return -EOPNOTSUPP;
rc = ops->notify_failure(dax_dev, off, len, mf_flags);
"""

What do you think ?

--Richard


> +		WRITE_ONCE(dax_dev->holder_ops, NULL);
> +		prev = cmpxchg(&dax_dev->holder_data, holder, NULL);
> +
> +		/*
> +		 * prev == holder: normal release.
> +		 * prev == NULL:   already released by kill_dax() when the
> +		 *                 device was removed under a live holder;
> +		 *                 not a bug.
> +		 * prev != holder (non-NULL): fs_put_dax() called by something
> +		 *                 that is not the current holder; an API
> +		 *                 contract violation. A lock would be needed
> +		 *                 to guard against this, but we WARN_ON()
> +		 *                 instead since violating the contract is
> +		 *                 a bug.
> +		 */
> +		WARN_ON(prev && prev != holder);
> +	}
>  	put_dax(dax_dev);
>  }
>  EXPORT_SYMBOL_GPL(fs_put_dax);
> -- 
> 2.53.0
> 
> 
> 

Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012016.outbound.protection.outlook.com [52.101.43.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB2E3257452
	for <nvdimm@lists.linux.dev>; Mon,  8 Jun 2026 10:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780915710; cv=fail; b=TR8I/7vH+pTItnr4bPXTmxgWAvtGZSd0x4Gto8pJffgPjCCiQU+soFlrUj5NyeQvKNGLUbf66Imd928wk2GEbqmXfe7MHUKWDKCzk+s49KXg4cRvyEa9uut+PSzGML61M3Lb8aH5vlihNJacq8/HCzNkBQshPQgu1W0AgPh65gs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780915710; c=relaxed/simple;
	bh=kW6MCpLNZ+E+c79grj7wyTgZ6lyP35x80zW9HKsR+og=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=cevm9KCjJVxrRW+P3FCPEdVdYr8A8DEBGzNIAwbkYBKpDyJsfksYC7UCluOovoVsje9+KRPc+C07M2vPAUHaiS1z2RyWaCN+9o0QW4fEZmLqNYXmJNgYcYgAz2Q1QKjk1zSCkm9CzpyYIzEfK+DQCcooa8klyHJMQ/Jw+OkByCM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=CnJhCLgh; arc=fail smtp.client-ip=52.101.43.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="CnJhCLgh"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y3T8tTxtvqzVHPW383o6FePbGzJGzBD9ix0eIwgUTVn4QFkoyh85u04FJAwkvswEoYjhkTw5fYPZQkzIDZrhAnhM/h/TuzBm087qja6qlCbJ3Nvf0gv/+DmXZ5HYbq00A8TsWci/pGidBydfCdbrBbd5NVDH+giCPfETvMNMne/4QtWIJIme5+ZPVqeZFjhuXErEFbn6hRPm12ZMzEK3L2NGwrDB2/SN8O6pWVn0nivfMp+KMEbUr7pbLbTx7UGocnjqtFfNYUbB/x9SuoaU/tEgNGepOxga6DwXdxIZ0Zs2Vau7Qvs1FBF85ORfNj0VPOwB6StTWrldzFHDaUITwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BGhdsvTr1/zoQ5y2CYs69Cj1p7gAj2/I5gyWczhUvyE=;
 b=A2vj58rSMrNgS5yaTyBj8yLLXOod+lgqbldhqdxC5GNwyLYhkPUfcB+igZRVzDUdsXxJgAb7aW/ILAt+GyVKOOqGdNBkPK6eJ31t2nR82i5i2MdwNYgfcFKJjErHHzRXFn5Z1SAIsiV/PsJQK1R5YizVnaoDpx3D+ksOO7MPpBHSbCj8DoZaPPfnFZgcdcUR5RoxeJagYflJ7h2gpKeAsPkOdDzDi+A9SRGU3yJdsvKvF5lqmFbIqoexdRhqL0i7BErMjs9tMqg7qx1iJivSJ51avna9dggEBPtI4tFAjNmg+R7isjQMjN5caZpTd9FoQZohAyI43Do0+fFnLRYIPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BGhdsvTr1/zoQ5y2CYs69Cj1p7gAj2/I5gyWczhUvyE=;
 b=CnJhCLghnBXnVa9qFfpN1qaB5wBC+7KC7b8atAUyN0PTvKQZfVdpvqkntbCmyn+BrozYst0V49NVgmG6lK5QjcrjBqP0JIGq2trh8ZhZr/pjSxU4DNrdaCIKSfRSfQEk6Bd2MDTM5LssUdPUwJFFCmlJNm0JRF/L8GeXl2lSCXqOCpQiDAnFT3VuPoCH00FAv4ZyzOlF/v4P2Hw+bKm/H8jnRj6MKnGyT8NOG4p8xdwW0Sf45zLd0JUx4EYqnc8YySTL2gveOH6jjS29m7AuvEF3l3gh4h9PGWN6jV6fjXDCSxF1oU3FnWPHLvvcrICYeKnOgsjAQr+4mzWkwP/eyw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB2370.namprd12.prod.outlook.com (2603:10b6:207:47::27)
 by IA0PR12MB9010.namprd12.prod.outlook.com (2603:10b6:208:48e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.13; Mon, 8 Jun 2026
 10:48:24 +0000
Received: from BL0PR12MB2370.namprd12.prod.outlook.com
 ([fe80::86cf:c3ec:2cf5:74c8]) by BL0PR12MB2370.namprd12.prod.outlook.com
 ([fe80::86cf:c3ec:2cf5:74c8%5]) with mapi id 15.21.0092.011; Mon, 8 Jun 2026
 10:48:24 +0000
Date: Mon, 8 Jun 2026 18:48:16 +0800
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
Subject: Re: [PATCH V4 8/9] dax: replace exported dax_dev_get() with
 non-allocating dax_dev_find()
Message-ID: <aiadcHb-9y-p0GoC@MWDK4CY14F>
References: <0100019ea3929225-a0f8e6f7-30ae-4f8e-ae6f-19129666c4c3-000000@email.amazonses.com>
 <20260607193416.94407-1-john@jagalactic.com>
 <0100019ea3943a9d-3724a539-97c6-46f9-a3bb-c7b9a51d3889-000000@email.amazonses.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0100019ea3943a9d-3724a539-97c6-46f9-a3bb-c7b9a51d3889-000000@email.amazonses.com>
X-ClientProxiedBy: KUZPR01CA0028.apcprd01.prod.exchangelabs.com
 (2603:1096:d10:26::13) To BL0PR12MB2370.namprd12.prod.outlook.com
 (2603:10b6:207:47::27)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR12MB2370:EE_|IA0PR12MB9010:EE_
X-MS-Office365-Filtering-Correlation-Id: 97238dcd-1e14-48d9-9522-08dec54b76b7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|18002099003|22082099003|4143699003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	RtLQDdoizQUfJaqq2fXWohFOJinAUmdxyZPzNCYYXsHn7of1V3IOX7ycJUDVREnre74i/dU5qUhRC7gg7MFXTJOclc5hvcZHnh/YD6+9a0lSZPukHmo9+jw6WUbgnSIqROV4CetjnRAv5L4r8X/NeiJPXg+oVCGMsDAijiyxeAPFkdy6uJfwTEdaQoyyZYXCTLUSNmXhM1I+nwV4xyxgAWIi9hPJQQwdHVrL3uLyjxHONx82E0v2/7df0i9t8GInDpAOxHKG9gup0+5DdxQ5GJUJ6T/2Pdz89WuEH9jgyqYaG1U755+GCKn7br9PGAqpPrUyzlOw1IepXMW6b4rTHkL2idBBpfB4cwhr1ReQrbBr9t3b94kcttoAO6j9G9IGg5JalJUo612BMhyhzzRw+hmpxxWO1VO6RdW/R5/jpqQrK+Mghq7m93ocSJCsOvTy7OEz6DDkQaCcYnJAbdPy9GgJtKYevJ5sXmDl303+9k7ooj5ucg5Hhk6bYH2OBw1p8n5au+mCISwloUI0opPY252m0Ey+rrFzzfEG/BpnyoFt1nucyb5y4ZISkhOlQb+tDUP6oMZE4AkOhlJPTYa07eLwL9qQCJiEdDyAYI31Kt7vtRnzTGGsBs2UPx6bzACriJc3b5plANeUdkFEzIyd8Ha0spj2LQkTvSdIg/lx2IHBSbwcI+MtM8Ddjq1gPkzQ
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB2370.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(18002099003)(22082099003)(4143699003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?clp0R2pzTDVZNXZoQzV3dFZxZHBONndsdGYvMld4Y25ORjhUUktEeVhodkVH?=
 =?utf-8?B?V0IzVFR0UEtsM2JmT3VZMFkxK0laK2Z1b0N6VVZEZXU3eHh2aCt4RWFVNEZt?=
 =?utf-8?B?QndBYk5yeHgwSTdmY0ZOd2NFbEtyb0ZWanh4OTF3cTZRa0w4WGkvQ3hhcEM3?=
 =?utf-8?B?TGt5eEE2YXlhWVJNcTh1S3Y4YzNyVjBrV2Y2YTdGNEF0K29Lem5BblZGeXZt?=
 =?utf-8?B?b3Ria2Q0d3dJck90YVhhdmdWM3NOOGRob1pRZVBmMGw0bjMvOXdyNkhiY2Fr?=
 =?utf-8?B?aldjSHVmdzdVSlY1NXZweDdMZ3lSMDc1MXhzOW9ZYWg1RGVsYlExZDFidHNR?=
 =?utf-8?B?N2JLV2RUY2xJSlRyUHQ4OTVZSXdId2ZHbmdsekNFR0pDckU5NzYzZzNpYUdi?=
 =?utf-8?B?ZjhRRTMwQjVGNUNLcHVEc2l1YlBUNzRyUHA2NGlDZktPTlNFU3lvdS8wWU9R?=
 =?utf-8?B?L3p6eUNCK2R1ck5kSjkyNWZQQ014b3Z6cmRITGIxSzNPRXJ6eldFZTY2VThV?=
 =?utf-8?B?Y0t2S3lGNEZHb3lRK3VaV2cvQVVaQ2lNcGR0OEgzd2tlaW5mdkVEd3Y5Wnpq?=
 =?utf-8?B?WWJtN1B4bkNQbWluWkUzaDZOL1c3T2R1amd6Y0JXcVB3UklwQmdCVFZQWHFz?=
 =?utf-8?B?VnVqckxvN2U2WFZHUXE2VFNzdzFXZWh6NS9CL3pQQjY2ZjVNdXNVdThWbUZm?=
 =?utf-8?B?bTUzOGI2MldrbU4xUGUyOWZYd1VJMTBxYlBSYjV4VkRxc0FUQ1V1RDVkZ1VY?=
 =?utf-8?B?OVVkU0phWHlZcWpyUlVIdTM2bHl0NFZDUytzaHVaRFVnaHRFTnV3bFEwMXpq?=
 =?utf-8?B?c0JpMkU3bW5aOEFyVGh6OXhRS3FVQTM3OElyM2QwUTh5RExUVkFrWFk0YWcx?=
 =?utf-8?B?U1JEeWo3b3RERVd6cDNrWGNoSzRnTW9CWXVteXpDYTY2Z29NTTgrYlM1cU15?=
 =?utf-8?B?R1BINzNHaDQzQTcwQ1VwMkFoUjlCbG1XYjZaMDk5K0g4YnI1ak5tRlVJSHM5?=
 =?utf-8?B?bGFwZXV5cjJscU1Uclk2aUg4SzlTZGNkNE1aOWdCWko3QUkwZFJSUE9jMjl2?=
 =?utf-8?B?QUZ5dmNDczMwU01tblE1anFqaVZNSmxORnUxU2N1MVl0U0FGVHdaRDdoSVpW?=
 =?utf-8?B?R2s1c3o0Z1BQZi9YaWxQYnFXWEV6a2pGdk5YSnFGcDczcnJNRVpKMkQ5RGpZ?=
 =?utf-8?B?MEg5RDRwQmx4THpHdXJBcXhya040UUllS0FVRlVVcytseHd1MjJNY2NzQnAv?=
 =?utf-8?B?M1EzODVkTllGY05aaGJ1TGpVZmxVcTNKZGcrc3QyVDROcDZIcG5VTmYvdUhW?=
 =?utf-8?B?WWJVbXVKVENaazIrdktJRUV6R3JJcnJmcVV5RWFMWHZQTUpaTWhNeGxUQnBw?=
 =?utf-8?B?Q2N3KzlIdWI3OVRwV2VJanViNWswMlRvZ043ZHZwNm9ZY2VYYTZuaVNUenFG?=
 =?utf-8?B?cXJUa1hBR0lFelVVaXA0OHZXdHlKR1d5WmxrVEJoTXZ4NkR1d0gwQ2tqNUNS?=
 =?utf-8?B?cVA3RXJNMFExMFQrdllrWHdmSXVDWE5kcFEvRXFlYTR5b3ZRcDZlQnB0TWMw?=
 =?utf-8?B?RnpZUWdyUlBBK0toOSs5QUpWWnFOS2wxTEhFckNpTFJCTU1Cc1k0bGFnOVY5?=
 =?utf-8?B?bjF2ZlJHV0xuN1lwZmRrRTFmaTVlT1VsZ2ZhRHdZMStibXB6RkNMeFdVa0R1?=
 =?utf-8?B?NGRrY0FBeXVpTkVyVXVhdGZEVWRjK2ZHNk5ZQU5wWjJadVFwRHUzZDdiN1lr?=
 =?utf-8?B?bkc1c2FzYWRTMnBnQXBqbnBHUHhMdDJrTFg5TXBYNnkxZ3VRUVF1THBsaC9F?=
 =?utf-8?B?RjFRUmVCTXUrbnFvZTV2VURWRk5IcDJJcXoyZXVFUkVzTndlS3FXanJDY0Jx?=
 =?utf-8?B?ZGxOQmNRMTZXRkJENEJ5bGFEY1UvNndBd3Mwcno4eVJNODRjSHk2bXFXMXV4?=
 =?utf-8?B?OFBlYnNSU3NZaHQ0akJxb09kQ1R1MDh4elVFdW83Q3RpbTBRUzZEbllJdVRM?=
 =?utf-8?B?M3YzbFZMOWMzRHJra3FuNzVLdk14MjN5alFva2N6ZkV1TTBsaDVlZmdkUzFl?=
 =?utf-8?B?Sko5d2FKdnd4LzREcEI4QUtsZDhZSHdGdjFxcDlMS3VnWkVLWjhiaWsxbFFO?=
 =?utf-8?B?b0kwUUxXMVhKd0JyUkxtckhnZE44RGtzNCtEcFZ4bVdDOHFJSjN5Zjhta2x5?=
 =?utf-8?B?MW91Zm0wSGwxU2Y4cmplR1pleEFhc1psVjBMYkcwSWN1NjhlOWJSRitwRW5L?=
 =?utf-8?B?bjhHc3BvR1Zlb3ZNY0NCbU9vZ011QW5nTWJ5ODZSWDE3bE5yUCtCS3M4aHoz?=
 =?utf-8?B?N2RtYlB0a3B3RkVNTUZzTUZMTUVkbHMxMEJ4NDNZMk1VSHkydWdaUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97238dcd-1e14-48d9-9522-08dec54b76b7
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB2370.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2026 10:48:24.2211
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4A+u1OyO7F6DLPWri4bL9BAbcE+F5hIAJzP8mXI1PMV+XG9KqB2EmwZx99liUj/QTHlobGJfly4U+YwHFMLwkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB9010

On Sun, Jun 07, 2026 at 07:34:21PM +0800, John Groves wrote:
> From: John Groves <John@Groves.net>
> 
> This fix is in response to a Sashiko review, and some subsequent
> analysis.
> 
> dax_dev_get() uses iget5_locked() which creates a new inode if no
> matching one exists. This is correct for the internal caller
> (alloc_dax), but dangerous for external callers that look up devices
> from user-supplied or metadata-supplied dev_t values:
> 
> 1. A new inode is created with DAXDEV_ALIVE set but no backing driver,
>    no ops, and no IDA-allocated minor number.
> 
> 2. On teardown, dax_destroy_inode() warns because kill_dax() was never
>    called, and dax_free_inode() calls ida_free() for a minor that was
>    never ida_alloc'd -- potentially freeing the minor of a real device.
> 
> Add dax_dev_find() which uses ilookup5() for lookup-only semantics:
> it returns an existing dax_device with an elevated inode reference, or
> NULL if no device with the given dev_t exists. It never creates inodes.
> A dax_alive() check under dax_read_lock() guards against returning a
> device that is concurrently being torn down by kill_dax().
> 
> Make dax_dev_get() static again (internal to super.c for alloc_dax),
> export dax_dev_find() instead, and update the two external callers
> (famfs_inode.c, famfs.c). Also add the missing CONFIG_DAX=n stub.
> 
> About the 'fixes' tag: this removes the export of dax_dev_get(),
> which was flawed, and replaces is with dax_dev_find(). It feels like
> the fixes tag makes sense for correcting an ABI error.
> 
> Fixes: 2ae624d5a555d ("dax: export dax_dev_get()")
> 
> Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> Reviewed-by: Alison Schofield <alison.schofield@intel.com>
> Signed-off-by: John Groves <john@groves.net>
> ---
>  drivers/dax/super.c | 38 ++++++++++++++++++++++++++++++++++++--
>  include/linux/dax.h |  6 +++++-
>  2 files changed, 41 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> index 96f778dcde50b..b37ae79c084bb 100644
> --- a/drivers/dax/super.c
> +++ b/drivers/dax/super.c
> @@ -557,7 +557,7 @@ static int dax_set(struct inode *inode, void *data)
>  	return 0;
>  }
>  
> -struct dax_device *dax_dev_get(dev_t devt)
> +static struct dax_device *dax_dev_get(dev_t devt)
>  {
>  	struct dax_device *dax_dev;
>  	struct inode *inode;
> @@ -580,7 +580,41 @@ struct dax_device *dax_dev_get(dev_t devt)
>  
>  	return dax_dev;
>  }
> -EXPORT_SYMBOL_GPL(dax_dev_get);
> +
> +/**
> + * dax_dev_find - look up an existing dax_device by dev_t
> + * @devt: the device number to find
> + *
> + * Returns a dax_device with an elevated inode reference, or NULL if no
> + * device with the given dev_t exists. Unlike dax_dev_get(), this never
> + * allocates a new inode — it is safe for external callers that are looking
> + * up devices from user-supplied or metadata-supplied dev_t values.
> + *
> + * Caller must put_dax() the returned device when done.
> + */
> +struct dax_device *dax_dev_find(dev_t devt)
> +{
> +	struct dax_device *dax_dev;
> +	struct inode *inode;
> +	int id;
> +
> +	inode = ilookup5(dax_superblock, hash_32(devt + DAXFS_MAGIC, 31),
> +			 dax_test, &devt);
> +	if (!inode)
> +		return NULL;
> +
> +	dax_dev = to_dax_dev(inode);
> +	id = dax_read_lock();
> +	if (!dax_alive(dax_dev)) {
> +		dax_read_unlock(id);
> +		iput(inode);
> +		return NULL;
> +	}
> +	dax_read_unlock(id);
> +
> +	return dax_dev;
> +}
> +EXPORT_SYMBOL_GPL(dax_dev_find);
>

For now I see no in-tree caller of this function, the famfs users you mention doesn't
exists yet. Cloud the dax_dev_find() addition+export go with the famfs series that
actually uses it, and this patch just do the dax_dev_get() de-export ?

--Richard
  
>  struct dax_device *alloc_dax(void *private, const struct dax_operations *ops)
>  {
> diff --git a/include/linux/dax.h b/include/linux/dax.h
> index fe6c3ded1b50f..29113eb95e72d 100644
> --- a/include/linux/dax.h
> +++ b/include/linux/dax.h
> @@ -54,7 +54,7 @@ struct dax_device *alloc_dax(void *private, const struct dax_operations *ops);
>  void *dax_holder(struct dax_device *dax_dev);
>  void put_dax(struct dax_device *dax_dev);
>  void kill_dax(struct dax_device *dax_dev);
> -struct dax_device *dax_dev_get(dev_t devt);
> +struct dax_device *dax_dev_find(dev_t devt);
>  void dax_write_cache(struct dax_device *dax_dev, bool wc);
>  bool dax_write_cache_enabled(struct dax_device *dax_dev);
>  bool dax_synchronous(struct dax_device *dax_dev);
> @@ -92,6 +92,10 @@ static inline void put_dax(struct dax_device *dax_dev)
>  static inline void kill_dax(struct dax_device *dax_dev)
>  {
>  }
> +static inline struct dax_device *dax_dev_find(dev_t devt)
> +{
> +	return NULL;
> +}
>  static inline void dax_write_cache(struct dax_device *dax_dev, bool wc)
>  {
>  }
> -- 
> 2.53.0
> 
> 
> 

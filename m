Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013023.outbound.protection.outlook.com [40.107.201.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 888E8472096
	for <nvdimm@lists.linux.dev>; Thu,  8 Oct 2026 08:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.23
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791449919; cv=fail; b=m3WKK+rxbNoN+jDZqGD5545jJyzbQR24QHdgooK9KIOaEat8OK+CFh2bChI4BlzZbzFCddkgK0/m4/gLoBeRNOkEbVFTv/E9s5PHUS9E0OJrN1vKHoKiff1vfzx8BfykHBrBiFnCW4114BTYnh+jICYSprgwdjXIYaWMNLyYkNI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791449919; c=relaxed/simple;
	bh=qJhs44MvWqBvCMdRGWLYFA0ovI+NsCLo0kq/g/hG71Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=SkFn5iEQcfG4Cd7TjouE6SFNh6FaEMSCOkgZMSva0Dysb/Wu6dfhY23GnH4G1WmbclRGZNNdQ5SW8yVY5fkiqrCVzwII3hheXPqML5O2SeFtOTVT+NxV2PizUvXNp58rhVUMSrfo03aSYI6bvE+UF82Ej04M4Yt0k/T116kY04g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=BmqpY1ve; arc=fail smtp.client-ip=40.107.201.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="BmqpY1ve"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SCKTAdSKptF82yfgiDgoOrulK7XtgqCTz7moSkMXXqtTBxWZbSkDjpOt1RPVfTD8WhYqM6EWmOEnMbtvPqijmg02+H1fJnE0arGvNEB3NlvEkvgbsOmBfpC82t6vKu18LtqDn4FnJBNhuMNK+4afJlGAXonLoXqpCR3cJlgESTGj30yz/iza9E+edX6/OMWxeVq7DBcaBMBpFYiHFfgg40fy/hgKlF7C3YJmPQFAmm7VoUuyequ7yUVCvic5kMdi61YFf22QC8LcXQlV8iQR7H6b7jO8D2s/ZMpY55Mtvfk/aZqZWqnGp1Kf29BO/KD6drRAjS68FavJTezPy/d+GQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LuEWaeTzwxvSqElNQq1g/uNlj87kovOyqWLj6r4ujyk=;
 b=yiCkKQD3k7U9MPR0AKDztchMiVUxbRf+A135OSW24BzEmObdSuUoSH4mmJgD4Qc+8RyJOH7BtXy9VvpAXK8cAvTYF9shXPTDZS71F1cKTJWaHKOqLkAOHoRav3zydTBJrJlnpY1f+cp+cS0Pan4Ht4Qjlq4Is2FKXPwQD/6lSQ+ErqAhAZTKYuTvYZJNAw3ssUBoQdtTkxCe+uZrhA/rvbFCBGN4Uqi4sy6JOVo5J5rqsAKg13Nb0d0XLEXoTSfwrtLDdu3zHzr0Ez9975/Dvj3JJkIAhufPap0Tf98h9pn7TJHZu+eCaqhchRLTfb33ywRn6z2U8z85zngCih7xAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LuEWaeTzwxvSqElNQq1g/uNlj87kovOyqWLj6r4ujyk=;
 b=BmqpY1veXNtGWq/NXMckSuEws/uZeU2v17g4h5j8GbrEnbEMmvFjupqhOfmsgmjX0KNcjQaC54kzKHq73gUNrnxc3zKcWTpqD8PxDyyhu52lKLvmlCWrh9k43tx1LnbU+AcACBz0fJL4TgAmR1ieoB/rtGz4TjxpvU5Xxgw0LnjUU8hc1S/AkZikZ/IY4ylwfrlN0WO5J4djhjwBthf6loYrmzFjQluqNQIsh6IXqztiqN6CikRoFsoWsIOSpsrh0dFGU5meTBlNciU+UywanKUrYgFdHF4mdPs408Ljpd8ex0Xm2Z+6aFnwUIBE3ho29PCbxaGe1zDagc0ENb4aOA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB2370.namprd12.prod.outlook.com (2603:10b6:207:47::27)
 by SA3PR12MB7879.namprd12.prod.outlook.com (2603:10b6:806:306::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.17; Thu, 8 Oct
 2026 08:58:33 +0000
Received: from BL0PR12MB2370.namprd12.prod.outlook.com
 ([fe80::86cf:c3ec:2cf5:74c8]) by BL0PR12MB2370.namprd12.prod.outlook.com
 ([fe80::86cf:c3ec:2cf5:74c8%5]) with mapi id 15.21.0496.010; Thu, 8 Oct 2026
 08:58:33 +0000
Date: Thu, 8 Oct 2026 16:58:28 +0800
From: Richard Cheng <icheng@nvidia.com>
To: Anisa Su <anisa.su887@gmail.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Dan Williams <djbw@kernel.org>, 
	Dave Jiang <dave.jiang@intel.com>, Alison Schofield <alison.schofield@intel.com>, 
	Jonathan Cameron <jic23@kernel.org>, Davidlohr Bueso <dave@stgolabs.net>, 
	Ira Weiny <iweiny@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>, 
	Fan Ni <nifan.cxl@gmail.com>, Li Ming <ming.li@zohomail.com>, 
	Benjamin Cheatham <benjamin.cheatham@amd.com>, Gregory Price <gourry@gourry.net>, 
	Anisa Su <anisa.su@samsung.com>
Subject: Re: [PATCH v15 6/8] cxl/mem: Configure dynamic capacity interrupts
Message-ID: <asdaKGr4Rpwz4nih@MWDK4CY14F>
References: <20261007201828.952-1-anisa.su@samsung.com>
 <20261007201828.952-7-anisa.su@samsung.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261007201828.952-7-anisa.su@samsung.com>
X-ClientProxiedBy: TP0P295CA0036.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:910:4::15) To BL0PR12MB2370.namprd12.prod.outlook.com
 (2603:10b6:207:47::27)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR12MB2370:EE_|SA3PR12MB7879:EE_
X-MS-Office365-Filtering-Correlation-Id: 34f3f5b9-c7bf-40e6-1f25-08df251a5496
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|1800799024|366016|6133799003|22082099003|18002099003|10067099003|3023799007|11063799006|4143699003|56012099006;
X-Microsoft-Antispam-Message-Info:
	k6XYckZD7E33Kx9RqMkYSGlJ44hEZy7SZg5OPKw1/GCvvvG1acc0vwj/ojr2RhIAWnRwV7CmGaIQjQTDOyjpspknMLWoyJ6YgaBm/4gQ6juHHHoAyVBiChOF/vEuvRS+xfomwu7NUZN1vV0ANecYGazZPnCrUW9eWAnTqJqN5Umdj7fmNjCjftBizn0jr41JOyPUo1fQarOsI9ooq0hGPeggHab6RvwrdYo0LRy7FPgz8hUE9kfLPGmcoQenh/QfjYkdnwlYOb7qYCMQq6KR5SQR/fqUZm8a+qDIHMazAY1rYPGNYynDCiSXR2UN69Ua7dMz8XXzIYrgx7VqNbDx+7Zq5jlmoSXq0V52wEWpU0FebDrcUgpG89qDVeGnG/YDHjaZAapjXWv/BvCTw4zwpsgFrUxxWr/ANV8yJRTgv1gMa7IGft+8q4YNQTaoeJv3OJuJ7c6cvfrWFM6fFZKhBKk3wTpnexG6jcc0AEr5LHghikSmOn3/t1n5ObC34YFW+F1wm85Jvt2XF97RMGQxy0+wATi4Gmm4wEqjC7vkOikuBEPSPimD2zK8pB2sZtcfA/EKDzh4auRaSiPlXzyMvnHROg61IA9iruYPvpKQSYoTpqmwBvNRHG8RxV9XE7ANzwkOD7yT0vwlyyf3sGZ+iIzoZqRa1wYRlyuKWmCArC4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB2370.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(1800799024)(366016)(6133799003)(22082099003)(18002099003)(10067099003)(3023799007)(11063799006)(4143699003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?oRfpSvJ+E/WzR4HgOAD9AcbA0YidurkKX3DA2jgYyIxf7plKMcQEeytlA6Hq?=
 =?us-ascii?Q?lth3auK99fXRqLfYhIy08M3QL3fem/kmgSXPY2NLIJvqbpzaEC/DDh7LT9MV?=
 =?us-ascii?Q?kp4j+E2vzmYdzAoPD8xO6LiXCUltospkI6Lv3SJwjmICbe6M/mz0Apw+Bzlf?=
 =?us-ascii?Q?md6bSJGpG7hHtEEMzs2NooFAZ/KSeosqpjWqw1Q85EG5yVAdqOOyMMKIizYt?=
 =?us-ascii?Q?6mTuV+qiuFfF3hS/uNG0+c7eXlr0SlGzL06ez6hADct9MSfAv98h0Pnj8fgI?=
 =?us-ascii?Q?xUV7ga/PX3zn5jpeM8Fygt+Bts0JC6m/8eKHqkhvO7CTs5ukEmVGP0LI01n3?=
 =?us-ascii?Q?Rd+qe4dItskqIRHIhPGq+g/gaB0gaRixAcNWYQBYjaqBi8DUJ66G5Tt/jDS+?=
 =?us-ascii?Q?0wYxAQ4q/qVr2GpGqIb/r/troPGjM7LETlocdlVc2Xk9GWVOKCMyc7eB6odK?=
 =?us-ascii?Q?wgFvleqKgBD1GVQ9CIugQvcawmyUdRSMRv/DIaZuASNaQ4PXBqq7zw/OFgqw?=
 =?us-ascii?Q?+5gQkbEF4QLGXMPGrKM0l8T8IJQXT7aLMvY3bPsq9xDb/+LDeL3FBHib804P?=
 =?us-ascii?Q?e9fv3gEUPsNpUIeVn0n+yOEXGfTcSTqnvZ2RJpKv85lE8usbxaDhwlI7bK8G?=
 =?us-ascii?Q?LwOq2iV9Hc2JubpA9CYh/5LbfCg5Xqnd9nEM/kyy16YZMXS8wz5qzLiZ72t2?=
 =?us-ascii?Q?uXZl+vTvC1XPJ2SHMLPjniREdA7pgJsSS+mcvvVmkBJwOc+PFO6NYP7fzJpf?=
 =?us-ascii?Q?1KHG2A+jwymb3R+4edA6INikQQKT9lswcTFwZF6LQdhBoVwHXxigFl8XzFi+?=
 =?us-ascii?Q?WWKlezkshMTjuo7CaM+ZMjRqWLz8CPzjx63xMtLiOWmjrwa4LYkGwOL7oM+c?=
 =?us-ascii?Q?oEHmsYxcBzQPzOJ15Z3xH5HBORmZsUGoxL0WI+W7bZAEtN/HGmVanaB+xGL1?=
 =?us-ascii?Q?/HR1anzZzE1C9elVBlmoCRna4VWl0XZDIYxMuIHae+TXdghLaVYgZg39/aqn?=
 =?us-ascii?Q?AgLJwBNhnLEelDrYyl9tQoiyaEdQA/UrGaayOv4MB7rOdJyEEwlKk379gsRD?=
 =?us-ascii?Q?W2UOlbMAYRa5l1QnZA8m9w7evCOexIeifiXQ/EmIRfTItDrJotf/KjjJuap3?=
 =?us-ascii?Q?ydV9WXbwbto12MlnuhiYZXgSaw2xEdcc42+td8KBDtCARlB4ZyRIczDIF9YO?=
 =?us-ascii?Q?VYjtxNHXlyiYSdwTOgy74oOvh7oLsW4j6s47oCPsUO+e6jCt40GEzxWqS2pC?=
 =?us-ascii?Q?eJB5ZBrOwtvkqKgzzAI9zTs+O2ohfwGeUoXayfPGYPPJUL3KK1wLLzrV43Wr?=
 =?us-ascii?Q?qF3QLXfmN+gB+1iDeIXmwhLIY4TBnQ3OQATaw0UVvYbkscD3nMS2ixafo668?=
 =?us-ascii?Q?Wh+caI08lCzQQRUsA+sK6vLzO5W3S3yNjIX/DHr9XNtbK/xUo1X+fxj8IMF5?=
 =?us-ascii?Q?6dN1n4L4W+ayBCwPBclUyJdwgBCSTnBmfmzP8/xkXB0hmz5TpmqWwP/Q8L95?=
 =?us-ascii?Q?+TtMIo6wZTPcwi/Ih+IHMIpEKZ3LhunnBE3ajauZtpV9JnwmDnWM9EZULAuC?=
 =?us-ascii?Q?fx5M1mRM2ZANE27zinH1K2QicmlF1iK8S1w5dQAPHmi1GhcdlaajyBkNGgez?=
 =?us-ascii?Q?gug9fw+mXV2UKUcYVbevv7xFQghOwdCYiKXyuCnZxHYOT3+LJGSvNpH6/Q9T?=
 =?us-ascii?Q?5Qiar4FFQFDawNwCRChcB4CabG2hH7wnfks6g3RmhiSYzyE8A/PpEl/2k9SN?=
 =?us-ascii?Q?IyjDmNbT2A=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34f3f5b9-c7bf-40e6-1f25-08df251a5496
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB2370.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2026 08:58:33.1495
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E1EvN3YkQ+Wnph1/urwxSpGJXEW4Kv7QkcOyBtvDfCnKkjm+yF7nVgtZswWKLArCPrYd0B25GbTQEI093pPsWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7879

On Wed, Oct 07, 2026 at 01:16:39PM +0800, Anisa Su wrote:
> From: Ira Weiny <iweiny@kernel.org>
> 
> Dynamic Capacity Devices (DCD) support extent change notifications
> through the event log mechanism. The interrupt mailbox commands were
> extended in CXL 3.1 to support these notifications. Firmware can't
> configure DCD events to be FW controlled but can retain control of
> memory events.
> 
> Configure DCD event log interrupts on devices supporting dynamic
> capacity. Disable DCD if interrupts are not supported.
> 
> The DCD event log is not drained here. cxl_event_drain_mask() reports
> only the logs the driver can service, and the DCD bit is added by
> the patch introducing DCD event handling. Until then a DCD interrupt
> wakes the event thread, which finds no log it owns and returns.
> 
> Care is taken to preserve the interrupt policy set by the FW if FW first
> has been selected by the BIOS.
> 
> Based on an original patch by Navneet Singh.
> 
> Signed-off-by: Ira Weiny <iweiny@kernel.org>
> Co-developed-by: Anisa Su <anisa.su@samsung.com>
> Signed-off-by: Anisa Su <anisa.su@samsung.com>
> 
> ---
> Changes:
> 1. cxl.h: add CXLDEV_EVENT_STATUS_STANDARD_LOGS for the four logs whose
>    ownership follows native_cxl_error, and use it in
>    cxl_event_drain_mask() and the cxl_test mock instead of spelling the
>    mask out in both places.
>    [Dave, Richard, Jonathan]
> 2. On platforms where BIOS owns the event logs, a failed Get/Set Event
>    Interrupt Policy disables DCD instead of failing probe. Before DCD
>    this path never reached the mailbox there; now DCD is the only
>    reason it does, so its failure costs DCD, not the memdev.
>    [Sashiko]
> ---
>  drivers/cxl/cxl.h            |  14 ++--
>  drivers/cxl/cxlmem.h         |   2 +
>  drivers/cxl/pci.c            | 143 +++++++++++++++++++++++++++++------
>  tools/testing/cxl/test/mem.c |   2 +-
>  4 files changed, 133 insertions(+), 28 deletions(-)
> 
> diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
> index cab8ce39f465..15356d25369d 100644
> --- a/drivers/cxl/cxl.h
> +++ b/drivers/cxl/cxl.h
> @@ -192,11 +192,15 @@ static inline int ways_to_eiw(unsigned int ways, u8 *eiw)
>  #define CXLDEV_EVENT_STATUS_WARN		BIT(1)
>  #define CXLDEV_EVENT_STATUS_FAIL		BIT(2)
>  #define CXLDEV_EVENT_STATUS_FATAL		BIT(3)
> -
> -#define CXLDEV_EVENT_STATUS_ALL (CXLDEV_EVENT_STATUS_INFO |	\
> -				 CXLDEV_EVENT_STATUS_WARN |	\
> -				 CXLDEV_EVENT_STATUS_FAIL |	\
> -				 CXLDEV_EVENT_STATUS_FATAL)
> +#define CXLDEV_EVENT_STATUS_DCD			BIT(4)
> +/*
> + * Logs whose ownership follows native_cxl_error; the DCD log is always
> + * OS owned.
> + */
> +#define CXLDEV_EVENT_STATUS_STANDARD_LOGS	(CXLDEV_EVENT_STATUS_INFO | \
> +						 CXLDEV_EVENT_STATUS_WARN | \
> +						 CXLDEV_EVENT_STATUS_FAIL | \
> +						 CXLDEV_EVENT_STATUS_FATAL)
>  
>  /* CXL rev 3.0 section 8.2.9.2.4; Table 8-52 */
>  #define CXLDEV_EVENT_INT_MODE_MASK	GENMASK(1, 0)
> diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
> index 9fd5af2e41d4..9106affd7c81 100644
> --- a/drivers/cxl/cxlmem.h
> +++ b/drivers/cxl/cxlmem.h
> @@ -240,7 +240,9 @@ struct cxl_event_interrupt_policy {
>  	u8 warn_settings;
>  	u8 failure_settings;
>  	u8 fatal_settings;
> +	u8 dcd_settings;
>  } __packed;
> +#define CXL_EVENT_INT_POLICY_BASE_SIZE 4 /* info, warn, failure, fatal */
>  
>  /**
>   * struct cxl_event_state - Event log driver state
> diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
> index 7b754af2168d..d2bed92be30d 100644
> --- a/drivers/cxl/pci.c
> +++ b/drivers/cxl/pci.c
> @@ -510,11 +510,22 @@ static bool cxl_alloc_irq_vectors(struct pci_dev *pdev)
>  	return true;
>  }
>  
> +/* Event logs the driver drains: standard logs when native_cxl */
> +static u32 cxl_event_drain_mask(struct pci_host_bridge *host_bridge)
> +{
> +	if (host_bridge->native_cxl_error)
> +		return CXLDEV_EVENT_STATUS_STANDARD_LOGS;
> +	return 0;
> +}
> +
>  static irqreturn_t cxl_event_thread(int irq, void *id)
>  {
>  	struct cxl_dev_id *dev_id = id;
>  	struct cxl_dev_state *cxlds = dev_id->cxlds;
>  	struct cxl_memdev_state *mds = to_cxl_memdev_state(cxlds);
> +	struct pci_host_bridge *host_bridge =
> +		pci_find_host_bridge(to_pci_dev(cxlds->dev)->bus);
> +	u32 mask = cxl_event_drain_mask(host_bridge);
>  	u32 status;
>  
>  	do {
> @@ -523,8 +534,8 @@ static irqreturn_t cxl_event_thread(int irq, void *id)
>  		 * ignore the reserved upper 32 bits
>  		 */
>  		status = readl(cxlds->regs.status + CXLDEV_DEV_EVENT_STATUS_OFFSET);
> -		/* Ignore logs unknown to the driver */
> -		status &= CXLDEV_EVENT_STATUS_ALL;
> +		/* Ignore logs unknown to the driver or owned by BIOS */
> +		status &= mask;
>  		if (!status)
>  			break;
>  		cxl_mem_get_event_records(mds, status);
> @@ -551,42 +562,62 @@ static int cxl_event_req_irq(struct cxl_dev_state *cxlds, u8 setting)
>  }
>  
>  static int cxl_event_get_int_policy(struct cxl_memdev_state *mds,
> -				    struct cxl_event_interrupt_policy *policy)
> +				    struct cxl_event_interrupt_policy *policy,
> +				    size_t *policy_size)
>  {
>  	struct cxl_mailbox *cxl_mbox = &mds->cxlds.cxl_mbox;
>  	struct cxl_mbox_cmd mbox_cmd = {
>  		.opcode = CXL_MBOX_OP_GET_EVT_INT_POLICY,
>  		.payload_out = policy,
>  		.size_out = sizeof(*policy),
> +		/* CXL 2.0 firmware omits dcd_settings; accept the shorter reply */
> +		.min_out = CXL_EVENT_INT_POLICY_BASE_SIZE,
>  	};
>  	int rc;
>  
>  	rc = cxl_internal_send_cmd(cxl_mbox, &mbox_cmd);
> -	if (rc < 0)
> +	if (rc < 0) {
>  		dev_err(mds->cxlds.dev,
>  			"Failed to get event interrupt policy : %d", rc);
> +		return rc;
> +	}
>  
> +	if (policy_size)
> +		*policy_size = mbox_cmd.size_out;
>  	return rc;
>  }
>  
>  static int cxl_event_config_msgnums(struct cxl_memdev_state *mds,
> -				    struct cxl_event_interrupt_policy *policy)
> +				    struct cxl_event_interrupt_policy *policy,
> +				    bool native_cxl, size_t policy_size)
>  {
>  	struct cxl_mailbox *cxl_mbox = &mds->cxlds.cxl_mbox;
>  	struct cxl_mbox_cmd mbox_cmd;
>  	int rc;
>  
> -	*policy = (struct cxl_event_interrupt_policy) {
> -		.info_settings = CXL_INT_MSI_MSIX,
> -		.warn_settings = CXL_INT_MSI_MSIX,
> -		.failure_settings = CXL_INT_MSI_MSIX,
> -		.fatal_settings = CXL_INT_MSI_MSIX,
> -	};
> +	/* memory event policy is left if FW has control */
> +	if (native_cxl) {
> +		*policy = (struct cxl_event_interrupt_policy) {
> +			.info_settings = CXL_INT_MSI_MSIX,
> +			.warn_settings = CXL_INT_MSI_MSIX,
> +			.failure_settings = CXL_INT_MSI_MSIX,
> +			.fatal_settings = CXL_INT_MSI_MSIX,
> +			.dcd_settings = 0,
> +		};
> +	}
> +
> +	/*
> +	 * A CXL 3.0+ device can carry dcd_settings field without DCD command
> +	 * support, so size the request by the device's policy_size and only
> +	 * enable the DCD interrupt when DCD commands are supported.
> +	 */
> +	if (cxl_dcd_supported(mds))
> +		policy->dcd_settings = CXL_INT_MSI_MSIX;
>  
>  	mbox_cmd = (struct cxl_mbox_cmd) {
>  		.opcode = CXL_MBOX_OP_SET_EVT_INT_POLICY,
>  		.payload_in = policy,
> -		.size_in = sizeof(*policy),
> +		.size_in = policy_size,
>  	};
>  
>  	rc = cxl_internal_send_cmd(cxl_mbox, &mbox_cmd);
> @@ -597,7 +628,7 @@ static int cxl_event_config_msgnums(struct cxl_memdev_state *mds,
>  	}
>  
>  	/* Retrieve final interrupt settings */
> -	return cxl_event_get_int_policy(mds, policy);
> +	return cxl_event_get_int_policy(mds, policy, NULL);
>  }
>  
>  static int cxl_event_irqsetup(struct cxl_memdev_state *mds,
> @@ -633,6 +664,30 @@ static int cxl_event_irqsetup(struct cxl_memdev_state *mds,
>  	return 0;
>  }
>  
> +static int cxl_irqsetup(struct cxl_memdev_state *mds,
> +			struct cxl_event_interrupt_policy *policy,
> +			bool native_cxl)
> +{
> +	struct cxl_dev_state *cxlds = &mds->cxlds;
> +	int rc;
> +
> +	if (native_cxl) {
> +		rc = cxl_event_irqsetup(mds, policy);
> +		if (rc)
> +			return rc;
> +	}
> +
> +	if (cxl_dcd_supported(mds)) {
> +		rc = cxl_event_req_irq(cxlds, policy->dcd_settings);
> +		if (rc) {
> +			dev_err(cxlds->dev, "Failed to get interrupt for DCD event log\n");
> +			cxl_disable_dcd(mds);

Hi Anisa,

If I didn't understand wrong, the interrupt has devicce half and host half.
When cxl_event_req_irq() fails for DCD log, cxl_irqsetup() disable DCD and
return 0, but still dcd_settings = MSI/MSI-X, so the device keeps signalling
a vector with no handler while driver consider DCD off.

Should we match the state together ?

Best regards,
Richard Cheng.


> +		}
> +	}
> +
> +	return 0;
> +}
> +
>  static bool cxl_event_int_is_fw(u8 setting)
>  {
>  	u8 mode = FIELD_GET(CXLDEV_EVENT_INT_MODE_MASK, setting);
> @@ -651,46 +706,90 @@ static bool cxl_event_fw_owns_mem_logs(struct cxl_event_interrupt_policy *policy
>  static int cxl_event_config(struct pci_host_bridge *host_bridge,
>  			    struct cxl_memdev_state *mds, bool irq_avail)
>  {
> -	struct cxl_event_interrupt_policy policy;
> +	struct cxl_event_interrupt_policy policy = { 0 };
> +	bool native_cxl = host_bridge->native_cxl_error;
> +	size_t policy_size;
> +	u32 mask;
>  	int rc;
>  
>  	/*
>  	 * When BIOS maintains CXL error reporting control, it will process
>  	 * event records.  Only one agent can do so.
> +	 *
> +	 * If BIOS has control of events and DCD is not supported skip event
> +	 * configuration.
>  	 */
> -	if (!host_bridge->native_cxl_error)
> +	if (!native_cxl && !cxl_dcd_supported(mds))
>  		return 0;
>  
>  	if (!irq_avail) {
>  		dev_info(mds->cxlds.dev, "No interrupt support, disable event processing.\n");
> +		if (cxl_dcd_supported(mds)) {
> +			dev_info(mds->cxlds.dev, "DCD requires interrupts, disable DCD\n");
> +			cxl_disable_dcd(mds);
> +		}
>  		return 0;
>  	}
>  
> -	rc = cxl_event_get_int_policy(mds, &policy);
> +	rc = cxl_event_get_int_policy(mds, &policy, &policy_size);
>  	if (rc)
> -		return rc;
> +		goto err;
> +
> +	/*
> +	 * dcd_settings cannot be sent to a device whose policy is too short
> +	 * to hold it, so the device would never accept the setting
> +	 * cxl_irqsetup() arms the DCD interrupt with.
> +	 */
> +	if (cxl_dcd_supported(mds) && policy_size < sizeof(policy)) {
> +		dev_warn(mds->cxlds.dev,
> +			 "DCD supported but interrupt policy is only %zu bytes\n",
> +			 policy_size);
> +		cxl_disable_dcd(mds);
> +		/* DCD was the only reason to be here */
> +		if (!native_cxl)
> +			return 0;
> +	}
>  
> -	if (cxl_event_fw_owns_mem_logs(&policy)) {
> +	if (native_cxl && cxl_event_fw_owns_mem_logs(&policy)) {
>  		dev_err(mds->cxlds.dev,
>  			"FW still in control of Event Logs despite _OSC settings\n");
>  		return -EBUSY;
>  	}
>  
> -	rc = cxl_event_config_msgnums(mds, &policy);
> +	rc = cxl_event_config_msgnums(mds, &policy, native_cxl, policy_size);
>  	if (rc)
> -		return rc;
> +		goto err;
>  
>  	rc = cxl_mem_alloc_event_buf(mds);
>  	if (rc)
>  		return rc;
>  
> -	rc = cxl_event_irqsetup(mds, &policy);
> +	rc = cxl_irqsetup(mds, &policy, native_cxl);
>  	if (rc)
>  		return rc;
>  
> -	cxl_mem_get_event_records(mds, CXLDEV_EVENT_STATUS_ALL);
> +	mask = cxl_event_drain_mask(host_bridge);
> +	if (mask)
> +		cxl_mem_get_event_records(mds, mask);
> +
> +	dev_dbg(mds->cxlds.dev, "Event config : %s DCD %s\n",
> +		native_cxl ? "OS" : "BIOS",
> +		cxl_dcd_supported(mds) ? "supported" : "not supported");
>  
>  	return 0;
> +
> +err:
> +	/*
> +	 * Failed to Get/Set interrupt policy for DCD while BIOS owns the
> +	 * other logs. Disable DCD and continue.
> +	 */
> +	if (!native_cxl) {
> +		dev_warn(mds->cxlds.dev,
> +			 "Event interrupt policy failed (%d), disabling DCD\n", rc);
> +		cxl_disable_dcd(mds);
> +		return 0;
> +	}
> +	return rc;
>  }
>  
>  static int cxl_pci_type3_init_mailbox(struct cxl_dev_state *cxlds)
> diff --git a/tools/testing/cxl/test/mem.c b/tools/testing/cxl/test/mem.c
> index 7b756000a1a6..c740372bdaaa 100644
> --- a/tools/testing/cxl/test/mem.c
> +++ b/tools/testing/cxl/test/mem.c
> @@ -1818,7 +1818,7 @@ static int cxl_mock_mem_probe(struct platform_device *pdev)
>  	if (rc)
>  		dev_dbg(dev, "No CXL FWCTL setup\n");
>  
> -	cxl_mem_get_event_records(mds, CXLDEV_EVENT_STATUS_ALL);
> +	cxl_mem_get_event_records(mds, CXLDEV_EVENT_STATUS_STANDARD_LOGS);
>  	cxl_mock_test_feat_init(mdata);
>  
>  	return 0;
> -- 
> 2.43.0
> 

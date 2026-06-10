Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011032.outbound.protection.outlook.com [52.101.62.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEB58272E6D
	for <nvdimm@lists.linux.dev>; Wed, 10 Jun 2026 03:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781063487; cv=fail; b=iLl0rZqYv8q5Tkay3bHCJN5HwcOuEATnnG7AmCRTSZD/WC+uILdvm5p9eZjlvuJcpP/INHIB8tmvJsC/ikJFz0sQBG3IbuAyTZxpXm+eKjUpn1lFd5WqM5MGmCgCABb4MKVr7UCzhIJ9dWqf1e5n9YHW42jVRgvv6HMFm1rmoZA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781063487; c=relaxed/simple;
	bh=ASp91B4RvkkDtVMxz40/QZzaWNGZHH2JZLCel7xjrZ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=AgLGg3vDt4d5o/vT3zWjpAZyL1qxPlhblrhZ3E60K94MFJ/me4y0Me68S3Wh8nCCQJpGgH+Wn1qI2Ua7fXIvktltVCGuxMRfufcPUnXdHKcjp68LRnu/CpJvyvY9y09FM1U3dP5EPoYUrDNHfzYbGw6hTzYHZB1prBYzI5jEYG4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=EMuYROmg; arc=fail smtp.client-ip=52.101.62.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="EMuYROmg"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ctwcN3gJgcPsXnkbImDJmcMS975hXDhBfemp3fJuVz1E28gbwpHDZWK5nurIly9EG6/gdsimXToCXg/HTSA/fcdDJYoYFeR+DYKq0618pW89eHCt6MohFFz/Y+w3ldZwSRoQMQwBEC9tnUlyOLPsTUmXmBnagM88ZZaTtaBHX68unBIHLTuUSpfN99OJjzqkT9RSS2H0KZ642eDxB2SwzFWMfIO6vqC+/FRvKSnbCB8tJsAaiwmapinoIIPjH+UDmGFi6PgdpG+ZCzN/Hzu0qiJA/y+q7ZsVHAxFB4H+/nXenNnnEoU2665p8hEygXVBJw7KwBOdKkLjDnEJ1/fk8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aGdRfs13In4PqGHGdMQxAwPk4UQdwVQtxTLuHPKysQY=;
 b=cH98rr1zQDWoWcappewKRFyWiyluHmW2/F8iJVv4PFSKQdmnHVhJdnlAFYkM6OPCckxTR8TCRQ/eSevOtNNwHTC3/4pIyaeMlcf+OVblW1TXcPyUJVwNWdz8WJdtrxFhVPWno38+Y4LDsTOkMScnXhS7iQJNd1lMvwgpUY29tpJo2NRKW4K2OWiu2EJLpWvAIOOzWJtV6d3NwRnuGjpWdaN4fpdP/YbZ52+QWN/8j2rmNVD1BE7aRyeSdmgpIpb7VzsDlU1WtP46WJLWAalOOx89LXqy1juNgpFrWsG08DZATFoYf/pycmPIz48u8as4HC8bUTq/6o1DLQIRVaR1fQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aGdRfs13In4PqGHGdMQxAwPk4UQdwVQtxTLuHPKysQY=;
 b=EMuYROmgg1kVXdMqzkcyEgB3jJl2V6igC/3rE5C296eDP5b6jN4d+jo0rQ5puvDY5gRbh2FrCerRfXaY0+S/ANVsi36uvf1zuTiPd6T9BCK9lJw/y/VkCe2jX1j+b+HbDHoQIiWZK4c981JpvtNZ3OP8qUBTWVS4KL5ugi3lJkBxEbd0YSML1CyI4G6DKFRe58pRIc4hX2AnkXtUwqao7kdvvYee8TxFWYAvblf/eyEhlpw/1CAvGV1l+82qSBmgVQSiZxielJVwiJuCN2Z+056e60nsjthVWrSiCjQh1EoOZGR/xonc2h0Lc6BPsIC76mH9acPmJU4r1XaAY9U/wA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB2370.namprd12.prod.outlook.com (2603:10b6:207:47::27)
 by DS5PPF23E22D637.namprd12.prod.outlook.com (2603:10b6:f:fc00::647) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.13; Wed, 10 Jun
 2026 03:51:19 +0000
Received: from BL0PR12MB2370.namprd12.prod.outlook.com
 ([fe80::86cf:c3ec:2cf5:74c8]) by BL0PR12MB2370.namprd12.prod.outlook.com
 ([fe80::86cf:c3ec:2cf5:74c8%5]) with mapi id 15.21.0092.011; Wed, 10 Jun 2026
 03:51:19 +0000
Date: Wed, 10 Jun 2026 11:51:10 +0800
From: Richard Cheng <icheng@nvidia.com>
To: Dave Jiang <dave.jiang@intel.com>
Cc: Anisa Su <anisa.su887@gmail.com>, linux-cxl@vger.kernel.org, 
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, Dan Williams <djbw@kernel.org>, 
	Jonathan Cameron <jic23@kernel.org>, Davidlohr Bueso <dave@stgolabs.net>, 
	Ira Weiny <iweiny@kernel.org>, Alison Schofield <alison.schofield@intel.com>, 
	John Groves <John@groves.net>, Gregory Price <gourry@gourry.net>, 
	Ira Weiny <ira.weiny@intel.com>
Subject: Re: [PATCH v6 2/7] libcxl: Add Dynamic RAM A partition mode support
Message-ID: <aijefVjI2x6hgxH8@MWDK4CY14F>
References: <20260523095043.471098-1-anisa.su@samsung.com>
 <20260523095043.471098-3-anisa.su@samsung.com>
 <06747633-ed22-48a2-b8d0-c9b544a682f8@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <06747633-ed22-48a2-b8d0-c9b544a682f8@intel.com>
X-ClientProxiedBy: KU2P306CA0010.MYSP306.PROD.OUTLOOK.COM
 (2603:1096:d10:14::7) To BL0PR12MB2370.namprd12.prod.outlook.com
 (2603:10b6:207:47::27)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR12MB2370:EE_|DS5PPF23E22D637:EE_
X-MS-Office365-Filtering-Correlation-Id: cc2768bc-a8f5-4ab2-bfc7-08dec6a3876b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|7416014|366016|22082099003|18002099003|5023799004|11063799006|4143699003|6133799003|56012099006;
X-Microsoft-Antispam-Message-Info:
	KRQYlex2JH9qmdyxhF7BbTh/3bjXYatAw123b4o5m8pJ9nE/fq/OOdnSLlyGuw7pLIkxYQ7GBxsdReWlSHcS2ou2Xnqpxfq6JdK0i26khl0q3tGB8f+qDK1uFE0Hf2tNyXgTuHAaKgrG/oQdF0IlMaexFldQllZdPGiPOE+6W1w1DomzdCxi62g0y12clEUZk5wuOj5EYGwXp/jSe2F9lNnTXbKaAQegHNCPdD39HpUNA4Q2HGsTutjXeEQ4J+6lhsPCJGdtG4OR0PW0oK2DrSKiL0JUUrUI+0c63zTLG0EgotiytNguifGTW2B9z8cmhdOApMyrlcBp8zwQ0EGzxOissTajLdT1TKMd9QsSn+jFBjnmt+PmMo+ZndQ9r6jD8S0iXfliS6h/k+8AWiWRKHKJFajVaUlN+nTW0BPe//LoPJLQ/wFRwpDx0FEOUUNKNvgWlEFz5TdwS7wv1bl5aWmFj5qX6MOSQkFMaMPEgeYLUK5TkgSQ2Kl+MPfh4UT05QMnYH3hMxoDrsDxIcJQhrZwCQeNokPeDFcnL+Kp05YlI1/W7Arfrmf2VIZgo3XPq5ypW4iO6t7iJl7zl/RJrFaZQu+YoUkh/ORqW7djI+Oga5zNfw/k7pSOtt/rOIQsqE5rViUIWSCnWBLKdPEdhOYD3bDZG+GkgFLhw6I59vsP90eEXd2Ac4GiqFx1O/mt
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB2370.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(7416014)(366016)(22082099003)(18002099003)(5023799004)(11063799006)(4143699003)(6133799003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Erev71u30OcHrwbN16kMuk6tuh5VQyDSAvj3WPhY3hDv87chn4QhIwYSoVaY?=
 =?us-ascii?Q?6Z6aMM+Ecn+Z0IUtfgQFJ+lNAOrKWQUBKWyQJJA1ZDezGmCd95bBLie3L/y1?=
 =?us-ascii?Q?h17N4U2StMO8O4lpUjBk51dcIV6f7aHZ+5XGi6ebf3FrTdVIupxlzq4SrdV8?=
 =?us-ascii?Q?FRLftxQJLYzJnAPatamSy8x1i6UEmEdyv3mC29s6FIMJhHwWzy6N2O0BN3PQ?=
 =?us-ascii?Q?iYJNEJRtk1i+wUC7s8Xuq1XhFxwIAFPjc1WwmHRwcz+qqrhoP42jcfNH30t0?=
 =?us-ascii?Q?fpNBDILifkBnzHWjXY+ZKido+V7ECbHhmQ1WV+uzaXeOIBkYihv8yqmneMgK?=
 =?us-ascii?Q?L/PWcSz5iH6veLtyzV9iOZBmWCNwNfpDZGFRUHLJaTPpJkzqL+ujELSUd8BH?=
 =?us-ascii?Q?Z9MW/2KlGPQLICz0TOwIIUXaDP2ke36IB3y/7ZsJR4f9SuXXq1OCQ1PjJ1N+?=
 =?us-ascii?Q?NJo56mi10yE3amwj8LOOnttf1Q1+YSfFkpzQg7zdtsVpyvWnGTaAMDUnuLAq?=
 =?us-ascii?Q?fs2XCDtClfiz/k1vor0mPUQzqQSeBmwfMqQeagc2mQU98CXE7LQRmauWxx2u?=
 =?us-ascii?Q?IGI4GnexezDwi8zCfY1Rfe3XiOhuuSai7WvTwQG6MTPHlc1X9hUjSMuzn9Kf?=
 =?us-ascii?Q?Fnc2Yd+fpk/vhC/qoAozZF7VU2DR6QW85ZT8bBE9gLzWr2vzw5z36z/i01jL?=
 =?us-ascii?Q?l1cFfYyWcwhnNQX6BM6fn6hdfWX2Od5QBewUSGymDV9GEVAH2CgIoLrFwwX1?=
 =?us-ascii?Q?LXbaAX0kCS9QDvRX0hve+50dmYU8a72rkYjZiLpssAzhu1CgY4A015U/WRoR?=
 =?us-ascii?Q?UmvrO0kCO5agivCPvF28YysjOVhIGSnxT3EyArf2G7F1xp51PwZOdC7vTtNh?=
 =?us-ascii?Q?FefSvnlPmgbBEIIlq0CkYi2YEjjtc5mo1vouP+/DaZE+GpYMdEN2HHbXJH5I?=
 =?us-ascii?Q?hvOeX9VDi2aUNVOiHXR4vox9a67w09M+2ja8cQGtuDYN9Y6lzmFUmGE4H+Vc?=
 =?us-ascii?Q?4W5CRBGBCgA+/EAvQA5BxkV1YCIeMETCJoJAF/pvUiHg6CzUDaGifA89Gqwl?=
 =?us-ascii?Q?t+Mp9mgwFKg7IHtNlZPt0nROyNtivV6YQYtuAk6PtNbnNroq7DoU8u3VtYXc?=
 =?us-ascii?Q?ed7jsSm1D9s+LfdUlyJiML24VEeUvWGF738BNNMBY7wzhINZnZvZn31GBeTT?=
 =?us-ascii?Q?Rke/W3KSVd2Jfo5Ran4bIJaBIdOvedJvcZXTFKVlELD6fWbqgMkBBcrPPSdF?=
 =?us-ascii?Q?ur6uYE/YwxlHgfq8JVaTLliXcS9hDzuhM18gOek/izwzGYReLQduTpdmcP2Z?=
 =?us-ascii?Q?or/DjvkSnbhfnQzN02ylC8JGwfKnkqEiAWfGrfjd/dg8+4pKF/n6Zkg/8FQB?=
 =?us-ascii?Q?qklEOlB6I/hsfxkokfCua5tInZksWmTdcyEuUYeFXBoWlRerthf/wz7PQZxk?=
 =?us-ascii?Q?4WTV//IjwgnLCisgPyJNVKgHRhH2qsp/1onQCOW7Rfaid6aP9Smg2vuCdDJv?=
 =?us-ascii?Q?uKAkzjFdxknKW8EAbH5/5QXGPa+pSvBSktMOGCcjc+LPCgopnr5JgI52/5/O?=
 =?us-ascii?Q?WuLOKz2kZL4BW0vjorb/r/iqJ9kYo+wbhLN2fpeyL1Kfrg6oyhwLueAy0LfA?=
 =?us-ascii?Q?Z8UsbF9fVauBLAZPK9DBKCVq4UEWoyP6+TCcFA619BTt1O6eXtSnE5fA3207?=
 =?us-ascii?Q?VHLZBfYaIBquMM8jbx+ylaJdrRtWrCCIXC9kBqNdYLEm38iV5xYk2ZfBmAWu?=
 =?us-ascii?Q?Qdfa8C7vEg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc2768bc-a8f5-4ab2-bfc7-08dec6a3876b
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB2370.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2026 03:51:19.0538
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n+n37zuSEcauqyxiR328fIzQ7yuePPdf4rP0W7WouGqvmtrVvfwdYC94JCGUKH4D1m7dSC1AgNqrp3NkCgOYDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS5PPF23E22D637

On Mon, Jun 08, 2026 at 04:19:47PM +0800, Dave Jiang wrote:
> 
> 
> On 5/23/26 2:50 AM, Anisa Su wrote:
> > From: Ira Weiny <ira.weiny@intel.com>
> > 
> > Dynamic capacity partitions are exposed as a singular dynamic ram
> > partition.
> > 
> > Add CXL library support to read this partition information.
> > 
> > Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> 
> Missing Anisa sign off.
> 
> Can probably squash this and the next commit so the usage is shown for the reviewer.
> 
> DJ
> 
> > ---
> >  Documentation/cxl/lib/libcxl.txt |  6 +++--
> >  cxl/lib/libcxl.c                 | 43 ++++++++++++++++++++++++++++++++
> >  cxl/lib/libcxl.sym               |  4 +++
> >  cxl/lib/private.h                |  3 +++
> >  cxl/libcxl.h                     | 10 +++++++-
> >  5 files changed, 63 insertions(+), 3 deletions(-)
> > 
> > diff --git a/Documentation/cxl/lib/libcxl.txt b/Documentation/cxl/lib/libcxl.txt
> > index 5c3ebd4..9921ac1 100644
> > --- a/Documentation/cxl/lib/libcxl.txt
> > +++ b/Documentation/cxl/lib/libcxl.txt
> > @@ -74,6 +74,7 @@ int cxl_memdev_get_major(struct cxl_memdev *memdev);
> >  int cxl_memdev_get_minor(struct cxl_memdev *memdev);
> >  unsigned long long cxl_memdev_get_pmem_size(struct cxl_memdev *memdev);
> >  unsigned long long cxl_memdev_get_ram_size(struct cxl_memdev *memdev);
> > +unsigned long long cxl_memdev_get_dynamic_ram_a_size(struct cxl_memdev *memdev);
> >  const char *cxl_memdev_get_firmware_version(struct cxl_memdev *memdev);
> >  size_t cxl_memdev_get_label_size(struct cxl_memdev *memdev);
> >  int cxl_memdev_nvdimm_bridge_active(struct cxl_memdev *memdev);
> > @@ -93,8 +94,8 @@ The character device node for command submission can be found by default
> >  at /dev/cxl/mem%d, or created with a major / minor returned from
> >  cxl_memdev_get_{major,minor}().
> >  
> > -The 'pmem_size' and 'ram_size' attributes return the current
> > -provisioning of DPA (Device Physical Address / local capacity) in the
> > +The 'pmem_size', 'ram_size', and 'dynamic_ram_a_size' attributes return the
> > +current provisioning of DPA (Device Physical Address / local capacity) in the
> >  device.
> >  
> >  cxl_memdev_get_numa_node() returns the affinitized CPU node number if
> > @@ -453,6 +454,7 @@ enum cxl_decoder_mode {
> >  	CXL_DECODER_MODE_MIXED,
> >  	CXL_DECODER_MODE_PMEM,
> >  	CXL_DECODER_MODE_RAM,
> > +	CXL_DECODER_MODE_DYNAMIC_RAM_A,
> >  };
> >  enum cxl_decoder_mode cxl_decoder_get_mode(struct cxl_decoder *decoder);
> >  int cxl_decoder_set_mode(struct cxl_decoder *decoder, enum cxl_decoder_mode mode);
> > diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
> > index e55a7b4..be0bc03 100644
> > --- a/cxl/lib/libcxl.c
> > +++ b/cxl/lib/libcxl.c
> > @@ -501,6 +501,9 @@ CXL_EXPORT bool cxl_region_qos_class_mismatch(struct cxl_region *region)
> >  		} else if (region->mode == CXL_DECODER_MODE_PMEM) {
> >  			if (root_decoder->qos_class != memdev->pmem_qos_class)
> >  				return true;
> > +		} else if (region->mode == CXL_DECODER_MODE_DYNAMIC_RAM_A) {
> > +			if (root_decoder->qos_class != memdev->dynamic_ram_a_qos_class)
> > +				return true;
> >  		}
> >  	}
> >  
> > @@ -1426,6 +1429,10 @@ static void *add_cxl_memdev(void *parent, int id, const char *cxlmem_base)
> >  	if (sysfs_read_attr(ctx, path, buf) == 0)
> >  		memdev->ram_size = strtoull(buf, NULL, 0);
> >  
> > +	sprintf(path, "%s/dynamic_ram_a/size", cxlmem_base);
> > +	if (sysfs_read_attr(ctx, path, buf) == 0)
> > +		memdev->dynamic_ram_a_size = strtoull(buf, NULL, 0);
> > +
> >  	sprintf(path, "%s/pmem/qos_class", cxlmem_base);
> >  	if (sysfs_read_attr(ctx, path, buf) < 0)
> >  		memdev->pmem_qos_class = CXL_QOS_CLASS_NONE;
> > @@ -1438,6 +1445,12 @@ static void *add_cxl_memdev(void *parent, int id, const char *cxlmem_base)
> >  	else
> >  		memdev->ram_qos_class = atoi(buf);
> >  
> > +	sprintf(path, "%s/dynamic_ram_a/qos_class", cxlmem_base);
> > +	if (sysfs_read_attr(ctx, path, buf) < 0)
> > +		memdev->dynamic_ram_a_qos_class = CXL_QOS_CLASS_NONE;
> > +	else
> > +		memdev->dynamic_ram_a_qos_class = atoi(buf);
> > +
> >  	sprintf(path, "%s/payload_max", cxlmem_base);
> >  	if (sysfs_read_attr(ctx, path, buf) == 0) {
> >  		memdev->payload_max = strtoull(buf, NULL, 0);
> > @@ -1685,6 +1698,11 @@ CXL_EXPORT unsigned long long cxl_memdev_get_ram_size(struct cxl_memdev *memdev)
> >  	return memdev->ram_size;
> >  }
> >  
> > +CXL_EXPORT unsigned long long cxl_memdev_get_dynamic_ram_a_size(struct cxl_memdev *memdev)
> > +{
> > +	return memdev->dynamic_ram_a_size;
> > +}
> > +
> >  CXL_EXPORT int cxl_memdev_get_pmem_qos_class(struct cxl_memdev *memdev)
> >  {
> >  	return memdev->pmem_qos_class;
> > @@ -1695,6 +1713,11 @@ CXL_EXPORT int cxl_memdev_get_ram_qos_class(struct cxl_memdev *memdev)
> >  	return memdev->ram_qos_class;
> >  }
> >  
> > +CXL_EXPORT int cxl_memdev_get_dynamic_ram_a_qos_class(struct cxl_memdev *memdev)
> > +{
> > +	return memdev->dynamic_ram_a_qos_class;
> > +}
> > +
> >  CXL_EXPORT const char *cxl_memdev_get_firmware_verison(struct cxl_memdev *memdev)
> >  {
> >  	return memdev->firmware_version;
> > @@ -2465,6 +2488,8 @@ static void *add_cxl_decoder(void *parent, int id, const char *cxldecoder_base)
> >  			decoder->mode = CXL_DECODER_MODE_MIXED;
> >  		else if (strcmp(buf, "none") == 0)
> >  			decoder->mode = CXL_DECODER_MODE_NONE;
> > +		else if (strcmp(buf, "dynamic_ram_a") == 0)
> > +			decoder->mode = CXL_DECODER_MODE_DYNAMIC_RAM_A;
> >  		else
> >  			decoder->mode = CXL_DECODER_MODE_MIXED;
> >  	} else
> > @@ -2504,6 +2529,7 @@ static void *add_cxl_decoder(void *parent, int id, const char *cxldecoder_base)
> >  	case CXL_PORT_SWITCH:
> >  		decoder->pmem_capable = true;
> >  		decoder->volatile_capable = true;
> > +		decoder->dynamic_ram_a_capable = true;
> >  		decoder->mem_capable = true;
> >  		decoder->accelmem_capable = true;
> >  		sprintf(path, "%s/locked", cxldecoder_base);
> > @@ -2528,6 +2554,7 @@ static void *add_cxl_decoder(void *parent, int id, const char *cxldecoder_base)
> >  			{ "cap_type3", &decoder->mem_capable },
> >  			{ "cap_ram", &decoder->volatile_capable },
> >  			{ "cap_pmem", &decoder->pmem_capable },
> > +			{ "cap_dynamic_ram_a", &decoder->dynamic_ram_a_capable },
> >  			{ "locked", &decoder->locked },
> >  		};
> >  
> > @@ -2778,6 +2805,9 @@ CXL_EXPORT int cxl_decoder_set_mode(struct cxl_decoder *decoder,
> >  	case CXL_DECODER_MODE_RAM:
> >  		sprintf(buf, "ram");
> >  		break;
> > +	case CXL_DECODER_MODE_DYNAMIC_RAM_A:
> > +		sprintf(buf, "dynamic_ram_a");
> > +		break;
> >  	default:
> >  		err(ctx, "%s: unsupported mode: %d\n",
> >  		    cxl_decoder_get_devname(decoder), mode);
> > @@ -2829,6 +2859,11 @@ CXL_EXPORT bool cxl_decoder_is_volatile_capable(struct cxl_decoder *decoder)
> >  	return decoder->volatile_capable;
> >  }
> >  
> > +CXL_EXPORT bool cxl_decoder_is_dynamic_ram_a_capable(struct cxl_decoder *decoder)
> > +{
> > +	return decoder->dynamic_ram_a_capable;
> > +}
> > +
> >  CXL_EXPORT bool cxl_decoder_is_mem_capable(struct cxl_decoder *decoder)
> >  {
> >  	return decoder->mem_capable;
> > @@ -2903,6 +2938,8 @@ static struct cxl_region *cxl_decoder_create_region(struct cxl_decoder *decoder,
> >  		sprintf(path, "%s/create_pmem_region", decoder->dev_path);
> >  	else if (mode == CXL_DECODER_MODE_RAM)
> >  		sprintf(path, "%s/create_ram_region", decoder->dev_path);
> > +	else if (mode == CXL_DECODER_MODE_DYNAMIC_RAM_A)
> > +		sprintf(path, "%s/create_dynamic_ram_a_region", decoder->dev_path);
> >  
> >  	rc = sysfs_read_attr(ctx, path, buf);
> >  	if (rc < 0) {
> > @@ -2954,6 +2991,12 @@ cxl_decoder_create_ram_region(struct cxl_decoder *decoder)
> >  	return cxl_decoder_create_region(decoder, CXL_DECODER_MODE_RAM);
> >  }
> >  
> > +CXL_EXPORT struct cxl_region *
> > +cxl_decoder_create_dynamic_ram_a_region(struct cxl_decoder *decoder)
> > +{
> > +	return cxl_decoder_create_region(decoder, CXL_DECODER_MODE_DYNAMIC_RAM_A);
> > +}
> > +
> >  CXL_EXPORT int cxl_decoder_get_nr_targets(struct cxl_decoder *decoder)
> >  {
> >  	return decoder->nr_targets;
> > diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
> > index ed4429f..258bdd3 100644
> > --- a/cxl/lib/libcxl.sym
> > +++ b/cxl/lib/libcxl.sym
> > @@ -294,6 +294,10 @@ global:
> >  	cxl_memdev_get_fwctl;
> >  	cxl_fwctl_get_major;
> >  	cxl_fwctl_get_minor;
> > +	cxl_memdev_get_dynamic_ram_a_size;
> > +	cxl_memdev_get_dynamic_ram_a_qos_class;
> > +	cxl_decoder_is_dynamic_ram_a_capable;
> > +	cxl_decoder_create_dynamic_ram_a_region;
> >  } LIBECXL_8;
> >  
> >  LIBCXL_10 {

Shouldn't new exported symbols go in a fresh top-level node ?
Something like LIBCXL_12 ? please note that Patch 4 has the same
issue.

Please let me know if I'm wrong or misunderstand anything.

Best regards,
Richard Cheng.

> > diff --git a/cxl/lib/private.h b/cxl/lib/private.h
> > index d2d71fc..37b7b06 100644
> > --- a/cxl/lib/private.h
> > +++ b/cxl/lib/private.h
> > @@ -52,8 +52,10 @@ struct cxl_memdev {
> >  	struct list_node list;
> >  	unsigned long long pmem_size;
> >  	unsigned long long ram_size;
> > +	unsigned long long dynamic_ram_a_size;
> >  	int ram_qos_class;
> >  	int pmem_qos_class;
> > +	int dynamic_ram_a_qos_class;
> >  	int payload_max;
> >  	size_t lsa_size;
> >  	struct kmod_module *module;
> > @@ -159,6 +161,7 @@ struct cxl_decoder {
> >  	unsigned int interleave_granularity;
> >  	bool pmem_capable;
> >  	bool volatile_capable;
> > +	bool dynamic_ram_a_capable;
> >  	bool mem_capable;
> >  	bool accelmem_capable;
> >  	bool locked;
> > diff --git a/cxl/libcxl.h b/cxl/libcxl.h
> > index e91af90..fd41122 100644
> > --- a/cxl/libcxl.h
> > +++ b/cxl/libcxl.h
> > @@ -75,8 +75,10 @@ struct cxl_fwctl *cxl_memdev_get_fwctl(struct cxl_memdev *memdev);
> >  struct cxl_ctx *cxl_memdev_get_ctx(struct cxl_memdev *memdev);
> >  unsigned long long cxl_memdev_get_pmem_size(struct cxl_memdev *memdev);
> >  unsigned long long cxl_memdev_get_ram_size(struct cxl_memdev *memdev);
> > +unsigned long long cxl_memdev_get_dynamic_ram_a_size(struct cxl_memdev *memdev);
> >  int cxl_memdev_get_pmem_qos_class(struct cxl_memdev *memdev);
> >  int cxl_memdev_get_ram_qos_class(struct cxl_memdev *memdev);
> > +int cxl_memdev_get_dynamic_ram_a_qos_class(struct cxl_memdev *memdev);
> >  const char *cxl_memdev_get_firmware_verison(struct cxl_memdev *memdev);
> >  bool cxl_memdev_fw_update_in_progress(struct cxl_memdev *memdev);
> >  size_t cxl_memdev_fw_update_get_remaining(struct cxl_memdev *memdev);
> > @@ -210,6 +212,7 @@ enum cxl_decoder_mode {
> >  	CXL_DECODER_MODE_MIXED,
> >  	CXL_DECODER_MODE_PMEM,
> >  	CXL_DECODER_MODE_RAM,
> > +	CXL_DECODER_MODE_DYNAMIC_RAM_A,
> >  };
> >  
> >  static inline const char *cxl_decoder_mode_name(enum cxl_decoder_mode mode)
> > @@ -219,9 +222,10 @@ static inline const char *cxl_decoder_mode_name(enum cxl_decoder_mode mode)
> >  		[CXL_DECODER_MODE_MIXED] = "mixed",
> >  		[CXL_DECODER_MODE_PMEM] = "pmem",
> >  		[CXL_DECODER_MODE_RAM] = "ram",
> > +		[CXL_DECODER_MODE_DYNAMIC_RAM_A] = "dynamic_ram_a",
> >  	};
> >  
> > -	if (mode < CXL_DECODER_MODE_NONE || mode > CXL_DECODER_MODE_RAM)
> > +	if (mode < CXL_DECODER_MODE_NONE || mode > CXL_DECODER_MODE_DYNAMIC_RAM_A)
> >  		mode = CXL_DECODER_MODE_NONE;
> >  	return names[mode];
> >  }
> > @@ -235,6 +239,8 @@ cxl_decoder_mode_from_ident(const char *ident)
> >  		return CXL_DECODER_MODE_RAM;
> >  	else if (strcmp(ident, "pmem") == 0)
> >  		return CXL_DECODER_MODE_PMEM;
> > +	else if (strcmp(ident, "dynamic_ram_a") == 0)
> > +		return CXL_DECODER_MODE_DYNAMIC_RAM_A;
> >  	return CXL_DECODER_MODE_NONE;
> >  }
> >  
> > @@ -264,6 +270,7 @@ cxl_decoder_get_target_type(struct cxl_decoder *decoder);
> >  bool cxl_decoder_is_pmem_capable(struct cxl_decoder *decoder);
> >  bool cxl_decoder_is_volatile_capable(struct cxl_decoder *decoder);
> >  bool cxl_decoder_is_mem_capable(struct cxl_decoder *decoder);
> > +bool cxl_decoder_is_dynamic_ram_a_capable(struct cxl_decoder *decoder);
> >  bool cxl_decoder_is_accelmem_capable(struct cxl_decoder *decoder);
> >  bool cxl_decoder_is_locked(struct cxl_decoder *decoder);
> >  unsigned int
> > @@ -272,6 +279,7 @@ unsigned int cxl_decoder_get_interleave_ways(struct cxl_decoder *decoder);
> >  struct cxl_region *cxl_decoder_get_region(struct cxl_decoder *decoder);
> >  struct cxl_region *cxl_decoder_create_pmem_region(struct cxl_decoder *decoder);
> >  struct cxl_region *cxl_decoder_create_ram_region(struct cxl_decoder *decoder);
> > +struct cxl_region *cxl_decoder_create_dynamic_ram_a_region(struct cxl_decoder *decoder);
> >  struct cxl_decoder *cxl_decoder_get_by_name(struct cxl_ctx *ctx,
> >  					    const char *ident);
> >  struct cxl_memdev *cxl_decoder_get_memdev(struct cxl_decoder *decoder);
> 
> 

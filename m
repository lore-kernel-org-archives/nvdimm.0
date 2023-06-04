Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B445315A5
	for <nvdimm@lists.linux.dev>; Sun,  4 Jun 2023 02:57:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685847432; x=1717383432;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=OMPbzklvwTO/sfzC1w369U+d9V4Ur55w7BaorWTXPA8=;
  b=jK1s3HuaTvErjtXE6XZ5zVMwPgWBGK0YlZz11ivGkB/EzcWRQ7VTw2XQ
   eDKKilK9mDIQnKD4lhimLEatAsag1vW9r6mlp/u9ewgQGS6D7sXPoeH+E
   9kWfz8A9/4prOVZ+UNW+r12XCNPlucHWEUyRhIY+3d3ikipyQkQlhx7IY
   QZYy2gaUH87sxck1YSaXGP3KOaTpFTaMN/Z5dyxUIqgaHfJJ+xfknd3O1
   zqYEuJ9D2gbOS87HG9HRXy+RXPNz9URVq/J/cTLS8CktWAq3yFBS0248A
   fVX/5aGdsrK8ZTv2nVmEIJfxlbe7LZwcS7dLVQB8u1xa7+Vrj2k0ezU0D
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10730"; a="421966433"
X-IronPort-AV: E=Sophos;i="6.00,217,1681196400"; 
   d="scan'208";a="421966433"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2023 19:57:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10730"; a="852571053"
X-IronPort-AV: E=Sophos;i="6.00,217,1681196400"; 
   d="scan'208";a="852571053"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga001.fm.intel.com with ESMTP; 03 Jun 2023 19:57:11 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sat, 3 Jun 2023 19:57:11 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Sat, 3 Jun 2023 19:57:11 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.176)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Sat, 3 Jun 2023 19:57:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SvZB0jnWZZLRqu6NZouH/N31BFiDhECA0/WO7CR2GXU9033JaH5FjLUd3oCr8kiekBvH+EZCRux9dC+VUNkTKH0VY9z0GT4RSGXL+6DedwKkVZ+kcvLleDICwNVLnpRgo4UG+n0ScjBkiZ5clnMjwc8tus2cMX32DZvuHCyL8V5ORm68zN4UUcelXoG6beMd1XlYcIl6I5y2KXW8bYrT5YfqnNQOn+Dq328o9JBLeeugW2G7dpayr4AU6LRS7GrL6tQmkDCRSythXZhsNoToBHHTb/MMyFAMqmGDuTUz5SuUhVShdPTyfj2Lx+gi3AZyhQXpUI4fsusnrPsy1OZPuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oa/QuxZWbUT2H0fFnH9OXwlnvQm9OANs8cbIug8oEg4=;
 b=DlSiE8eBlaiBIeBVTlqIRtrEK+v+CcvJtnRXzAv4wEXGRB7SYwi6/7Snww+dbUOflL6SlAPpB05Q/iEnEh9KoMtYK4vYjPWH0KohlHLwt4+dRB0l5+7WN/gsNpE/KGF9eJAia94R9lTlu7jDLJfcF2/PfV1pQc+WSdjZ+o3gpuhqMbcEmSA/OQm21fKjaBfgP17Y5VYXq2CPm41y1CkQD8zwiy4JB3aed777BhautC6C3CK9bVbiFuIUqTQP51+cqXFnfwaZsgvk8SvoTONCl22tWCh4qA3wKDgBGdUTu1skHytaL2MqrfgYyhwQsJE84IfdldzYN/pXyMrFCZRUkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17)
 by CO1PR11MB5012.namprd11.prod.outlook.com (2603:10b6:303:90::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.31; Sun, 4 Jun
 2023 02:57:09 +0000
Received: from SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::9679:34f7:f1b:1e7c]) by SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::9679:34f7:f1b:1e7c%6]) with mapi id 15.20.6455.027; Sun, 4 Jun 2023
 02:57:08 +0000
Date: Sat, 3 Jun 2023 19:57:02 -0700
From: Ira Weiny <ira.weiny@intel.com>
To: Dan Williams <dan.j.williams@intel.com>, <nvdimm@lists.linux.dev>
CC: Yongqiang Liu <liuyongqiang13@huawei.com>, Paul Cassella
	<cassella@hpe.com>, Ira Weiny <ira.weiny@intel.com>,
	<linux-cxl@vger.kernel.org>
Subject: Re: [PATCH 3/4] dax: Introduce alloc_dev_dax_id()
Message-ID: <647bfd7e1ef3_4c9842941c@iweiny-mobl.notmuch>
References: <168577282846.1672036.13848242151310480001.stgit@dwillia2-xfh.jf.intel.com>
 <168577284563.1672036.13493034988900989554.stgit@dwillia2-xfh.jf.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <168577284563.1672036.13493034988900989554.stgit@dwillia2-xfh.jf.intel.com>
X-ClientProxiedBy: BY3PR05CA0018.namprd05.prod.outlook.com
 (2603:10b6:a03:254::23) To SA1PR11MB6733.namprd11.prod.outlook.com
 (2603:10b6:806:25c::17)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6733:EE_|CO1PR11MB5012:EE_
X-MS-Office365-Filtering-Correlation-Id: 6e97a877-8516-4754-4f8f-08db64a7620e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iSGUMZ2QZAHRzbwTi/b3LJo/nPSPTI3wSIx2WeYfvun3Y3k2ctPTP2PEphfRUpTjqCKqMg0cmHnCp+gCSXBOoYKYxqWi9zzkhuCR7vYQ29LRy+gO0e2hmL1xq0uYbyjpCjUMAukXO+N9wGQs+pQxSYHHdZhmlChxCXL39nTPAXZnM5wFXXiXwCNaBqB6DnVAJooaOY9BdHk3etY949PKfgzaiTff2bkCOUTaH7F+Bg0zcPc79qnfZaTt9LKfaJjtgz2usXQQFIJVM1I+BqlJI037W2D4DRiUaEx9w35ERjmmtgMhDHb6tyMKSP0JQexr+IcYs5Rl0qG/whoT3zsj0allZpW9LnKqFJQG1mi5uqGqq9nkuPwfrkSNKCQbRtTZ1e/gKZY5sKOu1hth0vwDheCHnNDcWwcqU09lGaKN5olp1keTTxUtGHrTdyOw8ZnYlPg7y/OTzSqxpq/KxzAzGEhPx4iuWlL3fuesMx3cLQ77oUNiGoG50WcvAys1GGHD7jj3bpp+ITqKA7lLj+8Z07i888AdIwBm1gA+p7u5sV333S3K/6lYxZTBhZP7r97SIIp7n62k8dtO9dkB9m0URg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(396003)(346002)(39860400002)(366004)(376002)(451199021)(82960400001)(8936002)(8676002)(4326008)(66476007)(66556008)(66946007)(38100700002)(5660300002)(41300700001)(316002)(44832011)(54906003)(478600001)(83380400001)(2906002)(86362001)(6666004)(966005)(186003)(6506007)(6512007)(26005)(6486002)(9686003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qc36jXyX0g1V84FoEd1VW1J3Msrk5BDy6elLdG/KDQjP1z5vXkCHEDJu4kB+?=
 =?us-ascii?Q?3vQ7qjqfdKect5BG94Ff3n/1nBOIf3vhKjRn+8Y3iwxDCqpxiGG/Wtct55wI?=
 =?us-ascii?Q?vYMy93nj+/AauHK0uTY+SvFZRPxJYQdeu/4eue7HlpyTCq8msyTCIBtYjoj8?=
 =?us-ascii?Q?lwRp9HDwvFfX0P+SfyAepnj8vtxI1rw8pwJ9jfnom8sQvoY4LwzseQE5fOlE?=
 =?us-ascii?Q?HPlIz4e/xeSgyo+uDxALB8dKWC89oh/w5Qwy0rB9KU/GMILKaXENc/1NLjnk?=
 =?us-ascii?Q?I9JZY/RaDyygLhakgUnEKY12/OHzJ7kUFG2u7mvQqNB9WMyK8LI/na7BRXVM?=
 =?us-ascii?Q?RyRWMfMwrA7GAM6Fyov2Xw9V9IWWose8H3dgt1VQX28R9xcHqowTthEEZ+gG?=
 =?us-ascii?Q?2mWBlvYaPLXRCizWa+TcrdF22N0zMHGuVwsb1XzFf4V95qEMrMmCGf0gyqvy?=
 =?us-ascii?Q?q7u9EV8bdJEDeJNkbuu8+7T8MMdXg2Ji7K5b8XatAOkeLbLt2A8KQAfj2jyF?=
 =?us-ascii?Q?5cSLOawP3+e6nHidMxAr5r8x5h8n7Jd/RHzIKFPrglezCufB7ja+C5n7Egt8?=
 =?us-ascii?Q?I/OMDhX1lLTtxzQH4Bu34I+dc8PqpSRS8DjysWRHFM3pXDOS42FAMLBeCCQn?=
 =?us-ascii?Q?m7py0UjcFXlbFr2W3HI0uuChlljR6s3SHF+duOdj+BeVolihiEzg+fqjzdLT?=
 =?us-ascii?Q?RuOEhin8qYvxZWqOMRNiKJda18k/rDD+Cd6eFxTr+trtotIfFHrPNYigaySG?=
 =?us-ascii?Q?kmJxeYR4b0Ji4F6K/3Wn5baXJ31ftxD5/dVHNxYkj3A92AE4sq5JmQoGizww?=
 =?us-ascii?Q?6cJnBktnMmcFdvVMqsHnbSxJiav0/DdlFrC3UKhKQwDkF+yXDynmmaIlffsA?=
 =?us-ascii?Q?w65y3wadaBuTFzwpFVePu0trVK7ePCgByM68BDeGJZFd7PzkU6QjP12+R2da?=
 =?us-ascii?Q?FdQixJHvTbhDCDdxRdZJa7e8OHX4uV5dv3hRUBV48uIgxK0JJMHU3HhdaXY3?=
 =?us-ascii?Q?G0/LqP8wNls5paF1bPL1ppTjTFdZcuOYn6S74ykrsXKC7fALVuMX/L1Rvivc?=
 =?us-ascii?Q?4oc/4HV8ojhQdInGQP1y/vncGu07eMoPGuhXp1WJJBE8LJTXuaNzSCfUMDGN?=
 =?us-ascii?Q?4PE+y1mqoWMyGbso1+FRDMqSyafSovDQ5jvRPjNb6H0vHZxrkpRGtJgiSNhV?=
 =?us-ascii?Q?R0gBXTUlAMF728Y0iqtAmJ4ZUu2jKAU7aEgf4G7a6O2HrQaKS/80vhStjbB6?=
 =?us-ascii?Q?+3mVJFOP4M3Pknw5CAWMmP4t4rkliNqD0pvyLjTClI7ZJUatT22WFRMXjFId?=
 =?us-ascii?Q?Wx+A/BLqbQqdoDaoZ7ArB6ggt/RVDmWaeHfo4LpNnxwikigvOdWNw+nR3fLG?=
 =?us-ascii?Q?4PMZALLC5YLhyolgctkJzC06FUIJ2TGpPM0JpUjCafSkXP68kfV7rIF16R1E?=
 =?us-ascii?Q?yZhU1bAAgpw7LzZFdu48vDEESPflAbFRzv0ieScui7y0jTbJErSPpHCA/pk9?=
 =?us-ascii?Q?MLjzpEt3WMz74CYtIG6w8j+XzqEMu2xmOOSWMWtdBcHpH5GKu+sBXsTrV8iW?=
 =?us-ascii?Q?7SYzmliuDSvq9kuqZGTQmAkHwDkMfm20qZOu5Fq0?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e97a877-8516-4754-4f8f-08db64a7620e
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2023 02:57:07.6463
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lGCoaVaAHePG0jwI2mbtFZnY9Cw7uZMbUv+2jGcUEExcJ4h+I22qj7ht0KP0c3PUFbWsaO4VaaNA2iEc/CTj7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5012
X-OriginatorOrg: intel.com

Dan Williams wrote:
> The reference counting of dax_region objects is needlessly complicated,
> has lead to confusion [1], and has hidden a bug [2]. Towards cleaning up
> that mess introduce alloc_dev_dax_id() to minimize the holding of a
> dax_region reference to only what dev_dax_release() needs, the
> dax_region->ida.
> 
> Part of the reason for the mess was the design to dereference a
> dax_region in all cases in free_dev_dax_id() even if the id was
> statically assigned by the upper level dax_region driver. Remove the
> need to call "is_static(dax_region)" by tracking whether the id is
> dynamic directly in the dev_dax instance itself.
> 
> With that flag the dax_region pinning and release per dev_dax instance
> can move to alloc_dev_dax_id() and free_dev_dax_id() respectively.
> 
> A follow-on cleanup address the unnecessary references in the dax_region
> setup and drivers.
> 
> Fixes: 0f3da14a4f05 ("device-dax: introduce 'seed' devices")
> Link: http://lore.kernel.org/r/20221203095858.612027-1-liuyongqiang13@huawei.com [1]
> Link: http://lore.kernel.org/r/3cf0890b-4eb0-e70e-cd9c-2ecc3d496263@hpe.com [2]
> Reported-by: Yongqiang Liu <liuyongqiang13@huawei.com>
> Reported-by: Paul Cassella <cassella@hpe.com>
> Reported-by: Ira Weiny <ira.weiny@intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  drivers/dax/bus.c         |   56 +++++++++++++++++++++++++++------------------
>  drivers/dax/dax-private.h |    4 ++-
>  2 files changed, 37 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
> index c99ea08aafc3..a4cc3eca774f 100644
> --- a/drivers/dax/bus.c
> +++ b/drivers/dax/bus.c
> @@ -446,18 +446,34 @@ static void unregister_dev_dax(void *dev)
>  	put_device(dev);
>  }
>  
> +static void dax_region_free(struct kref *kref)
> +{
> +	struct dax_region *dax_region;
> +
> +	dax_region = container_of(kref, struct dax_region, kref);
> +	kfree(dax_region);
> +}
> +
> +void dax_region_put(struct dax_region *dax_region)
> +{
> +	kref_put(&dax_region->kref, dax_region_free);
> +}
> +EXPORT_SYMBOL_GPL(dax_region_put);
> +
>  /* a return value >= 0 indicates this invocation invalidated the id */
>  static int __free_dev_dax_id(struct dev_dax *dev_dax)
>  {
> -	struct dax_region *dax_region = dev_dax->region;
>  	struct device *dev = &dev_dax->dev;
> +	struct dax_region *dax_region;
>  	int rc = dev_dax->id;
>  
>  	device_lock_assert(dev);
>  
> -	if (is_static(dax_region) || dev_dax->id < 0)
> +	if (!dev_dax->dyn_id || dev_dax->id < 0)
>  		return -1;
> +	dax_region = dev_dax->region;
>  	ida_free(&dax_region->ida, dev_dax->id);
> +	dax_region_put(dax_region);
>  	dev_dax->id = -1;
>  	return rc;
>  }
> @@ -473,6 +489,20 @@ static int free_dev_dax_id(struct dev_dax *dev_dax)
>  	return rc;
>  }
>  
> +static int alloc_dev_dax_id(struct dev_dax *dev_dax)
> +{
> +	struct dax_region *dax_region = dev_dax->region;
> +	int id;
> +
> +	id = ida_alloc(&dax_region->ida, GFP_KERNEL);
> +	if (id < 0)
> +		return id;
> +	kref_get(&dax_region->kref);
> +	dev_dax->dyn_id = true;
> +	dev_dax->id = id;
> +	return id;
> +}
> +
>  static ssize_t delete_store(struct device *dev, struct device_attribute *attr,
>  		const char *buf, size_t len)
>  {
> @@ -560,20 +590,6 @@ static const struct attribute_group *dax_region_attribute_groups[] = {
>  	NULL,
>  };
>  
> -static void dax_region_free(struct kref *kref)
> -{
> -	struct dax_region *dax_region;
> -
> -	dax_region = container_of(kref, struct dax_region, kref);
> -	kfree(dax_region);
> -}
> -
> -void dax_region_put(struct dax_region *dax_region)
> -{
> -	kref_put(&dax_region->kref, dax_region_free);
> -}
> -EXPORT_SYMBOL_GPL(dax_region_put);
> -
>  static void dax_region_unregister(void *region)
>  {
>  	struct dax_region *dax_region = region;
> @@ -1297,12 +1313,10 @@ static const struct attribute_group *dax_attribute_groups[] = {
>  static void dev_dax_release(struct device *dev)
>  {
>  	struct dev_dax *dev_dax = to_dev_dax(dev);
> -	struct dax_region *dax_region = dev_dax->region;
>  	struct dax_device *dax_dev = dev_dax->dax_dev;
>  
>  	put_dax(dax_dev);
>  	free_dev_dax_id(dev_dax);
> -	dax_region_put(dax_region);
>  	kfree(dev_dax->pgmap);
>  	kfree(dev_dax);
>  }
> @@ -1326,6 +1340,7 @@ struct dev_dax *devm_create_dev_dax(struct dev_dax_data *data)
>  	if (!dev_dax)
>  		return ERR_PTR(-ENOMEM);
>  
> +	dev_dax->region = dax_region;

Overall I like that this reference is not needed to be carried and/or
managed by the callers.

However, here you are referencing the dax_region from the dev_dax in an
unrelated place to where the reference matters (in id management).

Could alloc_dev_dax_id() change to:

static int alloc_dev_dax_id(struct dev_dax *dev_dax, struct dax_region *dax_region)
{
...
}

Then make this assignment next to where the kref is taken so it is clear
that this is the only user of the reference?

I did not pick up on the fact this reference was only needed to free the
id at all in reviewing the code and I think this would make it even more
clear.

Ira

>  	if (is_static(dax_region)) {
>  		if (dev_WARN_ONCE(parent, data->id < 0,
>  				"dynamic id specified to static region\n")) {
> @@ -1341,13 +1356,11 @@ struct dev_dax *devm_create_dev_dax(struct dev_dax_data *data)
>  			goto err_id;
>  		}
>  
> -		rc = ida_alloc(&dax_region->ida, GFP_KERNEL);
> +		rc = alloc_dev_dax_id(dev_dax);
>  		if (rc < 0)
>  			goto err_id;
> -		dev_dax->id = rc;
>  	}
>  
> -	dev_dax->region = dax_region;
>  	dev = &dev_dax->dev;
>  	device_initialize(dev);
>  	dev_set_name(dev, "dax%d.%d", dax_region->id, dev_dax->id);
> @@ -1388,7 +1401,6 @@ struct dev_dax *devm_create_dev_dax(struct dev_dax_data *data)
>  	dev_dax->target_node = dax_region->target_node;
>  	dev_dax->align = dax_region->align;
>  	ida_init(&dev_dax->ida);
> -	kref_get(&dax_region->kref);
>  
>  	inode = dax_inode(dax_dev);
>  	dev->devt = inode->i_rdev;
> diff --git a/drivers/dax/dax-private.h b/drivers/dax/dax-private.h
> index 1c974b7caae6..afcada6fd2ed 100644
> --- a/drivers/dax/dax-private.h
> +++ b/drivers/dax/dax-private.h
> @@ -52,7 +52,8 @@ struct dax_mapping {
>   * @region - parent region
>   * @dax_dev - core dax functionality
>   * @target_node: effective numa node if dev_dax memory range is onlined
> - * @id: ida allocated id
> + * @dyn_id: is this a dynamic or statically created instance
> + * @id: ida allocated id when the dax_region is not static
>   * @ida: mapping id allocator
>   * @dev - device core
>   * @pgmap - pgmap for memmap setup / lifetime (driver owned)
> @@ -64,6 +65,7 @@ struct dev_dax {
>  	struct dax_device *dax_dev;
>  	unsigned int align;
>  	int target_node;
> +	bool dyn_id;
>  	int id;
>  	struct ida ida;
>  	struct device dev;
> 

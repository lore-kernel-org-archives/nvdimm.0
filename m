Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67240A28
	for <nvdimm@lists.linux.dev>; Thu,  1 Dec 2022 02:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669861256; x=1701397256;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=aqhj+DmAsi3pJRFZrvLFGcpYU0wKAb5nnXiAXiMW3rg=;
  b=GNt6BXSEhrKWZEPoj0571L7C1gX/I62POSky9M9ozKRlg0My4KCmQhJL
   TArdK+Gt4+sXCRKaqcu2T1wF9iTxefCvpu27sc9/c4gZyqyu9H+BNj26u
   k87t2oE1S5XhyWge1qPUJzpOYNRNcCk0pC6MpKpShmA0kh1AS8MSX6O2r
   KB+9M6sHStzsIeqOw+ibY9crpGPXM8n8+ftW/iQQ5iGQJZphPsyO1RQpS
   i4Uml2OjbqwtrpDppmuxu7Npao1LrCPcsz2PYA2ZGw6n6yyvXFtWHJEyK
   0kmbqE4pR920DcpU9aHBoJCqsYvZB+Wou382NhfcHHwV8SAp5XCRaVTW3
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="315586498"
X-IronPort-AV: E=Sophos;i="5.96,207,1665471600"; 
   d="scan'208";a="315586498"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2022 18:20:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="818863785"
X-IronPort-AV: E=Sophos;i="5.96,207,1665471600"; 
   d="scan'208";a="818863785"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga005.jf.intel.com with ESMTP; 30 Nov 2022 18:20:55 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 30 Nov 2022 18:20:55 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 30 Nov 2022 18:20:54 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 30 Nov 2022 18:20:54 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.102)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 30 Nov 2022 18:20:54 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=li2NahOpZYB3YIAgNgTZ4kSesHGf4KMS/i3TR2HYCFW1uTGaI2SctyMtJyKtbdLaqY6aL1GUoA/KH8rY5VC1uo+1JDzlZA3KxHe1IxSqoYvd61CFz67xk+N+VKWzrDKVX5XC0Rqd03gcloTaZlxsYDHA//Y/as/Crhbi+kMwMZkVsSfv7WmjMTlOyvIRVFKD3d5+Ngwa9CFeCaGxbNvxyvmea/gkp/26nplzF0c4vwhTGQZkNIBCaRMW3PFwS1+99Vr7poYnKVd3eK5dLpG4KGf5qAX+Rl72aAgaXnhCdKEVy1WFncFmQB1EjnqYxKVQCM5s8IZv6oibnCsrXtDMyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CRWuFtnztG3MudY9ZC5RInUEcKu7bKJFuqsjK5DQUok=;
 b=lDGwTacF7FS4DTHxy8lGPWPIvzvdI0WVcGSnaeG6+ksQAStQG+J7VU6XcgDeOB9xkqUcRvACkji9AlLvhvwfZ0OnWTQn2dloft4rR1+S3+RyUTXND4sNCTb7yBjJjplNr7AGclYnH2FtqnFxuUvm7+gjxnfXTVtMj/lHy1QGnO1LWsjQR+AYm+BlfNThIFRAtYF4dTUPjXteCR9QLqbTz+k+nRm7w8fCBvCGFCc4oLNSh9Nvn3d0blTbPn5OyMm5l+oAdHe6hBG2q3TVyiQRmrs6W/N92ET4L6b2G1bomdKN03S5XpGg4Xus2nW00jYc/OKXnkNhhZq5n/fvdHrcXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by PH0PR11MB5611.namprd11.prod.outlook.com
 (2603:10b6:510:ed::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Thu, 1 Dec
 2022 02:20:52 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::340d:cb77:604d:b0b]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::340d:cb77:604d:b0b%9]) with mapi id 15.20.5857.023; Thu, 1 Dec 2022
 02:20:52 +0000
Date: Wed, 30 Nov 2022 18:20:50 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: Dave Jiang <dave.jiang@intel.com>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>
CC: <dan.j.williams@intel.com>, <ira.weiny@intel.com>,
	<vishal.l.verma@intel.com>, <alison.schofield@intel.com>,
	<Jonathan.Cameron@huawei.com>, <dave@stgolabs.net>
Subject: RE: [PATCH v7 20/20] cxl: add dimm_id support for __nvdimm_create()
Message-ID: <63880f82ad56_3cbe02949e@dwillia2-xfh.jf.intel.com.notmuch>
References: <166983606451.2734609.4050644229630259452.stgit@djiang5-desk3.ch.intel.com>
 <166983620459.2734609.10175456773200251184.stgit@djiang5-desk3.ch.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <166983620459.2734609.10175456773200251184.stgit@djiang5-desk3.ch.intel.com>
X-ClientProxiedBy: BYAPR05CA0034.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::47) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1101MB2126:EE_|PH0PR11MB5611:EE_
X-MS-Office365-Filtering-Correlation-Id: b5ad199a-4613-468d-a858-08dad342ab4f
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +RtbcThNyNXWeqsoJp9JHpQlDIOrA3SMOTUVEpSx5hfzAp494A+sOqdf7OWzKmiG/F4Cxen+BXO03fy5Um0ESm9HQt6NhbQaz/i/nt7BKIRrkEJ7VbF5tvAISPbWlr7hCuPjes1TWMuQS6NkKK0vtOUP5B9MRGDE37KC2EBu6X2ntTT3DM81XDB1APDh9e23RCJli8W1qwTeNzUjReZ44ByVh5+p7SeeMa8tbDj0DeZr2G6Jt2zJbd57H+GAqMfRyqvWcptmw0645PhfLvih3HdPn8y79iWQ7tjHxsZnlWvogIY1Ol3rMoEVxetXSd4cQgFvyrAz2z2s9isL401W+nCQa2s8q9mIrfCz6GvThJTTXxmX9i7KIZZuGizx+6pBX4eULKYEkr9h1ao0HywgOOlSaaBZlw6Q2lBGJctPzdulK0jwetEr7ujL+wtwaZrA/xWj0x9jqONYi1403bIgxz/3nQ86zgweZoHVk4VMUL+92/w7wFynwmF/pNfoqmi3oXmflxNTof1sf+4a+UwQ5XKJJotI0rwqUDgXOz/lXQ5Xltq9SjfHPXEUR1y178XU5gsYhs+rZaAoq4OLCZIKi4gNisRpzalgOck1vJeTnM3fpsy4Lru74Ji2Pnkk2ZPb6u7CdBNUVjBErDPFekXDLAUEb/QGtjsB5lIGT6uA6B8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(376002)(366004)(39860400002)(396003)(346002)(451199015)(8936002)(966005)(66946007)(9686003)(478600001)(6486002)(316002)(4326008)(66476007)(26005)(8676002)(6506007)(86362001)(6512007)(2906002)(186003)(5660300002)(41300700001)(66556008)(82960400001)(83380400001)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Zwc++hjLMHGkKcL9osYGqQ1e4KI+0fEH/LQR5PMlxmfQ8Mnh9P++V5O9Qvbk?=
 =?us-ascii?Q?HUGd4WyPTiBuEGYgTHrb7uwEeb8BoSk2dRq+c1YPNMza+9m/LTMgKO7z832k?=
 =?us-ascii?Q?f9UcLBHnxSrrjKWONwDNZRsBFix8UihxgI7+Cw21RIXikfWVWBHW9+jEayZS?=
 =?us-ascii?Q?eNVJKnnVYob3nOIyNgTPNDEsqzbmJ0e5Yts8aimqw5goEH7/DYWI+EqTJlL7?=
 =?us-ascii?Q?NHTHtm2yZCKiYk+RvK4iESlaE6AQr+S2WnUpPJ5tO2PtBRGibBFYcLmuD5+s?=
 =?us-ascii?Q?O4ylyykojP4N+Eg2pNEPsyqBvrHwFuXLxzNbNEh9Lv6TEPf5ILvW0PVgbJPs?=
 =?us-ascii?Q?JzQ5FckQ/RC+bRa5CD4OgxUNe4Q17KhMi4U1DtMvXHRTxVHQfCMcR9SNf7Dq?=
 =?us-ascii?Q?m/pDNudExANpjpZZStzKgBiXQbY+EQQY6XGbvXV56EMuBCtXlTLEYrU/mQEx?=
 =?us-ascii?Q?SDN9/d17yYc3kOepq4PiZIwW2QUgqkQULWXte1virHgrz0zYNM2lbSGrPvjn?=
 =?us-ascii?Q?wnnHWIxQ+dYD8c/6Az/JEUx5p466Kh9lb95QXll50lWDNeIFHjvuTtsBKwK5?=
 =?us-ascii?Q?uDHp20DNbomqIbwrp3LEbh6Tgy1fo+oC13Fq2dd27PXcfCYL+anTLA2Bzykp?=
 =?us-ascii?Q?flfG8KOeK9t0YusIVoHHfIKOUJsQi4r0WDZY6zJskeWALTIN0ujFgbfW/FWg?=
 =?us-ascii?Q?FH9bm6sSb6FAWAAcgVU/NrLDJCbrrBUZKkgDA32ZtfR0KwU57/NaWLMlQOaO?=
 =?us-ascii?Q?O2+E3pPSPxkXshw+/AgJkBLoOnJSQHmhjDdjGOXmkC2kyII96Pzb8WMJKkDl?=
 =?us-ascii?Q?klI554jrxzMPdsigEMNHaaEl0YVtFXN8/ng4qXw+RiVahnipqNnP/LtoLYC+?=
 =?us-ascii?Q?lGvi1PMTLR0xWaYXFC/ahtsyWzlaJ7KxO4PMZSB+4KgJq+/vvgJyV3yphrnp?=
 =?us-ascii?Q?84PyGktPTUVKOoPKETLdVc+ZO4HdqEJ8at3E4SsR4DG0IB7ISPPprZrmGmZj?=
 =?us-ascii?Q?1ZDlPIxpr2C1xUWr/IDJUBR5dNDM5zDkkQ/E8QfiD3W6uppMp1h3UO22XsOZ?=
 =?us-ascii?Q?IbFYSqQTW5H7V0ghcnvCllIK0E+10cB71RowJ8Obf2+UF15ocQ0Y/1QxxUIM?=
 =?us-ascii?Q?fyGeuAbr10FY1y/4oG7Tg71w1IIK8AzhEg+Q/OrF/5LFmSu361MQKG+O/nL9?=
 =?us-ascii?Q?Z+UG2+ySaPaRMuNTo1EtWG+Kj3y1Rde+0/hJVzzlVPnakd0K4WfTA7F70BqT?=
 =?us-ascii?Q?uXXTgGODsFe/G+UdJwddWsTOLeKA9bka3eFra7Asccr0buzVJ4ZrpJ4yxCi/?=
 =?us-ascii?Q?Bg3qW/DF3VO4Acpc3aikKRFFKyx5vQG8DJ8zdtqpzLoox1r3C6FHyHHAiapB?=
 =?us-ascii?Q?ejUm1MvjzLa55RC1gkr+Eo9GkflOv8T2479IDSvQtdNnrYHcqpLbOAdl2DUz?=
 =?us-ascii?Q?A2DtMm5RWMIZt3tTsFC3B4Lq7br2leYkiwhBCdnNbAV+XMfSU5jWScnFsUil?=
 =?us-ascii?Q?y5ZqHdMkyz38PDz2vf9FNkc/gFF3lrG7wihDAPTTqe6wp0NmUVnWUKdOCZsv?=
 =?us-ascii?Q?++Yh+aHZHfiXQfI5fABKwJpeWGVjxtwN8JsSwF0KxnYr25IrvjkF7TmzL9tC?=
 =?us-ascii?Q?Vg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b5ad199a-4613-468d-a858-08dad342ab4f
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2022 02:20:52.3804
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qyWHEMsKYuRURcNQMWmbfFXoLfyqSekKJNFXOqiQSrDhhPUbgXpWghKHDjT334ABCFx+bQxXIk+iIN0ON4KTCwHQ3MShQuJYIy79LNExGvs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5611
X-OriginatorOrg: intel.com

Dave Jiang wrote:
> Set the cxlds->serial as the dimm_id to be fed to __nvdimm_create(). The
> security code uses that as the key description for the security key of the
> memory device. The nvdimm unlock code cannot find the respective key
> without the dimm_id.
> 
> Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> Link: https://lore.kernel.org/r/166863357043.80269.4337575149671383294.stgit@djiang5-desk3.ch.intel.com
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  drivers/cxl/core/pmem.c |   10 ++++++++++
>  drivers/cxl/cxl.h       |    3 +++
>  drivers/cxl/pmem.c      |    3 ++-
>  3 files changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/cxl/core/pmem.c b/drivers/cxl/core/pmem.c
> index 36aa5070d902..f985d41f8f8e 100644
> --- a/drivers/cxl/core/pmem.c
> +++ b/drivers/cxl/core/pmem.c
> @@ -224,6 +224,7 @@ static struct cxl_nvdimm *cxl_nvdimm_alloc(struct cxl_memdev *cxlmd)
>  {
>  	struct cxl_nvdimm *cxl_nvd;
>  	struct device *dev;
> +	int rc;
>  
>  	cxl_nvd = kzalloc(sizeof(*cxl_nvd), GFP_KERNEL);
>  	if (!cxl_nvd)
> @@ -239,6 +240,15 @@ static struct cxl_nvdimm *cxl_nvdimm_alloc(struct cxl_memdev *cxlmd)
>  	dev->bus = &cxl_bus_type;
>  	dev->type = &cxl_nvdimm_type;
>  
> +	rc = snprintf(cxl_nvd->dev_id, CXL_DEV_ID_LEN, "%llx",
> +		      cxlmd->cxlds->serial);

So ->dev_id at 19 bytes can fit any value of serial, so there is no need
to check for errors here even if the 0x prefix is included. I notice
that for the nfit case this value is a string not a number so it's ok to
leave off the 0x.

Any concerns with me just deleting this error case when I apply it?

> +	if (rc <= 0) {
> +		kfree(cxl_nvd);
> +		if (rc == 0)
> +			rc = -ENXIO;
> +		return ERR_PTR(rc);
> +	}
> +
>  	return cxl_nvd;
>  }
>  
> diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
> index 7d07127eade3..b433e541a054 100644
> --- a/drivers/cxl/cxl.h
> +++ b/drivers/cxl/cxl.h
> @@ -420,11 +420,14 @@ struct cxl_nvdimm_bridge {
>  	enum cxl_nvdimm_brige_state state;
>  };
>  
> +#define CXL_DEV_ID_LEN 19
> +
>  struct cxl_nvdimm {
>  	struct device dev;
>  	struct cxl_memdev *cxlmd;
>  	struct cxl_nvdimm_bridge *bridge;
>  	struct xarray pmem_regions;
> +	u8 dev_id[CXL_DEV_ID_LEN]; /* for nvdimm, string of 'serial' */

Any reason to use u8 instead of char? It really is just a string.

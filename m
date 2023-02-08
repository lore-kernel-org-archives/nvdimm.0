Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DE8436E
	for <nvdimm@lists.linux.dev>; Wed,  8 Feb 2023 05:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675834926; x=1707370926;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Mo2OSspS+MaIysRfoQ4qeSa6jhDUmYO9IH9dTzg4o30=;
  b=EoImoaa4DUnqwH7HdWbqGdzr2YHz51Bvu33wyjcoXEPVRgKWJSa4kai3
   NHbgPfSUykhkhUq+/UKkD4/zfAtvo3tlx2KTfhp57Pz6mDCnYkd7jUx6i
   FVjTnmT47Zu59cgXXimcaE0TLqp4eb3S2BB3XjzO/rzkh9mQ1hvjitJ6y
   Ny27P3kje6vXNbOlQX2hMV8TFQPf/gHdl6CYU4j9D7+7r2amvSqwGasI+
   VHDrLZejqIVDvnYcrUISLOo9AvMTGMyNC9/z8o65LPsVxdLhlnw28+TZH
   JguckjfhcYFN8fg1qHtrQvhLsIUkM5omXyFQpYkvMa2PNHm09DDLev079
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10614"; a="415938299"
X-IronPort-AV: E=Sophos;i="5.97,280,1669104000"; 
   d="scan'208";a="415938299"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2023 21:42:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10614"; a="809815596"
X-IronPort-AV: E=Sophos;i="5.97,280,1669104000"; 
   d="scan'208";a="809815596"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga001.fm.intel.com with ESMTP; 07 Feb 2023 21:42:05 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 7 Feb 2023 21:42:05 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 7 Feb 2023 21:42:05 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.44) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 7 Feb 2023 21:42:04 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R5BdXmTOlRnypdC7MdzQqGn6eF60WXJXph6NW2SrpcpDB2Y90pjSiXY6M3W0vIP0DrwBNkCm1wapHFdFJv2qorRYIpaNx9o1/MnxhtMMaaXk2EtLscHpKUloY6GRkj2Gzi05UIZ9n/Bk31QUs9p5Xw+dPyK7pGqnihoOUFyLh2R7cHe2In0+qN5y++1LSGgWO0sg6uV5FOJxTbZvalwmbdMjZz5W/tNwU2rWXMqWe+DHNJwsPpilTxb00rzhg0vg845VLC+sqP9b7QLME/JhPVFoHsG5OD3MhSY27YtMnUt2nDeuZIucUTqjsM+LXHJh71FLN98FKOVc4shabpqLVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M0e91/0MqVZE/7r9VlYyjRqjfKolevzdtFOnFr9Czus=;
 b=jrGhsraLnU0L2apXNPtNNfN4i/rjOGtFmL8eaRdUAbj6vvy1lFmyNf8y7S6JP+vix8vvi30irjfupU99DO+jU+b1YoJzAVQmn3QbPycvbcjr2khAJZdooIwCQ1UHb14p8yw1RGQSXYd2A8lbQfIhwRRQxetrsVBlUBeJsuXhD6d73ZHG9vNRZ27NlylT2a5e/nfq2UooENGLORtQxvee0fEg+4e0PynXbpRfROOv7s81VqqcnW8UftAiShh4uBvbS/A5w86GV5hy0d7hakxOw29j4QFKAKK1BR1kEJnlpD3mpsO1wxk45q7O4ZvpoBeuFQsLRvPrgZ2Fa4X3+F11RA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by PH0PR11MB5612.namprd11.prod.outlook.com (2603:10b6:510:e7::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.17; Wed, 8 Feb
 2023 05:42:03 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::421b:865b:f356:7dfc]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::421b:865b:f356:7dfc%6]) with mapi id 15.20.6064.036; Wed, 8 Feb 2023
 05:42:03 +0000
Date: Tue, 7 Feb 2023 21:41:59 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: Vishal Verma <vishal.l.verma@intel.com>, <linux-cxl@vger.kernel.org>
CC: Gregory Price <gregory.price@memverge.com>, Jonathan Cameron
	<Jonathan.Cameron@huawei.com>, Davidlohr Bueso <dave@stgolabs.net>, "Dan
 Williams" <dan.j.williams@intel.com>, Vishal Verma
	<vishal.l.verma@intel.com>, <nvdimm@lists.linux.dev>
Subject: RE: [PATCH ndctl 1/7] cxl/region: skip region_actions for region
 creation
Message-ID: <63e336273713a_e3dae294b9@dwillia2-xfh.jf.intel.com.notmuch>
References: <20230120-vv-volatile-regions-v1-0-b42b21ee8d0b@intel.com>
 <20230120-vv-volatile-regions-v1-1-b42b21ee8d0b@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230120-vv-volatile-regions-v1-1-b42b21ee8d0b@intel.com>
X-ClientProxiedBy: BY3PR04CA0029.namprd04.prod.outlook.com
 (2603:10b6:a03:217::34) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|PH0PR11MB5612:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a21e34e-aa75-48b0-597f-08db09973496
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: p0zZ9Hnj4e9nXKn096VmClqB1nNEYR/tfemSDcOj/zh8lSz9CgFvFyGPD6fdkyq1d6hCqyOg7n/DnwB9ML8bx1PCxoc8bsfx2CoDh7sCJTJVdONacjhoA+yrSVt0CaDaZ1fQSp+2Oe8PIkinnKNMENL5TqJJPTPGfYecLqP3wWozBi8y5E2w7wGPZ32FtIVF1XrHxsKtobsVPwjnX2mMu5/5awOERq2hA2Hv7wHYALPFFU+I8572NLZec1vx1tBjI+TgWu5v+43vVK2A3S0OFOaPM05zoRUVx7F20dU/3IGxy8AYuR+1gmpB6Ab7fZMmYDe17i4FmOZ087evZm3u/C/mY6bxdiOmnirmVL3XbgxJmYjGwwnlapSdbajHeBajJRCV8L4lctgPLugRsOguwgdLmlci47CY323xeySN+k+lN+QC8F9WCkPjPKDBySfxU1ycdvmz5a8EaIRLCZt2PELAP9kygltlwD8gb6BbneQGQsc7N6I1Q0AJhwqTZTTlqZ7AAbUi07lCBK/U3stkNmm/Dqopl28voQQwqEw88W/D92ImlaSaoUrX8W2J8dcX1l4CI022gTARmB+++Trpmw4mD+RHPOakAUh7k7rYpCIUOk/epU2yvGs4qaOQaDixB2Zf7OGz4+0WfwW4L6hc7A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(39860400002)(136003)(396003)(346002)(376002)(451199018)(316002)(83380400001)(2906002)(26005)(41300700001)(478600001)(54906003)(38100700002)(6512007)(6486002)(186003)(9686003)(6666004)(86362001)(8936002)(6506007)(5660300002)(4326008)(8676002)(82960400001)(66556008)(66946007)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lSIk3nT17yo5ss5vpl7LX7DE82BLm0B+Uaa5tgY5Z5j27icYG1+sWnd2P7vo?=
 =?us-ascii?Q?YLN2JyaRYFyQ7OHYnruqSgvvd4MRfumFM7sRUBkZ/2KT2ryFTpe8HxZiBZ0O?=
 =?us-ascii?Q?jW/lzXLP7u928X63fZ8BzLG+yQswupgyp9SfSWsxF4oTYvWEzXFg7H7toYTn?=
 =?us-ascii?Q?pPipQtolP6TabB2sngoDO2HeManOma8gehGNxkkjeu4JKe/0fpDsOobdFFi/?=
 =?us-ascii?Q?TNP8ue4S7HhdWwb6hunbC31pZ0vR8JCDN4wvn0g0hCagV/hk6HTX2Il3f1Nc?=
 =?us-ascii?Q?efcOf+59A478SDpbeRUb1GuJMTZHdKH8YmF8Y0mRK44LHcrGvFhlvNvg0l65?=
 =?us-ascii?Q?7kfeTJWwpfdpFpppUhSn87aDLhIzcVWiF+Lm4oR/v9aFGRDccQafwyHEg/dK?=
 =?us-ascii?Q?35+lMiDqJ6LjsYMrgwFYz0R0rCP8qQz/T3P2/fC6Z7goH6/60Rcw3HoTVN3C?=
 =?us-ascii?Q?Ewk+159loJ/5XyUNU+aEhpBfpM5pvws9o+z/gAX4S16Rpi8hOS0uG7DTuvUC?=
 =?us-ascii?Q?isbQBv8L/JSVCNgtld5oUnA99NEOr/Zc9kChisZ3DppSxoh4qibzhVCGU3bX?=
 =?us-ascii?Q?7YqchpRQe5iQwq8Qm6Ey4aQaFKC5QXOLjQU/M9dAsPNmWQDmMGYRflrNNUPt?=
 =?us-ascii?Q?jyNRZiyYbAz1qBROHt7shlXxVXRDA+2D6Qgipleil3ierfyNQmyUEv7Zvsgs?=
 =?us-ascii?Q?8l/ufZRR67ipDyevhAmZLJCwEJtVP34x0r7Dicg9npz1klmzpIO4HtItteyJ?=
 =?us-ascii?Q?aovi2ygOULcaI1tWOCCSBLW/nY1tqhR+N3iHHqCJIrCsQh968whjkXpBTQcM?=
 =?us-ascii?Q?TtI+PSh2E5yW0772Dcdv2dEiAP0RSu5EX9dTv+JStu38tOWoNSwxac4+Yk2K?=
 =?us-ascii?Q?w8HrhqndhdmNihhJCkmLXU/Btnk1GfViE67enPJew6/erl0mpSqmCnNvpoD1?=
 =?us-ascii?Q?phMszARHq2iN8z8H8Wuws5mx/W553Oy8p79OjjtHl7QuHPA1heq9WCm0elhu?=
 =?us-ascii?Q?oh3TpBiq+oJC4qEVQKbOY2ZhQS755pGu4aqUpoHYUcjXdyBeiPsGDaLAFDJE?=
 =?us-ascii?Q?KuHv3B23FLBxla4C2LGn4+uvYADbmHqOGYh7bYPv9uBc1k8gI4RP/+XVOlo9?=
 =?us-ascii?Q?J1ii8o8K55GvaVYKOEj2f3OHurwoxul1shvwG4K+s4rC4t62Fh634ANbs6oW?=
 =?us-ascii?Q?2kioO5nxIJCwK7rbkxxACElUwWtxPmNNJ2lBaRCT/1U6xPehTPFVSfE65iBJ?=
 =?us-ascii?Q?SChITlTJTtC/eqQvVhcAPf3lIPJVQ6UvDu3uIs8IggvuqS/cB5yczI9CBK3A?=
 =?us-ascii?Q?iNW4Er3O4tYxLsgK2CToqWlIPQvATYpu2k9Wguuvu3GJ+eNc1ouRFZnyX0Pn?=
 =?us-ascii?Q?oLSJb9wsXgHRDjo+EdPcjVEIPmG2S7Vf4zZooBlSRsSgVmxEAk9iOInRAPUh?=
 =?us-ascii?Q?/ZsgsrzpEcp1zn7g3tU2ENP4RZrByibBXJTnmqzbGwFCSI/X4cA3IiO2GX91?=
 =?us-ascii?Q?hWT12iWmVfMmGk6CJx9HkJc4INxueWRq89T589lfnw+dhkvs9K8+ldQDxVhQ?=
 =?us-ascii?Q?Ps8PKfRWxLMK8qw0LDAOPotVuKnmUWUT8dUtAoRYuSTJ1rIvxEBDpGi9bB6Q?=
 =?us-ascii?Q?Ow=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a21e34e-aa75-48b0-597f-08db09973496
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2023 05:42:03.1443
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qsxJGSMRH6dQtR80P7YM51b6IVJrU1jGSvT9vtow2fmlMHyvROgSNOxhziFCBnjS9cEVn9wqsRmGghpwH5mocfGcJAar7wsDn0IVLfDell4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5612
X-OriginatorOrg: intel.com

Vishal Verma wrote:
> Commit 3d6cd829ec08 ("cxl/region: Use cxl_filter_walk() to gather create-region targets")
> removed the early return for create-region, and this caused a
> create-region operation to unnecessarily loop through buses and root
> decoders only to EINVAL out because ACTION_CREATE is handled outside of
> the other actions. This results in confising messages such as:
> 
>   # cxl create-region -t ram -d 0.0 -m 0,4
>   {
>     "region":"region7",
>     "resource":"0xf030000000",
>     "size":"512.00 MiB (536.87 MB)",
>     ...
>   }
>   cxl region: decoder_region_action: region0: failed: Invalid argument
>   cxl region: region_action: one or more failures, last failure: Invalid argument
>   cxl region: cmd_create_region: created 1 region
> 
> Since there's no need to walk through the topology after creating a
> region, and especially not to perform an invalid 'action', switch
> back to retuening early for create-region.
> 
> Fixes: 3d6cd829ec08 ("cxl/region: Use cxl_filter_walk() to gather create-region targets")
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  cxl/region.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/cxl/region.c b/cxl/region.c
> index efe05aa..38aa142 100644
> --- a/cxl/region.c
> +++ b/cxl/region.c
> @@ -789,7 +789,7 @@ static int region_action(int argc, const char **argv, struct cxl_ctx *ctx,
>  		return rc;
>  
>  	if (action == ACTION_CREATE)
> -		rc = create_region(ctx, count, p);
> +		return create_region(ctx, count, p);

Looks good, can't remember the motivation for changing that.

Reviewed-by: Dan Williams <dan.j.williams@intel.com>

...modulo the spelling fixes that Fan noted.

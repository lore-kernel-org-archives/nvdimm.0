Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91AF84C63
	for <nvdimm@lists.linux.dev>; Tue, 23 Aug 2022 17:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661275684; x=1692811684;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=UYdAWNUZWOHq7M8aEP3mhmoh72Ldlqo7+lYM1SVGwF4=;
  b=RsdP/zT9ZZs+bilnGcpmIPn54MfVBPysPCZ/LFo1+e+CkDcTBPm3JrBp
   IY0QSoCCVlafPZxTvcJhNzO48YjRgGUVzwvaBt1XdaMW0qDC5H62hXnL8
   QPdVBNSeTo5fbiko+jTHByQM9/UhttzUaK7LRDcgl77u5kQGfToAP91Pj
   8pnL3pxR9UXsBr8uXCdUYs60oXswxtgPrEkYztN06RD7KtitnhdErTfM8
   HHsLSxAD+L/3edLUDxoB7yN3aPxdIKke9baruXFJFIMvRWGnCXkO4mmfY
   MY3gJXrg1046o0o4s4Y0LAgwUnhPREbPU/oqFSG+ChT9Brbrz+mnaeoRr
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10448"; a="294539146"
X-IronPort-AV: E=Sophos;i="5.93,258,1654585200"; 
   d="scan'208";a="294539146"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2022 10:27:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,258,1654585200"; 
   d="scan'208";a="586083177"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga006.jf.intel.com with ESMTP; 23 Aug 2022 10:27:52 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 23 Aug 2022 10:27:52 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 23 Aug 2022 10:27:51 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 23 Aug 2022 10:27:51 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.170)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 23 Aug 2022 10:27:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YIJ/T9FAslPmgfAdSZ7xyyzc6Q1asUzbn/Wg3iB6scPdlpaD56hDrJa8GQ0amL6myy0tBB3p/jvnsCibPjcwsR64/ctELW43A+Ao6HKEhYhZF+MGY5GcyNwfoCu/PSbjmmqSodpqEkxgtLgJSvx9/AEpu+zVdHZv3dIp+M0wYHZtTHlbQH4TqfLVivq71DddI3cjoWCeVnxQxU/BkM8eTgiJpmL/yIeeNWb4LV9eGvDrfYZn1gacfmqhewmpevRCSEOWRvXLUcg8FWY9hcZYM2ZGy6ivel2YCPA1HRyzfAxByzjg/+hATOrex5Q0iXg2TJHb7Rs/CxuYc4FVZQsgdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5Ts65f8vNwZ4aJLVCivkLr1njzZ7iTwjXQvRHQNA44M=;
 b=GGfaS67PUhnL/Naw3VEr7Isdmg5IfMpnpR/KLNkFBUixecq6EyoIKQyYKMsGNxm16gY68fA27KOiPBKY7jaVf9yx540vJ4XzPmR0KAKsXPvwXAfLrsh6F+AUulcBX9GiI32lx6LeYfH5n/lq+TplVnlXlcO4Abjg31Vkh5lvZbPW+wqwhg+bAXtpMygPNzrHJF1EzcZrHTLeSq0GVZ9Z2PRU5IcdfRdFGgoh0d9GGYnTMAnn3vAvqDXFyr3sMjDtIAbhI6/0Kxt5SFvgpBPPJK6Opv3j0Ln1+iJp795eSj1B6vXQLITJtRkyecnJwjWwNdNEq9ftuf+PKaNsbO8P0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by CO1PR11MB4867.namprd11.prod.outlook.com
 (2603:10b6:303:9a::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.14; Tue, 23 Aug
 2022 17:27:49 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::9847:345e:4c5b:ca12]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::9847:345e:4c5b:ca12%6]) with mapi id 15.20.5546.024; Tue, 23 Aug 2022
 17:27:49 +0000
Date: Tue, 23 Aug 2022 10:27:47 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Vishal Verma <vishal.l.verma@intel.com>, <linux-cxl@vger.kernel.org>
CC: <nvdimm@lists.linux.dev>, Dan Williams <dan.j.williams@intel.com>, "Vishal
 Verma" <vishal.l.verma@intel.com>
Subject: RE: [ndctl PATCH v2 3/3] cxl/filter: Fix an uninitialized pointer
 dereference
Message-ID: <63050e13694fe_18ed72945a@dwillia2-xfh.jf.intel.com.notmuch>
References: <20220823074527.404435-1-vishal.l.verma@intel.com>
 <20220823074527.404435-4-vishal.l.verma@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220823074527.404435-4-vishal.l.verma@intel.com>
X-ClientProxiedBy: SJ0PR03CA0182.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::7) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6f9e5474-7a71-460a-83b3-08da852ccd4b
X-MS-TrafficTypeDiagnostic: CO1PR11MB4867:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7vQzrh7bktQpirp9B+mJN4Ab7UC6h2Gnm19LP0Lye949uaccNNE20lsbAeZcTChZ8eUBHc+XW+GbBijdq+PMeKoI5zCnEne33XWpT2PF/0pVhu2udqF63+065KYC2pP5TLeAUXNXXoEMgdRIsJ/44hfyWZ0cEePlO9a77VBLXFyAHoNmWeF46bt/PZXyAIAjyDeHOiA42xdp1hDHLr84TvknGJ2WVo+c8HQSgGaLllbc+isd7bP2z8E2qxyV+LlWG5ILlTd9PeHwyWDIiyFL+FOu3DjRVdeTsLkAG+Rh6C5zGNGxqp3GXyUXNrpg4IQTJMad5afVb41Mp0fKbspRPmcx329+igRTGzpMUAIUi7zgUAbCG6TUWV4pzYaCyiuxg3IDSKGbIXRLJA7F5mgMq4kP5fT50FmPhIzq0d7CN8RYQ5o/ow1uWyqdH/sbri36rTWjQFmUB73soI4sztLmuB0pkhyPvdEpSbFnQXvPqxTNa1mza91giayjQaE0tUzm5SNZM+uVZES4TmpFaUVR2Z6xzV0g9iT5cMvgK/hvjmJDfFIjtIiCexgdYX8sfXNiTt5rpL1HblJRim1BFrr2DgkujNzpdxB3hOFavH+I4fdTo/LpYe81lfrx1EEaz6M8x8TKMxTm8CIHjhV7F/S6FUSxUm4TZvUBgnNL1XNtmCYpnlqnQMmF1aPLZSpAj0QDCegh10t22+sAXMYmS+Sz8g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(39860400002)(366004)(376002)(136003)(346002)(8936002)(5660300002)(83380400001)(316002)(54906003)(186003)(38100700002)(66476007)(66946007)(4326008)(8676002)(478600001)(6486002)(66556008)(86362001)(41300700001)(9686003)(4744005)(6506007)(26005)(6512007)(82960400001)(2906002)(107886003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?C0Ls5bxo4rwqmppnK04BfLsNlGXXzUbgnzbk3Aob9jlRvcbgvG1wVPKtY/Wb?=
 =?us-ascii?Q?67nbOX9lzgGdiA6Fs7m1pdss0UNMDW7hkwfDH7aja9T54Xd9RMkjblerx3SY?=
 =?us-ascii?Q?6Fz1evXndbWd8EG8q8+9GniqPGv3tME0BAW18fg4rzvku892IzV9H29cSQLC?=
 =?us-ascii?Q?RXyz2caPrapwATAteJ6SOqaOwGo+Jg5wq+yzyy9uwsVLLXX2xlHfOVUH2YoK?=
 =?us-ascii?Q?pyfS+mieJkN+b7+M0L2eM7VCXg/jVX0NvuonHyxNcM0O/OiyzM22QNbkULw/?=
 =?us-ascii?Q?Km6kb9K1enG0Iz7giVJMwCd4e4vr8PTF2oRBxSok2MlPksUngZndBlDabN/t?=
 =?us-ascii?Q?IZE56q5VoeYxf1pavUJVLDjSRADp9mjqM+GQhDYzlMRLX19yxvCWAg12sO2R?=
 =?us-ascii?Q?psMc5mkU6Q0j21eKTMF/dVVumPv56NolzaFsjhnlf/XfKSuxClBekr8ZoCc7?=
 =?us-ascii?Q?q1xw31+xOgInvnwCkatuHEFs1G/tL9kIa9nhfa2CYo54LATErV6AnhcuJOBV?=
 =?us-ascii?Q?cky+0q6bEwX1rVpYFyHcE46NLFgmRqDQVSPeKwMeN+/vKxpCIb5fQfw6iNx1?=
 =?us-ascii?Q?sQhnEob3GRr8dJUSvAXSO6Hxvc6rrZ1u6Z8eYEf2ldaLD7dmaEXON2Alm53o?=
 =?us-ascii?Q?KXZ0JE54pBeqwpojrRnqY0iwwpF0M+4y7zRIAPDW8je5FjVYGuyKiH2NuOF4?=
 =?us-ascii?Q?20/Ws3VsIGHrb52+aeXXuI9tKFUuxeZLqh+HD1a381A/kMpwHU1tf36mjn/Y?=
 =?us-ascii?Q?a/7sMkOOhF85elfTcBbHXsqvy/fJkj3s/aQikkoKTmYxHFX9mVg9Mx6lMsR8?=
 =?us-ascii?Q?tKjh3DnP1NWYwpO+TJN1+qNcKFXUvth47n+xyN+He6ZJK2s7yEEB2cu9WLML?=
 =?us-ascii?Q?dq7BP8D7x6vCJ+5BHdUSlAiLRCaAqONE0Z7chueg1Af8D4PVEHxhsd0b00ee?=
 =?us-ascii?Q?edkm62BzDQfz1h5FtB6ftz6BQrzcQeipPXAirr6Y9LoyAUlcyNu33cGV4x0Q?=
 =?us-ascii?Q?tsmQVt2wBWrjMhk//EzzoUejJhnQKpxZDPoAawK9c3tYyWWKQESPihp4SYvM?=
 =?us-ascii?Q?iJSk/VjaUq6l2Mq6KHAvR5Zs6SvlCWpKRtVM9SsCM/4wlik0WD/5kSUhyrsy?=
 =?us-ascii?Q?gklOYbH7HIgT0fGq7kjebPn4EztEmEX217UIukbxAvKnz7nLdD4CssC/1GDW?=
 =?us-ascii?Q?9CtNUx1OqZdR40HtqxTFEGVpHQPvLVF8WRuIAtGbBQJqIoeJxBlXtZcEyNmd?=
 =?us-ascii?Q?rlglrzWWpHFtt8js0XFbrBgpK74JbJ9zMjFyDd+H76e4jvqhpqBafC2Y/8Id?=
 =?us-ascii?Q?QkzScUHQcZ2OfUmqWfBeXY1jXFtr4PnNMl+GhTIavF1cyYNUBLaxlYervFkd?=
 =?us-ascii?Q?RaQi/gvOH2PnPq6DXDqrqLbURGT0qSW5ED2cJFR8GpRh1BtwReEuNjSpOHTf?=
 =?us-ascii?Q?wRdcHOReO8wr4WPGVnVSijfdLI3aAa06EnLXp+XhvNh0rzy9xhB1wtUvv73w?=
 =?us-ascii?Q?ktkUprjlrE/K13O9Bptr8KAqwCj4Cpfd11Lv0CMBZPuIlgXdL+p1D05gp+at?=
 =?us-ascii?Q?JelOfJaOj5XuWCyx7VPVC6JK6G/qSyxvEI+8+FZwzlutt/2hsQjVrFPdocTz?=
 =?us-ascii?Q?4A=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f9e5474-7a71-460a-83b3-08da852ccd4b
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2022 17:27:49.7554
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jV49OFPJJr8Eg32aqL+bLL8VWk72RHstnLC9wGiUMkHjYc7cPrhpbvnu8x1n9Q7xtg+hESsjfYsvanfItCGdN81/3LjVbjBmhk204Kf9BSY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4867
X-OriginatorOrg: intel.com

Vishal Verma wrote:
> Static analysis points out that there was a chance that 'jdecoder' could
> be used while uninitialized in walk_decoders(). Initialize it to NULL to
> avoid this.
> 
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  cxl/filter.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/cxl/filter.c b/cxl/filter.c
> index 9a3de8c..56c6599 100644
> --- a/cxl/filter.c
> +++ b/cxl/filter.c
> @@ -796,7 +796,7 @@ static void walk_decoders(struct cxl_port *port, struct cxl_filter_params *p,
>  	cxl_decoder_foreach(port, decoder) {
>  		const char *devname = cxl_decoder_get_devname(decoder);
>  		struct json_object *jchildregions = NULL;
> -		struct json_object *jdecoder;
> +		struct json_object *jdecoder = NULL;

Looks good,

Reviewed-by: Dan Williams <dan.j.williams@intel.com>

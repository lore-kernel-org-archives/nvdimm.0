Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CE2B39E
	for <nvdimm@lists.linux.dev>; Wed,  8 Feb 2023 05:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675835468; x=1707371468;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=4kDk8aOEtPyLDk8HlKimjNbq8GmyFrE5rXpnlInyBS0=;
  b=QFCwDmAznpgBUUSD9vrowlAQ+YPuxGIt32S6hTKjYJMP/laJoNbWudGf
   5yCMHkTHrXHzbVOtqWyonV3N7c0FRsHxHeJjMs9fbnXzLO2Nwl7K46lai
   j4RvCuxOpx1B1n0eWGSGwazf/8xUjfrH/VgqrdCrHePNTrwpQZLZ0lrEj
   RM+BBIfgXTW0CnWb64M1oyZuIS6ZrHDISNDKBX6WOuEIOcQCioljCs0Fe
   DoGPg6VbMvF7aFdaM3LNneIwUQClLkRYdfXxcuYVSmLKJ0KRazX233N//
   3G3ZEdA3C9//TwQars3O+YUshrkTNQ9pETVE7zCDawHqcRstR4DAyciPJ
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10614"; a="328372753"
X-IronPort-AV: E=Sophos;i="5.97,280,1669104000"; 
   d="scan'208";a="328372753"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2023 21:51:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10614"; a="996010090"
X-IronPort-AV: E=Sophos;i="5.97,280,1669104000"; 
   d="scan'208";a="996010090"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga005.fm.intel.com with ESMTP; 07 Feb 2023 21:51:07 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 7 Feb 2023 21:51:06 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 7 Feb 2023 21:51:06 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.49) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 7 Feb 2023 21:51:06 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L0msOWLIg+ErVN6r79nz7vIBt4DuDMymPRvJGgk47vBbseBAX20EJMRCIzKBtR+8hW35mjzgq9r+8+R8dirs+rgW64w6vBRiHPaoCkXHZeKNQVXDywk58aobrKfoP7DizOldgSevseVu5rCZcUgb8lCvjI9I9XQ2yjeCliwNZ4c/LE9k2z690pZB5qegAVI7ty0rFt7/VAiH6d9ds22p9JsEl6Mf9e3G9shLlXiVi9Cn33k9vo1Hc1IHfURDUSyUS4SIce2XMv5JMzPT65ugSEX9U3PG8t2QYXtnfzsIwwYkdoOF6aplKMXQOAg/VOj0vg8KXPK+8n8Hxa2Dej+wNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2STIDoQUJQxKvMu+Dn2EJg/QeCwFCQ+r9ZhFlVQTnSg=;
 b=V3BO29n/GyAwTak7S1PjHzuci7i6/mX/zHFp0Xys5qpleFsIM+YL5myUa2tQunEQHopd623h3x7+mB0nca3hx808jFrz9EDTgh+L24IhCKHUNj00lQ6RafKqyRnwoPDxPvptzftMSJw98CDIL5vfVXsqWWXvi2hFO3rcAenSlvnw/vMQ+NmqTlOsenYMQlNK4q2X5d6OMGKWXfevr8vu8oS/OSBvjwXCFWhlyASBee4c+LJfR0+ZmzQgelh0SOvsSaevbNd9m4UdXuS7j+Hdj63SDPoHjFybmH4q7M7BB9dlLGlw5VMLjFofatRH2E/kH5Q8UpSJ3FL3Vg4IzpBJNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by BL3PR11MB6505.namprd11.prod.outlook.com (2603:10b6:208:38c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Wed, 8 Feb
 2023 05:51:05 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::421b:865b:f356:7dfc]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::421b:865b:f356:7dfc%6]) with mapi id 15.20.6064.036; Wed, 8 Feb 2023
 05:51:05 +0000
Date: Tue, 7 Feb 2023 21:51:02 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: Vishal Verma <vishal.l.verma@intel.com>, <linux-cxl@vger.kernel.org>
CC: Gregory Price <gregory.price@memverge.com>, Jonathan Cameron
	<Jonathan.Cameron@huawei.com>, Davidlohr Bueso <dave@stgolabs.net>, "Dan
 Williams" <dan.j.williams@intel.com>, Vishal Verma
	<vishal.l.verma@intel.com>, <nvdimm@lists.linux.dev>
Subject: RE: [PATCH ndctl 4/7] cxl/region: accept user-supplied UUIDs for
 pmem regions
Message-ID: <63e33846309c3_e3dae2949f@dwillia2-xfh.jf.intel.com.notmuch>
References: <20230120-vv-volatile-regions-v1-0-b42b21ee8d0b@intel.com>
 <20230120-vv-volatile-regions-v1-4-b42b21ee8d0b@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230120-vv-volatile-regions-v1-4-b42b21ee8d0b@intel.com>
X-ClientProxiedBy: BY5PR17CA0068.namprd17.prod.outlook.com
 (2603:10b6:a03:167::45) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|BL3PR11MB6505:EE_
X-MS-Office365-Filtering-Correlation-Id: 489baf04-eecf-4444-03f2-08db09987766
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0Zeu8+4pX2t8fPB7wQGkzc0VieiMyPvrhxOFL+b0tp6YUbUjpzE2n61cyKm8cuKMn/iZ0IT3vNqUajP6DK1/6MM69fW44+kvJ2FEqM6wqRUzi/D3wAu63Eb2J390Qvqbh0q2ok16SY+tYeOpYIXmNgFl5fLWaORZ8sVOkK2gNu/JAqBDoNI2UKEPBFn/PC05LXgkZm6Gd2gpxQLVU9c3EdueXlYvxULcQLY2wwQJecsTvCy1QMDI7jbq9PoFSIi5hF62DGwu5X1beIHOs1ZwORV6flPkKhpTWCFisDiuqnusNlH+afHDMhQmGxxYqHESOwmF3m7fp3tsV7HKO2FbCcPcnU2vS+X1UrAIRMCB6Atwk0YbAUfhRdr0VOkl6M8hNSx91oICfADWkomj+rFj+ZBb6Qv2xU0hRPmA/UMqB+yDEDLQxfFC1YOEU/GTBEK08wPGJchnQ8T30DaDIm7diPQ4T33GBrFwu+dgu60BZNFEcHThQQJ+DCO6fUnRuIQP2vY9Yt7/W5iiq+uXBvTbt6gypQyrD3D9VskE1n9BqR2OwOpmNFv2bh8qjtQ+uSGngtdH/trw9lBP2JEqRYPteIT34aVdH4aZ0L4KH6H6vCF8t/FGW+nRuksRvTlb3SFJFLTHWCfWFHzLw691Z/spmw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(39860400002)(346002)(376002)(366004)(396003)(451199018)(5660300002)(6506007)(86362001)(9686003)(26005)(6512007)(4744005)(186003)(8936002)(6666004)(2906002)(82960400001)(8676002)(66946007)(66556008)(66476007)(4326008)(38100700002)(41300700001)(316002)(478600001)(6486002)(54906003)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iL1003+lD9jMwTSm+K9VdOttIAzzmnWdCceHOXyCQLoZ7P7V+uKTLf3F3iyi?=
 =?us-ascii?Q?waP8OnwjlE4U25xOv+VqqQIoiOmGIw5zJsTYhCUSpTPSZf7s7U+xtipo1arE?=
 =?us-ascii?Q?N81gHjDWE4UMUrL/Ur7Aw/OHOiBpkZuYDUsraNA2K5Sn583/bqaGvV/NUVBU?=
 =?us-ascii?Q?aZ0KRqsxDJg6Ob7cfbnl5LnJg7xVGSvXm4ag6iOYYOg2q7RlmGpA+vnDqadh?=
 =?us-ascii?Q?F3gQMD9HW+Nm5y5jlhYtTKLGrwN/tEPfxpR09CEwVE4YS6SCRH0ZavIV/idH?=
 =?us-ascii?Q?sHYnxSeMcKYBwtZuMFcgpoD8GTfSDKkRQXVPoa94yq5PhktWiNRwXIMA9nER?=
 =?us-ascii?Q?UIixRr/uoZF5yyuoC/i1dMFv0e7qrrClA8jOPh45V9dz5Trkfk8wuSW0CeZv?=
 =?us-ascii?Q?w4ASc9LTilqvyifFMVFNwUImNlSgUH6LPpyO7InWIqEtzENYCus1UprVPT28?=
 =?us-ascii?Q?wFlM6SHtQ8VzLYT48npy5AyPy/KxEn870nIFf5u0UY+2WWH9fmMeD5eSzPvr?=
 =?us-ascii?Q?6r1GKErqqyvOAzdd71aUnx5wwNOPmV2ZElFiPNzGZ/RI/JhupFN5D0CyDc2s?=
 =?us-ascii?Q?qDGatUIJIaEuRGFcqQORSDEXY0ccx1Gr9KKfVHWzxEfwN6AvTxbR7R+NQNNO?=
 =?us-ascii?Q?r5KW83hUS8SlZHI8nhFsqxmMuUfDa+j7Vj7O1tdZq4vjdhao8AkXaDp874qA?=
 =?us-ascii?Q?ul3omPx0rivPaIoqiG26EpCTCm/DK3EWlQ2fkbSIiP7IHCtC5Vam/ohrJ/9W?=
 =?us-ascii?Q?hqVr/p2bUGEwTrEuugYy2WiueT8X3uyZ1OOb4lOc4ia4gdeAknuTu6zN1064?=
 =?us-ascii?Q?K9XdTKBf8lGf2oEn3NQQPYljVHBMJQCSOW5A3qbkBHuj45PO48w8DqXF6+to?=
 =?us-ascii?Q?3FOQRTR9TJbElvuoqgfpk/lB7+q5NcyHJHqflReaZ2XjE5eUgEyXzpJxT7eu?=
 =?us-ascii?Q?/f9mScP0Zt7H7maeGrxCQa6Fmlq5k39EW6n5y67S3GYTGrX81VaL65W2qFjs?=
 =?us-ascii?Q?3rA5J87KJYvVkSyeGT5nVdvd6Yzb1GLIOrpMvlzdLsVuii4FYt0qF25y+nSE?=
 =?us-ascii?Q?PB7i/Wk3mmCcYl1A0q80ao+ZEeAUIX+n4HXwHUItbiEaha56Sr8PQXDsIKoc?=
 =?us-ascii?Q?VTaSe+ejz7hlz9PSDgdG/bYZG97EA63kmhOegBZX9tPkQNYVJ7vgbXKsX3uI?=
 =?us-ascii?Q?kOb+puH+le+qRkVj8+Q0PfqBTeH+81EHRRwyetUGwhap5LhsuFPUVz2g5tMg?=
 =?us-ascii?Q?EBYJHWe3vF1DD3H/Ca9QMapsinLkOl4hpxyap25o7U6B6w9Y2UM+xGAFDHO3?=
 =?us-ascii?Q?g/7EG5mrIrAgT36eQGLQrxgyEXqvbDGhKrrQndz7xCqKOhcZsDTCJwD4+hO8?=
 =?us-ascii?Q?0MEqOqTdsmbTEF/4j4BVaFeteYoKxGq9uwBLqcBRKsFfCBhiEfs6klXWVAW7?=
 =?us-ascii?Q?88FLzARKju5zvEoJxrEs0zRweiygX93wwTIsPko64D/9wsMgHuO8GlOSSs/d?=
 =?us-ascii?Q?1p+T+m+H/uJBkLN64GEOwGFZUkrrnCK1UXOaDP9GWiZwAIvci5aarynIUWDe?=
 =?us-ascii?Q?ofLZTRt6CdIEFnuhhPlpZ3gKfTv1nJaCuKHZi7MkHOf9BNOoUCOj52yhNDiM?=
 =?us-ascii?Q?Xg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 489baf04-eecf-4444-03f2-08db09987766
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2023 05:51:04.7629
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k4c31I14eoHLpHo+ZI4PZ/skCMFv2J+bv68LW7705kjpmAw1UYJROtYtGrIA190gMs9oODEDrSGMEvFBp97qlhiX8aAHc3EkZM1KoW1Za+A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6505
X-OriginatorOrg: intel.com

Vishal Verma wrote:
> Attempting to add additional checking around user-supplied UUIDs against
> 'ram' type regions revealed that commit 21b089025178 ("cxl: add a 'create-region' command")
> completely neglected to add the requisite support for accepting
> user-supplied UUIDs, even though the man page for cxl-create-region
> advertised the option.
> 
> Fix this by actually adding this option now, and add checks to validate
> the user-supplied UUID, and refuse it for ram regions.
> 
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---

Looks good,

Reviewed-by: Dan Williams <dan.j.williams@intel.com>

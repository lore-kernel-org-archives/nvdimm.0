Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9348B7B
	for <nvdimm@lists.linux.dev>; Wed, 20 Jul 2022 00:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658278431; x=1689814431;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=qbyOgmaVbPs+Jed0GD1SgYF4OX2bgtp1DzpVaoZiMKQ=;
  b=aU6I7oOzm+oBXdq5XFFOU0Erfh+IZG6bZM1cMU1B48xB+pnbX5M89cIH
   CaX3bimHdgxp6x+qshaODL8AF2HOz9ocKwQ+KKVriOjUuR0eqyF2N0NMm
   xcajmVa4uvq23kXvrdYWbc4QVBsUa5ox6hBxyd5tEiYB6pcF8AhB41JS/
   5H5+Rh4NI7x76dWioiwj31kFXNfWznAKDeIVueEXkW2y+PMxDrFjAK6r4
   vzu0qvtEIavRmeBeOQkatkodzPgPOA4miIfRvFNUAqo0nbil0tmf5LXH2
   gsIMSo3xYVDM5YT02zeXXN7Ug9vuE+x4lXKiQnPOagG5bjNLmKPQNGcDm
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10413"; a="348340143"
X-IronPort-AV: E=Sophos;i="5.92,285,1650956400"; 
   d="scan'208";a="348340143"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2022 17:53:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,285,1650956400"; 
   d="scan'208";a="740091585"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga001.fm.intel.com with ESMTP; 19 Jul 2022 17:53:50 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Tue, 19 Jul 2022 17:53:50 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Tue, 19 Jul 2022 17:53:50 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.45) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Tue, 19 Jul 2022 17:53:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XqRkWmomD9G+OJ9GLb4Nelzar0fserFCKmprK597i1aQ8LPKGOZSIyltF9HgB2laLPy3DD3YNZEwZ+l2ZSfFWZzIbEyM5oQDqGZhfj3caK/gsj+0JtcQmWRTobROp44kApD3lqM/sMasrgVAUa1+hNykuc5yM/FBjTZQnM+wCTiB3pVm0qleHsdwIUCwxkTt0dvVYVt6YC+xK2rD2H71GitksT+NmfR1jWJxuyWfbyLVyY/fHbbuUQfCmkoCiJPwadliU+jok2dsJP/BqjjnDlQhhNe+nOTqx9JHJmCsf2jwPKr8KokvgscnETPMqNadzkAHGzgM9ItcDAT738dP3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LsOTzw4NxhStoFjPgz5be7azCH0NKQ4xeeN5vw3bwCk=;
 b=Jof5JWkUkIt6jFZ/tMDB1tRvvY0HztwXHPkMzArlCAjPKhOzwhL70Rqs71/+iejn7PdTApbjXOk5rrvXvpsWrCgfrRzk7hqingFVFZM9CQNNvlUMzdZSW/ElLJ2YNKaOwiYsQBGclq0sJw3x4uPr6MZyJ1BhUV0DQOe23vpHYtXSwlXXlq+6ialFuyHT7rzMhiW0U2QNgo5CtPwrSBPMC1LOQAY7Lxc+MM0bOzfg08MryQSAg8dRl8QIKE20/l3pHPug9SAKnbJhqaD4g1DMFHNbj18zSmYYC26q+v8qqcr2d9tYkD33mhsQRn8IX8c4YRRRrMt2qqVnPyaGh+eYuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by BL0PR11MB2977.namprd11.prod.outlook.com
 (2603:10b6:208:7d::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.20; Wed, 20 Jul
 2022 00:53:48 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::6466:20a6:57b4:1edf]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::6466:20a6:57b4:1edf%11]) with mapi id 15.20.5438.024; Wed, 20 Jul
 2022 00:53:48 +0000
Date: Tue, 19 Jul 2022 17:53:46 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Vishal Verma <vishal.l.verma@intel.com>, <linux-cxl@vger.kernel.org>
CC: <nvdimm@lists.linux.dev>, Dan Williams <dan.j.williams@intel.com>, "Alison
 Schofield" <alison.schofield@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	"Dave Jiang" <dave.jiang@intel.com>, Vishal Verma <vishal.l.verma@intel.com>
Subject: RE: [ndctl PATCH 1/8] libcxl: add a depth attribute to cxl_port
Message-ID: <62d7521a30f94_11a166294a@dwillia2-xfh.jf.intel.com.notmuch>
References: <20220715062550.789736-1-vishal.l.verma@intel.com>
 <20220715062550.789736-2-vishal.l.verma@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220715062550.789736-2-vishal.l.verma@intel.com>
X-ClientProxiedBy: SJ0PR03CA0214.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::9) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1a91eedf-3717-4379-072e-08da69ea4e34
X-MS-TrafficTypeDiagnostic: BL0PR11MB2977:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3aJyspI6VTpHpxdWM6QsO+VpAApmVI2uFGhH+ajgRt9oUd8mneUesee59OUGinfxdCJXYTTg8jTejua9UWRPuXjjJYXDIqcQo5qg5NAGZrHuxvOUk29wpR1oRfsvkq+LTcre5f3fp7ZTeHKcdwhBz72n2SzWlPHQd5X/nco0J5wqTvThPD1DqiYCcMhoa4pohTpRnA6GvwZWi2kXp0/Ox3zpzD+0tbJ0zAZDk/L3MuzWjcaA/WYmOkIZnHFbpk/BRsw/HAHAVvm/eE1nm10HUXjY/sEiIAkNHU6jRe3cOyl5qeVws3oeB/H8N+m5mQC8Ny+nAnTTpXWAPhH6yYM9zG3w9usFFjvzXPIX6MgsiW/tpVQOPUjkcq0TmWLvgonS5Jcq9f1kDsIH5e4r2OrlOW1wk1e2Z0SAK7FcTtmTfkKt0w5alUnR91KbzEHEtRcla+UJZs7ZScjm0Mxos/K2Gyk99+Kp/BLTA6GgBRa1irAomjuT75e5R4KoamEviDtUri//V69pPjp3VkyDvSxorJOBzt/UoFWMjxutiXlWF+G/hN0gr+m/iYbCje2R6yxyOZ6HL9CNBpt7aKpoYzWr1OYyQlzLAeR/6jAsZp43sLyHbJeMPUvCnrxyWEmSwr89EtvIx9QpJkXhKgNfQ5vBGztDHxaw8bjdvDv9wNT+oqUydQdFCde/uiLjjf4kvi/zOUDdUxDmTnD0IPlUv4OqSkE/NcuwhC+R7RXZVkAFXnY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(366004)(39860400002)(346002)(136003)(376002)(6486002)(478600001)(26005)(6506007)(2906002)(316002)(41300700001)(86362001)(54906003)(4326008)(66946007)(8676002)(66556008)(107886003)(9686003)(66476007)(82960400001)(6512007)(5660300002)(8936002)(4744005)(38100700002)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+2LvAKWv4Z4OQMiKcoBpghep8fEzKcVU1gSw8UtLpTNGqvBCHEF3ZxYLCVrN?=
 =?us-ascii?Q?Ngi57OB604dO8+oV9II/wNemg/E1cMF/yZOExxsC0n4lDPTPT+e94Z3HCRX0?=
 =?us-ascii?Q?CsEwXgXTzwcYesmcKMbpgs01NeHDU1NvXOQD5y4b3wIpXpPHjmhCLfvqe7Ww?=
 =?us-ascii?Q?ybecNuFyeo1kcq0Gt6xtMBlNOy+iMMayN7/L+QSDe/Epejx56DK10KH5LR+n?=
 =?us-ascii?Q?Z6wp+KvP5gmgkjftaWqlu51H7xr4lGNDPlpVc5eOkanKZt9V40o68e/g7G7p?=
 =?us-ascii?Q?3AguBXDXxWBJCfLDC/cJt8na0h8S1jRVV5jCQxl3W2C9uTtD5aY/kqrFYjKw?=
 =?us-ascii?Q?+MkX4GAmkiciKY7KJYgyhlsqWMGHtunEqH3a9oXJej7FKiwJ10cy3+PMo7Du?=
 =?us-ascii?Q?coo5UccjFM6xUAfnePCvy/UqdTq7IVlzVSdTz/SYbjxJqNylI3RMhT9Y150G?=
 =?us-ascii?Q?w/IrGXS3dfZnDZbkwnIuXI7gcO0Gri0lkDoK5Hjry63QKuXmYoclxNIAMQjy?=
 =?us-ascii?Q?hRT5M9MPuGCMJgc2/aqAQu+KniUDItjeaXTD92nUunN8W0/e0C0sk5Z6gYwD?=
 =?us-ascii?Q?KsT7COM1yHQpDnY3XdsyJ6mP0LvZLTlqZj0udb7rHdB5MfjkzzARKT+ULNzO?=
 =?us-ascii?Q?JrGvUH3r2FCezr/C4vaqD6f4c5DpoDA3rRIWUtgxAXNgaCUxY/lFIu3cBauu?=
 =?us-ascii?Q?Ij2AgKdi5hbsUodfQf6w93V2C1spjxNGMYA1k/iOWLrr8l29GQIwclRPe7es?=
 =?us-ascii?Q?AtyvszGntRsI0gHnYxH0znp3DNFB1URts/ycNZPcgt2y5qekDkhvki/IlOgy?=
 =?us-ascii?Q?f9tXzlnDjPvcC0rwvlWXh1rdskivi74f2e7h1eiIpwBgbt5qlSR564Pyqeq2?=
 =?us-ascii?Q?3YKrpGxswnJ4xafcIEgFnWsdMo/7RXIE2fCNK7MUFJ9lrBl/+HTsxNT+soiV?=
 =?us-ascii?Q?zw4gNbHJeFC+nylEOAKPe+yj4L1XjiYSCJQQd3SZJaxsnzzq+OnJ1KWPly6o?=
 =?us-ascii?Q?+Zvw8rgCCAwWUFMpuj7/jQy0+S9mTbxxp+GUVx+pn8pZoksL98/GSJq4ogYL?=
 =?us-ascii?Q?lovzMn7gBYN+Pi3aG+lCLFU9W96ec3C6Yp0IbjUQnfc955g89FRnP6G5GgIQ?=
 =?us-ascii?Q?rnADgnbGi/epgbss5HY4n11XDsaS42JCUzpHn01D6c3rUpX5NF44S1w3kW7R?=
 =?us-ascii?Q?Zm7iU3uueyKXpXtH3x53JNaUOBQIU9FCGVRFXCaBL38d+4zSIDuda6/Ek0Uo?=
 =?us-ascii?Q?v9TUzwNrw2ZolQX6Xzrr05/u9GnIjpUGh0pHQH5665fVhhh6peLrUHzpskR/?=
 =?us-ascii?Q?u5AAkY+NiNzoWKogTIBdTretybYSpxlHtYCbfgcuUI4uBkblsszSnt8HVSRd?=
 =?us-ascii?Q?jYGOadYALDDdTGWgx6c3J8XYQWFxxAHyRP+dZl4+seCuI/IYrXjNe9VORnZA?=
 =?us-ascii?Q?/FmzabazxvmhiIC5wRJyDVWDALUSUu+YvEtpI9+iRgBWIOLsCHq+honDjBFl?=
 =?us-ascii?Q?E4ycbnc9QBm4PJ8+F062wC94RrgBJgRcertnMzpqbD5KDHpxOUbj3OhJmtrT?=
 =?us-ascii?Q?uTyZnnwIfrtq+/rShRIQVMS9BEKMd7Dnwq41k++/7mom+P4ehetpLJ/y/OwJ?=
 =?us-ascii?Q?Kg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a91eedf-3717-4379-072e-08da69ea4e34
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2022 00:53:48.3517
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hPHtsgU3iahhZPdFK5s/+BOMDyMZM57xpPkOVss9+n/dcIHMWWpVGxrrr9n6wd8vd02YoKIAMNYdg3Z94PjOk61bpc24RyQpc1JkwC8H/Ws=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR11MB2977
X-OriginatorOrg: intel.com

Vishal Verma wrote:
> Add a depth attribute to the cxl_port structure, that can be used for
> calculating its distance from the root port, and will be needed for
> interleave granularity calculations during region creation.
> 
> Suggested-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

Looks good,

Reviewed-by: Dan Williams <dan.j.williams@intel.com>

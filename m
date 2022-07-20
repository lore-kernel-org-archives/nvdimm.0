Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B24427B
	for <nvdimm@lists.linux.dev>; Wed, 20 Jul 2022 02:06:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658282784; x=1689818784;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=7OdacnZzT/MspJgKHwlQHz2DILJ1Lg4W0cvF/iACIvQ=;
  b=MjfzngQt0Fr9PW0U5jHhVIkBeHMxWl+IAGzh8auHx6XXJEXH68OfSMbu
   33J0EheYV3mycQf69UPhr2AStLKTiDSxIRbymSgmdnKXI2UjQTMcJc/lh
   fqudeNtWCJwT1DhYQnTSz7LtzhPLW9bXjmGN4RM0C2RKv75otvfOa9zlg
   pJKECoP9LcMctpQNo1JMnztCHwJifwPtbR4VIo/Ej3PLTIb19QzPGYDGz
   XnmuE7cFjGrSWZBeMDaPjSptMPXAt2g5SvwtnQRgunwf37flIYrThS7gn
   bj/4LqH1xI3mKDiPG86nhjQFroxX0CIjFbtlcag/S4rFYNgq75iRZHedc
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10413"; a="350646035"
X-IronPort-AV: E=Sophos;i="5.92,285,1650956400"; 
   d="scan'208";a="350646035"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2022 19:06:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,285,1650956400"; 
   d="scan'208";a="656050405"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga008.fm.intel.com with ESMTP; 19 Jul 2022 19:06:23 -0700
Received: from orsmsx606.amr.corp.intel.com (10.22.229.19) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Tue, 19 Jul 2022 19:06:22 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Tue, 19 Jul 2022 19:06:22 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.103)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Tue, 19 Jul 2022 19:06:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nTx0S3rwIj3ZtmnRvR9d3LdYRtSAWAlrtHqF9/ZHGEl9/zfJ+7kBYLShqMgW9cDR+gtb0fCMNmm5Zzou74RRBptD7LLNvBXOsZ77eP0badRFK6KmRRSyw98p7r7yRl6iG0YKQLaVhUrU8QH6rwdrzGgJQSY0JBPvlZoKVHSYtkwFSvWOyoJIzChD28q07CLtqRzPk1YdZqDXNseAwQmTsVbGO2sHKS9a/0iTtzhSt1zJKgi7XTrL8gBVnyxtWaRA9QT9QoqIgVrr6DHlm3hgYkYWSiAJ5AzLcog0ExNDUi28zf7Dar7ciDbvR0MbQelopDlxEl1I+BxtqA8qVC4Lug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hNWXTslFw17hsuO5K6EQW9/QW/rQzHKoPZn2k+eCivA=;
 b=Tq/HbzjSbsm8JJvfAG9Yn5zc8N7HWDpWh0jtpFGwact7EfSg9px40z7T1Sa5id+WUxjwqK930xjHZynqfyqTxJmA1rmECjAJ778IDoS4wI8jgy9Gl2GYSy7bTHiUl+G1sj9GaFCMtBCUtIIUFHbFB6eno+uTKnkdw/cNzZU0ORX68GS1wiD+UzEflLxkju+Kn8x+uvvmjxo1avK1Wxy8C8SvVcRmCDRpr02VWXnpYiSeRHTbRb9BGxV6uWSlHw9WZB0rvbVT0XoVMru70e8g0HhIGk7C98N8djq43Tk57g1XFG2+BmaA2uPWg3RWG5kbKnc4b+evb4KZAEj/9UeydQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by DM6PR11MB2602.namprd11.prod.outlook.com
 (2603:10b6:5:c0::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.21; Wed, 20 Jul
 2022 02:06:15 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::6466:20a6:57b4:1edf]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::6466:20a6:57b4:1edf%11]) with mapi id 15.20.5438.024; Wed, 20 Jul
 2022 02:06:14 +0000
Date: Tue, 19 Jul 2022 19:06:12 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Vishal Verma <vishal.l.verma@intel.com>, <linux-cxl@vger.kernel.org>
CC: <nvdimm@lists.linux.dev>, Dan Williams <dan.j.williams@intel.com>, "Alison
 Schofield" <alison.schofield@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	"Dave Jiang" <dave.jiang@intel.com>, Vishal Verma <vishal.l.verma@intel.com>
Subject: RE: [ndctl PATCH 7/8] cxl: add commands to
 {enable,disable,destroy}-region
Message-ID: <62d763149080a_11a166294ab@dwillia2-xfh.jf.intel.com.notmuch>
References: <20220715062550.789736-1-vishal.l.verma@intel.com>
 <20220715062550.789736-8-vishal.l.verma@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220715062550.789736-8-vishal.l.verma@intel.com>
X-ClientProxiedBy: SJ0PR05CA0163.namprd05.prod.outlook.com
 (2603:10b6:a03:339::18) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e2491633-0d54-4b13-9627-08da69f46cee
X-MS-TrafficTypeDiagnostic: DM6PR11MB2602:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7AYGjj01kxvKximilivejOn/YX3mlfHZ2V23BBPc6V/3hRONj1RT7dREa4jOQLluYn1419ljvdgUfqHDz8CDj71pDfgfA69hqu5lVoiNqSU+oeCV1uxnJOYOEBzOKva/FV5sBnAS1I2AhmZWgAiVoX7n539hQ9fHrDZd8bfLa87Tj8xvC7y5XdbqKkuN4VZsYxfh8H3ceGhHdCQ6+3Z2euULksGR1YU5cXLcbOc4Fb/F/f79SKwDN7r6tYBIZVQ5GTLvilzfluzK4TBVDiKjyB6hOdoHXg+me17j71uYt8TdzITdnydLRcdmJ57OY86ayDz6kK+P+HFFoaO+IFgXti/woxRIufU9YObHROkE26Jb/8xKAf84HMqILTtJkVOTfX5JlzDXlHEGHMsz+M8YkVRiacGM719UjBL6Ybwn9bJ1olAAi2xI9GUgcCk6+Y9ozjEoqUDxyoKCzxgpC4YUx5cXNTPyz4vGyzrMSU/7r+65IamG3PkGfA2QdYcAHkJURV3qME3QKDnZzMlFwMhFrJyBplwvOk2+Mmpt4R72GOVhXbsvqMXHJ+EWEaNSfVevRf0jPcaa0kIT3rY+e7BRyzuDmZO2ceRH3Bur2h98axUcSPaw4BwJeIzfPpWYoB3lk358SS0Qko00iGR3pCKoHqpP8QTNV1G0JyyH0nVvIDuI9CeT1ntcF97fjJCXRIBH+hKS46lznBEapuct16GIhyjFC3XdCDVEn2qauflDkwMH/gDyda+lTII+4n5bc5tgMC4gBEymTCzWLKI1ruWBVF6Cp0W4SW4vlc+4sIzHEro=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(346002)(376002)(366004)(39860400002)(396003)(107886003)(41300700001)(186003)(9686003)(316002)(26005)(6512007)(2906002)(6486002)(478600001)(83380400001)(5660300002)(66946007)(8676002)(4326008)(66556008)(66476007)(8936002)(86362001)(82960400001)(38100700002)(54906003)(6506007)(334744004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3NHhCD5Y5kNzYOPLPf2Ixg0og176MW9HNC0YlkoxhfY9yD9S+ZSCn6DFjw/v?=
 =?us-ascii?Q?MRAOH1CGWfOnBhtO5y0NgB8B/hgcYhFtgCzgBMoAUjqh0YvEtc9fvr1VI57W?=
 =?us-ascii?Q?YB1lCpKKbUJPsPj/HAn08v7jJsrFeq9mu57LieQJ+AoZ1rKs0pmSSZZi0mzB?=
 =?us-ascii?Q?3F1EqEdm0aeY2aON37XhpYOwoW7ZRA1/vW6vc7lvMWH0SyfMmti1vpyL5+4k?=
 =?us-ascii?Q?ZQsllqpmgG2TEUsfqj8k9uCDN2yJsCna4iXAlEO84OQesQKX3zoN8/Yusuyr?=
 =?us-ascii?Q?bFBBIPwZJXNCEjnJgXNHJ7ymzCQ/7darTihlaHgWnNJeQ0LNPDmv2jBuLK5V?=
 =?us-ascii?Q?dt5VvlT3fji/zsaxHr+K2aO3t7l8KlDqqGHyZgBcdH23B1vDbNKiAcMSR9OV?=
 =?us-ascii?Q?6gCTgSHEwtEB+xHS6iXcsmZv4OyRDRxpqRbI+X2geVHwHGmEwAyExG/rrZM9?=
 =?us-ascii?Q?YbZaap5m3PRngAE5svpHV+ozVVhPfJYeT7csddfXByg9VuyZOR0MMIg5ub5b?=
 =?us-ascii?Q?WnRvKK8cenNUeifrOV+vWC1kqOL4V4/i43y4PZoVwQRZ+dF6A8kKkrNWA4sc?=
 =?us-ascii?Q?DbWH/LqHvGEBANTK6w8aSPo5D9x/10IMtSq0tQqehH8Cg8f4L9OJ82wHyQVS?=
 =?us-ascii?Q?Hjz+ZnnQsvRyQiv+iSjlIRX4ixqXTq0+RPSEBuQ4kBH7LkI315zJTNMygU1w?=
 =?us-ascii?Q?CUtrV0MhvND5hbg6DmcUO9Qy91237rOkwHQQtmwDfdGvpcdGJe0cWTHtnRbi?=
 =?us-ascii?Q?DcNAv+xvq3UMqe73LT8WmEK0+kA0sBwFsexm2weYy+798lL43dkNpw9tt5E1?=
 =?us-ascii?Q?6F/xF0fSboD96pzpDaE+d+NH8nc90j0lh443FMFQpk1D7ctzokRYrZdpSpl8?=
 =?us-ascii?Q?xQRpPicZfFhAb89TUbPM8Lgdo3iYXhFzqUOcBtWQliXp88VKXODXl7+6LOZe?=
 =?us-ascii?Q?NtI2+x31sOr6HYrYyi27eDenyKOOs+XQLyEsl/r6XMuzCEnwy+FaClgprHXs?=
 =?us-ascii?Q?K4lmPOQPYoKqZagJ3jQ/xq8kC3hj+QX5MS2rfzm231ryLYqNoJESIO1eaT0i?=
 =?us-ascii?Q?NfHAbgYVpuu1weFa/UYhgFQsRRHI7iAu0A9OCeRe0D3Qkm+MiQJ84XYXKxFM?=
 =?us-ascii?Q?yr/rY35ucjyBOhe815CzXVxUCifOMbsykdwkUKLj+o61Y3q75A5cisUSH0Q/?=
 =?us-ascii?Q?Fi/gCEzD9mspgOeo1V8P/aXlhwlnOMbADRxqxHzox90UE+ioWT8c93w26Xas?=
 =?us-ascii?Q?0C/5dWe3ulzLzjfAS41J/o4aBJxloLPxpB3XIwQ0dQ+JMuAOW8Tkti5xxvl2?=
 =?us-ascii?Q?ekxEKclHl9P6TSCTE4b3XG4N92r6JQFm1/GSd/C3Qu9LZ8mxRJrAj8a6Xmsz?=
 =?us-ascii?Q?Imnj+uWKROtouOUrHOL5PCQ19maUWJZx4aPqMV5t3j0f+gA0WRstZ0lX0vxH?=
 =?us-ascii?Q?K2DcTkSquc4aj72f+W0TjNgj7vTpZZk+PoJovsUL3atWy5xLdOt0enuNuboZ?=
 =?us-ascii?Q?uODqux4TjqZiZBsvNJ72jNFQ3iisVv5WylbYXAVRjMoDac6mRXB71Zf7BY0f?=
 =?us-ascii?Q?rnTZPpo7pTsdQixkjSI1wnU3W/2MaFR1zmtaRoGPBdVjyhJH48i2qod2eybS?=
 =?us-ascii?Q?tg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e2491633-0d54-4b13-9627-08da69f46cee
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2022 02:06:14.8577
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Kc4MWNaSdrX/8a620Sm2AaXBjOFJKFLrto6WetXsmXR+7KEMneTUqBEkv9rpeC6O1Y2Fy8ROD8SjxmvptlyVhVZbM0LRE2tHwvpo75T7XHU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB2602
X-OriginatorOrg: intel.com

Vishal Verma wrote:
> With a template from cxl-create-region in place, add its friends:
> 
>   cxl enable-region
>   cxl disable-region
>   cxl destroy-region
> 
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  Documentation/cxl/cxl-destroy-region.txt |  39 +++++
>  Documentation/cxl/cxl-disable-region.txt |  34 +++++
>  Documentation/cxl/cxl-enable-region.txt  |  34 +++++
>  Documentation/cxl/decoder-option.txt     |   6 +
>  cxl/builtin.h                            |   3 +
>  cxl/cxl.c                                |   3 +
>  cxl/region.c                             | 172 +++++++++++++++++++++++
>  Documentation/cxl/meson.build            |   4 +
>  8 files changed, 295 insertions(+)
>  create mode 100644 Documentation/cxl/cxl-destroy-region.txt
>  create mode 100644 Documentation/cxl/cxl-disable-region.txt
>  create mode 100644 Documentation/cxl/cxl-enable-region.txt
>  create mode 100644 Documentation/cxl/decoder-option.txt
> 
> diff --git a/Documentation/cxl/cxl-destroy-region.txt b/Documentation/cxl/cxl-destroy-region.txt
> new file mode 100644
> index 0000000..cf1a6fe
> --- /dev/null
> +++ b/Documentation/cxl/cxl-destroy-region.txt
> @@ -0,0 +1,39 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +cxl-destroy-region(1)
> +=====================
> +
> +NAME
> +----
> +cxl-destroy-region - destroy specified region(s).
> +
> +SYNOPSIS
> +--------
> +[verse]
> +'cxl destroy-region <region> [<options>]'
> +
> +include::region-description.txt[]
> +
> +EXAMPLE
> +-------
> +----
> +# cxl destroy-region all
> +destroyed 2 regions
> +----
> +
> +OPTIONS
> +-------
> +-f::
> +--force::
> +	Force a destroy operation even if the region is active.
> +	This will attempt to disable the region first.
> +
> +include::decoder-option.txt[]
> +
> +include::debug-option.txt[]
> +
> +include::../copyright.txt[]
> +
> +SEE ALSO
> +--------
> +linkcxl:cxl-list[1], linkcxl:cxl-create-region[1]
> diff --git a/Documentation/cxl/cxl-disable-region.txt b/Documentation/cxl/cxl-disable-region.txt
> new file mode 100644
> index 0000000..2b13a1a
> --- /dev/null
> +++ b/Documentation/cxl/cxl-disable-region.txt
> @@ -0,0 +1,34 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +cxl-disable-region(1)
> +=====================
> +
> +NAME
> +----
> +cxl-disable-region - disable specified region(s).
> +
> +SYNOPSIS
> +--------
> +[verse]
> +'cxl disable-region <region> [<options>]'
> +
> +include::region-description.txt[]
> +
> +EXAMPLE
> +-------
> +----
> +# cxl disable-region all
> +disabled 2 regions
> +----
> +
> +OPTIONS
> +-------
> +include::decoder-option.txt[]
> +
> +include::debug-option.txt[]
> +
> +include::../copyright.txt[]
> +
> +SEE ALSO
> +--------
> +linkcxl:cxl-list[1], linkcxl:cxl-enable-region[1]
> diff --git a/Documentation/cxl/cxl-enable-region.txt b/Documentation/cxl/cxl-enable-region.txt
> new file mode 100644
> index 0000000..86e9aec
> --- /dev/null
> +++ b/Documentation/cxl/cxl-enable-region.txt
> @@ -0,0 +1,34 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +cxl-enable-region(1)
> +=====================
> +
> +NAME
> +----
> +cxl-enable-region - enable specified region(s).
> +
> +SYNOPSIS
> +--------
> +[verse]
> +'cxl enable-region <region> [<options>]'
> +
> +include::region-description.txt[]
> +
> +EXAMPLE
> +-------
> +----
> +# cxl enable-region all
> +enabled 2 regions
> +----
> +
> +OPTIONS
> +-------
> +include::decoder-option.txt[]
> +
> +include::debug-option.txt[]
> +
> +include::../copyright.txt[]
> +
> +SEE ALSO
> +--------
> +linkcxl:cxl-list[1], linkcxl:cxl-disable-region[1]
> diff --git a/Documentation/cxl/decoder-option.txt b/Documentation/cxl/decoder-option.txt
> new file mode 100644
> index 0000000..e638d6e
> --- /dev/null
> +++ b/Documentation/cxl/decoder-option.txt
> @@ -0,0 +1,6 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +-d::
> +--decoder=::
> +	The root decoder to limit the operation to. Only regions that are
> +	children of the specified decoder will be acted upon.
> diff --git a/cxl/builtin.h b/cxl/builtin.h
> index 843bada..b28c221 100644
> --- a/cxl/builtin.h
> +++ b/cxl/builtin.h
> @@ -19,4 +19,7 @@ int cmd_enable_port(int argc, const char **argv, struct cxl_ctx *ctx);
>  int cmd_set_partition(int argc, const char **argv, struct cxl_ctx *ctx);
>  int cmd_disable_bus(int argc, const char **argv, struct cxl_ctx *ctx);
>  int cmd_create_region(int argc, const char **argv, struct cxl_ctx *ctx);
> +int cmd_enable_region(int argc, const char **argv, struct cxl_ctx *ctx);
> +int cmd_disable_region(int argc, const char **argv, struct cxl_ctx *ctx);
> +int cmd_destroy_region(int argc, const char **argv, struct cxl_ctx *ctx);
>  #endif /* _CXL_BUILTIN_H_ */
> diff --git a/cxl/cxl.c b/cxl/cxl.c
> index f0afcfe..dd1be7a 100644
> --- a/cxl/cxl.c
> +++ b/cxl/cxl.c
> @@ -73,6 +73,9 @@ static struct cmd_struct commands[] = {
>  	{ "set-partition", .c_fn = cmd_set_partition },
>  	{ "disable-bus", .c_fn = cmd_disable_bus },
>  	{ "create-region", .c_fn = cmd_create_region },
> +	{ "enable-region", .c_fn = cmd_enable_region },
> +	{ "disable-region", .c_fn = cmd_disable_region },
> +	{ "destroy-region", .c_fn = cmd_destroy_region },
>  };
>  
>  int main(int argc, const char **argv)
> diff --git a/cxl/region.c b/cxl/region.c
> index 9fe99b2..cb50558 100644
> --- a/cxl/region.c
> +++ b/cxl/region.c
> @@ -45,6 +45,9 @@ struct parsed_params {
>  
>  enum region_actions {
>  	ACTION_CREATE,
> +	ACTION_ENABLE,
> +	ACTION_DISABLE,
> +	ACTION_DESTROY,
>  };
>  
>  static struct log_ctx rl;
> @@ -78,7 +81,22 @@ static const struct option create_options[] = {
>  	OPT_END(),
>  };
>  
> +static const struct option enable_options[] = {
> +	BASE_OPTIONS(),
> +	OPT_END(),
> +};
>  
> +static const struct option disable_options[] = {
> +	BASE_OPTIONS(),
> +	OPT_END(),
> +};
> +
> +static const struct option destroy_options[] = {
> +	BASE_OPTIONS(),
> +	OPT_BOOLEAN('f', "force", &param.force,
> +		    "destroy region even if currently active"),
> +	OPT_END(),
> +};
>  
>  static int parse_create_options(int argc, const char **argv,
>  				struct parsed_params *p)
> @@ -495,11 +513,90 @@ err_delete:
>  	return rc;
>  }
>  
> +static int destroy_region(struct cxl_region *region)
> +{
> +	const char *devname = cxl_region_get_devname(region);
> +	unsigned int ways, i;
> +	int rc;
> +
> +	/* First, unbind/disable the region if needed */
> +	if (cxl_region_is_enabled(region)) {
> +		if (param.force) {
> +			rc = cxl_region_disable(region);
> +			if (rc) {
> +				log_err(&rl, "%s: error disabling region: %s\n",
> +					devname, strerror(-rc));
> +				return rc;
> +			}
> +		} else {
> +			log_err(&rl, "%s active. Disable it or use --force\n",
> +				devname);
> +			return -EBUSY;
> +		}
> +	}
> +
> +	/* De-commit the region in preparation for removal */
> +	rc = cxl_region_decommit(region);
> +	if (rc) {
> +		log_err(&rl, "%s: failed to decommit: %s\n", devname,
> +			strerror(-rc));
> +		return rc;
> +	}
> +
> +	/* Reset all endpoint decoders and region targets */
> +	ways = cxl_region_get_interleave_ways(region);
> +	if (ways == 0 || ways == UINT_MAX) {
> +		log_err(&rl, "%s: error getting interleave ways\n", devname);
> +		return -ENXIO;
> +	}
> +
> +	for (i = 0; i < ways; i++) {
> +		struct cxl_decoder *ep_decoder;
> +
> +		ep_decoder = cxl_region_get_target_decoder(region, i);
> +		if (!ep_decoder)
> +			return -ENXIO;
> +
> +		rc = cxl_region_clear_target(region, i);
> +		if (rc) {
> +			log_err(&rl, "%s: clearing target%d failed: %s\n",
> +				devname, i, strerror(abs(rc)));
> +			return rc;
> +		}
> +
> +		rc = cxl_decoder_set_dpa_size(ep_decoder, 0);
> +		if (rc) {
> +			log_err(&rl, "%s: set_dpa_size failed: %s\n",
> +				cxl_decoder_get_devname(ep_decoder),
> +				strerror(abs(rc)));
> +			return rc;
> +		}
> +	}
> +
> +	/* Finally, delete the region */
> +	return cxl_region_delete(region);
> +}
> +
> +static int do_region_xable(struct cxl_region *region, enum region_actions action)
> +{
> +	switch (action) {
> +	case ACTION_ENABLE:
> +		return cxl_region_enable(region);
> +	case ACTION_DISABLE:
> +		return cxl_region_disable(region);
> +	case ACTION_DESTROY:
> +		return destroy_region(region);
> +	default:
> +		return -EINVAL;
> +	}
> +}
> +
>  static int region_action(int argc, const char **argv, struct cxl_ctx *ctx,
>  			 enum region_actions action,
>  			 const struct option *options, struct parsed_params *p,
>  			 int *count, const char *u)
>  {
> +	struct cxl_bus *bus;
>  	int rc = -ENXIO;
>  
>  	log_init(&rl, "cxl region", "CXL_REGION_LOG");
> @@ -509,6 +606,45 @@ static int region_action(int argc, const char **argv, struct cxl_ctx *ctx,
>  
>  	if (action == ACTION_CREATE)
>  		return create_region(ctx, count, p);
> +
> +	cxl_bus_foreach(ctx, bus) {
> +		struct cxl_decoder *decoder;
> +		struct cxl_port *port;
> +
> +		port = cxl_bus_get_port(bus);
> +		if (!cxl_port_is_root(port))
> +			continue;
> +
> +		cxl_decoder_foreach (port, decoder) {
> +			struct cxl_region *region, *_r;
> +
> +			decoder = util_cxl_decoder_filter(decoder,
> +							  param.root_decoder);
> +			if (!decoder)
> +				continue;

I think the stuff after this point wants to be in its own helper because
it's getting pretty smooshed from the indentation levels.


> +			cxl_region_foreach_safe(decoder, region, _r)
> +			{

Missing 'cxl_region_foreach_safe' in .clang-format?

Other than those minor comments:

Reviewed-by: Dan Williams <dan.j.williams@intel.com>

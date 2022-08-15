Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9534F111E
	for <nvdimm@lists.linux.dev>; Mon, 15 Aug 2022 22:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660604270; x=1692140270;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=JOUNoGeu6CHva6v4kg915SD+wL4QdsrKUdW5ixpplw8=;
  b=MNGvPChW45LwqUVYR6Wb/bcxi4EpfxVZz9xWruc1mMwjvYcXeKqIcnEK
   SLdM47gnwFVZPokWNfKCoRKkXlMTE/WXKnerVVfadF8hE/8JefeL+Kjtt
   Whjr/MzZRNhX2wX50wGAmxSeXtgek0eRlUGZZE3w6otXAsA/pSOjDHtgP
   E0U5T5MJMq5/S5Ws8ICWuEnuBfexryNetM4qnFbhzeyU1tIyIdiHb+lUC
   luVOTKKYEALAYP7HIvzkyaZ48nJSUDOuz9hMhO4vxQvcndG3Pe6/+auX3
   9B1vV57CJeEQoGwc/DwZCnncOIAQt6WgVBeJ84GTrnSpz5Tz+9/6oPDDZ
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10440"; a="279035569"
X-IronPort-AV: E=Sophos;i="5.93,239,1654585200"; 
   d="scan'208";a="279035569"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2022 15:57:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,239,1654585200"; 
   d="scan'208";a="696126408"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by FMSMGA003.fm.intel.com with ESMTP; 15 Aug 2022 15:57:49 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 15 Aug 2022 15:57:49 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 15 Aug 2022 15:57:48 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Mon, 15 Aug 2022 15:57:48 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.43) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Mon, 15 Aug 2022 15:57:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OO8CEryUj8EEejlOmsnF8eKG0kH9siHH+8pNkXYmolTiDoCCRHXXmEfvq3TjMma5TYCLBSxcZPf70wqMFpRChY+Sv21p0UKTFfvBVPj87iVNb1tr3r2FNjNhwuxcTamoLvJfXJSCbjdXsFpgqfD7QNejvYa1NEfO+zmrvgy0Hj5lGpfgmWiH0JFlduAwkAGMZW06/GOYWMSl5YIuKmQKUclBtl4t8wkWtsmm+IlL9Leki9kCcP9neeA3cjupyCmPhZpgMHLRegjlfJfLhD9JkeuHsEBevfjb/GyuL/UvH11PxIfRpijZwGSnQ/YuBY+6XL3nKupHlo7mvAE4s7B+iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wS8JTD5d5yM2a/mGlsJBCWdfquRjV4AiK+MbnfMjXoM=;
 b=ApbAouNm2zJnNfdufsveI5A7HNNwqwo3MiCvyctLOOmBjTEkcKiLkKSdJzN9y6kmq5E1bO89enSJ6fRCux2QXt37agjAGDIEW3pZxm0bAEGbLE7PF2vSKmViKVxXCQC07O+zDeNUCzzeyjnL4nX23J7jx+mzLSmm9vuJkWtuJJ9WTjmr+FpVBTrhf10OBs7aeccLiP+ofb3Oagcr9xjJ0oHRV4oBfHIJjvrDxm8LoZMbs3oHmAAt4Sy1meSI/gGhMTxin/rN+4L4Ch1k5dTjDxq6zxVC2SlI9gD+R9BjKtvm9HwQwRCrwP8kHRaOoUl6lApEzQ+EGZESlz+Dccgy+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by MN2PR11MB4334.namprd11.prod.outlook.com
 (2603:10b6:208:18e::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Mon, 15 Aug
 2022 22:57:45 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::9847:345e:4c5b:ca12]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::9847:345e:4c5b:ca12%6]) with mapi id 15.20.5504.028; Mon, 15 Aug 2022
 22:57:45 +0000
Date: Mon, 15 Aug 2022 15:57:43 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Vishal Verma <vishal.l.verma@intel.com>, <linux-cxl@vger.kernel.org>
CC: <nvdimm@lists.linux.dev>, Dan Williams <dan.j.williams@intel.com>, "Alison
 Schofield" <alison.schofield@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Vishal Verma <vishal.l.verma@intel.com>
Subject: RE: [ndctl PATCH v3 03/11] cxl/memdev: refactor decoder mode string
 parsing
Message-ID: <62facf6778e0f_dfbc1294fe@dwillia2-xfh.jf.intel.com.notmuch>
References: <20220815192214.545800-1-vishal.l.verma@intel.com>
 <20220815192214.545800-4-vishal.l.verma@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220815192214.545800-4-vishal.l.verma@intel.com>
X-ClientProxiedBy: SJ0PR05CA0105.namprd05.prod.outlook.com
 (2603:10b6:a03:334::20) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9a741683-892b-4905-4015-08da7f119154
X-MS-TrafficTypeDiagnostic: MN2PR11MB4334:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZNqNpvWlt6+jpK2hev64jwSEvlqYn7V2pJj08gIKnwx+IsgiZUSrUzTiXW59Du21EqcF/31dLS43KJpfFF/kHS0gOssFOcSITg4qfbg3/YmWD3V9ThS341aGVSGq09Un12ROnhmy2eF0L4WOI/0q5EvIYrFNR6AaQA0cbas8yA1F9VWO3JLb6oDLdinDzTSBRgQbRzsRt5okLGVwKVH+ruHZd1ypcfVjMsKK7WZm/xTrP9/ZgbeTzTwaZiyirafP6UMCmHMa7ZZojwOfOe3ZOHoTpl2XwBZ6k5fnhMHg6Pj/Xo1G7HzOydS1kQOGn053J1svtNOCDlO4fLLVPwRRKJgAbbY1+MqokyrwGvYE3Qx/03/vyjp+QY8MG5uIhlla190tHqekvMVE6CadfxlDH9RQBJqlVCEVMqZQjsOPDdm91Nb8R+7+422i5b3yx0NJyHKaml1loJuP8lAN0Y3cn8Y/mdF4ev6GknKK9MB6zcr7syKuFbZlrmjaInBdzFR6yua7iXb6tz4Vi/uicos9dgg+uwJKm91Abg3RszdNmNZsZLddVNUqotgzHnr9pGSrWBGAmzs0eJ40zCmWRjNkPpqZW9udUc76zRnY18VAWB2CV5dwbbRMwMUqRCS9ynQtvyLDF6xhSSQJkJtgQ8B7uOzzwBVXqaYwiZB7ocsUSuFrIq7e83DuFHVVpYgVg/uBZCClMorMV24cXWNUbYZXIzBNMsIGWNFBE8ZJwHhFJxTdgVTNGKau8aKbZs0kbtAi
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(396003)(136003)(39860400002)(346002)(366004)(26005)(8676002)(107886003)(6506007)(316002)(82960400001)(54906003)(9686003)(478600001)(6512007)(186003)(41300700001)(86362001)(2906002)(6486002)(4326008)(4744005)(5660300002)(66476007)(66556008)(8936002)(66946007)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gVoq0jiwd9FTKYiDphaZvVewoFJGKIGLa0pVWF9qgcsow6FpEqwzi7d+vH19?=
 =?us-ascii?Q?75GHbXYirB1jRXt5TZBwhodQ8XW/1fsphYyWHc3X03tY8XeejrR6AV0A+3h6?=
 =?us-ascii?Q?kARzrXWiFapE5nqimuzyiiTpmWO9v7yvLAeB1hnNo/SCe5IrsRrGAIHq9lBl?=
 =?us-ascii?Q?27pTx7U2Reb6owx3pM8frddSnstr5GmSS2ZFfvjEhc6Efa3Uyjh7UgoCT001?=
 =?us-ascii?Q?sv4gwJ88NHxVZO0dlfvme5GkcJ3+a7CFxT22/2MZ+0jnHKfU9d2qWoiwJhlc?=
 =?us-ascii?Q?5YrXKxoVeJ1QQBr/MwydhQo6GMydO/rVnZucUFTv1FA7nWdkM73tS3zrdMmN?=
 =?us-ascii?Q?HOUDESfp5pWeoHVMnKNb1tZ5+vcWDOLgFiH+R9rKQaJpc4malZKv0VjvlulH?=
 =?us-ascii?Q?PTl9xcyYWgRUE6qLH5ySwgo8mnH5uSmOqI9zNzpdM+hO01kHqNRUVbmQvhEx?=
 =?us-ascii?Q?gD4gc+Pa49X5xKSzGIO5mmsEH66o8/Exs/BfIRvoi5dUJFJT2tIDXLJQcaqg?=
 =?us-ascii?Q?P9fBOoe8xjIePJF1QNP1EZSY0eSl8PZoz1LnfrgZDuzfSQIR7zSq0mkJtwo4?=
 =?us-ascii?Q?7QgVCZQTYz6r6Sgr/txh3aqbkTd5xDcKu6G89dAOFQ+J5yQX3sICtkzskcqE?=
 =?us-ascii?Q?pwW7YSssEpSatiwLqTVJq8O2STujt72Cr/gAILOpGuVV4baSc6dWmpiVSUSH?=
 =?us-ascii?Q?QavLjtCamU0ZB5CHGN8k5gzSAbYVu4+GBM9WFU4SaZQ4XGK+x0K7uAuBbqlO?=
 =?us-ascii?Q?4tOtIB07lR6A7Rw2Lel/obe/KZmau1sFbQxK3eafu/NgaN403JHNLI9q0SMf?=
 =?us-ascii?Q?qlfqmcNqoWnOdcwiRt2ezjSwiBmryIhCs+aFvDQfK4VRIxWuQrypcssdaNoc?=
 =?us-ascii?Q?p2sx/bCwYbNTh5vi68z+K4DAh8fNXJx+2s/FvZro4JzsPtk2FelNltTJ5/s8?=
 =?us-ascii?Q?JgG5aUClKNlHLHqb0XrV7CmO+yLHfcIXYxYZcdwgAKhkKnvelcqdxFoUxYRo?=
 =?us-ascii?Q?FGdlAVzpcVgWTxw/Q09+8+GESHhv80yvBOBfbH8jWAAOjPwi8p3Pti9B662f?=
 =?us-ascii?Q?fyJFSwEqPLYdxRwOt2cNujP/nE98DwoNNUirqt4FgdLGhM5MtfPyiJjbXTPz?=
 =?us-ascii?Q?62IBWwMvKcDQNnZveoHGTLopsE/80XXXaC69qGZBHZArECjTLZgq0pTgrJXK?=
 =?us-ascii?Q?LYPSJnWmjTdCiCsquQJ7i3GjgmgxBVxveVghnxpI0J2gHUUXo4QunSjxAeOy?=
 =?us-ascii?Q?EfNlQOLOYVCWAGpT0JNbjlFAnLTHqwO9gpOwhq+rmlXcFv0kZYLBAFBxhD2e?=
 =?us-ascii?Q?eQBdBsxiMH40CX/Y+YZa+5dDw8rgEWd3V6pQritseLGbDTH2TyKW3wC5uTEK?=
 =?us-ascii?Q?yCNpTxs/S6EncRiny5bOoOky1Q9cDpC6hGMBM/YaJF1nk7aaDG2wlW9+AwG1?=
 =?us-ascii?Q?SaPemUSVCutMQLGN1vy6opur2LiicE1/2abvc1FuW4mM+uqd8M+x7JM4LnPq?=
 =?us-ascii?Q?mbEii68ab51oQoif/8Dw4QSMhbru1rWu6kOyWRMmdkro/CUAkFmQDoX1gouZ?=
 =?us-ascii?Q?3EL83cGtNMXauyFKI0dkRYKaWPjwDEWmvaJ8ENc0aXnF33kdAR//L6paJaLE?=
 =?us-ascii?Q?Lg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a741683-892b-4905-4015-08da7f119154
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2022 22:57:45.7141
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UKuF18biVP44x4ooiro90DnacE5cS+8GIVOHbOSPEIa09aCjNwtryMn/vwOlPt9T3Q9PeQKkoXuG1kOv4eGSSW7IPCxFXWEjPUe2qFyGZZ0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4334
X-OriginatorOrg: intel.com

Vishal Verma wrote:
> In preparation for create-region to use a similar decoder mode string
> to enum operation, break out the mode string parsing into its own inline
> helper in libcxl.h, and call it from memdev.c:__reserve_dpa().
> 
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

LGTM

Reviewed-by: Dan Williams <dan.j.williams@intel.com>

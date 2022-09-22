Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95AB866E8
	for <nvdimm@lists.linux.dev>; Thu, 22 Sep 2022 16:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663863819; x=1695399819;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=HKMFCIBFwFaiRuekCSNkC8y/1WJbpXiJNOzwrgPgLWk=;
  b=QLOth98gE9FGJLu12HLRo1n3znLbvclxKQ//trU4TB5eOtH9B/UI2HsX
   8QVpynJhpZgHIiokuO709gW8V94mutgtpovJBkmqc4uKC2BTwTei6w1a0
   wQp1Mz0qmhPvhYyUcE3Q3582PFoH79/OnjJpc8QuL4Far/0hJm+4y8k8m
   o5aIjuOyqM5TWyycUM6Z5IPcgJl2sCFNjvLvTdS9dIJDNkfXC54Nlo1qE
   lxyPdDkVGFWV+ss7j7Z/61+xuUUocrrjcGQnW/1VvHT6usC02uC8cbNkf
   FbVmjJPKtk36A4rpfoEMUYgjIt5gQSHj/y//KBakzAsl/KmjUP1RVxcI8
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10478"; a="301761083"
X-IronPort-AV: E=Sophos;i="5.93,335,1654585200"; 
   d="scan'208";a="301761083"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2022 09:23:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,335,1654585200"; 
   d="scan'208";a="619857353"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga002.jf.intel.com with ESMTP; 22 Sep 2022 09:23:34 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 22 Sep 2022 09:23:34 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 22 Sep 2022 09:23:33 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 22 Sep 2022 09:23:33 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.49) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 22 Sep 2022 09:23:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cRRbeWd2VHG3Iq9FgtvKdOWGIgDY+lAdvfA+L5yZiVKb4Cfx2K903wWfZB4Mf0kMb14u/fdEEg9BtrMZ7TfuBK50PDmKBRaDrWCh2a+SuALvsDloLn1J06qiddbLOqW9ZgFeNkvTja0EI+KiSFGwSnlO9Oy7pLBMFje+liZwY6SUSSKmohP2VhbZe1Evx95owNCtK6QdCBRe7J4sUcnmmYTR6oAxvISKTnQJzYvwGTTkLWx3m+bKlJkR1p809e+0lgeKHDn7OkA9neLa+vqRp/SEh8uioEMvuAjtPiDthwTdgr22WpjM/quBWewugX+cx0Fi11ZXuqI8OmBGKFH5Sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/Ex6Yqk+HhPPYmr6KwAvNvO2PLUekZ6hTMO11DFDbfc=;
 b=Hv8kaZHCamQ0Fhy06m84GGnPriH27ZB5t+/YtGHBvXU+P+ufzZE0l/SICsRNIsN3G7YaHwFDmQPO1RWFt84wBYqQTTlbLmcyHUbk3o9BTwyqcWVVn/8JHd/Yzjj89aM606HRyDmZeTAE7HWnd8O5PsjdGFCskNYBlgKcpYFNdKuElcRUXLNp9z6LF5JopCyIQ21vjFU1T/iIRbIvMntrQWFu5HgMac7KSlFnvG9y5ceNgnSHIx7VnS15fD2oqVnTzjXDJGyoL1yzZQp3TY7GdT9J8cn5+l9rE8WU0pgFi7JJbZ3CkSpDPkeIcu9hRgDQjU1HBJl9CWJzaH2XQuOXUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by MW4PR11MB6957.namprd11.prod.outlook.com
 (2603:10b6:303:22a::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.19; Thu, 22 Sep
 2022 16:23:32 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::9847:345e:4c5b:ca12]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::9847:345e:4c5b:ca12%6]) with mapi id 15.20.5654.017; Thu, 22 Sep 2022
 16:23:32 +0000
Date: Thu, 22 Sep 2022 09:23:29 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Vishal Verma <vishal.l.verma@intel.com>, <nvdimm@lists.linux.dev>
CC: Dan Williams <dan.j.williams@intel.com>, <corsepiu@fedoraproject.org>,
	<linux-cxl@vger.kernel.org>, Vishal Verma <vishal.l.verma@intel.com>
Subject: RE: [ndctl PATCH 0/2] misc RPM / release scripts fixes
Message-ID: <632c8c0143d41_1ad229471@dwillia2-mobl3.amr.corp.intel.com.notmuch>
References: <20220829234157.101085-1-vishal.l.verma@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220829234157.101085-1-vishal.l.verma@intel.com>
X-ClientProxiedBy: SJ0PR05CA0146.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::31) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1101MB2126:EE_|MW4PR11MB6957:EE_
X-MS-Office365-Filtering-Correlation-Id: bf9e8e95-121e-4399-46f1-08da9cb6ca79
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5v/J2CzQqChxXNTlYvKF6ZOaKYuPTui17BX8I6ZLcS7XD1bSYBwRY4AlBavcUenZGbW0JcRkSpDv+aH/Qe3S9CvmC/R5sms1Lvbxj50HM2isd79RdS+VOlbJ6gszdo0aLgdK7kRQ/3nR3xbLzoiM0avclKyBPccs3DpTs7OEAOySw88j++XJ1hLHeLt6la+n+DHs85VeFLfCEOzTqQXbThenLDiOonSJ3Rc415F26ErxQ8yyApAjbx40X6jAYFpOZU1J6betEZp2ZeMykjylnNyvBDl05CaUFY4wCmwz4cxAPaMlKhSMMYqoTh5nvSdctK5whvki/FSma4Cj2Gx5nnmjV21HTNEdp3Y0XQI6iVQ73o9rXZl8n5+s7DV55puqgCF9SMOH7tBPyyo6DzZEMxTN4rNjfKRNxFEnx15XbssRYO3TsugGauomZhSyYnZF4AcINmd5ft+N9Fzg+imb3hwQFOVGYvsUl6habarDCyCovPL2RQE5aricVWPaayqYDCGGPFGu/aeMcEpHoDXmD+cDEP1QIfkam0Z1n8POFLIt5I+iqcNc5Aip2Wo+h2AaCn1QWeOUY9JbzwrSNuZaZrHwvyV7rOSXE4eTr9kBj1L1RdwvhbBUhXqp5qE48VdJE1dasN1ff2cuRFeOhcntUK2d6jWxTKzS1CDDCngO6KbP9gWZrsuSJL8Zek1yO/z/+nlJ1mrrG5KmcUv0LvItjw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(39860400002)(396003)(346002)(136003)(376002)(451199015)(4744005)(2906002)(186003)(41300700001)(6666004)(8936002)(6506007)(9686003)(6512007)(26005)(5660300002)(4326008)(107886003)(86362001)(83380400001)(38100700002)(82960400001)(316002)(54906003)(478600001)(6486002)(66946007)(8676002)(66476007)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jGmCQ9juihYwMtDdb5HB1NsJi3vThftaBzTYNC5/tY9t41phRrpEht/fvZrF?=
 =?us-ascii?Q?pbcUk2gts1eDwk+c2kCr5kF1guTyO9vJeO6KaJWFhV61Njb+cnWasjx8t7nR?=
 =?us-ascii?Q?v6ufGlJupsOviuI3IYGgAPCtT2I9GSX3NmP3a6+wgdAhQOOjk4UVgJPy1lXR?=
 =?us-ascii?Q?6yR8j4Bjsa+hOH6J4KYm4p4HoK6nsn2lbDWWzlBvEcRmGuuyRqtbFm6Ui6WJ?=
 =?us-ascii?Q?66dbra1LnSEF6545c+RKQH/JbQYv4ffA4iHCusYz7uqQQh1q8oq5DIL+BnNw?=
 =?us-ascii?Q?alGVkBUYbgYWYIu+bj+p6LuX340s+GlzB7fJW1uX4kasXpnKisggXmevsHmm?=
 =?us-ascii?Q?9ywE94s+fiQZ01fS5BlOfO2fDKrLmeH4GbII9+CMYVzVuaNe7HQ20AF6Sucw?=
 =?us-ascii?Q?goyZGUIEIf9LfeVX9K0ohGCbnK9rp+j4iodTRXRpjsRKczTOcV5XtZRYdJCJ?=
 =?us-ascii?Q?4rkcFY15mPEaaECNghfbSDDn+4W79rXqORjGk0SBe+1PpUnQxA2b3lfmUY0/?=
 =?us-ascii?Q?8H/bME3crUajK9HLhOSFLtXphrXEs9jp6h3t9hI90l2VjfHKOHA+IXYprjRD?=
 =?us-ascii?Q?Smb6+1T/+J5kvxGPkq/Y0nDjjeIzVplGtTN8Cx7GvwXtPytCKuTVues2yI6Y?=
 =?us-ascii?Q?vfJdk5ehLCnny3PhI7PnWDagSyJhTafWFMzAqp9MKQ1eufOrio3oaH4nx48i?=
 =?us-ascii?Q?KB7of3ADkuydqFg+eFDnhfNQmaRBoPlHl8cocmf4DXGlicS/KP81EEarmph/?=
 =?us-ascii?Q?qVuMJpMAKalXDEA7tdfB/FWrtAbKRuYbit5JvhyYL3ecX+pVT/IAbgoq4Ern?=
 =?us-ascii?Q?/hyv/37drkE2nRzEUc8ip0AW7GubS/eMSK80Gt9X1EO+hj4d8kkMrceYV9Qy?=
 =?us-ascii?Q?qLe9zR+8/kUejYXtHeFVrb9DJhcFoqYyDzuwriiN27RiOzgZaKkvUQOa9TXR?=
 =?us-ascii?Q?TcUrGkLy+WdEMH8iIWP8xIDKrU2+a2w41a35sBsC1ABiwCfjBrdmdspSH+mG?=
 =?us-ascii?Q?q6zJUu2oEL5bn73yXEVNwNG7oLjbFFH+j4vDsZDxiT0KDJvmFlqJ5h60ZyT0?=
 =?us-ascii?Q?g0oVFcGzoQ2uW9I1CWcHlC424grUEcCkMGlW6W6n04ry5DWfHoSz0D+JFaqJ?=
 =?us-ascii?Q?0E0Bn4NXpgzqN9WxIJSwjb+d8X6aSok1rcMNeQ3E/Cjlg2JOjfqihYGumb5j?=
 =?us-ascii?Q?J3Tw7zFjA1wn67tO9jbqBApekQ7S5d+9AvWPJ3iT1vZ5gUnVVWiMFxSipm7f?=
 =?us-ascii?Q?zE9jpv9DiibVdF142c8ThchzMSEA2AdsOiSCyDHQfOB2sV5vXQ3thRqauNlm?=
 =?us-ascii?Q?EbyFqk994+Ue2d8vLsxp1IWLSYJFylJMdU5Z54+vqnsNkAZSvYgAczBSNg4F?=
 =?us-ascii?Q?Z4UxbXL5tpCqdWT9B7jGp9oHkorShHvkbeRPBftN3yyA+QI4vS5mX+badFKW?=
 =?us-ascii?Q?XbSoM46cVLNQfxag5h6P1ZaaH5xeZfay6SqWozLErVj6dOPPHGdeh7eETmAv?=
 =?us-ascii?Q?Hy34XO7FPHjRd4cQnjyxC9Yce5s6KOlO9IO1PZHhKeREz3+hdZmtaCj656vY?=
 =?us-ascii?Q?7XxYXxfq4i4Ur1lhWsgC/AZ3WNZDiAJTtc0K6RNrPaCCRhc9tiG6UvQCEM+H?=
 =?us-ascii?Q?NQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bf9e8e95-121e-4399-46f1-08da9cb6ca79
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 16:23:32.3460
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o3c/Vmp+Ww7jgmn0d/r9BUXktyr+2i9ga7A7vx7C4FnPGz/fSDt5gJHJwAa6H243qDsCfryJvGJWVEqKkv1FelujnWnFGymtxhSaL3V3mPo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6957
X-OriginatorOrg: intel.com

Vishal Verma wrote:
> Add a couple of fixes to the RPM spec to correctly claim ownership of
> config directories, and updates to release scripts for meson.
> 
> Vishal Verma (2):
>   ndctl.spec.in: Address misc. packaging bugs (RHBZ#2100157)
>   scripts: update release scripts for meson
> 
>  ndctl.spec.in              |  8 +++++++-
>  scripts/do_abidiff         | 14 ++++++--------
>  scripts/prepare-release.sh | 24 ++++++++++++------------
>  3 files changed, 25 insertions(+), 21 deletions(-)

Looks good to me:

Reviewed-by: Dan Williams <dan.j.williams@intel.com>

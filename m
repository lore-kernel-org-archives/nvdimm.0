Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19D28748E
	for <nvdimm@lists.linux.dev>; Tue, 20 Sep 2022 17:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663694763; x=1695230763;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=4quVnbiessCOWQy3lD3g5+b8brO4EGkGB/rFiFjtbc0=;
  b=jxvJup/GBsmWl13esbIfuvCGpExBlMaBlV82EyRM6o8Lf5fgVdI2r+kM
   78sYWq7CWkglWWuTQasPD8KTgdYmqyVKfseCZhOTqnVfX8hmeym3iNatE
   geNuyoETDFF3kSwmrZB11nijRGyMgGOyiHvuPs8921RxaR0+Fly/oHVwm
   uVfgJmMtQCRBeAOWkJGsEbE/8OGBcxR/SdJ+oyyJn9ff78HfYoigg991M
   POgrD8oiWLaXl2hSh2xR3+BXermuivOvuUS68TB6UgijSHH6af7rtKZ03
   sYtFrXkMQzZyKg8b5empFoTVIyEhLaw/MfLFU9nd4jHV/AK+41gUK9SJ/
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10476"; a="299751886"
X-IronPort-AV: E=Sophos;i="5.93,331,1654585200"; 
   d="scan'208";a="299751886"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Sep 2022 10:26:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,331,1654585200"; 
   d="scan'208";a="722833080"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga002.fm.intel.com with ESMTP; 20 Sep 2022 10:26:02 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 20 Sep 2022 10:26:02 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 20 Sep 2022 10:26:02 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.49) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 20 Sep 2022 10:26:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GZHa9ToGSpv4M1qyPPQVJITnBpV9x2GHmqdLDz8NjRIoMFHg74l/STknuY9Hyy6doz82TWXHcgKlrKKd46XbpCowotk+FoH8RE08Mrncgv7zxFb9baXr1/4SVKHMktP+brLAe8i2za5/D88Kh8cIwS9E5OOWJ7xb9kPz0p8QUBKPAyyy42lETdzk4g4d/id8sTPd8Hvu99O2OrVHTgzjpoeF2YwV4oWN++p0rZZz8XkItdRqCH4EP5hIuWGGr3wX6VUr9u0QLdX3wSDWUF1zAc9YNCzCLzociLc4q1GsiWH2lRr/3KG1i1upPF6+VxK9inYimN7oHezbgsCNDFOAtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yFUVl500hJ4J8YYGrUelDItuik8WZlwShM2VI4/31v8=;
 b=C/ya2JX4Fb78dauZO0EZF5RsEXTri9vfnlcW9pQoeqRYiljAiyCXrhs+g4aJ8hanBRkMVqE5FSmTGQQTJ+3nTgXLbFTtU3uFs9wcEcaqM+Segqc4PpKI4qT751s5+IPNhoOtXRETwluHYcFracRw0gonLSOQ7rP0FFEDy1ENz4+gJ0tsoDGB8GS1zIASOVq3IxfrPocfH0jNc+Nw7GYADuLssJOq9m98vjuN5xVAwhT3J2CHjLkVnuZgbU+YeihwwDmz3hVjmjD70HqJA7zQ6Dc42oiiqhsM5bY8wlZjpHDpa2cNJqqGE/WA4E8w8WC2C9JtftPG+HZOCIdCUXCfrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by DM8PR11MB5703.namprd11.prod.outlook.com
 (2603:10b6:8:22::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.21; Tue, 20 Sep
 2022 17:25:55 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::9847:345e:4c5b:ca12]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::9847:345e:4c5b:ca12%6]) with mapi id 15.20.5654.014; Tue, 20 Sep 2022
 17:25:55 +0000
Date: Tue, 20 Sep 2022 10:25:52 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Ira Weiny <ira.weiny@intel.com>, <cgel.zte@gmail.com>
CC: <dan.j.williams@intel.com>, <vishal.l.verma@intel.com>,
	<dave.jiang@intel.com>, <nvdimm@lists.linux.dev>, ye xingchen
	<ye.xingchen@zte.com.cn>, Zeal Robot <zealci@zte.com.cn>
Subject: Re: [PATCH linux-next] nvdimm/namespace:Use the function
 kobj_to_dev()
Message-ID: <6329f7a0ba383_2a6ded29453@dwillia2-xfh.jf.intel.com.notmuch>
References: <20220811013106.15947-1-ye.xingchen@zte.com.cn>
 <YxF20Lh9yG6NQc7u@iweiny-mobl>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <YxF20Lh9yG6NQc7u@iweiny-mobl>
X-ClientProxiedBy: BYAPR05CA0077.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::18) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1101MB2126:EE_|DM8PR11MB5703:EE_
X-MS-Office365-Filtering-Correlation-Id: 092f1623-56f7-4632-d937-08da9b2d2c82
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eQVVS7sdb4tPgQR+D0YwlvMGiMThbcD9gRocGbKz0ZWrfB5DCST+kk6rVNufTZOnqwEFosgxCki6y9idSZQA0OdBvFLAsI7+odfNwEKibTIHMYoW0r9KXWpJCyFh/MKJnpCJd3bTLgFOWg4s7XSHXU/rznWuJS8yFqFZxF+CtROrfSedQoIV82CXogR/1sjR2GT1/gtIelX7q7r5jrDZ8ZrGtprYlZpiKAfb8eJxA7eTJifgi1QgTOb1w3TtcMna3UmcqEYfaG6E7yBEO42P64rOUH2CR5OWgonPykC+uvT7Vvfgm+AX+kr8aVb3L9kziqwkGAy1g0KqOi0Xh/CC+24FdW6s9mceY6wsUNXSFNGkaiMW3YIjB7cXcoGTEwK2apTI+CMBZaEAzN2M3boCjnhV6OEwsgsg3luDHGopAOEKeQcILPCd/LO92CeLetcT7VpW4fr0LXp2F5Uv/duJNRoT4Boqy/ETy9sS48zsGRBZI+qqHFG2caiF7+H0ixVvTPTsVhlmjthBndCskchur9CcDZcFrtvg0RLm2l34MdjqMuWsgBX4/cgqO+5TUD5UWyeUqyXphftyWKUhqxQtnAYAY89zZJ0+7JXoinOkZJbn06JKl6vaPpQeWO111Q60drSGjSZHA9TxhodJK5B6LkdlrZfZugf9Qg3/UnOFSOoicYkc827kFk3aJes/3+rgM16tfPJbE+YIRXLJauWD2A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(376002)(39860400002)(346002)(136003)(451199015)(41300700001)(6512007)(26005)(6506007)(186003)(6666004)(9686003)(82960400001)(8936002)(8676002)(54906003)(316002)(86362001)(6486002)(4326008)(38100700002)(66946007)(66476007)(66556008)(478600001)(5660300002)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vcjuyKNzBPrHDEgnsy8JrDsykvzczQwGdGZVstZR87fBVk//9pd8PsDuvIVs?=
 =?us-ascii?Q?WbHnOJtPVc/JxoaV9dF+dNYWHhyX8d55yUwo80L7F+F+3zks6HdT3plSREVS?=
 =?us-ascii?Q?fRZolGhYAFjJNzKAGfwyLUQIVvm+4YZeniazz5lPyAKv5/usZgBeW/X7GoFP?=
 =?us-ascii?Q?fPK4OlkJUmAbfjf1Cpg3mJqhZWs8wbX1Mckbn6QFD91XvfyEPopS1Fj0G3vn?=
 =?us-ascii?Q?4+jvhvJHJDGUFxMhMtP6BilEXOTttNoABb4QzEGuEOiQMbwlcVJ8HrtrhalG?=
 =?us-ascii?Q?FxI63Zeu4cmQe6GwCEjm+5U/p/lstU2L6ggBDIQEhT7hkOpGzEucS4YlmIFV?=
 =?us-ascii?Q?/ObtJ6LUbCVQF8/6xlAAFz+9YERiRuQqYHkTEL53asWnX5Aba/Diof6fxDdM?=
 =?us-ascii?Q?+WUauTPE3SfZzKuWjg2yUlAfDwh6wdaKM4IZ88r/8geuHTChV2MyXUhPBOup?=
 =?us-ascii?Q?MccfBbGgmnXrHId7s8oFJijpa8vbtd6P9L+u0VTQua2O9JBThgvRTyyvAriq?=
 =?us-ascii?Q?TwoZPv6arLKGg4852IEoX8gWa1MJOh3v99RWC8M10L2PkEH1z/kQEufWxMsE?=
 =?us-ascii?Q?YKw4XdGcIK6LF7MjcCnlu4ycrihn7afg2sj93eSSUqnNLIMIKGttFJMGgKB+?=
 =?us-ascii?Q?MOjsyDveFOfjWHZp6uvhe7UElaV9Ipg04BPz3aycXFidx1yCEbeLkB+ffFd3?=
 =?us-ascii?Q?GVC+LG0/wSIDDAJFFwTT9mwgTXIzP6JCRnybTMckkEkxeE9+LcgHBu34vPSo?=
 =?us-ascii?Q?zIG9hWobTWIUIWdgr309ew4/kfI491GMwNGd5ylAMjXMIzUDLvNrGrPDauyF?=
 =?us-ascii?Q?72KKu4G7IkG0yiiEwGk1TojFUZApJP4Fx+O/BxlngO9OQw3AmsnlZ5kQ5Hyf?=
 =?us-ascii?Q?l5uZDfGLSRTmm5TGIYN9dDgROBm48+6MK99u9xIO3D/V8sSyUXsM57/5Pnxr?=
 =?us-ascii?Q?StgoNwbX3KlDZUKPOkzjbj3y1gPcrjIgglJXU3G004fvJ2NaeHA+zFcYtSTA?=
 =?us-ascii?Q?1QKkhqUn0W6atSZUoR+4s/tMHji1slvyvfHlQ7HbYndeVVSY79Wj8zA9Vxsg?=
 =?us-ascii?Q?FNsYXef9jSdGldLAxEnOS0s6CgmnWo10hqj08au+ql026WLMbP9sgz/VR4xj?=
 =?us-ascii?Q?OTVtnkeg2QtdiSRqcemItEJpkznkGpV20C5rX6McrracsuUbZmdln3w3eO0f?=
 =?us-ascii?Q?M0PpGsfToBJgRB+SWMU0slg21RJotansZqOes0Xiqg1rYrQVajyOxba11DqJ?=
 =?us-ascii?Q?ACFbosfO10cy8Z5/oz8Ec6tOF8sJjEdXlF0+tfoEFMbhZN8SIj4175CNymH3?=
 =?us-ascii?Q?zSK2qZ2xW1VdqR2L1H1rCpOQ3tXnT5Q8/T/qwCiWFawRIQBBHqfa5qUW4n3m?=
 =?us-ascii?Q?yZvSBsJgXjd+AjkEF3N4gLualohjt5uV9RV85wY0RP61XL2vSKF/M1Aiz+th?=
 =?us-ascii?Q?cXgOyOGpbQaSjb+sE9K2aukDpQ3ahYFeQgrY6gXDTy5sku1ApFAd1NRBn8ex?=
 =?us-ascii?Q?aD5L0C2Vx8mRActenN9upxNgZ36bGkpIZqi5SiNfSjBo86sPl6/9DLrFExxI?=
 =?us-ascii?Q?I75Vue13p60KF0f6doJDUNyvzqFysLns7vzU89tZV5lQNdi2rkHgDGx7DbA7?=
 =?us-ascii?Q?1g=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 092f1623-56f7-4632-d937-08da9b2d2c82
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2022 17:25:55.0983
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0jAuGxJ34VvcSgWq9qDWELuwJyTNkcGMrwgDRiHn1WRDgbBFZg61UKFimcw4hznhm4pCAE/3XY31juPD1M8p1BeP8Ihz2nYqbDIhnzC6F0w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR11MB5703
X-OriginatorOrg: intel.com

Ira Weiny wrote:
> On Thu, Aug 11, 2022 at 01:31:06AM +0000, cgel.zte@gmail.com wrote:
> > From: ye xingchen <ye.xingchen@zte.com.cn>
> > 
> > Use kobj_to_dev() instead of open-coding it.
> 
> I see at least 5 other places where this pattern applies in drivers/nvdimm.  Is
> this some general conversion being done on the entire kernel?  If so why not
> convert entire drivers at a time?

Yes, please convert all of these at once:

drivers/nvdimm/bus.c:693:	struct device *dev = container_of(kobj, typeof(*dev), kobj);
drivers/nvdimm/core.c:469:	struct device *dev = container_of(kobj, typeof(*dev), kobj);
drivers/nvdimm/dimm_devs.c:412:	struct device *dev = container_of(kobj, typeof(*dev), kobj);
drivers/nvdimm/dimm_devs.c:528:	struct device *dev = container_of(kobj, typeof(*dev), kobj);
drivers/nvdimm/namespace_devs.c:1383:	struct device *dev = container_of(kobj, struct device, kobj);
drivers/nvdimm/region_devs.c:610:	struct device *dev = container_of(kobj, typeof(*dev), kobj);
drivers/nvdimm/region_devs.c:724:	struct device *dev = container_of(kobj, struct device, kobj);

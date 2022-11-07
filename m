Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA39215C99
	for <nvdimm@lists.linux.dev>; Mon,  7 Nov 2022 23:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667864575; x=1699400575;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=bkL3lnCC+n5Gz4ccnoVUdaa1TpmgslwOiQ0ca0OVEGA=;
  b=Yd1avbIGhmI2GBWqOj1J7XvcB2eLwJMQ66OkIv+APZ6pVNbGgF5aO7Mc
   SKy4YqaBINy9d1NLbKD1WJrLYhlL1pTBl3y1fneGCrBZOUf0RVe1Yt/R0
   8oAbGlLgbGKlNRRi4ee3P3yaAmSZqF4xzPSTqAFbavHJVXgSBOQ0C4eS6
   AA410txAy8+9SL/YXXqjoEm2+wmMj6O98HDI4VQSWbVxqo7Ri1opDVDoT
   axYegxa4lN/ChFdlXkxH/2sHl8XfcwPMHRxbuRfYc0Cmt0U9ITJDVMGi2
   WBAr41hv7KdSmnYcD3HWcFRtQeKP3JXFjwyR/rTz/VnWHdwmSMG2ZrfIu
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="312339128"
X-IronPort-AV: E=Sophos;i="5.96,145,1665471600"; 
   d="scan'208";a="312339128"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2022 15:42:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="881276552"
X-IronPort-AV: E=Sophos;i="5.96,145,1665471600"; 
   d="scan'208";a="881276552"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga006.fm.intel.com with ESMTP; 07 Nov 2022 15:42:50 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 7 Nov 2022 15:42:50 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 7 Nov 2022 15:42:50 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.42) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 7 Nov 2022 15:42:50 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JJ1nJ4uonGySOTUoOabl+YfAgjQyt4WMzXCfv9Dh8m8vqFnYs2hmHwhc0i6c3ISZgmGyWOS4BU0y+89WPZmkKl1BgCPBeZwcwjJRTCg9V7O+W9JdFSVGRG2FXtju3sP+w2CFO1qtmdVODK9f7jiEdKXSb3qnk6VChuOZnCTRE6/xLi/C/6Bi2PWcHdAD2KhpwEsMwwFAhEuPCiEYOOcipEZ9KVSrSQu3d1ErS2Um4sorIoz5Rznt6GQMMklUBw5S5GZSem4LBMNsd2IkrCb75i47UeNy+lfqju9ELex9llpaSvEbU0wt4vOQeLSMT2PYquF2AfFXaglI7Nxi0c+PzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MWN6XhU1wsRlDekAiUdWfzNhypCrM3CRY/sumw3r84w=;
 b=CGnYpNloVUtUTP1bbXcMa30vP5g++h2zeHvrpsU6+MMotmqmSLKZlumvRJvYTIsdQ1wWFwQQbpmlZ0ecbYU/eqyfBCUn/Xx+Ro5a3NTTOaF+WOWBjdeyBt/rbXUmRrmjS/yQ4GRpg3Jh8T9+w5MqsVCAOHkGY99RlMYk/pY3bahhG9ySqNy4fva5lBhHSvUh+HZqYhTmAA3YbWEBKCh+VyIQGCPEt0UMq4TA45rMeOu4yekdSDg189OuFZ/f/EFaHr1sk04T6cknRPZknycT6dxH/bz7aJjJDLBlApoxmGoaU844kdqvXEKozt7jykfruvv+GJfz7uDXcqVO166b2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by SJ1PR11MB6227.namprd11.prod.outlook.com
 (2603:10b6:a03:45a::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.24; Mon, 7 Nov
 2022 23:42:43 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::11a0:d0ce:bdd:33e3]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::11a0:d0ce:bdd:33e3%4]) with mapi id 15.20.5791.026; Mon, 7 Nov 2022
 23:42:43 +0000
Date: Mon, 7 Nov 2022 15:42:41 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: Alison Schofield <alison.schofield@intel.com>, Dan Williams
	<dan.j.williams@intel.com>
CC: <vishal.l.verma@intel.com>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>
Subject: Re: [ndctl PATCH 06/15] cxl/list: Skip emitting pmem_size when it is
 zero
Message-ID: <636997f11922a_184322943c@dwillia2-xfh.jf.intel.com.notmuch>
References: <166777840496.1238089.5601286140872803173.stgit@dwillia2-xfh.jf.intel.com>
 <166777844020.1238089.5777920571190091563.stgit@dwillia2-xfh.jf.intel.com>
 <Y2lpS3COS9YdJnon@aschofie-mobl2>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Y2lpS3COS9YdJnon@aschofie-mobl2>
X-ClientProxiedBy: BYAPR07CA0024.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::37) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1101MB2126:EE_|SJ1PR11MB6227:EE_
X-MS-Office365-Filtering-Correlation-Id: 43a6c85c-16d1-407b-3924-08dac119c3f2
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eeyr3eMy8IQUICrcR/mFeNCyCAaY6unl376sXJMDLh8PLwhDpstus2Yj+i9z27HAJkUNR+FT798r+odSkHxzAwTRkTHanr1QtDrGbRAHZQHStX+xl5LROj29tkhq0ipOnvPq8GqRL/aGJa5rSn4AXCXKKPh5YRJhKqQm6cUnNDOYJ6uWJJ+YuFjhjnh+SDsexWRjH6lhmovxU9iJJWx9h51cokKOuEA3lB8oawLAIJUHzWENWMPYE12VJ+Q0o1rmA07rbu+z8Ljvw2cum36jHhUa5MhWF99JCxm7ylQPhwf4TBXlGYI1/lPMhB6vCqtADQZzowzmRxgZqstBLCDxoxNe5folS1YJ+TaEc/foFjJxImV56Lkwsx23UWN7TtoXRrUwJYFfmRSVGoPnRhrO8vZEOjuDlwdVYEFMClRMddXfrzhoN5ZyD7Vc6U26srwGlG4rrCjcfoP+mN4bbKC2jwiikoCXbFPL4SzvrIOeDFMp9xV+qQ7cOWLcOth1v+j/brLOEd9MCflbpbA+lADab11VU8QGFURDqan6kRqrqLiy5Vw95tOiNehFgQS4yyAUWfK6LEo9Ed+0eD4E0oZ8mRsocjisaPhQgq6xNqKxHnhvqCSMzkcN+BdcHqVIn4EgbDUzVSDSq5YbTq1xY9CHTygxBOicwLqHV4tK/PrEBA+3N8AFjPKBRXLJ0+m6aVaZpqlrvf6RXmQ1cE/oQEcx8g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(376002)(39860400002)(366004)(136003)(396003)(451199015)(86362001)(26005)(6512007)(6506007)(6486002)(9686003)(478600001)(38100700002)(2906002)(82960400001)(186003)(8936002)(110136005)(41300700001)(66946007)(66556008)(66476007)(4326008)(5660300002)(4744005)(316002)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1qoS7rdqxelM00y51Z4E2JK4I3dA1BXdBaF/KZfVg/wBbyWz4alpo95RBOBE?=
 =?us-ascii?Q?ljDikrhych7zLclhgKborR0X6KRXhtfg80vRdi+AH7kxh4iqoIofMngA1fC7?=
 =?us-ascii?Q?lJtfELBLyTieL0rarAhfzgzPWRk8xvs3CBqiO+SaI20Hg1BTgEC5SfC9/Jod?=
 =?us-ascii?Q?Ye30VGjboiuN2e8dIhrRm7iyTSR/bPmk8B+8D4pZKhphTaZQDe0kQJCyDeDl?=
 =?us-ascii?Q?++g9YAzF4EinJwt9E0daxwfJCAxNhRwzWsAyb5uHNLwsqbq3qddsO8w+dISt?=
 =?us-ascii?Q?z5SoUcUhb1LroiWME8isFl82HYBo2lTtqSonqkCXDOwO7H/33Mh03tR9H1L1?=
 =?us-ascii?Q?eRlmscajNK8o4jSwa5CeZgacKeVmNkiufP8up+lbcRhk5PhQ0jK2mcIOA3hP?=
 =?us-ascii?Q?Kva+SUc12h6cqAzs9kg/a/BeHcCRFaDdD9QZikMk4IhtDvYzJA/sEhtp11SI?=
 =?us-ascii?Q?6NwRH9soee0dJUp3nxHKKCIvQdeaYPLbBZJbhDHeRGG5MEyP7YweNu+ymN45?=
 =?us-ascii?Q?OGVS+hGDf1NYykyEIqkxamFcPh8iQ18ly4xXrEz167xqU5x1LNrIGs30h0jU?=
 =?us-ascii?Q?g2F2D81Erl7BLwuN4FIhOdc69XDNoONNAqP2PW/U9ac2Cl33IpHai4BSAfxN?=
 =?us-ascii?Q?C4smPxmGEDN/kMSjTqkpun9OZ2DifnJGx7vB3qyziElNSWe/wvnDa8I/+GB5?=
 =?us-ascii?Q?anXT+A/9NKqk0EH5wB14xnjYmxIO2zmnqj9anFzCODHRLRzHwJ/o/8c8qN3T?=
 =?us-ascii?Q?eSkC1tfKsTXox8gVyWL8g11GZrzCHVpoev0dvyqI9wzfIIIzSu6at56/ccbO?=
 =?us-ascii?Q?TdLeBLQxtvxOoEUPM8rVHQw/j18hhPTfc1XAZzrLaPmXYwyVApHdo4NFu9JG?=
 =?us-ascii?Q?nXG2KpMgHxBnCZPf738LEyA4wWiVDtx9KFiulJ/ry8eI53lpul5ji+hnsMmH?=
 =?us-ascii?Q?+l8mF6Wx+VneVN14mz923engjWfhE8woEJDHhAF/hexu+NUQ/NadGg4/rME8?=
 =?us-ascii?Q?gNevflzPywoJWPqoCSwVdaFuLy8Ehm+Rb+gINaqnj8vJS0FwOZQBitRqN6SN?=
 =?us-ascii?Q?0oNnvxEBKoB3FUo2O4Lp1UlQEvdtoUuA71QzJHQn26D73L+9SzC+5jdlcZr5?=
 =?us-ascii?Q?c/TuaqvXPkSynjPlR8s8YHYwBgFJIP1m4UMW6SqDzUbVSM8NAKAHJQ+FNEGQ?=
 =?us-ascii?Q?SeYLWZQ7R8e75Vo9O8Yzn9+UHBmg9tT9NlSxCJdbAoKs3sazau2Rrla8tqaI?=
 =?us-ascii?Q?C1+4GmFvBFiYMls3hRV9P9KsrfzY3Lb2FPxnZVO0wPGwKWBayRjUZV+J9eax?=
 =?us-ascii?Q?Lp8e2JcobuXsmlRJF0DWw4XY5CeQPV6jGfbO/AZ8hNK6vYf6X6wE0JtnRFVx?=
 =?us-ascii?Q?JObnO2vaOz7ZGwwY00bhhOcEowc7tT/0Dg5XSAl2SgD7rhCSdIg6NfL6sK8V?=
 =?us-ascii?Q?oXmKAIf5h2/xsD/0oy6mZvwUaUesc1iCRxdq46J3ArNjmRoUJ9fG41xlLy7J?=
 =?us-ascii?Q?91lN1kbImrmauIzWXnVJTBnnja8AjCmweWjY76FwE9oHkn2e+hE2iTxfh3uy?=
 =?us-ascii?Q?Gara7kLZ3a0CPaAY877rykewnZx3v9v8raa5/Nwfk1vr78boxhLlxgTBLWUf?=
 =?us-ascii?Q?wg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 43a6c85c-16d1-407b-3924-08dac119c3f2
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2022 23:42:43.4152
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CDRL02AE9gtyhj90opQAJg/eiop1HhtmMNx8lBOLhRRB1P8pGo7CkYPrkU8MkekZjk7uEBC39ArfeiaoPUWgsvBC2Ado7hZ+ldNqpaiuSHM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR11MB6227
X-OriginatorOrg: intel.com

Alison Schofield wrote:
> On Sun, Nov 06, 2022 at 03:47:20PM -0800, Dan Williams wrote:
> > The typical case is that CXL devices are pure ram devices. Only emit
> > capacity sizes when they are non-zero to avoid confusion around whether
> > pmem is available via partitioning or not.
> > 
> > Do the same for ram_size on the odd case that someone builds a pure pmem
> > device.
> 
> Maybe a few more words around what confusion this seeks to avoid.
> The confusion being that a user may assign more meaning to the zero
> size value than it actually deserves. A zero value for either 
> pmem or ram, doesn't indicate the devices capability for either mode.
> Use the -I option to cxl list to include paritition info in the
> memdev listing. That will explicitly show the ram and pmem capabilities
> of the device.

Nice, I like it. Will append for v2, or maybe Vishal can grab it when
applying? Depends on if I need to respin other patches.

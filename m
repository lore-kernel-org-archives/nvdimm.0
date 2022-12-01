Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53217107A0
	for <nvdimm@lists.linux.dev>; Thu,  1 Dec 2022 23:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669938529; x=1701474529;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=t+dLeT3FcTjpP3/rJpe292ejWEMYHK47AMxVZv5N8Xw=;
  b=AR5l2TeLB9Gm3qTdrNndszTgdpAtpEs4ns+ZNkAkL0cOvigG8S/UOBnc
   KMoFpmQPLqyQyCZXiKv+lotJ383ubcc6sgcVk2CC+xK2GgDmSWX6V8zUb
   kGvkrVMYodjbwdK5xRk2xVlm58jRImv0XiOWQZnHxFHGAPnNrMClUp0E1
   TywWjCW+MaXf9C/qm9lQR5timSaqfrgPGwM2U+QX2fCQ4/RwFyhrr8KyQ
   MsgrZD4zDvpYup8matJzjFgbJLbMxlIPKLvvFVpIQh4uZRmP5IXJMOMUS
   79qJ7+E0a3bjnGr0JHi3PccUYS/gcn/QI8MlvQxGqftiQxcl2e95oS0dD
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="402106635"
X-IronPort-AV: E=Sophos;i="5.96,210,1665471600"; 
   d="scan'208";a="402106635"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2022 15:48:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="889933636"
X-IronPort-AV: E=Sophos;i="5.96,210,1665471600"; 
   d="scan'208";a="889933636"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga006.fm.intel.com with ESMTP; 01 Dec 2022 15:48:48 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 1 Dec 2022 15:48:47 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 1 Dec 2022 15:48:47 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.44) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 1 Dec 2022 15:48:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gQ2Slw82sw1b/ABkDOdXiAyCIMko+4PJwLEw3SIxzMzC9i0i4Gc8oIhEuU9Z2YqNcQI8R4BKA7ZqTmFl23UogDsABnLV5Z9f3BwHLlY5k5LUcTKrRg2asmQmcIup6AavXcCMIhhJBXRi9UFJR1hv0j+WXDfMGw+5DMBxLMhtTsFDqIBM26gNCtBCwE8HORwwxoBzKTyccaP71mqizjfRJxUksLBPaJ6J6lIBHIROH3FNZn1zL0J1BM6+cBrZkgFeAsjbZeQpgyi2kaWOgaa4opRLtPM2x1uQBTju9kyCAFElJgqTLYyo09eXw2JL2vb0OXVXqVNOwcnv5Ce8ZFcDng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p2+aAereqgL0juzpN332EIw1G7zT6zakQtXI2UE1TgI=;
 b=VBUWROZB7tVtC9JqVH3NVYpMNJX3mtVVI0pb3NuEMmg2GnFHMEmQ1uPkxvv7fNK/oKw8xIlyqxx7xAvnK4BJ+IW2CWGpBCrBfy5Bl0iDwQq7r2Z8lYoNwO7I4XLV08NSkb0nC3xPPepmQbFyuPtwToZkhYsukq5DbC6qvMTuN4JpTai67/mMb22xKELwfUHJObsr/YUQCQc8WFwOZJQX9WXxo4MfkimVBWjF9QWnLwtL1V09IdWGssLej0te2IfBBE/Gv7qhRYM+mAq42IQAdTTk6XUyMQ/J0GCQ9gVUB2ScnJmUNxMQyq2UdJzT+rHxb/49pjamuoOlAlDVM30ojg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by MW3PR11MB4588.namprd11.prod.outlook.com
 (2603:10b6:303:54::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Thu, 1 Dec
 2022 23:48:40 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::340d:cb77:604d:b0b]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::340d:cb77:604d:b0b%9]) with mapi id 15.20.5880.008; Thu, 1 Dec 2022
 23:48:40 +0000
Date: Thu, 1 Dec 2022 15:48:27 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: Robert Richter <rrichter@amd.com>, Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, <terry.bowman@amd.com>,
	<bhelgaas@google.com>, <dave.jiang@intel.com>, <nvdimm@lists.linux.dev>
Subject: Re: [PATCH v4 10/12] cxl/port: Add RCD endpoint port enumeration
Message-ID: <63893d4b4cc2e_3cbe02943f@dwillia2-xfh.jf.intel.com.notmuch>
References: <166931487492.2104015.15204324083515120776.stgit@dwillia2-xfh.jf.intel.com>
 <166931493266.2104015.8062923429837042172.stgit@dwillia2-xfh.jf.intel.com>
 <Y4kuJgjes4a+vjuQ@rric.localdomain>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Y4kuJgjes4a+vjuQ@rric.localdomain>
X-ClientProxiedBy: SJ0PR05CA0198.namprd05.prod.outlook.com
 (2603:10b6:a03:330::23) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1101MB2126:EE_|MW3PR11MB4588:EE_
X-MS-Office365-Filtering-Correlation-Id: 4444f65f-ca7a-4420-450b-08dad3f691a2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nQ4oKSBhNym6tPDeCEX3TlAteBRg/jmqLCe8wgwhHhNSqKbLwQQtebZNTK0JihTqW/4jVkDGJjlDzaSVUxKKABfuoA4rlsZeTnyrOPElXuW6K9h/xTSyjA+V5tbF7wo74oKzjGBruDaovJh9jCwhSIBXrmDFePIRzbt3eZz54OqmyOqFxpgB4079LT5O3oGOm+k2vWoP5wybICsYh37e1Jw2eGm2M4z3vCtd/2GwtPp+ChpuwcjWBGdcDAGVEHIHb8vtVq06MVP7rXjroPu2spzopltN9E7kBQ4TtawwnOOMXq81egbJmzV8n4HVyUs+VyrR0vzhRhU1nOYRUp4d+4/cZp8zTzSvzL1b2osACLf8X0yR4oDX+rbWgKEuj2ImdnQi/B/qJ2qgzGue7eO45rVRzgxFgBXK9DB7pCWotuHeaU9gvGQgNhbaLcviIGFzXHko7rOvTMDpZitYea9S8su6AXFGpJxgtkWzorqmHILmreSH+iiJN2zW6wJk1kEFE3SR2ta0kr903aYcAPfkrDdtrd8RFTL/r+wnrqPvshSRRTGoetCnG/eH0dhdAbM4tbKU3pv3gnyPbl7P8Hz/QPPpz4A0+xxXRAq/GCun44tVekAjlznN7+3X+HBanN9n+KFGEVZdQyyxGiH6chKsrg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(396003)(366004)(346002)(376002)(136003)(451199015)(2906002)(83380400001)(82960400001)(9686003)(38100700002)(66946007)(66556008)(8676002)(26005)(6512007)(66476007)(53546011)(6486002)(478600001)(6666004)(6506007)(41300700001)(186003)(8936002)(5660300002)(4326008)(316002)(110136005)(4744005)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?K8iDtLNcvryYpV8I0NGvThwo83xNPiGU3jJHwGUZb4YOK4zzOlK2DC2E/QlX?=
 =?us-ascii?Q?ebWg3K5Jyo/84dw8JCrdDiTSozViPJL0RNvQWJQ6yIjry5AoLuQRIj9T1j+3?=
 =?us-ascii?Q?1p3TU9WWyvzipQpRqJF0hylMFp0uWYxHizS1Y6rwqSYbol2f4inIgATNzWfZ?=
 =?us-ascii?Q?p1VUsfbIrN4DPNNJY9lXXAMoMiHVDgvg13Bbe7MTgfwQDfyJPjBhUTROFPza?=
 =?us-ascii?Q?e8Mi4vZC1khMyeYJ+s3QRbrATBYFWHYyqY2F4jaAp1VuqyoUMQQUnoaXZUmC?=
 =?us-ascii?Q?XTaDJFQmMXWdy58V88/yaZcrEFPr3lk+V/JvkiOVUveXd5x2B9PGpjLYPXUn?=
 =?us-ascii?Q?acusS1XTcmzPjHICGCVIdiX0SNBvv5pBXyrfHuJmW1KCbF7ZUNWnUUGXhOVt?=
 =?us-ascii?Q?lUt2975817y3+XdlX3oGlzfrWBa0/CuZrBgzSXQYY26u2P8GN6S0S5t8LcGI?=
 =?us-ascii?Q?qk1J5ORXKBzns/2+2fxthq/cO14OahQ/hpo7zBatEnBRyp2OcWLNTb0nRKT+?=
 =?us-ascii?Q?+s+Pv1ht28YZr7XfXh67Z5q0nOEzTrUQEapb57IrWloyr/v9dD1WpWqfBCpw?=
 =?us-ascii?Q?AAhggPl1wlct02ksowEb7qFsQflBPPqc1l9y4CzagFsP8JKVNj5NcPaKuMtT?=
 =?us-ascii?Q?aUNd/iS2/XvC/pAWnvfvYw9YIpc9cwYmHQUyuYlkgd45LpxO06Dkpd2jTT9Y?=
 =?us-ascii?Q?B9kFh2MdpjqrUQxOrWrzP4tHFlzUrEcUE7ID27+TqbONMGCgZpnlplT5rq6K?=
 =?us-ascii?Q?C58a0VaGmwD0Sa5xG+KY8TVSobMIFRSuQHaWgK7sWPor5KOqOS+uih48D76y?=
 =?us-ascii?Q?0r5denvUMzar5pxUvh9r5WPj4BpVE45Xf498KH4jCFtM2dExn2jxk5uduE/B?=
 =?us-ascii?Q?pU2KEOyNp9Mre0GQXkVlHfWBidTx6jROegURspklYl4rkPQvqdL61aLB6DJg?=
 =?us-ascii?Q?Fqpt1i3R/h7jb5rzfLFXKGGGvl3lIr7sBxudvmxPw+4F0TFBVSgAuK4VZSRi?=
 =?us-ascii?Q?wHodd3T+y6gNR3aATszN0vWPEwudLK++wU20Vek5ETf5QjytIbYMHWFhpDN3?=
 =?us-ascii?Q?KeaL39IFQ/W+WjsEtHbcWOjwoe1+yocf+6TSThjEWR1CZ+8Dm39DexHeBdtS?=
 =?us-ascii?Q?TSpBpsOlYhJSzxwpjBSofXKVYxalKmk41TmYwJoyYda9wM8aCHbawP8LeCeL?=
 =?us-ascii?Q?GwKAvo0TOew7s5Uj/06bwFL9yLP4a9cHrZX+FlImpao4CErsbgiLl8NRaYk5?=
 =?us-ascii?Q?Rk7h7KW/YtVCDVkjvKIk4+KAfmA7Ev8HoCZuzRkmNcjNCnnQ+MuTiydX3AZj?=
 =?us-ascii?Q?C0P/ku1Dv3OoxQ9zMQBOfgw3y8u1fofjjVw01c7HClLDSTWix10RgbJ9dmqk?=
 =?us-ascii?Q?MPXGWGWaKvA4CwjWr9m5c0rseSx5tS1MK04JMNUyGDvwU8jbvtm1Vm5I9HCR?=
 =?us-ascii?Q?UV7rSyTadrgzEkmGNCrZDQmdwgabr8oRrTGoISdIKDYnX0CcOyJ2AQwZhNRa?=
 =?us-ascii?Q?WbV5AWX8cWaER4cW32p/MaalrmE16ODZ4/0AtazS7j60g3WknmBnks4RlXh3?=
 =?us-ascii?Q?aEqr3T8fOaRT1wr427U/q/9lVMofs67aa1r48ssCn3lSlVRT2H2Ie5v3EN4K?=
 =?us-ascii?Q?Dw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4444f65f-ca7a-4420-450b-08dad3f691a2
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2022 23:48:40.5403
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YlZsoG53M5RWKG4vxFrnhIAXYBPJux4Uvcs95ZW36XgFsO/XxnVceb07zOrj4ABExKFrAA7uBkADSCcWCVpsIqRlZjcGu4N0CXvGd67T4I0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4588
X-OriginatorOrg: intel.com

Robert Richter wrote:
> On 24.11.22 10:35:32, Dan Williams wrote:
> 
> > diff --git a/drivers/cxl/mem.c b/drivers/cxl/mem.c
> 
> > @@ -119,17 +131,22 @@ static int cxl_mem_probe(struct device *dev)
> >  		return -ENXIO;
> >  	}
> >  
> > -	device_lock(&parent_port->dev);
> > -	if (!parent_port->dev.driver) {
> > +	if (dport->rch)
> > +		endpoint_parent = parent_port->uport;
> > +	else
> > +		endpoint_parent = &parent_port->dev;
> > +
> > +	device_lock(endpoint_parent);
> > +	if (!endpoint_parent->driver) {
> >  		dev_err(dev, "CXL port topology %s not enabled\n",
> >  			dev_name(&parent_port->dev));
> 
> This must be dev_name(endpoint_parent) here.

Indeed, good catch.

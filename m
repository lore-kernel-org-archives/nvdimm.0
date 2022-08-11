Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21A3C4A15
	for <nvdimm@lists.linux.dev>; Thu, 11 Aug 2022 19:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660247264; x=1691783264;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=meTnDYy6BK9YV/ZefEBMHVdRsdqJylvx2NCnFqckBJE=;
  b=SW4LvUmbKVvwavDQu4ABlc76t/gejmrbQKbdTKS7Pa1jbvu8kRNHF9ET
   XdN5FyQk/pN3K3RpiM+P5JdtLarZLnH3MRRQdR9ddjUS2Iom/yZA17YAf
   RB1izFYE1svfitKAmzIcnsAK1owz5E62chWhbz5y+s1be9chDFAmWPDpt
   s8OMn4KlpHiyl80j8sqioY6TgG0JXCb8lwj0DD3hThZqKGaYFDIF+6XcM
   73TPEFy7ntP9h8kk/B00VLDp2aE5Kri3vIL9gFKFT0Fqx1/+2QmFZwtD+
   2GliH0Nm6ZGcx3XSE3fJ1mYgrxa1kLYaLna5pv8pCl2C0k8XlcDdHHpk2
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10436"; a="271221905"
X-IronPort-AV: E=Sophos;i="5.93,230,1654585200"; 
   d="scan'208";a="271221905"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2022 12:47:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,230,1654585200"; 
   d="scan'208";a="581804994"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga006.jf.intel.com with ESMTP; 11 Aug 2022 12:47:42 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 11 Aug 2022 12:47:42 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 11 Aug 2022 12:47:42 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Thu, 11 Aug 2022 12:47:42 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.173)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Thu, 11 Aug 2022 12:47:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JAYHGRW6N3kWq0QFCQ17cHpUBSQkaAyot1InUsY1qALYpInTn+o9RSnIn+E80HviGXdAFh9HZ7CAJo4pgFzxHZ8SYXWydBixRx1I/IcEOmwlmlDHMcc9eJOATnVWWbt3KqN2oMR0wPdtR7YpkOoAHT7q4EcCWFC2M08uqBAj8jAWp8V1ompJAYQAX6rPV+BvWviaP4IXNjiJe3rZtJ75IhXT0IfOl9FcP2FGNSd8vx7imkKrmXCKgXwIBiH0W8FKn4cBW+sWns4Zf1Azpsjku+3dBXWQvSk005cV3KbtexfqCzJ1caj7Lz1fuMY2wCxU/2oJ+z2+Jx3vJNsBYmgIHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gYD/ip53rob4uP7S86GNwlqPK3tyZ8m4JoJntH+hJW8=;
 b=dvB3AUpdIptevMWkSSXLE/YODICrMTwx4sofkTxRt/gQiHbUUmJYRSZ69PcnqPzsGiqSQYiZNhhrkhIIXlvhmUDekPkaDv4XSY9X3sz82uibEOFeR4gU9szLiF+z2DCX1dAAPpVlUQ5RW/juKpoe/S7tII2nl9zMiXcLwVP4Xw/ZcaPGgOrhR5on37r4wiEReNJGNgQJtaW75S9xyBkq0K8nW/9KHS33B5eZKxuExBCWj0iepTCr69EIhRHsDymULo/YMz9SCYc/fH9Rao871dADqD8ymrgVZo47qXVDwlIUGYYk2LtipAiYQ0qfEmKdr47ullQ0nPN8Coxb+h2sKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by SN6PR11MB3200.namprd11.prod.outlook.com
 (2603:10b6:805:ba::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Thu, 11 Aug
 2022 19:47:40 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::9847:345e:4c5b:ca12]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::9847:345e:4c5b:ca12%6]) with mapi id 15.20.5504.024; Thu, 11 Aug 2022
 19:47:39 +0000
Date: Thu, 11 Aug 2022 12:47:36 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Vishal Verma <vishal.l.verma@intel.com>, <linux-cxl@vger.kernel.org>
CC: <nvdimm@lists.linux.dev>, Dan Williams <dan.j.williams@intel.com>, "Alison
 Schofield" <alison.schofield@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Vishal Verma <vishal.l.verma@intel.com>
Subject: RE: [ndctl PATCH v2 09/10] test: add a cxl-create-region test
Message-ID: <62f55cd8e2c62_3ce6829421@dwillia2-xfh.jf.intel.com.notmuch>
References: <20220810230914.549611-1-vishal.l.verma@intel.com>
 <20220810230914.549611-10-vishal.l.verma@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220810230914.549611-10-vishal.l.verma@intel.com>
X-ClientProxiedBy: BY3PR05CA0036.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::11) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 97b753aa-0e70-4a26-8a5c-08da7bd25925
X-MS-TrafficTypeDiagnostic: SN6PR11MB3200:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eJKX05A1jpeeXFZpqo0mwB09VbOWhLfxwxuv7FjCc+2DrWAy168lmUhRuZTimht9qRQqSpYCGtFL8xbfAudhAU5AEDNmhGF/3q043p9Di6IgBcdpLvypK3FYAkQcRZaJ+wzl7I2G7pWMyL683lxtrZePVjWFGNXvjunKnPor4IsEi5Nqkt8eve547xgxfbaZV/2595hGMVNaUyuD9gn9bLIa+76TXj+xMDjPEwk0+C6xq12n3nICSDAES8LhQJ2L+lqDhY3uKHtvFRdB2ZpAQzbEnU6idUjEQWaRN4sENtxR4tjj2gzzbQogNAPndT2qcdpI9rWJYWL6Q8Ylm8I8i/vEGOdk+XYnVeP/Af6TVxWMUoI9Qj2ExpLrLZL/wz2ff1UKJ6cLY1gbp5TTjWEvpXSBJBhxOaM7q1aQxmUoGoSzMJhT5I8/owlsyHL/Ddi0u4ZVAx7tLAYy4ivA0TZpChdpH1Jfpqe7yiHlzBi6ijefcF+SEv/bUcNYD2uqtkxg6oYtOixgXUZUblz/q/dyIsacaBu8zT02HhlzU34xKPdljFe7esqZGm/JEfjRGBOa9m3gpaSLUORzZ7ZAiYoZfUgPB5L7GQbtQi6Q9KkB6Nt3HizzC5zgFHIGuV5Nv+CYDmj8vpQNae78kLtwDR8v5svOi1fhwHfEsTvJeFWGkpmXpO/a2sU/jC7T9wUQtNTJGyFsO/UjU3cgYHgfmNFlpn9Dq2dGQCRrMA5f5QIpc9bUA5bRcgtzUSP4/G4IcppU
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(396003)(39860400002)(376002)(136003)(366004)(478600001)(4744005)(5660300002)(6486002)(66946007)(66556008)(66476007)(2906002)(38100700002)(8936002)(8676002)(82960400001)(9686003)(6666004)(6512007)(6506007)(26005)(107886003)(186003)(86362001)(41300700001)(316002)(54906003)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?97zB69dgdxyR45pY2jdSKWbwVvxrXQzMn3Ya6ZwDnHlw5FsliwLXBsgB9ZUc?=
 =?us-ascii?Q?0FjtuSPtudc205DHYxslfH3o8pcgxurRwUj5vyzC4XTQapgRX7ZmIk+v+41d?=
 =?us-ascii?Q?YNDgYZe/o1JlHHBSrb+dLt1IiBziBIDWUKdVcivw/Pz9nS0GwAjw3b8BLnzQ?=
 =?us-ascii?Q?prApMWcbj/nVzdNnfTnct4a773afYaLbqGcKE3mW1hOG68UPKncN9k1msfwJ?=
 =?us-ascii?Q?ozH7fmlxjTlfke663GrXt/L2z/JR+W/ATmhp0YqA2uziFVkOB2jlvlKsRtqB?=
 =?us-ascii?Q?izmssnKNUQEj4pFrG1yx6wz7ALcQYsVWv0mLxtguFpH7ZyBsW336ElqTvAh3?=
 =?us-ascii?Q?mFSOq4PQkYaezYYDI5HggONaKwfluq4P5iQPQpjkpq66uvLexip2k+AOw5v0?=
 =?us-ascii?Q?y2Pa/4jjpXgd4H1La7oQeBmQMRjCXclrTWxecju0+5vTQSkXSOgdPkJzGfKe?=
 =?us-ascii?Q?RseRWIj8DZW6xFDKSNRWUPG6nNXgzTo55X1l6r9xMv9rTFQ8FuU+Tx0cRZAR?=
 =?us-ascii?Q?8plw4+RGc3KJDkybDgvVejAx0Yo7ADMDpgT/xu1unS+z8T8D5Sb2+NQ53DTv?=
 =?us-ascii?Q?APomhY7bgRVhUJp5tiaX1g2F6lhuHPjAKQmUYCntOl5RWU9/mEZaFwGCAMuX?=
 =?us-ascii?Q?008NfB/hK/MPWPib0C0GmSvOSTGcLP3VnFD82uXjTINEzpyoTy1QqAUlCHxQ?=
 =?us-ascii?Q?GOdsQs4bPe2Rlicx31l2HmFyDGoYSOY3bWzjzwRdcMu4bxWduXyZTsafCAV+?=
 =?us-ascii?Q?CqJxU24LOEWw4yCf0OqplerJbE+hKqOkut/61w8KOV+68f9p6XMGTSON3sue?=
 =?us-ascii?Q?DBapGAElskg88FAkyFu+zWTDGslfsbdoBxoqM3YuSQziJ2GHHU7s239kennt?=
 =?us-ascii?Q?GnxNH0uxgPTyjajsiHzSVs9ypqCgONFS1vXrUiTThYhfSi6zi1opzVUCBnNs?=
 =?us-ascii?Q?KpYqm2P8C1VKllzKZBkkL0DILlDtsdMAWfNQi6pFWFdgydOy127DJxyLXli8?=
 =?us-ascii?Q?rfoj+bg8LvPW3tFWab729lDCJjmn41Ws00MAxOnM1q/s7bgBeDXLgQCA4Nl2?=
 =?us-ascii?Q?gfLyb4q8bcjKWcPe30s7qyCZCBpfM6+pdIs6l4dR5q/B6qmcDzIdUvsxabLe?=
 =?us-ascii?Q?GPOA2Rzy14m+ROxW17bjdMM89aj/OXCYltquVnHZ5UzYQis6sCxvPhl9wJ/Y?=
 =?us-ascii?Q?Xfxk4xR3dPzuIa92n2skvxThSa+qLkChchQbn0XfGqp+HZywHn3GwZVnjpkG?=
 =?us-ascii?Q?pIVBl9Tn6qq7jGNVvOuaXxp/PnJEeX+wtwqBZqawmkKAX9IHFz/MjDlz0dEr?=
 =?us-ascii?Q?5B8n2DY2BwJkIeEHaiftJ3R7zqXlCt5q/ZOU4T36ODwloDnxQXrRBVqd2EYQ?=
 =?us-ascii?Q?M1+dYhmUxK0DgIxMOI1pWm97bNXpjQFhr6jYM/eNx6kU22RULx+OY/iLFkTV?=
 =?us-ascii?Q?oGxiuniCncvN4V5g7P7816duzq+SHJmUryeq6Gh7AkTctGJbsFQKugZVV6qu?=
 =?us-ascii?Q?qv8fHW9P9d57GVSWuSuCnNU+4UpQ8nw/z5PCe3Lah5ulUkF5Qg9Wpms+i/LB?=
 =?us-ascii?Q?nzFaOZ+/h/s7zTtkPM0757nYKXmtbUqFlInJbYCTQqq85ign/L6Z0G9uMU0C?=
 =?us-ascii?Q?iA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 97b753aa-0e70-4a26-8a5c-08da7bd25925
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2022 19:47:39.7358
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +6MjJipLpK23sRBrSQB88XqVBzFON6RjICPMyi1HFb6lgHCo4pMphqD45a/Lm8b/x2KxHs2hG5qxR7tU3QJ5CUwN8avPHMFfuIdsJtfk7bw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3200
X-OriginatorOrg: intel.com

Vishal Verma wrote:
> Add a unit test to exercise the cxl-create-region command with different
> combinations of memdevs and decoders, using cxl_test based mocked
> devices.
> 
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  test/cxl-create-region.sh | 126 ++++++++++++++++++++++++++++++++++++++
>  test/meson.build          |   2 +
>  2 files changed, 128 insertions(+)
>  create mode 100644 test/cxl-create-region.sh

Sweet, looks good.

Reviewed-by: Dan Williams <dan.j.williams@intel.com>

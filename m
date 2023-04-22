Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 206107F
	for <nvdimm@lists.linux.dev>; Sat, 22 Apr 2023 02:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682132385; x=1713668385;
  h=date:from:to:subject:message-id:references:in-reply-to:
   mime-version;
  bh=ntce1rU16By9mwyjdIHfMsi+3yCrPMNKz1zhjgMky3c=;
  b=a4LPPqCEha2xdOyQQ+G/EytibJtlqUAc2QAWmuk7pOANYGVrnmugy1lb
   PzNFLzhim0MWdZfNxwBp7eWg6mC1N0qNuDtxw7quny87SEc47JS8UGl/g
   qwIW2dC88GUKGmGog0vDaMuZ6jXcuMBQ13VtnEssjHO3cVuAGn++yVohV
   6LCEONmoZTh7lxe9qpq/AW/h+vFnwmfFq/dtqNxfWrItWwG8KS0ryJGJD
   OD90ElJeTHXUtcCS/q42Wsk2IE0aJq+fiYl9bMD+qV6P1hXBP2dqiV7Bz
   BoWIA9GrI3Z58HXmPgqGHqQgsgYysoQ9RXdUFY6OPRQg7vPyg0itnIeXJ
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10687"; a="374058351"
X-IronPort-AV: E=Sophos;i="5.99,216,1677571200"; 
   d="scan'208";a="374058351"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2023 19:59:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10687"; a="866884175"
X-IronPort-AV: E=Sophos;i="5.99,216,1677571200"; 
   d="scan'208";a="866884175"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga005.jf.intel.com with ESMTP; 21 Apr 2023 19:59:44 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 21 Apr 2023 19:59:43 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 21 Apr 2023 19:59:43 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 21 Apr 2023 19:59:43 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.48) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 21 Apr 2023 19:59:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eYLVDnC9z2cshTorX6yK5p5IFD4qK5YBb5zZvDxj9Wcr7Wgv6i+b/nNsNCdlOKUqt+HPNpQ56evrwjleAYsYlL/gWLZQFE9gcQpgmVD0wwPF5YQN36lWWihw5481EsNjUL/mGr6AD3ZFyiBCXKxZhnsA98biYdMR7oQiuaTOZLejtmXIL7tgi5KXvrIz72d8hLyR33AFPaKC8XcbHnlyOQMsaVZVvHg5B6AIM7BA3E/hYpYEtl9MR3+DMnY+TANzuuQsNx+SI13B7xSWL67fWbvRlnQiLrH4BWqqzUCNctsHerH1vERhRYFc7Ap0XFdEEwsAyoDfdkcyO0TapRHSNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x34Vrtc6D1Fw89nnG9iFA0zgjnc7RA/40iycUBUNCUU=;
 b=cfpnFhFqC7kaypLTSXUbsKGhGOYs6hlA2FXlvomarb4XOj8YbhcXicHdH+FfS7TcE0l+j8xg8NMqzYqtx6nLvAjHi6w0TF4jXV8K0HumufhyidTjX6Qpq4A4buQk8Ho2HdwW1836pD5rMU62PrFkAKrVl9zWN9g+K64uZe2CWhJOOQJyj7BltgYtNc4Pn3B22MeWZ9spMMcOwpvdCCbI3L+6ZiDcRQRnmQZ7GFgNbY5AntnB4tEK8Vjh13XUtVTWu0F42igFOQmAX4Ufmcx5f16+uVbnZqyGQrPacTrlIgSG4otllwN8ZeGZBMWfhRUbEQbFVnCLUOxV5aNK5TIW3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by DM4PR11MB5389.namprd11.prod.outlook.com (2603:10b6:5:394::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Sat, 22 Apr
 2023 02:59:41 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::ffa1:410b:20b3:6233]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::ffa1:410b:20b3:6233%6]) with mapi id 15.20.6298.045; Sat, 22 Apr 2023
 02:59:41 +0000
Date: Fri, 21 Apr 2023 19:59:37 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: "Joel C. Chang" <joelcchangg@gmail.com>, <nvdimm@lists.linux.dev>
Subject: RE: a more descriptive msg/running without root privileges
Message-ID: <64434d99956b7_1b6629439@dwillia2-xfh.jf.intel.com.notmuch>
References: <ZEJkI2i0GBmhtkI8@joel-gram-ubuntu>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZEJkI2i0GBmhtkI8@joel-gram-ubuntu>
X-ClientProxiedBy: BY3PR05CA0049.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::24) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|DM4PR11MB5389:EE_
X-MS-Office365-Filtering-Correlation-Id: b4136b61-468b-4d38-1c36-08db42dd9da7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pzi4Uh+l9UNHRqLxGX4bUrQrebLl6mkG+E6gsNifJF2K/cbvcIrNpvpoDTq+z/9Z8xIERqU6WUZiELHlzUqSffy7TlTBgTooYoNU8yLkz6zK7toJJaC5li7BlxEzHTdyocNIg2NQXwyfuDcJX8sPezl2ldAUq3Rmv801OWksTfuSV39iaEUgJwIPD2TfJ+Wbfq3Z9Kfi40xgOWYiNP0GMA5hcnxaB9eDcqI3WGmUwtUZBwBXp8FsUVONAOAN49uQ9QfCxE0QsHT/73srtqILVYxSovYavBgc7uqZKzxmeMHzaiphF/bvIxo+UHssu8GpeDlPxY8RKa71OyEOCmpgsxjK6Nfk9mhyZu4QS7DUUABijDhxlz9y9tcoCouuoxhSqkJ8OkGrlf5SnzUOB8brvb/HtYlkF01m0RuEP9WZqNfncPx9+b76Or1s/ZyZAo3UQ+0QIgC/9Fr8MfKJW5V8PFdwjtAoAHlIRIbwLGWdCUmq2igveoDKZ2Gaw2M4CQRfbd25fNnhHoGRG5JAhcDQCnUgnFEunjfDj6aCvk63FOM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(396003)(366004)(346002)(136003)(39860400002)(451199021)(82960400001)(316002)(66946007)(966005)(66556008)(83380400001)(6486002)(478600001)(38100700002)(8676002)(6666004)(8936002)(41300700001)(66476007)(4744005)(2906002)(5660300002)(6506007)(6512007)(9686003)(26005)(186003)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aMdx2KmDz4TK/U2zgm1ujSvYQ4QOlCwATvKKi6RPCf3bNe2042GRKGQ16kTo?=
 =?us-ascii?Q?0BrZW8LswSfuSCLa1wr2TEPFSBkTSNIplbFrn02j79vTTEh93OE8rcZS2/ai?=
 =?us-ascii?Q?4hhhqFQKI4A0tBcGRqHPgwDNOT/Sx7eisxeVnGEr9G+lUbzrRrn3EoHCbZhQ?=
 =?us-ascii?Q?0DJ1msOUY7e4Szkqj0UHtxed23H5JZPx6RLgByv7kvB1+8ro1O04Ik431c3J?=
 =?us-ascii?Q?FsgAkRf2S/3hiAqwQKvx7lBywbLEfUvsGXJ/P2LAoDrHaxOW9+C5hfpsmkuY?=
 =?us-ascii?Q?klBbCMwBeC/kfIn4V+dEh03nWGm4nM8Uz/RQCVhog+kfPN20vHP8lp26P9VK?=
 =?us-ascii?Q?JW8ADUTbzy+/bocMkabcTxuhKwWeUxnmiGQ/exZIW5WgccVZ6f+cNrLJ7ZXh?=
 =?us-ascii?Q?gTwO7WBMzoOH782JRU7riVNNnLL1PEAoa80l8lPJQB0/Ehk/CLMERdrgbjLn?=
 =?us-ascii?Q?8bAUSt5XmNTrK3AUpFf/LLFpt2zeFTsDZ2K83ptNxLdmRLRhmXq9xa2cE/ON?=
 =?us-ascii?Q?AMUGjc57HrM9FdN75PSjgymkH1aymbitjwQQRUwvmoj2l/RzpsdrWmjxZbQw?=
 =?us-ascii?Q?j3qBwNbEoQ4ewLPSVtkhy4EGBOZgb9GCeereemdqIflNn1RuXZUcjp3K6GxO?=
 =?us-ascii?Q?AyyIrAzXUMc3p90ICJ9Wapq8CO32bU4sPUv3QWFucATsr+7pWVgY1n3UuumV?=
 =?us-ascii?Q?3tbtSHtxHy7Z2RIU+oCFk/w3HlOurTdlWflJW69T/p4EqlD+RSg8MUajrMSO?=
 =?us-ascii?Q?yi1753G2NneYEQULobN9HxZ0frwHft+HhiqrFbbz/P3KOFvtn86jB+tbghOZ?=
 =?us-ascii?Q?rKQt2bYgVAhqee/mvmozjJoW5EumafhznnW2ktOboIwdRioMqCtaCG5m+0No?=
 =?us-ascii?Q?nOMbbVXBsWLjuk09K9pKdyc9Y3xaaDzP/jTRWhKxyFF0DBE6Id7GjIoLGF36?=
 =?us-ascii?Q?BZgEMjV72X7nuGJwGYnAYfoAZng0kJQJr74j34ZH3wmlCIU+tSd1sVgbFHf6?=
 =?us-ascii?Q?vfKIlNazdoqnw2vXFICVJYUx4lX2atWTjPLl2Xw6aqa7jHnQ8P87eXeyokfg?=
 =?us-ascii?Q?OmYpO5YSnmJBQs7yGvECSSHuzEvE27lntgb4Hd7gTbcHtACpdeO7kWRkqVL/?=
 =?us-ascii?Q?emKdmuQgXqd+3DrhZwhkRcwFd/slZE1D3ab0tWSsCCtHVMSgIwGn1V5ERsdA?=
 =?us-ascii?Q?3yCWdOozsqzd97nDdQJSouSjauVf4vEM55ljO3+1gY8YueoGy85snVTK4q1X?=
 =?us-ascii?Q?n0oW5dsj8a3OeR0Y5Yh07Jj9LKTrjQfH6R9Vy4AQpkKnYv40aK+0j9KMz7DB?=
 =?us-ascii?Q?YCIMDRuhYofC8IMMeWBwNUCS1eXyxlK1q3WzaWPiKy/7UdN3BTx9spMov7yQ?=
 =?us-ascii?Q?SLsqp0tEFqaKBJx8ysntCGnYn7Hbs5ZomIGsQCeXOxmuXTgqwM8W8QqiSGez?=
 =?us-ascii?Q?MCgBTUBfOoo0cNVoT7tcod3FiZMpe760wkhVNv0wvoICA3u5BacEdN7/RvjB?=
 =?us-ascii?Q?9fbzO9/jfdPl2YhTYV9GUS5dmKVlBPYI3yQUhQJUKpX4GDCFu8V5B3UKufE0?=
 =?us-ascii?Q?OLAFI0KEVZN4+5CawJ/7IpXojiCtOq+MXVVBQbvS2WbhdOK9AiQGPEQ3DAs/?=
 =?us-ascii?Q?IA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b4136b61-468b-4d38-1c36-08db42dd9da7
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2023 02:59:40.5015
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Czy+83NXq1ruf+EtweJUcG8UXvYIVlBw2ejPOXxc2UgfwEU2h/RljqjYlP41G1wTa3+bXj/iu6PkuBKmw28j1kCFQ3pqVbzxTeEL2IfHAmo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5389
X-OriginatorOrg: intel.com

Joel C. Chang wrote:
> When using daxctl, we don't get a hint/suggestion to use sudo/root.
> For example, running "daxctl reconfigure-device -m system-ram dax0.0"
> without sudo will only print the following:
> 
> libdaxctl: daxctl_dev_disable: dax0.0: failed to disable
> dax0.0: disable failed: Device or resource busy
> error reconfiguring devices: Device or resource busy
> reconfigured 0 devices
> 
> But running it as sudo is okay. The message is a little misleading,
> since the problem is not having root privileges, not the device being
> busy.
> 
> IMO a hint in the end would be a nice reminder.

Yup, makes sense to me. Opened:

https://github.com/pmem/ndctl/issues/237

...to track this.

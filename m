Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 897F96AC0
	for <nvdimm@lists.linux.dev>; Fri, 17 Mar 2023 15:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679066374; x=1710602374;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=bJ9t5ExyA/SDKR1EGopR6FT3T2LmJ7LPsS6L18K3JH4=;
  b=Q1volVf0hEsUFmBkUkIAeYSfn3J+IQpg7wYJ56aM9KoA/ACXaUefQ0T/
   dlKK+RCBmhpXOHs7glSHikEEPyGH06B1jhQKMpghvrM3E7TGE6KmT0Y/l
   /FTlmbhZdtG/rvlO6ecTF3UEsu3l7rzOJcZrhmwRkXym6HaxpnPBBauTR
   haCiWW/o5ItYZzz6ot9Wy4ATuhDIW3jb9WEneY4bwzGtVbgzkwSOTIonk
   TK5Jo6GCkRPc27TfYzIMW/tVTjHUigjRPHqoLZTKqxdRGo2i5SRYdW8L1
   r31b1s1E5Anod5lmDhtpCx4KKd4A8l6K8qS9j+pY5bSfp3F328jTyKU0X
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10652"; a="322129579"
X-IronPort-AV: E=Sophos;i="5.98,268,1673942400"; 
   d="scan'208";a="322129579"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2023 08:19:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10652"; a="630308669"
X-IronPort-AV: E=Sophos;i="5.98,268,1673942400"; 
   d="scan'208";a="630308669"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga003.jf.intel.com with ESMTP; 17 Mar 2023 08:19:26 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 17 Mar 2023 08:19:26 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 17 Mar 2023 08:19:26 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Fri, 17 Mar 2023 08:19:26 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.47) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Fri, 17 Mar 2023 08:19:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n7AR9GRZx5OPZdJqUaMwRKXBTy9MUnYoaz17Qg1ol1qUrqe+6b25DYO9V24ba8sho4uJu1acDGoTWKYqXKlMv/JKlpYJjgf5dewBh+e5WLTtnJBTDULit6RhlMIGrfNNeKTmzaXC8NNUCV6GsLpP23r8nMsCqOZAcURlZcw0y3SslMGV1dE1+nl+VvYt2cOmzTVXnIt1p4L/WUt95MSYvf8ISFAMKzuWuFtZvoSB8EUTJETVlfsIPJJ2O/PinzkM17H836CtUZgV6RiRzCYPdSSD7HlhItuuuMhQYFiUvyIj9hnkX7h/5fuIm3B7HNueup2OqXMOqC1kw7wvHJVwGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0XZWhkg1mhgpdopnrGbjRw4F6ay4/jXyo1HG+bsBbwg=;
 b=iDr7qg1VOYBsndfnc6qxxeSZQzD0NHio801nUcaSShLtl216wcl5X7HdP7OAeRt1LNnAt3ZBV/47xzhNUPMcu7lp0Oyz4/iXjtueXvWVCnwbqcb4d0GsKQYTc35amiq6QdNr+gCG8InPdku9z1h7/VKJQvjry9dHD3H8IzkP8ULHAcCL3G1VQtie2VWHQG9oChYuQlsvkDUJ7Mr8QcmPuoP4je7r9O/GpCM2JMop3i4Isp3iNEsAXdSehXzN2wtKHGBj+MwCaOQhSOweTA/9tYPpZnwBg1Xy1ENG8XywkIvh1nA57bvwDMV4i+hES13HhSijn2yxDKGBu7jj0gPu7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by PH8PR11MB6753.namprd11.prod.outlook.com (2603:10b6:510:1c8::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Fri, 17 Mar
 2023 15:19:22 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::ffa1:410b:20b3:6233]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::ffa1:410b:20b3:6233%5]) with mapi id 15.20.6178.035; Fri, 17 Mar 2023
 15:19:22 +0000
Date: Fri, 17 Mar 2023 08:19:20 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: "lizhijian@fujitsu.com" <lizhijian@fujitsu.com>, Dan Williams
	<dan.j.williams@intel.com>, "kexec@lists.infradead.org"
	<kexec@lists.infradead.org>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>, "linux-mm@kvack.org" <linux-mm@kvack.org>
CC: Baoquan He <bhe@redhat.com>, "vgoyal@redhat.com" <vgoyal@redhat.com>,
	"dyoung@redhat.com" <dyoung@redhat.com>, "vishal.l.verma@intel.com"
	<vishal.l.verma@intel.com>, "dave.jiang@intel.com" <dave.jiang@intel.com>,
	"horms@verge.net.au" <horms@verge.net.au>, "k-hagio-ab@nec.com"
	<k-hagio-ab@nec.com>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "Yasunori Gotou (Fujitsu)" <y-goto@fujitsu.com>,
	"yangx.jy@fujitsu.com" <yangx.jy@fujitsu.com>, "ruansy.fnst@fujitsu.com"
	<ruansy.fnst@fujitsu.com>
Subject: Re: [RFC][nvdimm][crash] pmem memmap dump support
Message-ID: <641484f7ef780_a52e2940@dwillia2-mobl3.amr.corp.intel.com.notmuch>
References: <3c752fc2-b6a0-2975-ffec-dba3edcf4155@fujitsu.com>
 <641404ea806dc_a52e2949@dwillia2-mobl3.amr.corp.intel.com.notmuch>
 <03bf236a-e832-ab81-2b2d-448aea37a2e4@fujitsu.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <03bf236a-e832-ab81-2b2d-448aea37a2e4@fujitsu.com>
X-ClientProxiedBy: SJ0PR13CA0055.namprd13.prod.outlook.com
 (2603:10b6:a03:2c2::30) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|PH8PR11MB6753:EE_
X-MS-Office365-Filtering-Correlation-Id: 7870f411-0543-41e2-e393-08db26fafc89
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sv15VnfJRl08QskLqn30YtF7bY7qY9BMHUDCGNpEf5lqR5MzgjRqD0gej1QGvFatrzMpl/tecQEb1l5/alQ3BsjnzZzg1pUezKZ/H+Cge+Yf7mFtzoitXGF/QZoQsRPSkgU+ZslIxU8JyNJn1QNScUv3+w+ILy1020A/XECpSttmBx7xPWK1EcvCDh7hyCSMzB25TVN3XsIHZKzntXVDRbVQ8OPAuGntACK7uTCzNM5bbw8UnVtYNc+fOvw3+L1GALmTIZiw+eMP65L/hA83SXpCIJbOW8Yn1WIYP7cr4bMdcBPVlTjYZDFwp5B+X9PvX7Zi6oZ8hFBS6Li8Do16J/Tmvy7R66SXzk0jKgB9r59k9CJdlAz1l3LChxdaPfX5uyd18z4W/CzwvrjfrdO3fDt+p5/Yc84KCpu4yUHEeEXl8z2ObrzwpvkMxa6dREwp07KNI8z9Kx9LXvgQgunbVhruca+VcZTV6az9pkmtCoNQWfHoTexwj6qtHYVEchBnwqjUvaNVSo3SlwodCsJGzPb/xAxItIxX/Sy+0Z/xcM+YlnNPve6l1YsPTFlRDefgeBcmdi2Co2NL4pJqSs49XRwyd1wathHtcLe0HtKvFFNsNCEHcbc0MdMaTizcTTKD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(366004)(396003)(346002)(376002)(39860400002)(451199018)(7416002)(5660300002)(83380400001)(53546011)(478600001)(66946007)(26005)(6512007)(966005)(186003)(6506007)(316002)(9686003)(6486002)(41300700001)(38100700002)(8936002)(86362001)(8676002)(66476007)(66556008)(54906003)(4326008)(110136005)(2906002)(82960400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7G6MXG9wOfa3stFOJFCZE9pGBAHBHrhop6QzHWY66AtO8lY9lrqeYbNBN+Xa?=
 =?us-ascii?Q?6UScG5wOLlL9xwKEv35yw0OrXJ0vKCte+NL8Ei4cOyl1COpfEs1xPBDw6czI?=
 =?us-ascii?Q?mvOzvdEtHgm0UnMyIjsZxfNfzaMy53rJiTCNUzs2FpfCDhcELgxMOVDF9Wc3?=
 =?us-ascii?Q?53mh3CVE0EEQYeFnp+KW3bn1HT6irvZZQcHe+SZriHzulHssfuEE77L8FsLa?=
 =?us-ascii?Q?cUxtLsR2EcJeJN17ns8AZdUamStXSXu8rk9B8Ko4zJLbAQSwWoMUlaQASVKU?=
 =?us-ascii?Q?cDN/QGKBqtrOTFiNzerCHqMEbSw3hyvuINuXbpH2aQ88RN9bf8WGvh2faATk?=
 =?us-ascii?Q?xnoYP0otUG1ZraIyP270ceK6XQYfYqy6Z6rboDekWMh9yY5zCvwf2WrLlFd0?=
 =?us-ascii?Q?5Ht7946Hnqsqwhcq/ziHx53TwZ6BD1RBC8J7LvNjRxzMDDX34u189XFYL/pM?=
 =?us-ascii?Q?YBOUtBE5yNuXnRQ7X4jdM9/fM/q1DWCBL17OTGOOJCPYgpF6BTwM5GmibZNY?=
 =?us-ascii?Q?JULaK9J+Qi2r1bYnhRIWerPwHTr8p2Yunq0kAS93GC6hSWBI/M//SGO3dk/J?=
 =?us-ascii?Q?CXoDzg0Xq3Ow7RXTJDNISHmUXt9kpjfcwRdkdznJhXOjSTRS8S1RTychDU0y?=
 =?us-ascii?Q?7cIYNeoQhIdCBateaw/dotWxnZLi9duGHpPgg5KlDxWiJM3hyFJqQ0rDIp2q?=
 =?us-ascii?Q?iX8v34/kdFjDcWXblaPzm1w4l8YhI5a4ogiePgmqJducOa/65JWzznBnJZVG?=
 =?us-ascii?Q?y6nL80Tld4qZEV8/wSyvwApW6tqRtHvDD3jOhpyv/6PP3Cp2KklDiy6PJ7IH?=
 =?us-ascii?Q?xcZIRYUm+L0uqnrb5i7Uu1LzCX0WlVSsRUaVHZnCy3c8+enJFqA3NbajK85c?=
 =?us-ascii?Q?u9lVfDqXS7FRlhDr3Q+aBwQe+nqAARK/5B82KH0xCSNeBbrc7eSkGnX+4MfV?=
 =?us-ascii?Q?wdeYg/kU93BxazbO4WQBCzuAQqz10SAu0Gdsu9lNHBu/VSuw1K7gqd+14wS1?=
 =?us-ascii?Q?J9evNndUI011PlfIWtqgVxfwGBDOAgcLOIYbFxT9hzDkGRV0X47PevlmYC6U?=
 =?us-ascii?Q?NxeXKfDUB0Atybq6c4fAFFLrqhcmbuhbuNW74e5A9eR0o9sxoBWfICkhpQ5l?=
 =?us-ascii?Q?87azHztGFsQrnOBvRdeUVfNPDKAkvMTytjVE93n63U2MQuc10gXz5zH7DYy+?=
 =?us-ascii?Q?Ivn+hcWMku6UZbX/YumeT9Ku3eV6UzR9StD/bR1QYjqELnkyDz7JBGDe22DH?=
 =?us-ascii?Q?egmKt/Z+sLjhEaWjh1U7S5GJY1x0pvIJSB4FHKWw5vzFW3jdBpoCbuwB8pOR?=
 =?us-ascii?Q?XxgNIgVCJ4DtICMtFlrs4Iz3hP5AoJuyJ0r6rWQqHNmt9KD8ZHNOL1XYC8fR?=
 =?us-ascii?Q?fSiQIY4+NxJirNdzhxI1vRIThM3ugUZXNv2CG9rNLUHUXiqMVIzH7dqJ+nbU?=
 =?us-ascii?Q?ayRw8voRJUojCYCHPi5j73nIcY9IpII4/lkr8t4B0nU5U3eXhB1fsbKLpthT?=
 =?us-ascii?Q?HzQ1psTA7VGO066Hzqkv4VbSirynhUUcSpcNHm6j0QO/8nz5XshXdgU0LrV4?=
 =?us-ascii?Q?6bTSCaXQ92K4PugWTGg5TDJD8GVf7c21+AyIDq5OiKnirNLWLgEORbj6JbQ4?=
 =?us-ascii?Q?Cg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7870f411-0543-41e2-e393-08db26fafc89
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2023 15:19:22.5663
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dZ/ZQMbUH4kJNscRmw7A03thcyCW8XjmobCZl/ih6/BnUAgC4l64Z6TltaVC3f42LDVAfLarKAtqLYJUzh2O3UebnXCRNU2AFE0pGZ10ylQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6753
X-OriginatorOrg: intel.com

lizhijian@fujitsu.com wrote:
> 
> 
> On 17/03/2023 14:12, Dan Williams wrote:
> > lizhijian@fujitsu.com wrote:
> > [..]
> >> Case D: unsupported && need your input To support this situation, the
> >> makedumpfile needs to know the location of metadata for each pmem
> >> namespace and the address and size of metadata in the pmem [start,
> >> end)
> > 
> > My first reaction is that you should copy what the ndctl utility does
> > when it needs to manipulate or interrogate the metadata space.
> > 
> > For example, see namespace_rw_infoblock():> 
> > https://github.com/pmem/ndctl/blob/main/ndctl/namespace.c#L2022
> > 
> > That facility uses the force_raw attribute
> > ("/sys/bus/nd/devices/namespaceX.Y/force_raw") to arrange for the
> > namespace to initalize without considering any pre-existing metdata
> > *and* without overwriting it. In that mode makedumpfile can walk the
> > namespaces and retrieve the metadata written by the previous kernel.
> 
> For the dumping application(makedumpfile or cp), it will/should reads
> /proc/vmcore to construct the dumpfile, So makedumpfile need to know
> the *address* and *size/end* of metadata in the view of 1st kernel
> address space.

Another option, instead of passing the metadata layout into the crash
kernel, is to just parse the infoblock and calculate teh boundaries of
userdata and metadata.

> I haven't known much about namespace_rw_infoblock() , so it is also an
> option if we can know such information from it.
> 
> My current WIP propose is to export a list linking all pmem namespaces
> to vmcore, with this, the kdump kernel don't need to rely on the pmem
> driver.

Seems like more work to avoid using the pmem driver as new information
passing infrastructure needs to be built vs reusing what is already
there.

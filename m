Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE1022D1F44;
	Tue,  2 Jun 2026 01:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780365096; cv=fail; b=CrheZH1EDh8RL7YZHXhsgLlaeCkNqTDhICGHx/5CYqBGDHXG0cDNuNdPmQdKaRJ/6Kmnjc7sOzNHSdMIfwDQtExxl2tRhygc15jnvR0dtWCH9YpLRqSc6H61917NDg5suhEgc+w6+GLEzKDVCZM8QrM6lC8D5Bc9JWMahpfs26s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780365096; c=relaxed/simple;
	bh=17zJk0cfF16Fa/AMlrjAIxs4t0FyUv2T6l4w8z6oZPY=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=MmA0U2Dd0Hkr3C4j7wNJZXMsmsQR3wXahGOvjcdqss70OkomoFJO9HGeR6pPbZF3nXD3fqqspoFaqXX61GEOSqnCnrZCff7wbkyF2louAubgG3GbKGF6Ghn+DiCv1LqT1J9pkRx5PyKYGkjwqGPo+q2N0S4auc45A3xXumLRDYg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MtHP8G0V; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MtHP8G0V"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780365095; x=1811901095;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=17zJk0cfF16Fa/AMlrjAIxs4t0FyUv2T6l4w8z6oZPY=;
  b=MtHP8G0VbcoMZBg1YSQd1In8PhkuetNpngtQ9LxfJ8lwVNYyrghiLUx7
   gW+D5Gv9Nx2qs+qTFLwk60oAC1xkWFDX2MCU+KQU6lNbu4NPPy5o2UdWj
   CzDUoYjZsIOqGfC8iJt5SiVFG1p4bsyvLRSMCRo+rI9+nQQxoej4je3iF
   OdLfp1lXFq73PHGU0cob2BoAWyVtsZ0qe6N8Aq7WIOOSx0oXg9Yb2Kc8J
   sMtI68BYgkZ9nI9dn27Ou9/6x3miJUWhYzeifodoPXzGHYdJxHKP7z4+d
   OMfScFZ9EAeWpOHC1O/XUiQcaAXQ8nDYQ/UZlf8ZKNcLsLuHzGseyO+0z
   Q==;
X-CSE-ConnectionGUID: dKxYTDf+ScOlJOwgvWg/NQ==
X-CSE-MsgGUID: 4ckWU9VOQi6QGgVTgMcnjw==
X-IronPort-AV: E=McAfee;i="6800,10657,11804"; a="91706587"
X-IronPort-AV: E=Sophos;i="6.24,182,1774335600"; 
   d="scan'208";a="91706587"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2026 18:51:34 -0700
X-CSE-ConnectionGUID: yadT/oDrRC+f6oz1AQMpLw==
X-CSE-MsgGUID: YlDO/ZIWRh2dlSU9vmVsyg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,182,1774335600"; 
   d="scan'208";a="242929130"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2026 18:51:34 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 1 Jun 2026 18:51:33 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 1 Jun 2026 18:51:33 -0700
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.5) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 1 Jun 2026 18:51:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T30YL7IsSXxjbhxJeFb1jbALjLOc98slBCkrK6GoPB25tpl7xPh3tzsr/FPejKjVJz8hG9r/s8bIuPnrvDaA02rM9JYnuAOwDiIee7O6v6hyx1rGVTFDBchIcotShPHPmz86aEHLgHtlsrod8UTzIHmhQClZEMstOkbe+fwje/IM3eLWjoSVVi49x2FU/SklxxpuSdg5Vo9iqeZAZF7w5Xwx5C7ikiLVXyVgKeFD36MY2UjwcVBS5WZXzm3IbfIOCOzTsCTLcO9aOKlJ46TnqC782C9k4lVju8/nSnytIzb0qBv4JUJ9NYuSdxWxZQs+OqegwIAWmUrYc5QDwEG5og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FRJjolLKzHYJ0EVzB1mLAYdC0c6tJM+MX7+WacxV3Zg=;
 b=JwKCxsIbbhmsb+rrX+CfI70eu1X+20Vkew6mu/r3CwkNykdmptg7rq+1I+42q6avfVFVZsiVRLGc4ciHPZ4rsFgXGKUdJIunOS19MwD3m3futNXofbCdJYOkXE1LpO+fBygwRlQ5mwjXoZBPujul24bAeQFVBb8UNEOGdCUWNKJi46L4Dey7oD6GRqyvCeOYFtrl2My9NtlbC6Rj5F995IFQVTMR77mBQeNoXOvp/bAQTcpxkPquPvCWLzB6FYBWBHzuomEfRokQwsMsWK/akIfbtuDhHRUtBC8IrVHHk2lXTA4B9wpCoxFyXU7H5j7Pqtzb/bxgvTL6Jo/hqddAxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by MW4PR11MB6690.namprd11.prod.outlook.com (2603:10b6:303:1e8::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.16; Tue, 2 Jun 2026
 01:51:30 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::a195:49d4:38c5:3891%4]) with mapi id 15.21.0071.010; Tue, 2 Jun 2026
 01:51:30 +0000
Date: Mon, 1 Jun 2026 18:51:26 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Li Chen <me@linux.beauty>
CC: Pankaj Gupta <pankaj.gupta.linux@gmail.com>, Dan Williams
	<dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, "Dave
 Jiang" <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	<virtualization@lists.linux.dev>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 0/5] nvdimm: virtio_pmem: fix request lifetime and
 converge broken queue failures
Message-ID: <ah43Hsur7KuTD-2c@aschofie-mobl2.lan>
References: <20260226025712.2236279-1-me@linux.beauty>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260226025712.2236279-1-me@linux.beauty>
X-ClientProxiedBy: SJ0PR03CA0027.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::32) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|MW4PR11MB6690:EE_
X-MS-Office365-Filtering-Correlation-Id: f07e0d08-439f-4b34-eabe-08dec049772e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|18002099003|3023799007|22082099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info: 6Av29WHvKy53VRzgIn39FJZjTX7trGTC6d0vO3xk7NfZpP7JQfZFB4EQWlQ+H0EW18zPUwh4xyk/YAKGzH8GLW7/NPyBUPIJJrylYBfPsvGeFLMHuJbssRDtdPMHihNqx0HUlENKBqbDhMqlwYQbUg641qN9MyNo0kjmHKjJvmotc7G0uhDO0uOdF3FaRdkzboerQVyYceltMz+7hJDsHjQJnuBtNCgCEUgHPUn/Pq7AtkAQEx51eVVXbrD7ncV2Y0LBycOkAnadbvi7l9SdlQpj+/WZ6liULMVEg9c5DpUB16eC0kekRtgs71wqHpPt8opo2b2K17btmDjdusJAgSGp/am2m0qG2ZUqC4c0JxNd6rKMqwyjJgc4eSK9Ym0Uxszcxs/J/9ooeuQcH5qjaj9MZY+BuTzM90RsTjkZh5BuM3NHs6fK6kudbscW+zwPd48VqdSLkfC7Hl+69692+bkoAk/dK/8VnJnxUO3N2qrbeldLqxFtOTRS3J5lIHyqQP5wHJv5tq0135v89K4UDIZqB9uN9Ick0992BnPxRMlRlf9jQyz7vjFkRYhjn9SY+KEsIAoG9Q/x3xJUxbpGX8UGwEeo3qKjAEGKdsK9OrG7cJZ1OrOXJ4b6iI7lk6ZFs21c9NzTpHrBBVcIfLdA2JyW/UPGpwvlE8KhsRL0+Opb42gztyY2ddX/hEURaZRV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(18002099003)(3023799007)(22082099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Y9WHIj4To2cykCZa5N4D+8RR/MbzLiTEfjYRSHzo0hSwi8RGy/AmxagXBDUK?=
 =?us-ascii?Q?hqCkiyNxEI3GDQsfx5s3CTYTiivBLfDKUhoDNZjMDIMaTcbi0AGMqFaz2xWP?=
 =?us-ascii?Q?nfXpFKUKLrFKkjUQJhEXI2ieRFw7NcbYRV48iZdwzi5VRlP58Oeo3ef9WBTn?=
 =?us-ascii?Q?8f7QKPRdAyPqP6wWGtR3ElovKB6uR5RuEIT0K56q1NdvZHy44U7L30sczlLW?=
 =?us-ascii?Q?ogfMlazSerVgnGKO26yODui1ZrlSAnUqBIa0dmI5QOWqwQpB6yHL7E1EdYi8?=
 =?us-ascii?Q?9Rfc+e7dSPop6H0CMI6ukdDOfoooqgyZ3b0W0E+UE1ebfE9Ltuf0enA+mihZ?=
 =?us-ascii?Q?bbYGEtIY2rmKXDQD62t0xtj5utLWOUBGIkFMvczBFgygXZIBx8wubObvgtbv?=
 =?us-ascii?Q?PQ1dKDTj85tfq68JOCrivG2KFjETmjBjs0cWKBb4H3IkSR+SA2p9DnI1s7ts?=
 =?us-ascii?Q?b8WwYtIIwY5g7sEiD+cLcWZEgODJbISYyE92wQlZjWl7oAPmw06iGc/p4eRX?=
 =?us-ascii?Q?gZ5PfUQcM57z59CUQINShQ0BxM9mUA1ljrTV+y29W+T+kovGYIG11K18vAc3?=
 =?us-ascii?Q?/SSys5HxTF+j5r0oamEU+Ouz9Dm2IlaSzRcL0b4WhQbrCf0Mi21nxjj7mcCe?=
 =?us-ascii?Q?ab70leO1qnO6CUPSFnuciElMwKVF/N8zC6LeVkC/F86d1PmPwEWe3ba7CqtG?=
 =?us-ascii?Q?EzkgHFy0yN/QYAP/1Lc8a4GmoQS53BULnSKRgTQlvELAKirshLx1ueGpUUVl?=
 =?us-ascii?Q?5xuq4+nEFq8o+02Pd5Uh6u2aDKdqcVlsToQk/02lJHXjpC50qEmTyd/txXGJ?=
 =?us-ascii?Q?tn8BbTWbafonqNQ9Ap+luVVoI7kATABKtrpfPnmakrpvvGvNCsXr5WzoBnml?=
 =?us-ascii?Q?8vIeQBILOUCeFJkC1yUqbzamcqzgrGmgemR/cE5q//hgYallZM1UYccSjRJX?=
 =?us-ascii?Q?cW86QRyMHmsTbkLPCBtC3QSzfCWwwVLiVSFoK7/6E4ZUXfti1zwEuWF4Lu1O?=
 =?us-ascii?Q?4j+0sqzJeYBHeKPHX7ctXmCqcaZYVoIxM5r80eRJe65gMjtMwmaHOG9jtoO8?=
 =?us-ascii?Q?fBXvZEVb8CdxQDddNAVo9wRDf4F2r5ITthKg2HjzzsYcDqMuwxawFEcdGBvC?=
 =?us-ascii?Q?ZW930yeaacEUsvHPq2JJdljwRWmvQVLiHO9zWCIhoIV/djEcircwZIFwsy+Q?=
 =?us-ascii?Q?TyPeIVom9rsGn1xXTEkKtge3UHKqeY8ccw3BhNFI8SX2HMdk+ULd2muWbnAb?=
 =?us-ascii?Q?yEiVanxp1EZ1WSF+1PCbnrqJJBTvFit2z4Sf1omjHmf0CyP/8oH/RC/jx/dg?=
 =?us-ascii?Q?UpU9bu4uu5OV9KuKy72EECp6QJhA79AdSo3HMyKda5HR/qJFZ6mfRTnHRfdZ?=
 =?us-ascii?Q?uzRcOSK+W4fneEybfd9EDvO6ujqDvD1ejVjb8411F/dq70OX4rc7/I/QIOKJ?=
 =?us-ascii?Q?glM4PmFGKT1oB9b5N2W5AfLQ71g8Gkt5jbbBjlLdNxOO15gRncTp/DL71wM2?=
 =?us-ascii?Q?rFW+gZ76AW80sOsFg480lexwrk6odRflPne/X4RlCa0YDOVB2P+ZYgUTt50F?=
 =?us-ascii?Q?z6JTLX4knm8jS8tRsvPyPTzWwfewk9JC/OxobcsHZ7EgyeVjQ75ofrkzg+sy?=
 =?us-ascii?Q?wPfVzd3Ui6kP3z5X+Af+nqw/Dle3Et0YdnNhJSLe0LTzYd1yWpkmroYpieOQ?=
 =?us-ascii?Q?c/YS3OhGKTKXeXYzBkSYLAltlK1gqZKetpCO4RMXTOs20hdlcsMrl3QX6JnH?=
 =?us-ascii?Q?3mIhsDBcbyFxzIWJWmJz/b2lW1U1tJw=3D?=
X-Exchange-RoutingPolicyChecked: QZpWSjzmO/tudFl9HG8QXuuJA+KrgmgU5cvmmC84hQwACQvZJyVa5+nlPSJo5HammwksnZhqSoA/4P249ATUfgyrVquTRDse0maU3+eO4D69qBwdEjMQ/Ke6w1Bdg+bOzGrBjJQKYiladNFvCgVZkaI2cCGNsmRMjWK+vBNHFHGv+nbL7+d/9Hy+vys9qz8XCSs8a2s/vSfe7e0UE2i3HzQZtvsGyp0Oe/F7dB+OfOsAHwFVbe9mXCR9q87e1kpVEIP/GUEV45infI/Hm1V/DPOzGfDE5bwjC6QroYpFQeVhcWfJhRVpeYB9N6jm6ZZgZQzVN0J+Mv4Tt5L1rRKhWw==
X-MS-Exchange-CrossTenant-Network-Message-Id: f07e0d08-439f-4b34-eabe-08dec049772e
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2026 01:51:30.2145
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4CJd/DtKOjXLl1vfRCueeApulXzqTgF6YbTgObnuXYeNjjkg8xLP37b/KYirn0sHQDZa1iAnNg0OvtAmWJBEjIru/cQe+AGb4IMR3HptDrU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6690
X-OriginatorOrg: intel.com

On Thu, Feb 26, 2026 at 10:57:05AM +0800, Li Chen wrote:
> Hi,
> 
> The virtio-pmem flush path uses a virtqueue cookie/token to carry a
> per-request context through completion. Under broken virtqueue / notify
> failure conditions, the submitter can return and free the request object
> while the host/backend may still complete the published request. The IRQ
> completion handler then dereferences freed memory when waking waiters,
> which is reported by KASAN as a slab-use-after-free and may manifest as
> lock corruption (e.g. "BUG: spinlock already unlocked") without KASAN.
> 
> In addition, the flush path has two wait sites: one for virtqueue
> descriptor availability (-ENOSPC from virtqueue_add_sgs()) and one for
> request completion. If the virtqueue becomes broken, forward progress is
> no longer guaranteed and these waiters may sleep indefinitely unless the
> driver converges the failure and wakes all wait sites.
> 
> This series addresses both issues:
> 
> 1/5 nvdimm: virtio_pmem: always wake -ENOSPC waiters
> Wake one -ENOSPC waiter for each reclaimed used buffer, decoupled from
> token completion.
> 
> 2/5 nvdimm: virtio_pmem: use READ_ONCE()/WRITE_ONCE() for wait flags
> Use READ_ONCE()/WRITE_ONCE() for the wait_event() flags (done and
> wq_buf_avail).
> 
> 3/5 nvdimm: virtio_pmem: refcount requests for token lifetime
> Refcount request objects so the token lifetime spans the window where it
> is reachable through the virtqueue until completion/drain drops the
> virtqueue reference.
> 
> 4/5 nvdimm: virtio_pmem: converge broken virtqueue to -EIO
> Track a device-level broken state to converge broken/notify failures to
> -EIO: wake all waiters and drain/detach outstanding requests to complete
> them with an error, and fail-fast new requests.
> 
> 5/5 nvdimm: virtio_pmem: drain requests in freeze
> Drain outstanding requests in freeze() before tearing down virtqueues so
> waiters do not sleep indefinitely.
> 
> Testing was done on QEMU x86_64 with a virtio-pmem device exported as
> /dev/pmem0, formatted with ext4 (-O fast_commit), mounted with DAX, and
> stressed with fsync-heavy workloads.
> 
> Thanks,
> Li Chen

Hi Li Chen,

Today I took a look at this set, noting that it's been sitting idle 
in our nvdimm backlog for a while. I'm not able to apply it. Can you
post a new rev that applies to 7.1-rc6 ?

Thanks,
Alison


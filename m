Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43675EC5
	for <nvdimm@lists.linux.dev>; Tue, 21 Jun 2022 22:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655851121; x=1687387121;
  h=date:from:to:subject:message-id:references:in-reply-to:
   mime-version;
  bh=jqDOZUxtAzXv5wAdI62GQiPM1Kf77AWli5gOzZ7u/VQ=;
  b=lm3TLp6yNvLQkVXRJwVAeTR3gnJ5tryHb+K3dXtDT07xZlaqRj4ASXKZ
   qyW46NptUMZ5zDVKjLmL2uHyi7FYzjK8brvRZZ+X6L7qgGP6X5VJeUZ3w
   QCujEI/UH3yn9NCENOOuOMoJEvqobytigDrg33719dmq9JsFrvX92WXvj
   waxw/frGzaYnGNHn8Pp8gwgXrvR/21r0j8iEyITxcmpdeBsWf++gxILfP
   CI5h4HOsssSty8XO/TejzmTbBJcrrLefMPA5CYk1CLhp65CKbr1xwsMzg
   /nwIJUbdLnMsBV0LobF/FeCVh18hLcoPbesIVly6MyBm35LEZtgynTZXe
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10385"; a="279025306"
X-IronPort-AV: E=Sophos;i="5.92,210,1650956400"; 
   d="scan'208";a="279025306"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2022 15:38:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,210,1650956400"; 
   d="scan'208";a="585462626"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga007.jf.intel.com with ESMTP; 21 Jun 2022 15:38:40 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 21 Jun 2022 15:38:39 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 21 Jun 2022 15:38:39 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Tue, 21 Jun 2022 15:38:39 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.174)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Tue, 21 Jun 2022 15:38:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ReqvX76IYl5VIP1witfISPo3099w6KlR33a4i+gDs710V31jklydIgPMpDDep+mVE0l3Rd5lJ6W/QFwzaV8Xmy0Vlf8qgf1kHmVznwXpQtmRL/PWsbz3S+2ZZXjEHlTKJCyl1YMtD3DwFIWggiILfwycqqsquLOunAword+4ZtxGY4uLNOqFNNe6XJ5EkQTEmsyjr3C87m1dIom7tZi8b/Ji8g7lxXCFVDVKpHLgIFlpmEdaGiAO+FKjOg0Fa7jJ2s/PsBdX0LcDQ5jrzdTzkCFHdFoxlnZOoXJwINCHT1H7/O2O+uQM7NjGw0q5n78k0Z2XAOnc6MtI40HMn5hbnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hUqXwD0df4T4viPK0NjS4qSJQHosfqb1jXG4VneGCgw=;
 b=YbTrlA3tUYu8g2LeheKVQeUC0p99I6ZQUgvMw+cSaWSSj5gx4W1wWn2/K9g1de+gMTTYIiZF2osqg6r4MtshqPrQRfZKDmxAerGJXCXktfRMBaQVhNS/e1V+z6VCAvaGR2GAULgZ7rsvCJ7X5SWKut+pzaWOgHKIQ1EdamcVv/LzXn5pauq9VwHUgkrpInuGpxfKKlysHU8mr6XXhMQJ7VWdxrRAlNViUt3BV6VNRaV+SQG3X8NXMt4wmT94JU6Oo5fsHYKzH9RGdmHRQVijYFpRhounqEtTzw5jqW+trDCm9ppBfTk6H/uhzE/gHtNbBqBnNRlxcjd3HetYabJejQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by BYAPR11MB2757.namprd11.prod.outlook.com
 (2603:10b6:a02:cb::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.17; Tue, 21 Jun
 2022 22:38:37 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::f50c:6e72:c8aa:8dbf]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::f50c:6e72:c8aa:8dbf%7]) with mapi id 15.20.5353.022; Tue, 21 Jun 2022
 22:38:37 +0000
Date: Tue, 21 Jun 2022 15:38:35 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Jason Wang <jasowang@redhat.com>, <dan.j.williams@intel.com>,
	<vishal.l.verma@intel.com>, <dave.jiang@intel.com>, <ira.weiny@intel.com>,
	<nvdimm@lists.linux.dev>, <mst@redhat.com>
Subject: RE: [PATCH 2/2] virtio_pmem: set device ready in probe()
Message-ID: <62b2486b8fafe_8920729455@dwillia2-xfh.notmuch>
References: <20220620081519.1494-1-jasowang@redhat.com>
 <20220620081519.1494-2-jasowang@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220620081519.1494-2-jasowang@redhat.com>
X-ClientProxiedBy: MW2PR2101CA0036.namprd21.prod.outlook.com
 (2603:10b6:302:1::49) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0028f3b0-c5c9-4e5f-f5b9-08da53d6c843
X-MS-TrafficTypeDiagnostic: BYAPR11MB2757:EE_
X-Microsoft-Antispam-PRVS: <BYAPR11MB27577B4802ED8B8D10925426C6B39@BYAPR11MB2757.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IPb2PnZTOyqEzQMzQ/cMYap2C379WnTOyQI9Lexk5tBTVXm4aLGurVuJUu4n3uEdRxjQ+C8D8SQ9nC4b9rtTgu13q+mQCZ1jbNHHf0UVZ/EKu4/c2hHkR6gmbax+OILBRc8jmHqOFs/rF4fAlePmyxU2c9eBGlpxdGSbyCKTDF7h4AvyQJoupSdsLBfft1bWGgaTTSYr93nFcdDPLklM3Zh5fmVMAzlkl34+p3J5wVTgwas/6ivkBoqPaMz6hpaeSPSsdM6ucqKdGdl5s5+XI8q7psFSsbVPzDZe4tjLXldleGiVal93T41JpSD73Q/nGNyE8Bz3iNxcvQfsGYVcpHW/MKmeqvg1MOQvG6RGbNuDOm65F9duf7gQsS5ZxuSptrFv6gvos8L5mQW6YSo2EYnX3Jlj6jLeek5tt9j5YjuYCTMSBpR5hydpD+sM4RVHR/h064L7uRntSQXjSLdd8k55b9bvObsuo9gyeg/zuJT2OJomfM20vmbf3C4cvMMbuvmRJJO+WMZezRILQmy7fjOyrUfMPrJEuC6fS10pX57kS59N/fGKgwZBjD0nW8xhhUXJopfJ9qjwv+Nss9x/+jgWozDgqo8Vzmk9+6UDCMSyMcym232xSNoZCbTTo/ppt7CvcChkxT8ruwVzri5ryg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(346002)(366004)(136003)(376002)(396003)(86362001)(8936002)(2906002)(478600001)(41300700001)(38100700002)(6512007)(9686003)(186003)(26005)(6506007)(5660300002)(8676002)(82960400001)(6486002)(83380400001)(66556008)(66476007)(316002)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?s0pVbzh9pDoEP7kU3TqfoSoEne05iQ3I9H69IDJCMFrOQAky1Qv04nVVAO5T?=
 =?us-ascii?Q?EqRpw0zNAI30LT/BJWWghBXWvLg3XZZFaF3P5DzT6iSFd5Qo0QUchXulfgLU?=
 =?us-ascii?Q?sNIXKcDEfpy0jOHEpnzrcUisRW1iqV6j2uMjaJpCC5fHApLfztH5oTuecNpA?=
 =?us-ascii?Q?zymN6lHEXBuHl6Wxoaby6cVcgUGdze9/5tivNvxkNRQ7N5Ub4bHsKOqhq4Db?=
 =?us-ascii?Q?smikX30zq6uT8Vy6KPEgn+/UWFFJiLFZmGNWhZiDJ8F5Fimk4SpLKREjqBsH?=
 =?us-ascii?Q?1wnryzYgHuvL4i2xZ/QByKzaGlT11M79vgslez09bQWYbgp7Oai9i8g58emJ?=
 =?us-ascii?Q?N2aiktsPmRGtBbaDmWAtPRvz1VkGtqMsDF4szhXoH1rJG2xD1zwyt42UKjOS?=
 =?us-ascii?Q?QMXwheLexdffh52j08HkebzPmv8z7ee4p5p/SIT0UssGc1rWku25ebJtAN02?=
 =?us-ascii?Q?j//DDOq0vZusJAfaUesnUy/vo5QRgkxBC0skpS5R8IBHjWAfZQxbITFE5GtE?=
 =?us-ascii?Q?jK0P7pRrE1OCxr4ooSxB82/nkE54ladUVSTrwcd3LA8HQpB4Qof4uMTpovYJ?=
 =?us-ascii?Q?ioznpgx0dgcnrPhvGxeR/yxPcnllQqMKrweJ+y1XJPpn7eLcLLFw6W5voWB5?=
 =?us-ascii?Q?xh22VPwfbEORQ9PV518LnzzT/pP0iDPrS8XQILSg7N8hqHYi49fwBH+++OJS?=
 =?us-ascii?Q?PNrwQJ3k98Pig7zXfaDNeo+DqedfBeN1Sc8C8xc+4oEus39R9ph8wXX/s5lj?=
 =?us-ascii?Q?f/i/HJSFUgaWWnBsuT1fG5DA/1D6NstyqC2HSDjkrnfPUJWb+cY1L5k1cr6R?=
 =?us-ascii?Q?iJt4lsXBfakM7cTMoJqJRSitf7G4FXaTPaE7ALbpTLu8BT/WNg5Ucnk8UUDT?=
 =?us-ascii?Q?R1Qn+ggrpx9BPzx1nRGUCR4xe+K4CiERnYOumV/XNqhfb+eqnSBraF42ZXWz?=
 =?us-ascii?Q?AdKgjDQPNWKHY/P1uk3QOGhz3LOwdKssW1Tg//4dAYCaeYu10dTiR5Kx6lpS?=
 =?us-ascii?Q?mH58VeIq6gs51dSkAjRMfk/rZjZ7ubjT19DoczNuX0qoBy+9+JvACCJgAr3B?=
 =?us-ascii?Q?iSWZRWffzM/eK6G42sfot7cArkibGLVfs6dp1w8gQXWMiNK6DIM4O+TmVgTs?=
 =?us-ascii?Q?Kkv0jZ9jk176wwTM4fJ+R/B4sMoGTNhnsF97aagRPS8TYrTbQPah/Srx2FsB?=
 =?us-ascii?Q?5PVGjvt5emfiZesN5hm3Ij54BRlC6oKfUNoC42VZQHKHgXDeTk38UJvOWSX7?=
 =?us-ascii?Q?hlwZCIgtorDpXXiT/GBBfYtKfRJvqMMr3fI6ViFRzRfMJVTVZVyGeDp92jSs?=
 =?us-ascii?Q?g39zB6bmpLeMycOCWr24zPVME1OR59xzudMB+BmxDGTzhWgnwUooauZDiteK?=
 =?us-ascii?Q?aCeYclDyBV5b4JBevYLF/NR05kVRqM7ESNxwUEtBKukelXmTf6u4SVuyEEYc?=
 =?us-ascii?Q?onxskcx6hCDDWgpZ0iJHYRh0WykgNWXpO5yEHIU00qPNAfYLHN1CWOQSOMlJ?=
 =?us-ascii?Q?5wWnoDK6a8jOSuYAwBPDA7Nye9fl3K2RytktGrDL/KoAgVkpVyOgKuaxMs2s?=
 =?us-ascii?Q?Ac8q1YshjDgxevXxgGCKyui8IUf5XptO6T1SMNQQrh6xcAZ3jEZTD8/gLWG2?=
 =?us-ascii?Q?yLbMwroVdWg/5AmTYfCv8xxGgchF+khfe74Z8deGJKn16T/Ib95HNIh6DHUw?=
 =?us-ascii?Q?CdU1cmkB7bnNganxTNThJQdG29bxSsipxocj+/wgFuCHnl9S6Q7FVlJJXPSm?=
 =?us-ascii?Q?seE38Sv+OomQsszXYtJ5nFjOfLUzOyk=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0028f3b0-c5c9-4e5f-f5b9-08da53d6c843
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2022 22:38:37.5756
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HDb+4nOdXsCe+YpKzTBlXY8qO9hAtwKITkk9UG7rNPEiAYL2BIqNW1szNIYTg4zj1W4QYW4oIICjL60DdHifc/dMJbb0nOk8WbFj2zw/TkM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2757
X-OriginatorOrg: intel.com

Jason Wang wrote:
> The NVDIMM region could be available before the virtio_device_ready()
> that is called by virtio_dev_probe(). This means the driver tries to
> use device before DRIVER_OK which violates the spec, fixing this by
> set device ready before the nvdimm_pmem_region_create().

Can you clarify the failure path. What race is virtio_device_ready()
losing?

> 
> Note that this means the virtio_pmem_host_ack() could be triggered
> before the creation of the nd region, this is safe since the
> virtio_pmem_host_ack() since pmem_lock has been initialized and we
> check if we've added any buffer before trying to proceed.

I got a little bit lost with the usage of "we" here. Can you clarify
which function / context is making which guarantee?

> 
> Fixes 6e84200c0a29 ("virtio-pmem: Add virtio pmem driver")
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>  drivers/nvdimm/virtio_pmem.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/drivers/nvdimm/virtio_pmem.c b/drivers/nvdimm/virtio_pmem.c
> index 48f8327d0431..173f2f5adaea 100644
> --- a/drivers/nvdimm/virtio_pmem.c
> +++ b/drivers/nvdimm/virtio_pmem.c
> @@ -84,6 +84,17 @@ static int virtio_pmem_probe(struct virtio_device *vdev)
>  	ndr_desc.provider_data = vdev;
>  	set_bit(ND_REGION_PAGEMAP, &ndr_desc.flags);
>  	set_bit(ND_REGION_ASYNC, &ndr_desc.flags);
> +	/*
> +	 * The NVDIMM region could be available before the
> +	 * virtio_device_ready() that is called by
> +	 * virtio_dev_probe(), so we set device ready here.
> +	 *
> +	 * The callback - virtio_pmem_host_ack() is safe to be called
> +	 * before the nvdimm_pmem_region_create() since the pmem_lock
> +	 * has been initialized and legality of a used buffer is
> +	 * validated before moving forward.

This comment feels like changelog material. Just document why
virtio_device_ready() must be called before device_add() of the
nd_region.

> +	 */
> +	virtio_device_ready(vdev);
>  	nd_region = nvdimm_pmem_region_create(vpmem->nvdimm_bus, &ndr_desc);
>  	if (!nd_region) {
>  		dev_err(&vdev->dev, "failed to create nvdimm region\n");
> @@ -92,6 +103,7 @@ static int virtio_pmem_probe(struct virtio_device *vdev)
>  	}
>  	return 0;
>  out_nd:
> +	virtio_reset_device(vdev);
>  	nvdimm_bus_unregister(vpmem->nvdimm_bus);
>  out_vq:
>  	vdev->config->del_vqs(vdev);
> -- 
> 2.25.1
> 

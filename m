Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70084ED3
	for <nvdimm@lists.linux.dev>; Tue, 20 Sep 2022 03:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663643287; x=1695179287;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=KlaZ/D9uFwKpfEnJwp/eHm0lbUEvqQfRF+/wfTn4VzU=;
  b=lHKlZgh6FCi7F35WATbtsUFsIfKCHxV8l641QcyvkuD6ijAA+wDvNKbW
   nnyefQFMKhY/YL/TQYwbMiyZXg6zxuFTD7GM9xHyKXdxWNYmItSjLoo7U
   15Y3mWv0e4s4KEJy6Yd83m/X3tn2ujvs21VQoa0IMDPgu7GIX5QqhPBJy
   +WXM52oxcOMKf3I3q/FKI/Qk0TY6Km1Dknjr8+d90Uxe9sCqiZl3TUlsw
   M4buDXIgrvByq8hM0U6j6iVzrKuXN74ZKO7er94ZbRiIfy7jNiTBaiN1D
   R2rWyVvPScOjh9q2TWOEAfbpqWn+kSrkNjCnm+jQG+sS1b+Bqz1+nC9ix
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10475"; a="297173775"
X-IronPort-AV: E=Sophos;i="5.93,329,1654585200"; 
   d="scan'208";a="297173775"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2022 20:08:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,329,1654585200"; 
   d="scan'208";a="681114831"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga008.fm.intel.com with ESMTP; 19 Sep 2022 20:08:06 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 19 Sep 2022 20:08:06 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 19 Sep 2022 20:08:06 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 19 Sep 2022 20:08:06 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 19 Sep 2022 20:08:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X6IyNtPIG/sAmvh2nRWYDxLdptdKqrjhgQFrXg/8sTq6N20+DbU6E7cGHRszZ24SI18/M56+sx64NVLdIcefNAMQbNwVjZUEAgQYAjgcjN0Xw6gOvXoKfYhNrJTnApHFB+iUn26AAcp/A4Mdc1I5IIA+/sMgrx0LMEouXNVfEtYMg2t/EtOLCHLDA4w8YsN3Chjprr1mq092MP/SkmzTIe4BIpjUQttaHwUPX6zz3mFd0YSlDP31npbOyfCkxIKuQSVG8J7EGR21jwwU2jsmy0rQa1XtB/j9O18yk2TX5BdAz2eVUQFHAvbBCu44thw7QAJG2qyoeMhOPDsCtQMFtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eCPAfjrHhVxqbuhnD8dsSbudmnhj1PiFLplw9BJlCXM=;
 b=j4mZF4SqfXc9x7eBrt9szzkGuF9LYv92+KV8/VT3CTfJs6dZm/CMhpw9wJq0ghG9vqyz/nDxLrKF1DiEmj9cBv+XlpLWjxqnX0I6AOjymS5fTO4/eDn+uiNe5aeKTgm3c4SHJreDO0WIg8zYQcPPcIPXwloRM8NOTWD4NybQwqyeer1hfgdUlpKoZoow+/31v3iX1P4ItJYO3blOo1PhTtsXxsbeQc2tlGaSo9T8O1FcVzQ4PVe4dpl7xBcQ2EVymqipBOV7o9UGgH0Xj5pNlb4gYCh9fKnrRtiX2dMgnT69O8RU2so2EHfKul8Lx6/njJo3wAZGrYLm18Q15BXYOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SN6PR11MB2640.namprd11.prod.outlook.com (2603:10b6:805:56::11)
 by SJ0PR11MB4862.namprd11.prod.outlook.com (2603:10b6:a03:2de::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.21; Tue, 20 Sep
 2022 03:08:03 +0000
Received: from SN6PR11MB2640.namprd11.prod.outlook.com
 ([fe80::c220:c91a:ae73:d776]) by SN6PR11MB2640.namprd11.prod.outlook.com
 ([fe80::c220:c91a:ae73:d776%3]) with mapi id 15.20.5632.021; Tue, 20 Sep 2022
 03:08:03 +0000
From: "Wu, Dennis" <dennis.wu@intel.com>
To: Christoph Hellwig <hch@infradead.org>, "Williams, Dan J"
	<dan.j.williams@intel.com>
CC: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, "Verma, Vishal L"
	<vishal.l.verma@intel.com>, "Jiang, Dave" <dave.jiang@intel.com>, "Weiny,
 Ira" <ira.weiny@intel.com>
Subject: RE: [PATCH] ACPI/NFIT: Add no_deepflush param to dynamic control
 flush operation
Thread-Topic: [PATCH] ACPI/NFIT: Add no_deepflush param to dynamic control
 flush operation
Thread-Index: AQHYi5KrPFn7SUrxj0OB8NZ75dE3ea1mgjiAgBUVgwCAC1PdgIBhOKsw
Date: Tue, 20 Sep 2022 03:08:03 +0000
Message-ID: <SN6PR11MB2640AC955668C96D5664F10BF84C9@SN6PR11MB2640.namprd11.prod.outlook.com>
References: <20220629083118.8737-1-dennis.wu@intel.com>
 <YrxvR6zDZymsQCQl@infradead.org>
 <62ce1f0a57b84_6070c294a@dwillia2-xfh.jf.intel.com.notmuch>
 <YtefnyIvY9OdrVU5@infradead.org>
In-Reply-To: <YtefnyIvY9OdrVU5@infradead.org>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.500.17
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR11MB2640:EE_|SJ0PR11MB4862:EE_
x-ms-office365-filtering-correlation-id: c1f92133-8ea7-4a7b-c114-08da9ab554f4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ou2G13JUrZBxaHKpUavAWtcKvU2mm9KsMSCrDXknfyTvka+IG6UFlU+J9GoUxDkj+20ViteEfEZWySsD+b4RkWO3quvZvIPCfXOpGPeqvItjxAwire6Mfx+IuLSKK/IN227TXZDWtHUsTp0NKIWTgEcR3YKqvRk4r+EsIHTo4friLPsnw9FwPvcBBcizefubWVBBNXAelPLAvUU5gxfnmpK5yT9ZO3yGurevgBHqH78H6qZfbpNP+eD+ixxmDJK0hih8eWcGHKFUa99jzNJ5xQxbSUYadU1Pdy3kWTvV7thbCC6vTZU4obRmGM6Gq7wp+zPX5NYftWQuXTWle0eYNEGvtsjcEWpIrTDVM+whDraXcnyTbWV+Rx+hsuEBA9Skc7GKCJFcme+25NAc2teDPA5ugZDvsTgxMh3Sew+KYrGqkQqsdqkKVPW5SM9C+zPvhiw1rnFJEZSNM95xmzvYkhqKPWDPONtRxhZo+aeI5pe2P/tnPQtcCxu8R2cXLjr2hQHDQIdSDi2q1z7cAa3s+QQMlLy4bPmJGloMUAe5dj3jcae63L7UV3CBVjAWgwm0v622vfw+ONUycxbP6kZAn9Dw2u/7AVk8DzMofUokYH6Z+GBH4SClFNc19sLf1rc1mbMxmhxw0zVlF+pK8W5Jtl4VVoQS0FsPEo1TLrAb64YiE631vZPHSRV9YNo8wVEqEh+2dgvM1llRDJKQcZxp22kKii+Wk7ooSLxbwqArsnxfFtO2aWkCZHKv+cY+vntpq+dHKdZvFWhwyByRQ3ypDA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2640.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(136003)(346002)(376002)(366004)(396003)(451199015)(55016003)(86362001)(33656002)(66556008)(110136005)(6636002)(54906003)(38070700005)(122000001)(316002)(38100700002)(107886003)(82960400001)(8676002)(6506007)(7696005)(53546011)(478600001)(71200400001)(9686003)(26005)(41300700001)(76116006)(66446008)(64756008)(4326008)(66946007)(8936002)(66476007)(52536014)(83380400001)(186003)(5660300002)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?MYc0UC4MZQNVtFJHwjF1B99gby7pPRdHPm2OMFczmxvJD9NKNoMeLwHF5hfF?=
 =?us-ascii?Q?dy9IylRYl85J+Ru72G2yplaV5+UrdBC1EbLSY+N0QP+3ZDh35qmMzmnA1CJl?=
 =?us-ascii?Q?b4oucq+CbX3vhGsX/QUeeQVuOof1CixuB/c8bL9nuZAc2c5752ft1uZ4Wkmp?=
 =?us-ascii?Q?n1hjEn8uD9mmEpbiuG8NSoZuBUmqd1q4gmKAvuvbWiOCi5+ycGADnArxFlBG?=
 =?us-ascii?Q?DhaOypIWYKVLPoua0yAk5zS5dPOOKGRad+9i4zx2B4SM4QawcmOXnWM994Hf?=
 =?us-ascii?Q?Z0kpwaBDLk1rJ/+CapeKqfOZ76ZaOfQ8llhGr+xI34vSH12hXgrdkWMJ42Oc?=
 =?us-ascii?Q?99takt1wtjHMVNHuIXNkGblTpHol8ZYMvdQpCvDPfgyMwNLP2Xv37q2fYY6q?=
 =?us-ascii?Q?J2GLvZ2ZoJnaSnWdODiDKY9vRpav1wnUf3c8qJF64iWFKU3SmSh7nBPsZXCb?=
 =?us-ascii?Q?m6iRj4hlgQNs0Sdl0C7timbswdrG7fIFWLYoDZs5J2uVeTZ/T0O4yY2VZKGW?=
 =?us-ascii?Q?7+7tOFBE1kiaVa8NojhhWH4XgGXSdkWFzmvvBxZzfDDUvjfiMaKezuk93Tmc?=
 =?us-ascii?Q?rchmwZm7ljwpy1csT5QX6aFQdJ2jIk/ruyy2Vthj1BTu7YSFPYKMtVdSgwJc?=
 =?us-ascii?Q?fmx3GuuB7QNhBNaCHx/vJzExNbi1sgyLuTTjU/cecG9eRvRwNCPIHbecNRGs?=
 =?us-ascii?Q?VwqGFtxZ9R9l6D1Tvqv5AmunZrLW+V3uNkR0sR68bpdYlUNKGOt8KfUWxOrw?=
 =?us-ascii?Q?B8YYsv5MiaKqLtr4SuB9st8875kGUQm5t6kNivQmAb53pKOKVlqmqxuAjnhX?=
 =?us-ascii?Q?l1002eJibPTCtPNDERvUMHe5Lb4LmIZhikIGuIVQ3YQ/zT7ezC1vy5w6Sag+?=
 =?us-ascii?Q?nifi0TDSvZTEbuPSiSbtjbIoUdSWWqvcwIhyBlDJ9+ibxDcRTOmKZQ8nFR8W?=
 =?us-ascii?Q?XKHGg9TV246aLMF5DkTY3WyHcj+9lho7jLjWBfu09SqbU63WAAdUTsSRgbRc?=
 =?us-ascii?Q?df1oYFMCqTywIEVYo0c9ef905fiKpvCx+6r5wcrNtpJ57JfUkTWImDV4goGR?=
 =?us-ascii?Q?3Wo09WLHs9po7c6I2XU8XgBbIx5IG7axNYCCa2bPRq7Hsxha1AQvH25MySa2?=
 =?us-ascii?Q?ZKxMgznhB2OWD7oQxZBeyy8O+Y9ksjMkuj0X5ES6J29n/lz2luwMRynVlKp3?=
 =?us-ascii?Q?5/yTucFsqhKgV5Tc3DbLqyAEC+mz3pxVFAq/a4findGwUzdAhZTnVOXMkDSp?=
 =?us-ascii?Q?2ZlLVgqdxmWoZMJqmZAOWm1H+hvCjE2JPMNVT/5HIZiGdvW9+9WvcwQUzEGk?=
 =?us-ascii?Q?5Ts89nYo2AWmAZh042QIFbxAaDx40PeZ398U5yqQtKwcn5LuziujUyXm04Xh?=
 =?us-ascii?Q?NMFg35W/5ZweV05p7LxBKIv3oRLRBU6j7P4wn1mi0y6acqNPpLLYAYkn1y5H?=
 =?us-ascii?Q?e3gvukoOJaX62tH8vJGl1f0URfjc9K8a1368tUUofaJ8OTo702NDETVDqHqT?=
 =?us-ascii?Q?86ODeUYmp4SyneFuJqt0lRdTnR0tptOp/IAfcFA0P8fYr4XfcOezkbxd7Syk?=
 =?us-ascii?Q?05igTz/D5WPmg7ZSdo/GNCEqhFsONsJg65Di7VmB?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2640.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1f92133-8ea7-4a7b-c114-08da9ab554f4
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Sep 2022 03:08:03.0962
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /on22b8M/xLBqCVQRYxaNs1rOGa/q7Jkus3SHlb8ZvoEF2bAOOTavoJPIjtXQGffVb/bXDSsoUxq2MKNKgSFfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4862
X-OriginatorOrg: intel.com

Hi, Dan,
Will we add this patch to some new kernel version?

Thank you a lot!
Dennis Wu

-----Original Message-----
From: Christoph Hellwig <hch@infradead.org>=20
Sent: Wednesday, July 20, 2022 2:25 PM
To: Williams, Dan J <dan.j.williams@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>; Wu, Dennis <dennis.wu@intel.com>=
; nvdimm@lists.linux.dev; Verma, Vishal L <vishal.l.verma@intel.com>; Jiang=
, Dave <dave.jiang@intel.com>; Weiny, Ira <ira.weiny@intel.com>
Subject: Re: [PATCH] ACPI/NFIT: Add no_deepflush param to dynamic control f=
lush operation

On Tue, Jul 12, 2022 at 06:25:30PM -0700, Dan Williams wrote:
> > This goes back to my question from years ago:  why do we ever do=20
> > this deep flush in the Linux nvdimm stack to start with?
>=20
> The rationale is to push the data to smaller failure domain. Similar=20
> to flushing disk write-caches.

Flushing disk caches is not about a smaller failure domain.  Flushing disk =
caches is about making data durable _at _all_.

> Otherwise, if you trust your memory power supplies like you trust your=20
> disks then just rely on them to take care of the data.

Well, it seems like all the benchmarketing schemes around pmem seem to trus=
t it.  Why would kernel block I/O be different from device dax, MAP_SYNC?

> Otherwise, by default the kernel should default to taking as much care=20
> as possible to push writes to the smallest failure domain possible.

In which case we need remve the device dax direct map and MAP_SYNC.
Reducing the failure domain is not what fsync or REQ_OP_FLUSH are about, th=
ey are about making changes durable.  How durable is up to your device impl=
ementation.  But if you trust it only a little you should not offer that ha=
lf way option to start with.

Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07AA117C4
	for <nvdimm@lists.linux.dev>; Thu, 20 Oct 2022 06:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666247034; x=1697783034;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=rMNf855zPaS4vusVmTG8ROr+XymkBf3YG6uefiTce4k=;
  b=nzNh2BDBL6FsmOuxl4SDerWpkwodykP7Dw4dDdkLv3d9FkkxnUbFOz0f
   E3798fhZv8L7KuOnBBSREqUoMdt3EmSXwvc7N1HJv/HhFX+Sg4WcBlJUA
   IhjHAZQZAao4dKgFFzfe63LbVKW8yOBgrPx2fNw4ZV9YgYeKVDBnSLLH0
   1CDzpNj0ykNYDENLLMcRflBCK3Cq3V5J1hsbq4YojFfqrYbqfZpOHKthR
   pvCW19GV/LFZSm3K6+siEKrX0C0zU6QzCqQ9979htxnCvMDYa3FrmX/7+
   hrRk5RUEhiRQIS6pDKl1mEarot+TKC1C69eqW7O/QXTHMVXzrKsVhV1kF
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10505"; a="286337076"
X-IronPort-AV: E=Sophos;i="5.95,198,1661842800"; 
   d="scan'208";a="286337076"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2022 23:23:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10505"; a="804680601"
X-IronPort-AV: E=Sophos;i="5.95,198,1661842800"; 
   d="scan'208";a="804680601"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga005.jf.intel.com with ESMTP; 19 Oct 2022 23:23:52 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 19 Oct 2022 23:23:52 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 19 Oct 2022 23:23:52 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 19 Oct 2022 23:23:52 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.172)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 19 Oct 2022 23:23:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kl/Uo1MPQMxrMYi8d9vBYF3iqxRMyZhcE18fscl0dAYNu5CsebMBgWjgCl5zQEAYZcEW2pak06v7d3FeeD9ARfC4BcrdXEjHnkkWNgCC0fFu2jB6xXZBuqRAnVV0ZelZvKmP/b8cIYmTpcxXF4AVo4G3fttwOJNXzsJLiEV+2l6JTpI3JU9acA8tNCY9lVnIIsHwG6NezDgJmKsHc7tVB2nu4niA1MbsPWiFVivSmGRa81GTRcPCoUqaK9LofEWezFVfsDwX2REhMjlQVqAAx0vEYIAHPJ6b3Aeac1rsh2rQ9TQsHBvsijG69262EkSVHeVmX+hhjp85uiVAhARzXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=45WOOVrVWc7PEPMjLogIeyTxWmBRAHxun7nMTtmKemg=;
 b=JX6Xh6ytjNpd4aaatxRBKx0aygm7tI/2tF5U3JUV5VI/FGSRuMyrpmxHyE9HzVyuwzK2dL0BhxkU8jvRMCoVVMBNAy7i4/mtngJC3g8o9Mll3t6KsaSQTxO4AhJ9PUTAmzTaJg/+CM7NbOOclifhFx4aI5ADrnurQrJMa3k7sK08G1Bn+FzbUe8SQWAww1vcNZ8EDG7cGfeyHIE40tliDqWIWPtEjYILWC9Zrwa8Vzqwk1YbmFCutPwUk489OmBtMVT4Dy7yBiHfa/E3nJznBK4F3Wh70qB8ZhxZU6xvEfVJe9t/4WLWKIdugBH5kSpltl9nzvzGwIAs3v03dAPF5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SN6PR11MB2640.namprd11.prod.outlook.com (2603:10b6:805:56::11)
 by MN0PR11MB6302.namprd11.prod.outlook.com (2603:10b6:208:3c2::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.33; Thu, 20 Oct
 2022 06:23:44 +0000
Received: from SN6PR11MB2640.namprd11.prod.outlook.com
 ([fe80::c220:c91a:ae73:d776]) by SN6PR11MB2640.namprd11.prod.outlook.com
 ([fe80::c220:c91a:ae73:d776%3]) with mapi id 15.20.5723.035; Thu, 20 Oct 2022
 06:23:44 +0000
From: "Wu, Dennis" <dennis.wu@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>, Christoph Hellwig
	<hch@infradead.org>
CC: Christoph Hellwig <hch@infradead.org>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>, "Verma, Vishal L" <vishal.l.verma@intel.com>,
	"Jiang, Dave" <dave.jiang@intel.com>, "Weiny, Ira" <ira.weiny@intel.com>
Subject: RE: [PATCH] ACPI/NFIT: Add no_deepflush param to dynamic control
 flush operation
Thread-Topic: [PATCH] ACPI/NFIT: Add no_deepflush param to dynamic control
 flush operation
Thread-Index: AQHYi5KrPFn7SUrxj0OB8NZ75dE3ea1mgjiAgBUVgwCAC1PdgIBiTEWAgC5EHEA=
Date: Thu, 20 Oct 2022 06:23:44 +0000
Message-ID: <SN6PR11MB2640DC5566F382F6B0E786F1F82A9@SN6PR11MB2640.namprd11.prod.outlook.com>
References: <20220629083118.8737-1-dennis.wu@intel.com>
 <YrxvR6zDZymsQCQl@infradead.org>
 <62ce1f0a57b84_6070c294a@dwillia2-xfh.jf.intel.com.notmuch>
 <YtefnyIvY9OdrVU5@infradead.org>
 <632a14f153dfd_2a6ded29444@dwillia2-xfh.jf.intel.com.notmuch>
In-Reply-To: <632a14f153dfd_2a6ded29444@dwillia2-xfh.jf.intel.com.notmuch>
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
x-ms-traffictypediagnostic: SN6PR11MB2640:EE_|MN0PR11MB6302:EE_
x-ms-office365-filtering-correlation-id: 86fdde30-d434-4054-7eb8-08dab263a3b0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: k5y+lFmgh84V/oYlwd2mZLoM4Avk46VDp0zNcZkVUF7GBp/gf9Fqe0SjjxAJe16E1L80AyU/5O04uEHZUkPU/LqPaFIPWEjvSXrQSYLQU063ng1Q+u/7J726J8f8mOC/uXC67bElSKU2EjmHygan6bz26fsrT7GQNE7c3+BoQVZFv7HCjBj8bHUg5gqKKWEN2W+l573j8gUrDFBY3y0AUVdR2tYW8TevxdD2N75T7YjID94GPuPjI6eCC6eqe/PO49/IUWm3KFDx15WdxELiRTNc4H7DzbSLGbeRNzeDIGK1goR3kgqJP4Wc0/ruHPKnJmnWt0Bt/I0IaGiGzt7uqZpHMZQgGpNnah93DqEJZsnUOk+crtOtnrzf09bRwSpSKLvFYBYlhDzDrpsD9RPROm7M/OT9Xeleu1J/C19S7CBi+g1xwktFofA8Ge2ZyOEDS0WPkFxaKCwHOlmA567/dpbGVNWX9RROw0dfbMhUfORANmaxfdJSjyy6oE5TAPyPDhOZCBi18BDU+R+hNKyZ9ZCN4hyRf/9iVHNA+9x/zp2GLQKKveWj37gTVJo3DyHLScmcNqzD1mJioEthwVmPIc6FA0ombsy+hd7XF0TFXxiXHd4KnBqVg20L4p4I4vQ+tTXOCLYwt5pm0QOKOf7eQKsjIxwPQ/MhWp3fsLhIaZvHsTiNRYTCqGLlEiAIqNt6evC7Ii0CAZFanlpHIjh7pVUHne9j6h5scEQP6EulyEj06iNFmIJGWnzz9+AkgDn7Z/d4a7HKWZ83LQL4i+Sb8Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2640.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(136003)(346002)(376002)(366004)(451199015)(186003)(6506007)(107886003)(26005)(83380400001)(7696005)(2906002)(53546011)(5660300002)(9686003)(55016003)(64756008)(110136005)(478600001)(316002)(71200400001)(8936002)(4326008)(66556008)(41300700001)(66946007)(66446008)(54906003)(76116006)(8676002)(52536014)(66476007)(86362001)(66899015)(33656002)(122000001)(38100700002)(82960400001)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?TIk93EEPPO32EyTaG41P4UyIvuzt4EycP1yDO/o/Tax8jUv6DRHRZzkpdEkG?=
 =?us-ascii?Q?qNTozKDMU8dli/rGp3yHeBkfImrnI8oaUKdGQaosUhnyCD1eG4eKscSXysh4?=
 =?us-ascii?Q?V+VT8hl8b4U9TpAnxdwnyHy/w/iUi2aWfrtAEa0cmdybSLFSHpHjpiIKTXO8?=
 =?us-ascii?Q?zvVPncwWfkzGtVHW2dDpyU5lw91GV3t0fj8Uu/1N3uIEE5L/cjvBDiwRN/Zb?=
 =?us-ascii?Q?v9DmEdRg1YhPAthW0bgHfaMwUvsTpHbGJ+jk1ci64cog4lTU2on/HBI+MzNe?=
 =?us-ascii?Q?slsLON/X4kLJ9JDvt/Q9fvgdLMShdDRSPIgLeWMKh5ojPHa1kKJEZwH9it0G?=
 =?us-ascii?Q?PXkbwyuLaSWgLJEV8LflXJcfsntnnFiyU3np7b/CSegQ7ErLkk40IveqzUQm?=
 =?us-ascii?Q?KXsLEsSiPrLWRzSVHQvFyMeoCu8atsUYX62P/LM6kJ4UHnyuYwcAK/Y63Qlg?=
 =?us-ascii?Q?SXkeHCRUYoM1nZmARIXRbb5G1VEkP7NGEQdZJpgdpqxu0gx+fNQ0Ku8kSiub?=
 =?us-ascii?Q?7C++WnJqo8PJCW/v3fFU9zzLoyykXGMQYwTLOUx2wYVDk5NTiAK/hyxvthAp?=
 =?us-ascii?Q?JnVzBmmuy0Avaadd1eSITlyT2y12Vj+3FBbpgX2NfFvq5JY9MGGvibbMQAma?=
 =?us-ascii?Q?sqstGXjikqN5Mv9cUAadJhAmOAtyit/1hos6up4gNCsxGLHaTn/qCMgVvNrF?=
 =?us-ascii?Q?xj/Tm5mgmYsaavYDnnYhTWnl3CTELY0UaPaxp6sd9nS2pewP054TZerE8dx6?=
 =?us-ascii?Q?9dnkjvfOrlFd2PGZrfJBrhMvT9Fndt774hfTwpqlZnlmYU13FLHkQHKhqHrD?=
 =?us-ascii?Q?NWl/mHPIdKc8Fw8/PP9NxXO6pYt1pexOfoXmZbQaebLOkT9XuhlyIrgpbAU/?=
 =?us-ascii?Q?Rbx6zgbw0q1hybG8y+h33EPnaAHujjPeYQTwfiAVIqK5lslfwtaBO1rQoMLr?=
 =?us-ascii?Q?93CyHDBREnBpv8mOHpm+GKjHmKRSXZIfqq8KpbXyUu7oez6DdewI7lYA39cr?=
 =?us-ascii?Q?taoYrKLv1axFv5XLDK8BCj+NS/JMrgG+XVRJtR7mpu4FnFTHVtAyv+O2OFSK?=
 =?us-ascii?Q?zOFPKEo2ecyD2vZYg75CwbxNYEMumzLTQh+mnvmGK+atTzKJSFT/J3/dDp6b?=
 =?us-ascii?Q?7ugMDMMxROBG1/G1ss8ktGmbwQu5BRf1gdnAYKwvdwWssIodgEhzwfXn5b2p?=
 =?us-ascii?Q?+Zu8G1cliwu6wMr1rWyer1fR3trg+r/IRJrwGok7hkzPPAYQT+yyuR+kOTaH?=
 =?us-ascii?Q?vgY+iGyNyhxV6iF1jtkFZl17smVIGutPFPe48HdL2KzTQCsnRX/Ko5FrfmzC?=
 =?us-ascii?Q?n86U7zgR5ZUvdy0Mg7olVAMJcm3id/GiJ4ema4SpmGnzM7KzDg+pb/e2/zP1?=
 =?us-ascii?Q?hSY617tOrltghDUWz/ds49tXZzfLiUhmBngIIFCDtgQy59g7nu3XxBR0SMQR?=
 =?us-ascii?Q?wUsL36W64HB91HLxpXcWg5u3ZgWx9tUrLL+jqEqu3EULdGSIantNW0QxAMEr?=
 =?us-ascii?Q?OdeBKkehXDS+IPF8G6pgZC0/TDeTGdJVQZjtORjCmt66M0yE6f9IhtmfgV3c?=
 =?us-ascii?Q?qXu7lwXqq3rbADuHNONdIWw+/88Qq91a/IfuO5iw?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 86fdde30-d434-4054-7eb8-08dab263a3b0
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Oct 2022 06:23:44.3793
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AAcDQVjNdCEVwjqohwlF9eQnapgJB6WH+QNNAT+PpY588+hnpvS7c8DgnRnz+0saUfyzaoGUuT5jtecqxOJ+RA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6302
X-OriginatorOrg: intel.com

Hi Dan,

ADR is the platform capability which is default support in the Intel platfo=
rm. (eADR is the extend capability to keep the cache as the persistent doma=
in, not well support from the PRC customers)

So far, the customer use PMem would not consider the deep flush since 100% =
data security will not only leverage the single server, it will leverage th=
e software (CRC, checksum) and distributed system.=20
Deep flush is the smallest persistent domain and can assure that data persi=
stent in any situation that might be useful for some Financial scenarios (d=
idn't see in the PRC market so far).
That's why options can be used for user to pick the data security level.=20

GPF, as my understanding, still leverage the ADR from the original design a=
nd still the capability of the platform and have the chance to be failure.=
=20

Thanks a lot and best regards,
Dennis Wu=20

-----Original Message-----
From: Williams, Dan J <dan.j.williams@intel.com>=20
Sent: Wednesday, September 21, 2022 3:31 AM
To: Christoph Hellwig <hch@infradead.org>; Williams, Dan J <dan.j.williams@=
intel.com>
Cc: Christoph Hellwig <hch@infradead.org>; Wu, Dennis <dennis.wu@intel.com>=
; nvdimm@lists.linux.dev; Verma, Vishal L <vishal.l.verma@intel.com>; Jiang=
, Dave <dave.jiang@intel.com>; Weiny, Ira <ira.weiny@intel.com>
Subject: Re: [PATCH] ACPI/NFIT: Add no_deepflush param to dynamic control f=
lush operation

Christoph Hellwig wrote:
[..]
> > Otherwise, by default the kernel should default to taking as much=20
> > care as possible to push writes to the smallest failure domain possible=
.
>=20
> In which case we need remve the device dax direct map and MAP_SYNC.
> Reducing the failure domain is not what fsync or REQ_OP_FLUSH are=20
> about, they are about making changes durable.  How durable is up to=20
> your device implementation.  But if you trust it only a little you=20
> should not offer that half way option to start with.

That's a good point, but (with my Linux kernel developer hat on) I would fl=
ip it around and make this the platform vendor's problem. If the platform v=
endor has validated ADR* and that platform power supplies maintain stable p=
ower in a powerloss scenario, then 'deepflush' is a complete nop, why publi=
sh a flush mechanism?

In other words, unless the platform vendor has no confidence in the standar=
d durability model (persistence / durability at global visibility outside t=
he CPU cache) it should skip publishing these flush hints in the ACPI NFIT =
table.

The recourse for an end user whose vendor has published this mechanism in e=
rror is to talk to their BIOS vendor to turn off the flush capability, or u=
se the ACPI table override mechanism to edit out the flush capability.

I will also note that CXL has done away with this software flush concept an=
d defines a standard Global Persistence Flush mechanism in the protocol tha=
t fires at impending power-loss events.

* ADR: Asynchronous DRAM refresh, a platform signal to flush write
  buffers in the device upon detection of power-loss.

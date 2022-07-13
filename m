Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5C1F2FB3
	for <nvdimm@lists.linux.dev>; Wed, 13 Jul 2022 18:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657738331; x=1689274331;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=WrqdCA56F9P+MiiSDf7KC8IRKtlpMv0C5PZWaK/Z86A=;
  b=axDaCPXNj4o9X2JJwitw606wDvb+b0fIEsg8qJAg+vDmU4WJYlVje7bg
   p81fH980OzTgtORU2W00K2Wu78KSXA8VeZAtmmvoq8Q2BJFqZ13x/7pqt
   wEDKTUlD9vsseGUKMxv+s/qtC5guRkUGfx7X0FZkJFlmXdl+2JSZADw1Z
   tRFoAkYp8RyV3hzRrzb//DiUrfrUyq6R2KHsDd1SEd1MA5VD0ypKf7bdw
   iDNTFrUC1jd5I4mOPeF4acqs0CWkFH06lXJJCuASLQkFN+ruLoz30UsrE
   dVSHORr4YCpUmyqbCWhTlzEbOjk2vswUHv2gimfsbpLROi7/GSewwldtW
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10407"; a="268350024"
X-IronPort-AV: E=Sophos;i="5.92,267,1650956400"; 
   d="scan'208";a="268350024"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2022 11:52:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,267,1650956400"; 
   d="scan'208";a="841872347"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga006.fm.intel.com with ESMTP; 13 Jul 2022 11:52:10 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 13 Jul 2022 11:52:10 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 13 Jul 2022 11:52:09 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Wed, 13 Jul 2022 11:52:09 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.170)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Wed, 13 Jul 2022 11:52:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hf9kUjHIyHfTfGbV7VpJ69kzVpjLd6t48H8vLIWLUyr9c+QWQz/0p3woMLfU8avpOUfnk+x2Wm0ieW9iMEsdEOnIyz+TMCfVPSym9RZz601A4MsnuPKqLklRz6ctKDRAxLPbjZgEoBQKCrPZZgesPl5JyvD+cKdx2bIZUnOtU9gCmypWK7QBNYV57nJvvsDYro3LQI95FPtD5Hl0Vi4zWKqQTo08eBPDpr+TBwEXo5f5TTctUDG71OG2PDe9vXoF8FPJt8vT4dCL2f1dGGsaSKPnjJQae0cTCHV+wH85Q9cGBTu59I4EXMNw7Hcb0qB4iH2/L7ZkZrmkf+tHQSaMBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6v8+Y1rTnZunNtASVvm/IyVlqxFUiKYrHGmqs/rdM3M=;
 b=jb2nMDSHpvbkCpb9gowpXILzGtCRmGbYbzhJISs5kiDZHKy+txwaIhP7DS3DQswISYZBCm0RxORzsWSdo7uCh/VZuePRlAleAHpk46O/e205KxDlf69gsjlho1uJb1XL8t7eBaPGs/5LSqP0RzaXJ9pOM5IbAx4l/Y6kQUVo7DYHFNQetX9V8Yk2xVWpKJBhPmIAoCKGcLcpq918YJX42lousxwi5KbS584LAkZveTOr0xlQC78CepiAN5vg1MwPJ++4dxdab1+NogLDujY2+fx2/zZtfB5T/3jqW881sCT0KtFIDOZf4F8JCuO4D/iiA/NVlAxtCMYvtGYfkZxeEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by BYAPR11MB2807.namprd11.prod.outlook.com
 (2603:10b6:a02:c3::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.25; Wed, 13 Jul
 2022 18:52:07 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::6466:20a6:57b4:1edf]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::6466:20a6:57b4:1edf%11]) with mapi id 15.20.5417.026; Wed, 13 Jul
 2022 18:52:07 +0000
Date: Wed, 13 Jul 2022 11:52:04 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Vishal Verma <vishal.l.verma@intel.com>, <linux-cxl@vger.kernel.org>
CC: <nvdimm@lists.linux.dev>, Dan Williams <dan.j.williams@intel.com>, "Vishal
 Verma" <vishal.l.verma@intel.com>
Subject: RE: [ndctl PATCH] cxl/test: add a test to {read,write,zero}-labels
Message-ID: <62cf14544f000_1643dc29414@dwillia2-xfh.jf.intel.com.notmuch>
References: <20220713075157.411479-1-vishal.l.verma@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220713075157.411479-1-vishal.l.verma@intel.com>
X-ClientProxiedBy: BYAPR02CA0024.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::37) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2e2feba8-1e6b-42ad-6e72-08da6500c8c5
X-MS-TrafficTypeDiagnostic: BYAPR11MB2807:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VS67fXx8jWBosDth8T3TTKlbZ3nF0zSK3dhy1Nb3EoZ/M0ZCSMfscQeI4ItyMfEJ2fSiAXke4qyugsck74VznoTOAEs5O+WOuqSuTEim7YmXoRq0peWyZCtJ1xn58iHYzwlUA/V/sZnyGU0QpG334jO/Bwjel5tEf/BKdQ6I1q5BEUtly7Jl8CsV08EkQza1izpe78pdQkXB/cjJYYIufOT5VXxzEwplzp+nQclWZ0et1RkCclk28IZgFfip/nBNvu/K2LHdyydhWtDm24IgBkQk5BXDhJ6U5E+JeSOQLwdj4Pj4V6jiEVckFc48A2IqXFhYyqicVVAg/C5UQi0aGxYSrd8LOTsCC3+BwHBHQTF2AIK/Gja/HCXYEDQC8df/nFJuz/SacWtbDK6hlEHZDFiZJXvL5lc1h+wQm54lBhTm1cskaKFB0tF2Rdd445seSikcpyJ4paSF2BT7c60vKr2M3YLRIFYhISY8AaW4K4YZnp+KT0B1czm+R2fnKBfjguPnCHPB24WxfeaTBW/fFX87oIuQQsfndIAnrLPTnp21x8QiswsWBQDTQ6mLyze5q9h+k4515GZSpacBBiLJ+SxT7W0ok/0FQh/FHQPFeFSO9EAcWldkwDb/Kk1PS24AvPmvLahAbEcL8Nua7kcG2kRvLe91Qy1ocguwMQhkLZAfQa3dUG5F24hcCCyr2/1CvoXdQPWSAAL4r0Vwf37OhSXgZAdUJUd8tRcq4FYV3AQi7fc2k5RCjo6DwDms2FeVyHzilJnV2z64f1Mj4WT9UQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(39860400002)(396003)(346002)(136003)(376002)(54906003)(2906002)(107886003)(38100700002)(316002)(478600001)(5660300002)(82960400001)(186003)(4744005)(6486002)(86362001)(9686003)(41300700001)(6666004)(6512007)(66946007)(8676002)(66476007)(26005)(66556008)(6506007)(8936002)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nGudCxBEmoxcxrL2GCShaA9NAwvi+NXIygJX4mdHt+a3vhO/1GlFYcbNdAAV?=
 =?us-ascii?Q?zydWShD2mNw9yoGAWed2au+19baaZjIteoEUk/EjnCfEi7zW2pcRGEtK1Ogg?=
 =?us-ascii?Q?iyxo0r0F+AJzFAXOpq/Dh5fqWN28sYInan13fbd6ewev73k+ueeRGPQNpzKZ?=
 =?us-ascii?Q?oYGPGIIcOhUnkCvKO6Jh4BcFK7sQSpPnp75bRvjX+3u/GW6+rh4wRH+o1joZ?=
 =?us-ascii?Q?zq293lMPZlcdj3auOS7qsLGGAHPgRutgFMnvwzaZkjQUNJ3yG/wLz4psPBw7?=
 =?us-ascii?Q?KIKP5kJcJpT9X52/f1FSyHmOoK5dnkuhdvrAoRksKrQwZSD+/N8tI9x0bXOD?=
 =?us-ascii?Q?MczqCBsi8LQmEopN+Xh1jndi2wHMmhbvy4KByu9g7lhSCl2fDAFT/v64zhys?=
 =?us-ascii?Q?5Dvpr2ibwBOoOiPNrRYL+uicshapHTuoaeKvJ4fy8NXbUY+4tlM3bKWvbBA7?=
 =?us-ascii?Q?XTibysnSELXrwIJrBOsIvqbrJxKndMIe5b7xmwYDl1Soj7E+bUlD4MZVRb+E?=
 =?us-ascii?Q?I5CFQ9iRoGlna4otrx0oWEJc81QH2n/D2GX4VqtDmgaZHMk1bU1yFN3qU/Xl?=
 =?us-ascii?Q?69SEHkqdiX2sgxdMZZ8Zm4kWQJ5qZT9uaGMW6/8NheZyawGeN7a6kO3uUFXS?=
 =?us-ascii?Q?+2I8pjH7z2d92ukwlwPjDBji4vvFsgIDs0ioQ/r29J9b5XFbfAOd3j19OCv7?=
 =?us-ascii?Q?RWJQ7eZs7svZeWPh+6Z35qMr57WKSNt2HCuag2Sk/e/nVizX/WkrPEHC12DL?=
 =?us-ascii?Q?iKcOChV6hnjnp/Gv61dD0+ZJw4RBOwe/dzerCXQEkE78p9boPFNlpOUaPmzp?=
 =?us-ascii?Q?ElmpFohdeuPsoNSyR9PjqpPV734sz4kYsUavDhWYrvqr3HVFEXI731b3m5qk?=
 =?us-ascii?Q?LBFYE5T4dEIPCYGTa6gep0NS08LEmmhzg5Esfa7NWzTQnz1okYeuKwqjX3RB?=
 =?us-ascii?Q?QDjT30jb6Eo6B4YviHe8ZFuMC8PR3zDIdTvcJzWIEAOZzXUPEfjJyu7Trl+8?=
 =?us-ascii?Q?wz03LKrxcDV3+/i3BcaK7vRLBEvsthBZfk8bvNDRj7NE4/Z3IvP55r0jwXfq?=
 =?us-ascii?Q?OJte1hV86C7vjT/2N3iN6iqvuAVcjc69kua1wMJVeXiP6ue5s3dDuC5PYqT7?=
 =?us-ascii?Q?GtC085gVPSGo2ErS6GK3Womt5LkOTht9+e3Orn15JbpgmDb13eyKfAPayMUK?=
 =?us-ascii?Q?MxgrFxjg8DeF6elhgfD6917rf8mHoscAUhDNhOKvrXiy4xoGL0udwQLCLOKO?=
 =?us-ascii?Q?tVZovpeKfjQlAEv9lhJ1KuJmFcy85mPrkO1QBh6M4m2SLl37cXAYf4YdlARA?=
 =?us-ascii?Q?ErU8hlU8ItFfRsLZ3zNCoZ27Vdu1n4/ep7WozdE8jfstkMpZXAyGluSg+511?=
 =?us-ascii?Q?OhEGpN9nvbLO+oFVhuax3R/nMls0l1LuDKjHzlnM4zpHj1TkX3p7Y9kS72dp?=
 =?us-ascii?Q?kT1tnbpToxhOXInFr6DTHyeB2AGzkFPL8ZpDE/RtNxzb6XfM5k9dZrmOqsIN?=
 =?us-ascii?Q?kY9s23SS4PxqXSbbMsFqZuyBdO28KyKI3zpqO5GhJHbaP5IPsudHFLcGkkQJ?=
 =?us-ascii?Q?Q/635u1o4qjFnBlw/bLRrCgYx787e1/baxaVv0Jl20Tt6/a3B/HqrXZXjhFL?=
 =?us-ascii?Q?dA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e2feba8-1e6b-42ad-6e72-08da6500c8c5
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2022 18:52:07.0696
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gfBsKjJOm5QKPwt4pujEd82fLwp4TmZDDEjB0bq5FuToQRSU4IkLTjfEVAoTGI0XUD6JaiExMLeIwKwogJFmPVJMUiem+22TEVn9i2k6UUk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2807
X-OriginatorOrg: intel.com

Vishal Verma wrote:
> Add a unit test to test writing, reading, and zeroing LSA aread for
> cxl_test based memdevs using ndctl commands.
> 
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

Looks good to me:

Reviewed-by: Dan Williams <dan.j.williams@intel.com>

Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 823A033D9
	for <nvdimm@lists.linux.dev>; Tue, 23 Aug 2022 17:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661275632; x=1692811632;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=k2Iyl1xLgllvv70V8cYmw+oB8loTFttb12ot65LMzZw=;
  b=W/Md7TF6bFafoclH9erNtCDzcryl8rCqP/1+RkDbSg5SPqd17r2bRYwX
   EymBxNqhFRULVrSjCAzYAOsrF8SEZfOupntEJFtQ2ol9+v60uoO6bP7i9
   u0ZDDnLsK8diIron5j1kaGeyyzvFD+KB5xgoM/BeGhQJ8cN9XsTi3znxL
   Go60ilDHFGJwNeADIcGEAbjR+52N1xuHKAhzov7d/kdoM8Xnn3w2xPAy5
   fJ1k0lOsxsXAuW/H974UhUsyzuSuX1zv+3IT5O1ImbNVizLbvT3LW/qWW
   usxEBekIEykZfP4MqIPZ8/bZTcjI1V8CebrbAZqvGDPlKrnPz8ErDGZAL
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10448"; a="380042370"
X-IronPort-AV: E=Sophos;i="5.93,258,1654585200"; 
   d="scan'208";a="380042370"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2022 10:27:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,258,1654585200"; 
   d="scan'208";a="612486431"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga007.fm.intel.com with ESMTP; 23 Aug 2022 10:27:11 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 23 Aug 2022 10:27:11 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 23 Aug 2022 10:27:11 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.170)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 23 Aug 2022 10:27:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oK53720vU1+K3AN5Hs37bEGMi+xLKxFNq2adbMbZQD5yX2u0fz8k66IQU3ZPoQ4u6UNATK1yS8voY7noNWEhdimVNrb7B5ad7ie5tqTiamSzwbEJwmb1rGis4vIO0xKrll6zHjzb7W8Le0p4Vj/zzR++EmSKoH8a3dPXvleeKDSRYccSwR3qw8obhkp69jl1U6QgeEFw/BIxqdBzuXXf1LaWJ7RpTLQu1lDm128k5kZsRf+zpSXYQBc9RtvXSGq86KeIri0YKz7TGWfsiUNgsJlm8MEpsgrJe8t/Bew9ViDm5HthCwCvlwfIapvNvS2zA3ZP/S4yrwjG/x9phhhGEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ALSSpyixzBMk5UUQs4JzrtvoTVkmXTpYKVlLkJqgWN0=;
 b=FMZ1MogVJtKJV9uv7yeD3Bqj+8BUryk0PEQ8OisiitnPgLshWHqsut2IrEh4AUz6a45/9C2dKBR8QIw6rkuTitS/NuO5cpMn+jZ0C2xX5/AwKE4cNgQcCPH9pKmc1mq2pte2zH0XRmiPDEE4JcKh9BPIzBv14pourfW8r3FwhRgeEQr7DmOF4E20rYtg2UeHoWRU1GvLE7uhoVoHpplu0xvGqmQnxShZKOuT+hCSld4Xb6eYZx0jINF406MNrW9pEvedqm/1ocKP6JB7pQQBP8otuomOeM+AIQSB2gNNNuxXZ6bdMuCIlpctGJ5WljdazXniirVonUiUbvFw/AiZYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by CO1PR11MB4867.namprd11.prod.outlook.com
 (2603:10b6:303:9a::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.14; Tue, 23 Aug
 2022 17:27:09 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::9847:345e:4c5b:ca12]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::9847:345e:4c5b:ca12%6]) with mapi id 15.20.5546.024; Tue, 23 Aug 2022
 17:27:09 +0000
Date: Tue, 23 Aug 2022 10:27:07 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Vishal Verma <vishal.l.verma@intel.com>, <linux-cxl@vger.kernel.org>
CC: <nvdimm@lists.linux.dev>, Dan Williams <dan.j.williams@intel.com>, "Vishal
 Verma" <vishal.l.verma@intel.com>
Subject: RE: [ndctl PATCH v2 2/3] libcxl: fox a resource leak and a forward
 NULL check
Message-ID: <63050deb818b7_18ed72949b@dwillia2-xfh.jf.intel.com.notmuch>
References: <20220823074527.404435-1-vishal.l.verma@intel.com>
 <20220823074527.404435-3-vishal.l.verma@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220823074527.404435-3-vishal.l.verma@intel.com>
X-ClientProxiedBy: SJ0PR03CA0091.namprd03.prod.outlook.com
 (2603:10b6:a03:333::6) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4ddff12d-c291-4c79-e4f2-08da852cb563
X-MS-TrafficTypeDiagnostic: CO1PR11MB4867:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vJ0eFakFTdisgCbVFuzgtIGRS271q6iT2uzScd36ex0/RG48+M4XpjkSpDD7048cFP6hKeN6svTyOvSnPhzIm6nltaeAkp0+H+0ryWcRHk8faZ/nL0fTR4if2DjCEo8QNkl5odHvzwkkVyYlJmQYP2nuB5ocZpHHmGwz4oCdPm9lvv0MNCjCL4b+lFLoi164h4mFuSdiyom9TCBbmwKQ1se2vXTsE1cDJR2sTcM69BVg95hImAVZxM3HToOedvg4npInczADnmydfm5ZFYD6cmxCRf0/rVR4xfbYw0TxJthJ0RjJ7Wl0ZFeBpdFMgotpYgfXCWjpFvL2xi/r967ppZRMc3H9CRj7nLXv/kp7PjfioS10uszGuFbcU8m0dViU+CoALggkCZ5I8Xzp0MghyrxTWsyXIYlSV8KnjrzHe8yV6w5pcmUmTJ5sz+EfXaq0ggxMG8SySjIDZY/4JiWHuYtqu7T2OtqPvJhJLXLUFWhPlPFc7pBYyJ+XOno8h3oHU5C1oZFbPuKSHys1TWbh2NdqGmB3TyvSW4KCirg3xMiVLG7MI3DlhTM3X+3UEmKwJZDVXlS330IU3J4V5Liz2av7qVLZ3y3trm/ToUjX5354OLJKcozqjaG5HdT3lYYMr2hAkUym3tH+KqzEm+akFyUKAOt0LXnLUhIE6BeNOd6m4xevNLoJllqZQTLShoGsLtuQdCR122eXSUFCvqn7NQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(39860400002)(366004)(376002)(136003)(346002)(8936002)(5660300002)(316002)(54906003)(186003)(38100700002)(66476007)(66946007)(4326008)(8676002)(478600001)(6486002)(66556008)(86362001)(41300700001)(9686003)(4744005)(6506007)(26005)(6512007)(82960400001)(2906002)(107886003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eGJdpr29zX2k2t2PJnrm3nS4vRt+NTDcs86/FGKftEQgrh6WT9qppMmAjBic?=
 =?us-ascii?Q?DIwlZom2l/hXrWyNWT1PGTQwBfPmzy8zbfg4VRvbZsYDYREjzxaxK4At+0oC?=
 =?us-ascii?Q?lTi2X1S7nVlAY77BWE3piWqHWXic4ukOp3m1qdHggRrj3PVCRuqkdfzi9xfv?=
 =?us-ascii?Q?8tKEa40YIB+1i+q3K++gtFC+SLMqPtEtVjbB56EfPiCOqLPvmRag9hmqPk7X?=
 =?us-ascii?Q?dmkbYpc71+RETcWbktFrtXHLqm0b5TqDFkvj6jrDYLBv2mfKw4jcepqKLl5X?=
 =?us-ascii?Q?1OrrJfMq5ScquvyD7SFTzpVU1ogKvzfAQm3Orb4O3FIsivbGLbR4QO4os5Yd?=
 =?us-ascii?Q?K9rq3cv/fRVPuWiMd3EHAH12L2NTsNtXY2nV+htU0A/Okattjd06qtpsXDZi?=
 =?us-ascii?Q?F0yejQn2OAxsGXIp/l7E09za8REBQvLHkkCLIJ78pyHw/nOTYmgoJbqpDSKs?=
 =?us-ascii?Q?6gqXpAw9d8n125sDgf1+F/oY8jgwu7mYhh5l4CDY9JtdTiqcbuf1vECvMXnv?=
 =?us-ascii?Q?6/c0PONkWw05ku4GRGZmpOczbp2Uwi8aeo+dvSaU/Ef2UpcrbxWuGvMQCbtc?=
 =?us-ascii?Q?e4foMBbCLpJeikosuOKSrYmK8eMH/+SIj5MHfQkXNesIUDs7jkr7VbFyVu/R?=
 =?us-ascii?Q?uwFnNgHrPqkDT2ZpjX4j18jHQPqHtOARGlagL5t1gryndoDERID4A00dLz2R?=
 =?us-ascii?Q?3ae2ZSIKwgqol/a4cdLr3XA5CadmhEGu0qpD7lE8m6TMvf9rgldNPFOg3bZs?=
 =?us-ascii?Q?8anaxLRfgK68k5b5CkjNA9smLog0n+vfBtlUWEZFHev8wnQ/aN468QN1lH2c?=
 =?us-ascii?Q?gI7KrBiGXVu6/8kA16qYTEp4mALTaaVW0eNDLqHp4M7lLXxSoDkcqZ2lfzMQ?=
 =?us-ascii?Q?UmTyUQanCwp5ru8pfQHHepl9JlaJjaZO4K88s/+AvCxHbIwZXK60Nna7V1c3?=
 =?us-ascii?Q?uDhdUAikUhhI05twnWfJdIpc5OWmhchQilhPH0aAUN0sgyQG9ZkwKnCnIzN9?=
 =?us-ascii?Q?yJ1TU9h8KhUsizP/S7HwHCWOfdZRpdXPyS4ACBBJ8ng2R6uzQ6ZBZgwo2K4X?=
 =?us-ascii?Q?TA9PK1CgPojfa3GcMWnGZd8GvX/Mat2m8gq4htdAv46HEf81Ip7oX/9X3ssQ?=
 =?us-ascii?Q?87wAviqsXM5vrFVNJ+6u8tdN3zCc3XPfWjw+bCreJLbIp+xKJT35A21dO7Gf?=
 =?us-ascii?Q?8OTfPWEq8l+6NVOx84b0mLRAVrPz7Dd9G5lDbBLdE51u+RCty4l6Pf6QHpXR?=
 =?us-ascii?Q?ZCKKlJ9svAZ2KKKB7vjNlWE10X9wOxEnSv/mWx7shdnKLVbCY/EzHTpeZB8q?=
 =?us-ascii?Q?B4m3ES3idhN9jqkMrlOoapUA0GtD7PcDrIbEm48nWOegHIoO5pBIQARijHUe?=
 =?us-ascii?Q?oU0vgNpJI74yXRkWpDxFL76QEvH7LaSJT+8Ph0lUTW/v8e5346dsxaS4umTg?=
 =?us-ascii?Q?PyUS7wgmfqg/LzFDKJJddZYPOaWdTJpg8YE1bTPc8Pt8Ieq3jXuWu27A6ejB?=
 =?us-ascii?Q?pVnEzhyTX2oq1LMr3+Q8fL3PzbC1fVvyjKSAyrj9HtaDkL9QiERneQtRt7VC?=
 =?us-ascii?Q?zqe8mTTGo8+ocgSkzV35eHtLepZGZ4oVR/Hmaytnq9xp23sjJJNLdUPvJzA/?=
 =?us-ascii?Q?xw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ddff12d-c291-4c79-e4f2-08da852cb563
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2022 17:27:09.6343
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ehoZA4035lPlLETNZhKrPVzFB6cSsQuEhrPvN7R9m2BPPx+/25ZLRwUSXc2Y1IARrdc7ncKvOUttLKDkGKKiSeKrUEcJs/oCFcKGb1m7Etk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4867
X-OriginatorOrg: intel.com

Vishal Verma wrote:
> Static analysis reports a couple of issues in add_cxl_region(). Firstly,
> 'path' wasn't freed in the success case, only in the error case.
> Secondly, the error handling after 'calloc()'ing the region object
> erroneously jumped to the error path which tried to free the region object.
> 
> Add anew error label to just free 'path' and return for this exit case.

s/anew/a new/

Reviewed-by: Dan Williams <dan.j.williams@intel.com>

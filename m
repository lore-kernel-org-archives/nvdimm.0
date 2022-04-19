Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2056.outbound.protection.outlook.com [40.107.244.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7C452C9C;
	Tue, 19 Apr 2022 23:04:15 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lIZLYvArFfs+UlIQYLm30B7MB44NQtzoZiJiz7sCK+RaxcI2obwUdLkJiikQB2ZSChVMZL/jsqGYyzMP2vTkZ1E0BxCA4NgbxDBIBcE4zBd2JxxeCaZIsMpQuWo8EXyByQ2loWpq4DVPWdSRaP99o5jAVosgXxgaxwvCN/I3KDfxdcbr0/QmqOpZfKYhbQ0WmoZrrEwSFUWGmHa/3OOoq6DJTg0GXsXn5cLxRQHW7I/m1Eb2eys3SKUxxmzfvTggovGQCSTFtLuPCuNn1LaGNrbHaUpA/tcFaB9Si9BK8tK7JmIj8SzDCX0bGPyG7ArSBRoGLfwpUiHgtLCmLsS7qA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rg+YUif79FUxVASl35OtW79cSEn4DUF0sfY78PY6xJI=;
 b=QXpZeRk0yTU/XG1IMTfPYplzxPUq6ltqJkhqB+Gwvf1x0YNtmjjnbfECEoTajdWnN0nm8XIV4PZiKAIihzRMjZEHbbr+ICekEiwK7awjJfYUcd47+x5n71dFYtYVWYqmNaOSLeA7Uxoy9CvfFJPzdf04kT2YxerwXoFOi2ssqo7z9O49WoESRvSNCRej/FDqV10YpQEdbCE1eL4PbEOtEY7mNv65YDkIlq6Buojzg8+KElofIQu/LDfStIenmt9JTJrWLwRemMxqvynSJ1onAQGVgZiwBhYLp1qHNAychr6X120eRLi4Zpm/qHu9bzUMop7jRYTR+ybxrUMN0TB6mA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rg+YUif79FUxVASl35OtW79cSEn4DUF0sfY78PY6xJI=;
 b=ZQsAZ9D1+xfrghQcQM3g6VFX7dbWno576BEejuIDSw96y33ckCRH/C2LGXvcIhjZGRW9xCiib0uio1qJynfVuHG/1cctEofLv7M4LO00WAfyDmUpNlBLqqpVwDg1aJLnBg53XKbgGN6oE107bFFx7OWAUvIApK0IVnsFdAFqBeKKdfzt4adq0mBhWzxWlCfI89xFOk8K9r9tCuEYHOewRHnzwOewDYYyoY0qKOn00oIwjZeGoCKntJlFx7CSTiXUpWthWtY6GEBzjMHU4Ca9T2eRkSnH0eFjRC0LqxBwgwvm0B6tsVu8082lyNHpTgRt015UBh5548+lBsBdMK1KPg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM4PR12MB5310.namprd12.prod.outlook.com (2603:10b6:5:39e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Tue, 19 Apr
 2022 23:04:14 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%5]) with mapi id 15.20.5164.025; Tue, 19 Apr 2022
 23:04:13 +0000
Date: Tue, 19 Apr 2022 20:04:12 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Ben Widawsky <ben.widawsky@intel.com>, linux-cxl@vger.kernel.org,
	Linux NVDIMM <nvdimm@lists.linux.dev>, patches@lists.linux.dev,
	Alison Schofield <alison.schofield@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Christoph Hellwig <hch@infradead.org>,
	John Hubbard <jhubbard@nvidia.com>
Subject: Re: [RFC PATCH 05/15] cxl/acpi: Reserve CXL resources from
 request_free_mem_region
Message-ID: <20220419230412.GU2120790@nvidia.com>
References: <20220413183720.2444089-1-ben.widawsky@intel.com>
 <20220413183720.2444089-6-ben.widawsky@intel.com>
 <CAPcyv4iM13nzCpnF5S4oHSWF769t4Av96gQM_3n4E=RAPSnSig@mail.gmail.com>
 <20220419164313.GT2120790@nvidia.com>
 <CAPcyv4hPBw0yJmu7qzSZ_gsbVuj+_R7-_r3+_W9-JsLTD6Uscw@mail.gmail.com>
 <CAPcyv4hyTRm7K8gu4wdL_gaMm2C+Agg1V2-BbnmJ8Kf0OH4sng@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4hyTRm7K8gu4wdL_gaMm2C+Agg1V2-BbnmJ8Kf0OH4sng@mail.gmail.com>
X-ClientProxiedBy: BLAPR03CA0032.namprd03.prod.outlook.com
 (2603:10b6:208:32d::7) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 27dcdbe5-9de5-4d1f-7279-08da2258ec00
X-MS-TrafficTypeDiagnostic: DM4PR12MB5310:EE_
X-Microsoft-Antispam-PRVS:
	<DM4PR12MB531040F49710A83E63C623FCC2F29@DM4PR12MB5310.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	4+xLsYUWXIQUEXJCZjiPwg3M8eR3FUkx4VbP3pfshb2m5aTPDsDu10NDLwSpuGz1vaOmFm/uVUBmU6S2Smt+Y2xgabhjlSPBjBU6SE5ePeMYzG6XzIdr8IMml/wBnZtMUhG2N07y343gbZBgaHNwE6o2OT8vx26kIJSwPIzRlMORgwNqaJXAzcXyNsQxycwSRE9oEoSvp+Ryt7T7KytoX5cwMnU6Ns0HMhEutb7fQWSoZtCE/Cw7sE6C59SWmCfVK4VB3XSlN3pPhxZTkyRV2d61J0XhXsTN528wMQtw+eQ00uQEY7eWp1Gb+tq/lWlmFS4OOSW2PJLzTqeqymQTdxDmbJ7HeFsT7T3gD7YphKEt0wM3I2XCsi30Y9O5wT87i2fH11TiI0pBkXRmNeMzR7IVY7cb2FKe4Ih8ataTIrPvbTuXPVfOBu6Ceywd3Ifa1gnN9wp4Sz2zotLqqdF/yhY8wYdlsZQK79TT0AAYvmO8EEP8vw7eiR/aiFhy9e3wySOfCRiOuMEGZBRs1SpdL4j4dA63OikUEcGIf5lMMzOt57H8Dfan7G0LNwCIgLTDm4DKI8ogw6y/sMOcEj4PsNR1R0Dn0YiE7icPcIE/oTSs2voRFwCbhsZZDdMJCwNYgIGTrxeGjhA5MB6Z7RcBag==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(107886003)(26005)(33656002)(66476007)(6486002)(8936002)(4326008)(66946007)(66556008)(54906003)(7416002)(5660300002)(6916009)(4744005)(2616005)(8676002)(36756003)(316002)(1076003)(86362001)(508600001)(6506007)(38100700002)(6512007)(186003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xzYuWGQgn8mnuiWskkdcD739/a3etkFxeRGCOyb11kOMlNRVsQUjcmsSi+bl?=
 =?us-ascii?Q?PDsE0EdnEyxfqD4/kzfL+TRGmG8DBIDDqYvdhtANhZlCltdtPzgIw/efOmd5?=
 =?us-ascii?Q?SdszZKNSoYGmGfXy7nQDG0xu2397A2ulh1idt3CJ8lXAogtHbesHdTsQG2PW?=
 =?us-ascii?Q?uAYEFViOmn17ATSdHhyow6wDhjcKYS4B0iHf3QwlDGqvYsydN2Zog41/l+AL?=
 =?us-ascii?Q?wf8mNQUSR9A4+09hEytQPX9nrVqQwVgdSv7pkTOuMUzqDqgzIrfffx+uMjbI?=
 =?us-ascii?Q?zzpISzxL64OVpbzPmgNZvbxJsqncqQ+E+HxsO0NjaXiqbB150fuwyRD8Yreg?=
 =?us-ascii?Q?Oio31FSWohQKvZUGq/fJBWBkorYstwf443WQoE+g61+8w6VFYSBFmIZW9FyN?=
 =?us-ascii?Q?2eVIxuwldZUQFBxnkcasecJjr+ZQtYMBuZGdsH8+bb8hy2sN8Y+4F00P+SD7?=
 =?us-ascii?Q?uQZo7XBvvLKbPFPnAf7hq62COZz9Hbni0HAmvRM1wLpZNADfdqmG5LHUY15L?=
 =?us-ascii?Q?aLzFlrrXN/tiO89c1Wj3OOXqL2kNYbDtYcQabdQ+JTJz95FTzMJAmEw8jhxt?=
 =?us-ascii?Q?4MHruoqfNWhRY+pYTJHYDRHzFalUq5M9TFLYFttF4wb582wGEa6c00kTFWqD?=
 =?us-ascii?Q?R0k7vQTLD4y7FlNQed9averneYPtgQ4SrSGfYYVjcQvop0Ep9+u8kx235yFD?=
 =?us-ascii?Q?zob3eLYR47jW1ujYHXS+DOAwecrQ7lGW+Ul/gX2momXVLSrYugUltO4lODEt?=
 =?us-ascii?Q?QlUjfRTcJ1kudAz/HHFvbLrqs8XYvdrGgA31fI7pswp/4XuSHfaXZKsgnOEc?=
 =?us-ascii?Q?idb2o+kaxam8q9BRI9fWeH4lnON9hIuwA+Hb5+QKXV3dyoVgGjkw5jklZEl5?=
 =?us-ascii?Q?pNmndC2uJ1AlixvlpNjomkn4CpebsC1cAd/4fLFFOaiL/qiB3TZ/snEnihvL?=
 =?us-ascii?Q?NHZE/temhZKD7n3PbchQNAfeOCwPcI4aJkfA56LAG6tOJlsuT74mJWjNfkdT?=
 =?us-ascii?Q?AZ2mQY2a/cD5lTvO/LHn6EdhP+7hqoDSpxPFv2SlMUtkeCTs1XB+lXJ6/mLQ?=
 =?us-ascii?Q?7ELa0gIPnHab8XDjptf95AKqiSzgEkJ1zpsIPFvvqvISwOnNnBg28u29Bq3i?=
 =?us-ascii?Q?ZBZlplZI/0LECpnKD/26j0yYA9iFk9awAKzi26DN0gySEXqr9fLXX2l/MfO4?=
 =?us-ascii?Q?sexFV08pbQzsCMaVUVuua7Pf1oQW8FJZf0AQO+Dnkp0oK2a8UUsJvGdRrPa4?=
 =?us-ascii?Q?yYse6vUbpcGC8XBetuTQP6tMTpQcGg9Nck5OVhrysD4mH/0kOLLKA8fj2OSb?=
 =?us-ascii?Q?gydUZ7RWrOeP3QM6KoCUPB4/h2sIE+OoZb2IFmmUoqXwXvuPN/2qPuIvF/Ck?=
 =?us-ascii?Q?JaMeZgHxRUnvhW5xwYrs3mKWvC6Sj2HQloy/IOsYOeWNSLR/pSr04vzxLY0+?=
 =?us-ascii?Q?jT4RRV2rq7qkC5gPGm4/MCjbJtGR01f4FK8EjqXQRUzI5O+asGmUZkiyEPGa?=
 =?us-ascii?Q?+hrs2DBpJE4zNqNfZ7+DSbNs6HkB82aCsHXteghWBYKQtdlg4n0+d1GNcNnL?=
 =?us-ascii?Q?l6CUEpGkljrzYSTfAIzmlgxA/FxUwfHkgFVXh/bcLCRD3biTgY7CtDm0+gDj?=
 =?us-ascii?Q?LOXBCORuimxldPN6W9cdlEKl3oEnMvk5WRC/DFT0Wh6PAxY2Qx7jVtaWIkkY?=
 =?us-ascii?Q?nkkNJHP1P74eso/ltLkEnOLnhXzgDyW7XzVyB5aohcqbM8ekDbkfuyhDSdtx?=
 =?us-ascii?Q?PFHLvt6lXA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27dcdbe5-9de5-4d1f-7279-08da2258ec00
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2022 23:04:13.9202
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +V79+as/fKyMYNp2yH4Z8CTqX/WUILU2uKqZHYiO5pDEw7MWIlvV1Fjhf6JbJ9cO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5310

On Tue, Apr 19, 2022 at 02:59:46PM -0700, Dan Williams wrote:

> ...or are you suggesting to represent CXL free memory capacity in
> iomem_resource and augment the FW list early with CXL ranges. That
> seems doable, but it would only represent the free CXL ranges in
> iomem_resource as the populated CXL ranges cannot have their resources
> reparented after the fact, and there is plenty of code that expects
> "System RAM" to be a top-level resource.

Yes, something more like this. iomem_resource should represent stuff
actually in use and CXL shouldn't leave behind an 'IOW' for address
space it isn't actually able to currently use.

Your whole description sounds like the same problems PCI hotplug has
adjusting the bridge windows.

Jason

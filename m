Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D4037B
	for <nvdimm@lists.linux.dev>; Wed, 20 Jul 2022 01:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658279078; x=1689815078;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=OZasx2AUs2b7aHh4SW98bIAgDspM9qI0yd7iio9bAHM=;
  b=cvExAHFcly5klEsOMBdNNedyIgAjHkDo6Zy0PiOPrq1LO1AvWTWoS1Yj
   TBXaID492TjfhaPPgOQwmdZnA33vBTjZPmV8H/Df2Ka7VT7cLXG4dgHP8
   +P+fD2cD1hUwouCe3pSTDVAjmdoEbphlP4bV4JA9+jH5LJKNibAKFhZwo
   YOshL7z+A/yT4H5Zgnl8pqwEcU9CfXTnFG5LcyGiAOgQLlnbLbpIoiqFp
   UDfQrkVe35YRmrVtaxcdXQi31SmnfP5YEAKuIl8d7cFkff1F46zepdErV
   LE7hoGj5OM50paMgLbHv+/SUjHDNKCy2+IiZPZbillOV+MyydHGZmkhDi
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10413"; a="287394086"
X-IronPort-AV: E=Sophos;i="5.92,285,1650956400"; 
   d="scan'208";a="287394086"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2022 18:04:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,285,1650956400"; 
   d="scan'208";a="724468739"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by orsmga004.jf.intel.com with ESMTP; 19 Jul 2022 18:04:37 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Tue, 19 Jul 2022 18:04:37 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 19 Jul 2022 18:04:36 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Tue, 19 Jul 2022 18:04:36 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.173)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Tue, 19 Jul 2022 18:04:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OW4J2cRYYa3EXryAzfSxJbUlM+DMr/MBzfRRXgMWkgwMV2ENi+v1gP7Gmcd0jLjiKxR7Qxy3tZPDKjyfQTJ00NvaZTQS6rxC+VwsN3nkpotbUqWBCUk7o9uC7/AHHRt651zj+an4y8mcLg6W0IlPafFxStTDYAXbjGp4otNd5gPdvaVnUEykUSXN6R7bPdbgn+odrx1rpTFzkU/N3fnr5HrZify0C4cZMC0CXrWbBxTRuDRJz4AIHQLnkRo3Q8vPWuoI+Xgq1UZFrcJmEMw9XEI07iM4wt8j6+Ul/hsJ1zO1TxFB8oWvvRDImp2arr/u0U+0EHuJSiKQ9dLbcmfMpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2IyiiJPKnAN/UpedaLXLnKGwzq8ICAUp/wRDXXDrWHg=;
 b=jT4z1xI4HZHbqGkffwze33EakNCFB7qfE0dg5BiexJDIadVREHvAPVxI5MUZqCtnd6GSGZBdeQ3i/nXBbOuTcwEnYCQ+zRomUayi+q4+/F2Uj5JC/91HfGY+6eSwspGSzA6Fv4ibo+zFFBuYHawuTnTlAvjAPTtKnBkSjHvwQSexqkUZ6IgnFwW/xkNEYMFZgmRHGBtwqa5jIE3/oJhDn09b+MEwSoKVZHtMilneuQjIhbh9UBe0CWTYOvLzS9WZ49CdSFKRHcpAmFRIDGfhBafpfk2Kf+4Gicuy440Y4ItW6dpFA1Gl6Dc5nRwKAJQVqbPJo/84ZxJWOAdLDBXyhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by BN6PR11MB2019.namprd11.prod.outlook.com
 (2603:10b6:404:3f::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.12; Wed, 20 Jul
 2022 01:04:34 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::6466:20a6:57b4:1edf]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::6466:20a6:57b4:1edf%11]) with mapi id 15.20.5438.024; Wed, 20 Jul
 2022 01:04:34 +0000
Date: Tue, 19 Jul 2022 18:04:32 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Vishal Verma <vishal.l.verma@intel.com>, <linux-cxl@vger.kernel.org>
CC: <nvdimm@lists.linux.dev>, Dan Williams <dan.j.williams@intel.com>, "Alison
 Schofield" <alison.schofield@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Vishal Verma <vishal.l.verma@intel.com>
Subject: RE: [ndctl PATCH 3/8] libcxl: Introduce libcxl region and mapping
 objects
Message-ID: <62d754a092a6e_11a1662942a@dwillia2-xfh.jf.intel.com.notmuch>
References: <20220715062550.789736-1-vishal.l.verma@intel.com>
 <20220715062550.789736-4-vishal.l.verma@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220715062550.789736-4-vishal.l.verma@intel.com>
X-ClientProxiedBy: BYAPR11CA0041.namprd11.prod.outlook.com
 (2603:10b6:a03:80::18) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d13d91a4-543a-4564-a8c4-08da69ebcf63
X-MS-TrafficTypeDiagnostic: BN6PR11MB2019:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EJU7ShzzaN95+7q+cgv5lWyhdSUjqE22TmjSyZIk6nBWmm1sj1/qFVhUlyi8l6Lx4JKukO05tOC3XPUqtkAziF+ugQ62fK+W5Cl5P4qsYHE6vfLRQD5XnQPhNa4HoOXI6iDLfEhgToGM7jW/bnV12zLdOA6SNoj6Fa8x6tPEe4Bn4ngdegydR7Kfo6xyvW99ptivwI0MGR6jhtRWhiYkVHtuDxefMX12oSkc3o6Pm5rf+okijAALry5vrNVRb5XA/fqNOrPWwzc8HmdwIPRXoWZDN27lKYz3KTTMzJK0199DBDGTNPV2hodxt6/CsZGs+IPOztNWP/hi43Hr8LZI22mkv7/Yl9XiPnPOFbN+qb5g+4ZLp3rkhgGOFWGXjkt4nJRwFIaBKR8SJsrZdjltTVmMIsU9CuPyJX+fb3kU9v+Kub+eISwgtMtsdaVdQUXDC/DD1pVMUqc5km6Id0Msh14kQTKkP+75TQlouT1rLekzH1raPXWvkuuE9VYj6sgCAL8oRxNd0+vJhLnK7GaBOUARhIHPpVYBfMCPdXwxXvD+Kz9LCvDVWQPg0aG1SfVwBWFCWD64c789xc3CjoHgaQE83j3zDeWf9LW/YBG4I+Sk5tq/QDZjUPhTXIhneo2DMaOUjDnU19DWRM45id1qkQ9xB5yIbQDHz0GUi6YailWhKDhZEhGWDSh8jvdzbs5C4Ym21coy4uEkioZec3gMF5BjwEAHS12r7MAZxPhwq9SHSv5zMVmSuq2cLlWk0Obp
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(376002)(136003)(396003)(346002)(366004)(8676002)(4326008)(6486002)(41300700001)(478600001)(86362001)(186003)(66556008)(66946007)(83380400001)(66476007)(5660300002)(8936002)(9686003)(26005)(316002)(6506007)(54906003)(107886003)(82960400001)(6512007)(38100700002)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Llpta5rAHI6mCONheAmUfQxTQ8IGHBLsgtQ2eXyZ4Oztb72yh0O+GB+Dh/BV?=
 =?us-ascii?Q?iLhB4nPjLCmidYPkYCJyqNWFcjSll4MWr/nVbevTHeHFL+KRmo08Vn14klzr?=
 =?us-ascii?Q?cJxyc/25vCcT18lzfapmUJRWBNrxXMUTTBepwtQyIqMTEV+Q6Y38KMF65y1R?=
 =?us-ascii?Q?AFW42tAhIDLwUMQ4GnjNJbPhdsveNjbRILM3F31TtdmtJ2rU93AuPu5CYcDO?=
 =?us-ascii?Q?FMWed2wf59XWKB71OTrLkJKEB9sNp4uuANdXUUgW6cEf7p4BcITBvmtOzcmD?=
 =?us-ascii?Q?Jl4wylhUb/rkrAmRzFg8si7EyFa1LQioyIojHd0cVz4x26helpR8e9g7Nyrq?=
 =?us-ascii?Q?Qpllm8MbqZeFnmpPFJM3xVTbksDaHLUjpchx13DriFfxLZW/eSVVe4IQKyzj?=
 =?us-ascii?Q?K5L9iAmUHlTrVWui6ku2JhleqgAKY9UPdLLDmrHHIeUgMVUCmziKkayeEwmh?=
 =?us-ascii?Q?js2hwvoOjX6I5ySDbT/UjihiStbNcIk9GuAVwTzkTBpihl+paoh8vl0zAmj7?=
 =?us-ascii?Q?Im1md/TJezeDFnhxC05+MauMUN5Bk5n714iBqon0L5L0wMGHCoIjIGvTO1iN?=
 =?us-ascii?Q?12Xp3v6DMF0qvfOhuuZ2TJ67RUgbsvq3RZVQ7fYVXOrYekAPqnO1GidTJCE/?=
 =?us-ascii?Q?s+EZR8oD1DmB8a4t+kd2MqiWWMp3aS68mOtH2z7Ibcqf1SaYQCJrgoZsmrId?=
 =?us-ascii?Q?CR3HtkEDHK5HBOFKudmHn3EWrsm1HhbVVec3G5oS59lB1A7JOZhTa4QZRj2d?=
 =?us-ascii?Q?a885KvcdQFbrrXmpjL8/CDju9/yI3FTzCYYA/3d2oKKeWg3Ex1L9AP3cSxZD?=
 =?us-ascii?Q?SEqjrPVY37J64d2hX2NeXJfhqMcRDbZ4vV1MHy2GY0vGOSEb0vbJMpyaq5/8?=
 =?us-ascii?Q?UhCVeoW9ixaq3h4VSXIMUk2+QlKKeRrIJYMaewxq/Kr62Cm8eJj+ZGwXFqbc?=
 =?us-ascii?Q?19Hq6jY5UILYvzJxlwryn5tQNQG6YaQbStfliCvQnFrWbiJGBk/MAOpB08iV?=
 =?us-ascii?Q?OHMpewR2yy0RQ++4N6C5er7uXEt8UCYDLdiioFM6c1ed7SkiBHgd7usTIlKM?=
 =?us-ascii?Q?K1wHQGy9c1Scp51PoBjqcyVb/bR57kYBPzS4Yq4+UDmTIbSGg7UG2zO9t4S5?=
 =?us-ascii?Q?gsYp4jlaBHu8j7xMHjo/xWW1fLbsQX2mP8925UwjQjd3VT708lWLOZmqkCUj?=
 =?us-ascii?Q?fNKne7LhFzAl9k7LRemyyhRxN7yHdAaRTezZccNUegZsOEmjkU5KsfqGhlUL?=
 =?us-ascii?Q?TxvuO7zhwKh+jV4FMQBeN2zy19icza8OWZsKtukNbayhNQBLklsknCHuKlmP?=
 =?us-ascii?Q?6A5Kx/XsFX0RImKc+UMTrFsW6yUaxGIdhHXkkVwyDrU5XX00eb2V+MfcP+Zp?=
 =?us-ascii?Q?b2DOSdmFYGHROeZR3v9e0DCSvFxj3hEMazaQJeEOS1ppOWfmFpvNdss2vhAk?=
 =?us-ascii?Q?WWwdw3+6LO58txfVC1heaqt859lDP9IIf0izOr64lC1vsdWygEikYZQD9ZOq?=
 =?us-ascii?Q?Ty7zWBlSKZcAW/jQ3E79ZRF/+rnEBDd1sva+mlhijgdsvpf3Dg8UcYAHvzn8?=
 =?us-ascii?Q?kZDS+mjUei9pCVlv+M3t2enkTqRd+tzCLP2zrYwjccUsuUxSMGBCM2QnVqjp?=
 =?us-ascii?Q?0Q=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d13d91a4-543a-4564-a8c4-08da69ebcf63
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2022 01:04:34.5242
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KFg2lq6rGjrTHOmSO+OB+h6KYs9hNlvpxVT/ZwmD/acTIQc027DqNRC5KSQNqfvWhopJzfDlRoM62zeTN2H4MTt552BKoABqsk4IjXzewCI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB2019
X-OriginatorOrg: intel.com

Vishal Verma wrote:
> Add a cxl_region object to libcxl that represents a CXL region. CXL
> regions are made up of one or more cxl_memdev 'targets'. The
> relationship between a target and a region is conveyed with a
> cxl_memdev_mapping object.
> 
> CXL regions are childeren of root decoders, and are organized as such.
> Mapping objects are childeren of a CXL region.  Introduce the two
> classes of objects themselves, and common accessors related to them.
> 
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  cxl/lib/private.h  |  34 ++++
>  cxl/lib/libcxl.c   | 421 +++++++++++++++++++++++++++++++++++++++++++--
>  cxl/libcxl.h       |  41 +++++
>  .clang-format      |   2 +
>  cxl/lib/libcxl.sym |  20 +++
>  5 files changed, 508 insertions(+), 10 deletions(-)
> 
> diff --git a/cxl/lib/private.h b/cxl/lib/private.h
> index 832a815..d58a73b 100644
> --- a/cxl/lib/private.h
> +++ b/cxl/lib/private.h
> @@ -116,7 +116,41 @@ struct cxl_decoder {
>  	bool accelmem_capable;
>  	bool locked;
>  	enum cxl_decoder_target_type target_type;
> +	int regions_init;
>  	struct list_head targets;
> +	struct list_head regions;
> +};
> +
> +enum cxl_region_commit {
> +	CXL_REGION_COMMIT_UNKNOWN = -1,
> +	CXL_REGION_DECOMMIT = 0,

I had been calling the opposite of the commit operation "reset()". How
about CXL_DECODE_COMMIT, and CXL_DECODE_RESET since it's the "decode"
not the "region" that's being mutated.

However, this isn't an exported definition, only CXL_REGION_COMMIT
appears in code, and nothing else in this patch looks like it needs
updating, so just leave it for now.

Reviewed-by: Dan Williams <dan.j.williams@intel.com>

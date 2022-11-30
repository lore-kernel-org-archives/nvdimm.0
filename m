Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0662D51B
	for <nvdimm@lists.linux.dev>; Wed, 30 Nov 2022 23:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669852449; x=1701388449;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=K+xEW5lHgmNLWVZD6EC662m7IvVHW/akKe+6gnuPuLw=;
  b=c1MtGwc8P5Nd5VEMHkD8qNP9hFX4UmsV6ixFA9baA60j/09La9FrMBRR
   i72oAUz8i82Uew7pmvie3HzQx+2XqKh2Mjmk7Kb4b3bvBogO3J4CNV1js
   PtiqM96v5rw5H09JUi84ahIv8e0iGndgZ5u/Ttk4V5lc5I6eBuZHjwFKW
   mi4kjQN6H+oJoBbyp0AvaG2LkIvpBpP8KniXcpsmDhr508c0c83IaMzAI
   mrG1fHfoRDFhcoJewkSjRFeMAh6HmJHS0J6f3QusORNdcLmTJ1NFPcU4c
   gX7Qw4IkEx5Qnx1HWGID2wASfpZY3rCBJk6Af16pnbCjkJWOE73LlD8+K
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="295234589"
X-IronPort-AV: E=Sophos;i="5.96,207,1665471600"; 
   d="scan'208";a="295234589"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2022 15:54:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="638183291"
X-IronPort-AV: E=Sophos;i="5.96,207,1665471600"; 
   d="scan'208";a="638183291"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga007.jf.intel.com with ESMTP; 30 Nov 2022 15:54:08 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 30 Nov 2022 15:54:08 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 30 Nov 2022 15:54:08 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 30 Nov 2022 15:54:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D70Z1MzIMmoC4qClxusB7ZxvUSAbmIlPRev935kmdNGenuQ/n4SduT5580GIUYAYN60TLadcDrN9bl5i9ms1TGlqZCYkVWa5JUF3L8X3lodbuwnO3KEpiGmnYkj9jB3h2QpK+aNxFlsRhXO9iYpiOzLhZpM1xnrdb9gBE292cmW4J4ujF0nrjYfwf4Jtsi+JfOeeyrIF32OXUrPz0dNlF8btXfKL3YnbmHRfXYkjp1a39oPSrxnTk/vIiuhXF4XpB3xxMG6OVAYFWUH1l92qRf6K0lSGVBubNPXzor5N85J/rBSObSzEHdBl2hvGgQs6Jo+trjT5mcIWyv61OWmEKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jCQoEown+OONGYDdR/wFumfoLDY1YRCKOzqSZBI0+Kk=;
 b=XAkWrlCLg3sRi8oA3PCRMJILeR7j70QmhjoLiNZpMg1d5JcfE9yR2veOOVN8CqI3Yj4c8UUIQSyIRZW/YaLV40XzvLk4juOWbaeRnz5s8wk3B0Llq+pI/CfuJkzLTiWgVNyBzElOD1ITCgqc9Nl+O7ws8yFbHGQXcsuDYd2l/zCgvK5ssEsIj2Q7OwjGqcxQjJqPhUObr7E1IyYC6Kn0wYg8Gblo5/BbVxfnLFE8eaypll8d/jXXDb+M/HgUHLMG6tJZlHPNN+tWfv//Mgw0wjZDt9TbXI/47Pwj/YqZuiliAkE/SL8kLRaBKByCRzZL50MAk8sRNo/w9tq60mhf2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by PH8PR11MB6755.namprd11.prod.outlook.com
 (2603:10b6:510:1ca::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Wed, 30 Nov
 2022 23:54:06 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::340d:cb77:604d:b0b]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::340d:cb77:604d:b0b%9]) with mapi id 15.20.5857.023; Wed, 30 Nov 2022
 23:54:06 +0000
Date: Wed, 30 Nov 2022 15:54:03 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: Davidlohr Bueso <dave@stgolabs.net>, Dave Jiang <dave.jiang@intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<dan.j.williams@intel.com>, <ira.weiny@intel.com>,
	<vishal.l.verma@intel.com>, <alison.schofield@intel.com>,
	<Jonathan.Cameron@huawei.com>
Subject: Re: [PATCH v7 18/20] cxl: bypass cpu_cache_invalidate_memregion()
 when in test config
Message-ID: <6387ed1b67fb7_c957294dd@dwillia2-mobl3.amr.corp.intel.com.notmuch>
References: <166983606451.2734609.4050644229630259452.stgit@djiang5-desk3.ch.intel.com>
 <166983619332.2734609.2800078343178136915.stgit@djiang5-desk3.ch.intel.com>
 <20221130221641.hban57icdww2fie5@offworld>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20221130221641.hban57icdww2fie5@offworld>
X-ClientProxiedBy: SJ0PR03CA0128.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::13) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1101MB2126:EE_|PH8PR11MB6755:EE_
X-MS-Office365-Filtering-Correlation-Id: b1ee624f-5e98-4c3c-6254-08dad32e2a38
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JaEMrPwASzqdkUHeGXke77I2wlUAc/c5jtDeSU7PeuK5zcwAqGMXk/QvhY6nJV3F1Vrw2NruacYxGAlR8TNrXbsyziSwzbTCoUs2XI4BScfDFt+YBbHZsMcs+og2xkGJhSEkMVMg1pm2Qjg1Nb9Y80nbjIl2ceSSCP8xjSp2j9ufjjeVcD3SpIOHqCRnGVOfmEBNtjE8wVW/9ZfDKr6FX3/9ty+EQTRJbYqR0IQrxUwn7vO4eZzLXfHdZFtVX7TdwVPDMtYQKGlhKEcAsImrxjGP1e9NWhHBuLDlvRll5xD/BI3wWYZrbTiZfDfFLupYB0mw6ymKX73gaDg6WuNghsQJje4C6QAH97l5FgIsw5ZcdpHtddxBNQybd/HDAje0QGTR0SmcPMPg8+YIfBIZy34guzT4i2Wi0lLMiFNSOxZoCx55RoxLtu0AirYCwgX99PuKBe3TX1B5y7HorvV7A8jBqxmBxGYx1pbzlq0uPf+oiyH+EvY08f2UMx1lTEh4pxVr/3vPBe7nq8TblTi3GB8JiSDKdn6ECp2xHV8NrnIOx1f83D4UFSl7EKbA4KkPLCiReyW5sU8inGfdFSrJfcGDXhhKQzByqwMNNA9/NVU0D5QXkcinFlJFMAK+p27aYzPB3G5TKd2/+RjG+Oyy8g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(346002)(136003)(396003)(39860400002)(376002)(451199015)(8936002)(2906002)(38100700002)(86362001)(41300700001)(6486002)(186003)(478600001)(82960400001)(66946007)(316002)(66476007)(5660300002)(8676002)(83380400001)(6636002)(6512007)(9686003)(6666004)(66556008)(6506007)(26005)(4326008)(110136005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4RRlGwJ3A4nL4iWnbjgbGU4LoYkWeXqX51ggOxyUAP0Ch86bj7HFQkR5eozx?=
 =?us-ascii?Q?vN1OukwLDYgBJQkyHflZOWV21MvhK8dMlLwCtC50w8tc/wSx7C2Pv1e4wNsx?=
 =?us-ascii?Q?DFignpX7WWA1VwI3SO+MUHp3Xe2A+gE0JBtyYfQ6qf2mZeHWlFf6WZpLXGT+?=
 =?us-ascii?Q?zsgO4YjzT25TcYG/Sn5R9yb2dmyl6slQ4XuhNLUuoLlBz0PNTFdd86DIjfhv?=
 =?us-ascii?Q?UwqPxmkTr2vvPtlKuAv9l5Kgz36E96pJs/64Fx4z2VLGuGEvuw528nPwzJTU?=
 =?us-ascii?Q?5weT1InIKRTBHfqA8yxOM/bU0dsjKoorrdPG7qjaBAn90WtQMW3APgT1Gttc?=
 =?us-ascii?Q?VDqw30qWy7tXzcGta2iqmxQpfiwtCikFUlayO2vOPPCl/LS9LOKUtQOnjF5N?=
 =?us-ascii?Q?Ja7Fm/EVL6BiJI+xWp9ij97FWCjSKT3HU8ee0imuLvZITm2zv8tNBlAm7Ck/?=
 =?us-ascii?Q?rHVTHsu/enDrRzKcrB/CXLiOoQgzrkHPq24IgDbYs2YUajXRwwJGkcXSJlO2?=
 =?us-ascii?Q?BbACP560BoVJ+NQOZ5eOPaSv/t0Grc4gmORqhRdd4rm6tpdYgOWzv36uBH/+?=
 =?us-ascii?Q?Fl3uTZEy6fUgj2qeIayjecs8ZHaG5vOuCcEjzjh/YwpLrxTSaPdZSO35jp4C?=
 =?us-ascii?Q?Bmef1oq3n+iUwYVc6IJGXfJXNpHIYHSh3Ol7lH2rzv8gefcSRd74NX52fN+1?=
 =?us-ascii?Q?VSoTWee2pJjjvzwmI9TaY52lDjAXlBdAdOhephitGa3bC0hGXXD83t3bLAg9?=
 =?us-ascii?Q?4aHVOKhRtTyoEOckd+JbA7sC6cqKNEav4mSxlRk//3cIxVxfjN3/nBMIJQrB?=
 =?us-ascii?Q?vefZqQTORZDOudrjg3g7XnNqWQpTQDZ7bVzeeUmmysylASJyVwAcK3YjGd4E?=
 =?us-ascii?Q?HvVEIz2mfdp04HVYacOeWt7o0dkUJa+VzGDiuG7Q/LVTFPA0f9Q1p4J87COd?=
 =?us-ascii?Q?HRSfE15z+zzAv3Z2zMEGGAbFncpK42uTg016nqxOBJbV8BJRyztDWBG6IrSP?=
 =?us-ascii?Q?eEMitGjANBpSWKN1F+kKRQaRkf7Mz/8NAucT1yLudmkg1aWs4b2tWOaAMDaw?=
 =?us-ascii?Q?udMoFQVDn2EhDJ/GSGU74SFAWCFulpnA41kSKx6xL7TMsNHniXd6+DoyZz6X?=
 =?us-ascii?Q?NlA/t5DrwiWWTbkEjSlFtMRVZiAuo++8lsqRWOBBTrggBSFLKHhXeZ+RBCjk?=
 =?us-ascii?Q?5+ns7mEmDtbi7tYN+2VG45xzUPMKKuw1842lHIUk1wOjA8iNnSvC0ft1Opmd?=
 =?us-ascii?Q?jkOeObz9nGFL9AdFPgwSV1ze4W1W3EVBQ1pWNPtqsB+0ANe64nuqRlTPRpWx?=
 =?us-ascii?Q?/aqoq7rMczkGTnxN2RMOcgdMb+LtnNXqcWdaEzVHHkVZe9OUNL/YkM7Xg19K?=
 =?us-ascii?Q?VsoWx+V+DyLgm1Orx6THTwowbEBJ4izB33me6+cXz8Ba9v5i9weHCkJI0IPC?=
 =?us-ascii?Q?nsvx3+4uzOUIGuNvb9Xpnq1QmRJzZZI0f6jsDryeXXH7Tfoy1w74ose5Ky4l?=
 =?us-ascii?Q?DzWJxXD5MyzJLQDUXzGJvrAUDbOFCnJVbEwaCtczO24RTQ8yXZGZZBA7iz2U?=
 =?us-ascii?Q?6YKMhDAFx7bfN92ZIjNaGzc/+JGIyrc219ecVITyZkIZo4k2W+0jAxkb/hhr?=
 =?us-ascii?Q?2Q=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b1ee624f-5e98-4c3c-6254-08dad32e2a38
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2022 23:54:05.9140
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JpTUncBqqF2lqdsNio/0LBiTKOc2tNt8mDoPYq2r+VsOZQYePKsMMoY4jYBC2ddRyLZTgUT9FCaxa9Pq73f63h2HVcJTW+c/pYm8pFcDAYw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6755
X-OriginatorOrg: intel.com

Davidlohr Bueso wrote:
> On Wed, 30 Nov 2022, Dave Jiang wrote:
> 
> >Bypass cpu_cache_invalidate_memregion() and checks when doing testing
> >using CONFIG_NVDIMM_SECURITY_TEST flag. The bypass allows testing on
> >QEMU where cpu_cache_has_invalidate_memregion() fails. Usage of
> >cpu_cache_invalidate_memregion() is not needed for cxl_test security
> >testing.
> 
> We'll also want something similar for the non-pmem specific security
> bits

Wait, you expect someone is going to build a device *with* security
commands but *without* pmem?  In the volatile case the device can just
secure erase itself without user intervention every time power is
removed, no need for explicit user action to trigger that. So the
data-at-rest security argument goes away with a pure volatile device,
no?

> think the current naming is very generic but the functionality is
> too tied to pmem. So I would either rename these to 'cxl_pmem...'
> or make them more generic by placing them in cxlmem.h and taking the
> dev pointer directly as well as the iores.

This does remind me that security is just one use case CXL has for
cpu_cache_has_invalidate_memregion(). It also needs to be used for any
HDM decoder changes where the HPA to DPA translation has changed. I
think this means that any user created region needs to flush CPU caches
before that region goes into service. So I like the idea of separate
cxl_pmem_invalidate_memregion() and cxl_region_invalidate_memregion()
with something like:

diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index 1e61d1bafc0c..430e8e5ba7d9 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -1403,6 +1403,8 @@ static int attach_target(struct cxl_region *cxlr, const char *decoder, int pos)
 		goto out;
 	down_read(&cxl_dpa_rwsem);
 	rc = cxl_region_attach(cxlr, to_cxl_endpoint_decoder(dev), pos);
+	if (rc == 0)
+		set_bit(CXL_REGION_F_INCOHERENT, &cxlr->flags);
 	up_read(&cxl_dpa_rwsem);
 	up_write(&cxl_region_rwsem);
 out:
@@ -1958,6 +1960,33 @@ static int devm_cxl_add_pmem_region(struct cxl_region *cxlr)
 	return rc;
 }
 
+static bool cxl_region_has_invalidate_memregion(struct cxl_region *cxlr)
+{
+	if (!cpu_cache_has_invalidate_memregion()) {
+		if (IS_ENABLED(CONFIG_CXL_REGION_TEST)) {
+			dev_warn_once(
+				&cxlr->dev,
+				"Bypassing cpu_cache_has_invalidate_memregion() check for testing!\n");
+			return true;
+		}
+		return false;
+	}
+
+	return true;
+}
+
+static void cxl_region_invalidate_memregion(struct cxl_region *cxlr)
+{
+	if (IS_ENABLED(CONFIG_CXL_REGION_TEST)) {
+		dev_warn_once(
+			&cxlr->dev,
+			"Bypassing cpu_cache_invalidate_memergion() for testing!\n");
+		return;
+	}
+
+	cpu_cache_invalidate_memregion(IORES_DESC_CXL);
+}
+
 static int cxl_region_probe(struct device *dev)
 {
 	struct cxl_region *cxlr = to_cxl_region(dev);
@@ -1975,12 +2004,22 @@ static int cxl_region_probe(struct device *dev)
 		rc = -ENXIO;
 	}
 
+	if (test_bit(CXL_REGION_F_INCOHERENT, &cxlr->flags) &&
+	    !cxl_region_has_invalidate_memregion(cxlr)) {
+		dev_err(&cxlr->dev, "Failed to synchronize CPU cache state\n");
+		rc = -ENXIO;
+	} else if (test_and_clear_bit(CXL_REGION_F_INCOHERENT, &cxlr->flags))
+		cxl_region_invalidate_memregion(cxlr);
+
 	/*
 	 * From this point on any path that changes the region's state away from
 	 * CXL_CONFIG_COMMIT is also responsible for releasing the driver.
 	 */
 	up_read(&cxl_region_rwsem);
 
+	if (rc)
+		return rc;
+
 	switch (cxlr->mode) {
 	case CXL_DECODER_PMEM:
 		return devm_cxl_add_pmem_region(cxlr);
@@ -2008,4 +2047,5 @@ void cxl_region_exit(void)
 }
 
 MODULE_IMPORT_NS(CXL);
+MODULE_IMPORT_NS(DEVMEM);
 MODULE_ALIAS_CXL(CXL_DEVICE_REGION);
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 9a212ab3cae4..827b1ad6cae4 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -388,12 +388,19 @@ struct cxl_region_params {
 	int nr_targets;
 };
 
+/*
+ * Flag whether this region needs to have its HPA span synchronized with
+ * CPU cache state at region activation time.
+ */
+#define CXL_REGION_F_INCOHERENT BIT(0)
+
 /**
  * struct cxl_region - CXL region
  * @dev: This region's device
  * @id: This region's id. Id is globally unique across all regions
  * @mode: Endpoint decoder allocation / access mode
  * @type: Endpoint decoder target type
+ * @flags: Region state flags
  * @cxl_nvb: nvdimm bridge for coordinating @cxlr_pmem setup / shutdown
  * @cxlr_pmem: (for pmem regions) cached copy of the nvdimm bridge
  * @params: active + config params for the region
@@ -403,6 +410,7 @@ struct cxl_region {
 	int id;
 	enum cxl_decoder_mode mode;
 	enum cxl_decoder_type type;
+	unsigned long flags;
 	struct cxl_nvdimm_bridge *cxl_nvb;
 	struct cxl_pmem_region *cxlr_pmem;
 	struct cxl_region_params params;

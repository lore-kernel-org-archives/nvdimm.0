Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5669E2CAB
	for <nvdimm@lists.linux.dev>; Wed, 30 Nov 2022 20:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669841976; x=1701377976;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=qkwI+HUjql6wtPFV/vXOV2sUGLTY+5nfp0j9yZ8eyMg=;
  b=L8AMeAKHmC6LxGbA/1osyK0+pZNCfzpHLzDUPtK8zDEJ086/ogN1ngBU
   awKZdMd/phnKN8U2FhkN54CUgrAlH5Kx1bPcZSNcUUBi4vxQ3IeKvSHL7
   ohmXaNj0pYXB5lADvnDjAbLbAI7j807XM4qCEiKGMGfssCBlfIKea64bX
   9Vkb8285HYIgf/GeHuVzGBDHH8hirUuRzM/hNeZbd6OM44KUtmJKNF1iu
   y7GG+FxxOQwkfvuLvrJ0l9guQ/yyc4UpQHKVP0Irf9z4Tx1OUVONQCLNA
   ek+pM1e111D/YNQyrgzG0c0V50eU+RuWkvxa3hsGPzNjvJ/ZFuh1SCYOr
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="379786716"
X-IronPort-AV: E=Sophos;i="5.96,207,1665471600"; 
   d="scan'208";a="379786716"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2022 12:59:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="786619057"
X-IronPort-AV: E=Sophos;i="5.96,207,1665471600"; 
   d="scan'208";a="786619057"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga001.fm.intel.com with ESMTP; 30 Nov 2022 12:59:35 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 30 Nov 2022 12:59:34 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 30 Nov 2022 12:59:34 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 30 Nov 2022 12:59:34 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 30 Nov 2022 12:59:33 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BBKIYMv4wzozIPc0as6uOpnbZvE5WgkTIBA6ol35T+B8gIEQ/6Y8yhYow1Ctii75Yv3U+j8cPjcCL8jqSluX6/jQJ5Eax/Os2BKiVQ2nFEo6MaDbZOPgeHmhw3aUBJXNLJUxMpJLVUKmeLXurECOj0LOFjGgRwNn4+Sad1DBzqU1KUFZPIUiuAfFKT+qGST4muEKEe9Ulz5m9dBhFsodWRc0SOeyjOz64ADKHbWf+1H/C0BhfY77VEE0dnLEPEw/Ipj6MSYJFFOlrrJZ6qm4//2VDXWkFBgL2GRnordbOLYZ1qZoz8LfkfQdAck4qzp6OZkv1ZqH7EYQ9DYh/wk+qQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FUMtzIVjxrJ+0/wkYqHos9GVndavd6zxboY1lp6nT8c=;
 b=P4hl6ixFdnRHIdugCUvBZWoLsVorHKi4e+JwZhp93jqr4oGH8gSP6DWuVLXSsAcT3+MlYu2hNGsqVfj7hGb/CG7G1TtAKWxk0CxmpwRIxn5FNSJO2B1AMBd9sDH3bbNSPE6xqdr/YKR60eWiBC23+vyLH20t/7gMbZlmXzUCOFhH67XfhBvRvyqG93iZgU0YybMKAmFMPDr7KofokzyhYEtJU0N/YE0vfyixo6ve60h6bCap7ARHMGmeVOZBZJ8kAdfDAzww9+f1b5lfIUmu8H8CyR6emvS/knvbmMUe/NQcLX2e5DGJolLiwbR0Ha/wKrtOl9bPwGVxf1z2h1axPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by SJ0PR11MB5199.namprd11.prod.outlook.com
 (2603:10b6:a03:2dd::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Wed, 30 Nov
 2022 20:59:32 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::340d:cb77:604d:b0b]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::340d:cb77:604d:b0b%9]) with mapi id 15.20.5857.023; Wed, 30 Nov 2022
 20:59:32 +0000
Date: Wed, 30 Nov 2022 12:59:28 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: Robert Richter <rrichter@amd.com>, Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, Terry Bowman <terry.bowman@amd.com>, "Rafael
 J. Wysocki" <rafael.j.wysocki@intel.com>, <bhelgaas@google.com>,
	<dave.jiang@intel.com>, <nvdimm@lists.linux.dev>
Subject: Re: [PATCH v4 00/12] cxl: Add support for Restricted CXL hosts (RCD
 mode)
Message-ID: <6387c43084d69_3cbe029493@dwillia2-xfh.jf.intel.com.notmuch>
References: <166931487492.2104015.15204324083515120776.stgit@dwillia2-xfh.jf.intel.com>
 <Y4Z5G7fpnEw6uTmJ@rric.localdomain>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Y4Z5G7fpnEw6uTmJ@rric.localdomain>
X-ClientProxiedBy: SJ0PR05CA0121.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::6) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1101MB2126:EE_|SJ0PR11MB5199:EE_
X-MS-Office365-Filtering-Correlation-Id: 021a65cf-d828-4033-d6d4-08dad315c6a7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GboFLIiGQW3Fyh5JUgyHpaslXQ8hhoVpzrYREpv8oKJT4cUmB2wrJ/rHAQmyHEwas/0SrMm2TotRSWJPiAyQCck1uR2BYRsVVQN3Stqz6SRJzV+d+E8ZXCSRTHcJRqhZ209QbTZz7qoV0Lt1HO58S34/gr23e0HypU4oSt363d+xTVqOpU7ytr9apf3K9q6QI9dPKNeWDc/T/OOr6mT9ibjMG8VhhNuVnrycorEPRWSUCnmWhSN2rmfydJiO61LQoTjGzbPLDWFwKESDTa1co025NJfN3L635Y65LYVqKESb+qwLBT144bv9vMyOcyKAB5sX1co85X24h53SMm4YHFhoO8ieHZSTJv+RkREiapgjvdCiX4W4XKT60QSQ8fXJVoSDB0AYIIOrqa3hicHQ36ShA3g3EVDItY4mxTbNmbaogzRXCcdj9KIiIcRLR5fVZZYb92+Tmr0hZqTWj9eHgQnP8tyLDa1ZIHFFcPF7njKUpT8Zd2myIgeDyTWvAbKHlif62NQSEViXiXGURC94IfCwt/0iWnN2S/1xFT68HCVn4tMesyWgwQGnTzVyLyEv9a50t/Y+6EQp53Ee6+lFncwUDhCeCBQEc+3UjQ28uB6ZAXX47KRAPpYiVKsPnMfSPc2gYjjDRGT4/EIRf58wVq+VhRNDW+0XRYiO81yaaIn+r9ak440ZbKf5miBl0HLS
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(346002)(376002)(396003)(39860400002)(366004)(451199015)(5660300002)(54906003)(41300700001)(9686003)(6512007)(316002)(110136005)(82960400001)(66556008)(8676002)(66946007)(4326008)(66476007)(38100700002)(186003)(8936002)(26005)(2906002)(83380400001)(86362001)(6506007)(6486002)(966005)(6666004)(478600001)(53546011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Em0uxTJ74wZ6Ex6ucSa/lgfOwZ91B88r60sLYjuqWTJ9OCTP3cRo0wYFTSFI?=
 =?us-ascii?Q?hgBmITtjqRmJ1G+0eIPMxabhGofohsdswviXBtdbfS+ZeHYQRM4YdMdaBb+2?=
 =?us-ascii?Q?3VXHXtiVL6TRCMPAP9Of3WO4DdHrlRkl01gzzUj4oCPYs1AYAnl/OYMG/BtL?=
 =?us-ascii?Q?WftBvhxtIjYjPt3iDnkLdFt1LjIxocKXn3BVHn52B8kUVhNruoNpxmJs2vYe?=
 =?us-ascii?Q?L1kPyxltOYC+DL2z49KGX57YP7RRfSrpLo8N9STs4daCt82iXzUyxVS+ffem?=
 =?us-ascii?Q?qzEn0SCqhxNKzcT6jeGPQjKSny6u9kL9+He4SlOjtaUWnFpi9m1fgQbih50m?=
 =?us-ascii?Q?BiUPv6OKGlo1zgeWKMhLrmrM4ivVvfoVHYWWLh8iY5iijfir9/d85KAaiREt?=
 =?us-ascii?Q?wacRz5Cn3ScJGEO6/gIrf48pGy9BhI5939NiDS83bKL5l0V6lepZLtQ/XMfk?=
 =?us-ascii?Q?E62Tn8gcss671AsONjLgdRZObIQDsQgxy3Ak3Io6+dSKG9JatuuPBqbSnRIR?=
 =?us-ascii?Q?HJ6FBBmJgJGh1WVHTwEPWJSRx7tsEkezw6o1FmdwQyq7byqEMqxxAyBls/91?=
 =?us-ascii?Q?zBGrmN0t9sREFE71EFb/4cRXdB0f3zZDVb7BlEdEh9kI6XkXmu3XZE5WF3q9?=
 =?us-ascii?Q?xgq6KroHOUp2BM91KAy7YGA0dXbfyXEERaM/CRt1rivCSPGJabDBdppa7Rl0?=
 =?us-ascii?Q?peFUnb2pjCJWH0vNeGO8/5JJviwXLbUezBvhrHqP7MZfXuwvcz6RJ35VsXJd?=
 =?us-ascii?Q?9JpbVuwtpRvGzAUad21pRUhnm8cqPS+BACvJEqJez3UUrE2qoJULnbE64kHT?=
 =?us-ascii?Q?YMUx3wg3PDYFU8uBLt+lPEU5C8iZ/ufCYvZk7SP1wPmIXQKdH2NI8bs7Sd3N?=
 =?us-ascii?Q?JNymLh8/1cPrYbKAHpduvbUaQL8l6YGDo3BNVGjNAKhXwibJlm1Boyhvxwy2?=
 =?us-ascii?Q?AVibHm77hRSoQ2EN+lGmb/XAsWAyi2MlcPkNTlK8t74QkQAq/Bkott/NWeif?=
 =?us-ascii?Q?aA91Gj6IlhAoUstTEp36unzTAA/Xd8XxKXvZ6gu5pl4c0cDRlw7D2bhp8VoC?=
 =?us-ascii?Q?1n0il1GqX0fhJQ2chbTPhIuOwHLobjQXImKxhesvxpOKQSsYbHMc64J9yAjy?=
 =?us-ascii?Q?yPU9z/OolDa3zn6aNHiMYLmTApSXhdEGd1KP9pJgzlcAapxKEcQdbEWIbhA4?=
 =?us-ascii?Q?GptNSLJXyFb96Ez2Vsd4dp6b141NeIjklrrJQx+TbUQX6uflnvPNQq/2aQz4?=
 =?us-ascii?Q?UlwBl4qT6HC9q2eB71miapYnoJl3ydLRjzcpBJEBcydTaR6/CsrBvLiSF42Y?=
 =?us-ascii?Q?v6hyG/9kEwXU6/729V90nP4h0Bbv2PMh22+HVNGvhjT33ZRyH7W28fuJ+Shn?=
 =?us-ascii?Q?toYs+mEx3C3t53IdDemOKUm12Fm6nXAv/kd9asbC+YRuzNvIp+HiX1znWPqI?=
 =?us-ascii?Q?D7S1kpqVsq7vTjhMjjnhiCQm47RLcxYU6grTTWRW+81yoUnR+1mmCnhGk4B3?=
 =?us-ascii?Q?IJMNDE186LJHvBxin6kI5WGlXNAWuxrKtSWRgUQ4/dsu8dAbeFZb63k+g592?=
 =?us-ascii?Q?T3t+SJEDCt+t9SCzLswNBCvXBf+uPu9X3SdS7iLi+FPgICKrvLXMfCdPM3at?=
 =?us-ascii?Q?ig=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 021a65cf-d828-4033-d6d4-08dad315c6a7
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2022 20:59:32.1851
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PfCFcf61Xc1jYX4HUwtmOUeClmXTOmDKBNMsa3QDt9vF3P5V/eYhQ6vzi94OSuHuOKlPzibgatbiysB0UVepnrfIYJc0eCXFG2Z2/BIsWts=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5199
X-OriginatorOrg: intel.com

Robert Richter wrote:
> Dan,
> 
> On 24.11.22 10:34:35, Dan Williams wrote:
> > Changes since v3 [1]:
> > - Rework / simplify CXL to LIBNVDIMM coordination to remove a
> >   flush_work() locking dependency from underneath the root device lock.
> > - Move the root device rescan to a workqueue
> > - Connect RCDs directly as endpoints reachable through a CXL host bridge
> >   as a dport, i.e. drop the extra dport indirection from v3
> > - Add unit test infrastructure for an RCD configuration
> 
> thank you for this posting.
> 
> Patches #1-#6 are not really prerequisites (except for a trivial
> conflict), right? I only reviewed them starting with #6.

In fact they are pre-requisites because of this hunk in:

[PATCH v4 10/12] cxl/port: Add RCD endpoint port enumeration

http://lore.kernel.org/r/166931493266.2104015.8062923429837042172.stgit@dwillia2-xfh.jf.intel.com/

@@ -119,17 +131,22 @@ static int cxl_mem_probe(struct device *dev)
                return -ENXIO;
        }
 
-       device_lock(&parent_port->dev);
-       if (!parent_port->dev.driver) {
+       if (dport->rch)
+               endpoint_parent = parent_port->uport;
+       else
+               endpoint_parent = &parent_port->dev;
+
+       device_lock(endpoint_parent);
+       if (!endpoint_parent->driver) {
                dev_err(dev, "CXL port topology %s not enabled\n",
                        dev_name(&parent_port->dev));
                rc = -ENXIO;
                goto unlock;
        }
 
-       rc = devm_cxl_add_endpoint(cxlmd, dport);
+       rc = devm_cxl_add_endpoint(endpoint_parent, cxlmd, dport);
 unlock:
-       device_unlock(&parent_port->dev);
+       device_unlock(endpoint_parent);
        put_device(&parent_port->dev);
        if (rc)
                return rc;

That device_lock(endpoint_parent) in the RCH case locks the ACPI0017
device so that a devm action can be serialized against ACPI0017 being
unbound from its driver. Before RCH support this path only locked
cxl_port objects to syncrhonize with the cxl_port driver. In the RCH
case the port that needs to be locked while the endpoint is attached is
the one owned by the cxl_acpi driver.

This all happens while holding device_lock(&cxlmd->dev). It means
lockdep complains about cxl_bus_rescan() being done under
device_lock(&ACPI0017->dev), since rescan may take
device_lock(&cxlmd->dev), and it complains about the flush_work() in
unregister_nvb() for a similar entanglement. So the initial patches in
this series are all about making it possible setup an unregistration
chain when the root CXL device goes through ->remove().

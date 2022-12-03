Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E5667B
	for <nvdimm@lists.linux.dev>; Sat,  3 Dec 2022 07:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670052508; x=1701588508;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=fjZLzeIIUXsFXVkBZa7YV7sX1BT1wvk3jDMQ6GZOOAE=;
  b=M6woIooXj3UvjhfsrSCAVEFsHLUdzocrmZNvT+EaJ7+VVjKoJgcJF0T8
   guLFUEtkTR0Jlny77Ds6PyjOxYulHt6lFqKblR5RaEbvjlr7GJIzYK88n
   OCj+661hkmnkZam+8QEqIpBVlntSoORIJW3ao+vGLEO2WHJQflju7lBb1
   6FqlhVTwQaFnlPzP5jOYy8hTpfXM0sLQ8ECPgvZdYKDNCvOJTHnWjwjSi
   oSjUIAn9iN0rQVvvDt6T6EiN1dpu+z8lGH2dgqN4heB8sYgjX82doFfnn
   z7D6IzBTVvlpIZdt1qLv4FTwYCtdtWJ+SQWl6jSWcEsso2gRYN08c9AJp
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10549"; a="296459572"
X-IronPort-AV: E=Sophos;i="5.96,214,1665471600"; 
   d="scan'208";a="296459572"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2022 23:28:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10549"; a="638977939"
X-IronPort-AV: E=Sophos;i="5.96,214,1665471600"; 
   d="scan'208";a="638977939"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga007.jf.intel.com with ESMTP; 02 Dec 2022 23:28:27 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 2 Dec 2022 23:28:26 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 2 Dec 2022 23:28:26 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 2 Dec 2022 23:28:26 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 2 Dec 2022 23:28:25 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DEdiSnfdF9Kl7RKimbtEAnzJRdh0qTPD8YYA3ekg/DT3qOyjH5c1OwRT/k/LqEg5lwANIhbsJEgMr4m8MMBbzlDMgD49gK104T8uzUFeE8uSY7KeJaHRIAw+3WCccpGi9tXO+qZQmDWDDcafx3bJWjHq2W1azS1hTRBWROf+NYmlPtD8t4bhetfLaSOhD64WuQxzOEfp9HJcdfSJwh3QzuQdRyHQTQUxEKMEfF5ljZVjj6j5a1wBNtwynVRhf8Ty3VJaJnyO054Gc6x4o0pIFdbB0PQWKgmTTfeiKXoW3VBWrcJEaDoM+UYtWkl0Xq8BFtqWcrKDjisV6qvTCwDJkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8Cx+7OqImBxvPnpc4li7yDg+tQkUZhYmyzHL/l9D6Mo=;
 b=As7I+YGj9CFyF3CPfmFr0E1mFKWQ9PZ/+ewfHOdenUDtmhR/ECJi7pxGqkyfOQ2ihTuVDn39ChKvxBa58thoQ8VbxffY2KFgZlKb0KpE9n5epQ7cBCmTp0GjebjHjc+gc2V4iKbyh+Z1K8hbNyNMTsclhgrFeRIh1q7mXBZEZcgpTVJApI7FdpxVOLbt7hmm646iw/hQn66eZho/Hf/9KAYg713wmF5c5DokNxes/Md+QCha7CV3irAfCwX+0oPG/sM/ixpwfpiLhlVa4lzznwM7uUmfxddzz1jKXil5hizu0lT9/UZHITxpr8Mc9BUD+shHyqaAUDCYKKiyYLs1ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by BL1PR11MB5397.namprd11.prod.outlook.com
 (2603:10b6:208:308::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Sat, 3 Dec
 2022 07:28:18 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::340d:cb77:604d:b0b]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::340d:cb77:604d:b0b%9]) with mapi id 15.20.5880.011; Sat, 3 Dec 2022
 07:28:18 +0000
Date: Fri, 2 Dec 2022 23:28:16 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>, Dan Williams
	<dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, Robert Richter <rrichter@amd.com>,
	<alison.schofield@intel.com>, <terry.bowman@amd.com>, <bhelgaas@google.com>,
	<dave.jiang@intel.com>, <nvdimm@lists.linux.dev>
Subject: Re: [PATCH v6 07/12] cxl/ACPI: Register CXL host ports by bridge
 device
Message-ID: <638afa9033fd6_3cbe0294e@dwillia2-xfh.jf.intel.com.notmuch>
References: <166993040066.1882361.5484659873467120859.stgit@dwillia2-xfh.jf.intel.com>
 <166993043978.1882361.16238060349889579369.stgit@dwillia2-xfh.jf.intel.com>
 <20221202161120.00005be9@Huawei.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20221202161120.00005be9@Huawei.com>
X-ClientProxiedBy: BY5PR16CA0019.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::32) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1101MB2126:EE_|BL1PR11MB5397:EE_
X-MS-Office365-Filtering-Correlation-Id: fc867ab2-bc05-4f42-7349-08dad4fff2e8
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ispp3K01e4DzbIkyajdehaZWlquBmbecMKycCcpvEvu+jRxwhgf1njKnf2ZXsXAvhChOvl5L+eu21SRogzkVOrQl8PnM5crblcnigcb0fh4PFNso9qXWnNi9lCApfCweIxkPyvUlQcuTlEHkw1p33SMmc3jxolkly2YJlrP+S0QQ3vHaA7TqH7OB974jlLBTDXHBUNdSFC0BqRO2QaAD+ZO8zxMaDzhYry7stid4BihByI00Bd0+/YWNtntSWMyhyR+lbYi5K810CgJBIbVBU7t+mTDgoRQqFNOh7slXZXwP3JKIPP1t5cnPCru290aSOo7MqiHeDCA5IEnpe9Qk7aoV8LxQr0Voo5FeN8+TUOoMwIkWiAwUe8QXn8JRW2T2LustabBVj6XexUEsN+zD8fZKLCcXGVH2X6CDQpvyPOcTJ0bzappE8oDiiG2gSIgkc+H4IsNYgNehpSKV3AHC1hZZCoxIX7X/+jsBzGiUIwuoU23SrUNuH6hFvCt1QyMwEiJ8MAg/TmBd/9meWmjcmxuZ8I0gjfNfPkB1Aq83kOOKlI9W1rlYQQ8OkgN3FLsuF/sJ29HTJJAyowsmpbyi6tiSd46sVBRVXaA7FEe+kYAZ1PIeFX3/6gSpVfdzH0s0hWFAnDDS0eUCo4l1i8U6Pw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(39860400002)(136003)(396003)(376002)(366004)(451199015)(110136005)(26005)(316002)(4326008)(8936002)(5660300002)(186003)(66556008)(41300700001)(8676002)(66946007)(66476007)(83380400001)(86362001)(6506007)(9686003)(6486002)(2906002)(6512007)(478600001)(38100700002)(82960400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?E4ikZ3MQh2YiaQ2QojirraUzV5Rh038ZkDtkodkuFX0hNW5rW6xltyZjRPqO?=
 =?us-ascii?Q?N4TCzynQ90tX2pfG/EA5Tp74iyylKCeGfKivMQDyyzdOB7F670EHb0G2V1l3?=
 =?us-ascii?Q?0JCLClVM0L3VaWFjukRAdvbEp/94dicf71nnp9oMgI6GDYUwhCt/R4jFLguc?=
 =?us-ascii?Q?w1XwtyT5yeHJKjDsAUmeKCcybzrMoQzlCxulZ6Vp/kEsQVWp+jV0OXXyKBpE?=
 =?us-ascii?Q?gIai1LUQUvp/UqTVzPtyKWr1tvBll+GOIvf/UM5+mOU2FYlmPBv8VccXUTbz?=
 =?us-ascii?Q?D67MoFNWPjHorNqd4eXDgrJArPoljtCRni9RRpPZPppR+dzXfSqlsb1vrwlr?=
 =?us-ascii?Q?e/IW+OsqDLczb/F35KWTX9Xw0ljFvVfwhCEyGh9hVEoN81qAVktV/eJHT91a?=
 =?us-ascii?Q?4qJ/2s0LXrs69ByMx4ZIpxTdwyxOZkB/Pm4+1vsg5PbTwavhMhRKMEkUTzaF?=
 =?us-ascii?Q?lqKEK+HpRekTLDEgR5rHzLjK0k50iAT32ZNF25V8DZxqH2A2K2varp9YAgHs?=
 =?us-ascii?Q?RITF7zlrno8WXeLQ1TDnW4xeMjTzd/Pt73I1ZzwiHL/GGS1iHD5b/3vqvvp7?=
 =?us-ascii?Q?c/zU4IX8xQb4E1WJYWqnQ9DQHybwTj/8JLpBXmduDC31y9C+9NYtgembgImK?=
 =?us-ascii?Q?7ZW7pwjAdChkA8n0pmkwvQ43AfumoqWe2Rk6y94Dl1paq9hsExFHjbjIzT+N?=
 =?us-ascii?Q?jy+N+1MeR1VyE2wtMZ+2Z8Q1+HiVKbFHRfpreg7j0fLa562f/2vBqvpjwQbN?=
 =?us-ascii?Q?XQVkff6KqgO/EXx67oVaTYPiwGgmEKP46or3ntd+qiMAyL3Dv7FaGpCxs+cZ?=
 =?us-ascii?Q?ZC/QSjHyixnxrv8cmNf1yP+1tzwCFiXu5mf1A5X+oPZceyTtG0HZ7Tma8lLZ?=
 =?us-ascii?Q?BjyS3ENnNg8/rW1pnWBYWYj+0Hf94xCtDlQ5c6zp/HkVT1A/DoIr4HzeNUv4?=
 =?us-ascii?Q?cC9Tp+0dZKPGIYPv+bjcjKDs9sFCVJVnM75upcH5jFsLIWMuNtnZTxK5AtGg?=
 =?us-ascii?Q?iUSd8vScnoOX881lAq2Xa2GSsA9FZrqHzxkUzRvHbPIPMDrF+q7gpqSdfscV?=
 =?us-ascii?Q?hob+c7M2J4B9GYXrvW/V7F7eTB8oILk44Fucb5c/Nu3C1vo4TR2vKvdp8ys5?=
 =?us-ascii?Q?uaWB420aNV43rDa9ZuvNnMOpguWCXG4Rv4u5LuraBZsN1atoZAWvgR1INa+5?=
 =?us-ascii?Q?89Ra0a78i+FC8WhMwELO00iJAvJSBOFPfJ+Q4nR9hMRyQATkkSB1ww99z8WD?=
 =?us-ascii?Q?y8uRr9eItZS1rwn5RRNtr1+Eggh03FfqqIcCiZJQrGA2dDBhQ+CJUiPx7WNf?=
 =?us-ascii?Q?8PUJtckGD6AjxeGyqDHzUFuZmnGKFn1wEtdCVWqnBQsmID59hLAl5qtZmYAt?=
 =?us-ascii?Q?nHzO57WgtMWtlAX0BNHdZahxQvHgWs1dJLERLuCBb6EgEPuYpXxbpi62mnZx?=
 =?us-ascii?Q?d2GL0/hNsc5TwXIxONFjybwcfRnsgU1lqZSh3uvFTMw0rVolO0ySkjKCD7qD?=
 =?us-ascii?Q?jZxphMtDJI4ASL6KfKMyd1DfpB/muaI/QE+MgtYhLJJNtxDSlzXI//W1t+zW?=
 =?us-ascii?Q?cxOtqSfX2m6zsAdN3PhTeRPGkYkM8X6atpWlsmTOXrSEVFbhnADb+oESOivL?=
 =?us-ascii?Q?PA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fc867ab2-bc05-4f42-7349-08dad4fff2e8
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2022 07:28:18.4665
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QHC+tbfusZ1pPTGbk+nsmT+yWFWm200jffjo7SyB7ELmIfoqJVhO0109WCV8AcE3yt47NvWU4+2UtdX0C7JO5FO8bBXjaG1qlwBSQTOx4Cg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5397
X-OriginatorOrg: intel.com

Jonathan Cameron wrote:
> On Thu, 01 Dec 2022 13:33:59 -0800
> Dan Williams <dan.j.williams@intel.com> wrote:
> 
> > From: Robert Richter <rrichter@amd.com>
> > 
> > A port of a CXL host bridge links to the bridge's ACPI device
> > (&adev->dev) with its corresponding uport/dport device (uport_dev and
> > dport_dev respectively). The device is not a direct parent device in
> > the PCI topology as pdev->dev.parent points to a PCI bridge's (struct
> > pci_host_bridge) device. The following CXL memory device hierarchy
> > would be valid for an endpoint once an RCD EP would be enabled (note
> > this will be done in a later patch):
> > 
> > VH mode:
> > 
> >  cxlmd->dev.parent->parent
> >         ^^^\^^^^^^\ ^^^^^^\
> >             \      \       pci_dev (Type 1, Downstream Port)
> >              \      pci_dev (Type 0, PCI Express Endpoint)
> >               cxl mem device
> > 
> > RCD mode:
> > 
> >  cxlmd->dev.parent->parent
> >         ^^^\^^^^^^\ ^^^^^^\
> >             \      \       pci_host_bridge
> >              \      pci_dev (Type 0, RCiEP)
> >               cxl mem device
> > 
> > In VH mode a downstream port is created by port enumeration and thus
> > always exists.
> > 
> > Now, in RCD mode the host bridge also already exists but it references
> > to an ACPI device. A port lookup by the PCI device's parent device
> > will fail as a direct link to the registered port is missing. The ACPI
> > device of the bridge must be determined first.
> > 
> > To prevent this, change port registration of a CXL host to use the
> > bridge device instead. Do this also for the VH case as port topology
> > will better reflect the PCI topology then.
> > 
> > Signed-off-by: Robert Richter <rrichter@amd.com>
> > [djbw: rebase on brige mocking]
> > Reviewed-by: Robert Richter <rrichter@amd.com>
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> Trivial comment inline. Looks fine to me otherwise...
> 
> Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> 
> 
> > ---
> >  drivers/cxl/acpi.c |   35 +++++++++++++++++++----------------
> >  1 file changed, 19 insertions(+), 16 deletions(-)
> > 
> > diff --git a/drivers/cxl/acpi.c b/drivers/cxl/acpi.c
> > index b8407b77aff6..50d82376097c 100644
> > --- a/drivers/cxl/acpi.c
> > +++ b/drivers/cxl/acpi.c
> > @@ -193,35 +193,34 @@ static int add_host_bridge_uport(struct device *match, void *arg)
> >  {
> >  	struct cxl_port *root_port = arg;
> >  	struct device *host = root_port->dev.parent;
> > -	struct acpi_device *bridge = to_cxl_host_bridge(host, match);
> > +	struct acpi_device *hb = to_cxl_host_bridge(host, match);
> >  	struct acpi_pci_root *pci_root;
> >  	struct cxl_dport *dport;
> >  	struct cxl_port *port;
> > +	struct device *bridge;
> >  	int rc;
> >  
> > -	if (!bridge)
> > +	if (!hb)
> >  		return 0;
> >  
> > -	dport = cxl_find_dport_by_dev(root_port, match);
> > +	pci_root = acpi_pci_find_root(hb->handle);
> > +	bridge = pci_root->bus->bridge;
> > +	dport = cxl_find_dport_by_dev(root_port, bridge);
> >  	if (!dport) {
> >  		dev_dbg(host, "host bridge expected and not found\n");
> >  		return 0;
> >  	}
> >  
> > -	/*
> > -	 * Note that this lookup already succeeded in
> > -	 * to_cxl_host_bridge(), so no need to check for failure here
> > -	 */
> > -	pci_root = acpi_pci_find_root(bridge->handle);
> > -	rc = devm_cxl_register_pci_bus(host, match, pci_root->bus);
> > +	rc = devm_cxl_register_pci_bus(host, bridge, pci_root->bus);
> >  	if (rc)
> >  		return rc;
> >  
> > -	port = devm_cxl_add_port(host, match, dport->component_reg_phys, dport);
> > +	port = devm_cxl_add_port(host, bridge, dport->component_reg_phys,
> > +				 dport);
> >  	if (IS_ERR(port))
> >  		return PTR_ERR(port);
> >  
> > -	dev_info(pci_root->bus->bridge, "host supports CXL\n");
> > +	dev_info(bridge, "host supports CXL\n");
> >  
> >  	return 0;
> >  }
> > @@ -253,18 +252,20 @@ static int cxl_get_chbcr(union acpi_subtable_headers *header, void *arg,
> >  static int add_host_bridge_dport(struct device *match, void *arg)
> >  {
> >  	acpi_status status;
> > +	struct device *bridge;
> >  	unsigned long long uid;
> >  	struct cxl_dport *dport;
> >  	struct cxl_chbs_context ctx;
> > +	struct acpi_pci_root *pci_root;
> >  	struct cxl_port *root_port = arg;
> >  	struct device *host = root_port->dev.parent;
> > -	struct acpi_device *bridge = to_cxl_host_bridge(host, match);
> > +	struct acpi_device *hb = to_cxl_host_bridge(host, match);
> >  
> > -	if (!bridge)
> > +	if (!hb)
> >  		return 0;
> >  
> > -	status = acpi_evaluate_integer(bridge->handle, METHOD_NAME__UID, NULL,
> > -				       &uid);
> > +	status =
> > +		acpi_evaluate_integer(hb->handle, METHOD_NAME__UID, NULL, &uid);
> 
> Bit ugly.  Maybe a good case for a slightly longer line!

I just went ahead and shortened @status to @rc since there's no other
usages in this function.

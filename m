Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2049.outbound.protection.outlook.com [40.107.92.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBD30187E
	for <nvdimm@lists.linux.dev>; Fri,  2 Dec 2022 08:21:13 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IJj4pjYAutyXZeIj1rfLf23TvQdOk9DCBjatY9egqseQ6YpY0/r2sqmEWY2RP4ESCdy3fkhPk7Pt9Tm9CXxL16iNgXtLNvYcS69GlfAKo5gvm1Mj7HHuqkgzkw56ZkXycCaBss9FMzMtEgDWK4qgNGCUnfQAJLkWMdWNg3KCNE/xhO/lMbUHzbsozjSm0rmxSidszr2uqSEUdYWccFeJMxH3u8DQqfQB1ZDrZlDiPUDe3YMWLfQjr/4Lqmb81htIrisxeussXlEfaO1PEgSicolRwYVqFHgetlWWKqaBRXy544TyX2P9mMSyoR8FW8plKtF0V1cV8UZd4Iu1iW4xQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wn6HYYtzsrhX5W7n/MtWScLNoubn5Sm1OMmpNvMHMTU=;
 b=dqEU3ng4rPNKiwLyIcr2wc74RKVAVWz1qm3vHNWnxD7rJYCVvp9YohQNwFaZd0utemFvYviFCGfjy1RuB6+4qpbV7uFz/mVUOXbIKHqv3XC5EaUZqo92xSduQiJ3mdWmcFCuy/ZM2Z4D/6gUYZAPdCPAKvR8DIKTbnmqRLRI2rAfJuv4yq3N5qBBmySaXTe+LbmAUvKMacqH+fgPFhGZVvl+XOep+pcQrmwOOW05VIUuZv8mfGLk6cM00zNZuDvWCcgjvkNOEniClkjKIvSX91eS3nN2OO75eJRNEkKgqAHSjXW0kTlmkNjgfdqzESX/7bQ13ItXiDRqfqh/Wtvfog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wn6HYYtzsrhX5W7n/MtWScLNoubn5Sm1OMmpNvMHMTU=;
 b=nPoWvClcBqJ8RSkNtVf1H/89rXvtUEH911uPSi77gP4VAd6tn3IMmEfXomrDTD4kI2CvCEAlnAZT0wN4NqiJe6fER4REY3j7hzKf2WimpyRvF4kAE5JLN1MAaoOnPtKAevqzDJINI66Es76k+gtq0komMO3CoUnObkw9UKzSujQ=
Received: from BN9P221CA0023.NAMP221.PROD.OUTLOOK.COM (2603:10b6:408:10a::11)
 by MW4PR12MB5642.namprd12.prod.outlook.com (2603:10b6:303:187::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Fri, 2 Dec
 2022 08:21:11 +0000
Received: from BN8NAM11FT080.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10a:cafe::be) by BN9P221CA0023.outlook.office365.com
 (2603:10b6:408:10a::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.10 via Frontend
 Transport; Fri, 2 Dec 2022 08:21:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT080.mail.protection.outlook.com (10.13.176.82) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5880.10 via Frontend Transport; Fri, 2 Dec 2022 08:21:10 +0000
Received: from rric.localdomain (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 2 Dec
 2022 02:21:05 -0600
Date: Fri, 2 Dec 2022 09:21:00 +0100
From: Robert Richter <rrichter@amd.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, <alison.schofield@intel.com>,
	<terry.bowman@amd.com>, <bhelgaas@google.com>, <dave.jiang@intel.com>,
	<nvdimm@lists.linux.dev>
Subject: Re: [PATCH v6 10/12] cxl/port: Add RCD endpoint port enumeration
Message-ID: <Y4m1bCugC/6e1LTQ@rric.localdomain>
References: <166993040066.1882361.5484659873467120859.stgit@dwillia2-xfh.jf.intel.com>
 <166993045621.1882361.1730100141527044744.stgit@dwillia2-xfh.jf.intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <166993045621.1882361.1730100141527044744.stgit@dwillia2-xfh.jf.intel.com>
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT080:EE_|MW4PR12MB5642:EE_
X-MS-Office365-Filtering-Correlation-Id: ad760d59-e666-44e2-a371-08dad43e2b65
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	r1v/LddsJv9kJ/8eRvOMeXGRGat3DXn1xEds17r/Um1Z5jviC6GP0gYG3nSzhm8HxMRvZJUzksZX6Ji3jH1kV2QrHQzwDgOuAGncaEycduOyDWfjrREM4Yhnl9w3v9BMsiVI6m3Kakw/V7xAzLtxHXN8+r4OLq9ei/p1DCATOe4xQNK/2uabNAad7sYdsiuBwJ8N+gUpC5R5sSXuUTm3uFC3i0d3PhhXTvHqvRdJW9VQO6yobxi1CyqsiPqvZe1wFhzzm3v0jhWJ54u/4BSIwvVpW4pmNLp1RIjPVJztfA2FgxYUA+ZjxwzV+9hBoCinUsy2GbOPMDjRKRbp1TGRYtpKeNylNXu3v6c5pR9xbCuoBs3taA7HBF1uiJshPf7mc3LYoTH7ztqCbRiXMyP9YrO2bifkEcdd8mypsYp4WXxJQRYX4LfF7rLQoBYy4lqqOx0dK/lK6/XLgvBLwpp/r1aSZzd20uZcBlZCai9CjRe8MskfJ38LJCJvtvedhZjgOalzRUqgNM7zTgjCMa3Clspg7XN3YiK8RDWMHgcSfETrOCc2ejGP5FKwZCpYq4phbA0Wn6K69J/g8b4f5HLiFbbNKbVJ36Jy3rPC4ed1u6P/KkM3ZapHSYgDY/OfEEK71Xl7O+eIzLBqufuPal2xttfZXsEuvV6erqJipwkNP194RjcFxYNS/d7xhIKVos8eQjU4/bsZU3SGy6mI1X4uubJRgscL181vHkas/wWEPlI=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(136003)(376002)(346002)(396003)(451199015)(36840700001)(46966006)(40470700004)(4326008)(47076005)(81166007)(82740400003)(426003)(41300700001)(8676002)(316002)(40480700001)(54906003)(70206006)(6916009)(82310400005)(40460700003)(26005)(186003)(36860700001)(16526019)(83380400001)(356005)(7696005)(336012)(478600001)(70586007)(9686003)(6666004)(55016003)(2906002)(5660300002)(53546011)(8936002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2022 08:21:10.7019
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ad760d59-e666-44e2-a371-08dad43e2b65
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN8NAM11FT080.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB5642

On 01.12.22 13:34:16, Dan Williams wrote:
> Unlike a CXL memory expander in a VH topology that has at least one
> intervening 'struct cxl_port' instance between itself and the CXL root
> device, an RCD attaches one-level higher. For example:
> 
>                VH
>           ┌──────────┐
>           │ ACPI0017 │
>           │  root0   │
>           └─────┬────┘
>                 │
>           ┌─────┴────┐
>           │  dport0  │
>     ┌─────┤ ACPI0016 ├─────┐
>     │     │  port1   │     │
>     │     └────┬─────┘     │
>     │          │           │
>  ┌──┴───┐   ┌──┴───┐   ┌───┴──┐
>  │dport0│   │dport1│   │dport2│
>  │ RP0  │   │ RP1  │   │ RP2  │
>  └──────┘   └──┬───┘   └──────┘
>                │
>            ┌───┴─────┐
>            │endpoint0│
>            │  port2  │
>            └─────────┘
> 
> ...vs:
> 
>               RCH
>           ┌──────────┐
>           │ ACPI0017 │
>           │  root0   │
>           └────┬─────┘
>                │
>            ┌───┴────┐
>            │ dport0 │
>            │ACPI0016│
>            └───┬────┘
>                │
>           ┌────┴─────┐
>           │endpoint0 │
>           │  port1   │
>           └──────────┘
> 
> So arrange for endpoint port in the RCH/RCD case to appear directly
> connected to the host-bridge in its singular role as a dport. Compare
> that to the VH case where the host-bridge serves a dual role as a
> 'cxl_dport' for the CXL root device *and* a 'cxl_port' upstream port for
> the Root Ports in the Root Complex that are modeled as 'cxl_dport'
> instances in the CXL topology.
> 
> Another deviation from the VH case is that RCDs may need to look up
> their component registers from the Root Complex Register Block (RCRB).
> That platform firmware specified RCRB area is cached by the cxl_acpi
> driver and conveyed via the host-bridge dport to the cxl_mem driver to
> perform the cxl_rcrb_to_component() lookup for the endpoint port
> (See 9.11.8 CXL Devices Attached to an RCH for the lookup of the
> upstream port component registers).
> 
> Tested-by: Robert Richter <rrichter@amd.com>

With the one comment below addressed you can also add my:

Reviewed-by: Robert Richter <rrichter@amd.com>

> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  drivers/cxl/core/port.c |    7 +++++++
>  drivers/cxl/cxlmem.h    |    2 ++
>  drivers/cxl/mem.c       |   31 ++++++++++++++++++++++++-------
>  drivers/cxl/pci.c       |   10 ++++++++++
>  4 files changed, 43 insertions(+), 7 deletions(-)

> diff --git a/drivers/cxl/mem.c b/drivers/cxl/mem.c

> @@ -119,17 +131,22 @@ static int cxl_mem_probe(struct device *dev)
>  		return -ENXIO;
>  	}
>  
> -	device_lock(&parent_port->dev);
> -	if (!parent_port->dev.driver) {
> +	if (dport->rch)
> +		endpoint_parent = parent_port->uport;
> +	else
> +		endpoint_parent = &parent_port->dev;
> +
> +	device_lock(endpoint_parent);
> +	if (!endpoint_parent->driver) {
>  		dev_err(dev, "CXL port topology %s not enabled\n",
>  			dev_name(&parent_port->dev));

Already reported: dev_name(endpoint_parent)

>  		rc = -ENXIO;
>  		goto unlock;
>  	}
>  
> -	rc = devm_cxl_add_endpoint(cxlmd, dport);
> +	rc = devm_cxl_add_endpoint(endpoint_parent, cxlmd, dport);
>  unlock:
> -	device_unlock(&parent_port->dev);
> +	device_unlock(endpoint_parent);
>  	put_device(&parent_port->dev);
>  	if (rc)
>  		return rc;

Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2084.outbound.protection.outlook.com [40.107.244.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21CECBA28
	for <nvdimm@lists.linux.dev>; Tue, 29 Nov 2022 20:49:40 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DpqqtXIFBPS5zOVwsJHIANw6uW7TKSpB1eMN5JsKzu+/RSGVH8BcvJg92XRB3Dw+2uOAtvLDx8Wn8gQa3xa95SwkKy6MS2sDOg6Ui0U9c/vGBGRm6RQpE2uwbd4TEGki4nGfgbl3f2YBndsF037oSzA3MEA8I+CGEQZmxbWWs2YSgSOHud2WmtS838FLgC1J5UpwUseiBY3Cnpq1lsEh+3fFk5BJmt+zdLJ12QWFUIvKqhf4rfb3NWEJ74ZeO/BAX13YlBEKolUKnfg/kxhL9QRRK21IJNKRCxGt9/eATS81aJpXaElctpQZXsgS0IAtu9V9eWNqOE/RVe5o4HuBig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ndudEopoFOtzYzFa7Yv98d0CP4MAaa+DV1DYyMPrjJw=;
 b=lOVJDDyNhevBJPqQNqWt81Okjy7Al+bQevtwJUgyE/QJ7jnVhHxsMeR9QxnkuVtzrGzmd0rnFXp1eQlqTYy6JjMMufMjA8J0Gm5p/cLcOvUza/3KszgwYw7E9htXsKCZyKls+tI/O/sjIz70n7DEMdjInPke5u0dvEEC9XOOoSl6afz4kgbAR6vQtWWVQU1ADDv/Tod/LtOnLQF+csJ6SkVpqKLKHIVhZWrjMvXwTuHBjpUaj8OeN3a5V2hUeZUhQQxn1m96NFmct9AGUO2gemnRiYkOSXMxglrJdSIwYWJ7wg89XF5thovVDOrQG/Jatt+IOWD8AgdLcOef8z23uQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ndudEopoFOtzYzFa7Yv98d0CP4MAaa+DV1DYyMPrjJw=;
 b=S4IEHabwS3cfZ9oszXUaGY59AGxfavsECXuLRe6U66DLH/kqPox0gRD4mCTOFPZtGPdcudcwk6jGFr3l4k6pdUsXt6h98hchUYSKXUnvc+piT0z9V3unlHjsGUQtCQRT/svqLuVTP4FnWfNNpIiyWB4fhQgLJLI/FVbsPfkrtSg=
Received: from MW4PR04CA0366.namprd04.prod.outlook.com (2603:10b6:303:81::11)
 by SA1PR12MB6920.namprd12.prod.outlook.com (2603:10b6:806:258::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Tue, 29 Nov
 2022 20:49:37 +0000
Received: from CO1NAM11FT092.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:81:cafe::35) by MW4PR04CA0366.outlook.office365.com
 (2603:10b6:303:81::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23 via Frontend
 Transport; Tue, 29 Nov 2022 20:49:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT092.mail.protection.outlook.com (10.13.175.225) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5857.22 via Frontend Transport; Tue, 29 Nov 2022 20:49:37 +0000
Received: from rric.localdomain (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 29 Nov
 2022 14:49:34 -0600
Date: Tue, 29 Nov 2022 21:49:32 +0100
From: Robert Richter <rrichter@amd.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, <terry.bowman@amd.com>,
	<bhelgaas@google.com>, <dave.jiang@intel.com>, <nvdimm@lists.linux.dev>
Subject: Re: [PATCH v4 11/12] tools/testing/cxl: Add an RCH topology
Message-ID: <Y4ZwXNpwt83puF4W@rric.localdomain>
References: <166931487492.2104015.15204324083515120776.stgit@dwillia2-xfh.jf.intel.com>
 <166931493816.2104015.8749844490243672146.stgit@dwillia2-xfh.jf.intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <166931493816.2104015.8749844490243672146.stgit@dwillia2-xfh.jf.intel.com>
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT092:EE_|SA1PR12MB6920:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b083e3c-81dc-4c3a-070a-08dad24b3a8c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	CUABxWIpz2Dv5dzicZB+SBIl/HpKwv55ciCR4hqbsWIUAiuLhxOybAuhetGY9P1WapKE5zwbwRnGEhJaxwofT5SYM0XBu1KVQaXnuhTMlm4eTJ7/Y7v3WczdOo4xuL0gsx5NHlqKIAO79Z7zSgyhdHF1+fCml6nKA75dHWKbbOWoKIf4EUvEHY1FiX/HD1xFNefaiG/XZ/vaOO8LlfCd3U4/Gst7YWcms6Dr1oGaBHE/VaPjy0tfRJmbrbOpuTJwVrrW0jWP2fYL/xs7YtlOEYXcIzOFXRcEAcD21yAcqPlLYINQvs0qGeDZjhceKgIGP57bRIsdduqM+7GbUiW6HHYJ50BWbQZRm5hOlGb18RCZpWR3g84WMDpcjgudh/kHOr3Axr7oO90iwK345Po1XqylfQr9qE3UD0TtD+d5oKMDSYnmkmqXXzqZi7wBmg5Q/QnAOP0kzEnS3360nz5Hzy53eaRJWGfR7hR8SVpk/+9lpupBZtaH0oxu3Y43MkkpmjiM9xdLKHhGx8pTv2Eg47NTrlbd9VwINCRpnkAy1/9Da9qKp773NCH45dmoLqoDbEsUHiszuJxFUaVPo60W94oy/8sd5Vj8m4FeLVFx+4YeGNqyZzA1GqGFvVcf9yas9aJAtc6WXMVwMrf4DmOkB9R9cwRrKbqAFNtjEZSUJ+OE5mZpn30CXAdwb7Mb+sm+twfHCKd+DfwUJE4NKAQOm0nwF0AHJMJwj4LWDimynsI=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(396003)(376002)(346002)(451199015)(46966006)(36840700001)(40470700004)(356005)(81166007)(53546011)(478600001)(7696005)(82310400005)(9686003)(26005)(82740400003)(40480700001)(70586007)(40460700003)(41300700001)(70206006)(8676002)(4326008)(316002)(54906003)(55016003)(186003)(8936002)(6916009)(426003)(336012)(5660300002)(16526019)(47076005)(83380400001)(2906002)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 20:49:37.1419
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b083e3c-81dc-4c3a-070a-08dad24b3a8c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1NAM11FT092.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6920

On 24.11.22 10:35:38, Dan Williams wrote:
> In an RCH topology a CXL host-bridge as Root Complex Integrated Endpoint
> the represents the memory expander. Unlike a VH topology there is no
> CXL/PCIE Root Port that host the endpoint. The CXL subsystem maps this
> as the CXL root object (ACPI0017 on ACPI based systems) targeting the
> host-bridge as a dport, per usual, but then that dport directly hosts
> the endpoint port.
> 
> Mock up that configuration with a 4th host-bridge that has a 'cxl_rcd'
> device instance as its immediate child.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  tools/testing/cxl/test/cxl.c |  151 +++++++++++++++++++++++++++++++++++++++---
>  tools/testing/cxl/test/mem.c |   37 ++++++++++
>  2 files changed, 176 insertions(+), 12 deletions(-)

One comment below.

> @@ -736,6 +779,87 @@ static void mock_companion(struct acpi_device *adev, struct device *dev)
>  #define SZ_512G (SZ_64G * 8)
>  #endif
>  
> +static __init int cxl_rch_init(void)
> +{
> +	int rc, i;
> +
> +	for (i = 0; i < ARRAY_SIZE(cxl_rch); i++) {
> +		int idx = NR_CXL_HOST_BRIDGES + NR_CXL_SINGLE_HOST + i;
> +		struct acpi_device *adev = &host_bridge[idx];
> +		struct platform_device *pdev;
> +
> +		pdev = platform_device_alloc("cxl_host_bridge", idx);
> +		if (!pdev)
> +			goto err_bridge;
> +
> +		mock_companion(adev, &pdev->dev);
> +		rc = platform_device_add(pdev);
> +		if (rc) {
> +			platform_device_put(pdev);
> +			goto err_bridge;
> +		}
> +
> +		cxl_rch[i] = pdev;
> +		mock_pci_bus[idx].bridge = &pdev->dev;
> +		rc = sysfs_create_link(&pdev->dev.kobj, &pdev->dev.kobj,
> +				       "firmware_node");
> +		if (rc)
> +			goto err_bridge;
> +	}
> +
> +	for (i = 0; i < ARRAY_SIZE(cxl_rcd); i++) {
> +		int idx = NR_MEM_MULTI + NR_MEM_SINGLE + i;
> +		struct platform_device *rch = cxl_rch[i];
> +		struct platform_device *pdev;
> +
> +		pdev = platform_device_alloc("cxl_rcd", idx);
> +		if (!pdev)
> +			goto err_mem;
> +		pdev->dev.parent = &rch->dev;
> +		set_dev_node(&pdev->dev, i % 2);
> +
> +		rc = platform_device_add(pdev);
> +		if (rc) {
> +			platform_device_put(pdev);
> +			goto err_mem;
> +		}
> +		cxl_rcd[i] = pdev;
> +	}
> +
> +	return 0;
> +
> +err_mem:
> +	for (i = ARRAY_SIZE(cxl_rcd) - 1; i >= 0; i--)
> +		platform_device_unregister(cxl_rcd[i]);
> +err_bridge:

platform_device_unregister() is safe to be used with NULL, so we can
have a single entry of this unregister code ...

> +	for (i = ARRAY_SIZE(cxl_rch) - 1; i >= 0; i--) {
> +		struct platform_device *pdev = cxl_rch[i];
> +
> +		if (!pdev)
> +			continue;
> +		sysfs_remove_link(&pdev->dev.kobj, "firmware_node");
> +		platform_device_unregister(cxl_rch[i]);
> +	}
> +
> +	return rc;
> +}
> +
> +static void cxl_rch_exit(void)
> +{
> +	int i;
> +
> +	for (i = ARRAY_SIZE(cxl_rcd) - 1; i >= 0; i--)
> +		platform_device_unregister(cxl_rcd[i]);
> +	for (i = ARRAY_SIZE(cxl_rch) - 1; i >= 0; i--) {
> +		struct platform_device *pdev = cxl_rch[i];
> +
> +		if (!pdev)
> +			continue;
> +		sysfs_remove_link(&pdev->dev.kobj, "firmware_node");
> +		platform_device_unregister(cxl_rch[i]);
> +	}
> +}

... and have a single function for both. This reduces code
duplication here.

-Robert

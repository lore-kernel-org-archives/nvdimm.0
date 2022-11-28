Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2084.outbound.protection.outlook.com [40.107.237.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FCBB2F43
	for <nvdimm@lists.linux.dev>; Mon, 28 Nov 2022 11:45:33 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KO5UzSTO7o4lt0eAUBvFHr223xIlzH2oN0HuX4UUAsqCLf+1KecQcZsHvGgC2t3fykUAelSimtfCev7fSE9zZ4VNEWWfV8RTa19T1dUnOhvOTekPlsJQCBmd+xWd7NphxhTrIS746ScLQS0wfXB9SN8hg87GgzrrJKqoeHmL/JhAvlhP/4WFMFksxpTMfOFbRTqs3LqW5YCtz5HYND6l0FzWocDiwWh+VrztsKtHMqkl+AzMjZ15CwEfKylRWFkejeKdaX4fT1KhTxhXalsBbWC5PVfgZv8MFHGRo0HvDXr4hv7/HCITTOj7/p93X0YOLP31pO7r4KW/YProEdCftQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XBOqeL/mNsyUAYE6xVBVgpxDZ7ic97vjrtm7KywYdgU=;
 b=HJ4aHYeJSRWtHRmafLKa2/kshCr8XEEN5lByF0GArvxREEWKa+lG5QKlpz+r5C12qjoLUGXCh9iRzenk+EtD4Z99FfdCEpP0wrshWbJlYSobRYUgn/Cyff8dBy4Wx6Av+DwngTnVPGrFFDtT6vpn+lqiuwl0X+Zqh3woR18R1Cgkuu1oeaZhUCxG0G+rwzY3mUTe/e/KqRawwxIiJA4TnvtkX7+PPlokoMLku8FRcUXpTdfRKz2ZrzjRfcLJIG5iePTgEIfbANDGqYYihqLH9JwoSIr8cDkQSQnBLrU9RS4Dk/rypxWNf/HGVZTthWU8Q+C+z7lVi24drMXkLBjOCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XBOqeL/mNsyUAYE6xVBVgpxDZ7ic97vjrtm7KywYdgU=;
 b=hP8nzxd0YS1xTi3xPYWNNlS8o01mAyYbgXv6aIAQvpdONp0WMyeyrR93n4MwW6Cl5M3gBtIhxifmeuBl0Ql2/z2n+ql/Zvv9x/zPL/skwbt6+L4zFp5KqmmoPES9dTgmavEzOTxdQtsQBKmWRt7sNuS2s0OmkL8UGStNan3Mlqc=
Received: from MW4P221CA0025.NAMP221.PROD.OUTLOOK.COM (2603:10b6:303:8b::30)
 by MN0PR12MB6128.namprd12.prod.outlook.com (2603:10b6:208:3c4::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Mon, 28 Nov
 2022 11:45:27 +0000
Received: from CO1NAM11FT035.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8b:cafe::a6) by MW4P221CA0025.outlook.office365.com
 (2603:10b6:303:8b::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23 via Frontend
 Transport; Mon, 28 Nov 2022 11:45:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT035.mail.protection.outlook.com (10.13.175.36) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5834.8 via Frontend Transport; Mon, 28 Nov 2022 11:45:27 +0000
Received: from rric.localdomain (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 28 Nov
 2022 05:45:25 -0600
Date: Mon, 28 Nov 2022 12:45:22 +0100
From: Robert Richter <rrichter@amd.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, <terry.bowman@amd.com>,
	<bhelgaas@google.com>, <dave.jiang@intel.com>, <nvdimm@lists.linux.dev>
Subject: Re: [PATCH v4 07/12] cxl/ACPI: Register CXL host ports by bridge
 device
Message-ID: <Y4SfUhw/SiPpayLm@rric.localdomain>
References: <166931487492.2104015.15204324083515120776.stgit@dwillia2-xfh.jf.intel.com>
 <166931491613.2104015.1393432737056891820.stgit@dwillia2-xfh.jf.intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <166931491613.2104015.1393432737056891820.stgit@dwillia2-xfh.jf.intel.com>
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT035:EE_|MN0PR12MB6128:EE_
X-MS-Office365-Filtering-Correlation-Id: 911c6ce0-d8ff-42e6-ff95-08dad1360b6c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Xfq8NUXD6PAUP0lMXu1lRvQT+WjV+zR+tzLy3Oqir47erejSGWUTJ1elD46k0vcm8gOoMfkMeYhBJVHx6wE+WG8yZBLsnXpQY0uY6fSUUqcICj7GfwbRWcs/e2eXz6McAf9z6NQ621F3ZH/6T9JA/tvgkf9osFjG6scv6YrVU1ZyHswkOCLrtnlXxj7nVlLyKS0FHCSrZfsBQGIzL5Uahgs2LbOR9NtNDpvp4byL6O/Up4xtxHb/a7bbmvb+W1XJARQQkbDzxsFOxJGmgrwLk8FXzdkfYUwdw66hddRjNWPUf4uTMmBhunViiNxCpDiD+2acdakOrUgW/alzAjk4cS6cQRXMmMopSxxb/Zi7a9E3TfYi2Nqi3ADvFpHDQ1XXrZlAebPPqI0buh9K4Cgj+HHFo9a8W4+ISzMMehqPGeXyzWLsHoS/eUKMly7t9koP4ksBOm3kMWmp/tstJMO3khXhBiOUvkJ0FeYcSyeQJ23vuCpnQVlKnTqRXVTLBOcVx/bMF0GRXLz9hEjtpfL0QnOndaCH0hnMPKeoQxCC6JXksaaXb/VPa4f95sBTRRJN6/ZVoH+UBWUUYuNHVZVrNLy+2Zod+EIP6lkxrNaAmVZszk365i6/nKN/1UeFk6H8bHj9iWUg+R5ZZq4xtYMIK3bCtF2FcFc22K/Z5CydYc4aqbJDs/rj7v5oVZL8fb2i2cmzcs2nZ5Yo3wH49rLxVFFocQkDOvXNm1d0WSX7/70=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(396003)(136003)(39860400002)(451199015)(46966006)(40470700004)(36840700001)(47076005)(426003)(7696005)(6666004)(478600001)(81166007)(40480700001)(55016003)(356005)(40460700003)(2906002)(82740400003)(83380400001)(186003)(82310400005)(9686003)(16526019)(336012)(70206006)(41300700001)(53546011)(70586007)(316002)(26005)(54906003)(8676002)(6916009)(4326008)(8936002)(5660300002)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2022 11:45:27.4915
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 911c6ce0-d8ff-42e6-ff95-08dad1360b6c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1NAM11FT035.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6128

On 24.11.22 10:35:16, Dan Williams wrote:
> From: Robert Richter <rrichter@amd.com>
> 
> A port of a CXL host bridge links to the bridge's ACPI device
> (&adev->dev) with its corresponding uport/dport device (uport_dev and
> dport_dev respectively). The device is not a direct parent device in
> the PCI topology as pdev->dev.parent points to a PCI bridge's (struct
> pci_host_bridge) device. The following CXL memory device hierarchy
> would be valid for an endpoint once an RCD EP would be enabled (note
> this will be done in a later patch):
> 
> VH mode:
> 
>  cxlmd->dev.parent->parent
>         ^^^\^^^^^^\ ^^^^^^\
>             \      \       pci_dev (Type 1, Downstream Port)
>              \      pci_dev (Type 0, PCI Express Endpoint)
>               cxl mem device
> 
> RCD mode:
> 
>  cxlmd->dev.parent->parent
>         ^^^\^^^^^^\ ^^^^^^\
>             \      \       pci_host_bridge
>              \      pci_dev (Type 0, RCiEP)
>               cxl mem device
> 
> In VH mode a downstream port is created by port enumeration and thus
> always exists.
> 
> Now, in RCD mode the host bridge also already exists but it references
> to an ACPI device. A port lookup by the PCI device's parent device
> will fail as a direct link to the registered port is missing. The ACPI
> device of the bridge must be determined first.
> 
> To prevent this, change port registration of a CXL host to use the
> bridge device instead. Do this also for the VH case as port topology
> will better reflect the PCI topology then.
> 
> Signed-off-by: Robert Richter <rrichter@amd.com>
> [djbw: rebase on brige mocking]
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Patch looks unchanged compared to v3.

Reviewed-by: Robert Richter <rrichter@amd.com>

> ---
>  drivers/cxl/acpi.c |   35 +++++++++++++++++++----------------
>  1 file changed, 19 insertions(+), 16 deletions(-)

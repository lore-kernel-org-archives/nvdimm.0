Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2081.outbound.protection.outlook.com [40.107.94.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F123A29
	for <nvdimm@lists.linux.dev>; Wed, 30 Nov 2022 08:16:43 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jseitvNI8I63G0DI/p8Jcvrb3VZ18geg6abWPfBSF4CwyGTNt+jRR/nWTAtJffONDAOGD1QMDCxWe/igu//hjRs0nVYkZ0RWXHIuvg2jiTKMkGGRciuoNxz3eWRIB0AalhchO4oS5sydDIY8hCP196smQbzmXT+sO4MxxTbGiJvrddquE6iNHgEpk+iABGeGJFJPYYN0gh9X1DuNiADRepDKU8i9ipRr6UpoTnDdJptnvtvQUT18GYQocmBdtqKLYD5Kxo8+NAi88FtACd0rP4T3aM8vZyiurgrq3+L/83MwQVvHlZV+1Jz6yiXmsrsiPk6awd/ioS/b1HTHyzduCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SirpUZr4CB0Y9NbeDZUiTitO21tkgNOg7RqruX9RlNo=;
 b=E+euxxTj9vVqyJbaYcJYaJ0H8vG7Yvm9UkVW3au9tEMrRY8hLYxAef5Be5X25UnYlmjmHxUaWXJsTdFdg2He1IRv/8HwhQb3k4QfWprIK/EzRYvPtRcmnnWYrJEDYcrjHKyNd4cskQuTJyw7z/D5E0EcoEMioTCdzGNaOYH/Vdtp9fAydDSwLF+geccOkgMeYS2COBuOVkD7K47bqL1ouVahCeEtAGXZUzK4rpzo9E865uVbFdSBvVpAYARluiZrL5Cz07sjPkMpZsq0lUz9dfneJyIPwIh1ftVwzcJGdand+SNFFUtEsdyY/TmB9ACsumRonaNqaXEt9NJNuaSGoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SirpUZr4CB0Y9NbeDZUiTitO21tkgNOg7RqruX9RlNo=;
 b=Wflb9foZGMkz6YtbR+3keQ3pE84UH/eJs7q4CcL26CMIyHh9W8m4FO0qF3dKRBpLQ15q21gCX0YTOtrXNpcoSX6VzxH/EssYwaFFTZ53rDQa8s6aCAnx+s81GWt6xqpoQtBU8M8ggObEtViBeYdDOx2APo2aqnraPvzSOxEjCUI=
Received: from DM6PR06CA0032.namprd06.prod.outlook.com (2603:10b6:5:120::45)
 by IA1PR12MB6065.namprd12.prod.outlook.com (2603:10b6:208:3ef::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Wed, 30 Nov
 2022 08:16:40 +0000
Received: from DS1PEPF0000E631.namprd02.prod.outlook.com
 (2603:10b6:5:120:cafe::a6) by DM6PR06CA0032.outlook.office365.com
 (2603:10b6:5:120::45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23 via Frontend
 Transport; Wed, 30 Nov 2022 08:16:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS1PEPF0000E631.mail.protection.outlook.com (10.167.17.135) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5857.17 via Frontend Transport; Wed, 30 Nov 2022 08:16:40 +0000
Received: from rric.localdomain (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 30 Nov
 2022 02:16:38 -0600
Date: Wed, 30 Nov 2022 09:16:23 +0100
From: Robert Richter <rrichter@amd.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, Terry Bowman <terry.bowman@amd.com>, "Rafael
 J. Wysocki" <rafael.j.wysocki@intel.com>, <bhelgaas@google.com>,
	<dave.jiang@intel.com>, <nvdimm@lists.linux.dev>
Subject: Re: [PATCH v4 12/12] cxl/acpi: Set ACPI's CXL _OSC to indicate
 CXL1.1 support
Message-ID: <Y4cRV/Sj0epVW7bE@rric.localdomain>
References: <166931487492.2104015.15204324083515120776.stgit@dwillia2-xfh.jf.intel.com>
 <166931494367.2104015.9411254827419714457.stgit@dwillia2-xfh.jf.intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <166931494367.2104015.9411254827419714457.stgit@dwillia2-xfh.jf.intel.com>
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E631:EE_|IA1PR12MB6065:EE_
X-MS-Office365-Filtering-Correlation-Id: eb767e15-c67d-43f1-5b26-08dad2ab356e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	0WvEYGDJOiVMUiYTU5nU/51qvdjDdauorgHprQq/P82nUErqa2vQNKn6mujuReUSIGrVf4E5L1Cp9Xgw4jtyQmQTWDQCV50qzV7cwcVhJnzcEr3oUafs5H5GyV19YyLSUQ+IhvrFgqyMhPjek6/R5oRWKXKVCZz+Cj49dRT0WGfajJdZV7Ze8SdcNdyPzlfrLr+uwWrB0RkcyKuEQ9RqJCWwqm1MVDHlw9OmQI/0DMYvI8wqLxScfr5ozCC77bykKuqsJyrHWp3S0oXPbj6BbahI3J5uEjiUCaiFrFD2bwiNMK//16L1ASLjvimBnH9xKd0+5zmrOaDix2cr5VoDSPlTFiDZRb+nHBjTahpbLokuLT6+FvS3uADnOHUFY6W4kKqT3Zzv7HeXCVvTij4zDte2s/DlYYegHuVvm+yaW8+0QFl0y5kjesiPQaX2eVzslk1R2nBCVmmTjSTtdP3rE2g5W2oZy17Dyr/YJzBi5V8FE1R+1j29bJB3ueAPUTbJ8ZZmlYzu6bp/W3Bs4o2GK4ichLc1ZyNDRh+LnINm9+zHnf6ilmLOjRyMH7RYDFEA0snpwSYCPBwJsYplvPg81yNlEk1QYukWjG6Xk6SzZ18Z0VwFO/DpvJuV9NCyImsqfqSeDyvCulBj6vlOCYl5JJ2dOMKoCKUautUp+KME0YivSyVjJ6EDpQxqWRcSEYvVPA7uJlZW8SvTaSk89P44mMmzdvdqCUq3PlfWsduTEtQ=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(396003)(136003)(39860400002)(451199015)(46966006)(36840700001)(40470700004)(81166007)(40480700001)(55016003)(356005)(7696005)(9686003)(26005)(41300700001)(8936002)(4326008)(8676002)(478600001)(70206006)(70586007)(40460700003)(6666004)(36860700001)(316002)(5660300002)(82740400003)(2906002)(426003)(83380400001)(54906003)(53546011)(47076005)(336012)(6916009)(186003)(16526019)(82310400005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2022 08:16:40.3230
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: eb767e15-c67d-43f1-5b26-08dad2ab356e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF0000E631.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6065

On 24.11.22 10:35:43, Dan Williams wrote:
> From: Terry Bowman <terry.bowman@amd.com>
> 
> ACPI includes a CXL _OSC for the OS to communicate what it knows of CXL
> device topologies. To date Linux has added support for CXL 2.0 (VH) port
> topologies, hotplug, and error handling. Now that the driver also know
> how to enumerate CXL 1.1 (RCH) port topologies, indicate that capability
> via CXL _OSC. See CXL3.0 Table 9-26 'Interpretation of CXL _OSC Support
> Field'
> 
> Signed-off-by: Terry Bowman <terry.bowman@amd.com>
> Signed-off-by: Robert Richter <rrichter@amd.com>
> Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> [djbw: wordsmith changelog]
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

I have had a reworded version of this in the pipe too, esp. version
strings were dropped in favor of VH and RCD mode. You might want to
consider that one:

-- >8 --

From 260e04d5d34c6d37a1866b73a5e229d1ceddf272 Mon Sep 17 00:00:00 2001
From: Terry Bowman <terry.bowman@amd.com>
Date: Mon, 14 Nov 2022 10:03:30 -0600
Subject: [PATCH v5] cxl/acpi: Set ACPI's CXL _OSC to indicate RCD mode support

ACPI uses the CXL _OSC support method to communicate the available CXL
functionality to FW. The CXL _OSC support method includes a field to
indicate the OS is capable of RCD mode. FW can potentially change it's
operation depending on the _OSC support method reported by the OS.

The ACPI driver currently only sets the ACPI _OSC support method to
indicate CXL VH mode. Change the capability reported to also include
CXL RCD mode.

[1] CXL3.0 Table 9-26 'Interpretation of CXL _OSC Support Field'

Signed-off-by: Terry Bowman <terry.bowman@amd.com>
[rrichter@amd.com: Reworded patch description.]
Signed-off-by: Robert Richter <rrichter@amd.com>
---
 drivers/acpi/pci_root.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
index 4e3db20e9cbb..b3c202d2a433 100644
--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@ -493,6 +493,7 @@ static u32 calculate_cxl_support(void)
 	u32 support;
 
 	support = OSC_CXL_2_0_PORT_DEV_REG_ACCESS_SUPPORT;
+	support |= OSC_CXL_1_1_PORT_REG_ACCESS_SUPPORT;
 	if (pci_aer_available())
 		support |= OSC_CXL_PROTOCOL_ERR_REPORTING_SUPPORT;
 	if (IS_ENABLED(CONFIG_HOTPLUG_PCI_PCIE))
-- 
2.30.2


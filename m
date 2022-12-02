Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2049.outbound.protection.outlook.com [40.107.220.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9A661C03
	for <nvdimm@lists.linux.dev>; Fri,  2 Dec 2022 08:05:52 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UBJ6FKHw/FChlPnydiREl4QNUkIiqmcbkBSR7u0Gy0lIx6fRpVKgfbvmiwHd5MjrKz1RonWWuq9cTKQGVKsOgsfPEUIXcg7Cd4la2aeQT8Odfq8U9SYqdp+V7tR+BQ1Q/cikn+w5t2CIw+2L993ChMXReBmGmkv0bDFt7+Uowqm7W34xK/bG2OCU+FgLS8m0X5i0D/kC5qORNev46BCdrEQOwtEPEWzFHN0bS15hp6MfFx1y5cI2IBMzBS0OSAPuujU+V5NfwFxJ1S6iO2p15EGJZE00DYuROeFlQ8FNYACR8lNE/RyhCFVehMVe7eYgMtlRLnOV3bm4MkZC129HSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aDHfx1IP+y5tMJrLwAkSN5FlbkcywJuBmbLye0hGeWc=;
 b=FaH/h8p5NZrvUWqNIT1kso+9tuV7BAZMB5Kd1XZ1rV9LGG0rczjx4v24JHS7ODuxp6IEywCzkdzZVJ7LIMtfcYUUHkO3APP66LwrwQ1O0s9q+v2yFYyOXDLGBc1GHVfR14Z/HckGKiFArTF1axcxumtS3lMm96ELfQWbuOI0SdONuxRB7NsbTZqoU90p2fZaqGFh4bP+UiwZV44hUqxK4kZSyK1vQORH+jlM1AtvVrX6GSWF7BzD+zKY3egFbWRaKMzyRcKCmYPvzkFsB80DImPjcnh3o9toXdJsUZFROmIL4i7wMb7O3CLPaN3ELn5/IeRSxEbwqh19TOIHuRWKpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aDHfx1IP+y5tMJrLwAkSN5FlbkcywJuBmbLye0hGeWc=;
 b=M620jPajkR6r5g9r4ECQW9zmBIb/SrUMl3+v3XrahZ1ZD0FnvTHKRaX+XMvrEqFRC2RLXvTw8R5Xx0BGkMYFhIiTTRn1ZJ/xVvwKTwnO/SU20cERJDRlxVVEt+A6he/0cUH3v2aUadzGcRbl6YkmdNxIrlv5AULKyCBQHwLBRM4=
Received: from BN0PR04CA0022.namprd04.prod.outlook.com (2603:10b6:408:ee::27)
 by IA0PR12MB8206.namprd12.prod.outlook.com (2603:10b6:208:403::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.10; Fri, 2 Dec
 2022 08:05:50 +0000
Received: from BN8NAM11FT037.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ee:cafe::48) by BN0PR04CA0022.outlook.office365.com
 (2603:10b6:408:ee::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.10 via Frontend
 Transport; Fri, 2 Dec 2022 08:05:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT037.mail.protection.outlook.com (10.13.177.182) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5880.8 via Frontend Transport; Fri, 2 Dec 2022 08:05:50 +0000
Received: from rric.localdomain (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 2 Dec
 2022 02:05:48 -0600
Date: Fri, 2 Dec 2022 09:05:27 +0100
From: Robert Richter <rrichter@amd.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, Alison Schofield
	<alison.schofield@intel.com>, <terry.bowman@amd.com>, <bhelgaas@google.com>,
	<dave.jiang@intel.com>, <nvdimm@lists.linux.dev>
Subject: Re: [PATCH v6 11/12] tools/testing/cxl: Add an RCH topology
Message-ID: <Y4mxWP7nitYpkDwe@rric.localdomain>
References: <166993040066.1882361.5484659873467120859.stgit@dwillia2-xfh.jf.intel.com>
 <166993046170.1882361.12460762475782283638.stgit@dwillia2-xfh.jf.intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <166993046170.1882361.12460762475782283638.stgit@dwillia2-xfh.jf.intel.com>
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT037:EE_|IA0PR12MB8206:EE_
X-MS-Office365-Filtering-Correlation-Id: 1090ded3-633b-4d32-fa81-08dad43c06c9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	XG1jn4iLZsxUndAjEVphn7R6D8YSBbZmjr3vspHW4eO9tYfNDw43QDEaBh5EfMpKLS/IShdP/XTq6RdUmyMMESsLoMTbeKZtMtf15LRSIVufI1CJ9RwId9y3EEUAgWjnvXSVWgRt/x5HAQPhybqjAuhJrlSsgNW+BxTiCB9kOLsPuIDC83TUWtYOo/xG2IHBe0zU3bWBpen/Xj8ZtY3GTvYCzXJTI2sscAxgcK3demRqJGhe3xaRFCyLjuBVoIkpINHt1Igfs9kgONOopJIvi1fYg2k4wprIeVfEGnSuXAxufzNb5Yko5s1joxv7taPRnk7voFEvxITFZyi7XkgfQJOdfAKwMGUFkxHdp6FlZFxs7MexlTdPlRParLdFi8kUdxUWQfmmWEAbDYLRDVrpKFBfvBWLYe+b7N+XrC/p2pjbI0/5rHsaKtrRbsIj34JX+BVelKNdvhX8wLyPHuwoGgbOtL1jaKh6VOmUnYzOU9duOX3nT5RtBVIQjsmwr9rPk8PGUia6fc5GUiwTKTeYmbg80g8OKAxEbiBRk7BRal89ojkbCTpxnsEKwvQPPrvoryZ/37CeZ21sMhrHCoXLGxHwkQcruNpjrF/PU/d+t5xsoycHB866edaCuioNXEEFFrBDJ5FzEEyQje7LAqsUhol8Nb5lKGsyMl/2PB0hbRrqPOOCK4ZnXCPBFu0yrjlH1wTOCUJ1N2fcbr65eEZowzyX/GwzIo/vAk7DmyvDZzw=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(136003)(346002)(39860400002)(451199015)(36840700001)(46966006)(40470700004)(9686003)(70586007)(26005)(53546011)(7696005)(8676002)(70206006)(4326008)(6666004)(478600001)(186003)(16526019)(41300700001)(336012)(8936002)(4744005)(5660300002)(47076005)(426003)(83380400001)(2906002)(36860700001)(40480700001)(55016003)(81166007)(356005)(82740400003)(316002)(54906003)(6916009)(82310400005)(40460700003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2022 08:05:50.2904
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1090ded3-633b-4d32-fa81-08dad43c06c9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN8NAM11FT037.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8206

On 01.12.22 13:34:21, Dan Williams wrote:
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
> Reviewed-by: Alison Schofield <alison.schofield@intel.com>

Reviewed-by: Robert Richter <rrichter@amd.com>

> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  tools/testing/cxl/test/cxl.c |  151 +++++++++++++++++++++++++++++++++++++++---
>  tools/testing/cxl/test/mem.c |   37 ++++++++++
>  2 files changed, 176 insertions(+), 12 deletions(-)

Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2057.outbound.protection.outlook.com [40.107.92.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 679392F43
	for <nvdimm@lists.linux.dev>; Mon, 28 Nov 2022 11:15:51 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fk1rCwU5u7ksgkGUa3kAfq/nHCv26WaEw4i8LJDsNDnINuKe4alrCWTPjXgRfhHEpVhP1vjuidnuabdf+ftbc+GH0YAYnIZS2KrrAvrCgBP5ThfGlqKY0+VlHxyA/Gqqq2Flcp7sVaJunZVjhc4WEQcZhV2mHPnG/BeisEOA+YBrYcvV3iMzSBP5dIgO3+BhotQZq/q9MCjaGgyHXhqDqEr94S6ZcXaUpXLhluIShXZuIR9vCwW9nPAWhBpFAvLsg8Z2cIbk8KOMomf9o/u9jAZnMkI+3e0PU4jFJWPey4gW8xfmwNBQSFOX75zUss5MWbeaI2Tvy1BbNKf0Rrf/iA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zLpH2xIErNZqlqNkxCszRHDdjb42302yxONS8FdCcBU=;
 b=AFcXIj29jFtIkdJ2h5Bnla+2HHwb6zVdTYR4hnPrRuYeEovCQAww8r4Iadat2cC3kVhMS8ufzNMrcPIQtslNIGMW5pKPpYt16alUYjwDqEtorkbDits5aEmcEp+qbP6FQ+NJJG/CXRTietH5c4JYHZ+g7wQHcF/6sJMjFwWfEhhJ70k+KbpxEQyMdiiPi39N53XRd1Ir9IjGlWZe89vw4qMDAVNHFiGz7qI8AXGPJxIwC8sZqnUurqo4ERuhuAwZaXJWKOXjD2Ya/sw2SrC1wU0lYmB89+HYTO7/keaUOKeTDp7ee66Ti/K8eQ93FgMiMinWAldhC0R3fWPkSLM0gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zLpH2xIErNZqlqNkxCszRHDdjb42302yxONS8FdCcBU=;
 b=PO+724f2j4SRO/JZA+WlFr7qCnr2ImhMDGFBuLqxUCzE0oQLDEae3JiD/ikTZoSo06r0DYDTpe5g0Dw4YQJDhQeZQUPTSOjhJhliqyH3ii4fM1LxGMkuGJvuIUYuO5Z4Y9bevw+b7Mwd90rzNSLKR8lWq+7XmXsWanY/l6ZrH1A=
Received: from CY5P221CA0022.NAMP221.PROD.OUTLOOK.COM (2603:10b6:930:b::23) by
 DS7PR12MB5791.namprd12.prod.outlook.com (2603:10b6:8:76::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5857.21; Mon, 28 Nov 2022 11:15:48 +0000
Received: from CY4PEPF0000C973.namprd02.prod.outlook.com
 (2603:10b6:930:b:cafe::9) by CY5P221CA0022.outlook.office365.com
 (2603:10b6:930:b::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.22 via Frontend
 Transport; Mon, 28 Nov 2022 11:15:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000C973.mail.protection.outlook.com (10.167.242.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5857.17 via Frontend Transport; Mon, 28 Nov 2022 11:15:48 +0000
Received: from rric.localdomain (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 28 Nov
 2022 05:14:51 -0600
Date: Mon, 28 Nov 2022 12:13:58 +0100
From: Robert Richter <rrichter@amd.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, <terry.bowman@amd.com>,
	<bhelgaas@google.com>, <dave.jiang@intel.com>, <nvdimm@lists.linux.dev>
Subject: Re: [PATCH v4 06/12] tools/testing/cxl: Make mock CEDT parsing more
 robust
Message-ID: <Y4SX9nzDLGKPgsSD@rric.localdomain>
References: <166931487492.2104015.15204324083515120776.stgit@dwillia2-xfh.jf.intel.com>
 <166931491054.2104015.16722069708509650823.stgit@dwillia2-xfh.jf.intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <166931491054.2104015.16722069708509650823.stgit@dwillia2-xfh.jf.intel.com>
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000C973:EE_|DS7PR12MB5791:EE_
X-MS-Office365-Filtering-Correlation-Id: 68e4035c-f05e-41e3-1729-08dad131e6de
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Vew0/PlZC8xkpT5pCJXeW2rIQGVXQQOyyMFRLVv/x4D+xyN1psBiCemgnkCxnVfFJrPtw2NwtRgv0C3O0tDmwv/p5Ogiwep7K11lSa/dIf0OfJfLVzCAj2WipwBwrKxkcwq+Px1hH8oqOQXQuuqTRAAGSBoX6P4a87Oo1ovhC6wLtNoHahJzK38ALYoNaPwNVjwqlHiFOOdtqPFvj2osfoWAEqys0qnpfYYf4CSLMvmy7aL/dAKBxPq7qJsMEN1PZUR5aayRvhOH2ImsMkHhOblxfQjGdKjBCLVfqNdKjzEeBaagEPkoO2EdNSLa2KXKyk5q2kwViAsYh1SUQOgofwjXrMWKMIBSoMMd4cpXNbw9VYXrbhLKYE3a4wE7wmbErzdBzRdRdndEjB7Cl9emk1IFA1HOG/l5SAUQyQx9s891085aTFEy4ZZ3FaH2nNQ/rr4TR5iS0fCTpza6/Z+sD3c5PJgaorGinqRJIlFay7wRFGJBYUfZJzfDDWycZVKeaZkzhluUm2oNo26gUBtrtJr/arpYgt8M86UVMh0iSy4oXg0VPUQ8XSsQZpkg2FP4aDADytd3ljnMKddaZthSaR7rvRdXyK/4BMgwO74H6BCWAdFKsUZaJHl82UdATwO6no0FBkAR3ZnM4ryTC7TWuOAmMGgdEhXSVHIK0x7lC/U/865vz0uvQ5JWBYvNakovHSqzsDxrgHjB9Y5qz02t1x17rXU4Ks5+SB8m/b/WKgY=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(346002)(39860400002)(136003)(451199015)(46966006)(36840700001)(40470700004)(83380400001)(47076005)(81166007)(356005)(82740400003)(36860700001)(2906002)(16526019)(8936002)(4744005)(4326008)(55016003)(82310400005)(40480700001)(5660300002)(41300700001)(316002)(7696005)(426003)(478600001)(9686003)(336012)(186003)(26005)(53546011)(70586007)(70206006)(8676002)(6916009)(54906003)(40460700003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2022 11:15:48.2170
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 68e4035c-f05e-41e3-1729-08dad131e6de
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000C973.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5791

On 24.11.22 10:35:10, Dan Williams wrote:
> Accept any cxl_test topology device as the first argument in
> cxl_chbs_context. This is in preparation for reworking the detection of
> the component registers across VH and RCH topologies. Move
> mock_acpi_table_parse_cedt() beneath the definition of is_mock_port()
> and use is_mock_port() instead of the explicit mock cxl_acpi device
> check.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Robert Richter <rrichter@amd.com>

> ---
>  tools/testing/cxl/test/cxl.c |   80 +++++++++++++++++++++---------------------
>  1 file changed, 40 insertions(+), 40 deletions(-)

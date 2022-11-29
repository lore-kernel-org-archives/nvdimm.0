Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2048.outbound.protection.outlook.com [40.107.237.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FB1FBA28
	for <nvdimm@lists.linux.dev>; Tue, 29 Nov 2022 21:26:59 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IYcXNPr0/b8Su8g421fhD8NTGVxCWKo5sdIJ4Rl5IETAqLiwlPzZ7Cd5uwG4CX+XUm9qRwsiUjr96frtMnBP9gkvT4QtNKTPgWtwNDJrHloG9Hga3iniq/BOFGOUeNiv7wKvGOnZxul3ZyRixuAexN7j8v7q4QFU85AifQo+I4WnorG1ogjhcVGCJ1SClT0sltFknOwzuRoSrHZlcGkWv8Rw/P8QdPZVPn28T55znr0h3CFeE7sPwh7rRGX/VukbWZ7n/9yNu/PgnxqiTjEHGtcY9tffNea4Qkh5X0A612+vZ2qrDLRPFzr6hAj7PLtsUoamU+VgczWcu30p3EjLTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=neGlu1WbZ5FDqQ/t80VsUceUcSUlDiPvbskpt2PPAXE=;
 b=fHDhzfQSnk95yPD4ABMx3y3aah/5LTz3en7HV/IlD8elPwHx4wLrUcFI3hAvl5c1mBrqTdjly4812/7Cl2HUEHi5EV9IGc2rdmmM2p6WwlWXlJL2LgMssSb7UXCwPLfXe6IbQs11o5dh/PVkxk/p0gHS0zZTMn/kAwiU+VQJrNq/87Mi/NkPFWEWsIG1LxlXiqSTGkpSE5LSG3fI0RAyO3ZgyvkMbcRKg/8pkfcinjOwTlnVnTg49cVlO1EZIjm3mJszglKJ97EpxyKLcAc7RycE6Et3FUtRYMEaRQ1xFEyMhSC0SQPCWMlsElXF35USvZWEOXnIjP0Z8pQo02ribg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=neGlu1WbZ5FDqQ/t80VsUceUcSUlDiPvbskpt2PPAXE=;
 b=NelVUwxvWcBDd3lS8ut8DXERwYNd9h2d5lGm9JzFZid71bEGut++/oJ0nvEnobVSPp0iNSHC/RPXVrxGNxPjgU2Spa01OjtwnJCPv3et/0hgPSF1hzoI9CdhT3jX0fkQ+m8Ezc07JTeO40/PR8lG7qZqaNn2w9wb1gb4aFdGkQY=
Received: from DM6PR17CA0001.namprd17.prod.outlook.com (2603:10b6:5:1b3::14)
 by MW3PR12MB4524.namprd12.prod.outlook.com (2603:10b6:303:2d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Tue, 29 Nov
 2022 21:26:56 +0000
Received: from DM6NAM11FT024.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1b3:cafe::66) by DM6PR17CA0001.outlook.office365.com
 (2603:10b6:5:1b3::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.19 via Frontend
 Transport; Tue, 29 Nov 2022 21:26:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT024.mail.protection.outlook.com (10.13.172.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5857.23 via Frontend Transport; Tue, 29 Nov 2022 21:26:56 +0000
Received: from rric.localdomain (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 29 Nov
 2022 15:26:54 -0600
Date: Tue, 29 Nov 2022 22:26:51 +0100
From: Robert Richter <rrichter@amd.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, Terry Bowman <terry.bowman@amd.com>, "Rafael
 J. Wysocki" <rafael.j.wysocki@intel.com>, <bhelgaas@google.com>,
	<dave.jiang@intel.com>, <nvdimm@lists.linux.dev>
Subject: Re: [PATCH v4 00/12] cxl: Add support for Restricted CXL hosts (RCD
 mode)
Message-ID: <Y4Z5G7fpnEw6uTmJ@rric.localdomain>
References: <166931487492.2104015.15204324083515120776.stgit@dwillia2-xfh.jf.intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <166931487492.2104015.15204324083515120776.stgit@dwillia2-xfh.jf.intel.com>
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT024:EE_|MW3PR12MB4524:EE_
X-MS-Office365-Filtering-Correlation-Id: 89e618b8-aa47-45b1-bcf4-08dad2507167
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	uoVUXQGuX7Jg3XK7NqhWReiEHpp+7a0DhttuZ75Uy945Z3eKywuP3Ylh1as0k6ajzysdjy9An8JVuE8/hkTZlfmKWk/HtR4P30LxvuDt01pTah1aTSWrd6PY0UoXiaoA5CieZ0pW2gppX+zFlDmNb92E7rKofqS7pUI+LJkUdeztHs2c9hVAHul4qfh4+m59j0zp3j+S2rxTslrRTkDDJOjtLz/otYwAUj3RUc6ZAmt9F5bYS4IMdxPWJlPex+uxhneoIew+SKkxRajW35/NuI8aQmB8Ng1lSdrsUW0sGi1Q3ozOP0ucDi7HJJ8cABQuQWK8KBF7/v+Kfm0ABv6C6RXWsGGkFxP1y+lkCMYVy7QY8mq4hu7uPL/RrX3L4Un7QhfPrrpU/rXAeVxo/CZZHyOPArhrgg9ASbXIv+JyHiEMx0o9Yo7qVKjAYxpu7MkgVv/TTc7hsuQWhKwccDuNUssb+kSpV6nlwusjYEJtmf4yFdq4GvNWUnsG/n0m8x4OCPB9b0gNvaSdCp38IH8O2KxzCYJH5zQ55boci+YFIZgR7Lvmc+n+ZkJGlYZ0ew5EWX3R9UlLYWuvTxXdl1M+3uLOWzneNo3Fojtn2w5Ci2TVnE/PSDLLdE9I+hvXLepKfRIKALT+rC0RwJZni4GoGLFy4hGK5icGkqebZ5LreNYP/fzm4CGhnO9Nj4G87UHapOUJf+lIAyhgCMvFQN1AYKbM6eF+bDSfI0xXK7jUEsI=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(136003)(376002)(346002)(451199015)(36840700001)(40470700004)(46966006)(7696005)(5660300002)(70586007)(8676002)(36860700001)(4326008)(41300700001)(8936002)(316002)(70206006)(82740400003)(40460700003)(83380400001)(81166007)(47076005)(356005)(55016003)(40480700001)(426003)(6666004)(336012)(478600001)(82310400005)(26005)(186003)(6916009)(53546011)(16526019)(9686003)(54906003)(2906002)(4744005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 21:26:56.7562
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 89e618b8-aa47-45b1-bcf4-08dad2507167
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM6NAM11FT024.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4524

Dan,

On 24.11.22 10:34:35, Dan Williams wrote:
> Changes since v3 [1]:
> - Rework / simplify CXL to LIBNVDIMM coordination to remove a
>   flush_work() locking dependency from underneath the root device lock.
> - Move the root device rescan to a workqueue
> - Connect RCDs directly as endpoints reachable through a CXL host bridge
>   as a dport, i.e. drop the extra dport indirection from v3
> - Add unit test infrastructure for an RCD configuration

thank you for this posting.

Patches #1-#6 are not really prerequisites (except for a trivial
conflict), right? I only reviewed them starting with #6.

Thanks,

-Robert

Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2067.outbound.protection.outlook.com [40.107.92.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30D73BA28
	for <nvdimm@lists.linux.dev>; Tue, 29 Nov 2022 20:52:36 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hwIqSZtJV0uymWgxBB9JnZhk+u9p6lPWFbcpGpMUobOSn2+a7fEZKmAHnU1N32lHvPgP70S/k91Q6SVTc6HSprtv6yz8tbKvwc2RZEbQf5sB2ppcDPCYADF3VloibgN+NH0rVfbCHnddPwyd+Y/EFDVrBZz9x8nwj/qyge1Jiv/4diQKq9ERPYDa6rxwkfR60FurWHYiFkTRw2D2ftM+fxjl3xUt515AQqOUPTjcr+vObCO67tcieNxgvCmipSha91ijydupGlkrbGdhGgTDWXC6pI9UWABawXoOQYNXUWd1CKTh6rl5dewaQZAM2fAnbABS9QfRijw/cT1UU9rx7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JrnmIxZcQGRvhKd/2CuY8dBZ2mRJPAUZB91xdul9wm4=;
 b=jNETL/K40Ncc6zEBXT6e/37Nw3+1yi6hPASep6mRmzS9APIerYY7cAX2EHXWpT2ct+8EuXywl3WnksYjhEiLep/9h3id59pWwmqqrjWbHr5puLiSEKbS3cnv0QDDwnbPPQ+mGTOcD8Hgn9Lb58Cl5QqUW6mrT8MGKp0Nphx7I6ugmOW9v0vX7MsoCypICx0FNTZ2hZ4pOtNxd22ObcQhkvC2iWUM2D1DEZVFjBj88qggwU7qsinPuN3MQ6IJq01hWUmJQTK3yoKUF6cwwQf4Gh4S6wgnNYT8yQTtRnkKcdRjCAOEaozvD8oyoqROD6z62VKT7RScCw/Z6k8/O6DXOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JrnmIxZcQGRvhKd/2CuY8dBZ2mRJPAUZB91xdul9wm4=;
 b=DOaPSXZ81blSekgB9Z/H+99CyzPBwFm/PYidpCml71wiL3ccC8Pssse0UpS/j5wBOkdQLO5z20gecsyOIEB2Qt0PENfHecF+PjCWGujNFK39BF68VhkbGEkjjUXxMAnkuWOOYQ5LaNnUGk8a4p0+//5qGSCIwbABknFF/s4wst0=
Received: from BN9PR03CA0238.namprd03.prod.outlook.com (2603:10b6:408:f8::33)
 by CO6PR12MB5460.namprd12.prod.outlook.com (2603:10b6:5:357::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Tue, 29 Nov
 2022 20:52:33 +0000
Received: from BN8NAM11FT014.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f8:cafe::80) by BN9PR03CA0238.outlook.office365.com
 (2603:10b6:408:f8::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23 via Frontend
 Transport; Tue, 29 Nov 2022 20:52:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT014.mail.protection.outlook.com (10.13.177.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5857.23 via Frontend Transport; Tue, 29 Nov 2022 20:52:32 +0000
Received: from rric.localdomain (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 29 Nov
 2022 14:52:30 -0600
Date: Tue, 29 Nov 2022 21:52:28 +0100
From: Robert Richter <rrichter@amd.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, <terry.bowman@amd.com>,
	<bhelgaas@google.com>, <dave.jiang@intel.com>, <nvdimm@lists.linux.dev>
Subject: Re: [PATCH v4 09/12] cxl/mem: Move devm_cxl_add_endpoint() from
 cxl_core to cxl_mem
Message-ID: <Y4ZxDEAerS7QGAcZ@rric.localdomain>
References: <166931487492.2104015.15204324083515120776.stgit@dwillia2-xfh.jf.intel.com>
 <166931492718.2104015.1866183528350401708.stgit@dwillia2-xfh.jf.intel.com>
 <Y4UQ85/KAmuaZXFq@rric.localdomain>
 <6385476e94c0f_3cbe02944c@dwillia2-xfh.jf.intel.com.notmuch>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <6385476e94c0f_3cbe02944c@dwillia2-xfh.jf.intel.com.notmuch>
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT014:EE_|CO6PR12MB5460:EE_
X-MS-Office365-Filtering-Correlation-Id: 29f5a8e9-a233-470d-2597-08dad24ba305
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	5rrCOUtjA/JzD+CvPKSJqA0o+2npu2ANr7zVf7kypLmZqNU0TOAuwxkuz3LsGbpCZ46wMu5GCOchmBg32hlIzxd6m3twHwWI+1Y64q+ZYVAFv1VBukwhQP25Lae1+yy4+nzg7fZ1KYmtAIf/dxWWVn66Slxww8l0ulB0iFIk/yMaEBP5uOzPMCbtrbIDCLaDhuB7/gyUG9WGflAPMPVL2zj2/TrVivDSw3Mee7fHiBrtdOUFpLQ/0DW+rM6LKG/0ComUB5cgK1aOS6OUm6IdsNQExHUzBFkMt2ZJGPGJlb55KSDDTqzOgShJfn6F/C8s1cmj+eYkS4sx1ojuI7+g5DWbTqn3nkpeBrb37c9g4GnPk88mAljBmAzHKvB8H+YO6Vj9MFUQcobWncaBvyqNDOoo40Wf/xOkPqQWShLG9S5xDvGSIw1xk1Wt4LOIImphOQML/RHgyJkxRIsY8SmlvkqK/k3hHgeULK2dOHySFHDskyGQ/EkdAK3jZFD00nC+x80xwNEy5CoZM1TZuUNHp8zd5t7ojoONl0y380LpVyOKPxRtS+s4aEOsOXuhk0DxkJCya3Bu74sUGADOXMwFeshkT4vfUIYn5PeNrSJAJiDExR7jPbBalaU6YPTZLzk1YSCy9fP3rivtRNkNsO0xA6aDh/Ab50klgAEIalE2JE6TycIab02Dd1g/aCuaB0x8OHReAmq6QjWDLLYE0/XsLqCmfgbhDRgzjFvxLwMa/Ho=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(346002)(376002)(136003)(451199015)(40470700004)(36840700001)(46966006)(356005)(81166007)(40480700001)(55016003)(9686003)(53546011)(16526019)(70586007)(336012)(41300700001)(186003)(8676002)(8936002)(70206006)(4326008)(26005)(478600001)(40460700003)(7696005)(316002)(6916009)(36860700001)(83380400001)(82740400003)(54906003)(5660300002)(426003)(47076005)(2906002)(82310400005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 20:52:32.5281
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 29f5a8e9-a233-470d-2597-08dad24ba305
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN8NAM11FT014.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR12MB5460

On 28.11.22 15:42:38, Dan Williams wrote:
> Robert Richter wrote:
> > On 24.11.22 10:35:27, Dan Williams wrote:
> > > In preparation for devm_cxl_add_endpoint() to call out to
> > > cxl_rcrb_to_component() to map the upstream port component registers,
> > > move devm_cxl_add_endpoint() from the cxl_core to the cxl_mem driver.
> > > This is due to the organization of cxl_test that mandates that the
> > > cxl_core not call out to any mocked symbols. It also cleans up the
> > > export of devm_cxl_add_endpoint() which is just a wrapper around
> > > devm_cxl_add_port().
> > 
> > The last sentense is unclear to me? I see you just make it static as
> > there is only a single user, do you mean that here? The change itself
> > looks good.
> 
> Yeah, it does read strangely. I changed it to:
> 
>     cxl/mem: Move devm_cxl_add_endpoint() from cxl_core to cxl_mem
>     
>     tl;dr: Clean up an unnecessary export and enable cxl_test.
>     
>     An RCD (Restricted CXL Device), in contrast to a typical CXL device in
>     a VH topology, obtains its component registers from the bottom half of
>     the associated CXL host bridge RCRB (Root Complex Register Block). In
>     turn this means that cxl_rcrb_to_component() needs to be called from
>     devm_cxl_add_endpoint().
>     
>     Presently devm_cxl_add_endpoint() is part of the CXL core, but the only
>     user is the CXL mem module. Move it from cxl_core to cxl_mem to not only
>     get rid of an unnecessary export, but to also enable its call out to
>     cxl_rcrb_to_component(), in a subsequent patch, to be mocked by
>     cxl_test. Recall that cxl_test can only mock exported symbols, and since
>     cxl_rcrb_to_component() is itself inside the core, all callers must be
>     outside of cxl_core to allow cxl_test to mock it.
> 
> > Reviewed-by: Robert Richter <rrichter@amd.com>

Yep, thanks for changing.

-Robert

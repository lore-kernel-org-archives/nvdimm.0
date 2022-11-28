Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2042.outbound.protection.outlook.com [40.107.237.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75C1C29AC
	for <nvdimm@lists.linux.dev>; Mon, 28 Nov 2022 20:35:57 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LxRzJLhvEu5rQbxPJ2PF6tQta67I27yPwrnedbaSHPqHcpvt5uBQcvtUztdaAEFxdIBdMQI6k0C5PeTP7J2zqYKkuTiaJ688uGy/yNKX+/tRVdJxdnIyc3HEztzpmWp3YqBVIPVM/afomMWdJIw8DmOU7PbfKp7iKf5Ua3NxhSiaHFZ5SRj1Eb75FipWMEr06dUzkLB3u2Xj9deqhjSQP3JZXfy6dcvOc171E5lc9UHwwyZ+s8jEnKexez4stBVas6yL4sewEl3c39laDOHy1IwupFyBVPgbKLIxYnfD3ci9RgDel4Jf5rOgcPalG/f/1LThh4mGFfsEqTuTSn/i+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wXAZlbN6xn/Wer7hQdU/vpz+Rmc1AIUqOQFKjGPhFg0=;
 b=dRLW4He+532+KKv03W7tp4zFQcw5k51Df3IZicJaJNe+80+F4Sez9R1bo0U7RcZ6rqzZ+SP9oFvLx+7mblfiYCTZ4dWtOAuq/K4q5QzzVcKLnt+M2RK9INnfX7gQHx2tusfndjJZUPIBBB6nsiyYWNpb41kqugH+OPYGLfWrlZDU8PfZ4ph5+pBNg3B8bjYv3nnCcz4/q/QD2QHWE/E8TWguYothyXANE6zuz18CYR0QXq6ZCc+EeOF7aOdlLk4xQ518vslHoPJcYmU8CBLoQYiWKHlVsegWY/Pcdq5lB2vDvEvZzRWRPOoYOaKq9M4RwbFZMFIzQHFvXY/m50DRVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wXAZlbN6xn/Wer7hQdU/vpz+Rmc1AIUqOQFKjGPhFg0=;
 b=DAWAR5eJWuHWaKuc4+EdVCzcIz+W6ExOCymusEhEJGfW7/2Wt+1v+8Z++B/My3PBMWqyE8H7lLpfRS2jcYrSOHNhzM86HatnILbuPzqsuZzW5Unvg7826TUVvPEah9Bml2Ca9hc1fGaA1riViEV8BY3or8KS44c1WeHKvJBVbkY=
Received: from BN8PR12CA0030.namprd12.prod.outlook.com (2603:10b6:408:60::43)
 by DM4PR12MB7647.namprd12.prod.outlook.com (2603:10b6:8:105::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Mon, 28 Nov
 2022 20:35:55 +0000
Received: from BN8NAM11FT074.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:60::4) by BN8PR12CA0030.outlook.office365.com
 (2603:10b6:408:60::43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23 via Frontend
 Transport; Mon, 28 Nov 2022 20:35:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT074.mail.protection.outlook.com (10.13.176.154) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5834.8 via Frontend Transport; Mon, 28 Nov 2022 20:35:54 +0000
Received: from rric.localdomain (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 28 Nov
 2022 14:35:53 -0600
Date: Mon, 28 Nov 2022 21:35:50 +0100
From: Robert Richter <rrichter@amd.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, <terry.bowman@amd.com>,
	<bhelgaas@google.com>, <dave.jiang@intel.com>, <nvdimm@lists.linux.dev>
Subject: Re: [PATCH v4 09/12] cxl/mem: Move devm_cxl_add_endpoint() from
 cxl_core to cxl_mem
Message-ID: <Y4Ubpkz50vJI1Q76@rric.localdomain>
References: <166931487492.2104015.15204324083515120776.stgit@dwillia2-xfh.jf.intel.com>
 <166931492718.2104015.1866183528350401708.stgit@dwillia2-xfh.jf.intel.com>
 <Y4UQ85/KAmuaZXFq@rric.localdomain>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Y4UQ85/KAmuaZXFq@rric.localdomain>
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT074:EE_|DM4PR12MB7647:EE_
X-MS-Office365-Filtering-Correlation-Id: b32a97e5-60a9-4c0b-c60e-08dad18025eb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	E7zwAeKOB9hT21AsJsTULIi9oeN4gup400hnzJldMd3y1gkTpbsMTcbPFeWPwaiHnX7IiY0ewpnPRkW7MKm8alUp4+FtH5NdR8So3ZopVO33T3MkKRYNOdXryMLbTagRpI7k2OCSH+aIwstaOMeBkbLejdxnvZK+esPmhB4Ua0i1mAIx95+hi0jHMvjG5zLAil1N+wEOwXjeOv4SduCqtO1NXYJXKKHA2c2kSNQ77zsRlL7k7GaW0EfS+W8oueL2Od08nGSjJXRyr4sHmBD/2AtJTIuOaSaYQh1TSozW/p+8vY+2bi0lBOwVeqWHgHyzYL6zwhECSYNWFc8l2qDy0wOCXR9Qi9zcCjS2ExHk1W24diCFAxoaFrxr6wUVNsPC7l5jJktHWbnGrw2cBgAS4PRQsqPMQ3/dSScGkoomblquy9eTx1Ic91r94Ue9rhAyZeoo+7gkyfOUH12DkHVBlz60j7HyA9a71O0DSI+BPKOsjPKu48rNqSPBnWOVUZk0Ntfp315m+Z6WOAnZHxNHQ1QSJL/nsG56pG6uEkkLkYMfxzutojISHINC9DuWIU+Icej3+714y8js2QaCEQKqnoIVoy1VP83cfO0RPKtGVGJPGcQ2n1uyM6ztQImz/dFcI+lZkvaqKT6hO3SN6U9Y0ohiMOHo5mh6T0drLZczqcVX/Tt4qF/nbHpi6WqLp60B/UptxPOS/b2yAql8NX3Prh7BGweBcJHN4enab35oeqo=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(376002)(396003)(346002)(451199015)(46966006)(40470700004)(36840700001)(8936002)(36860700001)(2906002)(6916009)(40460700003)(40480700001)(55016003)(336012)(426003)(478600001)(186003)(82740400003)(82310400005)(356005)(81166007)(5660300002)(83380400001)(70206006)(70586007)(54906003)(316002)(41300700001)(7696005)(16526019)(47076005)(9686003)(53546011)(4326008)(8676002)(26005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2022 20:35:54.8105
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b32a97e5-60a9-4c0b-c60e-08dad18025eb
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN8NAM11FT074.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7647

On 28.11.22 20:50:16, Robert Richter wrote:
> On 24.11.22 10:35:27, Dan Williams wrote:
> > In preparation for devm_cxl_add_endpoint() to call out to
> > cxl_rcrb_to_component() to map the upstream port component registers,
> > move devm_cxl_add_endpoint() from the cxl_core to the cxl_mem driver.
> > This is due to the organization of cxl_test that mandates that the
> > cxl_core not call out to any mocked symbols. It also cleans up the
> > export of devm_cxl_add_endpoint() which is just a wrapper around
> > devm_cxl_add_port().
> 
> The last sentense is unclear to me? I see you just make it static as
> there is only a single user, do you mean that here? The change itself
> looks good.

Looking at the next patch I think you mean the change of the function
i/f of devm_cxl_add_endpoint() here. Please update description.

> 
> > 
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> 
> Reviewed-by: Robert Richter <rrichter@amd.com>
> 
> > ---
> >  drivers/cxl/core/core.h |    8 --------
> >  drivers/cxl/core/port.c |   39 ---------------------------------------
> >  drivers/cxl/cxl.h       |    2 --
> >  drivers/cxl/cxlmem.h    |    9 +++++++++
> >  drivers/cxl/mem.c       |   38 ++++++++++++++++++++++++++++++++++++++
> >  5 files changed, 47 insertions(+), 49 deletions(-)

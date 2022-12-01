Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2042.outbound.protection.outlook.com [40.107.100.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0352310798
	for <nvdimm@lists.linux.dev>; Thu,  1 Dec 2022 22:59:20 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FvAXKTsB2SNpRzbC0kNBq7wHuq3DWoFxSdfK7xmxKA26+yQuYD47ndVOR2EMNNvcLODlO3yYQj3V/wvdXrTaa4WoogVs8sbY0njkge9hF350Shpmm+x/FoAD4JEdmyfm3Nt+g1r0t5d5dxl+OT+2hayHzMOTADh4nzPXrf98HQNa2nyVIbC6GPVAbnNlh3uIn7Ya6QX32WH6j9Bc+cRhn1l1Gy0LEaqWkTIzea/LDe+8d0wkWhvgCRVrJBPhCQ1kGVp70VWdHEG8KR+Gb+bzCC9Ow37HbQlyYuLr9cNBOj1SaBMsXwdyNPz/xa6tKfh4tYga6CNRhGb4gzcIhgV0NA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7eEZmSYPvMTFOP4fQcDQVo7VG/jwgYu6D8H1YOi4nAM=;
 b=VGNU3lmfeXV8z7zjlvrASsEojRkXS2Sw6t8fwZGHdRdpO33jyixURdGQafFa9ROFPWexIaadKMNUnJP5rxhmTfZWisbq2joM+U1GAo9ZNKo2lQuoGhGqC/jApNGCD5apZ36D7VUuuJ6OW4UfyFdxhXv1+vumaFlyPCKuljIW93FheJugU4h1wNmQpb1qKZ8eWk+m6aQWzgziBj8/oSAE6UmC8hKkCxiLWuH0M82J06QESSYYpHQG+v32wurVM7bkVNsPz0rUWFFuMNIIe5N2JOtHBjFgGFP1O0CjfsS0oPAQsieC0oav8wmlShcAs/absCgKAJb+TMwT6kwCU5Glng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7eEZmSYPvMTFOP4fQcDQVo7VG/jwgYu6D8H1YOi4nAM=;
 b=OUK5NLX9dSER8iFrHV/byPx7Lp/gFOcm1Gn3ZKxKzjWPdngT2iH8L1zjLvE/IUoVEWHUzn9UiP72YbceLvxh0WQUkLEgmTfvVBFRu49lGnfbT4mrq3o8C/L0zreTSlnueE7Vdne5O+EfCtAuDco7PqAsXinCSpqEs4OMmAq2w5o=
Received: from BN0PR08CA0005.namprd08.prod.outlook.com (2603:10b6:408:142::20)
 by CY8PR12MB7659.namprd12.prod.outlook.com (2603:10b6:930:9f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.8; Thu, 1 Dec
 2022 22:59:18 +0000
Received: from BN8NAM11FT023.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:142:cafe::44) by BN0PR08CA0005.outlook.office365.com
 (2603:10b6:408:142::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23 via Frontend
 Transport; Thu, 1 Dec 2022 22:59:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT023.mail.protection.outlook.com (10.13.177.103) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5834.8 via Frontend Transport; Thu, 1 Dec 2022 22:59:13 +0000
Received: from rric.localdomain (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 1 Dec
 2022 16:59:09 -0600
Date: Thu, 1 Dec 2022 23:59:06 +0100
From: Robert Richter <rrichter@amd.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, Terry Bowman <terry.bowman@amd.com>, "Rafael
 J. Wysocki" <rafael.j.wysocki@intel.com>, <bhelgaas@google.com>,
	<dave.jiang@intel.com>, <nvdimm@lists.linux.dev>
Subject: Re: [PATCH v4 00/12] cxl: Add support for Restricted CXL hosts (RCD
 mode)
Message-ID: <Y4kxuo/QmlkKiego@rric.localdomain>
References: <166931487492.2104015.15204324083515120776.stgit@dwillia2-xfh.jf.intel.com>
 <Y4Z5G7fpnEw6uTmJ@rric.localdomain>
 <6387c43084d69_3cbe029493@dwillia2-xfh.jf.intel.com.notmuch>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <6387c43084d69_3cbe029493@dwillia2-xfh.jf.intel.com.notmuch>
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT023:EE_|CY8PR12MB7659:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ae3ccef-d3c2-4499-51e7-08dad3efaa3e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Y8RdIYIatOJVyhoQLqSZ2FJI6/Sps/fBOco+tkZf8IncXva4ZSdDjqnFUwOWSdcMS3L9RTvRR1yKf/tbgpCz5f0tLxEqR1Oy/I0Z43opqtgAepUtRCLNkhQNFdLchM826mhtl27p1ROS9SWT3+AZjibOamoXwmYn8M3O2CAMlO5W2/m1uXBjLcNEA7D7uQT5YEsHIwyalayr1R8FBAI6WwM79OGgOSe+muV54v+KJKcuTB2kTQ2feAyuDZsvM6MxpGSaU1SP/TmVoXPrEH3IYRrvsPef5+QVNihVz01NmNJzUp/y7rrgN4pxVAqnEwkzUA2V80ZHhoY1SRpw/258OIxmtLG368RHfMMjsUWbf/vZHioekY9Ji7Zj6erGcsKlYRcPuH+0luQec9cML+yeZEles2+tlddXINU2u2lQnh4TSG6VBRctfOOTbzq9xR6oH5BEDuR1ToQDTd9ScQPsmhEw+kLKgq/0hTLRptCkKtZ/xgf9KPad7kQArej5OOVfVrqjKEFexjOMEj4kh1MKHbi/XLKnfQxdiTo6jgGf/tMGUYCelUCu1nPFKm0GYBoH/lkKxusoiNutU4KLE9aQUVKMEFnyg7AlVsGLA5pAclGZre1iXhaX1vXBQdFwM26jMSxWASALymUhoYXVpEHhCrlsw+XPyV/3UWrGhFYaXvmQm0Dfj8CYhnQiNRGgiEbgzETLncj+WTS+Dnh6QGbUEMwH2UO0Z+/4SDMY4xEynSo=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(346002)(39860400002)(396003)(451199015)(46966006)(36840700001)(40470700004)(426003)(36860700001)(316002)(54906003)(83380400001)(6916009)(47076005)(5660300002)(55016003)(40480700001)(4744005)(40460700003)(2906002)(4326008)(70586007)(41300700001)(70206006)(81166007)(356005)(8676002)(82740400003)(6666004)(8936002)(478600001)(9686003)(186003)(16526019)(336012)(53546011)(7696005)(82310400005)(26005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2022 22:59:13.1014
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ae3ccef-d3c2-4499-51e7-08dad3efaa3e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN8NAM11FT023.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7659

On 30.11.22 12:59:28, Dan Williams wrote:
> Robert Richter wrote:
> > Dan,
> > 
> > On 24.11.22 10:34:35, Dan Williams wrote:
> > > Changes since v3 [1]:
> > > - Rework / simplify CXL to LIBNVDIMM coordination to remove a
> > >   flush_work() locking dependency from underneath the root device lock.
> > > - Move the root device rescan to a workqueue
> > > - Connect RCDs directly as endpoints reachable through a CXL host bridge
> > >   as a dport, i.e. drop the extra dport indirection from v3
> > > - Add unit test infrastructure for an RCD configuration
> > 
> > thank you for this posting.
> > 
> > Patches #1-#6 are not really prerequisites (except for a trivial
> > conflict), right? I only reviewed them starting with #6.
> 
> In fact they are pre-requisites because of this hunk in:

Thanks for the explanation of using device_lock() here.

-Robert

Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2046.outbound.protection.outlook.com [40.107.93.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12B83D53C
	for <nvdimm@lists.linux.dev>; Thu,  1 Dec 2022 22:43:58 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i0mBiW0iUjYsDtyMpdIzAjCVXLJexljD3DZ0RBiND3dZDYiropSB80Ix+qtF2PlZR+ZAWfaqz3cYh8H/8ORv3igL1VRPSOETjJ2wd0XA1kz4n7YKEFyNz9Bo1pv/0DIv/4kJV5GMsXl/egGZaUDElSuTNEPGhFqIQA/eisGRGwEP8rw/TLml5LF95wrXn93rffO1Kx0A0P1FbziRUAum0HuTTUb7yZHYn3uWaWHCOyphRNuvp2ZtjjG3xbMDBAVwCUWTUdu51UD1np7f3Sz6sWyR2a9gswGH1ODY8MVsEWF1g8IgiuT2tf35KiiRp5hxLHSjIIGRSyz0J/57NY3EtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Bs5R6ItSAGrPAJScQsmhc81zZjMxKzNQ7FCfyevsjlg=;
 b=det3qWEw1QkV00mmfICckYE9oE3bpuSMvwYQ23Re4PKjG7qlRz++5DdMKv2pP59vKLNyPmOnNxvRIOFeoK0XvQqhBdzpmjI6yP8Ju4N5FZbTE4q3XaDdDDDhoDAVIh5lZiV8t5gkkqRhmxkG+81pqC44b45AqIYYJKbGjbY5jsYlGcuEcZvj22PvV7Vm8PlkDnYC53ye3yUOe5wlvOJDnlczov4uaPwYhvb8mx08d0SfpUvYyLLxEIf5OBOEJ913Kb2LD4FqWjUlka47VGqVU8A0hpSwK8KtOz66BmW/K4OBpoG0L3E+95FKWKIeUW0ieMrQdKIvn43Hlx+qYqrzyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bs5R6ItSAGrPAJScQsmhc81zZjMxKzNQ7FCfyevsjlg=;
 b=ykhszyzHFVG4ytQbg/AjptYKhHEGKOfoaf8yTSVJXQmKhJIX5uVuhJUQLH2SMrVHhHXzJ1lwrt4Cn/Y5VhwaotH0myWE8VjuPC8sbe7KwuqeumShW1wsCawfgSemXJW/yZl6ZXhAjxF6pqOLNtlXpSZiQVFKICTrHSptuGXsF2Y=
Received: from BN9P223CA0006.NAMP223.PROD.OUTLOOK.COM (2603:10b6:408:10b::11)
 by CY8PR12MB7196.namprd12.prod.outlook.com (2603:10b6:930:58::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Thu, 1 Dec
 2022 22:43:57 +0000
Received: from BN8NAM11FT106.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10b:cafe::e7) by BN9P223CA0006.outlook.office365.com
 (2603:10b6:408:10b::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.8 via Frontend
 Transport; Thu, 1 Dec 2022 22:43:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT106.mail.protection.outlook.com (10.13.177.7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5857.22 via Frontend Transport; Thu, 1 Dec 2022 22:43:56 +0000
Received: from rric.localdomain (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 1 Dec
 2022 16:43:53 -0600
Date: Thu, 1 Dec 2022 23:43:50 +0100
From: Robert Richter <rrichter@amd.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, <terry.bowman@amd.com>,
	<bhelgaas@google.com>, <dave.jiang@intel.com>, <nvdimm@lists.linux.dev>
Subject: Re: [PATCH v4 10/12] cxl/port: Add RCD endpoint port enumeration
Message-ID: <Y4kuJgjes4a+vjuQ@rric.localdomain>
References: <166931487492.2104015.15204324083515120776.stgit@dwillia2-xfh.jf.intel.com>
 <166931493266.2104015.8062923429837042172.stgit@dwillia2-xfh.jf.intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <166931493266.2104015.8062923429837042172.stgit@dwillia2-xfh.jf.intel.com>
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT106:EE_|CY8PR12MB7196:EE_
X-MS-Office365-Filtering-Correlation-Id: 64a70569-f0ad-4288-902a-08dad3ed8818
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	0gPN4wq159HrgdUDXRzyoXV/mP9mdfOQxVJrxPPMG7JtJepEnVwEKvYieCnImrpLKAzQTeV7FHU1/zpGgd3CmUHk4TrXBP8fl9D8/sbbivG9It4Q3vMqwNMBXimcCIcJAd+UyT4zSdOA7hnO4WRROZyDSLSDfzFwkxN3LQz3KVhzqdFpxQ5NiS9RbHzp5E4hKl/hoWor3tue3D++E94LdtH+qZI9eZHppwNiLjYIno4uWmgtAkAYLdLR6b51lpWBn63Xh7dlmOQex98evr6R7THoXR8XJ8wOgIBMFNMKfSAAyCeSfUk1jdHnvX1yOXAhi9iYvvx/NALza4AJEXq9azdoYhvxB5SHTejTELE3LPQPyIqSD9Uyo2BqOr6Fzp+rCqOlbuhyl1iMokc3zotgLyzjbfbQ71rHBMd5SxqNuVzIWZZujYI4eLo63w4OSvp2oxkyWnV+PottepBSVXCErp0024qBkwf57QDQevhGhokOAdu2F60Dl6sRwRullh4l/EGNDz8FbcDXoWFt5K7YFpnVoL9J7n3OX7luYvDV5u50oe9EXYHyBYGFrq8sBQx+2N1pak0MkBnJse9FLxImB0LvfzYDEciU7JaOC6j3ldy2dd6MzfV7Q93DLpX8aW/4Qq/oAo/PRkEi3dldu15rH02Y+jh9IwCD7fiNC3Taml1R2JbM8cfopaBe7AieC9I22RuQPiLTYuo6LkA1KuM4LbmQATaPYZ2l42DTeNjHO+MlRQKGpOjFVSLsnhbhiZcV
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(376002)(39860400002)(136003)(451199015)(46966006)(40470700004)(36840700001)(356005)(5660300002)(81166007)(2906002)(55016003)(82740400003)(8936002)(40480700001)(4744005)(9686003)(6916009)(53546011)(54906003)(70206006)(426003)(82310400005)(26005)(83380400001)(47076005)(316002)(7696005)(41300700001)(4326008)(8676002)(36860700001)(40460700003)(478600001)(70586007)(16526019)(186003)(336012)(67856001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2022 22:43:56.8336
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 64a70569-f0ad-4288-902a-08dad3ed8818
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN8NAM11FT106.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7196

On 24.11.22 10:35:32, Dan Williams wrote:

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

This must be dev_name(endpoint_parent) here.

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

This is correct and the counterpart to cxl_mem_find_port().

>  	if (rc)
>  		return rc;

-Robert

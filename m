Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012008.outbound.protection.outlook.com [52.101.48.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0972386C07
	for <nvdimm@lists.linux.dev>; Wed,  8 Apr 2026 20:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775680364; cv=fail; b=PDTn/2NJVcCBzJHLiyCcwYXh4q49NxyZzl29rlU9ZSFpuT9xleKMKz76js9+ouayvlQ/oihdiNqJiYp7UkLEO3v9DrhJy5k0CZ9CQ+8qiSlJFlqxFf/wD1udJRKYXswjqz6Ad7YAbU3CULI16yjDGW7a0Vs6fn9+UwoGxVTejeY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775680364; c=relaxed/simple;
	bh=O9K7Sus8cqVctJGNPQzqZEsQSO3HkxI9RhklP41plUE=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Bg5e6YbsrXxpawGxRfihIvwEg0rYzzFpqiulf7JkFPdPCyPojz2ktFTCsy/7PcHDe4SfNH5XkDzrx2vgCOnkMeHvXiyBgS/l5tzWuRcbijNSilKdktSW0DE5wVIvf4Aucqpycm1T2HOgE3WSrtVhEMteWz8U+s1hyFEWKRiXh74=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=25CBD0ZR; arc=fail smtp.client-ip=52.101.48.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="25CBD0ZR"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FPyIZEAsno6eMovqvn/uzyW6+9658jPi9cEJlWvCnPWboJKqhCAoF9AFOz9zJuEAHjgV/LEV758mhCDcuI2faENPfMmeSS0dL5VGr/YqcqZfWnEqRluyx3D/O3zYRTFURHgrHoRXckPFdFZ4f0cRKsgo9D9gSEV/Zl4SKFU4xVXPQNAWf3eyGfNd+TmC4pNITHkUcmhBhl1lz3WTjgdQpnm4XLrWWgYw5xsW5+HaHy1pPuBEfdXu1mLkGp+D2XEaOx/iRBBvpi2YBFRTmxW2F+76QRHa78BD00AdkMc/xM1u4YDyG12PKbYRSJTAd0senpe8NKnogIxAljSAEQRvKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bDu82FVz6zlkm/ylkKXt0BuOpa2FqbmZzk+6DPpO8QY=;
 b=cQZ/t0sF2IAom+e6ZrJKEE3OKTQaEPVRPM9/Ac2aNUSBjnseou8V3zyQIMpmHqbTpgs4qtv/RxJwUV/LKk5ttsyHLZFbsFZZ5kzUptMeuV0DT7EY/oZaXaS/mHA3iz0UFlx/4VAtWPDag6MlE2gGuO9gqbBbmdIlSztSzb8RClL31EQvkj0DzaUAYXJUquhVxyqsxICa+Z1+9U/J1IyxgFlkbcLvnTrM0RC5G0Cr1D4+AfGkkhzFwiSfUabUpo8e6RHUq65K8vjA/T8/XRS5e0QyyLa13G/brG43nDe1Dei/mnQYCTLA/kK7S/oCOg+pyMqOlqY9JoHkvPS/hR67ZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=stgolabs.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bDu82FVz6zlkm/ylkKXt0BuOpa2FqbmZzk+6DPpO8QY=;
 b=25CBD0ZRc5zKXze5FcbGRk1Wy0lzdEHZyZyb/5Jyx8ui5hnwNKzZjV1WztSpCDeviBzOCRXtTy+vTxl0isfce6L5cLCuqEXxHhVHsr+ZCIAE792KW921XJBbH8l1jZfmEjJo76RdpAst2FPhzsRVx+BMVsUntALF6hWLDYEyjz0=
Received: from BL1PR13CA0071.namprd13.prod.outlook.com (2603:10b6:208:2b8::16)
 by CY8PR12MB7633.namprd12.prod.outlook.com (2603:10b6:930:9c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.19; Wed, 8 Apr
 2026 20:32:38 +0000
Received: from BL6PEPF00020E5F.namprd04.prod.outlook.com
 (2603:10b6:208:2b8:cafe::26) by BL1PR13CA0071.outlook.office365.com
 (2603:10b6:208:2b8::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9769.37 via Frontend Transport; Wed,
 8 Apr 2026 20:32:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL6PEPF00020E5F.mail.protection.outlook.com (10.167.249.20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9769.17 via Frontend Transport; Wed, 8 Apr 2026 20:32:38 +0000
Received: from ethanolx7ea3host.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 8 Apr
 2026 15:32:37 -0500
From: Terry Bowman <terry.bowman@amd.com>
To: <dave@stgolabs.net>, <jonathan.cameron@huawei.com>,
	<dave.jiang@intel.com>, <alison.schofield@intel.com>,
	<dan.j.williams@intel.com>, <shiju.jose@huawei.com>, <ming.li@zohomail.com>,
	<Smita.KoralahalliChannabasappa@amd.com>, <rrichter@amd.com>,
	<dan.carpenter@linaro.org>, <PradeepVineshReddy.Kodamati@amd.com>,
	<lukas@wunner.de>, <Benjamin.Cheatham@amd.com>,
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <nvdimm@lists.linux.dev>,
	<alucerop@amd.com>, <ira.weiny@intel.com>
CC: <linux-cxl@vger.kernel.org>, <terry.bowman@amd.com>
Subject: [ndctl PATCH 0/3] Enable CXL protocol testing
Date: Wed, 8 Apr 2026 15:32:28 -0500
Message-ID: <20260408203231.962206-1-terry.bowman@amd.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF00020E5F:EE_|CY8PR12MB7633:EE_
X-MS-Office365-Filtering-Correlation-Id: a01643da-2d73-452c-575a-08de95adf9a8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700016|7416014|82310400026|1800799024|921020|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	F2TodULu5Tg2skJPTo0Bb4Coy4W4/2njN6z7aINyKM7puky95LwJmiB8rQAbvOcz19jJWC/G5QZ/zyXWp25i3f5FwHmIq7sKMmCVhse442wHsoZfN4xXY9Da6bm4WQYhuBJPR8vnBTwFTaNw43BooSsXSCpNs+9vXv6s7eb+EkNdjfGdmdb6IFetzya5USR4InLbpTO+akd649rKMHQhSU0LxJ75r4DCbIYJJHHrxDhrC/Me6+jo7Nm1aRPhFl0P04mw8rI2xZbegevAB1Fvc6X14NN06KQnQmIZ2es7B6tbd2LLidPHLQIse3tbdiBa5wHwQP/3CYJdhRrRqp7RKdSh1bdLU+kn3XDz32iDTujOETowT3kO4MUYeZVbRMI4udMnvmFOZ41/QApamcR2OHuJC2+jLk6pPo1euNzGOpXijqjJ0B+3Rs6j9MzMG/iA2JxotmswP26dwFFpruZMEfDjSkLTgklPnX4er6KGqRKHkdi1zY7mkWS9kfBLGrkztgQ/yqWm4xQeSlHCruRbFTn9TcBfxoU1PVXZh9nm+tn7tMebYx4UX2t72nJgiP8o5j42FTUfaErTHcsDC23eBBtHJbHMJDI6OpOtHsjWYAxXS2CVXnMSPZNS8+xSqqUPWl6lGPSz4xyxSAElKNxy3YK0cZ4UOb/d+z232E5sLaD1UYr0sj2QM5qqwJqk+UK5ex84pczU0FzAmgC4xZbLf77c4atEGfxy/AgzK8mAyOkUxh3cHoXba4q2SIdIL9TKU+/4bLinFTT8rlH2ms1HWuz6HYC2R2XbqTQUnCPsSsk9OvzKwyl9flYROtGAIKLa
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(36860700016)(7416014)(82310400026)(1800799024)(921020)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	EuTzxErsUg7XbZnOj89AamphJd2Ett9WXDIYIx1dKliGuJcL7H67QLtfr7oKDlsyYLia3/hhsONNP1wFsiKMNAnNqQaDp0dXbfsr4jrJMQWrH7kYXE+raF6vvt3qcKwk6j1l5jFBt/6bQlnaM12k4b78yYpL+mT62dFFhMZtdbKtne66CN9metN/ARxSaaeLZ6QWiJbSmcoeXwh5HOm0DSM6tAvXNT92AmG6lsDqAT879HSm5Qn/sZ3kqE9E0a3pYsqJHMDy49HkzMv+wLJhwOMMbPa1LfJb/Dqqku2EhXnNb1oHRJwl/uOHL3hMPMvgquOaKFAfFeyg60FJke5Nnyj5+l1RLf//QyxQDLRjFr3s28bFoaIZaaQcBGE36/2hzMynJ1YnXBGos5V8lFekdbt0m8W0Fft51158FEeM0f5Fo0l8rUzyNqsavmEWitwf
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2026 20:32:38.3186
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a01643da-2d73-452c-575a-08de95adf9a8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00020E5F.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7633

Current CXL error injection (EINJ) only supports Root Port protocol error
injection but a method to test all CXL devices is needed. This series
outlines methods to update both the kernel and the 'aer-inject' tool-without
relying on EINJ-to enable CXL RAS protocol error handling across all CXL
devices.

The first patch provides the scripts to enable and trigger AER protocol
errors. This patch also includes the README.md with install details.

The second patch enables correctable and uncorrectable AER internal error
handling in the aer-inject tool.

The third patch is a kernel patch to set the RAS status in the handler. 

Terry Bowman (3):
  test/cxl: Enable CXL protocol error testing using aer-inject
  test/aer-inject: Add aer-inject correctable and uncorrectable interanl
    error support
  test/cxl: Force RAS status in cxl_handle_cor_ras() and
    cxl_handle_ras()

 test/contrib/cxl-aer-einj/README.md           | 80 ++++++++++++++++
 ...Add-internal-error-injection-support.patch | 91 +++++++++++++++++++
 ...AS-status-in-cxl_handle_cor_ras-and-.patch | 51 +++++++++++
 .../cxl-aer-einj/scripts/ds-ce-inject.sh      |  4 +
 .../cxl-aer-einj/scripts/ds-uce-inject.sh     |  4 +
 .../cxl-aer-einj/scripts/enable-trace.sh      |  5 +
 .../cxl-aer-einj/scripts/ep-ce-inject.sh      |  4 +
 .../cxl-aer-einj/scripts/ep-uce-inject.sh     |  4 +
 .../cxl-aer-einj/scripts/root-ce-inject.sh    |  4 +
 .../cxl-aer-einj/scripts/root-uce-inject.sh   |  4 +
 .../cxl-aer-einj/scripts/us-ce-inject.sh      |  4 +
 .../cxl-aer-einj/scripts/us-uce-inject.sh     |  4 +
 12 files changed, 259 insertions(+)
 create mode 100644 test/contrib/cxl-aer-einj/README.md
 create mode 100644 test/contrib/cxl-aer-einj/patches/0001-aer-inject-Add-internal-error-injection-support.patch
 create mode 100644 test/contrib/cxl-aer-einj/patches/0001-test-cxl-Force-RAS-status-in-cxl_handle_cor_ras-and-.patch
 create mode 100755 test/contrib/cxl-aer-einj/scripts/ds-ce-inject.sh
 create mode 100755 test/contrib/cxl-aer-einj/scripts/ds-uce-inject.sh
 create mode 100755 test/contrib/cxl-aer-einj/scripts/enable-trace.sh
 create mode 100755 test/contrib/cxl-aer-einj/scripts/ep-ce-inject.sh
 create mode 100755 test/contrib/cxl-aer-einj/scripts/ep-uce-inject.sh
 create mode 100755 test/contrib/cxl-aer-einj/scripts/root-ce-inject.sh
 create mode 100755 test/contrib/cxl-aer-einj/scripts/root-uce-inject.sh
 create mode 100755 test/contrib/cxl-aer-einj/scripts/us-ce-inject.sh
 create mode 100755 test/contrib/cxl-aer-einj/scripts/us-uce-inject.sh


base-commit: 8ad90e54f0ff4f7291e7f21d44d769d10f24e2b6
-- 
2.34.1


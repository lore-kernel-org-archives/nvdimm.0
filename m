Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2075.outbound.protection.outlook.com [40.107.220.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DED7314F88
	for <nvdimm@lists.linux.dev>; Mon,  7 Aug 2023 21:36:45 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iAZ2DyGoWPCDoMKZg1kW+RHLUzfKXyMJm8vxOe28NE2ZdwWcr3KUun1vSfkxbdANegEgzfXrzlUlCre+941Tn8J8i1cu0hes7HjuB+bSe4Vora56WocTe80fHgrWgAQEPYwwwUv4dEwyJC0EzbPiMiA7D1hIBkJX3/WptD0dJ3S8ZLYO38Wr+B+udIQL+/tHQhutSXKn0dzRZtpA8pJGYafdZjpVcuQBzwfTLW0tnKlgxPLUR7IURWiHLWFg+yDF1BmG83XR2gEqODATjGr9HwE71MxapOTZ5IENuk3YneWEUotoyM2VjEV9K7r85BskhVw92o9QymtaekA4dTNY/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qf566Qqip+T9mWy9bD13fRTljv7KZgVVGEv/LXfm6wY=;
 b=E67cGvxUgjoYbZcTQiL/Qj24bnCGd/ERk+ZK+KWCfMDSxlw4gFlw7fn0gr7Zd/lk+q1f1uEJKv0wK7cg9ckt0FBRL5Bpv/DPZYH9nwHYLZGyilFHK2XcEqIN7VEn/T8WAODkhGstoQfbQzvnt+fV5vL7ntZ4yDqvZCYAHjqV9cXorz6f1d2iRAo2mLF7JxiW+aYtAiK+034MOaCXOUtdrTGNEssshPLL7lW0NfFF7CqgxHpIIdMj0zmJYJbohuKzjpPFjrmFQxJccIXD8WkX6Qm6xwfOGGgV+tKL9+ut+98UUaS+iubhA5k7iMYxpJ9OL71LDm6Lj9QdYEfS+fnqKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qf566Qqip+T9mWy9bD13fRTljv7KZgVVGEv/LXfm6wY=;
 b=yy9qAZFEmmliahoTwfwVvI6lKkQelRRvXm8wARu0HuCS5Z+B8NeaENJhliLUVUATmH1Amaf+T7lqF74dhEGfqOsjJXT3j5ihvN5XuAeXsVfRKO5JS1KLR9+Z8/3LK0F84IOgAfVMEK/4+qCRBZjAW7r1bB2JN7PkWSsD+sDrzYo=
Received: from SN6PR2101CA0006.namprd21.prod.outlook.com
 (2603:10b6:805:106::16) by DM4PR12MB7599.namprd12.prod.outlook.com
 (2603:10b6:8:109::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.26; Mon, 7 Aug
 2023 21:36:42 +0000
Received: from SA2PEPF00001509.namprd04.prod.outlook.com
 (2603:10b6:805:106:cafe::6e) by SN6PR2101CA0006.outlook.office365.com
 (2603:10b6:805:106::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.0 via Frontend
 Transport; Mon, 7 Aug 2023 21:36:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SA2PEPF00001509.mail.protection.outlook.com (10.167.242.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6652.20 via Frontend Transport; Mon, 7 Aug 2023 21:36:41 +0000
Received: from ethanolx7ea3host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Mon, 7 Aug
 2023 16:36:40 -0500
From: Terry Bowman <terry.bowman@amd.com>
To: <nvdimm@lists.linux.dev>, <dan.j.williams@intel.com>,
	<dave.jiang@intel.com>, <vishal.l.verma@intel.com>, <mav@ixsystems.com>
CC: <terry.bowman@amd.com>, <linux-cxl@vger.kernel.org>
Subject: [ndctl RFC 0/1] cxl: Script to manage regions during CXL device hotplug remove-reinsert
Date: Mon, 7 Aug 2023 16:36:34 -0500
Message-ID: <20230807213635.3633907-1-terry.bowman@amd.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF00001509:EE_|DM4PR12MB7599:EE_
X-MS-Office365-Filtering-Correlation-Id: 088b31bc-3aad-4693-611b-08db978e6399
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	OKFM8C4gRuC0gLqNJpA9dyMWKHPvP0cZ847Tx9x7vN+QXqQ5E/06voJokC6t0WiU8cmO/8q+dBvfeSXT6TQVYH4zrZcglHqnFGxFbRYIbvDXKCImT8fO1q8Zlg4LqBHRRPl1/bJOd5hgLPmEeb+c0P80RTEEEzJ4MdEQLXxxR+WaZWpOE0oSIh5UOYeoKgvdlSSHkCWl/HF7BD4BSn8QhfInQQGVFqHM3cyekRA0u1DwYO6G9h7Evqt33Xl9j8+Gqd7CRxDHb/IiMGhuS7xbBGwD/kFZfdYmRa277+YXhlFQARF+3fYaqYfNqvm9AbWwHC8kXv+vxg5Ygb6Mm5KQBK2GVkQ27Vf5mW0PmPk2sQBUD4eDoNa4dukP2iCDV2cHXNbuT65g5qjNQUNfaHnmsi3y/7YqwPDWdRVFcxNL4Lpsc/c2SR/o+FGnncumE2UO5D6FzeAjBIdq8ThL+JI60WNiauV1auirlPTW0CIllmei/QNuW6CKz8TqRSubHbdd2fhgMtIBritS2dE9H/0yQ5wRERzswa/khLWkyDnMnn1EXO+PRDWBgpNXcowvQkysO9XN9k5iqfsHzSmoO4bh8KfnZhZKwNLeLs48Cz8dpsbNu+nLopplLxkcozpadAj7Ult/UlKLZvcu9CN6DYmIYY/1fih5hlyI5Ct8blZOxDRp0mm14tR9wIP2mS1GUehQtbtha8XcWkK6r5UZ/XPorXYBe9jvpRkCWX3NzFHuDKIV39/IlLK9zenckv3ndtvUTMzTTXB2KFYzlqPEgigVZw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(136003)(39860400002)(376002)(396003)(346002)(1800799003)(186006)(82310400008)(451199021)(46966006)(40470700004)(36840700001)(83380400001)(426003)(47076005)(36860700001)(2616005)(40460700003)(40480700001)(110136005)(54906003)(2906002)(4326008)(316002)(4744005)(5660300002)(8936002)(8676002)(44832011)(336012)(70206006)(70586007)(16526019)(82740400003)(478600001)(81166007)(7696005)(6666004)(86362001)(356005)(41300700001)(36756003)(1076003)(26005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2023 21:36:41.4578
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 088b31bc-3aad-4693-611b-08db978e6399
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00001509.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7599

This patch is a script providing region deletion-creation management
required during hotplug remove-insert. It allows a user to hotplug
remove and reinsert a CXL device without requiring the user to make
additional tool calls to destroy-create the region. The tool will save
the region configuration before removal and recreate the region later
after hotplug reinsert. The script makes the necessary calls to the cxl
cli and daxctl tools to manage the regions.

This may be useful to add to the ndctl tools as a standalone tool or
incoprorate into the existing CXL cli or daxctl tools. I'm interested in
feedback.

Terry Bowman (1):
  cxl: Script to manage regions during CXL device hotplug
    remove-reinsert

-- 
2.34.1


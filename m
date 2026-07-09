Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011067.outbound.protection.outlook.com [52.101.52.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F38EF2E06E4
	for <nvdimm@lists.linux.dev>; Thu,  9 Jul 2026 02:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783564154; cv=fail; b=PTmJBd5luMzZITmLXzJrl5ftQPl4m2I5qOoYljQeq0ei/2im6OetwGeij5kUEyrmAmj+tvxa274OS5i8dsDrw+ess4muh7gREscVjK1vdVNAaY1xauY/SfTkmgt34iLm4XE282iGupyWw5r87b3DJ00zvsdYHN6yhZyfrnUv+x4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783564154; c=relaxed/simple;
	bh=K142lqackjFrAftJmx4KpDAv/LSI+JPYasqRPGfNHNg=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=uP7pzF6TI3+JHbwmR3Ha0K2ZUdTAEXHHr9DkV7BY8qSzUo83U/zgP46YR0SKYDSxzEZFF1fNmi3/PnkZh5w/PmELhwBRzWUlOD/KXIN6RI3SNgKIxM2YBW/g+69Ph8TcPA/xxJqi65cj/bTpQVbvzPbbtu18OMG9cEwCXIujS7U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=TThCE1Mo; arc=fail smtp.client-ip=52.101.52.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="TThCE1Mo"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xBK354dEXpYqK8erOcZy4ufoCBAD5ijduzTBOhKQ7SOxfFU68FP+udmC/TXY42ejyoPAgyiQqrtyot3cQ+W+YUEJVK3Ch3V6ETuUS6Wqc1BC1+dqNivBHf4KddsckB933nSwjrLiJT+TqYlNdl7WN5kewSMBVpmP3Sfi06rThpE2ZxPHgWYWxhlH37dZRrnUsBRdScdTzQJqig4MUjZiNEwflCtw+s9/eqsOpv+GUhUOTDCzwR6eV+zO+9F4dlp2r5WtpwR1/Msiyjhj4aX7lgzp2h46hJM2QKnjt/hYcpimr5DwKW7M0K2n7FXvk5avoo2QUJqTFRCfIb2e2dru6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=chyBhfv3irpgrwb47KQqKobbe1fX88gAaiYmvJSig04=;
 b=JMMDZhBVVVbca9nUyyBMj1LwAy7oD1TqB0Pu7TLSmK0Z2HBycweiXhzIImusKD9EdGI3BCECuPvw2IwZI1qGJ/M7zS4V2QiJQ+aaq+rggvfG/5vxgkGByyUX8sQL4VJfknkkad02LKdvi780reyF1xyFlg+k/4wK+SyRrp5i/YyUXNZcmCSmcKHM78y5G9zPevibPqQyXi0LkMUedZgWltTfE7RK5BSxq1qlnRP1iweHwFUldyMoTOd285TmQi5pI90tECuA3Ebv7Y6emnvcOuB7HwsIuHFg+fm5njteksGQliw/bSIrj5rzieA5G7VWqnkY61Tvix+MrWzGJ7oTeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=chyBhfv3irpgrwb47KQqKobbe1fX88gAaiYmvJSig04=;
 b=TThCE1MoTi6rSa7wkIj+fVUg3mqL58s7t/XV3JRCE8NXgdsXAQGeTq8oOcoqUWF4XI4mSdo1mwufuNUwjgxbu3Jvh6/mgow6frFaiUJQhyVPoaAHyp5FQpgRWs1bOT+vBIxs4nSl8FznlelxMniUWSRks2Hcc2mW0ekCx4dKb5noc66zf3YeSKNsQIraPjW5ofj0MHPqWXXNOfC7DkE+HApl2NSNBBCnkY24bvEFMSf6BsQSa/OXUNA59TQo0h60G4SO2QalAxrxePVd1RP6ApkP8pImC3L+Gvz6rg3GOxlLGDSsrFrjEo+f1hoMKetWvYoQhWd5gi2cJJtzm5L3gw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB2370.namprd12.prod.outlook.com (2603:10b6:207:47::27)
 by DS5PPFDF2DDE6CD.namprd12.prod.outlook.com (2603:10b6:f:fc00::665) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.14; Thu, 9 Jul
 2026 02:29:06 +0000
Received: from BL0PR12MB2370.namprd12.prod.outlook.com
 ([fe80::86cf:c3ec:2cf5:74c8]) by BL0PR12MB2370.namprd12.prod.outlook.com
 ([fe80::86cf:c3ec:2cf5:74c8%5]) with mapi id 15.21.0181.014; Thu, 9 Jul 2026
 02:29:06 +0000
From: Richard Cheng <icheng@nvidia.com>
To: dave@stgolabs.net,
	jic23@kernel.org,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	vishal.l.verma@intel.com,
	djbw@kernel.org,
	danwilliams@nvidia.com
Cc: iweiny@kernel.org,
	ming.li@zohomail.com,
	kobak@nvidia.com,
	kaihengf@nvidia.com,
	linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	Richard Cheng <icheng@nvidia.com>
Subject: [ndctl PATCH] test/cxl-topology.sh: test zero-sized decoders
Date: Thu,  9 Jul 2026 10:28:57 +0800
Message-ID: <20260709022857.18732-1-icheng@nvidia.com>
X-Mailer: git-send-email 2.50.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TP0P295CA0041.TWNP295.PROD.OUTLOOK.COM (2603:1096:910:4::7)
 To BL0PR12MB2370.namprd12.prod.outlook.com (2603:10b6:207:47::27)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR12MB2370:EE_|DS5PPFDF2DDE6CD:EE_
X-MS-Office365-Filtering-Correlation-Id: f300493b-0b93-48e8-b721-08dedd61d94f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|23010399003|366016|1800799024|56012099006|11063799006|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	II86YrxIv6LLJtoMYUoaixE6MiS82wnhq7OfoSqVmSnrgNT3bjuZy4S8pbykG96tFdbLWP8BaSBmNQphP2ZaCJK6MGmrVurP3yw4G0oPkpkmWa1Dqr/cV0B2hsG2WSgRBZevQ7fdfwV8/JeRLMjgd9tHQLZJxn81HyQ4FxU57lczKtpIyAhSHQIAiNMQxlh2HSAdYUuRpeZfbLLlNXKu3PL0JzwrMGtJCnPe6ppqCUVhvM7xIQTm9ZDOjeS0wTpqvvAqmPhTkfJ9R3TpX3+Eh26tMvJbzidFFfIPKSn4Q8/FJEIAbLkunFkZ8lQmxaD9jginYsxmu+gzLmzkrujUH58+GowqLarwlekzgTleVL6ElfUzO+2wMlRopdAwowusPN0DYxMmoDkiklzruYIaGLHDqPNtj6JlSgb0MXeoGDsze0tZEL+cf+s2jVAo5m9RHdmMG2I3hD9CSNuegaOfUQswv0HsrcYUDRHTgVY63Ycaw3wuqq8c2Cv9Rl5baamlhcrxyaxvt8OydLnk2cxO8gIF0+MCp2yP288izu3r0RON5EIC9YUSPzLEeSlx4rQ+UQoNHkWuNvMurVR0oEO5G3cOpB9SjnHylnNUTtUSfc2dz1HwNIqnnXbQwbN5Vws9yiQYW3kMD1DpSfhWk7e3txn8sm01tfKHTckIIHxcqM0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB2370.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(366016)(1800799024)(56012099006)(11063799006)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?nUADXmmnfv4PSDrB8wC9G/6HIgJ2JMNWrQuAS0i6wQ5yGkyfgxbRVxztezSo?=
 =?us-ascii?Q?NXBs7RV0Q0cqKbFP4UFsUaxrZL3sftLJaABRbFu1U5uHra2MVzQIxEJo9q1i?=
 =?us-ascii?Q?rZsjkRmgaJU97USA4hwBnNv2HMeH3J9Vl3IuT2qRJvFmeXI4umA0Sa3Ww5WW?=
 =?us-ascii?Q?f7ROhBB0dOHkCJuSWZAQbG+l+ecddHzYf86tDIvsz8YI8vCe7MYa8tdrVY85?=
 =?us-ascii?Q?MXvoDwbWyV6R7r2E1tUaNiFxUWjdWRQ4BasfXWPlky4Pk1xojBoqmR4LDShe?=
 =?us-ascii?Q?UTGB3RbrLTn6bi9iOm+206PwnfZulSOLyPbywPSj55918kBuvCQmt66rWOC5?=
 =?us-ascii?Q?gjcBJjwk42Aqap+woi5h0my+jJcl6flebNZ3cqLLLjfGWZTLL2pzXDawnhib?=
 =?us-ascii?Q?3zJ28sCfYV9RMZeXQaGM8SrbZG/G+1LBaN5+INugBDEopDRiPBLLe5ohQfU8?=
 =?us-ascii?Q?WrHpNKq6XqVHYg6NQvmdTtZK5Q+wcudzn18SVwSz/5OAhVgZYuttjflYdeQ6?=
 =?us-ascii?Q?tyc1ZOywOaKVS+952fNzlUwZWBAbdRXAoTsd0dRA/i8iy517bdHtRNm85Vs+?=
 =?us-ascii?Q?7jSrMYd+qdvZBfNGgDClxSZkHSlKdLYLp0QqSijTiWC9NR+QcdGWiShjE36s?=
 =?us-ascii?Q?nERKBlhVxWBDj25LXWk4sgebZ8gU+zwqSiW15Ex8fEDUpT0OykorXsZCnyvg?=
 =?us-ascii?Q?tX0MXsF1grOvm7Fb2+es0zQmIRgHyTDQ8YmR66Fn0vZjlNLUTygK6QOWMKE7?=
 =?us-ascii?Q?91pjeZiPfGX1RiIlMQuUY0YnRssbmd1S8yrn+B+tXfB8wtHib7eTvrLJhx3t?=
 =?us-ascii?Q?6RUgf/vRG9Sto8Q/sMzTiVvV/TLP9e1vxMkV7A8EgyU/ogLzJTXl2s8ppcXU?=
 =?us-ascii?Q?EHF33JFQbswiADbH/n4W73U4V3JL5QpwUZRSi0LTL6jyid/BCXoC16ArjKcR?=
 =?us-ascii?Q?Vu9gOVj8dI0hz93Y8wFJTo+FPL5rohIpqO6HFywCyzJQy9Ed0LJKf8kouNOD?=
 =?us-ascii?Q?q1zi1KfWnnFK95IIASb05fO/w//15A9v1+MoPymvnUCKuLAljVtojJsz1Xnu?=
 =?us-ascii?Q?t8wk8PCkEiayWDOPAmIubGrBiwWMeqJln3McY6hTbgj1IbpTTTrYyXEtML6i?=
 =?us-ascii?Q?ACumUxnCPBPXfT0+ikgY1cgk7oZfITjLBoZsW0/EOZxFnZRrg3vvj4n2JPuQ?=
 =?us-ascii?Q?6mYgwYYFw2GDTDxvl/jk256yHYQGM77ZJQIBUPSE1D+mCNPDV9cm2WL6RgFH?=
 =?us-ascii?Q?Pg+UkiTb6ySFwwh6BKzxgviiFM4xipiW3BEs40IwGxxXsTHPbFILtnCeiEN0?=
 =?us-ascii?Q?xAhk2AsXawB4TOLPBpKncL5mqsV4bCe3JiRSNEoQtxfQ4s6+aWPd/KzjkckQ?=
 =?us-ascii?Q?uZeIyq7UcYp5Yx+bafMSVJ2bcgerRnqvNgoOEsweHdzVEaZxvnBcPBRyndzC?=
 =?us-ascii?Q?jNFr6FyXuw5eS65LvA0eqWvFguVZy55rc6Oht38uHopQ/vhKIPilsvh91RJW?=
 =?us-ascii?Q?PZRVGjMoUtlSF/jAB2+Rjkpj0BTOhQso4/k87PpsmjXlGFg4Gmbcliyv33e8?=
 =?us-ascii?Q?fsd4j4HVZ3locrKZAOBw5KHpAAxPVCyjOSYtRL/nqaYfpPFNpcZGoHVQGucb?=
 =?us-ascii?Q?TKo1mdQAUTyXv+Gp4nB+K6zA9I28JqdftVHGEs+71phbkBIsYDPbDkEnT7VM?=
 =?us-ascii?Q?mll0OfhJFZ1yKYznCYdCyYVKqhr4se6BS81+rX7PK7CtGZXcHbb3rE6X6iln?=
 =?us-ascii?Q?bME+z+8WGQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f300493b-0b93-48e8-b721-08dedd61d94f
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB2370.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2026 02:29:06.5924
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dtSDH21bR4i1CnfhKPiXqWLZUkNKm4RyEbw6KIKjU3SSS95Wu0SjMKguQVZy8Q8zWko00zl/4SJ28YEehoTJDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS5PPFDF2DDE6CD

The kernel series [1] teaches the CXL core to enumerate committed
zero-sized HDM decoders and adds the opt-in mock_zero_size_decoders
cxl_test topology. Since the param defaults off, the existing ndctl
suite never exercises that path, leaving the series without userspace
regression coverage.

After the existing default-topology checks, detect the module param with
modinfo. When available, reload cxl_test with mock_zero_size_decoders=1,
discover both endpoint decoders through the auto-region mapping, and
verify that decoder IDs 1 and 2 exist with size 0 and locked set.
Unsupported kernels retain the existing baseline coverage.

Tested on arm64. The focused test passed. The full CXL suite passed and 1
unrelated cxl-security skip. Four zero-sized endpoint decoders were
validated, cxl_test unloaded cleanly, and no relevant dmesg errors were
shown.

[1]:
https://lore.kernel.org/linux-cxl/20260708104024.68029-1-icheng@nvidia.com/
Signed-off-by: Richard Cheng <icheng@nvidia.com>
---
 test/cxl-topology.sh | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/test/cxl-topology.sh b/test/cxl-topology.sh
index 170c9ca..3345cd8 100644
--- a/test/cxl-topology.sh
+++ b/test/cxl-topology.sh
@@ -276,3 +276,35 @@ $CXL disable-bus $root -f
 check_dmesg "$LINENO"
 
 modprobe -r cxl_test
+
+if ! modinfo cxl_test | grep -q '^parm:.*mock_zero_size_decoders'; then
+	exit 0
+fi
+
+modprobe cxl_test mock_zero_size_decoders=1
+
+region_json=$("$CXL" list -b cxl_test -R -T -u)
+[ -n "$region_json" ] || err "$LINENO"
+mapfile -t endpoint_decoders < <(
+	jq -r '.mappings[]?.decoder // empty' <<<"$region_json"
+)
+((${#endpoint_decoders[@]} == 2)) || err "$LINENO"
+
+for decoder in "${endpoint_decoders[@]}"; do
+	[[ "$decoder" == *.0 ]] || err "$LINENO"
+
+	for id in 1 2; do
+		empty_decoder="${decoder%.*}.$id"
+		decoder_path="/sys/bus/cxl/devices/$empty_decoder"
+		[ -d "$decoder_path" ] || err "$LINENO"
+
+		size=$(cat "$decoder_path/size")
+		locked=$(cat "$decoder_path/locked")
+		((size == 0)) || err "$LINENO"
+		((locked == 1)) || err "$LINENO"
+	done
+done
+
+check_dmesg "$LINENO"
+
+modprobe -r cxl_test

base-commit: 15e932c4e1318a9608ad9b799ad83a32a8b5970d
prerequisite-patch-id: 96641092f7122fa9b6a894ab56f71c4d50c02650
-- 
2.43.0


Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2051.outbound.protection.outlook.com [40.107.244.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D13C663B3
	for <nvdimm@lists.linux.dev>; Wed, 30 Nov 2022 14:43:45 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XxuTDg4Iyfry+DaGVolcBQzEKQg7ONddxke1MhakaVJ/6QPs13n5Q/be6lEwgvZaUn+0uM8TkbzwKfVA4+c2ZOvPs+NJQ+sPEanNF0UqPfa289mPNrgjYmP/vgHaN8CP6KJIsVI7+V09yzbwD86MiRFGnBOi5Qx+P6fdN1MbRTF4pC/rIejRSXSTpQWAeEQoG78jBxxdzYaoNNhKW2eveoxW0RR0CXQjSgqgCXlcWqlWck42OagnFAj1+HQaPwN/lkFP/v2iIFQY7/itzA6mJmYrdM8T6dW6lLzPqWEEqm49Em83qaPelAO9j8LctRCZ3eNh6FBMxlcFd1PFADDPMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PqS1WpCCMYRbpBp1wNWQeVYLQZy2AAi/BUENKj7HQm0=;
 b=JarG8xxm4oaBX8CdYDYrVN5/TMtEMhA2+gs0o11Fw5UV3ZMCOIU+T9Uu4btfQWp8hlX/T8A8DRPDK7m//7RUxC1GTMJrKIJ/5QwNUXTUuXY0gCBj0548CPi/qY3Y8NAIvIPc6zS1YSNXA1kP3uuTt148f2ioJ9LcWKa4BzzURsq6bfHEB9hSVjGynnO58prIcMPBPEOW5YW3+5e4WgK6xiS951x8UChpnb4nfkj7bX41j0otoGcthw71kRqvbx2v9VnNaTjNe/XIOzCGFC4NgGeSpR821hwVfmjae+8vwH6SQnWwC7+1vrFi4+mEUWwFnJ9FdtbRfX0hUv/1nJPvGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PqS1WpCCMYRbpBp1wNWQeVYLQZy2AAi/BUENKj7HQm0=;
 b=M9t88PaTwHgtGqyzIrsR0iux7MH7tr6BKaq1zy4S056edh5b5cjvFm91i5UG7xzkeqAYiDnx9ZqGZ1K65fEwPKzGckbWbQXCbq009ICOj+W93IRuOc1TKIPw23vPfHRUD9BU6G9k+OPkCl9/mzsq15eEQWJu7stpIVetMAK0KN4=
Received: from MW3PR06CA0008.namprd06.prod.outlook.com (2603:10b6:303:2a::13)
 by CY8PR12MB7491.namprd12.prod.outlook.com (2603:10b6:930:92::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Wed, 30 Nov
 2022 14:43:42 +0000
Received: from CO1NAM11FT005.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:2a:cafe::d8) by MW3PR06CA0008.outlook.office365.com
 (2603:10b6:303:2a::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23 via Frontend
 Transport; Wed, 30 Nov 2022 14:43:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT005.mail.protection.outlook.com (10.13.174.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5857.20 via Frontend Transport; Wed, 30 Nov 2022 14:43:42 +0000
Received: from rric.localdomain (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 30 Nov
 2022 08:43:40 -0600
Date: Wed, 30 Nov 2022 15:43:37 +0100
From: Robert Richter <rrichter@amd.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, Terry Bowman <terry.bowman@amd.com>,
	<bhelgaas@google.com>, <dave.jiang@intel.com>, <nvdimm@lists.linux.dev>
Subject: Re: [PATCH v4 08/12] cxl/acpi: Extract component registers of
 restricted hosts from RCRB
Message-ID: <Y4dsGZ24aJlxSfI1@rric.localdomain>
References: <166931487492.2104015.15204324083515120776.stgit@dwillia2-xfh.jf.intel.com>
 <166931492162.2104015.17972281946627197765.stgit@dwillia2-xfh.jf.intel.com>
 <Y4TGabZ4iqtOyTf8@rric.localdomain>
 <63852f1fdfadc_3cbe02947b@dwillia2-xfh.jf.intel.com.notmuch>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <63852f1fdfadc_3cbe02947b@dwillia2-xfh.jf.intel.com.notmuch>
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT005:EE_|CY8PR12MB7491:EE_
X-MS-Office365-Filtering-Correlation-Id: 9ca2f1bc-7607-431f-80a4-08dad2e146f9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	OsW4SygzekUiebavRzH5yFvB28VDV8SyhB5vX6zeBNugZLC6qTGegqcfM0i0uK33lAcoBByv2hk4CRCtGOjnlR4m/VMy3QGeAkYIuk7Wy2E2VyvC7mI+fim6DqE0R/fD4L1uRLzr03NcjBiov0SrJR/0W5FEfeV4I5N9kHSSacfcJdzgyby8b8lQjGVZ7UNN9yx/1TP/qapzGXDAuerRpFkrM9CTiG112NlFsznmP+8fWcah4Y9xPmSGlKWzUb130i9WFFW4azX2dd0/bzbjknW2s9/gS0+5wnbfZZwzmqkpGihgik9/mYivNYIz/SkBo1tJbT43Bx5kEFs0QeK/bqTRaF5t14hhyONk4NdBHV8wGJgp4Eiwmlo8euIePYywIudxUOd0Gw89LtoMFEpBBlmJ9qlluj8xGlzP7Qn3ySb7eGdF87fgRjI3ytxAwY5K+TeMA13RKc+DXm9VWNoqC5ryLtTijecSyKkM1HXiUHsP1BmzMzYNkmFkaFbkGtFrxsemEumuNGvxxy0ik2jsugZ84TWXtjlpilyZTvW+93UHWqk7JIPHEzhV401zFROBqvryQruC94LgVJYbButY6DfvqCULsyc0q91xQM3ZTWI3NsvdeNIFYgMX4ioVoJWGlIZTSMjQpPZWCqNWMJ8n/J3ZkoAg0Fs8GGIRkR3REWQmvqGEFgiBRRKqk712tfJF3wKbMpt9p2DIOswjRY0NzjF/cyFiSm0wUonXZjkRGSY=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(346002)(136003)(39860400002)(376002)(396003)(451199015)(40470700004)(46966006)(36840700001)(5660300002)(55016003)(478600001)(8936002)(316002)(54906003)(47076005)(70586007)(40460700003)(40480700001)(6916009)(83380400001)(81166007)(8676002)(4326008)(82740400003)(356005)(16526019)(9686003)(186003)(82310400005)(426003)(7696005)(336012)(70206006)(6666004)(53546011)(26005)(2906002)(41300700001)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2022 14:43:42.5015
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ca2f1bc-7607-431f-80a4-08dad2e146f9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1NAM11FT005.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7491

On 28.11.22 13:58:55, Dan Williams wrote:
> Robert Richter wrote:
> > On 24.11.22 10:35:21, Dan Williams wrote:
> > > From: Robert Richter <rrichter@amd.com>

> > > @@ -228,27 +235,46 @@ static int add_host_bridge_uport(struct device *match, void *arg)
> > >  struct cxl_chbs_context {
> > >  	struct device *dev;
> > >  	unsigned long long uid;
> > > -	resource_size_t chbcr;
> > > +	struct acpi_cedt_chbs chbs;
> > >  };
> > >  
> > > -static int cxl_get_chbcr(union acpi_subtable_headers *header, void *arg,
> > > -			 const unsigned long end)
> > > +static int cxl_get_chbs(union acpi_subtable_headers *header, void *arg,
> > > +			const unsigned long end)
> > >  {
> > >  	struct cxl_chbs_context *ctx = arg;
> > >  	struct acpi_cedt_chbs *chbs;
> > >  
> > > -	if (ctx->chbcr)
> > > +	if (ctx->chbs.base)
> > >  		return 0;
> > >  
> > >  	chbs = (struct acpi_cedt_chbs *) header;
> > >  
> > >  	if (ctx->uid != chbs->uid)
> > >  		return 0;
> > > -	ctx->chbcr = chbs->base;
> > > +	ctx->chbs = *chbs;
> > >  
> > >  	return 0;
> > >  }
> > >  
> > > +static resource_size_t cxl_get_chbcr(struct cxl_chbs_context *ctx)
> > > +{
> > > +	struct acpi_cedt_chbs *chbs = &ctx->chbs;
> > > +
> > > +	if (!chbs->base)
> > > +		return CXL_RESOURCE_NONE;
> > > +
> > > +	if (chbs->cxl_version != ACPI_CEDT_CHBS_VERSION_CXL11)
> > > +		return chbs->base;
> > > +
> > > +	if (chbs->length != CXL_RCRB_SIZE)
> > > +		return CXL_RESOURCE_NONE;
> > > +
> > > +	dev_dbg(ctx->dev, "RCRB found for UID %lld: %pa\n", ctx->uid,
> > > +		&chbs->base);
> > > +
> > > +	return cxl_rcrb_to_component(ctx->dev, chbs->base, CXL_RCRB_DOWNSTREAM);
> > > +}
> > > +
> > 
> > I have an improved version of this code which squashes cxl_get_chbcr()
> > into cxl_get_chbs() (basically extends the original cxl_get_chbcr()
> > function).
> 
> Care to send it? If I see it before the next posting I can fold it in,
> otherwise it can be a follow-on cleanup.

Here comes the delta patch of that change. Since you probably reworked
this patch already I hope the changes will apply cleanly or with small
conflicts only.

-- >8 --

From 65a6e03e53f2298c46d3fe0c16150aa7d539cfca Mon Sep 17 00:00:00 2001
From: Robert Richter <rrichter@amd.com>
Date: Wed, 30 Nov 2022 14:39:08 +0100
Subject: [PATCH v5] delta

Signed-off-by: Robert Richter <rrichter@amd.com>
---
 drivers/cxl/acpi.c | 59 +++++++++++++++++++++++-----------------------
 1 file changed, 30 insertions(+), 29 deletions(-)

diff --git a/drivers/cxl/acpi.c b/drivers/cxl/acpi.c
index f13b702e9fd5..1eb564e697fb 100644
--- a/drivers/cxl/acpi.c
+++ b/drivers/cxl/acpi.c
@@ -233,46 +233,47 @@ static int add_host_bridge_uport(struct device *match, void *arg)
 }
 
 struct cxl_chbs_context {
-	struct device *dev;
-	unsigned long long uid;
-	struct acpi_cedt_chbs chbs;
+	struct device		*dev;
+	unsigned long long	uid;
+	resource_size_t		rcrb;
+	resource_size_t		chbcr;
+	u32			cxl_version;
 };
 
-static int cxl_get_chbs(union acpi_subtable_headers *header, void *arg,
-			const unsigned long end)
+static int cxl_get_chbcr(union acpi_subtable_headers *header, void *arg,
+			 const unsigned long end)
 {
 	struct cxl_chbs_context *ctx = arg;
 	struct acpi_cedt_chbs *chbs;
 
-	if (ctx->chbs.base)
+	if (ctx->chbcr)
 		return 0;
 
 	chbs = (struct acpi_cedt_chbs *) header;
 
 	if (ctx->uid != chbs->uid)
 		return 0;
-	ctx->chbs = *chbs;
-
-	return 0;
-}
 
-static resource_size_t cxl_get_chbcr(struct cxl_chbs_context *ctx)
-{
-	struct acpi_cedt_chbs *chbs = &ctx->chbs;
+	ctx->cxl_version = chbs->cxl_version;
+	ctx->rcrb = CXL_RESOURCE_NONE;
+	ctx->chbcr = CXL_RESOURCE_NONE;
 
 	if (!chbs->base)
-		return CXL_RESOURCE_NONE;
+		return 0;
 
-	if (chbs->cxl_version != ACPI_CEDT_CHBS_VERSION_CXL11)
-		return chbs->base;
+	if (chbs->cxl_version != ACPI_CEDT_CHBS_VERSION_CXL11) {
+		ctx->chbcr = chbs->base;
+		return 0;
+	}
 
 	if (chbs->length != CXL_RCRB_SIZE)
-		return CXL_RESOURCE_NONE;
+		return 0;
 
-	dev_dbg(ctx->dev, "RCRB found for UID %lld: %pa\n", ctx->uid,
-		&chbs->base);
+	ctx->rcrb = chbs->base;
+	ctx->chbcr = cxl_rcrb_to_component(ctx->dev, chbs->base,
+					   CXL_RCRB_DOWNSTREAM);
 
-	return cxl_rcrb_to_component(ctx->dev, chbs->base, CXL_RCRB_DOWNSTREAM);
+	return 0;
 }
 
 static int add_host_bridge_dport(struct device *match, void *arg)
@@ -284,7 +285,6 @@ static int add_host_bridge_dport(struct device *match, void *arg)
 	struct cxl_chbs_context ctx;
 	struct acpi_pci_root *pci_root;
 	struct cxl_port *root_port = arg;
-	resource_size_t component_reg_phys;
 	struct device *host = root_port->dev.parent;
 	struct acpi_device *hb = to_cxl_host_bridge(host, match);
 
@@ -304,25 +304,26 @@ static int add_host_bridge_dport(struct device *match, void *arg)
 		.dev = match,
 		.uid = uid,
 	};
-	acpi_table_parse_cedt(ACPI_CEDT_TYPE_CHBS, cxl_get_chbs, &ctx);
+	acpi_table_parse_cedt(ACPI_CEDT_TYPE_CHBS, cxl_get_chbcr, &ctx);
+
+	if (ctx.rcrb != CXL_RESOURCE_NONE)
+		dev_dbg(match, "RCRB found for UID %lld: %pa\n", uid, &ctx.rcrb);
 
-	component_reg_phys = cxl_get_chbcr(&ctx);
-	if (component_reg_phys == CXL_RESOURCE_NONE) {
+	if (ctx.chbcr == CXL_RESOURCE_NONE) {
 		dev_warn(match, "No CHBS found for Host Bridge (UID %lld)\n", uid);
 		return 0;
 	}
 
-	dev_dbg(match, "CHBCR found: %pa\n", &component_reg_phys);
+	dev_dbg(match, "CHBCR found: %pa\n", &ctx.chbcr);
 
 	pci_root = acpi_pci_find_root(hb->handle);
 	bridge = pci_root->bus->bridge;
-	if (ctx.chbs.cxl_version == ACPI_CEDT_CHBS_VERSION_CXL11)
+	if (ctx.cxl_version == ACPI_CEDT_CHBS_VERSION_CXL11)
 		dport = devm_cxl_add_rch_dport(root_port, bridge, uid,
-					       component_reg_phys,
-					       ctx.chbs.base);
+					       ctx.chbcr, ctx.rcrb);
 	else
 		dport = devm_cxl_add_dport(root_port, bridge, uid,
-					   component_reg_phys);
+					   ctx.chbcr);
 	if (IS_ERR(dport))
 		return PTR_ERR(dport);
 
-- 
2.30.2

